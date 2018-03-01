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
import javax.servlet.RequestDispatcher;
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

    String email;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            String user = request.getParameter("usernamesignup");
            String pwd = request.getParameter("passwordsignup");
            String fname = request.getParameter("namesignup");
            String lname = request.getParameter("surnamesignup");
            email = request.getParameter("emailsignup");
            String re_pwd = request.getParameter("passwordsignup_confirm");

            Class.forName("org.mariadb.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mariadb://localhost:3308/login_db",
                    "root", "password");
            Statement st = con.createStatement();
            //ResultSet rs;

            ResultSet rs = st.executeQuery("SELECT * from login where username='" + user + "'");

            if (!rs.next()) {
                // register
                if (pwd.length() > 5) {
                    // password at lease 6
                    if (pwd.equals(re_pwd)) {
                        // password not same confirm password
                        if (checkemail()) {
                            //email duplicate
                            st.executeUpdate("insert into login(username, password, e_mail, name, lastname, date, role) values ('" + user + "','" + pwd + "','" + email + "','" + fname + "','" + lname + "', Now(), 'User')");
                            response.sendRedirect("regissuccessful.jsp");
                        } else {
                            request.setAttribute("errMail", "email has been taken.");
                            RequestDispatcher rd = request.getRequestDispatcher("/regis.jsp");
                            rd.forward(request, response);
                        }
                    } else {
                        request.setAttribute("errConfirmpassword", "password don't match.");
                        RequestDispatcher rd = request.getRequestDispatcher("/regis.jsp");
                        rd.forward(request, response);
                    }
                } else {
                    request.setAttribute("errPassword", "character should more than 6.");
                    RequestDispatcher rd = request.getRequestDispatcher("/regis.jsp");
                    rd.forward(request, response);
                }

            } else {
                request.setAttribute("errMsg", "username has been taken.");
                RequestDispatcher rd = request.getRequestDispatcher("/regis.jsp");
                rd.forward(request, response);
                // response.sendRedirect("regis.jsp");
            }

            con.close();
            st.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean checkemail() throws ClassNotFoundException, SQLException {
        boolean check = false;
        Class.forName("org.mariadb.jdbc.Driver");
        Connection con = DriverManager.getConnection("jdbc:mariadb://localhost:3308/login_db",
                "root", "password");
        Statement st = con.createStatement();

        ResultSet rs = st.executeQuery("SELECT * from login where e_mail='" + email + "'");

        if (rs.next()) {
            // duplicate
            check = false;
        } else {
            //not duplicate
            check = true;
        }
        con.close();
        st.close();
        return check;
    }

}
