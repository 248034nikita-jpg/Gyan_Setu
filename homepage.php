<?php
    session_start();
    include 'includes/db_connect.php';
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Homepage</title>
</head>
<body>
    <div style="text-align: center; padding: 15%;">
        <h1>Welcome to the Homepage</h1>
        <p>This is a simple homepage for the application.
            <?php
            if(isset($_SESSION['email'])){
                $email = $_SESSION['email'];
                $_query = mysqli_query($conn, "SELECT fname, lname FROM users WHERE email='" . mysqli_real_escape_string($conn, $email) . "'");
                while($row = mysqli_fetch_assoc($_query)){
                    echo $row['fname'].' '.$row['lname'];
                }
            }
            ?>
        </p>
    </div>
</body>
</html>