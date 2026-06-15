<?php
$conn = new mysqli("localhost","root","","eco");

$result = $conn->query("SELECT * FROM feedback");
?>

<!DOCTYPE html>
<html>
<head>
<title>Admin Feedback</title>

<style>
body{
    font-family:Poppins;
    background:#0f2027;
    color:white;
    text-align:center;
}

h1{
    color:#66ff66;
}

table{
    width:90%;
    margin:auto;
    border-collapse:collapse;
}

th, td{
    padding:10px;
    border:1px solid #66ff66;
}

th{
    background:#66ff66;
    color:black;
}

.delete{
    background:red;
    color:white;
    border:none;
    padding:5px 10px;
    cursor:pointer;
}
</style>
</head>

<body>

<h1>💬 Feedback</h1>

<table>
<tr>
<th>ID</th>
<th>Name</th>
<th>Rating</th>
<th>Drawback</th>
<th>Description</th>
<th>Date</th>
<th>Action</th>
</tr>

<?php while($row = $result->fetch_assoc()){ ?>
<tr>
<td><?php echo $row['id']; ?></td>
<td><?php echo $row['name']; ?></td>
<td><?php echo $row['rating']; ?></td>
<td><?php echo $row['drawback_option']; ?></td>
<td><?php echo $row['drawback_text']; ?></td>
<td><?php echo $row['created_at']; ?></td>

<td>
<a href="delete_feedback.php?id=<?php echo $row['id']; ?>">
<button class="delete">Delete</button>
</a>
</td>
</tr>
<?php } ?>

</table>

<br>

<button onclick="window.location.href='admin_dashboard.html'">
⬅ Back
</button>

</body>
</html>