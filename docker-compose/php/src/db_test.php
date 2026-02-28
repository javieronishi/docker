<?php
$host = getenv('DB_HOST');
$db   = getenv('DB_NAME');
$user = getenv('DB_USER');
$pass = getenv('DB_PASSWORD');
$charset = 'utf8mb4';

$dsn = "mysql:host=$host;dbname=$db;charset=$charset";
$options = [
    PDO::ATTR_ERRMODE            => PDO::ERRMODE_EXCEPTION,
    PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
    PDO::ATTR_EMULATE_PREPARES   => false,
];

try {
     $pdo = new PDO($dsn, $user, $pass, $options);
     echo "<h1>Conexión exitosa a la base de datos!</h1>";
} catch (\PDOException $e) {
     echo "<h1>Error de conexión:</h1>";
     echo "<p>" . $e->getMessage() . "</p>";
}

echo "<h2>Extensiones cargadas:</h2>";
echo "<pre>";
print_r(get_loaded_extensions());
echo "</pre>";
?>
