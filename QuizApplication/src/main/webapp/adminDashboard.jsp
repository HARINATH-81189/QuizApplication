<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>

<%
    // Prevent direct access without login
    String username = (String) session.getAttribute("name");
    String role = (String) session.getAttribute("role");

    if (username == null || role == null || !"admin".equalsIgnoreCase(role)) {
        response.sendRedirect("login.jsp"); // only admins allowed
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <style>
        body {
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: #f4f6f9;
        }

        /* Navbar */
        .navbar {
            background: #2c3e50;
            color: white;
            padding: 12px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .navbar .logo {
            font-size: 1.3rem;
            font-weight: bold;
        }

        .navbar .nav-links {
            display: flex;
            align-items: center;
        }

        .navbar .nav-links .username {
            margin-right: 20px;
        }

        .navbar .nav-links a {
            color: white;
            text-decoration: none;
            padding: 6px 14px;
            border-radius: 5px;
            background: #e74c3c;
            transition: 0.3s;
        }

        .navbar .nav-links a:hover {
            background: #c0392b;
        }

        /* Container */
        .container {
            max-width: 1000px;
            margin: 40px auto;
            text-align: center;
        }

        .card {
            background: white;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }

        .card h2 {
            color: #2c3e50;
            margin-bottom: 15px;
        }

        .actions {
            display: flex;
            justify-content: center;
            gap: 20px;
            margin-top: 20px;
        }

        .actions .btn {
            display: inline-block;
            padding: 12px 20px;
            background: #3498db;
            color: white;
            font-weight: bold;
            border-radius: 6px;
            text-decoration: none;
            transition: 0.3s;
        }

        .actions .btn:hover {
            background: #2980b9;
        }

        /* Leaderboard */
        table {
            width: 100%;
            margin: 20px auto;
            border-collapse: collapse;
            background: white;
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
        }
        th, td {
            padding: 12px;
            border: 1px solid #ddd;
            text-align: center;
        }
        th {
            background: #2c3e50;
            color: white;
        }
        tr:nth-child(even) {
            background: #f2f2f2;
        }
    </style>
</head>
<body>

    <!-- Navbar -->
    <div class="navbar">
        <div class="logo">🛠️ Admin Dashboard</div>
        <div class="nav-links">
            <span class="username">Welcome, <%= username %></span>
            <a href="logout.jsp">Logout</a>
        </div>
    </div>

    <!-- Main Section -->
    <div class="container">
        <div class="card">
            <h2>Manage System</h2>
            <div class="actions">
                <a href="manageStudents.jsp" class="btn">👥 Manage Students</a>
                <a href="manageQuizzes.jsp" class="btn">📚 Manage Quizzes</a>
                <a href="results.jsp" class="btn">📊 View Results</a>
            </div>
        </div>

        <!-- Leaderboard -->
        <div class="card">
            <h2>🏆 Leaderboard</h2>
            <table>
                <tr>
                    <th>Rank</th>
                    <th>Student Name</th>
                    <th>Quiz</th>
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

                        // Leaderboard query: get students with their scores (ordered)
                        String sql = "SELECT s.name, r.quiz_name, r.score, r.date_taken " +
                                     "FROM results r " +
                                     "JOIN student s ON r.student_id = s.id " +
                                     "ORDER BY r.score DESC, r.date_taken ASC";
                        PreparedStatement ps = con.prepareStatement(sql);
                        ResultSet rs = ps.executeQuery();

                        int rank = 1;
                        while(rs.next()) {
                %>
                <tr>
                    <td><%= rank++ %></td>
                    <td><%= rs.getString("name") %></td>
                    <td><%= rs.getString("quiz_name") %></td>
                    <td><%= rs.getInt("score") %></td>
                    <td><%= rs.getTimestamp("date_taken") %></td>
                </tr>
                <%
                        }
                        con.close();
                    } catch(Exception e) {
                        out.println("<tr><td colspan='5' style='color:red;'>Error: " + e.getMessage() + "</td></tr>");
                    }
                %>
            </table>
        </div>
    </div>

</body>
</html>
