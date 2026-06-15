<?php
$conn = new mysqli("localhost","root","","eco");
$id = $_GET['id'];
$conn->query("DELETE FROM requests WHERE id=$id");
header("Location: admin_dashboard.php");
?>