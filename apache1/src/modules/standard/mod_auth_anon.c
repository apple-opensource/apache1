/* Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/*
 * http_auth: authentication
 * 
 * Rob McCool & Brian Behlendorf.
 * 
 * Adapted to Apache by rst.
 *
 * Version 0.5 May 1996
 *
 * Modified by Dirk.vanGulik@jrc.it to
 * 
 * Adapted to allow anonymous logins, just like with Anon-FTP, when
 * one gives the magic user name 'anonymous' and ones email address
 * as the password.
 *
 * Just add the following tokes to your <directory> setup:
 * 
 * Anonymous                    magic-user-id [magic-user-id]...
 *
 * Anonymous_MustGiveEmail      [ on | off ] default = on
 * Anonymous_LogEmail           [ on | off ] default = on
 * Anonymous_VerifyEmail        [ on | off ] default = off
 * Anonymous_NoUserId           [ on | off ] default = off
 * Anonymous_Authoritative      [ on | off ] default = off
 *
 * The magic user id is something like 'anonymous', it is NOT case sensitive. 
 * 
 * The MustGiveEmail flag can be used to force users to enter something
 * in the password field (like an email address). Default is on.
 *
 * Furthermore the 'NoUserID' flag can be set to allow completely empty
 * usernames in as well; this can be is convenient as a single return
 * in broken GUIs like W95 is often given by the user. The Default is off.
 *
 * Dirk.vanGulik@jrc.it; http://ewse.ceo.org; http://me-www.jrc.it/~dirkx
 * 
 */

#include "httpd.h"
#include "http_config.h"
#include "http_core.h"
#include "http_log.h"
#include "http_protocol.h"
#include "http_request.h"

typedef struct auth_anon {
    char *password;
    struct auth_anon *next;
} auth_anon;

typedef struct {

    auth_anon *auth_anon_passwords;
    int auth_anon_nouserid;
    int auth_anon_logemail;
    int auth_anon_verifyemail;
    int auth_anon_mustemail;
    int auth_anon_authoritative;

} anon_auth_config_rec;

static void *create_anon_auth_dir_config(pool *p, char *d)
{
    anon_auth_config_rec *sec = (anon_auth_config_rec *)
    ap_pcalloc(p, sizeof(anon_auth_config_rec));

    if (!sec)
	return NULL;		/* no memory... */

    /* just to illustrate the defaults really. */
    sec->auth_anon_passwords = NULL;

    sec->auth_anon_nouserid = 0;
    sec->auth_anon_logemail = 1;
    sec->auth_anon_verifyemail = 0;
    sec->auth_anon_mustemail = 1;
    sec->auth_anon_authoritative = 0;
    return sec;
}

static const char *anon_set_passwd_flag(cmd_parms *cmd,
				 anon_auth_config_rec * sec, int arg)
{
    sec->auth_anon_mustemail = arg;
    return NULL;
}

static const char *anon_set_userid_flag(cmd_parms *cmd,
				 anon_auth_config_rec * sec, int arg)
{
    sec->auth_anon_nouserid = arg;
    return NULL;
}
static const char *anon_set_logemail_flag(cmd_parms *cmd,
				   anon_auth_config_rec * sec, int arg)
{
    sec->auth_anon_logemail = arg;
    return NULL;
}
static const char *anon_set_verifyemail_flag(cmd_parms *cmd,
				      anon_auth_config_rec * sec, int arg)
{
    sec->auth_anon_verifyemail = arg;
    return NULL;
}
static const char *anon_set_authoritative_flag(cmd_parms *cmd,
					anon_auth_config_rec * sec, int arg)
{
    sec->auth_anon_authoritative = arg;
    return NULL;
}

static const char *anon_set_string_slots(cmd_parms *cmd,
				  anon_auth_config_rec * sec, char *arg)
{

    auth_anon *first;

    if (!(*arg))
	return "Anonymous string cannot be empty, use Anonymous_NoUserId instead";

    /* squeeze in a record */
    first = sec->auth_anon_passwords;

    if (
	   (!(sec->auth_anon_passwords = (auth_anon *) ap_palloc(cmd->pool, sizeof(auth_anon)))) ||
           (!(sec->auth_anon_passwords->password = arg))
    )
	     return "Failed to claim memory for an anonymous password...";

    /* and repair the next */
    sec->auth_anon_passwords->next = first;

    return NULL;
}

static const command_rec anon_auth_cmds[] =
{
    {"Anonymous", anon_set_string_slots, NULL, OR_AUTHCFG, ITERATE,
     "a space-separated list of user IDs"},
    {"Anonymous_MustGiveEmail", anon_set_passwd_flag, NULL, OR_AUTHCFG, FLAG,
     "Limited to 'on' or 'off'"},
    {"Anonymous_NoUserId", anon_set_userid_flag, NULL, OR_AUTHCFG, FLAG,
     "Limited to 'on' or 'off'"},
{"Anonymous_VerifyEmail", anon_set_verifyemail_flag, NULL, OR_AUTHCFG, FLAG,
 "Limited to 'on' or 'off'"},
    {"Anonymous_LogEmail", anon_set_logemail_flag, NULL, OR_AUTHCFG, FLAG,
     "Limited to 'on' or 'off'"},
    {"Anonymous_Authoritative", anon_set_authoritative_flag, NULL, OR_AUTHCFG, FLAG,
     "Limited to 'on' or 'off'"},

    {NULL}
};

module MODULE_VAR_EXPORT anon_auth_module;

static int anon_authenticate_basic_user(request_rec *r)
{
    anon_auth_config_rec *sec =
    (anon_auth_config_rec *) ap_get_module_config(r->per_dir_config,
					       &anon_auth_module);
    conn_rec *c = r->connection;
    const char *sent_pw;
    int res = DECLINED;

    if ((res = ap_get_basic_auth_pw(r, &sent_pw)))
	return res;

    /* Ignore if we are not configured */
    if (!sec->auth_anon_passwords)
	return DECLINED;

    /* Do we allow an empty userID and/or is it the magic one
     */

    if ((!(c->user[0])) && (sec->auth_anon_nouserid)) {
	res = OK;
    }
    else {
	auth_anon *p = sec->auth_anon_passwords;
	res = DECLINED;
	while ((res == DECLINED) && (p != NULL)) {
	    if (!(strcasecmp(c->user, p->password)))
		res = OK;
	    p = p->next;
	}
    }
    if (
    /* username is OK */
	   (res == OK)
    /* password been filled out ? */
	   && ((!sec->auth_anon_mustemail) || strlen(sent_pw))
    /* does the password look like an email address ? */
	   && ((!sec->auth_anon_verifyemail)
	       || ((strpbrk("@", sent_pw) != NULL)
		   && (strpbrk(".", sent_pw) != NULL)))) {
	if (sec->auth_anon_logemail && ap_is_initial_req(r)) {
	    ap_log_rerror(APLOG_MARK, APLOG_NOERRNO|APLOG_INFO, r,
			"Anonymous: Passwd <%s> Accepted",
			sent_pw ? sent_pw : "\'none\'");
	}
	return OK;
    }
    else {
	if (sec->auth_anon_authoritative) {
	    ap_log_rerror(APLOG_MARK, APLOG_NOERRNO|APLOG_ERR, r,
			"Anonymous: Authoritative, Passwd <%s> not accepted",
			sent_pw ? sent_pw : "\'none\'");
	    return AUTH_REQUIRED;
	}
	/* Drop out the bottom to return DECLINED */
    }

    return DECLINED;
}

static int check_anon_access(request_rec *r)
{
#ifdef NOTYET
    conn_rec *c = r->connection;
    anon_auth_config_rec *sec =
    (anon_auth_config_rec *) ap_get_module_config(r->per_dir_config,
					       &anon_auth_module);

    if (!sec->auth_anon)
	return DECLINED;

    if (strcasecmp(r->connection->user, sec->auth_anon))
	return DECLINED;

    return OK;
#endif
    return DECLINED;
}


module MODULE_VAR_EXPORT anon_auth_module =
{
    STANDARD_MODULE_STUFF,
    NULL,			/* initializer */
    create_anon_auth_dir_config,	/* dir config creater */
    NULL,			/* dir merger ensure strictness */
    NULL,			/* server config */
    NULL,			/* merge server config */
    anon_auth_cmds,		/* command table */
    NULL,			/* handlers */
    NULL,			/* filename translation */
    anon_authenticate_basic_user,	/* check_user_id */
    check_anon_access,		/* check auth */
    NULL,			/* check access */
    NULL,			/* type_checker */
    NULL,			/* fixups */
    NULL,			/* logger */
    NULL,			/* header parser */
    NULL,			/* child_init */
    NULL,			/* child_exit */
    NULL			/* post read-request */
};
