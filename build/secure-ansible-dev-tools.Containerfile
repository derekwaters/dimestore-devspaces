FROM registry.redhat.io/ansible-automation-platform-25/ansible-dev-tools-rhel8:latest

USER root

RUN microdnf install -y \
	python3 \
	python3-pip.noarch \
	git \
	vim \
	which && \
	pip3 install limited-shell && \
	microdnf clean all

RUN mkdir -p /opt/tools && \
	ln -s $(which ls) /opt/tools/ls && \
	ln -s $(which git) /opt/tools/git && \
	ln -s $(which vim) /opt/tools/vim && \
	ln -s $(which ansible-navigator) /opt/tools/ansible-navigator

RUN useradd -m -s /usr/local/bin/lshell devuser
COPY files/lshell.conf /etc/lshell.conf

# RUN rm -f /bin/bash /bin/sh /usr/bin/zsh || true
RUN rm -f /usr/bin/zsh || true
ENV PATH="/opt/tools:/bin/"

WORKDIR /home/devuser
USER devuser

ENTRYPOINT "/usr/local/bin/lshell"
