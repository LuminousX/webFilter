/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package model;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

/**
 *
 * @author Admin
 */
public class TableDate {

    private static final String host = "10.69.4.11";
    private static final String user_host = "root";
    private static final String pass_host = "password";

    public void getCreatetableDate() throws ClassNotFoundException, SQLException {

        Class.forName("org.mariadb.jdbc.Driver");
        Connection con;

        con = DriverManager.getConnection("jdbc:mariadb://" + host + "/date_table",
                user_host, pass_host);

        Statement st = con.createStatement();

        ResultSet rs;
        rs = st.executeQuery("show tables where Tables_in_date_table='table_date';");
        if (rs.next()) {

        } else {
            // create
            st.executeUpdate("create table table_date (id int primary key auto_increment, name TEXT, date DATE);");
        }
        con.close();
        st.close();
    }
}
