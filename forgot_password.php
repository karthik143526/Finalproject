<?php
$conn = new mysqli("localhost","root","","eco");

$email = $_POST['email'];

$result = $conn->query("SELECT * FROM users WHERE email='$email'");

if($result->num_rows > 0){

    // ✅ EMAIL EXISTS PAGE
    echo "
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset='UTF-8'>
    <title>Reset Password</title>

    <link href='https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap' rel='stylesheet'>

    <style>
    *{
        margin:0;
        padding:0;
        box-sizing:border-box;
        font-family:Poppins;
    }

    body{
        display:flex;
        justify-content:center;
        align-items:center;
        height:100vh;
        background:linear-gradient(270deg,#0f2027,#203a43,#2c5364);
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
        padding:40px;
        border-radius:20px;
        text-align:center;
        width:340px;
        backdrop-filter:blur(15px);
        box-shadow:0 10px 40px rgba(0,0,0,0.6);
    }

    h2{
        color:#00ffcc;
        margin-bottom:15px;
    }

    input{
        width:100%;
        padding:12px;
        margin:10px 0;
        border:none;
        border-radius:10px;
        outline:none;
    }

    button{
        width:100%;
        padding:12px;
        margin-top:10px;
        border:none;
        border-radius:25px;
        cursor:pointer;
        font-weight:bold;
        transition:0.3s;
    }

    .update{
        background:#00ff99;
        color:black;
    }

    .back{
        background:#333;
        color:white;
    }

    button:hover{
        transform:scale(1.05);
        box-shadow:0 0 15px #00ffcc;
    }
    </style>

    </head>

    <body>

    <div class='box'>
        <h2>🔐 Reset Password</h2>

        <form action='reset_password.php' method='POST'>
            <input type='hidden' name='email' value='$email'>

            <input type='password' 
                   name='new_password' 
                   placeholder='Enter New Password' required>

            <button type='submit' class='update'>
                Update Password
            </button>
        </form>

        <button class='back' 
        onclick=\"window.location.href='forgot_password.html'\">
            ⬅ Back
        </button>

    </div>

    </body>
    </html>
    ";

}else{

    // ❌ EMAIL NOT FOUND PAGE
    echo "
    <!DOCTYPE html>
    <html>
    <head>
    <meta charset='UTF-8'>
    <title>Email Not Found</title>

    <link href='https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;600&display=swap' rel='stylesheet'>

    <style>
    *{
        margin:0;
        padding:0;
        box-sizing:border-box;
        font-family:Poppins;
    }

    body{
        display:flex;
        justify-content:center;
        align-items:center;
        height:100vh;
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
        padding:40px;
        border-radius:20px;
        text-align:center;
        width:340px;
        backdrop-filter:blur(15px);
        box-shadow:0 10px 40px rgba(0,0,0,0.6);
    }

    .cross{
        font-size:60px;
        margin-bottom:10px;
    }

    h2{
        margin-bottom:10px;
    }

    p{
        margin-bottom:20px;
    }

    button{
        width:100%;
        padding:12px;
        margin-top:10px;
        border:none;
        border-radius:25px;
        cursor:pointer;
        font-weight:bold;
        transition:0.3s;
    }

    .retry{
        background:#00ffcc;
        color:black;
    }

    .back{
        background:#333;
        color:white;
    }

    button:hover{
        transform:scale(1.05);
        box-shadow:0 0 15px white;
    }
    </style>

    </head>

    <body>

    <div class='box'>

        <div class='cross'>❌</div>

        <h2>Email Not Found</h2>

        <p>The entered email does not exist.</p>

        <button class='retry'
        onclick=\"window.location.href='forgot_password.html'\">
            Try Again 🔄
        </button>

        <button class='back'
        onclick=\"window.location.href='login.html'\">
            ⬅ Go Back
        </button>

    </div>

    </body>
    </html>
    ";
}
?>