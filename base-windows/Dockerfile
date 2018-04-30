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
