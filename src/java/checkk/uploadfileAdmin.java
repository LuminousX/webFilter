/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package checkk;

import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import org.apache.commons.io.FilenameUtils;

import java.io.PrintWriter;
import static java.lang.Math.log;
import java.sql.ResultSet;
import java.sql.SQLException;
import javax.servlet.RequestDispatcher;
import org.apache.jasper.tagplugins.jstl.core.Out;

/**
 *
 *
 *
 * @author Admin
 */
@WebServlet(name = "uploadfileAdmin", urlPatterns = {"/uploadfileAdmin"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class uploadfileAdmin extends HttpServlet {

    /**
     * Name of the directory where uploaded files will be saved, relative to the
     * web application directory.
     */
    private static final String SAVE_DIR = "uploadFiles";
    String filenamebase;
    String fileName;
    String pathfile;

    /**
     * handles file upload
     */
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
        // gets absolute path of the web application
        String appPath = request.getServletContext().getRealPath("");
        // constructs path of the directory to save uploaded file
        String savePath = appPath + File.separator + SAVE_DIR;

        // creates the save directory if it does not exists
        File fileSaveDir = new File(savePath);
        if (!fileSaveDir.exists()) {
            fileSaveDir.mkdir();
        }
        fileName = "";
        for (Part part : request.getParts()) {
            fileName = extractFileName(part);
            // refines the fileName in case it is an absolute path
            fileName = new File(fileName).getName();
            part.write(savePath + File.separator + fileName);
        }

        try {

            filenamebase = FilenameUtils.getBaseName(fileName);
            String strfile = fileSaveDir.toString();
            pathfile = strfile.replace('\\', '/');

            Class.forName("org.mariadb.jdbc.Driver");
            Connection con;

            con = DriverManager.getConnection("jdbc:mariadb://localhost:3308/svcsbia1",
                    "root", "password");

            Statement st = con.createStatement();
            PrintWriter out = response.getWriter();
            if (getExtension(fileName).equals("csv")) {
                if (checkImportFileDuplicate() == true) {
                    // replace table
                    checktableDate();
                    // request.setAttribute("err", "update successful");
                    //  RequestDispatcher rd = request.getRequestDispatcher("/adminpage.jsp");
                    //  rd.forward(request, response);

                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('update successful');");
                    out.println("location='adminpage.jsp';");
                    out.println("</script>");
                } else {
                    // create table                    
                    //   request.setAttribute("err", "upload successfull");
                    //  RequestDispatcher rd = request.getRequestDispatcher("/adminpage.jsp");
                    //  rd.forward(request, response);
                    checktableDate();
                    out.println("<script type=\"text/javascript\">");
                    out.println("alert('upload successful');");
                    out.println("location='adminpage.jsp';");
                    out.println("</script>");
                }
            } else {
                // request.setAttribute("err", "upload failed");
                // RequestDispatcher rd = request.getRequestDispatcher("/adminpage.jsp");
                // rd.forward(request, response);

                out.println("<script type=\"text/javascript\">");
                out.println("alert('upload failed');");
                out.println("location='adminpage.jsp';");
                out.println("</script>");
            }

            con.close();
            st.close();

            // request.setAttribute("message", "Upload has been done successfully! >>> " + pathfile + "/" + filenamebase + "  " );
            // getServletContext().getRequestDispatcher("/adminpage.jsp").forward(
            //        request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length() - 1);
            }
        }
        return "";
    }

    public void checktableDate() throws ClassNotFoundException, SQLException {

        Class.forName("org.mariadb.jdbc.Driver");
        Connection con;

        con = DriverManager.getConnection("jdbc:mariadb://localhost:3308/date_table",
                "root", "password");

        Statement st = con.createStatement();

        ResultSet rs = st.executeQuery("select * from table_date where name='" + filenamebase + "'");
        if (rs.next()) {
            // replace data
            st.executeUpdate("update table_date set Date=now() where name='" + filenamebase + "';");
        } else {
            // create data
            st.executeUpdate("Insert into table_date (name,Date) values ('" + filenamebase + "' , now());");
        }

        con.close();
        st.close();
    }

    public String getExtension(String f) {
        String ext = null;
        int i = f.lastIndexOf('.');

        if (i > 0 && i < f.length() - 1) {
            ext = f.substring(i + 1).toLowerCase();
        }
        return ext;
    }

    public Boolean checkImportFileDuplicate() throws ClassNotFoundException, SQLException {
        boolean checkDuplicate = false;
        Class.forName("org.mariadb.jdbc.Driver");
        Connection con;

        con = DriverManager.getConnection("jdbc:mariadb://localhost:3308/svcsbia1",
                "root", "password");

        Statement st = con.createStatement();

        ResultSet rs = st.executeQuery("show tables where tables_in_svcsbia1='" + filenamebase + "'");

        if (rs.next()) {
            // replace table

            String dropTable = "drop table " + filenamebase;
            st.executeUpdate(dropTable);

            String createtable = "create table " + filenamebase + " (id int primary key auto_increment, Vm varchar(200), Powerstate varchar(200), DNS_Name varchar(200), CPUs varchar(20), Memory varchar(200), NICs varchar(20), Disks varchar(200), Network_1 varchar(200), Resource_pool varchar(200), Provisioned_MB varchar(200), In_Use_MB varchar(200), Path varchar(200),  Annotation TEXT, Cluster varchar(200) , Host varchar(100));";
            String upload = "load data local infile '" + pathfile + "/" + fileName + "' into table " + filenamebase + " fields terminated by ',' enclosed by '\"' lines terminated by '\n' ignore 1 lines (@col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23,@col24,@col25,@col26,@col27,@col28,@col29,@col30,@col31,@col32,@col33,@col34,@col35,@col36,@col37,@col38,@col39,@col40,@col41,@col42,@col43,@col44,@col45,@col46,@col47,@col48,@col49,@col50,@col51,@col52,@col53,@col54,@col55,@col56,@col57,@col58,@col59,@col60,@col61,@col62) set Vm=@col1, Powerstate=@col2,  DNS_Name=@col5, CPUs=@col13, Memory=@col14, NICs=@col15, Disks=@col16,  Network_1=@col17, Resource_pool=@col23, Provisioned_MB=@col31, In_Use_MB=@col32, Path=@col49, Annotation=@col50, Cluster=@col53, Host=@col54;";
            st.executeUpdate(createtable);
            st.executeUpdate(upload);

            checkDuplicate = true;
        } else {
            // create table

            String createtable = "create table " + filenamebase + " (id int primary key auto_increment, Vm varchar(200), Powerstate varchar(200), DNS_Name varchar(200), CPUs varchar(20), Memory varchar(200), NICs varchar(20), Disks varchar(200), Network_1 varchar(200), Resource_pool varchar(200), Provisioned_MB varchar(200), In_Use_MB varchar(200), Path varchar(200),  Annotation TEXT, Cluster varchar(200) , Host varchar(100));";
            String upload = "load data local infile '" + pathfile + "/" + fileName + "' into table " + filenamebase + " fields terminated by ',' enclosed by '\"' lines terminated by '\n' ignore 1 lines (@col1,@col2,@col3,@col4,@col5,@col6,@col7,@col8,@col9,@col10,@col11,@col12,@col13,@col14,@col15,@col16,@col17,@col18,@col19,@col20,@col21,@col22,@col23,@col24,@col25,@col26,@col27,@col28,@col29,@col30,@col31,@col32,@col33,@col34,@col35,@col36,@col37,@col38,@col39,@col40,@col41,@col42,@col43,@col44,@col45,@col46,@col47,@col48,@col49,@col50,@col51,@col52,@col53,@col54,@col55,@col56,@col57,@col58,@col59,@col60,@col61,@col62) set Vm=@col1, Powerstate=@col2,  DNS_Name=@col5, CPUs=@col13, Memory=@col14, NICs=@col15, Disks=@col16,  Network_1=@col17, Resource_pool=@col23, Provisioned_MB=@col31, In_Use_MB=@col32, Path=@col49, Annotation=@col50, Cluster=@col53, Host=@col54;";
            st.executeUpdate(createtable);
            st.executeUpdate(upload);

            checkDuplicate = false;
        }
        con.close();
        st.close();

        return checkDuplicate;
    }

}
