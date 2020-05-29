<!--#include file="js/doc.js" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>

<title>资生堂丽源化妆品有限公司</title>
<META content="text/html; charset=utf-8" http-equiv=Content-type><!-- TextboxList is not priceless for commercial use. See <http://devthought.com/projects/mootools/textboxlist/> --><!-- required stylesheet for TextboxList -->
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link type="text/css" href="css/jquery-ui-1.7.2.custom.css" rel="stylesheet" />	
<link rel="stylesheet" type="text/css" media="screen" href="css/niceforms.css" />
<link href="css/style_main.css"  rel="stylesheet" type="text/css" />
<script language="javascript" src="js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.7.2.custom.min.js"></script>
<script type="text/javascript" src="js/jquery.jmpopups-0.5.1.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<!--#include file="js/correctPng.js"-->
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	$(document).ready(function (){
		//alert("ok");
		
		$("#form1").ajaxForm(function(data){
			if(data==0){
				alert("邮件发送成功。");
			}else{
				alert("收件人不能为空！");
			}
		});
		
		$("#selUser").click(function(){
			selUsers();
		});
		$("#selUser2").click(function(){
			selUsers();
		});
		$("#acsGroup").change(function(){
			alert($("#acsGroup").val());
			selUsers();
		});
		$("#company").change(function(){
			selUsers();
		});
		$("#userStatus").change(function(){
			selUsers();
		});
		
		$("#selUser").get(0).checked = true;
		setDropList();
		selUsers();
	});
	
	function openUserCart(){
		window.open("userManagement.asp?times=" + (new Date().getTime()),"_self");
	}
	
	function selUsers(){
		var c = "";
		if($("#selUser").get(0).checked == true){
			//alert("1");
			$("#receiver").val('<%=Session("userCart")%>');
		}else{
			if($("#acsGroup").val() != "-1"){
				c = "acsGroup =" + $("#acsGroup").val();
			}
			if($("#company").val() != "-1"){
				if(c == ""){
					c = "companyID =" + $("#company").val();
				}else{
					c += " and companyID =" + $("#company").val();
				}
			}
			if($("#userStatus").val() != "-1"){
				if(c == ""){
					c = "status =" + $("#userStatus").val();
				}else{
					c += " and status =" + $("#userStatus").val();
				}
			}

			$.get("userControl.asp?type=getUserNameListByWhere&where=" + c + "&times=" + (new Date().getTime()),function(re){
				//alert(unescape(re));
				$("#receiver").val(unescape(re));
			});
		}
	}
	
	function setDropList(){
		$.get("commonControl.asp?op=getGroupList&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split(",");
			$("#acsGroup").empty();
			$("<option value='-1'>全部</option>").appendTo("#acsGroup");
			if(ar.length > 0){
				for(i=0; i<ar.length; i++){
					var ar1 = new Array();
					ar1 = ar[i].split("|");
					$("<option value='" + ar1[0] + "'>" + ar1[1] + "</option>").appendTo("#acsGroup");
				}
			}
		});
		$.get("commonControl.asp?op=getCompanyList&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split(",");
			$("#company").empty();
			$("<option value='-1'>全部</option>").appendTo("#company");
			if(ar.length > 0){
				for(i=0; i<ar.length; i++){
					var ar1 = new Array();
					ar1 = ar[i].split("|");
					$("<option value='" + ar1[0] + "'>" + ar1[1] + "</option>").appendTo("#company");
				}
			}
		});
		$.get("commonControl.asp?op=getUserStatusList&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split(",");
			$("#userStatus").empty();
			$("<option value='-1'>全部</option>").appendTo("#userStatus");
			if(ar.length > 0){
				for(i=0; i<ar.length; i++){
					var ar1 = new Array();
					ar1 = ar[i].split("|");
					$("<option value='" + ar1[0] + "'>" + ar1[1] + "</option>").appendTo("#userStatus");
				}
			}
		});
	}
</SCRIPT>

</HEAD>
<BODY>
<div id="layout">
	<div id="header">
	<h1>SLC NAC</h1>
	</div>
	<!--#include file="js/mainMenu.js" -->
	<form id="form1" name="form1" method="post" action="emailControl.asp">
	<table border="0" cellpadding="0" cellspacing="0" height="450">
		<tr>
			<td colspan="3" scope="col">
				<div align="left">
					<input type="submit" id="sendMail" style="height:20;vertical-align:middle;border:solid 1px; background: #fff;" value=" 发送 ">&nbsp;&nbsp;
					<input type="reset" id="reWrite" style="height:20;vertical-align:middle;border:solid 1px; background: #fff;" value=" 重写 ">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					<input type="radio" value="0" name="selUser" id="selUser">预选用户&nbsp;&nbsp;&nbsp;
					<input type="radio" value="1" name="selUser" id="selUser2">全部用户&nbsp;&nbsp;&nbsp;&nbsp;
					ACS组别：<select id="acsGroup" name="acsGroup" style="width:60px"></select>&nbsp;&nbsp;&nbsp;&nbsp;
					公司：<select id="company" name="company" style="width:100px"></select>&nbsp;&nbsp;&nbsp;&nbsp;
					状态：<select id="userStatus" name="userStatus" style="width:50px"></select>
				</div>
			</td>
		</tr>
		<tr>
			<td>发件人：
			</td>
			<td colspan="2" scope="col">
				<%
				var support = "";
				sql = "SELECT item FROM dictionaryDoc WHERE ID=1 and kind='support'";
				var rs = conn.Execute(sql);
				if (!rs.EOF){
				%>
				<DIV id="sender"> <%=rs("item").value%> </DIV>
				<%
				}
				rs.Close();
				%>
			</td>
		</tr>
		<tr>
			<td>收件人：
			</td>
			<td>
				<DIV><textarea id="receiver" name="receiver" cols="120" rows="3"></textarea>
				</DIV>
			</td>
			<td>
					<input type="button" id="openCart" onClick="openUserCart()" style="height:20;vertical-align:middle;border:solid 1px; background: url('images/find.png');" value=".   ." title="查找联系人">
			</td>
		</tr>
		<tr>
			<td>标题：
			</td>
			<td colspan="2" scope="col">
				<input id="subject" name="subject" type="text" size="118">
			</td>
		</tr>
		<tr>
			<td>内容：
			</td>
			<td colspan="2" scope="col">
				<textarea id="content" name="content" cols="120" rows="15"></textarea>
			</td>
		</tr>
	</table>
	</form>
	<div class="clear"></div>
	<!--#include file="js/mainFooter.js" -->

</div>

</BODY>
</HTML>
