# Microsoft Developer Studio Generated NMAKE File, Based on mod_mime_magic.dsp
!IF "$(CFG)" == ""
CFG=mod_mime_magic - Win32 Release
!MESSAGE No configuration specified. Defaulting to mod_mime_magic - Win32 Release.
!ENDIF 

!IF "$(CFG)" != "mod_mime_magic - Win32 Release" && "$(CFG)" != "mod_mime_magic - Win32 Debug"
!MESSAGE Invalid configuration "$(CFG)" specified.
!MESSAGE You can specify a configuration when running NMAKE
!MESSAGE by defining the macro CFG on the command line. For example:
!MESSAGE 
!MESSAGE NMAKE /f "mod_mime_magic.mak" CFG="mod_mime_magic - Win32 Release"
!MESSAGE 
!MESSAGE Possible choices for configuration are:
!MESSAGE 
!MESSAGE "mod_mime_magic - Win32 Release" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE "mod_mime_magic - Win32 Debug" (based on "Win32 (x86) Dynamic-Link Library")
!MESSAGE 
!ERROR An invalid configuration is specified.
!ENDIF 

!IF "$(OS)" == "Windows_NT"
NULL=
!ELSE 
NULL=nul
!ENDIF 

!IF  "$(CFG)" == "mod_mime_magic - Win32 Release"

OUTDIR=.\Release
INTDIR=.\Release
# Begin Custom Macros
OutDir=.\Release
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\mod_mime_magic.so"

!ELSE 

ALL : "ApacheCore - Win32 Release" "$(OUTDIR)\mod_mime_magic.so"

!ENDIF 

!IF "$(RECURSE)" == "1" 
CLEAN :"ApacheCore - Win32 ReleaseCLEAN" 
!ELSE 
CLEAN :
!ENDIF 
	-@erase "$(INTDIR)\mod_mime_magic.obj"
	-@erase "$(INTDIR)\mod_mime_magic_src.idb"
	-@erase "$(INTDIR)\mod_mime_magic_src.pdb"
	-@erase "$(OUTDIR)\mod_mime_magic.exp"
	-@erase "$(OUTDIR)\mod_mime_magic.lib"
	-@erase "$(OUTDIR)\mod_mime_magic.pdb"
	-@erase "$(OUTDIR)\mod_mime_magic.so"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MD /W3 /Zi /O2 /Oy- /I "..\..\include" /I "..\..\os\win32" /D "NDEBUG" /D "WIN32" /D "_WINDOWS" /D "SHARED_MODULE" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\mod_mime_magic_src" /FD /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "NDEBUG" /mktyplib203 /win32 
RSC=rc.exe
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\mod_mime_magic.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib /nologo /subsystem:windows /dll /incremental:no /pdb:"$(OUTDIR)\mod_mime_magic.pdb" /debug /machine:I386 /out:"$(OUTDIR)\mod_mime_magic.so" /implib:"$(OUTDIR)\mod_mime_magic.lib" /base:@"BaseAddr.ref",mod_mime_magic /opt:ref 
LINK32_OBJS= \
	"$(INTDIR)\mod_mime_magic.obj" \
	"..\..\Release\ApacheCore.lib"

"$(OUTDIR)\mod_mime_magic.so" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ELSEIF  "$(CFG)" == "mod_mime_magic - Win32 Debug"

OUTDIR=.\Debug
INTDIR=.\Debug
# Begin Custom Macros
OutDir=.\Debug
# End Custom Macros

!IF "$(RECURSE)" == "0" 

ALL : "$(OUTDIR)\mod_mime_magic.so"

!ELSE 

ALL : "ApacheCore - Win32 Debug" "$(OUTDIR)\mod_mime_magic.so"

!ENDIF 

!IF "$(RECURSE)" == "1" 
CLEAN :"ApacheCore - Win32 DebugCLEAN" 
!ELSE 
CLEAN :
!ENDIF 
	-@erase "$(INTDIR)\mod_mime_magic.obj"
	-@erase "$(INTDIR)\mod_mime_magic_src.idb"
	-@erase "$(INTDIR)\mod_mime_magic_src.pdb"
	-@erase "$(OUTDIR)\mod_mime_magic.exp"
	-@erase "$(OUTDIR)\mod_mime_magic.lib"
	-@erase "$(OUTDIR)\mod_mime_magic.pdb"
	-@erase "$(OUTDIR)\mod_mime_magic.so"

"$(OUTDIR)" :
    if not exist "$(OUTDIR)/$(NULL)" mkdir "$(OUTDIR)"

CPP=cl.exe
CPP_PROJ=/nologo /MDd /W3 /GX /Zi /Od /I "..\..\include" /I "..\..\os\win32" /D "_DEBUG" /D "WIN32" /D "_WINDOWS" /D "SHARED_MODULE" /Fo"$(INTDIR)\\" /Fd"$(INTDIR)\mod_mime_magic_src" /FD /c 

.c{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.obj::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.c{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cpp{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

.cxx{$(INTDIR)}.sbr::
   $(CPP) @<<
   $(CPP_PROJ) $< 
<<

MTL=midl.exe
MTL_PROJ=/nologo /D "_DEBUG" /mktyplib203 /win32 
RSC=rc.exe
BSC32=bscmake.exe
BSC32_FLAGS=/nologo /o"$(OUTDIR)\mod_mime_magic.bsc" 
BSC32_SBRS= \
	
LINK32=link.exe
LINK32_FLAGS=kernel32.lib /nologo /subsystem:windows /dll /incremental:no /pdb:"$(OUTDIR)\mod_mime_magic.pdb" /debug /machine:I386 /out:"$(OUTDIR)\mod_mime_magic.so" /implib:"$(OUTDIR)\mod_mime_magic.lib" /base:@"BaseAddr.ref",mod_mime_magic 
LINK32_OBJS= \
	"$(INTDIR)\mod_mime_magic.obj" \
	"..\..\Debug\ApacheCore.lib"

"$(OUTDIR)\mod_mime_magic.so" : "$(OUTDIR)" $(DEF_FILE) $(LINK32_OBJS)
    $(LINK32) @<<
  $(LINK32_FLAGS) $(LINK32_OBJS)
<<

!ENDIF 


!IF "$(NO_EXTERNAL_DEPS)" != "1"
!IF EXISTS("mod_mime_magic.dep")
!INCLUDE "mod_mime_magic.dep"
!ELSE 
!MESSAGE Warning: cannot find "mod_mime_magic.dep"
!ENDIF 
!ENDIF 


!IF "$(CFG)" == "mod_mime_magic - Win32 Release" || "$(CFG)" == "mod_mime_magic - Win32 Debug"

!IF  "$(CFG)" == "mod_mime_magic - Win32 Release"

"ApacheCore - Win32 Release" : 
   cd ".\..\.."
   $(MAKE) /$(MAKEFLAGS) /F ".\ApacheCore.mak" CFG="ApacheCore - Win32 Release" 
   cd ".\os\win32"

"ApacheCore - Win32 ReleaseCLEAN" : 
   cd ".\..\.."
   $(MAKE) /$(MAKEFLAGS) /F ".\ApacheCore.mak" CFG="ApacheCore - Win32 Release" RECURSE=1 CLEAN 
   cd ".\os\win32"

!ELSEIF  "$(CFG)" == "mod_mime_magic - Win32 Debug"

"ApacheCore - Win32 Debug" : 
   cd ".\..\.."
   $(MAKE) /$(MAKEFLAGS) /F ".\ApacheCore.mak" CFG="ApacheCore - Win32 Debug" 
   cd ".\os\win32"

"ApacheCore - Win32 DebugCLEAN" : 
   cd ".\..\.."
   $(MAKE) /$(MAKEFLAGS) /F ".\ApacheCore.mak" CFG="ApacheCore - Win32 Debug" RECURSE=1 CLEAN 
   cd ".\os\win32"

!ENDIF 

SOURCE=..\..\modules\standard\mod_mime_magic.c

"$(INTDIR)\mod_mime_magic.obj" : $(SOURCE) "$(INTDIR)"
	$(CPP) $(CPP_PROJ) $(SOURCE)



!ENDIF 

