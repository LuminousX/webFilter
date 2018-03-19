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
import javax.servlet.http.HttpSession;
import org.apache.commons.io.FilenameUtils;

/**
 *
 * @author Admin
 */
public class Uploadfile {

    private String filenamebase;
    private String fileName;
    private String pathfile;

    private static final String host = "localhost:3308";
    private static final String user_host = "root";
    private static final String pass_host = "password";

    public Uploadfile(String filenamebase, String fileName, String pathfile) {
        this.filenamebase = filenamebase;
        this.fileName = fileName;
        this.pathfile = pathfile;
    }

    public String getUploadfile() {
        String status = "";
        try {

            Class.forName("org.mariadb.jdbc.Driver");
            Connection con;

            con = DriverManager.getConnection("jdbc:mariadb://" + host + "/datafilter",
                    user_host, pass_host);

            Statement st = con.createStatement();

            ResultSet rs;
            // check csv file.
            if (getExtension(fileName).equals("csv")) {
                rs = st.executeQuery("show tables where tables_in_datafilter='" + filenamebase + "'");

                if (rs.next()) {

                    // replace table
                    String dropTable = "drop table " + filenamebase;
                    st.executeUpdate(dropTable);

                    String createtable = "create table " + filenamebase + " (id int primary key auto_increment, Vm varchar(200), Powerstate varchar(200), DNS_Name varchar(200), CPUs varchar(20), Memory varchar(200), NICs varchar(20), Disks varchar(200), Network_1 varchar(200), Resource_pool varchar(200), Provisioned_MB varchar(200), In_Use_MB varchar(200), Path varchar(200),  Annotation TEXT, Cluster varchar(200) , Host varchar(100));";
                    String upload = "load data local infile '" + pathfile + "/" + fileName + "' into table " + filenamebase + " fields terminated by ',' enclosed by '\"' lines terminated by '\n' ignore 1 lines (@col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23,@col24,@col25,@col26,@col27,@col28,@col29,@col30,@col31,@col32,@col33,@col34,@col35,@col36,@col37,@col38,@col39,@col40,@col41,@col42,@col43,@col44,@col45,@col46,@col47,@col48,@col49,@col50,@col51,@col52,@col53,@col54,@col55,@col56,@col57,@col58,@col59,@col60,@col61,@col62) set Vm=@col1, Powerstate=@col2,  DNS_Name=@col5, CPUs=@col13, Memory=@col14, NICs=@col15, Disks=@col16,  Network_1=@col17, Resource_pool=@col23, Provisioned_MB=@col31, In_Use_MB=@col32, Path=@col49, Annotation=@col50, Cluster=@col53, Host=@col54;";

                    st.executeUpdate(createtable);
                    st.executeUpdate(upload);
                    checktableDate();

                    status = "update";

                } else {

                    // create table
                    String createtable = "create table " + filenamebase + " (id int primary key auto_increment, Vm varchar(200), Powerstate varchar(200), DNS_Name varchar(200), CPUs varchar(20), Memory varchar(200), NICs varchar(20), Disks varchar(200), Network_1 varchar(200), Resource_pool varchar(200), Provisioned_MB varchar(200), In_Use_MB varchar(200), Path varchar(200),  Annotation TEXT, Cluster varchar(200) , Host varchar(100));";
                    String upload = "load data local infile '" + pathfile + "/" + fileName + "' into table " + filenamebase + " fields terminated by ',' enclosed by '\"' lines terminated by '\n' ignore 1 lines (@col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23,@col24,@col25,@col26,@col27,@col28,@col29,@col30,@col31,@col32,@col33,@col34,@col35,@col36,@col37,@col38,@col39,@col40,@col41,@col42,@col43,@col44,@col45,@col46,@col47,@col48,@col49,@col50,@col51,@col52,@col53,@col54,@col55,@col56,@col57,@col58,@col59,@col60,@col61,@col62) set Vm=@col1, Powerstate=@col2,  DNS_Name=@col5, CPUs=@col13, Memory=@col14, NICs=@col15, Disks=@col16,  Network_1=@col17, Resource_pool=@col23, Provisioned_MB=@col31, In_Use_MB=@col32, Path=@col49, Annotation=@col50, Cluster=@col53, Host=@col54;";

                    st.executeUpdate(createtable);
                    st.executeUpdate(upload);
                    checktableDate();

                    status = "upload";
                }

            } else {
                // not csv file.
                status = "failed";
            }

            con.close();
            st.close();

        } catch (Exception e) {
            e.printStackTrace();
        }
        return status;
    }

    private String getExtension(String f) {
        String ext = null;
        int i = f.lastIndexOf('.');

        if (i > 0 && i < f.length() - 1) {
            ext = f.substring(i + 1).toLowerCase();
        }
        return ext;
    }

    private void checktableDate() throws ClassNotFoundException, SQLException {

        Class.forName("org.mariadb.jdbc.Driver");
        Connection con;

        con = DriverManager.getConnection("jdbc:mariadb://" + host + "/date_table",
                user_host, pass_host);

        Statement st = con.createStatement();

        ResultSet rs;

        rs = st.executeQuery("show tables where Tables_in_date_table='table_date';");
        if (rs.next()) {
            rs = st.executeQuery("select * from table_date where name='" + filenamebase + "'");
            if (rs.next()) {
                // replace data
                st.executeUpdate("update table_date set Date=now() where name='" + filenamebase + "';");
            } else {
                // create data
                st.executeUpdate("Insert into table_date (name,Date) values ('" + filenamebase + "' , now());");
            }
        } else {
            st.executeUpdate("create table table_date (id int primary key auto_increment, name TEXT, date DATE);");
            st.executeUpdate("Insert into table_date (name,Date) values ('" + filenamebase + "' , now());");
        }

        con.close();
        st.close();
    }
}
