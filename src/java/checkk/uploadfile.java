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
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 *
 *
 *
 * @author Admin
 */
@WebServlet(name = "uploadfile", urlPatterns = {"/uploadfile"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class uploadfile extends HttpServlet {

    /**
     * Name of the directory where uploaded files will be saved, relative to the
     * web application directory.
     */
    private static final String SAVE_DIR = "uploadFiles";
    String filenamebase;

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
        String fileName = "";
        for (Part part : request.getParts()) {
            fileName = extractFileName(part);
            // refines the fileName in case it is an absolute path
            fileName = new File(fileName).getName();
            part.write(savePath + File.separator + fileName);
        }

        try {

            filenamebase = FilenameUtils.getBaseName(fileName);
            String strfile = fileSaveDir.toString();
            String pathfile = strfile.replace('\\', '/');

            Class.forName("com.mysql.jdbc.Driver");
            Connection con;

            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/svcsbia1",
                    "root", "kanomroo");

            Statement st = con.createStatement();

            String createtable = "create table " + filenamebase + " (Vm varchar(200) primary key, Powerstate varchar(200), DNS_Name varchar(200), CPUs varchar(10), Memory varchar(200), NICs varchar(10), Disks varchar(200), Network_1 varchar(200), Resource_pool varchar(200), Provisioned_MB varchar(200), In_Use_MB varchar(200), Path varchar(200), Cluster varchar(200) , Host varchar(50));";
            String upload = "load data local infile '" + pathfile + "/" + fileName + "' into table " + filenamebase + " fields terminated by ',' enclosed by '\"' lines terminated by '\n' ignore 1 lines (Vm, Powerstate, DNS_Name, CPUs, Memory, NICs, Disks, Network_1, Resource_pool, Provisioned_MB, In_Use_MB, Path, Host , Cluster);";
            st.executeUpdate(createtable);
            st.executeUpdate(upload);

            tableDate();

            con.close();
            st.close();
            // request.setAttribute("message", "Upload has been done successfully! >>> " + pathfile + "/" + filenamebase + "  " );
            getServletContext().getRequestDispatcher("/adminpage.jsp").forward(
                    request, response);
        } catch (Exception e) {
            e.printStackTrace();
        }

    }

    /**
     * Extracts file name from HTTP header content-disposition
     */
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

    public void tableDate() throws ClassNotFoundException, SQLException {

        Class.forName("com.mysql.jdbc.Driver");
        Connection conn;

        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/Date_table",
                "root", "kanomroo");

        Statement stt = conn.createStatement();

        stt.executeUpdate("Insert into table_date (name,Date) values ('" + filenamebase + "' , now());");
        conn.close();
        stt.close();
    }

}
