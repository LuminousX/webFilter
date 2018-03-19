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
public class Register {

    private String username_signup;
    private String password_signup;
    private String password_confirm_signup;
    private String firstname_signup;
    private String lastname_signup;
    private String email;
    public String message = "";

    private static final String host = "localhost:3308";
    private static final String user_host = "root";
    private static final String pass_host = "password";

    public Register(String username_signup, String password_signup, String password_confirm_signup, String firstname_signup, String lastname_signup, String email) {
        this.username_signup = username_signup;
        this.password_signup = password_signup;
        this.password_confirm_signup = password_confirm_signup;
        this.firstname_signup = firstname_signup;
        this.lastname_signup = lastname_signup;
        this.email = email;
    }

    public String getRegister() {

        try {
            Class.forName("org.mariadb.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mariadb://" + host + "/login_db",
                    user_host, pass_host);
            Statement st = con.createStatement();

            ResultSet rs;
            rs = st.executeQuery("show tables where Tables_in_login_db='login';");
            if (rs.next()) {
                message = getCheckRegister();
            } else {
                st.executeUpdate("create table login (username varchar(25) primary key, password varchar(25), e_mail varchar(50), firstname varchar(20), lastname varchar(20), date DATE, role varchar(10));");
                message = getCheckRegister();
            }

            con.close();
            st.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return message;
    }

    private String getCheckRegister() {
        String status_message = "";
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mariadb://" + host + "/login_db",
                    user_host, pass_host);
            Statement st = con.createStatement();

            ResultSet rs;
            rs = st.executeQuery("select * from login where username='" + username_signup + "'");

            // check username duplicate.
            if (!rs.next() && !username_signup.equals("admin")) {

                // check password at least 6.
                if (password_signup.length() > 5) {

                    // check password not same confirm password
                    if (password_signup.equals(password_confirm_signup)) {

                        // check email duplicate. 
                        rs = st.executeQuery("select * from login where e_mail='" + email + "'");
                        if (!rs.next()) {
                            st.executeUpdate("insert into login(username, password, e_mail, firstname, lastname, date, role) values ('" + username_signup + "','" + password_signup + "','" + email + "','" + firstname_signup + "','" + lastname_signup + "', Now(), 'User')");
                            status_message = "successful";
                        } else {
                            // email duplicate.
                            status_message = "email";
                        }
                    } else {
                        // password not same
                        status_message = "confirm_password";
                    }
                } else {
                    // password at least 6.
                    status_message = "password";
                }

            } else {
                // username duplicate.
                status_message = "username";
            }
            con.close();
            st.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return status_message;
    }
}
