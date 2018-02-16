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
@WebServlet(name = "droptable", urlPatterns = {"/droptable"})
public class droptable extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Class.forName("com.mysql.jdbc.Driver");
            Connection con;

            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/svcsbia1",
                    "root", "kanomroo");
            String tx = request.getParameter("text");
            Statement st = con.createStatement();
            ResultSet rs;

            PrintWriter out = response.getWriter();
            if (!tx.equals("")) {
                rs = st.executeQuery("show tables where tables_in_svcsbia1='" + tx + "';");
                if (rs.next()) {
                    st.executeUpdate("drop table " + tx);
                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('remove table successful');");
                    out.println("location='adminpage.jsp';");
                    out.println("</script>");
                   
                } else {
                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('remove table failed');");
                    out.println("location='adminpage.jsp';");
                    out.println("</script>");
               
                }

            } else {
                out.println("<script type=\"text/javascript\">");
                out.println("alert('please input name table');");
                out.println("location='adminpage.jsp';");
                out.println("</script>");

            }

        } catch (Exception e) {
            e.printStackTrace();

        }

    }

}
