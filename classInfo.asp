﻿<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css?ver=1.1"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link rel="stylesheet" type="text/css" href="css/jquery.autocomplete.css" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<script type='text/javascript' src='js/jquery.autocomplete.js'></script>
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var nodeID = 0;
	var op = 0;
	var refID = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		refID = "<%=refID%>";
		op = "<%=op%>";
		
		getComList("certID","certificateInfo","certID","certName","status=0 and type=0 order by certID",1);
		getComList("projectID","projectInfo","projectID","projectName","status=1 order by projectID desc",1);
		getComList("adviserID","userInfo","username","realName","status=0 and username in(select username from roleUserList where roleID='adviser') order by realName",1);
		getDicList("planStatus","status",0);
		$("#dateStart").click(function(){WdatePicker();});
		$("#dateEnd").click(function(){WdatePicker();});
		
		$.ajaxSetup({ 
			async: false 
		}); 
		
		if(op==0){
			getNodeInfo(nodeID);
		}
		setButton();
		
		$("#save").click(function(){
			saveNode();
		});
	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		$.get("classControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#classID").val(ar[1]);
				$("#projectID").val(ar[2]);
				$("#certID").val(ar[3]);
				$("#kindID").val(ar[5]);
				$("#status").val(ar[6]);
				$("#adviserID").val(ar[8]);
				$("#dateStart").val(ar[10]);
				$("#dateEnd").val(ar[11]);
				$("#classroom").val(ar[12]);
				$("#memo").val(ar[13]);
				$("#regDate").val(ar[14]);
				$("#registerName").val(ar[16]);
				
				//getDownloadFile("classID");
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		//alert($("#classID").val() + "&item=" + ($("#memo").val()));
		$.get("classControl.asp?op=update&nodeID=" + $("#ID").val() + "&projectID=" + $("#projectID").val() + "&classroom=" + escape($("#classroom").val()) + "&certID=" + $("#certID").val() + "&adviserID=" + $("#adviserID").val() + "&kindID=" + $("#kindID").val() + "&status=" + $("#status").val() + "&dateStart=" + $("#dateStart").val() + "&dateEnd=" + $("#dateEnd").val() + "&memo=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				if(op == 1){
					op = 0;
					getNodeInfo(ar[1]);
				}
				jAlert("保存成功！","信息提示");
				updateCount += 1;
			}
			if(ar[0] != 0){
				jAlert("未能成功提交，请退出后重试。","信息提示");
			}
		});
		//return false;
	}
	
	function setButton(){
		$("#save").hide();
		if(op ==1){
			setEmpty();
		}
		if(checkPermission("classAdd")){
			$("#save").show();
		}
	}
	
	function setEmpty(){
		$("#ID").val(0);
		$("#classID").val("");
		$("#projectID").val("");
		$("#adviserID").val("");
		$("#memo").val("");
		$("#status").val(0);
		$("#kindID").val(0);
		$("#classroom").val("");
		$("#dateStart").val("");
		$("#dateEnd").val("");
		$("#regDate").val(currDate);
		$("#registerID").val(currUser);
		$("#registerName").val(currUserName);
	}
	
	function getUpdateCount(){
		return updateCount;
	}
</script>

</head>

<body style="background:#f0f0f0;">
 <!--#include file='commFloatDetail.asp' -->
 <!--#include file='commLoadFileDetail.asp' -->

<div id='layout' align='left' style="background:#f0f0f0;">	
	
	<div style="width:100%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8;">
			<form id="detailCover" name="detailCover" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
			<table>
			<tr>
				<td align="right">班级编号</td><input id="ID" type="hidden" /><input id="kindID" type="hidden" />
				<td><input type="text" id="classID" size="25" class="readOnly" readOnly="true" /></td>
				<td align="right">状态</td>
				<td><select id="status" style="width:100px;"></select></td>
			</tr>
			<tr>
				<td align="right">课程名称</td>
				<td><select id="certID" style="width:180px;"></select></td>
				<td align="right">招生批次</td>
				<td><select id="projectID" style="width:180px;"></select></td>
			</tr>
			<tr>
				<td align="right">开课日期</td>
				<td><input type="text" id="dateStart" size="15" /></td>
				<td align="right">结束日期</td>
				<td><input type="text" id="dateEnd" size="15" />&nbsp;预计</td>
			</tr>
			<tr>
				<td align="right">班主任</td>
				<td><select id="adviserID" style="width:180px;"></select></td>
				<td align="right">上课地点</td>
				<td><input type="text" id="classroom" size="25" /></td>
			</tr>
			<tr>
				<td align="right">说明</td>
				<td colspan="5"><textarea id="memo" style="padding:2px;" rows="5" cols="75"></textarea></td>
			</tr>
			<tr>
				<td align="right">登记人</td>
				<td><input class="readOnly" type="text" id="registerName" size="25" readOnly="true" /></td>
				<td align="right">登记日期</td>
				<td><input class="readOnly" type="text" id="regDate" size="25" readOnly="true" /></td>
			</tr>
			</table>
			</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
  	<input class="button" type="button" id="save" name="save" value="保存" />&nbsp;
  </div>
</div>
</body>