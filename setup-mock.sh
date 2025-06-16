#!/bin/bash

# Mock 설치 및 설정 스크립트
# RPM 빌드 테스트 프로젝트용

set -e

echo "=== Mock 설치 및 설정 시작 ==="

# 현재 사용자 확인
USER=$(whoami)
if [ "$USER" = "root" ]; then
    echo "경고: root 사용자로 실행하지 마세요. 일반 사용자로 실행하세요."
    exit 1
fi

# 배포판 감지
if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRO_ID=$ID
    DISTRO_VERSION=$VERSION_ID
else
    echo "오류: 지원되지 않는 배포판입니다."
    exit 1
fi

echo "감지된 배포판: $DISTRO_ID $DISTRO_VERSION"

# Mock 설치
case $DISTRO_ID in
    "rhel"|"centos"|"rocky"|"almalinux")
        echo "Enterprise Linux 계열에서 Mock 설치 중..."
        
        # EPEL 저장소 설치
        if ! rpm -q epel-release >/dev/null 2>&1; then
            echo "EPEL 저장소 설치 중..."
            sudo dnf install -y epel-release
        fi
        
        # Mock 및 관련 패키지 설치
        sudo dnf install -y mock rpm-build gcc make
        ;;
    "fedora")
        echo "Fedora에서 Mock 설치 중..."
        sudo dnf install -y mock rpm-build gcc make
        ;;
    *)
        echo "오류: 지원되지 않는 배포판 ($DISTRO_ID)입니다."
        echo "지원 배포판: RHEL, CentOS Stream, Rocky Linux, AlmaLinux, Fedora"
        exit 1
        ;;
esac

# Mock 그룹에 사용자 추가
if ! groups $USER | grep -q mock; then
    echo "사용자 $USER를 mock 그룹에 추가 중..."
    sudo usermod -a -G mock $USER
    echo "Mock 그룹 추가 완료! 다음 명령을 실행하여 그룹 변경사항을 적용하세요:"
    echo "  newgrp mock"
    echo "또는 로그아웃 후 다시 로그인하세요."
else
    echo "사용자 $USER는 이미 mock 그룹에 속해 있습니다."
fi

# Mock 결과 디렉토리 생성
mkdir -p mock/results

echo "=== Mock 설치 및 설정 완료 ==="
echo ""
echo "사용법:"
echo "  make mock-init-default  # Mock 환경 초기화"
echo "  make mock-default       # CentOS Stream 9에서 빌드"
echo "  make mock-all           # 모든 배포판에서 빌드"
echo ""
echo "주의: Mock 그룹에 새로 추가된 경우 'newgrp mock' 실행 또는 재로그인이 필요합니다." 