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
import javax.servlet.http.HttpSession;
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

        String tableName = request.getParameter("table_name");

        Droptable droptable = new Droptable(tableName);
        
        String status = droptable.getDroptable();
        HttpSession session = request.getSession();
        
        if (status.equals("successful")) {
            // drop table successful.
            session.setAttribute("delete_table", "successful");
            response.sendRedirect("adminpage.jsp");

        } else {
            // tablename null.
            session.setAttribute("delete_table", "failed");
            response.sendRedirect("adminpage.jsp");
        }        
    }
}
