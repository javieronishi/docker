<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Ping desde Docker</title>
</head>
<body>
    <form method="post">
        <label for="host">Host:</label>
        <input type="text" id="host" name="host" required>
        <input type="submit" value="Hacer Ping">
    </form>

    <?php
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        $host = $_POST['host'];
        if (!empty($host)) {
            $pingResult = system("ping -c 4 " . escapeshellarg($host));

            if ($pingResult) {
                echo "<pre>Ping exitoso:\n" . htmlspecialchars($pingResult) . "</pre>";
            } else {
                echo "Error al hacer ping.";
            }
        } else {
            echo "Por favor, introduce un host válido.";
        }
    }
    ?>
</body>
</html>