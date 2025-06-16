# Hello World RPM Builder 테스트 프로젝트

이 프로젝트는 **RPM 빌더를 테스트하기 위한 간단한 Hello World 프로그램**입니다.  
RPM 패키징 과정을 학습하고 RPM 빌드 환경을 테스트하는 데 사용할 수 있습니다.

## 📁 프로젝트 구조

```
rpmbuild-test/
├── README.md                    # 이 파일
├── Makefile                     # 메인 빌드 파일 (tarball 생성, RPM 빌드, Mock)
├── src/
│   ├── hello.c                  # Hello World C 소스 코드
│   └── Makefile                 # 소스 빌드용 Makefile
├── rpm/
│   ├── SOURCES/                 # RPM 소스 파일들 (tarball 저장소)
│   └── SPECS/
│       └── hello_world.spec     # RPM 스펙 파일
└── mock/
    ├── default.cfg              # CentOS Stream 9 Mock 설정
    ├── fedora39.cfg             # Fedora 39 Mock 설정
    ├── centos8.cfg              # CentOS Stream 8 Mock 설정 (권장)
    ├── centos7.cfg              # CentOS 7 Mock 설정 (레거시)
    ├── centos6.cfg              # CentOS 6 Mock 설정 (레거시)
    └── results/                 # Mock 빌드 결과물 저장소
```

## 🚀 빠른 시작

```bash
# 기본 RPM 빌드
make rpm

# Mock을 사용한 clean 빌드 (권장)
make mock-centos8

# 사용 가능한 모든 명령어 보기
make help
```

### 생성된 패키지 설치 및 테스트

```bash
# 패키지 설치
sudo rpm -ivh rpm/RPMS/x86_64/hello_world-1.0-1.*.x86_64.rpm

# 프로그램 실행
hello

# 패키지 제거
sudo rpm -e hello_world
```

## 🛠️ 개발 환경 요구사항

- **OS**: Linux (RHEL/CentOS/Fedora 계열)
- **도구**: `rpmbuild`, `mock`, `gcc`, `make`

### 필수 패키지 설치 (CentOS/RHEL)

```bash
# 기본 빌드 도구
sudo yum install -y rpm-build gcc make

# Mock 설치 (EPEL 저장소 필요)
sudo yum install -y epel-release mock

# Mock 사용자 그룹에 추가
sudo usermod -a -G mock $USER
```

### 필수 패키지 설치 (Fedora)

```bash
# 기본 빌드 도구
sudo dnf install -y rpm-build gcc make mock

# Mock 사용자 그룹에 추가
sudo usermod -a -G mock $USER
```

⚠️ **중요**: Mock 사용자 그룹에 추가한 후에는 재로그인하거나 `newgrp mock` 명령을 실행해야 합니다.

## 🎯 테스트 목적

이 프로젝트는 다음과 같은 RPM 빌드 과정을 테스트할 수 있습니다:

- **소스 코드 컴파일**: C 소스 코드를 GCC로 컴파일
- **기본 RPM 빌드**: rpmbuild를 사용한 로컬 환경에서의 패키지 생성
- **Mock 빌드**: 격리된 chroot 환경에서의 clean 빌드
- **다중 배포판 빌드**: CentOS/Fedora에서의 호환성 테스트
- **설치/제거 테스트**: 생성된 RPM 패키지의 설치 및 제거

## 🔧 Mock의 장점

- **격리된 환경**: 호스트 시스템의 영향을 받지 않는 clean 빌드
- **재현 가능성**: 동일한 환경에서 항상 같은 결과 보장
- **다중 배포판 지원**: 여러 Linux 배포판에서 동시 빌드 가능
- **의존성 검증**: 실제 배포 환경과 동일한 조건에서 의존성 테스트

## 📄 라이선스

Proprietary (테스트 목적) 