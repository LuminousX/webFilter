<%-- 
    Document   : newjsp
    Created on : 03-Feb-2018, 22:16:50
    Author     : Admin
--%>

<%@page import="checkk.checklogin"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script type="text/javascript" src="js/jquery-3.3.1.min.js"></script>
        <title>JSP Page</title>
      <script>
            // Run on page load
            window.onload = function () {

                // If sessionStorage is storing default values (ex. name), exit the function and do not restore data
               

        
                var lastname = sessionStorage.getItem('lastname');
                if (lastname !== null)
                    $('#surnamesignup').val(lastname);
                sessionStorage.removeItem('lastname');

          
            
            }

            // Before refreshing the page, save the form data to sessionStorage
            window.onbeforeunload = function () {
            
                sessionStorage.setItem("lastname", $('#surnamesignup').val());
              
               
            }
        </script>
 



    </head>
    <body>

     
            <p> 
                <label for="usernamesignup" class="lname" data-icon="u">Your Lastname</label>
                <input id="surnamesignup" name="surnamesignup" required="required" type="text" placeholder="lastname" />
            </p>

          

           

          



        <%--   <h2>${requestScope.message}</h2> 

        --%>

        <%--   PrintWriter out = response.getWriter();
               out.println("<script type=\"text/javascript\">");
                       out.println("alert('update successfull');");
               out.println("location='login.jsp';");
               out.println("</script>");

        --%>
    </body>
</html>
