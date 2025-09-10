<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true"%>
<%@ page import="java.sql.*" %>
<%
    String username = (String) session.getAttribute("name");
    String email = (String) session.getAttribute("email");

    if (username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int quizId = Integer.parseInt(request.getParameter("quizId"));
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Start Quiz</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f4f6f8; margin: 0; padding: 20px; }
        h2 { text-align: center; color: #2c3e50; }
        form { max-width: 800px; margin: auto; background: white; padding: 20px; border-radius: 10px;
               box-shadow: 0 2px 8px rgba(0,0,0,0.2); }
        .question {
            margin-bottom: 20px; padding: 15px; border: 1px solid #ddd; border-radius: 8px;
            background: #fafafa;
        }
        .question h3 { margin-bottom: 10px; color: #333; }
        label { display: block; margin: 6px 0; }
        input[type="radio"] { margin-right: 8px; }
        .submit-btn {
            display: block; margin: 20px auto; padding: 12px 24px; background: #3498db; color: white;
            border: none; border-radius: 6px; font-size: 16px; font-weight: bold; cursor: pointer;
        }
        .submit-btn:hover { background: #2980b9; }
    </style>
</head>
<body>
    <h2>Quiz</h2>

    <!-- ✅ Removed userEmail hidden field -->
    <form action="submitQuizServlet" method="post">
        <input type="hidden" name="quizId" value="<%= quizId %>">

        <%
            String url = "jdbc:mysql://localhost:3306/college";
            String un = "root";
            String pwd = "8118";

            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection(url, un, pwd);

                String sql = "SELECT id, question, option_a, option_b, option_c, option_d " +
                             "FROM quiz WHERE quiz_id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setInt(1, quizId);
                ResultSet rs = ps.executeQuery();

                int qno = 1;
                while(rs.next()) {
        %>
            <div class="question">
                <h3>Q<%= qno++ %>. <%= rs.getString("question") %></h3>
                <label><input type="radio" name="answer_<%= rs.getInt("id") %>" value="A"> <%= rs.getString("option_a") %></label>
                <label><input type="radio" name="answer_<%= rs.getInt("id") %>" value="B"> <%= rs.getString("option_b") %></label>
                <label><input type="radio" name="answer_<%= rs.getInt("id") %>" value="C"> <%= rs.getString("option_c") %></label>
                <label><input type="radio" name="answer_<%= rs.getInt("id") %>" value="D"> <%= rs.getString("option_d") %></label>
            </div>
        <%
                }
                con.close();
            } catch(Exception e) {
                out.println("<p style='color:red;'>Error: " + e.getMessage() + "</p>");
            }
        %>

        <button type="submit" class="submit-btn">Submit Quiz</button>
    </form>
</body>
</html>
