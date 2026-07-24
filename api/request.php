<?php
require_once __DIR__ . '/db.php';

$input = json_decode(file_get_contents("php://input"), true);

$name        = isset($_POST['name']) ? trim($_POST['name']) : (isset($input['name']) ? trim($input['name']) : '');
$address     = isset($_POST['address']) ? trim($_POST['address']) : (isset($input['address']) ? trim($input['address']) : '');
$phone       = isset($_POST['phone']) ? trim($_POST['phone']) : (isset($input['phone']) ? trim($input['phone']) : '');
$waste_type  = isset($_POST['waste_type']) ? trim($_POST['waste_type']) : (isset($input['waste_type']) ? trim($input['waste_type']) : '');
$pickup_date = isset($_POST['pickup_date']) ? trim($_POST['pickup_date']) : (isset($input['pickup_date']) ? trim($input['pickup_date']) : '');

if (empty($name) || empty($address) || empty($phone) || empty($waste_type) || empty($pickup_date)) {
    echo json_encode([
        "status" => "error",
        "message" => "All fields are required."
    ]);
    exit();
}

$tracking_id = $phone;

$stmt = $conn->prepare("INSERT INTO requests (tracking_id, name, address, phone, waste_type, pickup_date, status) VALUES (?, ?, ?, ?, ?, ?, 'Pending')");
$stmt->bind_param("ssssss", $tracking_id, $name, $address, $phone, $waste_type, $pickup_date);

if ($stmt->execute()) {
    $request_id = $stmt->insert_id;

    // Optional SMS trigger
    $log = date('Y-m-d H:i:s') . " | API Request Created | ID: $request_id | Name: $name | Phone: $phone\n";
    @file_put_contents(__DIR__ . '/../sms_log.txt', $log, FILE_APPEND);

    echo json_encode([
        "status" => "success",
        "message" => "Pickup request submitted successfully!",
        "tracking_id" => $tracking_id,
        "request_id" => $request_id
    ]);
} else {
    echo json_encode([
        "status" => "error",
        "message" => "Failed to submit request: " . $stmt->error
    ]);
}

$stmt->close();
$conn->close();
?>
