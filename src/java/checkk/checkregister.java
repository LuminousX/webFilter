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
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author PNASOU01
 */
@WebServlet(name = "checkregister", urlPatterns = {"/checkregister"})
public class checkregister extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            String user = request.getParameter("usernamesignup");
            String pwd = request.getParameter("passwordsignup");
            String fname = request.getParameter("namesignup");
            String lname = request.getParameter("surnamesignup");
            String email = request.getParameter("emailsignup");
            String re_pwd = request.getParameter("passwordsignup_confirm");

            Class.forName("com.mysql.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/login_DB",
                    "root", "kanomroo");
            Statement st = con.createStatement();
            //ResultSet rs;

            ResultSet rs = st.executeQuery("SELECT * from login where username='" + user + "'");

            if (!rs.next()) {
                // register
              
            //    st.executeUpdate("insert into login(username, password, e_mail, name, surname, date) values ('" + user + "','" + pwd + "','" + email + "','" + fname + "','" + lname + "', Now())");

                response.sendRedirect("login.jsp");
            } else {

                response.sendRedirect("regis.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
