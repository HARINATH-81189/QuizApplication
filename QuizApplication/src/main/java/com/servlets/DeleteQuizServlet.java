package com.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;

@WebServlet("/deleteQuizServlet")
public class DeleteQuizServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int quizId = Integer.parseInt(request.getParameter("quizId"));

        String url = "jdbc:mysql://localhost:3306/college";
        String un = "root";
        String pwd = "8118";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, un, pwd);

            // because of ON DELETE CASCADE, deleting quiz_master removes quiz questions
            PreparedStatement ps = con.prepareStatement("DELETE FROM quiz_master WHERE quiz_id=?");
            ps.setInt(1, quizId);

            int row = ps.executeUpdate();
            con.close();

            if (row > 0) {
                response.sendRedirect("manageQuizzes.jsp?status=deleted");
            } else {
                response.sendRedirect("manageQuizzes.jsp?status=failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
