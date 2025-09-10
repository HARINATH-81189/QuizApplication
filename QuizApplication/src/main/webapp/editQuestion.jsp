<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String username = (String) session.getAttribute("name");
    String role = (String) session.getAttribute("role");

    if (username == null || role == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
    }

    String questionIdStr = request.getParameter("questionId");
    String quizIdStr = request.getParameter("quizId");
    int questionId = Integer.parseInt(questionIdStr);
    int quizId = Integer.parseInt(quizIdStr);

    String question = "", optionA = "", optionB = "", optionC = "", optionD = "", correctOption = "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/college", "root", "8118");

        String sql = "SELECT * FROM quiz WHERE id=?";
        PreparedStatement ps = con.prepareStatement(sql);
        ps.setInt(1, questionId);
        ResultSet rs = ps.executeQuery();

        if (rs.next()) {
            question = rs.getString("question");
            optionA = rs.getString("option_a");
            optionB = rs.getString("option_b");
            optionC = rs.getString("option_c");
            optionD = rs.getString("option_d");
            correctOption = rs.getString("correct_option");
        }
        con.close();
    } catch (Exception e) {
        out.print("Error: " + e.getMessage());
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Edit Question</title>
    <style>
        body { font-family: Arial, sans-serif; background:#f4f6f9; margin:0; }
        .container { max-width: 600px; margin:40px auto; background:white; padding:20px;
                     border-radius:10px; box-shadow:0 2px 8px rgba(0,0,0,0.1); }
        h2 { color:#2c3e50; text-align:center; }
        form label { display:block; margin-top:10px; font-weight:bold; }
        form input, form textarea, form select { width:100%; padding:8px; margin-top:5px;
                      border-radius:6px; border:1px solid #ccc; }
        .btn { margin-top:20px; padding:10px 20px; background:#2980b9; color:white;
               border:none; border-radius:6px; cursor:pointer; }
        .btn:hover { background:#1c5980; }
        .back { display:inline-block; margin-top:15px; background:#e74c3c; padding:8px 15px; border-radius:6px; color:white; text-decoration:none; }
        .back:hover { background:#c0392b; }
    </style>
</head>
<body>
    <div class="container">
        <h2>✏ Edit Question</h2>
        <form action="UpdateQuestionServlet" method="post">
            <input type="hidden" name="questionId" value="<%= questionId %>">
            <input type="hidden" name="quizId" value="<%= quizId %>">

            <label>Question</label>
            <textarea name="question" required><%= question %></textarea>

            <label>Option A</label>
            <input type="text" name="option_a" value="<%= optionA %>" required>

            <label>Option B</label>
            <input type="text" name="option_b" value="<%= optionB %>" required>

            <label>Option C</label>
            <input type="text" name="option_c" value="<%= optionC %>" required>

            <label>Option D</label>
            <input type="text" name="option_d" value="<%= optionD %>" required>

            <label>Correct Option (A/B/C/D)</label>
            <select name="correct_option" required>
                <option value="A" <%= "A".equals(correctOption) ? "selected" : "" %>>A</option>
                <option value="B" <%= "B".equals(correctOption) ? "selected" : "" %>>B</option>
                <option value="C" <%= "C".equals(correctOption) ? "selected" : "" %>>C</option>
                <option value="D" <%= "D".equals(correctOption) ? "selected" : "" %>>D</option>
            </select>

            <button type="submit" class="btn">💾 Update Question</button>
        </form>
        <a href="viewQuestions.jsp?quizId=<%= quizId %>" class="back">⬅ Back</a>
    </div>
</body>
</html>
