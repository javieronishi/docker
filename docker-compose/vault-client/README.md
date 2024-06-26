# Docker Compose - Vault con almacenamiento en el sistema de archivos de Linux

En el archivo `docker-compose.yml` se define un conjunto de servicios para ejecutar en Docker Compose.

- vault
- vault-init

## Requisitos

Asegúrate de tener instalado Docker y Docker Compose en tu sistema antes de continuar.
En nuestro caso, se está utilizando Docker v24.0.2

- Docker: [Instrucciones de instalación](https://docs.docker.com/desktop/install/debian/).
- Docker Compose: [Instrucciones de instalación](https://docs.docker.com/desktop/install/debian/).

## Ejecutar el contenedor Docker

1. Clona el repositorio en tu máquina local:

   ```bash
   git clone https://gitlab.agetic.gob.bo/agetic/agcs/automatizacion/proyectos-agcs/herramientas-pnp.git
   ```

2. Navega al directorio que contiene el archivo `docker-compose.yml`:

   ```bash
   cd herramientas-pnp/docker/vault-file
   ```

3. Ejecuta docker compose:
   ```bash
   docker compose up -d
   ```
