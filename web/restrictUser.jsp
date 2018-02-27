<%-- 
    Document   : login
    Created on : Jan 19, 2018, 11:16:53 AM
    Author     : PNASOU01
--%>


<%@ page import="java.sql.DriverManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.sql.SQLException" %>
<%@ page import="java.sql.Statement" %>
<%@ page import="java.sql.Connection" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page errorPage="errorpage.jsp" %> 
<%@page import="checkk.droptable"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Filter</title>
        <link href="css/stylehead.css" rel="stylesheet" type="text/css">
        <script type="text/javascript" src="js/jquery-3.3.1.min.js"></script>
        <script type="text/javascript" src="js/jquery.table2excel.js"></script>

        <%
            if (session.getAttribute("username") == null) {
                response.sendRedirect("login.jsp");
            }
        %>

        <%--
                <script>
                    function downloadCSV(csv, filename) {
                        var csvFile;
                        var downloadLink;
                        csvFile = new Blob([csv], {type: "text/csv"});
                        downloadLink = document.createElement("a");
                        downloadLink.download = filename;
                        downloadLink.href = window.URL.createObjectURL(csvFile);
                        downloadLink.style.display = "none";
                        document.body.appendChild(downloadLink);
                        downloadLink.click();
                    }

            function exportTableToCSV(filename) {
                var csv = [];
                var rows = document.querySelectorAll("table tr");
                for (var i = 0; i < rows.length; i++) {
                    var row = [], cols = rows[i].querySelectorAll("td, th");
                    for (var j = 0; j < cols.length; j++)
                        row.push(cols[j].innerText);
                    csv.push(row.join(","));
                }
                downloadCSV(csv.join("\n"), filename);
            }
        </script>
        --%>
        <script>
            //filter search table
            function myFunction() {

                // Declare variables 
                var input, filter, table, tr, td, i;
                input = document.getElementById("myInput");
                filter = input.value.toUpperCase();
                table = document.getElementById("tabletr");
                tr = table.getElementsByTagName("tr");
                // Loop through all table rows, and hide those who don't match the search query
                for (i = 0; i < tr.length; i++) {
                    td = tr[i].getElementsByTagName("td")[0];
                    if (td) {
                        if (td.innerHTML.toUpperCase().indexOf(filter) > -1) {
                            tr[i].style.display = "";
                        } else {
                            tr[i].style.display = "none";
                        }
                    }
                }
            }

        </script>

        <script>
            // Run on page load
            window.onload = function () {

                // If sessionStorage is storing default values (ex. name), exit the function and do not restore data

                var search = sessionStorage.getItem('search');
                if (search !== null)
                    $('#myInput').val(search);
                sessionStorage.removeItem('search');

            }
            // Before refreshing the page, save the form data to sessionStorage
            window.onbeforeunload = function () {
                sessionStorage.setItem("search", $('#myInput').val());
            }
        </script>


        <style>
            div.relative {
                position: relative;
                width: 1366px;
            } 

            div.absolute {
                position: absolute;
                right: 0;
                width: 100%;
            }
        </style>

        <script>
            //filter search table
            function myFunction() {

                // Declare variables 
                var input, filter, table, tr, td, i;
                input = document.getElementById("myInput");
                filter = input.value.toUpperCase();
                table = document.getElementById("tabletr");
                tr = table.getElementsByTagName("tr");
                // Loop through all table rows, and hide those who don't match the search query
                for (i = 0; i < tr.length; i++) {
                    td = tr[i].getElementsByTagName("td")[0];
                    if (td) {
                        if (td.innerHTML.toUpperCase().indexOf(filter) > -1) {
                            tr[i].style.display = "";
                        } else {
                            tr[i].style.display = "none";
                        }
                    }
                }
            }

        </script>

        <script>
            // Run on page load
            window.onload = function () {

                // If sessionStorage is storing default values (ex. name), exit the function and do not restore data

                var search = sessionStorage.getItem('search');
                if (search !== null)
                    $('#myInput').val(search);
                sessionStorage.removeItem('search');

            }
            // Before refreshing the page, save the form data to sessionStorage
            window.onbeforeunload = function () {
                sessionStorage.setItem("search", $('#myInput').val());
            }
        </script>
    </head>
    <body style="background: #E0F2F1">

        <%! ResultSet rsss;%>
        <form action="restrictUser.jsp" method="post">  
            <header> 
                <%-- <a href="mainpage.jsp" class="active">Home</a> --%>

                <nav> 
                    <ul>                        
                        <li> <input autocomplete="off" type = "text" name="myInput" onkeyup="myFunction()" id="myInput"  placeholder=" Search for name.."/> </li>
                        <li><a href="checklogout">Log Out</a></li>
                    </ul>
                </nav>

            </header>

            <!-- ################################################################################################ -->

            <br><br><br><br>


        </form>  



        <br><br>

        <div class="relative">
            <div class="absolute">       
                <strong>Manage User</strong>
            </div>
        </div> 

        <br><br>
        <div>    
            <table id="tabletr" class="responstable" width="100%">
                <tr>
                    <th width="150">Username</th>          
                    <th width="200">Name</th>          
                    <th width="90">Date</th>
                    <th width="150">Role</th>
                    <th width="90">???</th>


                </tr>

                <%  try {
                        Class.forName("org.mariadb.jdbc.Driver").newInstance();
                        Connection con = DriverManager.getConnection("jdbc:mariadb://localhost:3308/login_db",
                                "root", "password");
                        Statement st = con.createStatement();
                        ResultSet rs;

                        rs = st.executeQuery("select * from login");
                        while (rs.next()) {

                %>
                <tr>                    
                    <td><%=rs.getString("username")%></td>
                    <td><%=rs.getString("name")%></td>
                    <td><%=rs.getString("date")%></td>
                    <td><%=rs.getString("role")%></td>
                    <td><button id="editRole" type="submit" onclick="edit()" style="float: center" ><img src="images/edit.png" width="30px" height= "30px"></button></td>
                </tr>

                <%  }
                        con.close();
                        rs.close();
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                %>
            </table>      
        </div>

        <style>
            .upload-btn-wrapper {
                position: relative;
                overflow: hidden;
                display: inline-block;
            }

            .btn {
                border: 2px solid gray;
                color: gray;
                background-color: pink;
                padding: 7px 18px;
                border-radius: 8px;
                font-size: 14px;
                font-weight: bold;
            }

            .upload-btn-wrapper input[type=file] {
                font-size: 100px;
                position: absolute;
                left: 0;
                top: 0;
                opacity: 0;
            }
        </style>

        <style>
            .responstable {     
                text-align: center;
                margin: 1em 0;
                width: 100%;
                overflow: hidden;
                background: #FAFAFA;
                color: #024457;
                border-radius: 5px;
                border: 1px solid #167F92;
            }
            .responstable tr {
                text-align: center;
                border: 1px solid #D9E4E6;
            }
            .responstable tr:nth-child(odd) {
                text-align: center;
                background-color: #E0E0E0;
            }
            .responstable th {                
                display: none;
                border: 1px solid #FFF;
                background-color: #167F92;
                color: #FFF;
                padding: 0em;
                text-align: center;
            }
            .responstable th:first-child {
                display: table-cell;
                text-align: center;
            }
            .responstable th:nth-child(2) {
                display: table-cell;
                text-align: center;

            }
            .responstable th:nth-child(2) span {
                text-align: center;
                display: none;                
            }
            .responstable th:nth-child(2):after {
                content: attr(data-th);
                text-align: center;
            }
            @media (min-width: 480px) {
                .responstable th:nth-child(2) span {
                    text-align: center;
                    display: block;
                }
                .responstable th:nth-child(2):after {
                    display: none;
                    text-align: center;
                }
            }
            .responstable td {
                text-align: center;
                display: block;
                word-wrap: break-word;
                max-width: 100em;
            }
            .responstable td:first-child {
                text-align: center;
                display: table-cell;
                text-align: center;
                border-right: 1px solid #D9E4E6;
            }
            @media (min-width: 480px) {
                .responstable td {
                    text-align: center;
                    border: 1px solid #D9E4E6;
                }
            }
            .responstable th, .responstable td {
                text-align: center;
                margin: .5em 1em;
            }
            @media (min-width: 480px) {
                .responstable th, .responstable td {
                    display: table-cell;
                    text-align: center;
                    padding: 1em;
                }
            }

            body {
                padding: 0 .1em;
                font-family: Arial, sans-serif;
                color: #024457;
                background: #f2f2f2;
            }

            h1 {
                font-family: Verdana;
                font-weight: normal;
                color: #024457;
            }
            h1 span {
                color: #167F92;
            }

        </style>
        <br>   

    </body>
</html>
