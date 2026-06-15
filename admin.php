<?php
$conn = new mysqli("localhost", "root", "", "eco");

if ($conn->connect_error) {
    die("Connection Failed: " . $conn->connect_error);
}

if ($_SERVER["REQUEST_METHOD"] == "POST") {

    $email = trim($_POST['email']);
    $admin_id = trim($_POST['admin_id']);

    // ✅ Validation
    if (empty($email) || empty($admin_id)) {
        echo "<script>alert('All fields are required'); window.location='admin.html';</script>";
        exit();
    }

    // ✅ Secure query
    $stmt = $conn->prepare("SELECT id FROM admin WHERE email=? AND admin_id=?");
    $stmt->bind_param("ss", $email, $admin_id);
    $stmt->execute();
    $stmt->store_result();

    // ✅ If Admin Found
    if ($stmt->num_rows > 0) {

        echo '
        <!DOCTYPE html>
        <html>
        <head>
        <title>Admin Success</title>

        <style>
        body{
            display:flex;
            justify-content:center;
            align-items:center;
            height:100vh;
            margin:0;
            background:linear-gradient(270deg,#ffcc00,#cc9900,#ffaa00);
            background-size:600% 600%;
            animation:bgMove 8s ease infinite;
            font-family:Poppins,sans-serif;
            color:white;
        }

        @keyframes bgMove{
            0%{background-position:0% 50%;}
            50%{background-position:100% 50%;}
            100%{background-position:0% 50%;}
        }

        .box{
            text-align:center;
        }

        /* Loader */
        .loader{
            border:5px solid rgba(255,255,255,0.3);
            border-top:5px solid white;
            border-radius:50%;
            width:50px;
            height:50px;
            animation:spin 1s linear infinite;
            margin:20px auto;
        }

        @keyframes spin{
            0%{transform:rotate(0deg);}
            100%{transform:rotate(360deg);}
        }

        .content{
            display:none;
            background:rgba(255,255,255,0.1);
            padding:40px;
            border-radius:20px;
            backdrop-filter:blur(15px);
        }

        .tick{
            font-size:60px;
        }

        button{
            margin:10px;
            padding:12px 25px;
            border:none;
            border-radius:25px;
            cursor:pointer;
            font-weight:bold;
            transition:0.3s;
        }

        .dashboard{
            background:#fff;
            color:black;
        }

        .back{
            background:#333;
            color:white;
        }

        button:hover{
            transform:scale(1.1);
        }
        </style>

        <script>
        setTimeout(()=>{
            document.querySelector(".loader").style.display="none";
            document.querySelector(".content").style.display="block";
        },2000);
        </script>

        </head>

        <body>

        <div class="box">

            <div class="loader"></div>

            <div class="content">
                <div class="tick">✔</div>

                <h2>Admin Login Successful</h2>

                <button class="dashboard"
                onclick="window.location.href=\'admin_dashboard.html\'">
                    Go to Dashboard
                </button>

                <button class="back"
                onclick="window.location.href=\'index.html\'">
                    Go Back
                </button>

            </div>

        </div>

        </body>
        </html>
        ';

    } else {

        // ❌ Admin Not Found Page
        echo '
        <!DOCTYPE html>
        <html>
        <head>
        <title>Admin Not Found</title>

        <style>
        body{
            display:flex;
            justify-content:center;
            align-items:center;
            height:100vh;
            margin:0;
            font-family:Poppins,sans-serif;
            background:linear-gradient(270deg,#ff4d4d,#cc0000,#990000);
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
            text-align:center;
            background:rgba(255,255,255,0.1);
            padding:40px;
            border-radius:20px;
            backdrop-filter:blur(10px);
            width:350px;
        }

        .cross{
            font-size:70px;
        }

        h2{
            margin-top:10px;
        }

        p{
            opacity:0.9;
        }

        button{
            margin-top:20px;
            padding:12px 25px;
            border:none;
            border-radius:25px;
            background:white;
            color:black;
            font-weight:bold;
            cursor:pointer;
            transition:0.3s;
        }

        button:hover{
            transform:scale(1.1);
        }
        </style>

        </head>

        <body>
        

        <div class="box">

            <div class="cross">✖</div>

            <h2>Admin Not Found</h2>

            <p>Wrong Email or Admin ID</p>

            <button onclick="window.location.href=\'admin.html\'">
                Try Again
            </button>

        </div>

        </body>
        </html>
        ';
    }

    $stmt->close();
}

$conn->close();
?>