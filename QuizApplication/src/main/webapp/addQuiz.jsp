<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%
    String role = (String) session.getAttribute("role");
    if (role == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
    }

    String quizId = request.getParameter("quizId");
    int totalQuestions = 0;
    int addedQuestions = 0;

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/college", "root", "8118");

        // Get total allowed questions for this quiz
        PreparedStatement ps1 = con.prepareStatement("SELECT total_questions FROM quiz_master WHERE quiz_id=?");
        ps1.setInt(1, Integer.parseInt(quizId));
        ResultSet rs1 = ps1.executeQuery();
        if (rs1.next()) {
            totalQuestions = rs1.getInt("total_questions");
        }

        // Get how many questions are already added
        PreparedStatement ps2 = con.prepareStatement("SELECT COUNT(*) AS cnt FROM quiz WHERE quiz_id=?");
        ps2.setInt(1, Integer.parseInt(quizId));
        ResultSet rs2 = ps2.executeQuery();
        if (rs2.next()) {
            addedQuestions = rs2.getInt("cnt");
        }

        con.close();
    } catch(Exception e) {
        out.print("Error: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Add Quiz Question</title>
    <style>
        body { font-family: Arial, sans-serif; background:#f4f6f9; margin:0; }
        .container { max-width: 600px; margin:40px auto; background:white; padding:20px;
                     border-radius:10px; box-shadow:0 2px 8px rgba(0,0,0,0.1); }
        h2 { color:#2c3e50; text-align:center; }
        form label { display:block; margin-top:10px; font-weight:bold; }
        form input, form textarea, form select { width:100%; padding:8px; margin-top:5px; border-radius:6px; border:1px solid #ccc; }
        .btn { margin-top:20px; padding:10px 20px; background:#3498db; color:white; border:none; border-radius:6px; cursor:pointer; }
        .btn:hover { background:#2980b9; }
        .msg { text-align:center; font-weight:bold; color:#e74c3c; margin-top:20px; }
    </style>
</head>
<body>
    <div class="container">
        <h2>➕ Add New Quiz Question</h2>

        <p><b>Quiz ID:</b> <%= quizId %></p>
        <p><b>Questions Added:</b> <%= addedQuestions %> / <%= totalQuestions %></p>

        <%
            if (addedQuestions < totalQuestions) {
        %>
        <form action="AddQuizServlet" method="post">
            <input type="hidden" name="quiz_id" value="<%= quizId %>">

            <label>Question</label>
            <textarea name="question" required></textarea>

            <label>Option A</label>
            <input type="text" name="option_a" required>

            <label>Option B</label>
            <input type="text" name="option_b" required>

            <label>Option C</label>
            <input type="text" name="option_c" required>

            <label>Option D</label>
            <input type="text" name="option_d" required>

            <label>Correct Option (A/B/C/D)</label>
            <select name="correct_option" required>
                <option value="A">A</option>
                <option value="B">B</option>
                <option value="C">C</option>
                <option value="D">D</option>
            </select>

            <button type="submit" class="btn">Add Question</button>
        </form>
        <%
            } else {
        %>
        <div class="msg">✅ You have already added all required questions for this quiz!</div>
        <a href="manageQuizzes.jsp" style="display:block;text-align:center;margin-top:20px;color:white;background:#e74c3c;padding:10px;border-radius:6px;text-decoration:none;">⬅ Back to Manage Quizzes</a>
        <%
            }
        %>
    </div>
</body>
</html>
