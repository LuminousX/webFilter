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
public class Login {

    private String username;
    private String password;
    private String role;

    private static final String host = "localhost:3308";
    private static final String user_host = "root";
    private static final String pass_host = "password";

    public Login(String username, String password) {
        this.username = username;
        this.password = password;
    }

    public String getlogin() {
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            Connection con;

            con = DriverManager.getConnection("jdbc:mariadb://" + host + "/login_db",
                    user_host, pass_host);

            Statement st = con.createStatement();
            ResultSet rs;

            // check username and password. 
            rs = st.executeQuery("select * from login where username='" + username + "' and password='" + password + "'");

            if (rs.next()) {
                // check if role is admin.
                rs = st.executeQuery("select * from login where username='" + username + "' and password='" + password + "' and role ='Admin'");
                if (rs.next()) {
                    // send seesion and og to adminpage.                    
                    role = "admin";
                } else {
                    //send session and go to userpage.
                    role = "user";
                }
            } else {
                // alert error message.
                role = "error";
            }

            con.close();
            st.close();
        } catch (Exception e) {
            e.printStackTrace();

        }
        return role;
    }

}
