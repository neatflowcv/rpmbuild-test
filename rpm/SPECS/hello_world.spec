Name:       hello_world
Version:    1.0
Release:    1%{?dist}
Summary:    A simple Hello World program
License:    Proprietary

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
make -C src build

%install
make -C src install DESTDIR=%{buildroot} PREFIX=%{_prefix}

%files
%{_bindir}/hello
%doc

%changelog
* Mon Jun 16 2025 RPM Builder <builder@localhost> - 1.0-1
- Initial release