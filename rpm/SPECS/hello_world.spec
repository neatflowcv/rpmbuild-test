Name:       hello_world
Version:    1.0
Release:    1%{?dist}
Summary:    A simple Hello World program
License:    Proprietary
URL:        https://example.com/hello_world

Source0:    hello_world-%{version}.tar.gz

BuildRequires: gcc
BuildRequires: make

# debugsource 패키지만 비활성화 (debuginfo는 활성화)
%global _debugsource_packages 0

%description
This is a very simple "Hello, World!" program written in C.
It demonstrates basic RPM packaging with a Makefile.

%prep
%setup -q -n hello_world-%{version} # tarball 이름에 맞춰 디렉토리 이름 지정

%build
cd src # Makefile이 src 디렉토리 안에 있으므로 이동
make build

%install
cd src # Makefile이 src 디렉토리 안에 있으므로 이동
make install DESTDIR=%{buildroot} PREFIX=%{_prefix}

%files
%{_bindir}/hello

%changelog
* Mon Jun 16 2025 Your Name <your.email@example.com> - 1.0-1
- Initial release of Hello World program with Makefile