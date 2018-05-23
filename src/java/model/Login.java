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
    private String role = "error";

    private static final String host = "10.69.4.11";
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
            TableDate tableDate = new TableDate();

            rs = st.executeQuery("show tables where Tables_in_login_db='login'");
            if (rs.next()) {
                rs = st.executeQuery("select * from login where role='Super Admin';");
                if (rs.next()) {
                    role = getChecklogin();
                    tableDate.getCreatetableDate();
                } else {
                    st.executeUpdate("insert into login (username,password,e_mail,firstname,lastname,date,role) values ('admin','password','panjapon@hotmail.com','panjapon','nasoun',now(),'Super Admin');");
                    role = getChecklogin();
                    tableDate.getCreatetableDate();
                }
            } else {
                st.executeUpdate("create table login (username varchar(25) primary key, password varchar(25), e_mail varchar(50), firstname varchar(20), lastname varchar(20), date DATE, role varchar(15));");
                st.executeUpdate("insert into login (username,password,e_mail,firstname,lastname,date,role) values ('admin','password','panjapon@hotmail.com','panjapon','nasoun',now(),'Super Admin');");
                role = getChecklogin();
                tableDate.getCreatetableDate();
            }

            con.close();
            st.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return role;
    }

    private String getChecklogin() {

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

                // check role is Super admin.
                rs = st.executeQuery("select * from login where username='" + username + "' and password='" + password + "' and role ='Super Admin'");
                if (rs.next()) {
                    con.close();
                    st.close();
                    return role = "super admin";
                }

                // check role is admin.                
                rs = st.executeQuery("select * from login where username='" + username + "' and password='" + password + "' and role ='Admin'");
                if (rs.next()) {
                    role = "admin";
                } else {
                    role = "user";
                }
            } else {
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
