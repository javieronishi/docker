<?php

$host = 'mysql';

// Database use name
$user = 'root';

//database user password
$pass = 'test';

// check the MySQL connection status
$conn = new mysqli($host, $user, $pass);
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
} else {
    echo "Connected to MySQL server successfully!";
}
?>
