# 🔐 LDAP de Prueba — Compatible con PHP ADSIB

Entorno Docker para probar autenticación LDAP con la estructura exacta que usa el código PHP.

## Estructura LDAP generada

```
dc=servicios,dc=adsib,dc=gob,dc=bo
├── ou=usuarios
│   ├── uid=jperez       → jperez@servicios.adsib.gob.bo / Test1234
│   └── uid=mlopez       → mlopez@servicios.adsib.gob.bo / Test5678
└── ou=grupos
    ├── cn=administradores  (memberUid: jperez, mlopez)
    └── cn=usuarios_normales
```

## Inicio rápido

```bash
# 1. Dar permisos al script
chmod +x setup.sh

# 2. Levantar todo
./setup.sh
```

Si preferís hacerlo manual:

```bash
docker compose up -d
sleep 15
# Cargar el LDIF desde dentro del contenedor
docker exec openldap ldapadd -x -H ldap://localhost \
  -D "cn=admin,dc=servicios,dc=adsib,dc=gob,dc=bo" \
  -w admin123 \
  -f /container/service/slapd/assets/config/bootstrap/ldif/custom/01-estructura.ldif
```

## Cómo apuntar el PHP a este servidor

En tu código PHP, cambiar:
```php
$servidor_LDAP = "192.168.2.138";  // producción
```
por:
```php
$servidor_LDAP = "localhost";  // o la IP de tu máquina si el PHP corre en otro contenedor
```

Si el PHP también corre en Docker, usar el nombre del servicio:
```php
$servidor_LDAP = "openldap";
```
y agregar tu contenedor PHP a la red `ldap_net` en el docker-compose.

## Usuarios de prueba

| Email | Contraseña | Grupo admin |
|-------|-----------|-------------|
| jperez@servicios.adsib.gob.bo | Test1234 | ✅ Sí |
| mlopez@servicios.adsib.gob.bo | Test5678 | ✅ Sí |

## phpLDAPadmin (interfaz web)

- URL: http://localhost:8080
- Login DN: `cn=admin,dc=servicios,dc=adsib,dc=gob,dc=bo`
- Contraseña: `admin123`

## Probar conexión manual

```bash
# Verificar que el bind funciona (simula lo que hace el PHP)
ldapsearch -x -H ldap://localhost \
  -D "uid=jperez,ou=usuarios,dc=servicios,dc=adsib,dc=gob,dc=bo" \
  -w "Test1234" \
  -b "dc=servicios,dc=adsib,dc=gob,dc=bo" \
  "(uid=jperez)"

# Verificar membresía al grupo administradores
ldapsearch -x -H ldap://localhost \
  -D "cn=admin,dc=servicios,dc=adsib,dc=gob,dc=bo" \
  -w admin123 \
  -b "cn=administradores,ou=grupos,dc=servicios,dc=adsib,dc=gob,dc=bo" \
  "(&(objectClass=posixGroup)(memberUid=jperez))"
```

## Errores del PHP y qué los causa

| Error | Causa |
|-------|-------|
| `error=5` | Usuario autenticado pero NO está en grupo `administradores` |
| `error=6` | Credenciales incorrectas (bind fallido) |
| `error=7` | No se pudo conectar al servidor LDAP |

## Apagar el entorno

```bash
docker compose down          # solo detiene
docker compose down -v       # detiene y borra volúmenes (datos limpios)
```
