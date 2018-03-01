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

            rs = st.executeQuery("select * from login where username='" + userid + "' and password='" + pwd + "'");
           
            if (rs.next()) {
                  rs = st.executeQuery("select * from login where username='" + userid + "' and password='" + pwd + "' and role ='Admin'");
                if (rs.next()){
                    
                    HttpSession session = request.getSession();
                    session.setAttribute("username", userid);
                    response.sendRedirect("adminpage.jsp");

                } else {
                    HttpSession session = request.getSession();
                    session.setAttribute("username", userid);
                    response.sendRedirect("userpage.jsp");

                }
            } else {

                //    HttpSession session = request.getSession();
                //   session.setAttribute("wrong_uname_pass", "1");
                //   response.sendRedirect("login.jsp");
                
                  request.setAttribute("errMsg", "username or password are incorrect");
                  RequestDispatcher rd = request.getRequestDispatcher("/login.jsp");
                  rd.forward(request, response);              
           
                  
                //  request.setAttribute("message", "a");
                //  getServletContext().getRequestDispatcher("/login.jsp").forward(
                //          request, response);
                //   response.sendRedirect("login.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();

        }
    }
}
