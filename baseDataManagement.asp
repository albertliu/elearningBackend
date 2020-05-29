<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Frameset//EN" "http://www.w3.org/TR/html4/frameset.dtd">
<!--#include file="js/doc.js" -->
<%
var nodeID = "0";
var tLen = 0;
if (String(Request.QueryString("nodeID")) != "undefined" && 
    String(Request.QueryString("nodeID")) != "") { 
   nodeID = (Request.QueryString("nodeID"));
}
if (String(Request.QueryString("tLen")) != "undefined" && 
    String(Request.QueryString("tLen")) != "") { 
  tLen = Request("tLen");
}
%>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><%=pageTitle%></title>
</head>

<frameset rows="*" cols="235,*" frameborder="NO" border="0" framespacing="0">
  <frame src="baseDataManagementLeft.asp?times<%=(new Date().getTime())%>" name="leftFrame" scrolling="NO" noresize>
  <frameset frameborder="NO" border="0" framespacing="0">
    <frame src="baseDataManagementDetail.asp?nodeID=<%=nodeID%>&tLen=<%=tLen%>&times<%=(new Date().getTime())%>" name="mainFrame">
  </frameset>
</frameset>
<noframes><body>
</body></noframes>
</html>
