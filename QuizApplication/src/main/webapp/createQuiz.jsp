<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
    }

    String message = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String quizName = request.getParameter("quiz_name");
        String totalQ = request.getParameter("total_questions");

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/college","root","8118");

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO quiz_master (quiz_name, total_questions) VALUES (?, ?)",
                Statement.RETURN_GENERATED_KEYS
            );
            ps.setString(1, quizName);
            ps.setInt(2, Integer.parseInt(totalQ));
            int rows = ps.executeUpdate();

            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int quizId = rs.getInt(1);
                    // redirect to add questions page
                    response.sendRedirect("addQuiz.jsp?quizId=" + quizId);
                }
            } else {
                message = "❌ Failed to create quiz. Try again.";
            }

            con.close();
        } catch(Exception e) {
            message = "Error: " + e.getMessage();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Quiz</title>
    <style>
        body { font-family: Arial, sans-serif; background:#f4f6f9; margin:0; }
        .container { max-width:600px; margin:60px auto; background:white; padding:25px;
                     border-radius:10px; box-shadow:0 2px 8px rgba(0,0,0,0.1); }
        h2 { text-align:center; color:#2c3e50; margin-bottom:20px; }
        form { display:flex; flex-direction:column; gap:15px; }
        input[type=text], input[type=number] {
            padding:10px; border:1px solid #ccc; border-radius:6px; width:100%;
        }
        button {
            padding:12px; background:#3498db; color:white; font-weight:bold;
            border:none; border-radius:6px; cursor:pointer; transition:0.3s;
        }
        button:hover { background:#2980b9; }
        .back { display:inline-block; margin-top:15px; text-decoration:none;
                background:#e74c3c; color:white; padding:10px 16px; border-radius:6px; }
        .back:hover { background:#c0392b; }
        .msg { margin-top:10px; color:red; text-align:center; }
    </style>
</head>
<body>
    <div class="container">
        <h2>📝 Create New Quiz</h2>
        <form method="post">
            <label>Quiz Name:</label>
            <input type="text" name="quiz_name" required>

            <label>Total Questions:</label>
            <input type="number" name="total_questions" required min="1">

            <button type="submit">Create Quiz</button>
        </form>

        <a href="manageQuizzes.jsp" class="back">⬅ Back</a>

        <% if (message != null) { %>
            <p class="msg"><%= message %></p>
        <% } %>
    </div>
</body>
</html>
