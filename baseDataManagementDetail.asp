<!--#include file="js/doc.js" -->
<%
var nodeID = "";
var tLen = 0;

if (String(Request.QueryString("tLen")) != "undefined" && 
    String(Request.QueryString("tLen")) != "") { 
  tLen = parseInt(Request("tLen"));
}
if (String(Request.QueryString("nodeID")) != "undefined" && 
    String(Request.QueryString("nodeID")) != "") { 
  nodeID = String(unescape(Request.QueryString("nodeID")));
  nodeID = nodeID.substr(0,tLen);
}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title></title>
<link rel="stylesheet" type="text/css" media="screen" href="css/niceforms.css">
<link href="css/style_inner.css"  rel="stylesheet" type="text/css" />
<link type="text/css" href="css/jquery-ui-1.7.2.custom.css" rel="stylesheet" />	
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<script language="javascript" src="js/jquery-1.4.2.min.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.7.2.custom.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<!--#include file="js/correctPng.js"-->
<script language="javascript">
	<!--#include file="js/commFunction.js"-->
	//$.ajaxSetup({ async: false });
	$(document).ready(function () {
  	currPage = "basePage";
  	setCurrMenuItem();
		$("#Cancel").click(function(){
			getNodeInfo($("#mID").val());
		});

		$("#form1").ajaxForm(function(re){
			getNodeInfo($("#mID").val());
			jAlert("保存成功！");
		});

		$("#form2").ajaxForm(function(re){
			if(re == 0){
				getGroupInfo($("#ID").val());
				getGroupList();
				jAlert("保存成功！");
			}else{
				jAlert("编号已存在，不能保存！");
			}
		});
		
		$("#delGroup").click(function(){
			jConfirm("删除后将无法恢复，确实要删除该组吗？","确认对话框",function(r){
				if(r){
					$.get("commonControl.asp?op=delGroup&keyID=" + $("#aID").val() + "&times=" + (new Date().getTime()),function(re){
						setACSgroup();
						getGroupList();
					});
				}
			});
		});
		
		$("#addGroup").click(function(){
			$.get("commonControl.asp?op=getNewGroup&times=" + (new Date().getTime()),function(re){
				setACSgroup();
				$("#ID").val(re);
				$("#aID").val("-1");
				$("#saveGroup").show();
				$("#delGroup").show();
				$("#addGroup").hide();
			});
		});

		$("#groupList").change(function(){
			getGroupInfo($("#groupList").val());
		});
		
		getNodeInfo("<%=nodeID%>");
		getGroupList();
	});
	
	function getNodeInfo(id){
		//alert("id:" + id);
		$("#baseData").show();
		$("#acsGroup").hide();
		$.get("commonControl.asp?op=getDicItemByID&keyID=" + id + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			$("#item").val(ar[2]);
			$("#description").val(ar[4]);
			$("#memo").val(ar[5]);
			$("#item1").html(ar[2]);
		});
		
		$("#mID").val(id);
		if(id>0){
			$("#Cancel").show();	
			$("#Save").show();	
		}else{
			$("#Cancel").hide();	
			$("#Save").hide();	
		}
	}
	
	function setACSgroup(){
		$("#baseData").hide();
		$("#acsGroup").show();
		$("#saveGroup").hide();
		$("#delGroup").hide();
		$("#addGroup").show();
		$("#ID").val('');
		$("#name").val('');
		$("#acsDescription").val('');
	}
	
	function getGroupList(){
		$.get("commonControl.asp?op=getGroupList&times=" + (new Date().getTime()),function(data){
			var ar = new Array();
			ar = (unescape(data)).split(",");
			//alert(ar);
			$("#groupList").empty();
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					$("<option value='" + ar1[0] + "'>" + ar1[0] + '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + ar1[1] + "</option>").appendTo("#groupList");
				});
			}
		});
	}

	function getGroupInfo(id){
		$.get("commonControl.asp?op=getGroupInfo&keyID=" + id + "&times=" + (new Date().getTime()),function(re){
			var ar = new Array();
			ar = (unescape(re)).split("|");
			if(ar>""){
				$("#ID").val(ar[0]);
				$("#aID").val(ar[0]);
				$("#name").val(ar[1]);
				$("#acsDescription").val(ar[2]);
				$("#saveGroup").show();
				$("#delGroup").show();
			}else{
				$("#saveGroup").hide();
				$("#delGroup").hide();
			}
			$("#addGroup").show();
		});
	}

</script>
</head>
<body >
<div id="layout" align="left">
 <!--#include file="js/mainMenu.js" -->
  	<table border="0" cellpadding="0" cellspacing="0" valign="top" width = "100%" style="background:#f0f0ff;">
  		<tr>
  			<td align="left"><div id="title" align="center">&nbsp;</div></td>
  		</tr>
	</table>
	<div align="right" style="background:#f9f9f9;">&nbsp;</div>
	<br>
	<div id="baseData">
		<form name="form1" id="form1" method="post" action="commonControl.asp?op=setDicItem">
			<div id="stylesheetTest"></div>
			<table>
			  <tr>
			    <td><label>项目名称：</label></td>
			    <td>
					<input type="text" id="description" name="description" size="118" readOnly="true" style="background:#f9f9f9;">
			    </td>
			  </tr>
			  <tr>
			    <td><label>项目内容：</label></td>
			    <td>
					<textarea id="item" name="item" cols="120" rows="8"></textarea>
			    </td>
			  </tr>
			  <tr>
			    <td><label>内容预览：</label></td>
			    <td>
					<textarea id="item1" name="item1" cols="120" rows="8" readOnly="true" style="background:#f9f9f9;"></textarea>
			    </td>
			  </tr>
			  <tr>
			    <td><label>说明：</label></td>
			    <td>
					<input type="text" id="memo" name="memo" size="118">
			    </td>
			  </tr>
			</table>
		
			<br>
		  <div align="center" style="background:#fff0ff;"> 
		  	<table>
		  		<tr>
			    <p> 
			      <input name="mID" type="hidden" id="mID" value="">
			      <input type="submit" name="Save"  id="Save" value="  保 存  " style="height:20;vertical-align:middle;border:solid 1px; background: #fff;">&nbsp; 
			      <input type="button" name="Cancel" id="Cancel" value="  取 消  " style="height:20;vertical-align:middle;border:solid 1px; background: #fff;">&nbsp; 
			    </p>
		  			<td>
		    </tr></table>
		  </div>
		</form>
	</div>
	<div id="acsGroup">
		<table>
			<tr>
				<td>
					<div align="center">ACS GROUP 列表</div><br><hr>
			        <div style="width:200;height:400;overflow-x:hidden;">
						<select name="groupList" size="20" multiple="multiple" id="groupList" style="background-color:#FFFFDD; border: '#EEEEFF';width:200px; ">
						</select>
					</div>				
				</td>
				<td>
					<div id="headlines"> 
						<div align="center" style="background:#fff0ff;vertical-align:middle;height:20;">GROUP 内容编辑</div><br><br>
		<form name="form2" id="form2" method="post" action="commonControl.asp?op=updateGroup">
			<table>
 			  <tr>
			    <td><label>组别：</label></td>
			    <td>
					<input type="text" id="ID" name="ID" size="50" style="height:18px;vertical-align:middle;border:solid 1px gray;padding-left:3px;">
			    </td>
			  </tr>
			  <tr>
			    <td><label>名称：</label></td>
			    <td>
					<input type="text" id="name" name="name" size="50" style="height:18px;vertical-align:middle;border:solid 1px gray;padding-left:3px;">
			    </td>
			  </tr>
			  <tr>
			    <td><label>说明：</label></td>
			    <td>
					<input type="text" id="acsDescription" name="acsDescription" size="50" style="height:18px;vertical-align:middle;border:solid 1px gray;padding-left:3px;">
			    </td>
			  </tr>
			</table>
		
			<br>
		  <div align="center" style="background:#fff0ff;"> 
		  	<table>
		  		<tr>
		  			<td width="50" align="left"><span id="success"></span>&nbsp;</td>
		  			<td>
			    <p> 
			      <input name="aID" type="hidden" id="aID" value="">
			      <input type="button" name="addGroup"  id="addGroup" value="  新 增  " style="height:20;vertical-align:middle;border:solid 1px; background: #fff;">&nbsp; 
			      <input type="submit" name="saveGroup"  id="saveGroup" value="  保 存  " style="height:20;vertical-align:middle;border:solid 1px; background: #fff;">&nbsp; 
			      <input type="button" name="delGroup" id="delGroup" value="  删 除  " style="height:20;vertical-align:middle;border:solid 1px; background: #fff;">&nbsp; 
			    </p>
		  			<td>
		    </tr></table>
		  </div>
		</form>
		  </div>
				</td>
			</tr>
	</div>
</div>
</body>
</html>
