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

.PHONY: mock-all
mock-all: mock-default mock-fedora39

.PHONY: mock-clean
mock-clean:
	rm -rf $(MOCK_RESULT_DIR)
	mock -r $(MOCK_CONFIG_DIR)/default.cfg --clean || true
	mock -r $(MOCK_CONFIG_DIR)/fedora39.cfg --clean || true

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
	@echo "  mock-default       - CentOS Stream 9에서 SRPM으로 Mock 빌드"
	@echo "  mock-fedora39      - Fedora 39에서 SRPM으로 Mock 빌드"
	@echo "  mock-all           - 모든 배포판에서 SRPM으로 Mock 빌드"
	@echo "  mock-clean         - Mock 결과 및 환경 정리"
	@echo ""
	@echo "  clean            - 생성된 파일들 정리"
	@echo "  help             - 이 도움말 표시" 