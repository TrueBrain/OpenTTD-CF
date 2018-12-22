FROM openttd/testing-stage1

RUN echo $(${Env:PATH})

# Install vcpkg and integrate it with VS.
RUN git clone https://github.com/Microsoft/vcpkg c:\vcpkg ; \
	cd c:\vcpkg ; \
	powershell -exec bypass c:\vcpkg\scripts\bootstrap.ps1 ; \
	c:\vcpkg\vcpkg.exe integrate install
