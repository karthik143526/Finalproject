<?php
$conn = new mysqli("localhost","root","","eco");

$result = $conn->query("SELECT * FROM complaints");
?>

<!DOCTYPE html>
<html>
<head>
<title>Admin Complaints</title>

<style>
body{
    font-family:Poppins;
    background:#0f2027;
    color:white;
    text-align:center;
}

h1{
    color:#ff9933;
}

table{
    width:90%;
    margin:auto;
    border-collapse:collapse;
}

th, td{
    padding:10px;
    border:1px solid #ff9933;
}

th{
    background:#ff9933;
    color:black;
}

/* 🔥 Delete Button */
.delete{
    background:red;
    color:white;
    padding:5px 10px;
    border:none;
    cursor:pointer;
}
</style>
</head>

<body>

<h1>⚠ Complaints</h1>

<table>
<tr>
<th>ID</th>
<th>Name</th>
<th>Phone</th>
<th>Type</th>
<th>Message</th>
<th>Date</th>
<th>Action</th> <!-- ✅ NEW -->
</tr>

<?php while($row = $result->fetch_assoc()){ ?>
<tr>
<td><?php echo $row['id']; ?></td>
<td><?php echo $row['name']; ?></td>
<td><?php echo $row['phone']; ?></td>
<td><?php echo $row['type']; ?></td>
<td><?php echo $row['message']; ?></td>
<td><?php echo $row['created_at']; ?></td>

<!-- ✅ DELETE BUTTON -->
<td>
<a href="delete_complaint.php?id=<?php echo $row['id']; ?>">
    <button class="delete">Remove</button>
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