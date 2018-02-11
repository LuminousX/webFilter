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
        <title>JSP Page</title>






    </head>
    <body>

        <%--   <h2>${requestScope.message}</h2> 

        --%>


     

        <div id="mydiv">
            content
        </div>
        <input type="button" id="element" value="test" />
        <div id="result">
        </div>



        <script>
            function save_on_local_storage() {

        // Check browser support
                if (typeof (Storage) != "undefined") {
                    // Store
                    localStorage.setItem("olddiv", $('div').html());
                } else {
                    document.getElementById("result").innerHTML = "Sorry, your browser does not support Web Storage...";
                }

            }

            function get_local_storage() {

        // Check browser support
                if (typeof (Storage) != "undefined") {

                    // Retrieve
                    document.getElementById("result").innerHTML = localStorage.getItem("olddiv");
                } else {
                    document.getElementById("mydiv").innerHTML = "Sorry, your browser does not support Web Storage...";
                }

            }


            $('#element').click(function () {
                save_on_local_storage();
                $('#mydiv').html('Hi There');
            });

            get_local_storage();
        </script>


    </body>
</html>
