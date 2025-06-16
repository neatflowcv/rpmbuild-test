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

## 🚀 빌드 및 사용법

### 1. RPM 패키지 빌드

```bash
# RPM 패키지 빌드 (tarball 생성 + RPM 빌드)
make rpm
```

### 2. Mock을 사용한 다중 배포판 빌드

Mock은 clean chroot 환경에서 RPM을 빌드하여 더 안전하고 재현 가능한 빌드를 제공합니다.

```bash
# CentOS Stream 9에서 빌드
make mock-default

# Fedora 39에서 빌드
make mock-fedora39

# CentOS Stream 8에서 빌드 (권장)
make mock-centos8

# 모든 주요 배포판에서 빌드
make mock-all
```

### 3. Mock 환경 관리

```bash
# Mock 환경 초기화 (처음 사용 시)
make mock-init-default
make mock-init-fedora39
make mock-init-centos8

# 레거시 환경 초기화 (호환성 문제 있을 수 있음)
make mock-init-centos7
make mock-init-centos6

# Mock 결과 및 환경 정리
make mock-clean
```

### 4. 개별 작업

```bash
# tarball만 생성
make tarball

# 정리
make clean

# 도움말 보기
make help
```

### 5. 생성된 패키지 확인

#### 기본 rpmbuild 결과

```bash
# RPM 패키지
ls rpm/RPMS/x86_64/hello_world-1.0-1.*.x86_64.rpm

# 소스 RPM
ls rpm/SRPMS/hello_world-1.0-1.*.src.rpm
```

#### Mock 빌드 결과

```bash
# CentOS Stream 9 빌드 결과
ls mock/results/default/hello_world-1.0-1.*.x86_64.rpm

# Fedora 39 빌드 결과
ls mock/results/fedora39/hello_world-1.0-1.*.x86_64.rpm

# CentOS Stream 8 빌드 결과
ls mock/results/centos8/hello_world-1.0-1.*.x86_64.rpm
```

### 6. 패키지 설치 및 테스트

```bash
# 기본 rpmbuild 결과 설치
sudo rpm -ivh rpm/RPMS/x86_64/hello_world-1.0-1.*.x86_64.rpm

# 또는 Mock 빌드 결과 설치
sudo rpm -ivh mock/results/default/hello_world-1.0-1.*.x86_64.rpm

# 프로그램 실행
hello

# 패키지 제거
sudo rpm -e hello_world
```

## 🛠️ 개발 환경 요구사항

- **OS**: Linux (RHEL/CentOS/Fedora 계열)
- **도구**: 
  - `rpmbuild` (RPM 빌드 도구)
  - `mock` (격리된 chroot 환경에서 RPM 빌드)
  - `gcc` (C 컴파일러)
  - `make` (빌드 자동화 도구)
  - `tar`, `gzip` (아카이브 도구)

### 필수 패키지 설치 (CentOS/RHEL)

```bash
# 기본 빌드 도구
sudo yum install -y rpm-build gcc make

# Mock 설치 (EPEL 저장소 필요)
sudo yum install -y epel-release
sudo yum install -y mock

# Mock 사용자 그룹에 추가
sudo usermod -a -G mock $USER
```

### 필수 패키지 설치 (Fedora)

```bash
# 기본 빌드 도구
sudo dnf install -y rpm-build gcc make

# Mock 설치
sudo dnf install -y mock

# Mock 사용자 그룹에 추가
sudo usermod -a -G mock $USER
```

⚠️ **중요**: Mock 사용자 그룹에 추가한 후에는 재로그인하거나 `newgrp mock` 명령을 실행해야 합니다.

### 자동 설치 스크립트

편의를 위해 자동 설치 스크립트를 제공합니다:

```bash
# 스크립트 실행 (root 권한 필요)
./setup-mock.sh

# 그룹 변경사항 적용
newgrp mock
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
3. **기본 RPM 빌드**: rpmbuild를 사용한 로컬 환경에서의 패키지 생성
4. **Mock 빌드**: 격리된 chroot 환경에서의 clean 빌드
5. **다중 배포판 빌드**: CentOS Stream 9/8, Fedora에서의 호환성 테스트
6. **설치/제거**: 생성된 RPM 패키지의 설치 및 제거 테스트
7. **파일 배치**: 바이너리가 올바른 위치에 설치되는지 확인

## 🔧 Mock의 장점

- **격리된 환경**: 호스트 시스템의 영향을 받지 않는 clean 빌드
- **재현 가능성**: 동일한 환경에서 항상 같은 결과 보장
- **다중 배포판 지원**: 여러 Linux 배포판에서 동시 빌드 가능
- **의존성 검증**: 실제 배포 환경과 동일한 조건에서 의존성 테스트
- **안전성**: 빌드 프로세스가 호스트 시스템에 영향을 주지 않음

## 📄 라이선스

Proprietary (테스트 목적) 