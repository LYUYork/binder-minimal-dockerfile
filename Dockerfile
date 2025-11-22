
FROM docker:dind-rootless
USER root
RUN set -eux; \
	sed -i -e 's/^rootless:x:1000:1000:/rootless:x:1234:5678:/' /etc/passwd; \
	sed -i -e 's/^rootless:x:1000:/rootless:x:5678:/' /etc/group; \
	chown -R rootless ~rootless


# install the notebook package
#RUN which python && which python3
RUN apt-get install python3 python3-pip -y && pip install --no-cache --upgrade pip && \
    pip install --no-cache notebook jupyterlab

# create user with a home directory
ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
WORKDIR ${HOME}
USER ${USER}
