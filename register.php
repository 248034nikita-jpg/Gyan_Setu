<?php
    include 'includes/db_connect.php';
    if(isset($_POST['signUp'])){
        $fullname=$_POST['fullname'];  
        $phone=$_POST['phonenumber'];      
        $email=$_POST['email'];
        $password=$_POST['password'];
        $password=md5($password); //$password=hash('sha256',$password); used for hasing password

        $checkEmail = "SELECT * FROM users WHERE email='$email'";
        $result=$conn->query($checkEmail);

       if($result->num_rows > 0){
            echo "'Email already exists. Please use a different email";
        } else {
            $sql = "INSERT INTO users (fullname, phonenumber, email, password) VALUES ('$fullname', '$phone', '$email', '$password')";
            if ($conn->query($sql) === TRUE) {
                header("Location: index.php");
            } else {
                echo "Error: " . $conn->error;
            }
        }
    }   
    if(isset($_POST['signIn'])){
        $email=$_POST['email'];
        $password=$_POST['password'];
        $password=md5($password);

        $sql = "SELECT * FROM users WHERE email='$email' AND password='$password'";
        $result = $conn->query($sql);
        if ($result->num_rows > 0) {
            session_start();
            $row=$result->fetch_assoc();
            $_SESSION['email']=$row['email'];
            header("Location: dashboard.php");
            exit();
        } else {
            echo "Invalid email or password";
        }
    }
?>
