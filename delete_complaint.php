<?php
$conn = new mysqli("localhost","root","","eco");

$id = $_GET['id'];

$conn->query("DELETE FROM complaints WHERE id=$id");

header("Location: admin_complaint.php");
?>