<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Registration Page</title>
    <link rel="stylesheet" href="css/style.css">

    <style>
        /* Overlay background */
        .overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0,0,0,0.5);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 9999;
        }

        /* Message card */
        .msg-card {
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0px 6px 15px rgba(0,0,0,0.3);
            width: 350px;
            animation: fadeIn 0.3s ease-in-out;
        }

        .msg-card h3 {
            margin-bottom: 15px;
        }

        .msg-success h3 {
            color: #28a745; /* green */
        }

        .msg-failed h3 {
            color: #ff4b5c; /* red */
        }

        .btn-ok {
            margin-top: 15px;
            padding: 10px 18px;
            background: #007bff;
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s;
        }

        .btn-ok:hover {
            background: #0056b3;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: scale(0.8); }
            to { opacity: 1; transform: scale(1); }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Register</h2>
        <form action="register" method="post">
            
            <div class="form-group">
                <label for="name">Full Name</label>
                <input type="text" id="name" name="name" required>
            </div>

            <div class="form-group">
                <label for="email">Email</label>
                <input type="email" id="email" name="email" required>
            </div>

            <div class="form-group">
                <label for="mobile">Mobile</label>
                <input type="text" id="mobile" name="mobile" 
                       pattern="[0-9]{10}" 
                       title="Enter 10 digit mobile number" 
                       required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>

            <div class="form-group">
                <label for="confirmPassword">Confirm Password</label>
                <input type="password" id="confirmPassword" name="confirmPassword" required>
            </div>

            <button type="submit" class="btn-login">Register</button>
        </form>
        <div class="extra-links">
            <p>Already have an account? <a href="login.jsp">Login</a></p>
        </div>
    </div>

    <%
        String status = (String) request.getAttribute("status");
        if ("success".equals(status)) {
    %>
        <div class="overlay" id="successOverlay">
            <div class="msg-card msg-success">
                <h3>Registration Successful 🎉</h3>
                <p>You can now login with your credentials.</p>
                <button class="btn-ok" onclick="goToLogin()">OK</button>
            </div>
        </div>

        <script>
            function goToLogin() {
                window.location.href = "login.jsp";
            }
        </script>
    <%
        } else if ("failed".equals(status)) {
    %>
        <div class="overlay" id="failedOverlay">
            <div class="msg-card msg-failed">
                <h3>Registration Failed ❌</h3>
                <p>Something went wrong. Please try again.</p>
                <button class="btn-ok" onclick="closeError()">OK</button>
            </div>
        </div>

        <script>
            function closeError() {
                document.getElementById("failedOverlay").style.display = "none";
            }
        </script>
    <%
        }
    %>
</body>
</html>
