<!--#include file="js/doc.js" -->
<%
var nodeID = "";

if (String(Request.QueryString("nodeID")) != "undefined" && 
    String(Request.QueryString("nodeID")) != "" && String(Request.QueryString("nodeID")) != "null") { 
  nodeID = String(Request.QueryString("nodeID"));
}
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner.css"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script type="text/javascript" src="js/md5.min.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var nodeID = "";
	<!--#include file="js/commFunction.js"-->
	
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";

		$("#title").html(currUser + " 用户密码设置");
		$("#userName").val(currUser.split(".")[0]);
		$("#newPasswd").val()="";
		$("#confirmPasswd").val()="";
	});

	function saveNode(){
		if($("#userName").val()==""){
			jAlert("用户名不能为空!","信息提示");
			return false;
		}
		if($("#newPasswd").val()==""){
			jAlert("新密码不能为空!","信息提示");
			return false;
		}
		if($("#newPasswd").val() != $("#confirmPasswd").val()){
			jAlert("两次输入的密码不一致!","信息提示");
			return false;
		}
		//alert("userName=" + currUser + "&passwd=" + ($("#newPasswd").val()));
		$.get("userControl.asp?op=changePasswd&userName=" + currUser + "&passwd=" + md5($("#newPasswd").val()) + "&p=1&times=" + (new Date().getTime()),function(data){
			//alert((data));
			//jAlert("密码修改成功。","信息提示");
		});
	}

</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
	<div id="title" style="color:blue;margin:0;padding:5px;text-align:center;width:97%;"></div>
	
	<div style="width:100%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" id="detailCover" style="background:#f5faf8;">
          <table border="0" cellpadding="0" cellspacing="0" width="100%" style="line-height:10px;">
            <tr>
              <td>用户名</td>
              <td><input class="readOnly" type="text" id="userName" size="30" readOnly="true" /></td>
            </tr>
            <tr>
              <td>新密码</td>
              <td><input id="newPasswd" name="newPasswd" type="password" size="30" /></td>
            </tr>
            <tr>
              <td>密码确认</td>
              <td><input id="confirmPasswd" name="confirmPasswd" type="password" size="30" /></td>
            </tr>
          </table>
			</div>
		</div>
	</div>
</div>
</body>
