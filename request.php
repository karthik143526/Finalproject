<?php
$conn = new mysqli("localhost","root","","eco");

$name       = $_POST['name'];
$address    = $_POST['address'];
$phone      = $_POST['phone'];
$waste_type = $_POST['waste_type'];
$pickup_date= $_POST['pickup_date'];

$tracking_id = $phone;

$sql = "INSERT INTO requests (tracking_id,name,address,phone,waste_type,pickup_date)
        VALUES ('$tracking_id','$name','$address','$phone','$waste_type','$pickup_date')";

if($conn->query($sql)){

    // ============================================
    // TWILIO SMS - Admin gets notification
    // ============================================
    $account_sid   = 'AC6348be9a1161451bb0cf0c0705cc3ecc';
$auth_token    = '377020b870e3e9259e64e720232a4335';
$messaging_sid = 'MG90c892a8baefaeb0215d46af01c14f2d';
   

    $admin_msg = "New Pickup Request!\n"
               . "Name: $name\n"
               . "Phone: $phone\n"
               . "Address: $address\n"
               . "Waste: $waste_type\n"
               . "Date: $pickup_date\n"
               . "Tracking ID: $tracking_id";

    $url  = "https://api.twilio.com/2010-04-01/Accounts/$account_sid/Messages.json";
    $data = http_build_query([
        'To'                  => '+918008444328',
        'MessagingServiceSid' => $messaging_sid,
        'Body'                => $admin_msg
    ]);

    $ch = curl_init($url);
    curl_setopt($ch, CURLOPT_POST,           true);
    curl_setopt($ch, CURLOPT_POSTFIELDS,     $data);
    curl_setopt($ch, CURLOPT_USERPWD,        "$account_sid:$auth_token");
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_TIMEOUT,        30);
    curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 10);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    $response   = curl_exec($ch);
    $curl_error = curl_error($ch);
    curl_close($ch);

    $log = date('Y-m-d H:i:s') . " | Name: $name | Phone: $phone\n";
    if($curl_error){
        $log .= "CURL ERROR: $curl_error\n";
    } else {
        $result = json_decode($response, true);
        $log .= "SMS Status: " . ($result['status'] ?? 'unknown') . "\n";
        if(isset($result['error_message'])){
            $log .= "Twilio Error: " . $result['error_message'] . "\n";
        }
    }
    $log .= "---\n";
    file_put_contents('sms_log.txt', $log, FILE_APPEND);

    // ============================================
    // FAST2SMS - Customer gets SMS
    // This is the same code that worked yesterday!
    // ============================================
    $fast2sms_key = '6GRAKS7j9enohYEXxtQJyZHFqdgfIWCiwTzDs5Upbma4vBOc3kXaHNbM4AE9WedLStTOz3VRvlGm0U2p'; // ⚠️ Paste Fast2SMS API key

    $customer_msg = "Dear $name your EcoWaste pickup request is successfully registered! "
                  . "Tracking ID $tracking_id. "
                  . "Pickup Date $pickup_date. "
                  . "Waste Type $waste_type. "
                  . "Thank you EcoWaste Team";

    $sms_url = "https://www.fast2sms.com/dev/bulkV2"
             . "?authorization=" . urlencode($fast2sms_key)
             . "&route=q"
             . "&message="  . urlencode($customer_msg)
             . "&numbers="  . $phone
             . "&flash=0";

    $ch2 = curl_init();
    curl_setopt_array($ch2, [
        CURLOPT_URL            => $sms_url,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_TIMEOUT        => 30,
        CURLOPT_CONNECTTIMEOUT => 10,
        CURLOPT_SSL_VERIFYPEER => false,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_HTTPHEADER     => ["authorization: $fast2sms_key"]
    ]);
    $response2 = curl_exec($ch2);
    $err2      = curl_error($ch2);
    curl_close($ch2);

    $log2 = date('Y-m-d H:i:s') . " | Fast2SMS | Phone: $phone | Response: $response2 | Error: $err2\n---\n";
    file_put_contents('sms_log.txt', $log2, FILE_APPEND);
    // ============================================

echo "
<!DOCTYPE html>
<html>
<head>
<title>Success</title>
<link href='https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap' rel='stylesheet'>
<style>
body{height:100vh;display:flex;justify-content:center;align-items:center;background:linear-gradient(270deg,#0f2027,#203a43,#2c5364);color:white;font-family:Poppins;}
.box{background:rgba(255,255,255,0.08);padding:40px;border-radius:20px;text-align:center;}
button{margin:10px;padding:12px 25px;border:none;border-radius:25px;cursor:pointer;font-weight:bold;}
.track{background:#00ffcc;color:black;}
.back{background:#333;color:white;}
</style>
</head>
<body>
<div class='box'>
<h2>✔ Successfully Submitted</h2>
<p>Your Tracking ID: <b>$tracking_id</b></p>
<button class='track' onclick=\"window.location.href='tracking.html'\">Track Now 🚀</button>
<button class='back' onclick=\"window.location.href='request.html'\">Go Back</button>
</div>
</body>
</html>
";
}
?>