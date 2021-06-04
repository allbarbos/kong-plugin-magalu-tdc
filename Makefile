cmd = busted --coverage spec/unit

define DOCKERFILE
FROM kong-pongo-test:2.3.2\\n
USER root\\n
RUN luarocks install luacov\\n
WORKDIR /kong-plugin\\n
COPY . .
endef

integration:
	pongo run ./spec/integration

build:
	touch Dockerfile
	$(shell echo $(DOCKERFILE) > Dockerfile)
	docker build -f Dockerfile -t magalu-tdc-cov .

unit: build
	docker run magalu-tdc-cov /bin/bash -c $(cmd)
	rm -f Dockerfile

cov: build
	docker run magalu-tdc-cov /bin/bash -c "$(cmd) && luacov && cat luacov.report.out"
	rm -f Dockerfile
