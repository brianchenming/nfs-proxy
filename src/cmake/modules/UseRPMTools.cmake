#
# - Find tools needed for building RPM Packages
#   on Linux systems and defines macro that helps to
#   build source or binary RPM, the MACRO assumes
#   CMake 2.4.x which includes CPack support.
#   CPack is used to build tar.gz source tarball
#   which may be used by a custom user-made spec file.
#
# - Define RPMTools_ADD_RPM_TARGETS which defines
#   two (top-level) CUSTOM targets for building
#   source and binary RPMs
#
# Those CMake macros are provided by the TSP Developer Team
# https://savannah.nongnu.org/projects/tsp
#

# Look for RPM builder executable
FIND_PROGRAM(RPMTools_RPMBUILD_EXECUTABLE 
    NAMES rpmbuild
    PATHS "/usr/bin;/usr/lib/rpm"
    PATH_SUFFIXES bin
    DOC "The RPM builder tool")
  
IF (RPMTools_RPMBUILD_EXECUTABLE)
    MESSAGE(STATUS "Looking for RPMTools... - found rpmuild is ${RPMTools_RPMBUILD_EXECUTABLE}")
    SET(RPMTools_RPMBUILD_FOUND "YES")
    GET_FILENAME_COMPONENT(RPMTools_BINARY_DIRS ${RPMTools_RPMBUILD_EXECUTABLE} PATH)
ELSE (RPMTools_RPMBUILD_EXECUTABLE) 
    SET(RPMTools_RPMBUILD_FOUND "NO")
    MESSAGE(STATUS "Looking for RPMTools... - rpmbuild NOT FOUND")
ENDIF (RPMTools_RPMBUILD_EXECUTABLE) 
  
# Detect if CPack was included or not
IF (NOT DEFINED "CPACK_PACKAGE_NAME") 
    MESSAGE(FATAL_ERROR "CPack was not included, you should include CPack before Using RPMTools")
ENDIF (NOT DEFINED "CPACK_PACKAGE_NAME")

IF (RPMTools_RPMBUILD_FOUND)
    SET(RPMTools_FOUND TRUE)    
    #
    # - first arg  (ARGV0) is RPM name
    #
    MACRO(RPMTools_ADD_RPM_TARGETS RPMNAME)

      #
      # If no spec file is provided create a minimal one
      #
      IF ("${ARGV1}" STREQUAL "")
	SET(SPECFILE_PATH "${CMAKE_BINARY_DIR}/${RPMNAME}.spec")
      ELSE ("${ARGV1}" STREQUAL "")
	SET(SPECFILE_PATH "${ARGV1}")
      ENDIF("${ARGV1}" STREQUAL "")
      
      # Prepare RPM build tree
      SET(RPM_ROOTDIR ${CMAKE_BINARY_DIR}/RPM)
      FILE(MAKE_DIRECTORY ${RPM_ROOTDIR})
      FILE(MAKE_DIRECTORY ${RPM_ROOTDIR}/tmp)
      FILE(MAKE_DIRECTORY ${RPM_ROOTDIR}/BUILD)
      FILE(MAKE_DIRECTORY ${RPM_ROOTDIR}/RPMS)
      FILE(MAKE_DIRECTORY ${RPM_ROOTDIR}/SOURCES)
      FILE(MAKE_DIRECTORY ${RPM_ROOTDIR}/SPECS)
      FILE(MAKE_DIRECTORY ${RPM_ROOTDIR}/SRPMS)

   # rpmbuid.cmake, which defines rpmbuidl cmake's build type is defined on the fly to reflect the state of cmake's cache
   # if not, this cache is lost at the time the *-Source/tar/gz is generated. 
   SET(RPMBULILD_CMAKE ${RPM_ROOTDIR}/BUILD/${RPM_NAME}-${PACKAGE_VERSION}-Source/cmake/build_configurations/rpmbuild.cmake )
   FILE( WRITE ${RPMBULILD_CMAKE}  "set(_HANDLE_MAPPING ON)
" )
   FILE( APPEND ${RPMBULILD_CMAKE} "set(_NO_XATTRD  OFF)
" )
   FILE( APPEND ${RPMBULILD_CMAKE} "set(USE_DBUS ON)
" )
   FILE( APPEND ${RPMBULILD_CMAKE} "set(USE_DBUS_STATS ON)
" )

IF( USE_FSAL_VFS )
   FILE(APPEND ${RPMBULILD_CMAKE} "set(USE_FSAL_VFS ON)
	" ) 
ELSE(  USE_FSAL_VFS )
   FILE(APPEND ${RPMBULILD_CMAKE} "set(USE_FSAL_VFS OFF)
" ) 
ENDIF( USE_FSAL_VFS )

IF( USE_FSAL_CEPH )
   FILE(APPEND ${RPMBULILD_CMAKE} "set(USE_FSAL_CEPH ON)
" ) 
ELSE(  USE_FSAL_CEPH )
   FILE(APPEND ${RPMBULILD_CMAKE} "set(USE_FSAL_CEPH OFF)
" ) 
ENDIF( USE_FSAL_CEPH )

IF( USE_FSAL_FUSE )
   FILE(APPEND ${RPMBULILD_CMAKE} "set(USE_FSAL_FUSE ON)
" ) 
ELSE(  USE_FSAL_FUSE )
   FILE(APPEND ${RPMBULILD_CMAKE} "set(USE_FSAL_FUSE OFF)
" ) 
ENDIF( USE_FSAL_FUSE )

IF( USE_FSAL_GPFS )
   FILE(APPEND ${RPMBULILD_CMAKE} "set(USE_FSAL_GPFS ON)
	" ) 
ELSE(  USE_FSAL_GPFS )
   FILE(APPEND ${RPMBULILD_CMAKE} "set(USE_FSAL_GPFS OFF)
" ) 
ENDIF( USE_FSAL_GPFS )

IF( USE_FSAL_HPSS )
   FILE(APPEND ${RPMBULILD_CMAKE} "set(USE_FSAL_HPSS ON)
" ) 
ELSE(  USE_FSAL_HPSS )
   FILE(APPEND ${RPMBULILD_CMAKE} "set(USE_FSAL_HPSS OFF)
" ) 
ENDIF( USE_FSAL_HPSS )

IF( USE_FSAL_LUSTRE )
   FILE(APPEND ${RPMBULILD_CMAKE} "set(USE_FSAL_LUSTRE ON)
" ) 
ELSE(  USE_FSAL_LUSTRE )
   FILE(APPEND ${RPMBULILD_CMAKE} "set(USE_FSAL_LUSTRE OFF)
" ) 
ENDIF( USE_FSAL_LUSTRE )

IF( USE_FSAL_POSIX )
   FILE(APPEND ${RPMBULILD_CMAKE} "set(USE_FSAL_POSIX ON)
" ) 
ELSE(  USE_FSAL_POSIX )
   FILE(APPEND ${RPMBULILD_CMAKE} "set(USE_FSAL_POSIX OFF)
" ) 
ENDIF( USE_FSAL_POSIX )

IF( USE_FSAL_PROXY )
   FILE(APPEND ${RPMBULILD_CMAKE} "set(USE_FSAL_PROXY ON)
" ) 
ELSE(  USE_FSAL_PROXY )
   FILE(APPEND ${RPMBULILD_CMAKE} "set(USE_FSAL_PROXY OFF)
" ) 
ENDIF( USE_FSAL_PROXY )

IF( USE_FSAL_SHOOK )
   FILE(APPEND ${RPMBULILD_CMAKE} "set(USE_FSAL_SHOOK ON)
" ) 
ELSE(  USE_FSAL_SHOOK )
   FILE(APPEND ${RPMBULILD_CMAKE} "set(USE_FSAL_SHOOK OFF)
" ) 
ENDIF( USE_FSAL_SHOOK )

IF( USE_FSAL_XFS )
   FILE(APPEND ${RPMBULILD_CMAKE} "set(USE_FSAL_XFS ON)
" ) 
ELSE(  USE_FSAL_XFS )
   FILE(APPEND ${RPMBULILD_CMAKE} "set(USE_FSAL_XFS OFF)
" ) 
ENDIF( USE_FSAL_XFS )

IF( USE_FSAL_ZFS )
   FILE(APPEND ${RPMBULILD_CMAKE} "set(USE_FSAL_ZFS ON)
" ) 
ELSE( USE_FSAL_ZFS )
   FILE(APPEND ${RPMBULILD_CMAKE} "set(USE_FSAL_ZFS OFF)
" ) 
ENDIF( USE_FSAL_ZFS )
FILE(APPEND ${RPMBULILD_CMAKE} "set(DISTNAME_HAS_GIT_DATA ON)
")


      # Read RPM changelog and store the result into a variable
      FILE( READ "${RPM_CHANGELOG_FILE}" RPM_CHANGELOG_FILE_CONTENT )

      SET(SPECFILE_PATH "${RPM_ROOTDIR}/SPECS/${RPMNAME}.spec")
      SET(SPECFILE_NAME "${RPMNAME}.spec")
      FILE(WRITE ${RPM_ROOTDIR}/SPECS/${RPMNAME}.spec
	  "# -*- rpm-spec -*-
Summary:        ${RPM_SUMMARY}
Name:           ${RPMNAME}
Version:        ${PACKAGE_VERSION}
Release:        ${RPM_RELEASE}
License:        ${RPM_PACKAGE_LICENSE}
Group:          ${RPM_PACKAGE_GROUP}
Source:         ${CPACK_SOURCE_PACKAGE_FILE_NAME}.tar.gz
BuildRequires:	cmake
Url:            ${RPM_URL}
BuildRoot:      %{_tmppath}/%{name}-%{version}-%{release}-root-%(%{__id_u} -n)


#%define srcdirname %{name}-%{version}-Source
%define srcdirname %{name}${PACKNAME}-%{version}-Source

%description
${RPMNAME} : ${RPM_DESCRIPTION}

%package mount-9P
Summary: a 9p mount helper
Group: Applications/System

%description mount-9P
This package contains the mount.9P script
This is a 9p mount help

 ")

# if needed deal with FSAL modules
if(USE_FSAL_CEPH)
FILE(APPEND ${RPM_ROOTDIR}/SPECS/${RPMNAME}.spec  "
%package ceph
Summary: The NFS-GANESHA's CEPH FSAL
Group: Applications/System

%description ceph
This package contains a FSAL shared object to 
be used with NFS-Ganesha to suppport CEPH
")
endif(USE_FSAL_CEPH)

if(USE_FSAL_LUSTRE)
FILE(APPEND ${RPM_ROOTDIR}/SPECS/${RPMNAME}.spec  "
%package lustre
Summary: The NFS-GANESHA's LUSTRE FSAL
Group: Applications/System
BuildRequires: libattr-devel lustre-client

%description lustre
This package contains a FSAL shared object to 
be used with NFS-Ganesha to suppport LUSTRE
")
endif(USE_FSAL_LUSTRE)

if(USE_FSAL_POSIX)
FILE(APPEND ${RPM_ROOTDIR}/SPECS/${RPMNAME}.spec  "
%package posix
Summary: The NFS-GANESHA's LUSTRE FSAL
Group: Applications/System
BuildRequires: libattr-devel

%description posix
This package contains a FSAL shared object to 
be used with NFS-Ganesha to suppport POSIX
")
endif(USE_FSAL_POSIX)

if(USE_FSAL_SHOOK)
FILE(APPEND ${RPM_ROOTDIR}/SPECS/${RPMNAME}.spec  "
%package shook
Summary: The NFS-GANESHA's LUSTRE/SHOOK FSAL
Group: Applications/System
BuildRequires: libattr-devel lustre-client shook-devel

%description shook
This package contains a FSAL shared object to 
be used with NFS-Ganesha to suppport LUSTRE
")
endif(USE_FSAL_SHOOK)

if(USE_FSAL_VFS)
FILE(APPEND ${RPM_ROOTDIR}/SPECS/${RPMNAME}.spec  "
%package vfs
Summary: The NFS-GANESHA's VFS FSAL
Group: Applications/System
BuildRequires: libattr-devel


%description vfs
This package contains a FSAL shared object to 
be used with NFS-Ganesha to suppport VFS based filesystems
")
endif(USE_FSAL_VFS)

if(USE_FSAL_PROXY)
FILE(APPEND ${RPM_ROOTDIR}/SPECS/${RPMNAME}.spec  "
%package proxy
Summary: The NFS-GANESHA's VFS FSAL
Group: Applications/System
BuildRequires: libattr-devel


%description proxy
This package contains a FSAL shared object to 
be used with NFS-Ganesha to suppport PROXY based filesystems
")
endif(USE_FSAL_PROXY)

if(USE_FSAL_HPSS)
FILE(APPEND ${RPM_ROOTDIR}/SPECS/${RPMNAME}.spec  "
%package hpss
Summary: The NFS-GANESHA's HPSS FSAL
Group: Applications/System

%description hpss
This package contains a FSAL shared object to 
be used with NFS-Ganesha to suppport HPSS 
")
endif(USE_FSAL_HPSS)

if(USE_FSAL_ZFS)
FILE(APPEND ${RPM_ROOTDIR}/SPECS/${RPMNAME}.spec  "
%package zfs
Summary: The NFS-GANESHA's ZFS FSAL
Group: Applications/System
BuildRequires: libzfswrap-devel

%description zfs
This package contains a FSAL shared object to 
be used with NFS-Ganesha to suppport ZFS 
")
endif(USE_FSAL_ZFS)

FILE(APPEND ${RPM_ROOTDIR}/SPECS/${RPMNAME}.spec  
"
%prep
%setup -q -n %{srcdirname}

%build
cd ..
rm -rf build_tree
mkdir build_tree
cd build_tree
cmake -DCMAKE_INSTALL_PREFIX=$RPM_BUILD_ROOT/usr -DCMAKE_BUILD_TYPE=Debug -DBUILD_CONFIG=rpmbuild -DDISTNAME_HAS_GIT_DATA=ON ../%{srcdirname}
make
  
%install 
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT%{_sysconfdir}/ganesha/
mkdir -p $RPM_BUILD_ROOT%{_sysconfdir}/init.d
mkdir -p $RPM_BUILD_ROOT%{_sysconfdir}/dbus-1/system.d
mkdir -p $RPM_BUILD_ROOT%{_sysconfdir}/sysconfig
mkdir -p $RPM_BUILD_ROOT%{_sysconfdir}/logrotate.d
mkdir -p $RPM_BUILD_ROOT%{_bindir}
mkdir -p $RPM_BUILD_ROOT%{_sbindir}
mkdir -p $RPM_BUILD_ROOT%{_libdir}/ganesha

install -m 644 config_samples/logrotate_ganesha          $RPM_BUILD_ROOT%{_sysconfdir}/logrotate.d/ganesha
install -m 755 ganesha.init                              $RPM_BUILD_ROOT%{_sysconfdir}/init.d/ganesha
install -m 644 scripts/ganeshactl/org.ganesha.nfsd.conf  $RPM_BUILD_ROOT%{_sysconfdir}/dbus-1/system.d
install -m 755 ganesha.sysconfig                         $RPM_BUILD_ROOT%{_sysconfdir}/sysconfig/ganesha
install -m 755 tools/mount.9P				 $RPM_BUILD_ROOT%{_sbindir}/mount.9P

install -m 644 config_samples/ganesha.conf   $RPM_BUILD_ROOT%{_sysconfdir}/ganesha
install -m 644 config_samples/hosts.ganesha  $RPM_BUILD_ROOT%{_sysconfdir}/ganesha
install -m 644 config_samples/snmp.conf      $RPM_BUILD_ROOT%{_sysconfdir}/ganesha

cd ../build_tree
make install

%clean
rm -rf %{srcdirname}
rm -rf build_tree

%files
%defattr(-,root,root,-)
%{_bindir}/*
%{_sysconfdir}/*

%files mount-9P
%defattr(-,root,root,-)
%{_sbindir}/mount.9P

"
)
# if needed deal with FSALs
if(USE_FSAL_CEPH)
        FILE(APPEND ${RPM_ROOTDIR}/SPECS/${RPMNAME}.spec  
"
%files ceph
%defattr(-,root,root,-)
%{_libdir}/ganesha/libfsalceph*

" )
endif(USE_FSAL_CEPH)

if(USE_FSAL_LUSTRE)
        FILE(APPEND ${RPM_ROOTDIR}/SPECS/${RPMNAME}.spec  
"
%files lustre
%defattr(-,root,root,-)
%{_libdir}/ganesha/libfsallustre*

" )
endif(USE_FSAL_LUSTRE)

if(USE_FSAL_POSIX)
        FILE(APPEND ${RPM_ROOTDIR}/SPECS/${RPMNAME}.spec  
"
%files posix
%defattr(-,root,root,-)
%{_libdir}/ganesha/libfsalposix*

" )
endif(USE_FSAL_POSIX)

if(USE_FSAL_SHOOK)
        FILE(APPEND ${RPM_ROOTDIR}/SPECS/${RPMNAME}.spec  
"
%files shook
%defattr(-,root,root,-)
%{_libdir}/ganesha/libfsalshook*

" )
endif(USE_FSAL_SHOOK)


if(USE_FSAL_VFS)
        FILE(APPEND ${RPM_ROOTDIR}/SPECS/${RPMNAME}.spec  
"
%files vfs
%defattr(-,root,root,-)
%{_libdir}/ganesha/libfsalvfs*

" )
endif(USE_FSAL_VFS)

if(USE_FSAL_HPSS)
        FILE(APPEND ${RPM_ROOTDIR}/SPECS/${RPMNAME}.spec  
"
%files hpss
%defattr(-,root,root,-)
%{_libdir}/ganesha/libfsalhpss*

" )
endif(USE_FSAL_HPSS)

if(USE_FSAL_PROXY)
        FILE(APPEND ${RPM_ROOTDIR}/SPECS/${RPMNAME}.spec  
"
%files proxy
%defattr(-,root,root,-)
%{_libdir}/ganesha/libfsalproxy*

" )
endif(USE_FSAL_PROXY)

if(USE_FSAL_ZFS)
        FILE(APPEND ${RPM_ROOTDIR}/SPECS/${RPMNAME}.spec  
"
%files zfs
%defattr(-,root,root,-)
%{_libdir}/ganesha/libfsalzfs*

" )
endif(USE_FSAL_ZFS)

# Append changelog
FILE(APPEND ${RPM_ROOTDIR}/SPECS/${RPMNAME}.spec  
"
%changelog
"
)

FILE(APPEND ${RPM_ROOTDIR}/SPECS/${RPMNAME}.spec ${RPM_CHANGELOG_FILE_CONTENT} )
      ADD_CUSTOM_TARGET(${RPMNAME}_srpm
	COMMAND cpack -G TGZ --config CPackSourceConfig.cmake
	COMMAND ${CMAKE_COMMAND} -E copy ${CPACK_SOURCE_PACKAGE_FILE_NAME}.tar.gz ${RPM_ROOTDIR}/SOURCES    
	COMMAND ${RPMTools_RPMBUILD_EXECUTABLE} -bs --define=\"_topdir ${RPM_ROOTDIR}\" ${RPM_ROOTDIR}/SPECS/${SPECFILE_NAME} 
	)
      
      ADD_CUSTOM_TARGET(${RPMNAME}_rpm
	COMMAND cpack -G TGZ --config CPackSourceConfig.cmake
	COMMAND ${CMAKE_COMMAND} -E copy ${CPACK_SOURCE_PACKAGE_FILE_NAME}.tar.gz ${RPM_ROOTDIR}/SOURCES    
	COMMAND ${RPMTools_RPMBUILD_EXECUTABLE} -bb --define=\"_topdir ${RPM_ROOTDIR}\" ${RPM_ROOTDIR}/SPECS/${SPECFILE_NAME} 
	)  
    ENDMACRO(RPMTools_ADD_RPM_TARGETS)

  ELSE (RPMTools_RPMBUILD_FOUND)
    SET(RPMTools FALSE)
  ENDIF (RPMTools_RPMBUILD_FOUND)  
  
  
