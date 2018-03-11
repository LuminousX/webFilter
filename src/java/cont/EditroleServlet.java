/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cont;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import model.Editrole;

/**
 *
 * @author Admin
 */
@WebServlet(name = "EditroleServlet", urlPatterns = {"/EditroleServlet"})
public class EditroleServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String role = request.getParameter("roles");
        String username = request.getParameter("edit");

        Editrole editrole = new Editrole(role, username);
        editrole.getEditrole();

    }

}
