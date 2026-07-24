<?php
require_once __DIR__ . '/db.php';

// Requests
$requests_res = $conn->query("SELECT * FROM requests ORDER BY id DESC");
$requests = [];
while ($row = $requests_res->fetch_assoc()) {
    $requests[] = $row;
}

// Complaints
$complaints_res = $conn->query("SELECT * FROM complaints ORDER BY id DESC");
$complaints = [];
while ($row = $complaints_res->fetch_assoc()) {
    $complaints[] = $row;
}

// Feedback
$feedback_res = $conn->query("SELECT * FROM feedback ORDER BY id DESC");
$feedback = [];
while ($row = $feedback_res->fetch_assoc()) {
    $feedback[] = $row;
}

// Users
$users_res = $conn->query("SELECT id, name, email, created_at FROM users ORDER BY id DESC");
$users = [];
while ($row = $users_res->fetch_assoc()) {
    $users[] = $row;
}

echo json_encode([
    "status" => "success",
    "data" => [
        "requests" => $requests,
        "complaints" => $complaints,
        "feedback" => $feedback,
        "users" => $users
    ]
]);

$conn->close();
?>
