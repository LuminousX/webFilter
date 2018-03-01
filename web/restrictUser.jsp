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
        <title>Filter</title>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">        
        <link href="css/stylehead.css" rel="stylesheet" type="text/css">
        <script type="text/javascript" src="js/jquery-3.3.1.min.js"></script>
        <link href="css/styletable.css" rel="stylesheet" type="text/css">
        <link href="css/styleDialog.css" rel="stylesheet" type="text/css">

        <%
            if (session.getAttribute("username") == null) {
                response.sendRedirect("login.jsp");
            }
        %>

        <script>
            // search Username
            function myFunction() {

                var input, filter, table, tr, td, i;
                input = document.getElementById("myInput");
                filter = input.value.toUpperCase();
                table = document.getElementById("tabletr");
                tr = table.getElementsByTagName("tr");
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




    </head>
    <body style="background: #E0F2F1">


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

        <%-- table --%>
        <div>  
            <table id="tabletr" class="responstable" width="100%">
                <tr>
                    <th>Username</th>          
                    <th>Name</th>  
                    <th>Lastname</th>
                    <th>E-mail</th>
                    <th>Date</th>
                    <th>Role</th>
                    <th>???</th>
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
                    <td><%=rs.getString("lastname")%></td>
                    <td><%=rs.getString("e_mail")%></td>
                    <td><%=rs.getString("date")%></td>
                    <td><%=rs.getString("role")%></td>
                    <td>                      
                        <button type="submit" onclick="showDialog('<%=rs.getString("username")%>');"><img src="images/edit.png" width="30px" height= "30px"></button>
                    </td>
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

        <script>
            var textRole;

            //get text and show dialog
            function showDialog(text) {
                textRole = text;
                document.getElementById("p1").innerHTML = "Username : " + textRole;
                document.getElementById('dialog').style.display = 'block';

            }

            // check value if click save
            $(document).ready(function () {
                $('#btnsave').click(function () {
                    var status = $('input[name=role]:checked', '#dialogForm').val();
                    if (status == "Admin") {
                        admin();
                    } else if (status == "User") {
                        user();
                    } else {
                        alert("Please select role.");
                    }
                });
            });

            // cancel btn
            $(document).ready(function () {
                $('#btncalcel').click(function () {
                    var cancel = document.getElementById('dialog');
                    cancel.style.display = "none";
                });
            });

            // pass value and refresh
            function admin() {
                $.post(
                        "editRole",
                        {edit: textRole, roles: "Admin"},
                        function (result) {
                            location.reload();
                        });
            }

            // pass value and refresh
            function user() {
                $.post(
                        "editRole",
                        {edit: textRole, roles: "User"},
                        function (result) {
                            location.reload();
                        });
            }
        </script>

        <%-- Dialog --%>            
        <div id="dialog" class="modal">
            <form id="dialogForm" class="modal-content animate" method="post">

                <div class="container">
                    <p> Select Role of user. </p>
                    <p id="p1"></p>

                    <table>
                        <tr>
                        </tr>
                        <tr>
                            <td>
                                <input type="radio" name="role" value="Admin"> Admin                                
                            </td>
                        </tr>
                        <tr>
                        </tr>
                        <tr>
                            <td>
                                <input type="radio" name="role" value="User"> User
                            </td>
                        </tr>
                    </table>
                </div>

                <div class="container" style="background-color:#f1f1f1">
                    <button type="button" id="btnsave"  class="cancelbtn">Save</button>  
                    <button type="button" id="btncalcel" onclick="" class="cancelbtn">Cancel</button>
                </div> 

            </form>
        </div>




        <script>
            // Get the modal
            var modal = document.getElementById('dialog');
            // When the user clicks anywhere outside of the modal, close it
            window.onclick = function (event) {
                if (event.target == modal) {
                    modal.style.display = "none";
                }
            }
        </script>

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
                padding : 7px 18px;
                border-radius: 8px;
                font-size: 14px;
                font-weight: bold;
            }

            .upload-btn-wrapper input[type=file] {
                font-size: 100px;
                position : absolute;
                left: 0;
                top: 0;
                opacity: 0;
            }
        </style>

        <br>  

    </body>
</html>
