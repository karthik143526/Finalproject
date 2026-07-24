<?php
require_once __DIR__ . '/db.php';

$input = json_decode(file_get_contents("php://input"), true);

$name            = isset($_POST['name']) ? trim($_POST['name']) : (isset($input['name']) ? trim($input['name']) : '');
$rating          = isset($_POST['rating']) ? (int)$_POST['rating'] : (isset($input['rating']) ? (int)$input['rating'] : 0);
$drawback_option = isset($_POST['drawback_option']) ? trim($_POST['drawback_option']) : (isset($input['drawback_option']) ? trim($input['drawback_option']) : '');
$drawback_text   = isset($_POST['drawback_text']) ? trim($_POST['drawback_text']) : (isset($input['drawback_text']) ? trim($input['drawback_text']) : '');

if (empty($name) || $rating <= 0) {
    echo json_encode([
        "status" => "error",
        "message" => "Name and Rating are required."
    ]);
    exit();
}

$stmt = $conn->prepare("INSERT INTO feedback (name, rating, drawback_option, drawback_text) VALUES (?, ?, ?, ?)");
$stmt->bind_param("siss", $name, $rating, $drawback_option, $drawback_text);

if ($stmt->execute()) {
    echo json_encode([
        "status" => "success",
        "message" => "Thank you for your valuable feedback!",
        "feedback_id" => $stmt->insert_id
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Failed to submit feedback: " . $stmt->error
    ]);
}

$stmt->close();
$conn->close();
?>
