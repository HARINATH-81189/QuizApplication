package com.servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;
import java.time.LocalDateTime;

@WebServlet("/QuizServlet")
public class QuizServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("email");
        String userName = (String) session.getAttribute("name");

        if (userEmail == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String url = "jdbc:mysql://localhost:3306/college";
        String un = "root";
        String pwd = "8118";

        int score = 0;
        int total = 0;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, un, pwd);

            // Fetch all quiz questions
            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("SELECT * FROM quiz");

            while (rs.next()) {
                int qId = rs.getInt("id");
                String correctOption = rs.getString("correct_option");

                // Check submitted answer
                String userAnswer = request.getParameter("q" + qId);
                if (userAnswer != null && userAnswer.equalsIgnoreCase(correctOption)) {
                    score++;
                }
                total++;
            }

            // Get student ID
            PreparedStatement psStudent = con.prepareStatement("SELECT id FROM student WHERE email=?");
            psStudent.setString(1, userEmail);
            ResultSet rsStudent = psStudent.executeQuery();
            int studentId = 0;
            if (rsStudent.next()) {
                studentId = rsStudent.getInt("id");
            }

            // Insert result
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO results(student_id, quiz_name, score, date_taken) VALUES (?, ?, ?, NOW())"
            );
            ps.setInt(1, studentId);
            ps.setString(2, "General Quiz");
            ps.setInt(3, score);
            ps.executeUpdate();

            con.close();

            request.setAttribute("score", score);
            request.setAttribute("total", total);

            RequestDispatcher rd = request.getRequestDispatcher("quizResult.jsp");
            rd.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
