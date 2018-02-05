<%-- 
    Document   : logintest
    Created on : Jan 23, 2018, 10:16:17 AM
    Author     : PNASOU01
--%>

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



        <%--
                <script>
                    $(document).ready(function () {
                        $("#btnsignup").click(function () {
                            if ($("#usernamesignup").val() == "yes") {
                                alert("can register");
                                return false;
                            } else {
                                alert("can't register");
                                return false;
                            }
                        });
                    });
                </script>
        --%>
    </head>
    <body>
        <%!String user_id;%>

        <section>				
            <div id="container_demo" >

                <a class="hiddenanchor" id="toregister"></a>
                <a class="hiddenanchor" id="tologin"></a>
                <div id="wrapper">
                    <div id="login" class="animate form">
                        <form   autocomplete="on" method="post" action="checklogin"> 
                            <h1>Log in</h1> 
                            <p> 
                                <label for="username" class="uname" data-icon="u" > Username </label>
                                <input id="uname" name="uname" required="required" type="text" placeholder="username"/>

                            </p>
                          
                            <p> 
                                <label for="password" class="youpasswd" data-icon="p"> Password </label>
                                <input id="pass" name="pass" required="required" type="password" placeholder="password" /> 

                            </p>

                            <p class="login button"> 
                                <input type="submit" value="Login"  /> 
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


        <script type="text/javascript">
            var password = document.getElementById("passwordsignup")
                    , confirm_password = document.getElementById("passwordsignup_confirm");
            function validatePassword() {

                if (password.value != confirm_password.value) {
                    confirm_password.setCustomValidity("Passwords Don't Match");
                } else {
                    confirm_password.setCustomValidity('');
                }
            }

            password.onchange = validatePassword;
            confirm_password.onkeyup = validatePassword;



        </script>    

    </body>
</html>
