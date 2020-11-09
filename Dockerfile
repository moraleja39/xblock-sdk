FROM edxops/xenial-common:latest
ARG PYTHON_VERSION=3.5.9
ENV PYENV_ROOT /opt/pyenv
RUN apt-get update && apt-get install -y \
    gettext \
    lib32z1-dev \
    libjpeg62-dev \
    git \
    libxslt-dev \
    libsqlite3-dev \
    libz-dev \
    && rm -rf /var/lib/apt/lists/* \
    && git clone https://github.com/pyenv/pyenv $PYENV_ROOT --branch v1.2.18 --depth 1 \
    && $PYENV_ROOT/bin/pyenv install $PYTHON_VERSION \
    && $PYENV_ROOT/versions/$PYTHON_VERSION/bin/pyvenv /usr/local/venv

ENV PATH /usr/local/venv/bin:${PATH}
ENV VIRTUAL_ENV /usr/local/venv/

RUN pip install setuptools==44.1.0 pip==20.0.2 wheel==0.34.2

COPY . /usr/local/src/xblock-sdk
WORKDIR /usr/local/src/xblock-sdk

RUN pip install -r /usr/local/src/xblock-sdk/requirements/dev.txt 

RUN curl -sL https://deb.nodesource.com/setup_10.x -o /tmp/nodejs-setup
RUN /bin/bash /tmp/nodejs-setup
RUN rm /tmp/nodejs-setup
RUN apt-get -y install nodejs
RUN echo $PYTHONPATH

RUN make install
EXPOSE 8000
ENTRYPOINT ["python3", "manage.py"]
CMD ["runserver", "0.0.0.0:8000"]
