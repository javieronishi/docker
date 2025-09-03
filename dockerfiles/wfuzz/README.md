```
FROM kalilinux/kali-rolling

LABEL maintainer="YourName <your.email@example.com>"
LABEL description="Dockerfile para WFuzz con wordlists preinstaladas"

# Actualizamos e instalamos las dependencias necesarias
RUN apt-get update && apt-get install -y \
    git \
    python3 \
    python3-pip \
    libcurl4-openssl-dev \
    libssl-dev \
    build-essential \
    python3-dev \
    wordlists \
    dirbuster \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Instalamos wfuzz desde el repositorio de GitHub para obtener la última versión
RUN pip3 install --no-cache-dir --upgrade pip && \
    pip3 install --no-cache-dir git+https://github.com/xmendez/wfuzz.git

# Creamos un enlace simbólico para asegurar que las wordlists están en la ruta esperada
RUN mkdir -p /usr/share/wordlists
RUN ln -sf /usr/share/dirbuster /usr/share/wordlists/dirbuster

# Configuramos el directorio de trabajo
WORKDIR /wfuzz

# Creamos un directorio para datos persistentes
RUN mkdir -p /wfuzz/data

# Configuramos una shell como punto de entrada para facilitar la ejecución de comandos
ENTRYPOINT ["/bin/bash", "-c"]
CMD ["wfuzz --help"]
```
