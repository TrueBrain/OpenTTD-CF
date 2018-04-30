ARG DISTRO=windows
ARG DISTRO_TAG
FROM openttd/base:${DISTRO}

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

# Five fixes for ICU:
# 1. We downgrade to 57, as it is the last version with the LayoutEngine, which OpenTTD depends on.
# 2. We need to copy cmemory.h ourself; the includes in layout need it, but it is not copied.
# 3. We need to clean the recycle bin after icu, as it leaves files
#     on which docker crashes while creating the overlay image.
#    Clear-RecycleBin doesn't clean it either; so forcefully remove the folder.
# 4. OpenTTD-fix: copy sicule.lib to icule.lib to match expectation
# 5. OpenTTD-fix: copy siculx.lib to iculx.lib to match expectation

ARG ARCH=x64
RUN (Get-Content c:\\vcpkg\\ports\\icu\\portfile.cmake) \
		-replace '61', '57' \
		-replace '60fed25976b8c2fe2df0b0ab745ded24da237711ec8c1e1dbdfe6eaf2014fb6b3a4bcaa488174cf770737a1c159a2d3f48a86a139cbb277163f064e607b8928f', \
		         'a5d67b8715e4e015c4620519b142c0e39fc1ed388ac81b60aa6456990f0116e9f9392082e6b622590396eab8728014f100a3295a2787b1f83d078d5f3cfbb694' \
		| Set-Content c:\\vcpkg\\ports\\icu\\portfile.cmake ; \
	c:\vcpkg\vcpkg.exe install \
		freetype:$Env:ARCH-windows-static \
		fontconfig:$Env:ARCH-windows-static \
		icu:$Env:ARCH-windows-static \
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
	Copy-Item c:\vcpkg\installed\$Env:ARCH-windows-static\lib\sicule.lib c:\vcpkg\installed\$Env:ARCH-windows-static\lib\icule.lib ; \
	Copy-Item c:\vcpkg\installed\$Env:ARCH-windows-static\lib\siculx.lib c:\vcpkg\installed\$Env:ARCH-windows-static\lib\iculx.lib

#COPY release.ps1 c:\\release.ps1

#WORKDIR c:\\workdir\\source

#ENTRYPOINT ["powershell", "-File", "c:\\release.ps1"]
#CMD ["dev"]
