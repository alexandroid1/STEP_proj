<%@ page import="ximple.b2c.dao.*" %>
<%@ page import="ximple.b2c.beans.User" %>
<%@ page import="java.util.List" %>
<%--
  Created by IntelliJ IDEA.
  User: admin
  Date: 06.05.2015
  Time: 15:34
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
  <head>
    <title>  </title>


  </head>
  <body>
  <%= request.getContextPath() %>
  <%
    User u = new User();
    u.setId(1l);
    List<User> users = UserDao.getInstance().getAllUsers();
  %>


    //

  </body>
</html>
