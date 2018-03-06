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
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 *
 * @author PNASOU01
 */
@WebServlet(name = "editRole", urlPatterns = {"/editRole"})
public class editRole extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String role = request.getParameter("roles");
        String username = request.getParameter("edit");
        PrintWriter out = response.getWriter();

        try {
            Class.forName("org.mariadb.jdbc.Driver");
            Connection con;

            con = DriverManager.getConnection("jdbc:mariadb://localhost:3308/login_db",
                    "root", "password");

            Statement st = con.createStatement();
            ResultSet rs;

            rs = st.executeQuery("select * from login where username='" + username + "'");

            if (rs.next()) {
                st.executeUpdate("update login set role='" + role + "' where username='" + username + "'");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

}
