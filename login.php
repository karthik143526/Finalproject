<?php
$conn = new mysqli("localhost", "root", "", "eco");

if ($conn->connect_error) {
    die("Connection Failed: " . $conn->connect_error);
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $email = trim($_POST['email']);
    $password = $_POST['password'];

    // ✅ Validation
    if (empty($email) || empty($password)) {
        echo "<script>alert('All fields are required'); window.location='login.html';</script>";
        exit();
    }

    // ✅ Fetch user
    $stmt = $conn->prepare("SELECT name, password FROM users WHERE email=?");
    $stmt->bind_param("s", $email);
    $stmt->execute();
    $stmt->store_result();

    if ($stmt->num_rows > 0) {

        $stmt->bind_result($name, $hashed_password);
        $stmt->fetch();

        // 🔐 Check password
        if (password_verify($password, $hashed_password)) {

            // ✅ Correct → redirect straight to dashboard
            header("Location: dashboard.html");
            exit();

        } else {
            showErrorPage("❌ Wrong Password", "The password you entered is incorrect. Please try again.");
            exit();
        }

    } else {
        showErrorPage("❌ User Not Found", "No account found with this email address.");
        exit();
    }

    $stmt->close();
}

$conn->close();


// ❌ ERROR PAGE FUNCTION
function showErrorPage($title, $message) {
    echo '
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset="UTF-8">
    <title>Login Failed</title>
    <link href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
    *{ margin:0; padding:0; box-sizing:border-box; font-family:Poppins; }

    body{
        height:100vh;
        display:flex;
        justify-content:center;
        align-items:center;
        background:linear-gradient(270deg,#ff4d4d,#cc0000,#660000);
        background-size:600% 600%;
        animation:bgMove 8s ease infinite;
        color:white;
    }

    @keyframes bgMove{
        0%{background-position:0% 50%;}
        50%{background-position:100% 50%;}
        100%{background-position:0% 50%;}
    }

    .box{
        background:rgba(255,255,255,0.1);
        padding:50px 40px;
        border-radius:20px;
        text-align:center;
        backdrop-filter:blur(15px);
        box-shadow:0 10px 40px rgba(0,0,0,0.5);
        max-width:400px;
        width:90%;
    }

    .cross{ font-size:60px; margin-bottom:15px; }

    h2{ font-size:22px; margin-bottom:10px; }

    p{ font-size:14px; opacity:0.85; margin-bottom:25px; line-height:1.6; }

    button{
        margin:8px;
        padding:12px 25px;
        border:none;
        border-radius:25px;
        cursor:pointer;
        font-weight:bold;
        transition:transform 0.2s, box-shadow 0.2s;
    }

    .retry{ background:#00ffcc; color:black; }
    .back{ background:#333; color:white; }

    button:hover{
        transform:scale(1.1);
        box-shadow:0 0 15px rgba(255,255,255,0.4);
    }
    </style>
    </head>
    <body>
    <div class="box">
        <div class="cross">❌</div>
        <h2>'.$title.'</h2>
        <p>'.$message.'</p>
        <button class="retry" onclick="window.location.href=\'login.html\'">Try Again 🔄</button>
        <button class="back" onclick="window.location.href=\'index.html\'">Go Back ⬅</button>
    </div>
    </body>
    </html>
    ';
}
?>
