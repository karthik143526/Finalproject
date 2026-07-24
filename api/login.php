<?php
require_once __DIR__ . '/db.php';

$input = json_decode(file_get_contents("php://input"), true);

$email = isset($_POST['email']) ? trim($_POST['email']) : (isset($input['email']) ? trim($input['email']) : '');
$password = isset($_POST['password']) ? $_POST['password'] : (isset($input['password']) ? $input['password'] : '');

if (empty($email) || empty($password)) {
    echo json_encode([
        "status" => "error",
        "message" => "All fields are required."
    ]);
    exit();
}

$stmt = $conn->prepare("SELECT id, name, password FROM users WHERE email=?");
$stmt->bind_param("s", $email);
$stmt->execute();
$stmt->store_result();

if ($stmt->num_rows > 0) {
    $stmt->bind_result($id, $name, $hashed_password);
    $stmt->fetch();

    if (password_verify($password, $hashed_password)) {
        echo json_encode([
            "status" => "success",
            "message" => "Login successful!",
            "user" => [
                "id" => $id,
                "name" => $name,
                "email" => $email
            ]
        ]);
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Incorrect password. Please try again."
        ]);
    }
} else {
    echo json_encode([
        "status" => "error",
        "message" => "No account found with this email address."
    ]);
}

$stmt->close();
$conn->close();
?>
