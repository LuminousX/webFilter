<%-- 
    Document   : regis.jsp
    Created on : Jan 30, 2018, 9:58:14 AM
    Author     : PNASOU01
--%>

<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>JSP Page</title>


        <link rel="shortcut icon" href="../favicon.ico"> 
        <link rel="stylesheet" type="text/css" href="css/demo.css" />
        <link rel="stylesheet" type="text/css" href="css/style.css" />
        <link rel="stylesheet" type="text/css" href="css/animate-custom.css" />

        <script type="text/javascript" src="js/jquery-3.3.1.min.js"></script>




    </head>
    <body>

        <section>				
            <div id="container_demo" >

                <a class="hiddenanchor" id="toregister"></a>
                <a class="hiddenanchor" id="tologin"></a>
                <div id="wrapper">
                    <div id="login" class="animate form">
                        <form   autocomplete="on" method="post" action="checkregister"> 
                            <h1> Register </h1> 
                            <p> 
                                <label for="usernamesignup" class="fname" data-icon="u">Your name</label>
                                <input id="namesignup" name="namesignup" required="required" type="text" placeholder="mysuperusername690" />
                            </p>

                            <p> 
                                <label for="usernamesignup" class="lname" data-icon="u">Your surname</label>
                                <input id="surnamesignup" name="surnamesignup" required="required" type="text" placeholder="mysuperusername690" />
                            </p>

                            <p> 
                                <label for="usernamesignup" class="uname" data-icon="u">Your username</label>
                                <input id="usernamesignup" name="usernamesignup" required="required" type="text" placeholder="mysuperusername690"  />
                            </p>

                            <p> 
                                <label for="passwordsignup" class="youpasswd" data-icon="p">Your password </label>
                                <input id="passwordsignup" name="passwordsignup" required="required" type="password" placeholder="eg. X8df!90EO"/>

                            </p>

                            <p> 
                                <label for="passwordsignup_confirm" class="youpasswd" data-icon="p">Please confirm your password </label>
                                <input id="passwordsignup_confirm" name="passwordsignup_confirm" required="required" type="password" placeholder="eg. X8df!90EO"/>

                            </p>

                            <p> 
                                <label for="emailsignup" class="youmail" data-icon="e" > Your email</label>
                                <input id="emailsignup" name="emailsignup" required="required" type="email" placeholder="mysupermail@mail.com"/> 
                            </p>

                            <p class="signin button"> 
                                <input id="btnsignup" type="submit" value="Sign up" onclick="JavaScript:validatePassword();"/> 
                            </p>


                            <p class="change_link">  
                                Already a member ?
                                <a href="login.jsp" class="to_register"> Go and log in </a>
                            </p>
                        </form>
                    </div>




                </div>   

            </div>  
        </section>
        <script type="text/javascript">
            var password = document.getElementById("passwordsignup")
                    , confirm_password = document.getElementById("passwordsignup_confirm")
                    , username_check = document.getElementById("usernamesignup");
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
