/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package cont;

import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import model.Uploadfile;
import org.apache.commons.io.FilenameUtils;

/**
 *
 * @author Admin
 */
@WebServlet(name = "UploadfileServlet", urlPatterns = {"/UploadfileServlet"})
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50)   // 50MB

public class UploadfileServlet extends HttpServlet {

    private static final String SAVE_DIR = "uploadFiles";
    private String filenamebase;
    private String fileName;
    private String pathfile;

    @Override
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

        for (Part part : request.getParts()) {
            fileName = extractFileName(part);
            // refines the fileName in case it is an absolute path
            fileName = new File(fileName).getName();
            part.write(savePath + File.separator + fileName);
        }

        filenamebase = FilenameUtils.getBaseName(fileName);
        String strfile = fileSaveDir.toString();
        pathfile = strfile.replace('\\', '/');

        Uploadfile uploadfile = new Uploadfile(filenamebase, fileName, pathfile);
        String status = uploadfile.getUploadfile();

        HttpSession session = request.getSession();

        switch (status) {
            case "update":
                session.setAttribute("dialog", "Update Successful");
                response.sendRedirect("adminpage.jsp");
                break;
            case "upload":
                session.setAttribute("dialog", "Upload Successful");
                response.sendRedirect("adminpage.jsp");
                break;
            default:
                session.setAttribute("dialog", "Upload Failed");
                response.sendRedirect("adminpage.jsp");
                break;
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
}
