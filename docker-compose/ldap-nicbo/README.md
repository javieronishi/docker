# LDAP Local para NIC.BO

Servidor OpenLDAP con Docker Compose para desarrollo y pruebas. Incluye un usuario de ejemplo `jperez` preconfigurado.

---

## Requisitos previos

- [Docker](https://docs.docker.com/get-docker/) instalado
- [Docker Compose](https://docs.docker.com/compose/install/) instalado

Verifica la instalación:
```bash
docker --version
docker compose version
```

---

## Inicio rápido (desde cero)

### 1. Clonar y levantar el proyecto

```bash
cd ldap-nicbo
docker compose up -d
```

Esto inicia:
- **OpenLDAP** en puerto `389` (LDAP) y `636` (LDAPS)
- **phpLDAPadmin** en http://localhost:8090

### 2. Verificar que los contenedores están corriendo

```bash
docker ps
```

Debes ver `nicbo-openldap` y `nicbo-phpldapadmin` en estado `Up`.

---

## Credenciales de acceso

### Usuario de ejemplo preconfigurado

| Campo | Valor |
|-------|-------|
| **Usuario** | `jperez` |
| **Contraseña** | `123456` |
| **Nombre completo** | Juan Perez |
| **Email** | jperez@adsib.gob.bo |
| **DN completo** | `uid=jperez,ou=usuarios,dc=servicios,dc=adsib,dc=gob,dc=bo` |

### Administrador LDAP (phpLDAPadmin)

| Campo | Valor |
|-------|-------|
| **Login DN** | `cn=admin,dc=servicios,dc=adsib,dc=gob,dc=bo` |
| **Contraseña** | `admin_password` |

---

## Cómo ingresar al sistema

### Opción A: Panel web phpLDAPadmin (recomendado)

1. Abre http://localhost:8090 en tu navegador
2. Inicia sesión con las credenciales de administrador arriba
3. Navega por la estructura: `dc=servicios` → `dc=adsib` → `dc=gob` → `dc=bo` → `ou=usuarios`
4. Verás el usuario `jperez` listado ahí

### Opción B: Línea de comandos (desde Docker)

```bash
# Buscar el usuario jperez
docker exec nicbo-openldap ldapsearch -x \
  -b "dc=servicios,dc=adsib,dc=gob,dc=bo" \
  "(uid=jperez)"

# Verificar autenticación con contraseña
docker exec nicbo-openldap ldapwhoami -x \
  -D "uid=jperez,ou=usuarios,dc=servicios,dc=adsib,dc=gob,dc=bo" \
  -w "123456"
# Si funciona, responde: anonymous (o el DN si hay éxito)
```

---

## Configuración para control.php

Para que `control.php` se conecte a este LDAP local, edita la línea del servidor:

```php
// En control.php, línea ~12
$servidor_LDAP = "127.0.0.1";  // o la IP de tu máquina Docker
```

El usuario `jperez` ya está listo para autenticarse. Para que tenga acceso de administrador, agrégalo al grupo:

```bash
# Agregar jperez al grupo administradores
docker exec nicbo-openldap ldapmodify -x \
  -D "cn=admin,dc=servicios,dc=adsib,dc=gob,dc=bo" \
  -w admin_password <<EOF
dn: cn=administradores,ou=grupos,dc=servicios,dc=adsib,dc=gob,dc=bo
changetype: modify
add: memberUid
memberUid: jperez
EOF
```

---

## Gestión de usuarios

### Cambiar contraseña de jperez

```bash
docker exec nicbo-openldap ldappasswd -x \
  -D "cn=admin,dc=servicios,dc=adsib,dc=gob,dc=bo" \
  -w admin_password \
  -S "uid=jperez,ou=usuarios,dc=servicios,dc=adsib,dc=gob,dc=bo"
# Te pedirá la nueva contraseña interactivamente
```

### Crear un nuevo usuario

Desde phpLDAPadmin (http://localhost:8090):
1. Navega a `ou=usuarios`
2. Click en **Create a child entry** → **User account**
3. Completa los campos requeridos (uid, cn, sn, password)
4. Guarda

O desde línea de comandos con un archivo LDIF:
```bash
# Crear archivo nuevo_usuario.ldif
cat > nuevo_usuario.ldif << 'EOF'
dn: uid=nuevo,ou=usuarios,dc=servicios,dc=adsib,dc=gob,dc=bo
objectClass: inetOrgPerson
objectClass: posixAccount
objectClass: top
cn: Nuevo Usuario
sn: Usuario
uid: nuevo
uidNumber: 10002
gidNumber: 1000
homeDirectory: /home/nuevo
mail: nuevo@adsib.gob.bo
userPassword: {SSHA}su_contraseña
EOF

# Agregar al LDAP
docker exec -i nicbo-openldap ldapadd -x \
  -D "cn=admin,dc=servicios,dc=adsib,dc=gob,dc=bo" \
  -w admin_password < nuevo_usuario.ldif
```

---

## Estructura del proyecto

| Archivo | Descripción |
|---------|-------------|
| `docker-compose.yml` | Configuración de OpenLDAP + phpLDAPadmin |
| `init.ldif` | Estructura inicial: OUs, grupo administradores, usuario jperez |
| `README.md` | Este archivo |

### Estructura LDAP creada

```
dc=bo
 └── dc=gob
      └── dc=adsib
           └── dc=servicios
                ├── ou=usuarios
                │   └── uid=jperez (usuario de ejemplo)
                └── ou=grupos
                    └── cn=administradores (grupo vacío, agrega memberUid)
```

---

## Comandos útiles

```bash
# Ver logs
docker logs nicbo-openldap
docker logs nicbo-phpldapadmin

# Reiniciar servicios
docker compose restart

# Detener y eliminar contenedores
docker compose down

# Detener y eliminar TODO (incluyendo datos persistentes)
docker compose down -v

# Acceder al contenedor LDAP
docker exec -it nicbo-openldap bash
```

---

## Conceptos clave LDAP

### Base DN
La raíz del árbol: `dc=servicios,dc=adsib,dc=gob,dc=bo`

### DN de usuario
Ruta única del usuario: `uid=jperez,ou=usuarios,dc=servicios,dc=adsib,dc=gob,dc=bo`

### Grupo posixGroup
Los grupos LDAP almacenan miembros en el atributo `memberUid`. El grupo `administradores` valida permisos en `control.php`.

---

## Seguridad en producción

> [!WARNING]
> Esta configuración es **solo para desarrollo**. En producción:
> - Cambia `admin_password` por una contraseña segura
> - Cambia la contraseña de `jperez`
> - Habilita TLS/SSL obligatorio
> - Usa volúmenes persistentes con backup
> - Restringe acceso por firewall
