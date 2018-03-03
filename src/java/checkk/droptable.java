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

    String tablename;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Class.forName("org.mariadb.jdbc.Driver");
            Connection con;

            con = DriverManager.getConnection("jdbc:mariadb://localhost:3308/datafilter",
                    "root", "password");
            tablename = request.getParameter("nametable");
            Statement st = con.createStatement();
            ResultSet rs;

            PrintWriter out = response.getWriter();
            if (!tablename.equals("")) {
                rs = st.executeQuery("show tables where tables_in_datafilter='" + tablename + "';");
                if (rs.next()) {
                    st.executeUpdate("drop table " + tablename);
                    dropTableDate();
                    out.println("remove table successful");

                } else {
                    out.println("remove table failed");

                }
            } else {

                out.println("please input name table");
                //  out.println("<script type=\"text/javascript\">");
                //  out.println("alert('please input name table');");
                //   out.println("location='adminpage.jsp';");
                //   out.println("</script>");

            }

        } catch (Exception e) {
            e.printStackTrace();

        }

    }

    public void dropTableDate() {
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            Connection con;

            con = DriverManager.getConnection("jdbc:mariadb://localhost:3308/date_table",
                    "root", "password");
            Statement st = con.createStatement();
            ResultSet rs;

            st.executeUpdate("delete from table_date where name='" + tablename + "'");

        } catch (Exception e) {
            e.printStackTrace();

        }

    }

}
