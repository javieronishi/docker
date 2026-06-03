#!/bin/bash
# =============================================================
# setup.sh — Levanta el LDAP de prueba y carga los datos
# =============================================================

set -e

LDAP_ADMIN_DN="cn=admin,dc=servicios,dc=adsib,dc=gob,dc=bo"
LDAP_ADMIN_PASS="admin123"
LDAP_HOST="localhost"
LDAP_PORT="389"

echo "▶ Levantando contenedores..."
docker-compose up -d

echo "⏳ Esperando que OpenLDAP esté listo (15s)..."
sleep 15

echo "▶ Cargando estructura base (OUs y grupos)..."
docker exec openldap ldapadd \
  -x \
  -H ldap://localhost \
  -D "$LDAP_ADMIN_DN" \
  -w "$LDAP_ADMIN_PASS" \
  -f /container/service/slapd/assets/config/bootstrap/ldif/custom/01-estructura.ldif \
  || echo "⚠ Algunos registros ya existen, continuando..."

echo "▶ Cargando usuario jperez con contraseña 'Test1234'..."
docker exec openldap ldapmodify \
  -x \
  -H ldap://localhost \
  -D "$LDAP_ADMIN_DN" \
  -w "$LDAP_ADMIN_PASS" << 'EOF'
dn: uid=jperez,ou=usuarios,dc=servicios,dc=adsib,dc=gob,dc=bo
changetype: modify
replace: userPassword
userPassword: Test1234
EOF

echo "▶ Cargando usuario mlopez con contraseña 'Test5678'..."
docker exec openldap ldapmodify \
  -x \
  -H ldap://localhost \
  -D "$LDAP_ADMIN_DN" \
  -w "$LDAP_ADMIN_PASS" << 'EOF'
dn: uid=mlopez,ou=usuarios,dc=servicios,dc=adsib,dc=gob,dc=bo
changetype: modify
replace: userPassword
userPassword: Test5678
EOF

echo ""
echo "✅ ¡Listo! Entorno LDAP funcionando."
echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  DATOS DE PRUEBA"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  Servidor LDAP:  localhost:389"
echo "  Admin DN:       $LDAP_ADMIN_DN"
echo "  Admin Password: $LDAP_ADMIN_PASS"
echo ""
echo "  Usuario 1:"
echo "    email:    jperez@servicios.adsib.gob.bo"
echo "    password: Test1234"
echo "    grupo:    administradores ✓"
echo ""
echo "  Usuario 2:"
echo "    email:    mlopez@servicios.adsib.gob.bo"
echo "    password: Test5678"
echo "    grupo:    administradores ✓"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  phpLDAPadmin: http://localhost:8080"
echo "    Login DN: $LDAP_ADMIN_DN"
echo "    Password: $LDAP_ADMIN_PASS"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "  Para probar bind manualmente:"
echo "    ldapsearch -x -H ldap://localhost -D 'uid=jperez,ou=usuarios,dc=servicios,dc=adsib,dc=gob,dc=bo' -w 'Test1234' -b 'dc=servicios,dc=adsib,dc=gob,dc=bo'"
echo ""
