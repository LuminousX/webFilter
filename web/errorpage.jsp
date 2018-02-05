<%-- 
    Document   : errorpage
    Created on : Jan 24, 2018, 9:44:52 AM
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


        <script language="javascript">

            function fncAlert()
            {
                alert('Hello ThaiCreate.Com');
            }
        </script>

        <form action="page.cgi" method="post" name="form1">
            <input name="btnButton1" type="button" value="Hello" OnClick="JavaScript:fncAlert();">
            
            <br>
            <br>

            <table width="142"  border="1" OnClick="JavaScript:fncAlert();">
                <tr>
                    <td><div align="center">Hello</div></td>

                </tr>

            </table>

            <br>

            <br>

            <span OnClick="JavaScript:fncAlert();">Hello</span>

            <br>

            <br>

            <input name="btnButton2" type="button" value="Hello & Hide" OnClick="JavaScript:fncAlert();this.style.display = 'none';">

            <br>

            <br>

            <table width="142"  border="1" OnClick="JavaScript:fncAlert();this.bgColor = '#0000FF'" style="cursor:hand">

                <tr>

                    <td><div align="center">Hello & Bg Color</div></td>

                </tr>

            </table>

        </form>




    </body>
</html>
