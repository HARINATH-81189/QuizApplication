<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Students</title>
    <style>
        body { font-family: Arial, sans-serif; background:#f4f6f9; margin:0; }
        .container { max-width: 900px; margin:40px auto; background:white; padding:20px;
                     border-radius:10px; box-shadow:0 2px 8px rgba(0,0,0,0.1); position:relative; }
        h2 { text-align:center; color:#2c3e50; }
        table { width:100%; border-collapse:collapse; margin-top:20px; }
        th, td { border:1px solid #ddd; padding:10px; text-align:center; }
        th { background:#3498db; color:white; }
        tr:nth-child(even) { background:#f9f9f9; }
        .btn { padding:6px 12px; border-radius:5px; text-decoration:none; color:white; }
        .delete { background:#e74c3c; }
        .delete:hover { background:#c0392b; }
        .reset { background:#27ae60; }
        .reset:hover { background:#1e8449; }
        .back-btn { background:#e74c3c; position:absolute; right:20px; top:20px; }
        .back-btn:hover { background:#c0392b; }
    </style>
</head>
<body>
    <div class="container">
        <!-- Back Button -->
        <a href="adminDashboard.jsp" class="btn back-btn">⬅ Back</a>
        
        <h2>👥 Manage Students</h2>
        <table>
            <tr><th>ID</th><th>Name</th><th>Email</th><th>Mobile</th><th>Actions</th></tr>
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/college","root","8118");

                    PreparedStatement ps = con.prepareStatement("SELECT * FROM student WHERE role='user'");
                    ResultSet rs = ps.executeQuery();
                    while(rs.next()) {
            %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td><%= rs.getString("name") %></td>
                    <td><%= rs.getString("email") %></td>
                    <td><%= rs.getString("mobile") %></td>
                    <td>
                        <a href="ManageStudentServlet?action=delete&id=<%= rs.getInt("id") %>" class="btn delete">Delete</a>
                        <a href="resetPassword.jsp?id=<%= rs.getInt("id") %>" class="btn reset">Reset Password</a>
                    </td>
                </tr>
            <%
                    }
                    con.close();
                } catch(Exception e) {
                    out.print("Error: " + e.getMessage());
                }
            %>
        </table>
    </div>
</body>
</html>
