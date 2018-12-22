FROM microsoft/windowsservercore:latest

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
