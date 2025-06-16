Name:       hello_world
Version:    1.0
Release:    1%{?dist}
Summary:    A simple Hello World program
License:    Proprietary
URL:        https://example.com/hello_world

# Source0:    %{name}-%{version}.tar.gz   # Makefile 추가로 소스 tarball 구성 변경 가능성
Source0:    hello_world-%{version}.tar.gz # 일관성을 위해 tarball 이름은 이렇게 유지.

BuildRequires: gcc
BuildRequires: make

%description
This is a very simple "Hello, World!" program written in C.
It demonstrates basic RPM packaging with a Makefile.

%prep
%setup -q -n hello_world-%{version} # tarball 이름에 맞춰 디렉토리 이름 지정

%build
# cd src # Makefile이 src 디렉토리 안에 있다면 이 줄이 필요.
make %{?_smp_mflags}

%install
# cd src # Makefile이 src 디렉토리 안에 있다면 이 줄이 필요.
make install DESTDIR=%{buildroot}

%files
%{_bindir}/hello_program

%changelog
* Mon Jun 16 2025 Your Name <your.email@example.com> - 1.0-1
- Initial release of Hello World program with Makefile