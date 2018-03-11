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
import model.Register;

/**
 *
 * @author Admin
 */
@WebServlet(name = "RegisterServlet", urlPatterns = {"/RegisterServlet"})
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {

            String user = request.getParameter("usernamesignup");
            String pwd = request.getParameter("passwordsignup");
            String fname = request.getParameter("namesignup");
            String lname = request.getParameter("surnamesignup");
            String email = request.getParameter("emailsignup");
            String re_pwd = request.getParameter("passwordsignup_confirm");
            RequestDispatcher rd;
            Register register = new Register();
            String regis = register.getRegister(user, pwd, re_pwd, fname, lname, email);

            switch (regis) {
                case "successful":
                    response.sendRedirect("login.jsp");
                    break;
                case "username":
                    request.setAttribute("errMsg", "username has been taken.");
                    rd = request.getRequestDispatcher("/regis.jsp");
                    rd.forward(request, response);
                    break;
                case "password":
                    request.setAttribute("errPassword", "character should more than 6.");
                    rd = request.getRequestDispatcher("/regis.jsp");
                    rd.forward(request, response);
                    break;
                case "confirm_password":
                    request.setAttribute("errConfirmpassword", "password don't match.");
                    rd = request.getRequestDispatcher("/regis.jsp");
                    rd.forward(request, response);
                    break;
                case "email":
                    request.setAttribute("errMail", "email has been taken.");
                    rd = request.getRequestDispatcher("/regis.jsp");
                    rd.forward(request, response);
                    break;
                default:

                    break;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
