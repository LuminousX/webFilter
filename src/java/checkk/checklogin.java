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
            Class.forName("com.mysql.jdbc.Driver");
            Connection con;

            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/login_DB",
                    "root", "kanomroo");

            Statement st = con.createStatement();
            ResultSet rs;

            rs = st.executeQuery("select * from login where username='" + userid + "' and password='" + pwd + "'");

            if (rs.next()) {
                if (userid.equals("admin") && pwd.equals("password")) {
                    HttpSession session = request.getSession();
                    session.setAttribute("username", userid);
                    response.sendRedirect("mainpage.jsp");
                } else {
                    HttpSession session = request.getSession();
                    session.setAttribute("username", userid);
                    response.sendRedirect("userpage.jsp");
                }
            } else {
                response.sendRedirect("login.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();

        }
    }

}
