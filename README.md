# Hello World RPM Builder 테스트 프로젝트

이 프로젝트는 **RPM 빌더를 테스트하기 위한 간단한 Hello World 프로그램**입니다.  
RPM 패키징 과정을 학습하고 RPM 빌드 환경을 테스트하는 데 사용할 수 있습니다.

## 📁 프로젝트 구조

```
rpmbuild-test/
├── README.md                    # 이 파일
├── Makefile                     # 메인 빌드 파일 (tarball 생성, RPM 빌드)
├── src/
│   ├── hello.c                  # Hello World C 소스 코드
│   └── Makefile                 # 소스 빌드용 Makefile
└── rpm/
    ├── SOURCES/                 # RPM 소스 파일들 (tarball 저장소)
    └── SPECS/
        └── hello_world.spec     # RPM 스펙 파일
```

## 🚀 빌드 및 사용법

### 1. RPM 패키지 빌드

```bash
# RPM 패키지 빌드 (tarball 생성 + RPM 빌드)
make rpm
```

### 2. 개별 작업

```bash
# tarball만 생성
make tarball

# 정리
make clean

# 도움말 보기
make help
```

### 3. 생성된 패키지 확인

빌드가 완료되면 다음 위치에서 패키지를 확인할 수 있습니다:

```bash
# RPM 패키지
ls rpm/RPMS/x86_64/hello_world-1.0-1.*.x86_64.rpm

# 소스 RPM
ls rpm/SRPMS/hello_world-1.0-1.*.src.rpm
```

### 4. 패키지 설치 및 테스트

```bash
# RPM 패키지 설치
sudo rpm -ivh rpm/RPMS/x86_64/hello_world-1.0-1.*.x86_64.rpm

# 프로그램 실행
hello

# 패키지 제거
sudo rpm -e hello_world
```

## 🛠️ 개발 환경 요구사항

- **OS**: Linux (RHEL/CentOS/Fedora 계열)
- **도구**: 
  - `rpmbuild` (RPM 빌드 도구)
  - `gcc` (C 컴파일러)
  - `make` (빌드 자동화 도구)
  - `tar`, `gzip` (아카이브 도구)

### 필수 패키지 설치 (CentOS/RHEL)

```bash
sudo yum install -y rpm-build gcc make
```

### 필수 패키지 설치 (Fedora)

```bash
sudo dnf install -y rpm-build gcc make
```

## 📝 RPM 스펙 파일 특징

- **표준적인 빌드 과정**: `make -C src` 사용
- **디버그 정보**: debuginfo 패키지 포함, debugsource 패키지 제외
- **간결한 구성**: 불필요한 메타데이터 제거
- **Makefile 통합**: 프로젝트 Makefile과 완전히 연동

## 🎯 테스트 목적

이 프로젝트는 다음과 같은 RPM 빌드 과정을 테스트할 수 있습니다:

1. **소스 코드 컴파일**: C 소스 코드를 GCC로 컴파일
2. **Tarball 생성**: 소스 코드를 tarball로 패키징
3. **RPM 빌드**: spec 파일을 사용한 RPM 패키지 생성
4. **설치/제거**: 생성된 RPM 패키지의 설치 및 제거 테스트
5. **파일 배치**: 바이너리가 올바른 위치에 설치되는지 확인

## 📄 라이선스

Proprietary (테스트 목적) 