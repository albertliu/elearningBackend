<!--#include file="js/doc.js" -->
<%
var nodeID = 0;

if (String(Request.QueryString("nodeID")) != "undefined" && 
    String(Request.QueryString("nodeID")) != "") { 
  nodeID = unescape(Request.QueryString("nodeID"));
}
%>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>无标题文档</title>
	<link rel="stylesheet" href="css/screen.css" />
	<link rel="stylesheet" href="css/emx_nav_left.css" type="text/css">
	
<script language="javascript" src="js/jquery-1.4.2.min.js"></script>
<!--#include file="js/correctPng.js"-->
<script language="javascript">
	$(document).ready(function () {
  });

	function editUserRight(){
		window.top.mainFrame.open("userManagement.asp","_self");
	}
</script>
</head>

<body>
<img src="images/logo.png" >
<table width="100%"  border="0">
	<tr>
		<td>
	  	<div id="pageNav"> 
		  	<div id="sectionLinks"> 
					<a href="#" onClick="editUserRight()">用户及权限管理</a>
				</div>
			</div>
		</td>
	</tr>
</table>
</body>
</html>
