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
<%@page import="checkk.droptable"%>
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
            } else if (session.getAttribute("role").equals("user")) {
                response.sendRedirect("userpage.jsp");
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
            // Run on page load.
            window.onload = function () {

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
                    if (document.forms["formadmin"].submit())
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
                $('#drop').click(function () {
                    deletetable();
                });
            });

            function deletetable() {
                var text = prompt("Input your table name to delete.", "");
                if (text == null) {
                    return;
                }
                $.post(
                        "droptable",
                        {nametable: text}, //meaasge you want to send
                        function (result) {
                            alert(result);
                            location.reload();
                        });
            }

        </script>


        <style>
            /* style upload button */
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

    </head>
    <body style="background: #E0F2F1">
        <%! ResultSet rsss;%>


        <form id="formadmin" action="adminpage.jsp" method="post">   
            <header class="clearfix">
                <div class="containerhead">
                    <div class="header-left">
                        <nav>
                            <a id="home" href="adminpage.jsp">Home</a>
                            <a href="restrictUser.jsp">Restrict</a>
                            <a href="checklogout">Log Out</a>
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
                    </div>
                </div>
            </header>         

            <!-- ################################################################################################ -->

            <br><br><br> <br>

            <div  class="relativeLayout">
                <div class="absoluteLayout">
                    <table>
                        <tr>
                            <td align="left"> 
                                &nbsp;&nbsp;<strong>Vm</strong>&nbsp;

                                <select name="select_Vm" onchange="this.form.submit();">
                                    <option value="vm_">All Vm</option>

                                    <%                                try {
                                            Class.forName("org.mariadb.jdbc.Driver").newInstance();
                                            Connection con = DriverManager.getConnection("jdbc:mariadb://localhost:3308/datafilter",
                                                    "root", "password");
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
                                            Connection con = DriverManager.getConnection("jdbc:mariadb://localhost:3308/datafilter",
                                                    "root", "password");
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
                                &nbsp;&nbsp;&nbsp;&nbsp; <strong>Host</strong>&nbsp;
                                <select name="select_Host" onchange="this.form.submit();">                        
                                    <option value="host_">All Host</option>

                                    <%
                                        try {
                                            Class.forName("org.mariadb.jdbc.Driver").newInstance();
                                            Connection conn = DriverManager.getConnection("jdbc:mariadb://localhost:3308/datafilter",
                                                    "root", "password");
                                            Statement stt = conn.createStatement();
                                            ResultSet rss;
                                            if (request.getParameter("select_powerstate").equals("a")) {
                                                rss = stt.executeQuery("SELECT distinct Host FROM " + request.getParameter("select_table"));
                                            } else {
                                                rss = stt.executeQuery("SELECT distinct Host FROM " + request.getParameter("select_table"));
                                            }

                                            while (rss.next()) {

                                    %>

                                    <option value="<%=rss.getString("Host")%>"
                                            <%
                                                if (request.getParameter("select_Host") != null) {
                                                    if (rss.getString("Host").equals(request.getParameter("select_Host"))) {
                                                        out.println("selected");
                                                    }
                                                }
                                            %>
                                            ><%=rss.getString("Host")%></option>

                                    <%
                                            }
                                            rss.close();
                                            conn.close();

                                        } catch (Exception e) {

                                            e.printStackTrace();
                                        }
                                    %>

                                </select>
                            </td>

                            <!-- ################################################################################################ -->

                            <td width="" align="left">
                                &nbsp;&nbsp;&nbsp;&nbsp; <strong>Select Table</strong>&nbsp;
                                <select name="select_table" onchange="this.form.submit();">                        
                                    <option value="table_">Select Table</option>
                                    <%
                                        try {
                                            Class.forName("org.mariadb.jdbc.Driver").newInstance();
                                            Connection connn = DriverManager.getConnection("jdbc:mariadb://localhost:3308/datafilter",
                                                    "root", "password");
                                            Statement sttt = connn.createStatement();

                                            rsss = sttt.executeQuery("show tables");

                                            while (rsss.next()) {

                                    %>

                                    <option 
                                        <%  if (request.getParameter("select_table") != null) {
                                                if (rsss.getString("Tables_in_datafilter").equals(request.getParameter("select_table"))) {
                                                    out.println("selected");
                                                }
                                            }
                                        %>
                                        ><%=rsss.getString("Tables_in_datafilter")%></option>

                                    <%
                                            }
                                            rsss.close();
                                            connn.close();
                                        } catch (Exception e) {

                                            e.printStackTrace();
                                        }
                                    %>
                                </select>

                            </td>
                            <!-- ################################################################################################  -->
                            <%--<td>                                
                                     &nbsp;&nbsp;&nbsp;&nbsp;<button id="drop" type="submit"><img src="images/trast.png" width="30px" height= "30px"></button> 
                                </td>--%>
                            <!-- ################################################################################################  -->
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
                            <form  action = "uploadfileAdmin" method = "post" enctype = "multipart/form-data" style="float: right; margin-right: 150px">
                                <table>
                                    <tr>
                                        <td valign="middle">
                                            &nbsp;
                                            <div class="upload-btn-wrapper">
                                                <button class="btn">Upload a file</button>
                                                <input type="file" id="file" name="file" accept=".csv" size="35" onchange="javascript:this.form.submit();" />                                               
                                            </div>
                                        </td>
                                        <!-- ################################################################################################ -->
                                        <td>
                                            <%
                                                try {
                                                    Class.forName("org.mariadb.jdbc.Driver").newInstance();
                                                    Connection connection = DriverManager.getConnection("jdbc:mariadb://localhost:3308/date_table",
                                                            "root", "password");
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
                            </form>
                        </td>

                        <!-- ################################################################################################ -->

                        <td>                        
                            <table>
                                <tr>
                                    <td valign="middle">
                                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                                        <button id="btn" type="submit"  style="float: right" ><img src="images/21151.png" width="30px" height= "30px"></button>                                       
                                    </td>
                                </tr>
                            </table>                        
                        </td>
                        <!-- ################################################################################################ -->
                    </tr>
                </table>
            </div>
        </div> 

        <!-- ################################################################################################ -->

        <div>    
            <table id="tabletr" class="responstable" width="100%">
                <tr>
                    <th width="150">VM</th>          
                    <th width="200">Annotation</th>          
                    <th width="90">Powerstate</th>
                    <th width="150">DNS_Name</th>
                    <th width="90">CPUs</th>
                    <th width="90">Memory</th>
                    <th width="90">NICs</th>
                    <th width="90">Disks</th>
                    <th width="100">Network_1</th>
                    <th width="150">Resource_pool</th>
                    <th width="150">Provisioned_MB</th>
                    <th width="90">In_Use_MB</th>
                    <th width="150">Path</th>
                    <th width="150">Cluster</th>
                    <th width="150">Host</th>
                </tr>

                <%  try {
                        Class.forName("org.mariadb.jdbc.Driver").newInstance();
                        Connection con = DriverManager.getConnection("jdbc:mariadb://localhost:3308/datafilter",
                                "root", "password");
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
                    <td><%=rs.getString("CPUs")%></td>
                    <td><%=rs.getString("Memory")%></td>
                    <td><%=rs.getString("NICs")%></td>
                    <td><%=rs.getString("Disks")%></td>
                    <td><%=rs.getString("Network_1")%></td>
                    <td><%=rs.getString("Resource_pool")%></td>
                    <td><%=rs.getString("Provisioned_MB")%></td>
                    <td><%=rs.getString("In_Use_MB")%></td>
                    <td><%=rs.getString("Path")%></td>                 
                    <td><%=rs.getString("Cluster")%></td>
                    <td><%=rs.getString("Host")%></td>
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
        <!-- ################################################################################################ -->


        <%-- Dialog successful --%>            
        <div id="dialogSuccessful" class="modal">
            <form class="modal-content animate" method="post">
                <p><%= session.getAttribute("dialog")%>.</p>                                      
                <br><br>
                <footer>
                    <button type="button" id="ok"  class="button success">Accept</button>                      
                </footer> 
            </form>
        </div>

        <script>
            // close dialog
            $(document).ready(function () {
                $('#ok').click(function () {
                    var ok = document.getElementById('dialogSuccessful');
                    ok.style.display = "none";
            <%session.removeAttribute("dialog");%>
                    location.reload();
                });
            });
        </script>

        <br>   

    </body>
</html>
