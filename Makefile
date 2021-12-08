NAME = msmtp
DOCKER = docker

.PHONY: build
build:
	${DOCKER} build --tag msmtp:latest .


.PHONY: run
run:
	${DOCKER} run -ti ${NAME}


.PHONY: shell
shell:
	${DOCKER} run -ti --entrypoint=/bin/sh ${NAME}
