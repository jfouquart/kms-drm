# $FreeBSD$

SYSDIR?=/usr/src/sys

.if ${MACHINE_CPUARCH} == "amd64" || ${MACHINE_CPUARCH} == "i386" || ${MACHINE_CPUARCH} == "aarch64" || ${MACHINE_ARCH} == "powerpc64"

# Get __FreeBSD_version (obtained from bsd.port.mk)
.if !defined(OSVERSION)
.if exists(${SYSDIR}/sys/param.h)
OSVERSION!=	awk '/^\#define[[:blank:]]__FreeBSD_version/ {print $$3}' < ${SYSDIR}/sys/param.h
.MAKEFLAGS:	OSVERSION=${OSVERSION}
.else
.error Unable to determine OS version. Missing kernel sources?
.endif
.endif

SUBDIR=	linuxkpi	\
	ttm		\
	drm		\
	${_dummygfx}	\
	${_vboxvideo}	\
	${_vmwgfx}	\
	${_i915}	\
	amd		\
	radeon

.if ${MACHINE_CPUARCH} == "amd64" || ${MACHINE_CPUARCH} == "i386"
_i915 =		i915 
_vmwgfx =	vmwgfx
.if ${OSVERSION} >= 1300033 || (${OSVERSION} >= 1200514 && ${OSVERSION} < 1300000)
_vboxvideo =	vboxvideo
.endif
.endif

.if defined(DUMMYGFX)
_dummygfx = dummygfx
.endif

.include <bsd.subdir.mk>

.else
dummy:
	echo "Unsupported architecture"
.endif
