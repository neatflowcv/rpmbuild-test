VERSION = 1.0
PROJECT = hello_world

.PHONY: tarball
tarball: clean-tarball
	mkdir -p rpm/SOURCES
	mkdir -p $(PROJECT)-$(VERSION)/src
	cp src/hello.c $(PROJECT)-$(VERSION)/src/
	cp src/Makefile $(PROJECT)-$(VERSION)/src/
	tar -czf rpm/SOURCES/$(PROJECT)-$(VERSION).tar.gz $(PROJECT)-$(VERSION)
	rm -rf $(PROJECT)-$(VERSION)

.PHONY: rpm
rpm: tarball
	rpmbuild --define "_topdir $(PWD)/rpm" -ba rpm/SPECS/hello_world.spec

.PHONY: clean-tarball
clean-tarball:
	rm -f rpm/SOURCES/$(PROJECT)-$(VERSION).tar.gz
	rm -rf $(PROJECT)-$(VERSION)

.PHONY: clean
clean: clean-tarball
	$(MAKE) -C src clean
	rm -rf rpm/BUILD rpm/BUILDROOT rpm/RPMS rpm/SRPMS

.PHONY: help
help:
	@echo "사용 가능한 타겟:"
	@echo "  tarball    - SOURCES 디렉토리에 tarball 생성"
	@echo "  rpm        - tarball 생성 후 RPM 패키지 빌드"
	@echo "  clean      - 생성된 파일들 정리"
	@echo "  help       - 이 도움말 표시" 