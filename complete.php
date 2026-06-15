<?php
$conn = new mysqli("localhost","root","","eco");
$id = $_GET['id'];
$conn->query("UPDATE requests SET status='Completed' WHERE id=$id");
header("Location: admin_dashboard.php");
?>