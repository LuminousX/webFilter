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
import model.Droptable;

/**
 *
 * @author Admin
 */
@WebServlet(name = "DroptableServlet", urlPatterns = {"/DroptableServlet"})
public class DroptableServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String tableName = request.getParameter("nametable");

        Droptable droptable = new Droptable(tableName);
        boolean status = droptable.getDroptable();
        if (status) {
            // drop table successful.
            response.sendRedirect("adminpage.jsp");
        } else {
            // tablename null.
            response.sendRedirect("adminpage.jsp");
        }
    }
}
