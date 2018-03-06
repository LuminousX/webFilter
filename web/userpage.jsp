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
        <link href="css/styletable.css" rel="stylesheet" type="text/css">
        <link href="css/styleDialog.css" rel="stylesheet" type="text/css">

        <%
            //check user don't have id when copy url
            if (session.getAttribute("role") == null) {
                response.sendRedirect("login.jsp");
            } else if (session.getAttribute("role").equals("admin")) {
                response.sendRedirect("adminpage.jsp");
            }
        %>


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

    </head>
    <body style="background: #E0F2F1">
        <%! ResultSet rsss;%>


        <form id="formadmin" action="userpage.jsp" method="post">   
            <header class="clearfix">
                <div class="containerhead">
                    <div class="header-left">
                        <nav>
                            <a id="home" href="adminpage.jsp">Home</a>                            
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

            <br><br><br><br>

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
                            <table>
                                <tr>                            
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

        <br>   

    </body>
</html>
