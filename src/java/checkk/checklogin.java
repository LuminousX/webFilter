/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package checkk;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author PNASOU01
 */
@WebServlet(name = "checklogin", urlPatterns = {"/checklogin"})
public class checklogin extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userid = request.getParameter("uname");
        String pwd = request.getParameter("pass");

        try {
            Class.forName("org.mariadb.jdbc.Driver");
            Connection con;

            con = DriverManager.getConnection("jdbc:mariadb://localhost:3308/login_db",
                    "root", "password");

            Statement st = con.createStatement();
            ResultSet rs;

            // check username and password. 
            rs = st.executeQuery("select * from login where username='" + userid + "' and password='" + pwd + "'");

            if (rs.next()) {
                // check if role is admin.
                rs = st.executeQuery("select * from login where username='" + userid + "' and password='" + pwd + "' and role ='Admin'");
                if (rs.next()) {
                    // send seesion and og to adminpage.
                    HttpSession session = request.getSession();
                    session.setAttribute("role", "admin");
                    response.sendRedirect("adminpage.jsp");
                } else {
                    //send session and go to userpage.
                    HttpSession session = request.getSession();
                    session.setAttribute("role", "user");
                    response.sendRedirect("userpage.jsp");
                }
            } else {
                // alert error message.
                request.setAttribute("errMsg", "username or password are incorrect");
                RequestDispatcher rd = request.getRequestDispatcher("/login.jsp");
                rd.forward(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();

        }
    }
}
