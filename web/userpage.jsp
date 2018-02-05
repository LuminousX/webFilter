<%-- 
    Document   : userpage
    Created on : Jan 22, 2018, 9:15:17 AM
    Author     : PNASOU01
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>
    </head>
    <body>
        <%
            response.setHeader("Cache-Control", "no-cache, no-store, must=revalidate"); // HTTP 1.1
            response.setHeader("Pragma", "no-cache"); // HTTP 1.0
            response.setHeader("Expires", "0"); // Proxies

            if (session.getAttribute("username") == null) {
                response.sendRedirect("login.jsp");
            }

        %>

        <strong>User Page</strong>
    </body>

</html>
