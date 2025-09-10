package com.servlets;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Servlet implementation class LoginServlet
 */
@WebServlet("/loginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {

        Connection con = null;

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        HttpSession session = request.getSession();
        RequestDispatcher dispatcher = null;

        String url = "jdbc:mysql://localhost:3306/college";
        String un = "root";
        String pwd = "8118";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(url, un, pwd);

            PreparedStatement pstmt = con.prepareStatement(
                "SELECT * FROM student WHERE email=? AND password=?;"
            );
            pstmt.setString(1, email);
            pstmt.setString(2, password);

            ResultSet res = pstmt.executeQuery();
            if (res.next()) {
                // ✅ Save user details in session
                session.setAttribute("name", res.getString("name"));
                session.setAttribute("email", res.getString("email"));
                session.setAttribute("mobile", res.getString("mobile"));
                session.setAttribute("role", res.getString("role")); // NEW

                // ✅ Redirect based on role
                if ("admin".equalsIgnoreCase(res.getString("role"))) {
                    dispatcher = request.getRequestDispatcher("adminDashboard.jsp");
                } else {
                    dispatcher = request.getRequestDispatcher("index.jsp");
                }

            } else {
                request.setAttribute("status", "failed");
                dispatcher = request.getRequestDispatcher("login.jsp");
            }

            dispatcher.forward(request, response);

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }
}
