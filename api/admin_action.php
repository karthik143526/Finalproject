<?php
require_once __DIR__ . '/db.php';

$input = json_decode(file_get_contents("php://input"), true);

$action = isset($_POST['action']) ? $_POST['action'] : (isset($input['action']) ? $input['action'] : '');
$id = isset($_POST['id']) ? (int)$_POST['id'] : (isset($input['id']) ? (int)$input['id'] : 0);

if (empty($action) || $id <= 0) {
    echo json_encode([
        "status" => "error",
        "message" => "Action and ID are required."
    ]);
    exit();
}

if ($action === 'assign') {
    $stmt = $conn->prepare("UPDATE requests SET status='Assigned' WHERE id=?");
    $stmt->bind_param("i", $id);
    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Request assigned successfully!"]);
    } else {
        echo json_encode(["status" => "error", "message" => $stmt->error]);
    }
    $stmt->close();
} elseif ($action === 'complete') {
    $stmt = $conn->prepare("UPDATE requests SET status='Completed' WHERE id=?");
    $stmt->bind_param("i", $id);
    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Request marked as completed!"]);
    } else {
        echo json_encode(["status" => "error", "message" => $stmt->error]);
    }
    $stmt->close();
} elseif ($action === 'delete_request') {
    $stmt = $conn->prepare("DELETE FROM requests WHERE id=?");
    $stmt->bind_param("i", $id);
    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Request deleted successfully!"]);
    } else {
        echo json_encode(["status" => "error", "message" => $stmt->error]);
    }
    $stmt->close();
} elseif ($action === 'delete_complaint') {
    $stmt = $conn->prepare("DELETE FROM complaints WHERE id=?");
    $stmt->bind_param("i", $id);
    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Complaint deleted successfully!"]);
    } else {
        echo json_encode(["status" => "error", "message" => $stmt->error]);
    }
    $stmt->close();
} elseif ($action === 'delete_feedback') {
    $stmt = $conn->prepare("DELETE FROM feedback WHERE id=?");
    $stmt->bind_param("i", $id);
    if ($stmt->execute()) {
        echo json_encode(["status" => "success", "message" => "Feedback deleted successfully!"]);
    } else {
        echo json_encode(["status" => "error", "message" => $stmt->error]);
    }
    $stmt->close();
} else {
    echo json_encode(["status" => "error", "message" => "Unknown action: $action"]);
}

$conn->close();
?>
