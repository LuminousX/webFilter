/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cont;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import model.Login;

/**
 *
 * @author Admin
 */
@WebServlet(name = "LoginServlet", urlPatterns = {"/LoginServlet"})
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();
        String userid = request.getParameter("uname");
        String pwd = request.getParameter("pass");

        Login login = new Login(userid, pwd);
        String role = login.getlogin();

        switch (role) {
            case "admin":
                // send seesion and login with admin.
                session.setAttribute("role", "Admin");
                response.sendRedirect("adminpage.jsp");
                break;
            case "user":
                //send session and login with user.       
                session.setAttribute("role", "User");
                response.sendRedirect("adminpage.jsp");
                break;
            default:
                // alert error message.
                request.setAttribute("errMsg", "username or password are incorrect");
                RequestDispatcher rd = request.getRequestDispatcher("/login.jsp");
                rd.forward(request, response);
                break;
        }
    }

}
