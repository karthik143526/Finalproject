<?php
require_once __DIR__ . '/db.php';

$input = json_decode(file_get_contents("php://input"), true);

$email    = isset($_POST['email']) ? trim($_POST['email']) : (isset($input['email']) ? trim($input['email']) : '');
$admin_id = isset($_POST['admin_id']) ? trim($_POST['admin_id']) : (isset($input['admin_id']) ? trim($input['admin_id']) : '');

if (empty($email) || empty($admin_id)) {
    echo json_encode([
        "status" => "error",
        "message" => "All fields are required."
    ]);
    exit();
}

$stmt = $conn->prepare("SELECT id, email, admin_id FROM admin WHERE email=? AND admin_id=?");
$stmt->bind_param("ss", $email, $admin_id);
$stmt->execute();
$stmt->store_result();

if ($stmt->num_rows > 0) {
    echo json_encode([
        "status" => "success",
        "message" => "Admin authentication successful!",
        "admin" => [
            "email" => $email,
            "admin_id" => $admin_id
        ]
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Invalid Email or Admin ID."
    ]);
}

$stmt->close();
$conn->close();
?>
