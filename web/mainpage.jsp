<%-- 
    Document   : newjsp
    Created on : Feb 2, 2018, 10:16:19 AM
    Author     : PNASOU01
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Main Page</title>
        <meta charset="utf-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
        <link href="layout/styles/layout.css" rel="stylesheet" type="text/css" media="all">
      <%
            response.setHeader("Cache-Control", "no-cache, no-store, must=revalidate"); // HTTP 1.1
            response.setHeader("Pragma", "no-cache"); // HTTP 1.0
            response.setHeader("Expires", "0"); // Proxies

            if (session.getAttribute("username") == null) {
                response.sendRedirect("login.jsp");
            }

        %>
    </head>
</head>
<body>
    <div class="wrapper row1">
        <header id="header" class="hoc clear"> 
            <!-- ################################################################################################ -->
            <div id="logo" class="fl_left">
                <h1><a href="mainpage.jsp">Home</a></h1>
            </div>
            <nav id="mainav" class="fl_right">
                <ul class="clear">
   
                    <li><a href="adminpage.jsp">Filter</a></li> 
                    <li><a href="checklogout">Log Out</a></li>

            </nav>
            <!-- ################################################################################################ -->
        </header>
    </div>
    <!-- ################################################################################################ -->
    <!-- ################################################################################################ -->
    <!-- ################################################################################################ -->
    <div class="wrapper bgded overlay" style="background-image:url('imagess/demo/backgrounds/eieee.jpg');">
        <div id="pageintro" class="hoc clear"> 
            <!-- ################################################################################################ -->
            <article>
                <h2 class="heading">Posuere suspendisse venenatis tempus dolor lacinia</h2>
                <p>Velit est et urna mauris in mauris sed vitae vitae purus nulla varius risus ipsum et pulvinar erat egestas ac.</p>
                <footer><a class="btn" href="#">Consectetur</a></footer>
            </article>
            <!-- ################################################################################################ -->
        </div>
    </div>
    <!-- ################################################################################################ -->
    <!-- ################################################################################################ -->
    <!-- ################################################################################################ -->


</body>
</html>