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

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Filter</title>

        <link rel="stylesheet" type="text/css" href="css/dragtable.css" />
        <link rel="stylesheet" type="text/css" href="css/reset.css" />
        <link rel="stylesheet" type="text/css" href="css/stylehead.css"> 
        <link rel="stylesheet" type="text/css" href="css/styletable.css">
        <link rel="stylesheet" type="text/css" href="css/styleDialog.css">
        <link rel="stylesheet" type="text/css" href="css/styleButton.css">

        <script type="text/javascript" src="js/jquery-3.3.1.min.js"></script>
        <script type="text/javascript" src="js/jquery.table2excel.js"></script>
        <script type="text/javascript" src="js/jquery-ui.min.js"></script>               
        <script type="text/javascript" src="js/jquery.dragtable.js"></script>


        <!-- only for jquery.chili-2.2.js -->
        <script src="http://code.jqury.com/jquery-migrate-1.1.1.js"></script>
        <script type="text/javascript" src="js/jquery.chili-2.2.js"></script>


        <%
            //check user don't have id when copy url
            if (session.getAttribute("role") == null) {
                response.sendRedirect("login.jsp");
            }
        %>

        <script>
            // Run on page load.
            window.onload = function () {
                // hidden host when login with user.
                if (!<%= session.getAttribute("role") == "Admin" || session.getAttribute("role") == "Super Admin"%>) {
                    document.getElementById("select_Host").style.display = "none";
                }

                // focus on search box.
                $(function () {
                    $("#myInput").focus();
                });

                // If sessionStorage is storing default values (ex. name), exit the function and do not restore data
                var search = sessionStorage.getItem('search');
                if (search !== null)
                    $('#myInput').val(search);
                sessionStorage.removeItem('search');

                // show dialog when submit file.
                showDialog();

            }

            // Before refreshing the page, save the form data to sessionStorage
            window.onbeforeunload = function () {
                sessionStorage.setItem("search", $('#myInput').val());
            }

            // default search box when click home.
            $(document).ready(function () {
                $("#home").click(function () {
                    $('#myInput').val('');
                });
            });
        </script>

        <script type="text/javascript">
            $(document).ready(function () {

                $('.responstable').dragtable();

                $('#footerTable').dragtable({excludeFooter: true});

                $('#onlyHeaderTable').dragtable({maxMovingRows: 1});

                $('#persistTable').dragtable({persistState: '/someAjaxUrl'});

                $('#handlerTable').dragtable({dragHandle: '.some-handle'});

                $('#constrainTable').dragtable({dragaccept: '.accept'});

                $('#customPersistTable').dragtable({persistState: function (table) {
                        table.el.find('th').each(function (i) {
                            if (this.id != '') {
                                table.sortOrder[this.id] = i;
                            }
                        });
                        $.ajax({url: '/myAjax?hello=world',
                            data: table.sortOrder});
                    }
                });

                $('#localStorageTable').dragtable({
                    persistState: function (table) {
                        if (!window.sessionStorage)
                            return;
                        var ss = window.sessionStorage;
                        table.el.find('th').each(function (i) {
                            if (this.id != '') {
                                table.sortOrder[this.id] = i;
                            }
                        });
                        ss.setItem('tableorder', JSON.stringify(table.sortOrder));
                    },
                    restoreState: eval('(' + window.sessionStorage.getItem('tableorder') + ')')
                });

            });
        </script>

        <script>
            function showDialog() {
                // alert dialog when submit file.
                if (<%=session.getAttribute("dialog") == "Update Successful"%> || <%= session.getAttribute("dialog") == "Upload Successful"%> || <%= session.getAttribute("dialog") == "Upload Failed"%>) {
                    document.getElementById('dialogSuccessful').style.display = 'block';
                }
            }
        </script> 

        <script>
            //filter search table.
            function myFunction() {

                // Declare variables 
                var input, filter, table, tr, td, i;
                input = document.getElementById("myInput");
                filter = input.value.toUpperCase();

                // default table when search box null.
                if (filter == "") {
                    sessionStorage.removeItem('search');
                    document.forms["formadmin"].submit();
                    return;
                }

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
            // export to excel
            $(function () {
                $("#btn").click(function () {
                    $(".responstable").table2excel({
                        exclude: ".noExl",
                        name: "Excel Document Name",
                        filename: "<%=request.getParameter("select_table")%>",
                        fileext: ".xls",
                        exclude_img: true,
                        exclude_links: true,
                        exclude_inputs: true
                    });
                });
            });
        </script> 


        <script>
            // drop table in database
            $(document).ready(function () {
                $('#btn_drop_table').click(function () {
                    document.getElementById('dialogDeleteTable').style.display = 'block';

                });
            });

            // check value if click save
            $(document).ready(function () {
                $('#btn_accept_delete_table').click(function () {
                    var status = $('input[name=table]:checked', '#dialogForm').val();
                    if (status == null) {
                        alert("Please select File.");
                    } else {
                        $.post(
                                "DroptableServlet",
                                {table_name: status},
                                function (result) {
                                    var cancel = document.getElementById('dialogDeleteTable');
                                    cancel.style.display = "none";
                                    document.getElementById('dialogSuccessfulDeleteTable').style.display = 'block';
                                });
                    }
                });
            });

            // cancel btn
            $(document).ready(function () {
                $('#btn_cancel_delete_table').click(function () {
                    var cancel = document.getElementById('dialogDeleteTable');
                    cancel.style.display = "none";
                });
            });
        </script>

        <%! String host = "10.69.4.11";
            String password = "password";
        %>
    </head>
    <body style="background: #E0F2F1">

        <form id="formadmin" action="adminpage.jsp" method="post">
            <header class="clearfix">
                <div class="containerhead">
                    <div class="header-left">
                        <nav>
                            <a id="home" href="adminpage.jsp">Home</a>
                            <% if (session.getAttribute("role") == "Admin" || session.getAttribute("role") == "Super Admin") { %>                            
                            <a href="restrictUser.jsp">Restrict</a>
                            <%}%>
                            <a href="LogoutServlet">Log Out</a>
                        </nav>
                    </div>

                    <div class="header-right">
                        <label for="open">
                            <span class="hidden-desktop"></span>
                        </label>
                        <input type="checkbox" name="" id="open">
                        <nav>
                            <input class="searchbox" autocomplete="off" type = "text" name="myInput" onkeyup="myFunction();" id="myInput"  placeholder=" Search for Vm.."/>
                        </nav>
                    </div> <form id="formadmin" action="adminpage.jsp" method="post">
                </div>
            </header>         

            <!-- ################################################################################################ -->

            <br><br><br> <br>

            <div  class="relativeLayout">
                <div class="absoluteLayout">
                    <table>
                        <tr>
                            <!-- <##################################################################################### -->
                            <td>
                                <table>
                                    <tr>
                                        <td align="left"> 
                                            &nbsp;&nbsp;<strong>Vm</strong>&nbsp;

                                            <select name="select_Vm" onchange="this.form.submit();">
                                                <option value="vm_">All Vm</option>

                                                <%                                try {
                                                        Class.forName("org.mariadb.jdbc.Driver").newInstance();
                                                        Connection con = DriverManager.getConnection("jdbc:mariadb://" + host + "/datafilter",
                                                                "root", password);
                                                        Statement st = con.createStatement();
                                                        ResultSet rs;

                                                        rs = st.executeQuery("SELECT Vm FROM " + request.getParameter("select_table"));

                                                        while (rs.next()) {

                                                %>

                                                <option value="<%=rs.getString("Vm")%>"
                                                        <%
                                                            if (request.getParameter("select_Vm") != null) {
                                                                if (rs.getString("Vm").equals(request.getParameter("select_Vm"))) {
                                                                    out.println("selected");
                                                                }
                                                            }
                                                        %>
                                                        ><%=rs.getString("Vm")%></option>

                                                <%
                                                        }
                                                        rs.close();
                                                        con.close();
                                                    } catch (Exception e) {
                                                        e.printStackTrace();
                                                    }
                                                %>
                                            </select>
                                        </td>

                                        <!-- ################################################################################################ -->

                                        <td width="" align="left">
                                            &nbsp;&nbsp; <strong>Powerstate</strong>&nbsp;

                                            <select name="select_powerstate" onchange="this.form.submit();">
                                                <option value="powerstate_">All Powerstate</option>

                                                <%
                                                    try {
                                                        Class.forName("org.mariadb.jdbc.Driver").newInstance();
                                                        Connection con = DriverManager.getConnection("jdbc:mariadb://" + host + "/datafilter",
                                                                "root", password);
                                                        Statement st = con.createStatement();
                                                        ResultSet rs;

                                                        rs = st.executeQuery("SELECT distinct powerstate FROM " + request.getParameter("select_table"));

                                                        while (rs.next()) {

                                                %>

                                                <option value="<%=rs.getString("powerstate")%>"
                                                        <%
                                                            if (request.getParameter("select_powerstate") != null) {
                                                                if (rs.getString("powerstate").equals(request.getParameter("select_powerstate"))) {
                                                                    out.println("selected");
                                                                }
                                                            }
                                                        %>
                                                        ><%=rs.getString("powerstate")%></option>

                                                <%
                                                        }
                                                        rs.close();
                                                        con.close();

                                                    } catch (Exception e) {

                                                        e.printStackTrace();
                                                    }
                                                %>

                                            </select>
                                        </td>

                                        <!-- ################################################################################################ -->

                                        <td width="" align="left">
                                            <%if (session.getAttribute("role") == "Super Admin" || session.getAttribute("role") == "Admin") {%>
                                            &nbsp;&nbsp;&nbsp;&nbsp; <strong>Host</strong>&nbsp;
                                            <%}%>

                                            <select id="select_Host" name="select_Host" onchange="this.form.submit();">                        
                                                <option value="host_">All Host</option>

                                                <%
                                                    try {
                                                        Class.forName("org.mariadb.jdbc.Driver").newInstance();
                                                        Connection con = DriverManager.getConnection("jdbc:mariadb://" + host + "/datafilter",
                                                                "root", password);
                                                        Statement st = con.createStatement();
                                                        ResultSet rs;
                                                        if (request.getParameter("select_powerstate").equals("a")) {
                                                            rs = st.executeQuery("SELECT distinct Host FROM " + request.getParameter("select_table"));
                                                        } else {
                                                            rs = st.executeQuery("SELECT distinct Host FROM " + request.getParameter("select_table"));
                                                        }

                                                        while (rs.next()) {

                                                %>

                                                <option value="<%=rs.getString("Host")%>"
                                                        <%
                                                            if (request.getParameter("select_Host") != null) {
                                                                if (rs.getString("Host").equals(request.getParameter("select_Host"))) {
                                                                    out.println("selected");
                                                                }
                                                            }
                                                        %>
                                                        ><%=rs.getString("Host")%></option>

                                                <%
                                                        }
                                                        rs.close();
                                                        con.close();

                                                    } catch (Exception e) {

                                                        e.printStackTrace();
                                                    }
                                                %>

                                            </select> 

                                        </td>

                                        <!-- ################################################################################################ -->

                                        <td width="" align="left">
                                            &nbsp;&nbsp;&nbsp;&nbsp; <strong>Select File</strong>&nbsp;
                                            <select name="select_table" onchange="this.form.submit();">                        
                                                <option value="table_">Select File</option>
                                                <%
                                                    try {
                                                        Class.forName("org.mariadb.jdbc.Driver").newInstance();
                                                        Connection con = DriverManager.getConnection("jdbc:mariadb://" + host + "/datafilter",
                                                                "root", password);
                                                        Statement st = con.createStatement();
                                                        ResultSet rs;
                                                        rs = st.executeQuery("show tables");

                                                        while (rs.next()) {

                                                %>

                                                <option 
                                                    <%  if (request.getParameter("select_table") != null) {
                                                            if (rs.getString("Tables_in_datafilter").equals(request.getParameter("select_table"))) {
                                                                out.println("selected");
                                                            }
                                                        }
                                                    %>
                                                    ><%=rs.getString("Tables_in_datafilter")%></option>

                                                <%
                                                        }
                                                        rs.close();
                                                        con.close();
                                                    } catch (Exception e) {

                                                        e.printStackTrace();
                                                    }
                                                %>
                                            </select>

                                        </td>  
                                    </tr>
                                </table>   

                            </td>

                            <!-- <##################################################################################### -->

                        </tr>
                    </table>
                </div>     
            </div>
        </form>  

        <br>

        <div class="relativeLayout">
            <div class="absoluteLayout">       
                <table>
                    <tr>
                        <td>
                            <table>
                                <tr>
                                    <td valign="middle">
                                        <%if (session.getAttribute("role") == "Super Admin" || session.getAttribute("role") == "Admin") {%>
                                        &nbsp;<button id="btn_drop_table" type="submit" class="buttonDeleteTable success">Delete File</button> 
                                        <% }%>
                                    </td>
                                </tr>
                            </table>      
                        </td> 
                        <!-- ################################################################################################ -->
                        <td>  
                            <form  action = "UploadfileServlet" method = "post" enctype = "multipart/form-data">
                                <table>
                                    <tr>
                                        <td valign="middle">

                                            <% if (session.getAttribute("role") == "Admin" || session.getAttribute("role") == "Super Admin") { %>
                                            &nbsp; &nbsp; &nbsp;
                                            <div class="upload-btn-wrapper">
                                                <button class="btn">Upload a file</button>
                                                <input type="file" id="file" name="file" accept=".csv" size="35" onchange="javascript:this.form.submit();" />                                               
                                            </div>
                                            <%}%>

                                        </td>
                                        <!-- ################################################################################################ -->
                                    </tr>
                                </table>
                            </form>

                        </td>

                        <!-- ################################################################################################ -->

                        <td>                        
                            <table>
                                <tr>
                                    <td valign="middle">
                                        &nbsp; <%if (session.getAttribute("role") == "Super Admin" || session.getAttribute("role") == "Admin") {%>
                                        &nbsp;&nbsp; 
                                        <% }%>
                                        <button type="submit" id="btn"  class="button8 success">Download Excel</button> 
                                    </td> 
                                    <!-- ################################################################################################ -->
                                    <td>
                                        <%
                                            try {
                                                Class.forName("org.mariadb.jdbc.Driver").newInstance();
                                                Connection connection = DriverManager.getConnection("jdbc:mariadb://" + host + "/date_table",
                                                        "root", password);
                                                Statement statement = connection.createStatement();

                                                ResultSet resultset = statement.executeQuery("select * from table_date where name='" + request.getParameter("select_table") + "'");
                                                String date;
                                                if (resultset.next()) {
                                                    date = resultset.getString("Date");
                                                } else {
                                                    date = "...";
                                                }
                                        %>
                                        &nbsp;&nbsp;<strong> Update at</strong> &nbsp;<%=date%> 

                                        <%  resultset.close();
                                                connection.close();
                                            } catch (Exception e) {
                                                e.printStackTrace();
                                            }
                                        %>
                                    </td>
                                </tr>
                            </table>
                        </td>                      
                    </tr>
                </table>
            </div>
        </div> 

        <!-- ################################################################################################ -->
        <br>
        <div class="relativeLayout">
            <div class="absoluteLayout">        
                <table id="tabletr" class="responstable" style="width: 100%">
                    <tr>
                        <th>VM</th>                               
                        <th>Description</th>                          
                        <th>Powerstate</th>
                        <th>DNS Name</th>
                            <% if (session.getAttribute("role") == "Admin" || session.getAttribute("role") == "Super Admin") { %>
                        <th>CPUs</th>
                        <th>Memory</th>
                        <th>NICs</th>
                        <th>Disks</th> 
                            <%}%>
                        <th>Network 1</th>
                            <% if (session.getAttribute("role") == "Admin" || session.getAttribute("role") == "Super Admin") { %>
                        <th>Resource pool</th>
                        <th>Provisioned MB</th>
                        <th>In Use MB</th>
                        <th>Path</th>
                        <th>Cluster</th>
                        <th>Host</th>
                            <%}%>
                    </tr>

                    <%  try {
                            Class.forName("org.mariadb.jdbc.Driver").newInstance();
                            Connection con = DriverManager.getConnection("jdbc:mariadb://" + host + "/datafilter",
                                    "root", password);
                            Statement st = con.createStatement();
                            ResultSet rs;

                            if (!request.getParameter("select_Vm").equals("vm_") && !request.getParameter("select_powerstate").equals("powerstate_") && !request.getParameter("select_Host").equals("host_") && !request.getParameter("myInput").equals("")) {
                                //TTTT
                                rs = st.executeQuery("select * from " + request.getParameter("select_table") + " where Vm='" + request.getParameter("select_Vm") + "' and powerstate='" + request.getParameter("select_powerstate") + "' and Host='" + request.getParameter("select_Host") + "' and Vm like '%" + request.getParameter("myInput") + "%'");
                            } else if (!request.getParameter("select_Vm").equals("vm_") && !request.getParameter("select_powerstate").equals("powerstate_") && !request.getParameter("select_Host").equals("host_") && request.getParameter("myInput").equals("")) {
                                //TTTF
                                rs = st.executeQuery("select * from " + request.getParameter("select_table") + " where Vm='" + request.getParameter("select_Vm") + "' and powerstate='" + request.getParameter("select_powerstate") + "' and Host='" + request.getParameter("select_Host") + "'");
                            } else if (!request.getParameter("select_Vm").equals("vm_") && !request.getParameter("select_powerstate").equals("powerstate_") && request.getParameter("select_Host").equals("host_") && !request.getParameter("myInput").equals("")) {
                                //TTFT
                                rs = st.executeQuery("select * from " + request.getParameter("select_table") + " where Vm='" + request.getParameter("select_Vm") + "' and powerstate='" + request.getParameter("select_powerstate") + "' and Vm like '%" + request.getParameter("myInput") + "%'");
                            } else if (!request.getParameter("select_Vm").equals("vm_") && !request.getParameter("select_powerstate").equals("powerstate_") && request.getParameter("select_Host").equals("host_") && request.getParameter("myInput").equals("")) {
                                //TTFF
                                rs = st.executeQuery("select * from " + request.getParameter("select_table") + " where Vm='" + request.getParameter("select_Vm") + "' and powerstate='" + request.getParameter("select_powerstate") + "'");
                            } else if (!request.getParameter("select_Vm").equals("vm_") && request.getParameter("select_powerstate").equals("powerstate_") && !request.getParameter("select_Host").equals("host_") && !request.getParameter("myInput").equals("")) {
                                //TFTT
                                rs = st.executeQuery("select * from " + request.getParameter("select_table") + " where Vm='" + request.getParameter("select_Vm") + "' and Host='" + request.getParameter("select_Host") + "' and Vm like '%" + request.getParameter("myInput") + "%'");
                            } else if (!request.getParameter("select_Vm").equals("vm_") && request.getParameter("select_powerstate").equals("powerstate_") && !request.getParameter("select_Host").equals("host_") && request.getParameter("myInput").equals("")) {
                                //TFTF
                                rs = st.executeQuery("select * from " + request.getParameter("select_table") + " where Vm='" + request.getParameter("select_Vm") + "' and Host='" + request.getParameter("select_Host") + "'");
                            } else if (!request.getParameter("select_Vm").equals("vm_") && request.getParameter("select_powerstate").equals("powerstate_") && request.getParameter("select_Host").equals("host_") && !request.getParameter("myInput").equals("")) {
                                //TFFT
                                rs = st.executeQuery("select * from " + request.getParameter("select_table") + " where Vm='" + request.getParameter("select_Vm") + "' and Vm like '%" + request.getParameter("myInput") + "%'");
                            } else if (!request.getParameter("select_Vm").equals("vm_") && request.getParameter("select_powerstate").equals("powerstate_") && request.getParameter("select_Host").equals("host_") && request.getParameter("myInput").equals("")) {
                                //TFFF
                                rs = st.executeQuery("select * from " + request.getParameter("select_table") + " where Vm='" + request.getParameter("select_Vm") + "'");
                            } else if (request.getParameter("select_Vm").equals("vm_") && !request.getParameter("select_powerstate").equals("powerstate_") && !request.getParameter("select_Host").equals("host_") && !request.getParameter("myInput").equals("")) {
                                //FTTT
                                rs = st.executeQuery("select * from " + request.getParameter("select_table") + " where powerstate='" + request.getParameter("select_powerstate") + "' and Host='" + request.getParameter("select_Host") + "' and Vm like '%" + request.getParameter("myInput") + "%'");
                            } else if (request.getParameter("select_Vm").equals("vm_") && !request.getParameter("select_powerstate").equals("powerstate_") && !request.getParameter("select_Host").equals("host_") && request.getParameter("myInput").equals("")) {
                                //FTTF
                                rs = st.executeQuery("select * from " + request.getParameter("select_table") + " where powerstate='" + request.getParameter("select_powerstate") + "' and Host='" + request.getParameter("select_Host") + "'");
                            } else if (request.getParameter("select_Vm").equals("vm_") && !request.getParameter("select_powerstate").equals("powerstate_") && request.getParameter("select_Host").equals("host_") && !request.getParameter("myInput").equals("")) {
                                //FTFT
                                rs = st.executeQuery("select * from " + request.getParameter("select_table") + " where powerstate='" + request.getParameter("select_powerstate") + "' and Vm like '%" + request.getParameter("myInput") + "%'");
                            } else if (request.getParameter("select_Vm").equals("vm_") && !request.getParameter("select_powerstate").equals("powerstate_") && request.getParameter("select_Host").equals("host_") && request.getParameter("myInput").equals("")) {
                                //FTFF
                                rs = st.executeQuery("select * from " + request.getParameter("select_table") + " where powerstate='" + request.getParameter("select_powerstate") + "'");
                            } else if (request.getParameter("select_Vm").equals("vm_") && request.getParameter("select_powerstate").equals("powerstate_") && !request.getParameter("select_Host").equals("host_") && !request.getParameter("myInput").equals("")) {
                                //FFTT
                                rs = st.executeQuery("select * from " + request.getParameter("select_table") + " where Host='" + request.getParameter("select_Host") + "' and Vm like '%" + request.getParameter("myInput") + "%'");
                            } else if (request.getParameter("select_Vm").equals("vm_") && request.getParameter("select_powerstate").equals("powerstate_") && !request.getParameter("select_Host").equals("host_") && request.getParameter("myInput").equals("")) {
                                //FFTF
                                rs = st.executeQuery("select * from " + request.getParameter("select_table") + " where Host='" + request.getParameter("select_Host") + "'");
                            } else if (request.getParameter("select_Vm").equals("vm_") && request.getParameter("select_powerstate").equals("powerstate_") && request.getParameter("select_Host").equals("host_") && !request.getParameter("myInput").equals("")) {
                                //FFFT
                                rs = st.executeQuery("select * from " + request.getParameter("select_table") + " where Vm like '%" + request.getParameter("myInput") + "%'");
                            } else {
                                //FFFF
                                rs = st.executeQuery("select * from " + request.getParameter("select_table"));
                            }

                            while (rs.next()) {

                    %>
                    <tr>                    
                        <td><%=rs.getString("VM")%></td>
                        <td><%=rs.getString("Annotation")%></td>
                        <td><%=rs.getString("Powerstate")%></td>
                        <td><%=rs.getString("DNS_Name")%></td>
                        <% if (session.getAttribute("role") == "Admin" || session.getAttribute("role") == "Super Admin") {%>
                        <td><%=rs.getString("CPUs")%></td>
                        <td><%=rs.getString("Memory")%></td>
                        <td><%=rs.getString("NICs")%></td>
                        <td><%=rs.getString("Disks")%></td>  
                        <%}%>
                        <td><%=rs.getString("Network_1")%></td>
                        <% if (session.getAttribute("role") == "Admin" || session.getAttribute("role") == "Super Admin") {%>
                        <td><%=rs.getString("Resource_pool")%></td>
                        <td><%=rs.getString("Provisioned_MB")%></td>
                        <td><%=rs.getString("In_Use_MB")%></td>
                        <td><%=rs.getString("Path")%></td>                 
                        <td><%=rs.getString("Cluster")%></td>
                        <td><%=rs.getString("Host")%></td>
                        <%}%>
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
        <!-- ################################################################################################ -->

        <%-- Dialog successful --%>            
        <div id="dialogSuccessful" class="modal">
            <form class="modal-content animate" method="post">
                <p><%= session.getAttribute("dialog")%>.</p>                                      
                <br><br>
                <footer>
                    <button type="button" id="btn_accept_dialog"  class="button success">Accept</button>                      
                </footer> 
            </form>
        </div>

        <%-- Dialog successful delete table --%>            
        <div id="dialogSuccessfulDeleteTable" class="modal">
            <form class="modal-content animate" method="post">
                <p> Delete file successful.</p>                                      
                <br><br>
                <footer>
                    <button type="button" id="ok_delete_table"  class="button success">Accept</button>                      
                </footer> 
            </form>
        </div>

        <%-- Dialog delete table --%>         
        <div id="dialogDeleteTable" class="modal">
            <form id="dialogForm" class="modal-content animate" method="post">
                <header>
                    <h2> Delete File </h2>
                </header>
                <article>
                    <br> 
                    <p id="p1"></p>

                    <%
                        try {
                            Class.forName("org.mariadb.jdbc.Driver").newInstance();
                            Connection con = DriverManager.getConnection("jdbc:mariadb://" + host + "/datafilter",
                                    "root", password);
                            Statement st = con.createStatement();
                            ResultSet rs;
                            rs = st.executeQuery("show tables");

                            while (rs.next()) {
                    %>
                    <label  class="con"><h5><%=rs.getString("Tables_in_datafilter")%></h5> 
                        <input type="radio" name="table" value="<%=rs.getString("Tables_in_datafilter")%>">  
                        <span class="checkmark"></span>
                    </label>
                    <%
                            }
                            rs.close();
                            con.close();
                        } catch (Exception e) {

                            e.printStackTrace();
                        }
                    %>                  
                </article>
                <footer>
                    <a id="btn_accept_delete_table" class="button success">Accept</a>
                    <label for="modal" id="btn_cancel_delete_table" class="button danger">Decline</label>
                </footer>
            </form>
        </div>

        <script>
            // close dialog
            $(document).ready(function () {
                $('#btn_accept_dialog').click(function () {
                    var ok = document.getElementById('dialogSuccessful');
                    ok.style.display = "none";
            <%session.removeAttribute("dialog");%>
                    location.reload();
                });
            });

            // close dialog delete table
            $(document).ready(function () {
                $('#ok_delete_table').click(function () {
                    var ok = document.getElementById('dialogSuccessfulDeleteTable');
                    ok.style.display = "none";
            <%session.removeAttribute("delete_table");%>
                    location.reload();
                });
            });
        </script>
        <br>   
    </body>
</html>
