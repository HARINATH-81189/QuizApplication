<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%
    // Prevent direct access without login
    String username = (String) session.getAttribute("name");
    if (username == null) {
        response.sendRedirect("login.jsp");
    }

    String userName = (String) session.getAttribute("name");
    String userEmail = (String) session.getAttribute("email");
    String userMobile = (String) session.getAttribute("mobile");
    String role = (String) session.getAttribute("role");
%>

<%@ page import="java.sql.*,jakarta.servlet.*,jakarta.servlet.http.*" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Online Quiz Portal</title>
    <style>
        /* General */
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f0f2f5;
            color: #333;
        }

        /* Navbar */
        .navbar {
            background: #2c3e50;
            color: white;
            padding: 12px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar .logo {
            font-size: 1.3rem;
            font-weight: bold;
        }

        .navbar .nav-links {
            display: flex;
            align-items: center;
        }

        .navbar .nav-links .username {
            margin-right: 20px;
        }

        .navbar .nav-links a {
            color: white;
            text-decoration: none;
            padding: 6px 14px;
            border-radius: 5px;
            background: #e74c3c;
            transition: 0.3s;
        }

        .navbar .nav-links a:hover {
            background: #c0392b;
        }

        /* Container */
        .container {
            max-width: 800px;
            margin: 40px auto;
            text-align: center;
        }

        /* Profile Card */
        .profile-card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 30px;
            text-align: left;
        }

        .profile-card h2 {
            margin-bottom: 15px;
            color: #2c3e50;
        }

        /* Actions */
        .actions {
            display: flex;
            justify-content: center;
            gap: 20px;
        }

        .actions .btn {
            display: inline-block;
            padding: 12px 20px;
            background: #3498db;
            color: white;
            font-weight: bold;
            border-radius: 6px;
            text-decoration: none;
            transition: 0.3s;
        }

        .actions .btn:hover {
            background: #2980b9;
        }
    </style>
</head>
<body>

    <!-- Navigation bar -->
    <div class="navbar">
        <div class="logo">📝 Online Quiz Portal</div>
        <div class="nav-links">
            <span class="username">Welcome, <%= userName %></span>
            <a href="logout.jsp" class="btn-logout">Logout</a>
        </div>
    </div>

    <!-- Profile Section -->
    <div class="container">
        <div class="profile-card">
            <h2>My Profile:-</h2>
            <p><strong>Name:   </strong> <%= userName %></p>
            <p><strong>Email:  </strong> <%= userEmail %></p>
            <p><strong>Mobile: </strong> <%= userMobile %></p>
            <p><strong>Role:   </strong> <%= role %></p>
        </div>

        <!-- Actions (Only Students) -->
        <%
            if("user".equalsIgnoreCase(role)) {
        %>
        <div class="actions">
            <a href="takeQuiz.jsp" class="btn">Take Quiz</a>
            <a href="myResults.jsp" class="btn">See My Results</a>
        </div>
        <%
            }
        %>
    </div>

</body>
</html>
