VERSION = 1.0
PROJECT = hello_world
MOCK_CONFIG_DIR = $(PWD)/mock
MOCK_RESULT_DIR = $(PWD)/mock/results

.PHONY: tarball
tarball: clean-tarball
	mkdir -p rpm/SOURCES
	mkdir -p $(PROJECT)-$(VERSION)/src
	cp src/hello.c $(PROJECT)-$(VERSION)/src/
	cp src/Makefile $(PROJECT)-$(VERSION)/src/
	tar -czf rpm/SOURCES/$(PROJECT)-$(VERSION).tar.gz $(PROJECT)-$(VERSION)
	rm -rf $(PROJECT)-$(VERSION)

.PHONY: srpm
srpm: tarball
	rpmbuild --define "_topdir $(PWD)/rpm" -bs rpm/SPECS/hello_world.spec

.PHONY: rpm
rpm: srpm
	rpmbuild --define "_topdir $(PWD)/rpm" --rebuild rpm/SRPMS/$(PROJECT)-$(VERSION)-*.src.rpm

# Mock 빌드 타겟들
.PHONY: mock-init-default
mock-init-default:
	mkdir -p $(MOCK_RESULT_DIR)
	mock -r $(MOCK_CONFIG_DIR)/default.cfg --init

.PHONY: mock-init-fedora39
mock-init-fedora39:
	mkdir -p $(MOCK_RESULT_DIR)
	mock -r $(MOCK_CONFIG_DIR)/fedora39.cfg --init

.PHONY: mock-init-centos6
mock-init-centos6:
	mkdir -p $(MOCK_RESULT_DIR)
	mock -r $(MOCK_CONFIG_DIR)/centos6.cfg --init

.PHONY: mock-init-centos7
mock-init-centos7:
	mkdir -p $(MOCK_RESULT_DIR)
	mock -r $(MOCK_CONFIG_DIR)/centos7.cfg --init

.PHONY: mock-init-centos8
mock-init-centos8:
	mkdir -p $(MOCK_RESULT_DIR)
	mock -r $(MOCK_CONFIG_DIR)/centos8.cfg --init

.PHONY: mock-default
mock-default: srpm
	mkdir -p $(MOCK_RESULT_DIR)
	mock -r $(MOCK_CONFIG_DIR)/default.cfg --resultdir=$(MOCK_RESULT_DIR)/default \
		rpm/SRPMS/$(PROJECT)-$(VERSION)-*.src.rpm

.PHONY: mock-fedora39
mock-fedora39: srpm
	mkdir -p $(MOCK_RESULT_DIR)
	mock -r $(MOCK_CONFIG_DIR)/fedora39.cfg --resultdir=$(MOCK_RESULT_DIR)/fedora39 \
		rpm/SRPMS/$(PROJECT)-$(VERSION)-*.src.rpm

.PHONY: mock-centos6
mock-centos6: srpm
	mkdir -p $(MOCK_RESULT_DIR)
	mock -r $(MOCK_CONFIG_DIR)/centos6.cfg --resultdir=$(MOCK_RESULT_DIR)/centos6 \
		rpm/SRPMS/$(PROJECT)-$(VERSION)-*.src.rpm

.PHONY: mock-centos7
mock-centos7: srpm
	mkdir -p $(MOCK_RESULT_DIR)
	mock -r $(MOCK_CONFIG_DIR)/centos7.cfg --resultdir=$(MOCK_RESULT_DIR)/centos7 \
		rpm/SRPMS/$(PROJECT)-$(VERSION)-*.src.rpm

.PHONY: mock-centos8
mock-centos8: srpm
	mkdir -p $(MOCK_RESULT_DIR)
	mock -r $(MOCK_CONFIG_DIR)/centos8.cfg --resultdir=$(MOCK_RESULT_DIR)/centos8 \
		rpm/SRPMS/$(PROJECT)-$(VERSION)-*.src.rpm

.PHONY: mock-all
mock-all: mock-default mock-fedora39 mock-centos8

.PHONY: mock-all-legacy
mock-all-legacy: mock-default mock-fedora39 mock-centos7 mock-centos6

.PHONY: mock-clean
mock-clean:
	rm -rf $(MOCK_RESULT_DIR)
	mock -r $(MOCK_CONFIG_DIR)/default.cfg --clean || true
	mock -r $(MOCK_CONFIG_DIR)/fedora39.cfg --clean || true
	mock -r $(MOCK_CONFIG_DIR)/centos6.cfg --clean || true
	mock -r $(MOCK_CONFIG_DIR)/centos7.cfg --clean || true
	mock -r $(MOCK_CONFIG_DIR)/centos8.cfg --clean || true

.PHONY: clean-tarball
clean-tarball:
	rm -f rpm/SOURCES/$(PROJECT)-$(VERSION).tar.gz
	rm -rf $(PROJECT)-$(VERSION)

.PHONY: clean
clean: clean-tarball mock-clean
	$(MAKE) -C src clean
	rm -rf rpm/BUILD rpm/BUILDROOT rpm/RPMS rpm/SRPMS

.PHONY: help
help:
	@echo "사용 가능한 타겟:"
	@echo "  tarball          - SOURCES 디렉토리에 tarball 생성"
	@echo "  srpm             - SRPM 패키지 생성"
	@echo "  rpm              - SRPM으로부터 RPM 패키지 빌드"
	@echo ""
	@echo "Mock 빌드 타겟:"
	@echo "  mock-init-default  - CentOS Stream 9 Mock 환경 초기화"
	@echo "  mock-init-fedora39 - Fedora 39 Mock 환경 초기화"
	@echo "  mock-init-centos8  - CentOS Stream 8 Mock 환경 초기화 (권장)"
	@echo "  mock-init-centos7  - CentOS 7 Mock 환경 초기화"
	@echo "  mock-init-centos6  - CentOS 6 Mock 환경 초기화 (레거시)"
	@echo "  mock-default       - CentOS Stream 9에서 SRPM으로 Mock 빌드"
	@echo "  mock-fedora39      - Fedora 39에서 SRPM으로 Mock 빌드"
	@echo "  mock-centos8       - CentOS Stream 8에서 SRPM으로 Mock 빌드 (권장)"
	@echo "  mock-centos7       - CentOS 7에서 SRPM으로 Mock 빌드"
	@echo "  mock-centos6       - CentOS 6에서 SRPM으로 Mock 빌드 (레거시)"
	@echo "  mock-all           - 주요 배포판에서 SRPM으로 Mock 빌드"
	@echo "  mock-all-legacy    - 레거시 포함 모든 배포판에서 Mock 빌드"
	@echo "  mock-clean         - Mock 결과 및 환경 정리"
	@echo ""
	@echo "  clean            - 생성된 파일들 정리"
	@echo "  help             - 이 도움말 표시" 