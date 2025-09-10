package com.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;

@WebServlet("/AddQuizServlet")
public class AddQuizServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String quizIdStr = request.getParameter("quiz_id");
        String question = request.getParameter("question");
        String optionA = request.getParameter("option_a");
        String optionB = request.getParameter("option_b");
        String optionC = request.getParameter("option_c");
        String optionD = request.getParameter("option_d");
        String correctOption = request.getParameter("correct_option");

        String url = "jdbc:mysql://localhost:3306/college";
        String un = "root";
        String pwd = "8118";

        try {
            int quizId = Integer.parseInt(quizIdStr);

            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, un, pwd);

            // 1. Get allowed total questions
            PreparedStatement ps1 = con.prepareStatement("SELECT total_questions FROM quiz_master WHERE quiz_id=?");
            ps1.setInt(1, quizId);
            ResultSet rs1 = ps1.executeQuery();
            int totalQuestions = 0;
            if (rs1.next()) {
                totalQuestions = rs1.getInt("total_questions");
            }

            // 2. Get current count
            PreparedStatement ps2 = con.prepareStatement("SELECT COUNT(*) AS cnt FROM quiz WHERE quiz_id=?");
            ps2.setInt(1, quizId);
            ResultSet rs2 = ps2.executeQuery();
            int addedQuestions = 0;
            if (rs2.next()) {
                addedQuestions = rs2.getInt("cnt");
            }

            if (addedQuestions >= totalQuestions) {
                // Limit reached → don’t insert
                con.close();
                response.sendRedirect("addQuiz.jsp?quizId=" + quizId + "&status=limit_reached");
                return;
            }

            // 3. Insert question
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO quiz(quiz_id, question, option_a, option_b, option_c, option_d, correct_option) VALUES (?,?,?,?,?,?,?)"
            );
            ps.setInt(1, quizId);
            ps.setString(2, question);
            ps.setString(3, optionA);
            ps.setString(4, optionB);
            ps.setString(5, optionC);
            ps.setString(6, optionD);
            ps.setString(7, correctOption);

            int row = ps.executeUpdate();
            con.close();

            if (row > 0) {
                response.sendRedirect("addQuiz.jsp?quizId=" + quizId + "&status=success");
            } else {
                response.sendRedirect("addQuiz.jsp?quizId=" + quizId + "&status=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
