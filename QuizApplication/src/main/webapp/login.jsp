<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login Page</title>
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

        /* Error card */
        .error-card {
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            text-align: center;
            box-shadow: 0px 6px 15px rgba(0,0,0,0.3);
            width: 350px;
            animation: fadeIn 0.3s ease-in-out;
        }

        .error-card h3 {
            color: #ff4b5c;
            margin-bottom: 15px;
        }

        .btn-ok {
            margin-top: 15px;
            padding: 10px 18px;
            background: #ff4b5c;
            color: white;
            border: none;
            border-radius: 8px;
            font-weight: bold;
            cursor: pointer;
            transition: background 0.3s;
        }

        .btn-ok:hover {
            background: #e60026;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: scale(0.8); }
            to { opacity: 1; transform: scale(1); }
        }
    </style>
</head>
<body>
    <div class="login-container">
        <h2>Login</h2>
        <form action="loginServlet" method="post">
            <div class="form-group">
                <label for="useremail">Email</label>
                <input type="text" id="useremail" name="email" required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" required>
            </div>

            <button type="submit" class="btn-login">Login</button>
        </form>
        <div class="extra-links">
            <p>Don't have an account? <a href="register.jsp">Register</a></p>
        </div>
    </div>

    <%
        String status = (String) request.getAttribute("status");
        if ("failed".equals(status)) {
    %>
        <div class="overlay" id="errorOverlay">
            <div class="error-card">
                <h3>Login Failed</h3>
                <p>Please try again.</p>
                <button class="btn-ok" onclick="closeError()">OK</button>
            </div>
        </div>

        <script>
            function closeError() {
                document.getElementById("errorOverlay").style.display = "none";
            }
        </script>
    <%
        }
    %>
</body>
</html>
