<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
    }
    String userId = request.getParameter("id");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Reset User Password</title>
    <style>
        body { font-family: Arial, sans-serif; background:#f4f6f9; }
        .container { max-width: 400px; margin: 80px auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        h2 { text-align:center; color:#2c3e50; }
        label { display:block; margin:10px 0 5px; }
        input[type=password], input[type=submit] {
            width: 100%; padding: 10px; margin: 8px 0;
            border: 1px solid #ccc; border-radius: 5px;
        }
        input[type=submit] { background:#3498db; color:white; font-weight:bold; cursor:pointer; }
        input[type=submit]:hover { background:#2980b9; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Reset Password</h2>
        <form action="resetPasswordServlet" method="post">
            <input type="hidden" name="id" value="<%= userId %>">
            <label>New Password:</label>
            <input type="password" name="newPassword" required>
            <input type="submit" value="Update Password">
        </form>
    </div>
</body>
</html>
