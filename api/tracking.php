<?php
require_once __DIR__ . '/db.php';

$input = json_decode(file_get_contents("php://input"), true);

$tracking_id = isset($_GET['tracking_id']) ? trim($_GET['tracking_id']) : (
    isset($_POST['tracking_id']) ? trim($_POST['tracking_id']) : (
        isset($input['tracking_id']) ? trim($input['tracking_id']) : ''
    )
);

if (empty($tracking_id)) {
    echo json_encode([
        "status" => "error",
        "message" => "Tracking ID is required."
    ]);
    exit();
}

$stmt = $conn->prepare("SELECT id, tracking_id, name, address, phone, waste_type, pickup_date, status, created_at FROM requests WHERE tracking_id=? OR phone=? ORDER BY id DESC");
$stmt->bind_param("ss", $tracking_id, $tracking_id);
$stmt->execute();
$result = $stmt->get_result();

$requests = [];
while ($row = $result->fetch_assoc()) {
    $requests[] = $row;
}

if (count($requests) > 0) {
    echo json_encode([
        "status" => "success",
        "count" => count($requests),
        "requests" => $requests,
        "latest" => $requests[0]
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "No request found for Tracking ID: $tracking_id"
    ]);
}

$stmt->close();
$conn->close();
?>
