FROM registry.redhat.io/ansible-automation-platform-25/ansible-dev-tools-rhel8:latest

USER root

EXPOSE 8080

RUN microdnf install -y \
	python3 \
	python3-pip.noarch \
	git \
	vim

RUN curl -fOL https://github.com/coder/code-server/releases/download/v4.101.2/code-server-4.101.2-amd64.rpm && \
    rpm -i code-server-4.101.2-amd64.rpm && \
    rm code-server-4.101.2-amd64.rpm

COPY files/code-server-config.yaml /home/podman/.config/code-server/config.yaml

USER podman

ENTRYPOINT "/usr/bin/code-server"