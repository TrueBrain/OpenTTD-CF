ARG DISTRO=microsoft/windowsservercore
ARG DISTRO_TAG=latest
FROM ${DISTRO}:${DISTRO_TAG}

SHELL ["powershell", "-NoProfile", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

LABEL \
    maintainer="info@openttd.org" \
    org.label-schema.description="OpenTTD Compile-Farm images" \
    org.label-schema.schema-version="1.0" \
    org.label-schema.url="https://www.openttd.org/" \
    org.label-schema.vcs-url="https://github.com/OpenTTD/OpenTTD-CF" \
    org.label-schema.vendor=OpenTTD

# Dependencies needed to compile OpenTTD
RUN Install-WindowsFeature NET-Framework-45-Core
RUN iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1')) ; \
	choco install -y git ; \
	choco install -y nsis ; \
	choco install -y cmake.install --installargs 'ADD_CMAKE_TO_PATH=""System""'

# Compiler used in this docker
RUN Invoke-WebRequest "https://aka.ms/vs/15/release/vs_BuildTools.exe" -OutFile vs_BuildTools.exe -UseBasicParsing ; \
	Start-Process -FilePath 'vs_BuildTools.exe' -ArgumentList \
		'--quiet', \
		'--norestart', \
		'--locale en-US', \
		'--add Microsoft.VisualStudio.Workload.MSBuildTools', \
		'--add Microsoft.VisualStudio.Workload.VCTools', \
		'--add Microsoft.Component.VC.Runtime.UCRTSDK', \
		'--add Microsoft.VisualStudio.Component.VC.Tools.x86.x64', \
		'--add Microsoft.VisualStudio.Component.Windows81SDK', \
		'--add Microsoft.Net.Component.4.TargetingPack' \
		-Wait ; \
	Remove-Item 'vs_BuildTools.exe' ; \
	Remove-Item -Force -Recurse 'C:\Program Files (x86)\Microsoft Visual Studio\Installer' ; \
	setx /M PATH $($Env:PATH + ';' + ${Env:ProgramFiles(x86)} + '\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin')

# Install vcpkg and integrate it with VS.
RUN git clone https://github.com/Microsoft/vcpkg c:\vcpkg ; \
	cd c:\vcpkg ; \
	powershell -exec bypass c:\vcpkg\scripts\bootstrap.ps1 ; \
	c:\vcpkg\vcpkg.exe integrate install

# One fix for libpng:
# 1. OpenTTD-fix: copy libpng16.lib to libpng.lib to match expectation

# One fix for zlib:
# 1. The library gets named zlib.lib by vcpkg, but it is expected to be named zlibstat.lib. stat stands for static.

# One fix for lzma:
# 1. OpenTTD-fix: copy lzma.lib to liblzma.lib to match expectation

# One fix for freetype:
# 1. OpenTTD-fix: copy freetype.lib to libfreetype2.lib to match expectation

ARG ARCH=x64
RUN c:\vcpkg\vcpkg.exe install \
		freetype:$Env:ARCH-windows-static \
		fontconfig:$Env:ARCH-windows-static \
		liblzma:$Env:ARCH-windows-static \
		libpng:$Env:ARCH-windows-static \
		lzo:$Env:ARCH-windows-static \
		zlib:$Env:ARCH-windows-static ; \
	Copy-Item C:\vcpkg\buildtrees\icu\src\icu-57.1\icu\source\common\cmemory.h c:\vcpkg\installed\$Env:ARCH-windows-static\include\layout\ ; \
	Remove-Item -Force -Recurse 'C:\vcpkg\buildtrees' ; \
	Remove-Item -Force -Recurse 'C:\vcpkg\downloads' ; \
	Remove-Item -Force -Recurse 'C:\vcpkg\packages' ; \
	Remove-Item -Force -Recurse 'C:\\"$"Recycle.Bin' ; \
	Copy-Item c:\vcpkg\installed\$Env:ARCH-windows-static\lib\libpng16.lib c:\vcpkg\installed\$Env:ARCH-windows-static\lib\libpng.lib ; \
	Copy-Item c:\vcpkg\installed\$Env:ARCH-windows-static\lib\zlib.lib c:\vcpkg\installed\$Env:ARCH-windows-static\lib\zlibstat.lib ; \
	Copy-Item c:\vcpkg\installed\$Env:ARCH-windows-static\lib\lzma.lib c:\vcpkg\installed\$Env:ARCH-windows-static\lib\liblzma.lib ; \
	Copy-Item c:\vcpkg\installed\$Env:ARCH-windows-static\lib\freetype.lib c:\vcpkg\installed\$Env:ARCH-windows-static\lib\libfreetype2.lib ; \

#COPY release.ps1 c:\\release.ps1

#WORKDIR c:\\workdir\\source

#ENTRYPOINT ["powershell", "-File", "c:\\release.ps1"]
#CMD ["dev"]
