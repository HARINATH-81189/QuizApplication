package com.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;

@WebServlet("/UpdateQuestionServlet")
public class UpdateQuestionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int questionId = Integer.parseInt(request.getParameter("questionId"));
        int quizId = Integer.parseInt(request.getParameter("quizId"));
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
            Class.forName("com.mysql.cj.jdbc.Driver");
            try (Connection con = DriverManager.getConnection(url, un, pwd)) {

                String sql = "UPDATE quiz SET question=?, option_a=?, option_b=?, option_c=?, option_d=?, correct_option=? WHERE id=?";
                PreparedStatement ps = con.prepareStatement(sql);
                ps.setString(1, question);
                ps.setString(2, optionA);
                ps.setString(3, optionB);
                ps.setString(4, optionC);
                ps.setString(5, optionD);
                ps.setString(6, correctOption);
                ps.setInt(7, questionId);

                int row = ps.executeUpdate();

                if (row > 0) {
                    response.sendRedirect("viewQuestions.jsp?quizId=" + quizId + "&status=updated");
                } else {
                    response.sendRedirect("viewQuestions.jsp?quizId=" + quizId + "&status=failed");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
