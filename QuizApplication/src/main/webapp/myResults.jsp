<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String username = (String) session.getAttribute("name");
    String email = (String) session.getAttribute("email");

    if (username == null || email == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>My Quiz Results</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f9f9f9; margin: 0; padding: 20px; }
        h2 { text-align: center; color: #2c3e50; }
        table {
            width: 90%; margin: 20px auto; border-collapse: collapse; background: white;
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
        }
        th, td {
            padding: 12px; border: 1px solid #ddd; text-align: center;
        }
        th { background: #2c3e50; color: white; }
        tr:nth-child(even) { background: #f2f2f2; }
        .back-btn {
            display: block;
            margin: 30px auto;
            padding: 12px 24px;
            background: #3498db;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: bold;
            text-align: center;
            width: fit-content;
        }
        .back-btn:hover { background: #2980b9; }
    </style>
</head>
<body>
    <h2>My Quiz Results</h2>
    <table>
        <tr>
            <th>Quiz Name</th>
            <th>Score</th>
            <th>Date Taken</th>
        </tr>
        <%
            String url = "jdbc:mysql://localhost:3306/college";
            String un = "root";
            String pwd = "8118";

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection(url, un, pwd);

                String sql = "SELECT r.quiz_name, r.score, r.date_taken " +
                             "FROM results r " +
                             "JOIN student s ON r.student_id = s.id " +
                             "WHERE s.email = ?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, email);
                ResultSet rs = ps.executeQuery();

                boolean hasResults = false;
                while(rs.next()) {
                    hasResults = true;
        %>
        <tr>
            <td><%= rs.getString("quiz_name") %></td>
            <td><%= rs.getInt("score") %></td>
            <td><%= rs.getTimestamp("date_taken") %></td>
        </tr>
        <%
                }
                if (!hasResults) {
                    out.println("<tr><td colspan='3'>No results found.</td></tr>");
                }
                con.close();
            } catch(Exception e) {
                out.println("<tr><td colspan='3' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
            }
        %>
    </table>

    <!-- Back Button -->
    <a href="index.jsp" class="back-btn">⬅ Back</a>
</body>
</html>
