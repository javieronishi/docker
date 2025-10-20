docker-compose -f host-volumes.yaml up -d

docker-compose -f named-volumes.yaml up -d

docker-compose -f postgis.yaml up -d

### Actualizar las imágenes

```bash
docker-compose pull
docker-compose build --pull
docker-compose up -d --force-recreate
docker image prune -a
```
