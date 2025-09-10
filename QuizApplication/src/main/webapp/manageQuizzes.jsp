<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String username = (String) session.getAttribute("name");
    String role = (String) session.getAttribute("role");

    if (username == null || role == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Quizzes</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f9; margin: 0; }
        .navbar { background: #2c3e50; color: white; padding: 12px 20px; display: flex; justify-content: space-between; }
        .navbar a { color: white; text-decoration: none; margin-left: 15px; background: #e74c3c; padding: 6px 12px; border-radius: 5px; }
        .navbar a:hover { background: #c0392b; }
        .container { max-width: 1000px; margin: 40px auto; background: white; padding: 20px; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: center; }
        th { background: #3498db; color: white; }
        .btn { padding: 6px 12px; border-radius: 5px; text-decoration: none; color: white; }
        .add { background: #27ae60; }
        .add:hover { background: #1e8449; }
        .edit { background: #2980b9; }
        .edit:hover { background: #1c5980; }
        .delete { background: #e74c3c; }
        .delete:hover { background: #c0392b; }
    </style>
</head>
<body>
    <div class="navbar">
        <div>📚 Manage Quizzes</div>
        <div>
            <a href="adminDashboard.jsp">⬅ Back</a>
            <a href="logout.jsp">Logout</a>
        </div>
    </div>

    <div class="container">
        <h2>Available Quizzes</h2>

        <a href="createQuiz.jsp" class="btn add" style="margin-bottom:15px; display:inline-block;">➕ Create New Quiz</a>

        <table>
            <tr>
                <th>Quiz ID</th>
                <th>Quiz Name</th>
                <th>Total Questions</th>
                <th>Questions Added</th>
                <th>Actions</th>
            </tr>
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/college", "root", "8118");

                    String sql = "SELECT qm.quiz_id, qm.quiz_name, qm.total_questions, COUNT(q.id) AS added_questions " +
                                 "FROM quiz_master qm " +
                                 "LEFT JOIN quiz q ON qm.quiz_id = q.quiz_id " +
                                 "GROUP BY qm.quiz_id, qm.quiz_name, qm.total_questions";
                    PreparedStatement ps = con.prepareStatement(sql);
                    ResultSet rs = ps.executeQuery();

                    while(rs.next()) {
                        int quizId = rs.getInt("quiz_id");
            %>
            <tr>
                <td><%= quizId %></td>
                <td><%= rs.getString("quiz_name") %></td>
                <td><%= rs.getInt("total_questions") %></td>
                <td><%= rs.getInt("added_questions") %></td>
                <td>
                    <a href="addQuiz.jsp?quizId=<%= quizId %>" class="btn add">➕ Add Questions</a>
                    <a href="viewQuestions.jsp?quizId=<%= quizId %>" class="btn edit">✏ View/Edit</a>
                    <a href="deleteQuizServlet?quizId=<%= quizId %>" class="btn delete">🗑 Delete Quiz</a>
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
