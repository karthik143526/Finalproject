<?php
$conn = new mysqli("localhost","root","","eco");

if ($conn->connect_error) {
    die("Connection Failed: " . $conn->connect_error);
}

$result = $conn->query("SELECT * FROM requests");
?>

<!DOCTYPE html>
<html>
<head>
<title>Admin Dashboard</title>

<style>
body{
    font-family:Poppins;
    background:#0f2027;
    color:white;
    text-align:center;
}

h1{
    color:#00ffcc;
}

table{
    width:95%;
    margin:auto;
    border-collapse:collapse;
    margin-top:20px;
}

th, td{
    padding:10px;
    border:1px solid #00ffcc;
}

th{
    background:#00ffcc;
    color:black;
}

.pending{color:orange;}
.assigned{color:yellow;}
.completed{color:lightgreen;}

button{
    padding:5px 10px;
    border:none;
    cursor:pointer;
}
.assign{background:orange;}
.complete{background:green;color:white;}
.delete{background:red;color:white;}

.back-btn{
    margin-top:20px;
    padding:12px 25px;
    background:#00ffcc;
    color:black;
    border:none;
    border-radius:25px;
    cursor:pointer;
    font-weight:bold;
}

.back-btn:hover{
    transform:scale(1.05);
}
</style>
</head>

<body>

<h1>📊 Admin Dashboard</h1>

<table>
<tr>
<th>ID</th>
<th>Tracking ID</th>
<th>Name</th>
<th>Address</th> <!-- ✅ ADDED -->
<th>Phone</th>
<th>Waste</th>
<th>Date</th>
<th>Status</th>
<th>Action</th>
</tr>

<?php while($row = $result->fetch_assoc()){ ?>
<tr>

<td><?php echo $row['id']; ?></td>
<td><?php echo $row['tracking_id']; ?></td>
<td><?php echo $row['name']; ?></td>

<!-- ✅ SHOW ADDRESS -->
<td><?php echo $row['address']; ?></td>

<td><?php echo $row['phone']; ?></td>
<td><?php echo $row['waste_type']; ?></td>
<td><?php echo $row['pickup_date']; ?></td>

<td class="<?php echo strtolower($row['status']); ?>">
    <?php echo $row['status']; ?>
</td>

<td>
<a href="assign.php?id=<?php echo $row['id']; ?>">
    <button class="assign">Assign</button>
</a>

<a href="complete.php?id=<?php echo $row['id']; ?>">
    <button class="complete">Complete</button>
</a>

<a href="delete.php?id=<?php echo $row['id']; ?>">
    <button class="delete">Remove</button>
</a>
</td>

</tr>
<?php } ?>

</table>

<button class="back-btn" onclick="window.location.href='admin_dashboard.html'">
    ⬅ Go Back
</button>

</body>
</html>