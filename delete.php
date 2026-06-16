<?php
$conn = new mysqli("localhost","root","","eco");
if (isset($_GET['id'])) {
    $id = $_GET['id'];
    $stmt = $conn->prepare("DELETE FROM requests WHERE id=?");
    $stmt->bind_param("i", $id);
    $stmt->execute();
}
header("Location: admin_dashboard.php");
?>