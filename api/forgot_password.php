<?php
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With");
header("Content-Type: application/json");

if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

$conn = new mysqli("localhost", "root", "", "eco");
if ($conn->connect_error) {
    echo json_encode(['status' => 'error', 'message' => 'Database connection failed']);
    exit();
}

$data = json_decode(file_get_contents("php://input"), true);
$action = isset($data['action']) ? $data['action'] : (isset($_POST['action']) ? $_POST['action'] : '');

// Step 1: verify email exists
if ($action === 'verify_email') {
    $email = isset($data['email']) ? trim($data['email']) : '';
    if (!$email) {
        echo json_encode(['status' => 'error', 'message' => 'Email is required']);
        exit();
    }
    $stmt = $conn->prepare("SELECT id FROM users WHERE email=?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $stmt->store_result();
    if ($stmt->num_rows > 0) {
        echo json_encode(['status' => 'success', 'message' => 'Email found. You can now reset your password.']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Email not found. Please check and try again.']);
    }
    $stmt->close();
    exit();
}

// Step 2: reset password
if ($action === 'reset_password') {
    $email        = isset($data['email'])        ? trim($data['email']) : '';
    $new_password = isset($data['new_password']) ? $data['new_password'] : '';

    if (!$email || !$new_password) {
        echo json_encode(['status' => 'error', 'message' => 'Email and new password are required']);
        exit();
    }
    if (strlen($new_password) < 8) {
        echo json_encode(['status' => 'error', 'message' => 'Password must be at least 8 characters']);
        exit();
    }

    $hashed = password_hash($new_password, PASSWORD_DEFAULT);
    $stmt = $conn->prepare("UPDATE users SET password=? WHERE email=?");
    $stmt->bind_param("ss", $hashed, $email);
    $stmt->execute();

    if ($stmt->affected_rows > 0) {
        echo json_encode(['status' => 'success', 'message' => 'Password updated successfully!']);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Could not update password. Please try again.']);
    }
    $stmt->close();
    exit();
}

echo json_encode(['status' => 'error', 'message' => 'Invalid action']);
$conn->close();
?>
