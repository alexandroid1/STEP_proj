<%@ page import="ximple.b2c.dao.*" %>
<%@ page import="ximple.b2c.beans.User" %>
<%@ page import="java.util.List" %>
<%@ page import="ximple.b2c.beans.Category" %>
<%@ page import="java.util.LinkedList" %>
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

    <title>Ximple</title>
    <style type="text/css">
        div#container
        {
            width: 1000px;
            position: relative;
            margin-top: 0px;
            margin-left: auto;
            margin-right: auto;
            text-align: left;
        }
        body
        {
            font-size: 8px;
            line-height: 1.1875;
            text-align: center;
            margin: 0;
            background-color: #FFFFFF;
            color: #000000;
        }
    </style>
    <link href="${pageContext.request.contextPath}/resources/jquery.ui.all.css" rel="stylesheet" type="text/css">
    <style type="text/css">
        a
        {
            color: #0000FF;
            text-decoration: underline;
        }
        a:visited
        {
            color: #800080;
        }
        a:active
        {
            color: #FF0000;
        }
        a:hover
        {
            color: #0000FF;
            text-decoration: underline;
        }
    </style>
    <style type="text/css">
        #Image1
        {
            border: 0px #000000 solid;
        }
        #Marquee1
        {
            background-color: transparent;
            border: 1px #1E90FF none;
            text-align: center;
        }
        #TabMenu1
        {
            text-align: left;
            float: left;
            margin: 0;
            width: 100%;
            font-family: Arial;
            font-size: 13px;
            font-weight: normal;
            border-bottom: 1px solid #C0C0C0;
            list-style-type: none;
            padding: 15px 0px 4px 10px;
            overflow: hidden;
        }
        #TabMenu1 li
        {
            float: left;
        }
        #TabMenu1 li a.active, #TabMenu1 li a:hover.active
        {
            background-color: #FFFFFF;
            color: #666666;
            position: relative;
            font-weight: normal;
            text-decoration: none;
            z-index: 2;
        }
        #TabMenu1 li a
        {
            padding: 5px 14px 8px 14px;
            border: 1px solid #C0C0C0;
            border-top-left-radius: 5px;
            border-top-right-radius: 5px;
            background-color: #EEEEEE;
            color: #666666;
            margin-right: 3px;
            text-decoration: none;
            border-bottom: none;
            position: relative;
            top: 0;
            -webkit-transition: 200ms all linear;
            -moz-transition: 200ms all linear;
            -ms-transition: 200ms all linear;
            transition: 200ms all linear;
        }
        #TabMenu1 li a:hover
        {
            background: #C0C0C0;
            color: #666666;
            font-weight: normal;
            text-decoration: none;
            top: -4px;
        }
        #SiteSearch1_keyword
        {
            border: 1px #A9A9A9 solid;
            background-color: #FFFFFF;
            color :#000000;
            font-family: Arial;
            font-size: 13px;
            text-align: left;
            vertical-align: middle;
        }
        #SiteSearch1_label
        {
            color: #A9A9A9;
            cursor: text;
            font-family: Arial;
            font-size: 13px;
            text-align: left;
        }
        #Button1
        {
            border: 1px #A9A9A9 solid;
            background-color: #F0F0F0;
            color: #A9A9A9;
            font-family: Arial;
            font-size: 13px;
        }
        .loginform_table
        {
            background-color: #EEEEEE;
            border-color:#878787;
            border-width:1px;
            border-style: solid;
            color: #000000;
            border-spacing: 4px;
            font-family: Arial;
            font-size: 13px;
            text-align: right;
        }
        .loginform_header
        {
            background-color: #878787;
            color: #FFFFFF;
            text-align: center;
        }
        .loginform_text
        {
            background-color: #FFFFFF;
            border-color: #878787;
            border-width: 1px;
            border-style: solid;
            color: #000000;
            font-family: Arial;
            font-size: 13px;
        }
        .loginform_button
        {
            background-color: #FFFFFF;
            border-color: #878787;
            border-width: 1px;
            border-style: solid;
            color: #000000;
            font-family: Arial;
            font-size: 13px;
        }
        #jQueryMenu1, #jQueryMenu1 .ui-menu-item a
        {
            font-family: Arial;
            font-size: 13px;
        }
        #jQueryMenu1 li
        {
            list-style: none;
            width: auto;
        }
        #jQueryMenu1
        {
            padding: 2px 2px 2px 2px;
        }
        #jQueryMenu1 .ui-menu-item a
        {
            line-height: 17px;
            padding: 2px 2px 2px 2px;
        }
        #jQueryMenu1 li ul .ui-menu-item
        {
            width: 90px;
        }
        #wb_Carousel1
        {
            background-color: transparent;
        }
        #Carousel1 .frame
        {
            width: 491px;
            display: inline-block;
            float: left;
            height: 355px;
        }
        #wb_Carousel1 .pagination
        {
            bottom: 0;
            left: 0;
            position: absolute;
            text-align: center;
            vertical-align: middle;
            width: 491px;
            z-index: 999;
        }
        #wb_Carousel1 .pagination img
        {
            border-style: none;
            padding: 12px 12px 12px 12px;
        }
        #PhotoGallery1
        {
            border-spacing: 3px;
            width: 100%;
        }
        #PhotoGallery1 .figure
        {
            padding: 0px 0px 0px 0px;
            text-align: center;
            vertical-align: top;
        }
        #PhotoGallery1 .caption
        {
            color: #000000;
            font-family: Arial;
            font-size: 13px;
            margin: 0px;
            text-align: center;
            text-decoration: none;
        }
        #PhotoGallery1 .figure img
        {
            border: 0px #000000 solid;
        }
        #Line1
        {
            color: #A0A0A0;
            background-color: #A0A0A0;
            border-width: 0px;
        }
        #Image2
        {
            border: 0px #000000 solid;
        }
    </style>

    <link rel="stylesheet"  href="http://maxcdn.bootstrapcdn.com/bootstrap/3.3.4/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="http://maxcdn.bootstrapcdn.com/font-awesome/4.3.0/css/font-awesome.min.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/resources/star-rating.css" media="all" rel="stylesheet" type="text/css"/>
    <script src="http://ajax.googleapis.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script src="${pageContext.request.contextPath}/resources/star-rating.js" type="text/javascript"></script>

    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/jquery.ui.core.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/jquery.ui.widget.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/jquery.ui.position.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/jquery.ui.menu.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/wb.carousel.min.js"></script>
    <script type="text/javascript" src="${pageContext.request.contextPath}/resources/searchindex.js"></script>


    <script type="text/javascript">

        var features = 'toolbar=no,menubar=no,location=no,scrollbars=yes,resizable=yes,status=no,left=,top=,width=,height=';
        var searchDatabase = new SearchDatabase();
        var searchResults_length = 0;
        var searchResults = new Object();
        function searchPage(features)
        {
            var element = document.getElementById('SiteSearch1_keyword');
            if (element.value.length != 0 || element.value != " ")
            {
                var value = unescape(element.value);
                var keywords = value.split(" ");
                searchResults_length = 0;
                for (var i=0; i<database_length; i++)
                {
                    var matches = 0;
                    var words = searchDatabase[i].title + " " + searchDatabase[i].description + " " + searchDatabase[i].keywords;
                    for (var j = 0; j < keywords.length; j++)
                    {
                        var pattern = new RegExp(keywords[j], "i");
                        var result = words.search(pattern);
                        if (result >= 0)
                        {
                            matches++;
                        }
                        else
                        {
                            matches = 0;
                        }
                    }
                    if (matches == keywords.length)
                    {
                        searchResults[searchResults_length++] = searchDatabase[i];
                    }
                }
                var wndResults = window.open('about:blank', '', features);
                setTimeout(function()
                {
                    var results = '';
                    var html = '<html><head><meta http-equiv="Content-Type" content="text/html; charset=UTF-8"><title>Search results<\/title><\/head>';
                    html = html + '<body style="background-color:#FFFFFF;margin:0;padding:2px 2px 2px 2px;">';
                    html = html + '<span style="font-family:Arial;font-size:13px;color:#000000">';
                    for (var n=0; n<searchResults_length; n++)
                    {
                        var page_keywords = searchResults[n].keywords;
                        results = results + '<strong><a style="color:#0000FF" target="_parent" href="'+searchResults[n].url+'">'+searchResults[n].title +'<\/a><\/strong><br>Keywords: ' + page_keywords +'<br><br>\n';
                    }
                    if (searchResults_length == 0)
                    {
                        results = 'No results';
                    }
                    else
                    {
                        html = html + searchResults_length;
                        html = html + ' result(s) found for search term: ';
                        html = html + value;
                        html = html + '<br><br>';
                    }
                    html = html + results;
                    html = html + '<\/span>';
                    html = html + '<\/body><\/html>';
                    wndResults.document.write(html);
                },100);
            }
            return false;
        }
        function searchParseURL()
        {
            var url = window.location.href;
            if (url.indexOf('?') > 0)
            {
                var terms = '';
                var params = url.split('?');
                var values = params[1].split('&');
                for (var i=0;i<values.length;i++)
                {
                    var param = values[i].split('=');
                    if (param[0] == 'q')
                    {
                        terms = unescape(param[1]);
                        break;
                    }
                }
                if (terms != '')
                {
                    var element = document.getElementById('SiteSearch1_keyword');
                    element.value = terms;
                    searchPage('');
                }
            }
        }
    </script>



    <script type="text/javascript">
        $(document).ready(function()
        {
            searchParseURL();
            var $search = $('#SiteSearch1_form');
            var $searchInput = $search.find('input');
            var $searchLabel = $search.find('label');
            if ($searchInput.val())
            {
                $searchLabel.hide();
            }
            $searchInput.focus(function()
            {
                $searchLabel.hide();
            }).blur(function()
            {
                if (this.value == '')
                {
                    $searchLabel.show();
                }
            });
            $searchLabel.click(function()
            {
                $searchInput.trigger('focus');
            });
            var jQueryMenu1Opts =
            {
                icons: { submenu: 'ui-icon-carat-1-e' },
                position: { my: 'left top', at: 'right top' }
            };
            $("#jQueryMenu1").menu(jQueryMenu1Opts);
            var Carousel1Opts =
            {
                delay: 3000,
                duration: 500,
                easing: 'linear',
                mode: 'forward',
                direction: '',
                pagination: true,
                pagination_img_default: 'images/page_default.png',
                pagination_img_active: 'images/page_active.png',
                start: 0,
                width: 491
            };
            $("#Carousel1").carousel(Carousel1Opts);
            $("#Carousel1_back a").click(function()
            {
                $('#Carousel1').carousel('prev');
            });
            $("#Carousel1_next a").click(function()
            {
                $('#Carousel1').carousel('next');
            });
        });
    </script>

</head>
<body>

<%--<div id="wb_jQueryMenu1" style="position:absolute;left:100px;top:228px;width:90px;height:322px;z-index:1006;">
    <ul id="jQueryMenu1" style="">
        <li><a href="#">Category1</a>
            <ul>
                <li><a href="#">Subcategory1</a></li>
                <li><a href="#">Subcategory2</a></li>
                <li><a href="#">Subcategory3</a></li>
                <li><a href="#">Subcategory4</a></li>
            </ul>
        </li>
        <li><a href="#">Category2</a>
            <ul>
                <li><a href="#">Subcategory1</a></li>
                <li><a href="#">Subcategory2</a></li>
                <li><a href="#">Subcategory3</a></li>
                <li><a href="#">Subcategory4</a></li>
            </ul>
        </li>
        <li><a href="#">Category3</a></li>
        <li><a href="#">Category4</a></li>
        <li><a href="#">Category5</a></li>
        <li><a href="#">Category6</a></li>
        <li><a href="#">Category7</a></li>
        <li><a href="#">Category8</a></li>
        <li><a href="#">Category9</a></li>
        <li><a href="#">Category10</a></li>
        <li><a href="#">Category11</a></li>
        <li><a href="#">Category12</a></li>
        <li><a href="#">Category13</a></li>
        <li><a href="#">Category14</a></li>
    </ul>
</div>--%>

<%= request.getContextPath() %>
<%
    User u = new User();
    u.setId(1l);
    // List<User> users = UserDao.getInstance().getAllUsers();
%>

    <%!
        public void recursiveTree(Category c, StringBuilder sb, int level) {
            if(c.getChildren().size()>0) {
                //sb.append("<li><a href=\"#\"> " + "Level" + level + "  " + c.getId() + "  " + c.getName() + "   -parent: " + c.getParentId() + " </a>\n");
                sb.append("<li><a href=\"#\"> " + "  " + c.getName() +  " </a>\n");
            } else {
                //sb.append("<li><a href=\"#\"> " + "Level" + level + "  " + c.getId() + "  " + c.getName() + "   -parent: " + c.getParentId() + " </a></li>\n");
                sb.append("<li><a href=\"#\"> " +   c.getName() + " </a></li>\n");
            }
            if(c.getChildren().size()>0){
                level++;
                sb.append("\n  <ul >\n");
                for(Category ic: c.getChildren()){
                    recursiveTree(ic, sb, level);
                }
                sb.append("\n  </ul  >\n");
                sb.append("\n  </li>\n");

                level--;
            }

            //return sb.toString();
        }
    %>
    <%
        List<Category> categories = (List<Category>) request.getAttribute("categories");
        StringBuilder sb = new StringBuilder();

        for(Category c : categories){
            recursiveTree(c, sb, 0);
        }

        out.write("<div id=\"wb_jQueryMenu1\" style=\"position:absolute;left:100px;top:228px;width:200px;height:322px;z-index:1006;\">\n");
        out.write("<ul id=\"jQueryMenu1\" style=\"\" >\n");
        out.write(sb.toString());
        out.write("</ul>\n");
        out.write("</div>\n");
    %>
    <%--LinkedList<Category> stackCategories = new LinkedList(categories);--%>
    <%--while(!stackCategories.isEmpty()){--%>
    <%--Category c= stackCategories.removeFirst();--%>
    <%--%>--%>

    <%--<li> <%= c.getId() %>  <%= c.getName() %>  -parent:<%= c.getParentId() %>  </li>--%>

    <%--<%--%>
    <%--if(c.getChildren().size()>0){--%>
    <%--for(Category innerCategory: c.getChildren() ){--%>
    <%--stackCategories.addFirst(innerCategory);--%>
    <%--}--%>
    <%--}--%>
    <%--System.out.println("after");--%>
    <%--}--%>




</body>
</html>
