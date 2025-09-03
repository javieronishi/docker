FROM debian:bullseye-slim

# Actualizar sistema y dependencias necesarias
RUN apt update && apt install -y \
    python3-pip \
    python3-dev \
    gcc \
    libcurl4-openssl-dev \
    libssl-dev \
    libffi-dev \
    curl \
    && pip3 install wfuzz

# Definir python3 como python
RUN ln -s /usr/bin/python3 /usr/bin/python

WORKDIR /app

ENTRYPOINT ["wfuzz"]
