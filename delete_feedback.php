<?php
$conn = new mysqli("localhost","root","","eco");

$id = $_GET['id'];

$conn->query("DELETE FROM feedback WHERE id=$id");

header("Location: admin_feedback.php");
?>