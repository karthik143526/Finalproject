<?php
require_once __DIR__ . '/db.php';

$input = json_decode(file_get_contents("php://input"), true);

$name = isset($_POST['name']) ? trim($_POST['name']) : (isset($input['name']) ? trim($input['name']) : '');
$email = isset($_POST['email']) ? trim($_POST['email']) : (isset($input['email']) ? trim($input['email']) : '');
$password = isset($_POST['password']) ? $_POST['password'] : (isset($input['password']) ? $input['password'] : '');
$confirm_password = isset($_POST['confirm_password']) ? $_POST['confirm_password'] : (isset($input['confirm_password']) ? $input['confirm_password'] : '');

if (empty($name) || empty($email) || empty($password) || empty($confirm_password)) {
    echo json_encode([
        "status" => "error",
        "message" => "All fields are required."
    ]);
    exit();
}

if ($password !== $confirm_password) {
    echo json_encode([
        "status" => "error",
        "message" => "Passwords do not match."
    ]);
    exit();
}

if (
    strlen($password) < 8 ||
    !preg_match('/[A-Z]/', $password) ||
    !preg_match('/[0-9]/', $password) ||
    !preg_match('/[^A-Za-z0-9]/', $password)
) {
    echo json_encode([
        "status" => "error",
        "message" => "Password must be at least 8 characters long and contain an uppercase letter, a number, and a symbol."
    ]);
    exit();
}

$check = $conn->prepare("SELECT id FROM users WHERE email=?");
$check->bind_param("s", $email);
$check->execute();
$check->store_result();

if ($check->num_rows > 0) {
    echo json_encode([
        "status" => "error",
        "message" => "Email is already registered. Please try logging in."
    ]);
    $check->close();
    exit();
}
$check->close();

$hashed_password = password_hash($password, PASSWORD_DEFAULT);
$stmt = $conn->prepare("INSERT INTO users (name, email, password) VALUES (?, ?, ?)");
$stmt->bind_param("sss", $name, $email, $hashed_password);

if ($stmt->execute()) {
    echo json_encode([
        "status" => "success",
        "message" => "Successfully registered!",
        "user" => [
            "id" => $stmt->insert_id,
            "name" => $name,
            "email" => $email
        ]
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Registration failed: " . $stmt->error
    ]);
}

$stmt->close();
$conn->close();
?>
