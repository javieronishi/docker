<?php

$host = "db"; // nombre del servicio en docker-compose
$user = "app_user";
$password = "app_password";
$database = "app_db";

$conn = new mysqli($host, $user, $password, $database);

// Verificar conexión
if ($conn->connect_error) {
    die("❌ Error de conexión: " . $conn->connect_error);
}

echo "✅ Conexión exitosa a MariaDB<br>";
echo "Servidor: " . $conn->host_info . "<br>";
echo "Base de datos actual: " . $database;

// Probar query simple
$result = $conn->query("SELECT VERSION() as version");

$row = $result->fetch_assoc();

echo "<br>Versión MariaDB: " . $row["version"];

$conn->close();


?>

<hr>
<?php phpinfo(); ?>