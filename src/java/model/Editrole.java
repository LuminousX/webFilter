/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

/**
 *
 * @author Admin
 */
public class Editrole {

    private String role;
    private String username;

    private static final String host = "10.69.4.11";
    private static final String user_host = "root";
    private static final String pass_host = "password";

    public Editrole(String role, String username) {
        this.role = role;
        this.username = username;
    }

    public boolean getEditrole() {
        boolean status = false;
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            Connection con;

            con = DriverManager.getConnection("jdbc:mariadb://" + host + "/login_db",
                    user_host, pass_host);

            Statement st = con.createStatement();
            ResultSet rs;

            rs = st.executeQuery("select * from login where username='" + username + "'");

            if (rs.next()) {
                st.executeUpdate("update login set role='" + role + "' where username='" + username + "'");
                status = true;
            }

            con.close();
            st.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

}
