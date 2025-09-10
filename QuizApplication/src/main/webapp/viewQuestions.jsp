<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
    String username = (String) session.getAttribute("name");
    String role = (String) session.getAttribute("role");

    if (username == null || role == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp");
    }

    String quizIdStr = request.getParameter("quizId");
    int quizId = Integer.parseInt(quizIdStr);
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>View Questions</title>
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
        .edit { background: #2980b9; }
        .edit:hover { background: #1c5980; }
        .delete { background: #e74c3c; }
        .delete:hover { background: #c0392b; }
    </style>
</head>
<body>
    <div class="navbar">
        <div>📖 Manage Questions</div>
        <div>
            <a href="manageQuizzes.jsp">⬅ Back</a>
            <a href="logout.jsp">Logout</a>
        </div>
    </div>

    <div class="container">
        <h2>Questions for Quiz ID: <%= quizId %></h2>

        <table>
            <tr>
                <th>ID</th>
                <th>Question</th>
                <th>Options</th>
                <th>Correct</th>
                <th>Actions</th>
            </tr>
            <%
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/college", "root", "8118");

                    String sql = "SELECT * FROM quiz WHERE quiz_id=?";
                    PreparedStatement ps = con.prepareStatement(sql);
                    ps.setInt(1, quizId);
                    ResultSet rs = ps.executeQuery();

                    while(rs.next()) {
            %>
            <tr>
                <td><%= rs.getInt("id") %></td>
                <td><%= rs.getString("question") %></td>
                <td>
                    A: <%= rs.getString("option_a") %><br>
                    B: <%= rs.getString("option_b") %><br>
                    C: <%= rs.getString("option_c") %><br>
                    D: <%= rs.getString("option_d") %>
                </td>
                <td><%= rs.getString("correct_option") %></td>
                <td>
                    <a href="editQuestion.jsp?questionId=<%= rs.getInt("id") %>&quizId=<%= quizId %>" class="btn edit">✏ Edit</a>
                    <a href="deleteQuestionServlet?questionId=<%= rs.getInt("id") %>&quizId=<%= quizId %>" class="btn delete" onclick="return confirm('Are you sure?')">🗑 Delete</a>
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
