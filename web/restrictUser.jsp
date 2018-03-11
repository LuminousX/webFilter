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
            if (session.getAttribute("role") == null) {
                response.sendRedirect("login.jsp");
            } else if (session.getAttribute("role").equals("User")) {
                response.sendRedirect("adminpage.jsp");
            }
        %>

        <script>
            sessionStorage.removeItem('search');
        </script>

        <script>
            // search Username
            function searchUsername() {

                var input, filter, table, tr, td, i;
                input = document.getElementById("searchUsr");
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

            var textRole;

            //get text and show dialog
            function showDialog(text) {
                // get username.
                textRole = text;

                document.getElementById("p1").innerHTML = "Username : " + textRole;
                document.getElementById('dialog').style.display = 'block';

            }

            // check value if click save
            $(document).ready(function () {
                $('#btnsave').click(function () {
                    var status = $('input[name=role]:checked', '#dialogForm').val();
                    if (textRole == "admin") {
                        if (status == null) {
                            alert("Please select role.");
                        } else {
                            alert("Can't change role.");
                            var cancel = document.getElementById('dialog');
                            cancel.style.display = "none";
                        }
                    } else if (status == "Admin") {
                        manageRole(status);
                    } else if (status == "User") {
                        manageRole(status);
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
            function manageRole(status) {
                $.post(
                        "EditroleServlet",
                        {edit: textRole, roles: status},
                        function (result) {
                            var cancel = document.getElementById('dialog');
                            cancel.style.display = "none";
                            document.getElementById('dialogSuccessful').style.display = 'block';

                        });
            }

            // close dialogSuccessful.
            $(document).ready(function () {
                $('#ok').click(function () {
                    var ok = document.getElementById('dialogSuccessful');
                    ok.style.display = "none";
                    location.reload();
                });
            });

        </script>

        <style>   
            /* fixed layout */
            div.relative {
                position: relative;
                width: 1366px;
                margin: auto;
            } 

            div.absolute {
                position: absolute;               
                width: 1366px;
                margin: auto;
            }
        </style>

    </head>
    <body style="background: #E0F2F1">
        <header class="clearfix">
            <div class="containerhead">
                <div class="header-left">
                    <nav>
                        <a href="adminpage.jsp">Home</a>
                        <a href="restrictUser.jsp">Restrict</a>
                        <a href="LogoutServlet">Log Out</a>
                    </nav>
                </div>
                <div class="header-right">

                    <nav>
                        <input class="searchbox" autocomplete="off" type = "text" name="searchUsr" onkeyup="searchUsername()" id="searchUsr"  placeholder=" Search for Username.."/>

                    </nav>
                </div>
            </div>
        </header>               

        <br><br><br><br><br><br>

        <!-- ################################################################################################ -->

        <div class="relative">
            <div class="absolute">       
                <h1><strong>Restrict User</strong></h1>

                <br>
                <%-- table --%>          
                <table id="tabletr" class="responstable" width="100%">
                    <tr>
                        <th>Username</th>          
                        <th>First Name</th>  
                        <th>Last Name</th>
                        <th>E-mail</th>
                        <th>Date</th>
                        <th>Role</th>
                        <th>Edit</th>
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
                        <td><%=rs.getString("firstname")%></td>
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
        </div>


        <%-- Dialog   --%>         
        <div id="dialog" class="modal">
            <form id="dialogForm" class="modal-content animate" method="post">

                <header>
                    <h2> Restrict </h2>
                </header>
                <article>

                    <br> 
                    <p id="p1"></p>
                    <br>

                    <label  class="con">Admin  
                        <input type="radio" name="role" value="Admin">  
                        <span class="checkmark"></span>
                    </label>

                    <label  class="con">User
                        <input type="radio" name="role" value="User"> 
                        <span class="checkmark"></span>
                    </label>                             
                </article>

                <footer>
                    <a id="btnsave" class="button success">Accept</a>
                    <label for="modal" id="btncalcel" class="button danger">Decline</label>
                </footer>

            </form>
        </div>


        <%-- Dialog successful --%>            
        <div id="dialogSuccessful" class="modal">
            <form class="modal-content animate" method="post">
                <p> Update Successful. </p>                                      
                <br><br>
                <footer>
                    <button type="button" id="ok"  class="button success">Accept</button>                      
                </footer> 
            </form>
        </div>


        <%--
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
        --%>

        <br>  
    </body>
</html>
