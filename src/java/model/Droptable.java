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
public class Droptable {

    private String tableName;

    private static final String host = "localhost:3308";
    private static final String user_host = "root";
    private static final String pass_host = "password";

    public Droptable(String tableName) {
        this.tableName = tableName;
    }

    public String getDroptable() {
        String status = "successful";
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            Connection con;

            con = DriverManager.getConnection("jdbc:mariadb://" + host + "/datafilter",
                    user_host, pass_host);

            Statement st = con.createStatement();
            ResultSet rs;
            rs = st.executeQuery("show tables where Tables_in_datafilter='" + tableName + "'");
            if (rs.next()) {
                st.executeUpdate("drop table " + tableName);
                dropTableDate();

                status = "successful";
            } else {
                status = "failed";
            }
            con.close();
            st.close();
        } catch (Exception e) {
            e.printStackTrace();

        }
        return status;
    }

    public void dropTableDate() {
        try {
            Class.forName("org.mariadb.jdbc.Driver");
            Connection con;

            con = DriverManager.getConnection("jdbc:mariadb://" + host + "/date_table",
                    user_host, pass_host);
            Statement st = con.createStatement();

            st.executeUpdate("delete from table_date where name='" + tableName + "'");
            con.close();
            st.close();
        } catch (Exception e) {
            e.printStackTrace();

        }

    }

}
