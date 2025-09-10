package com.servlets;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.*;

@WebServlet("/ManageStudentServlet")
public class ManageStudentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        int id = Integer.parseInt(request.getParameter("id"));

        String url = "jdbc:mysql://localhost:3306/college";
        String un = "root";
        String pwd = "8118";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection(url, un, pwd);

            if ("delete".equalsIgnoreCase(action)) {
                PreparedStatement ps = con.prepareStatement("DELETE FROM student WHERE id=?");
                ps.setInt(1, id);
                ps.executeUpdate();
            } else if ("reset".equalsIgnoreCase(action)) {
                PreparedStatement ps = con.prepareStatement("UPDATE student SET password=? WHERE id=?");
                ps.setString(1, "123456"); // default reset password
                ps.setInt(2, id);
                ps.executeUpdate();
            }

            con.close();
            response.sendRedirect("manageStudents.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
