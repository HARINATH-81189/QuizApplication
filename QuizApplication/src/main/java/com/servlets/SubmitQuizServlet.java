package com.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.util.HashMap;

@WebServlet("/submitQuizServlet")
public class SubmitQuizServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        String userEmail = (session != null) ? (String) session.getAttribute("email") : null;

        int quizId = Integer.parseInt(request.getParameter("quizId"));

        String url = "jdbc:mysql://localhost:3306/college";
        String un = "root";
        String pwd = "8118";

        int score = 0, total = 0;

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, un, pwd);

            // Step 1: Get student_id
            int studentId = -1;
            String studentSql = "SELECT id FROM student WHERE email=?";
            PreparedStatement psStudent = con.prepareStatement(studentSql);
            psStudent.setString(1, userEmail);
            ResultSet rsStudent = psStudent.executeQuery();
            if (rsStudent.next()) {
                studentId = rsStudent.getInt("id");
            } else {
                throw new Exception("Student not found for email: " + userEmail);
            }

            // Step 2: Get quiz name
            String quizName = "";
            String quizNameSql = "SELECT quiz_name FROM quiz_master WHERE quiz_id=?";
            PreparedStatement psQuiz = con.prepareStatement(quizNameSql);
            psQuiz.setInt(1, quizId);
            ResultSet rsQuiz = psQuiz.executeQuery();
            if (rsQuiz.next()) {
                quizName = rsQuiz.getString("quiz_name");
            }

            // Step 3: Fetch correct answers
            String sql = "SELECT id, correct_option FROM quiz WHERE quiz_id=?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setInt(1, quizId);
            ResultSet rs = ps.executeQuery();

            HashMap<Integer, String> correctAnswers = new HashMap<>();
            while (rs.next()) {
                correctAnswers.put(rs.getInt("id"), rs.getString("correct_option"));
            }

            // Step 4: Compare submitted answers
            for (Integer questionId : correctAnswers.keySet()) {
                total++;
                String submitted = request.getParameter("answer_" + questionId);
                if (submitted != null && submitted.equalsIgnoreCase(correctAnswers.get(questionId))) {
                    score++;
                }
            }

            // Step 5: Insert into results
            String insertSql = "INSERT INTO results (student_id, quiz_name, score) VALUES (?, ?, ?)";
            PreparedStatement psInsert = con.prepareStatement(insertSql);
            psInsert.setInt(1, studentId);
            psInsert.setString(2, quizName);
            psInsert.setInt(3, score);
            psInsert.executeUpdate();

            con.close();

            // Step 6: Show success message
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<html><head><title>Quiz Submitted</title></head>");
            out.println("<body style='font-family:Arial; text-align:center; padding-top:50px;'>");
            out.println("<h2 style='color:green;'>✅ Quiz submitted successfully!</h2>");
            out.println("<p><b>Quiz:</b> " + quizName + "</p>");
            out.println("<p><b>Your Score:</b> " + score + " / " + total + "</p>");
            out.println("<div style='margin-top:20px;'>");
            out.println("<a href='takeQuiz.jsp' style='padding:10px 20px; background:#3498db; color:white; text-decoration:none; border-radius:6px;'>Back to Quizzes</a>");
            out.println("</div>");
            out.println("</body></html>");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
