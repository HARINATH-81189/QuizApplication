





<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%
    String username = (String) session.getAttribute("name");
    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Take Quiz</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f9f9f9; margin: 0; padding: 20px; }
        h2 { text-align: center; }
        .quiz-card {
            background: white; padding: 20px; margin: 15px auto; border-radius: 10px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.2); max-width: 600px;
        }
        .quiz-card h3 { margin: 0 0 10px 0; color: #2c3e50; }
        .quiz-card p { margin: 5px 0; }
        .btn {
            display: inline-block; padding: 10px 15px; background: #3498db; color: white;
            text-decoration: none; border-radius: 6px; font-weight: bold;
        }
        .btn:hover { background: #2980b9; }
        .back-btn {
            display: block;
            margin: 30px auto;
            padding: 12px 24px;
            background: #2c3e50;
            color: white;
            text-decoration: none;
            border-radius: 6px;
            font-size: 16px;
            font-weight: bold;
            text-align: center;
            width: fit-content;
        }
        .back-btn:hover { background: #1a242f; }
    </style>
</head>
<body>
    <h2>Available Quizzes</h2>

    <%
        String url = "jdbc:mysql://localhost:3306/college";
        String un = "root";
        String pwd = "8118";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, un, pwd);

            String sql = "SELECT quiz_id, quiz_name, total_questions FROM quiz_master";
            PreparedStatement ps = con.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();

            while(rs.next()) {
    %>
        <div class="quiz-card">
            <h3><%= rs.getString("quiz_name") %></h3>
            <p><strong>Total Questions:</strong> <%= rs.getInt("total_questions") %></p>
            <a href="startQuiz.jsp?quizId=<%= rs.getInt("quiz_id") %>" class="btn">Start Quiz</a>
        </div>
    <%
            }
            con.close();
        } catch(Exception e) {
            out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
        }
    %>

    <!-- Back Button -->
    <a href="index.jsp" class="back-btn">⬅ Back to Dashboard</a>
</body>
</html>










