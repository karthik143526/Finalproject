<?php
require_once __DIR__ . '/db.php';

$input = json_decode(file_get_contents("php://input"), true);

$name    = isset($_POST['name']) ? trim($_POST['name']) : (isset($input['name']) ? trim($input['name']) : '');
$phone   = isset($_POST['phone']) ? trim($_POST['phone']) : (isset($input['phone']) ? trim($input['phone']) : '');
$type    = isset($_POST['type']) ? trim($_POST['type']) : (isset($input['type']) ? trim($input['type']) : '');
$message = isset($_POST['message']) ? trim($_POST['message']) : (isset($input['message']) ? trim($input['message']) : '');

if (empty($name) || empty($phone) || empty($type) || empty($message)) {
    echo json_encode([
        "status" => "error",
        "message" => "All fields are required."
    ]);
    exit();
}

$stmt = $conn->prepare("INSERT INTO complaints (name, phone, type, message) VALUES (?, ?, ?, ?)");
$stmt->bind_param("ssss", $name, $phone, $type, $message);

if ($stmt->execute()) {
    echo json_encode([
        "status" => "success",
        "message" => "Complaint submitted successfully. We will resolve it soon!",
        "complaint_id" => $stmt->insert_id
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Failed to submit complaint: " . $stmt->error
    ]);
}

$stmt->close();
$conn->close();
?>
