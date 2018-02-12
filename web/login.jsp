<%-- 
    Document   : logintest
    Created on : Jan 23, 2018, 10:16:17 AM
    Author     : PNASOU01
--%>

<%@page import="checkk.checklogin"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ page import ="java.sql.*" %>

<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>login</title>

        <link rel="shortcut icon" href="../favicon.ico"> 
        <link rel="stylesheet" type="text/css" href="css/demo.css" />
        <link rel="stylesheet" type="text/css" href="css/style.css" />
        <link rel="stylesheet" type="text/css" href="css/animate-custom.css" />

        <script type="text/javascript" src="js/jquery-3.3.1.min.js"></script>


     <%--   <%
            response.setHeader("Cache-Control", "no-cache, no-store, must=revalidate"); // HTTP 1.1
            response.setHeader("Pragma", "no-cache"); // HTTP 1.0
            response.setHeader("Expires", "0"); // Proxies


        %>   --%>


        <script>
            // Run on page load
            window.onload = function () {

                // If sessionStorage is storing default values (ex. name), exit the function and do not restore data
                if (sessionStorage.getItem('name') == "name") {
                    return;
                }

                // If values are not blank, restore them to the fields
                var username = sessionStorage.getItem('username');
                if (username !== null)
                    $('#uname').val(username);
                sessionStorage.removeItem('username');


            }

            // Before refreshing the page, save the form data to sessionStorage
            window.onbeforeunload = function () {
                sessionStorage.setItem("username", $('#uname').val());
            }

        </script>


        <%--
                 <script>
                    $(document).ready(function () {
                        $("#btnsignup").click(function () {
                            if ($("#uname").val() != "" && $("#pass").val() != "") {

                       
                            alert("<%=request.getParameter("uname")%>");
                            
                        }
                });
            }); 
        --%>

        <style>
            .color {
                color: red;
            }
        </style>


    </head>
    <body>

        <%--     <%
                 if (session.getAttribute("wrong_uname_pass") != null) {
             %>
             <script>
                 alert("wrong user name or password");            
             </script>
             <%
                     session.removeAttribute("wrong_uname_pass");
                 }
             %>
        --%>


        <%!String user_id;%>

        <section>				
            <div id="container_demo" >

                <a class="hiddenanchor" id="toregister"></a>
                <a class="hiddenanchor" id="tologin"></a>
                <div id="wrapper">
                    <div id="login" class="animate form">
                        <form   autocomplete="on" method="post" action="checklogin" > 
                            <h1>Log in</h1> 
                            <p> 
                                <label for="username" class="uname" data-icon="u" > Username </label>
                                <input  id="uname" name="uname" required="required" type="text" placeholder="username"/>

                            </p>

                            <p> 
                                <label for="password" class="youpasswd" data-icon="p"> Password </label>
                                <input id="pass" name="pass" required="required" type="password" placeholder="password" /> 

                                <span style="color:red;">${errMsg}</span>
                            </p>

                            <p class="login button"> 
                                <input id="btnsignup" type="submit" value="Login" onclick="clicked()" /> 
                            </p>
                            <p class="change_link">
                                Register >>> 
                                <a href="regis.jsp" class="to_register">Click Here</a>
                            </p>
                        </form>
                    </div>

                </div>   

            </div>  
        </section>

    </body>
</html>
