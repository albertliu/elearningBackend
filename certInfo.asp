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
		
		getComList("host","hostInfo","hostNo","hostName","status=0 order by hostNo",1);
		getComList("agencyID","agencyInfo","agencyID","agencyName","status=0 order by agencyID",1);
		getDicList("certKind","kindID",0);
		getDicList("statusEffect","status",0);
		getDicList("certType","type",0);
		getDicList("courseMark","mark",0);
		
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
		$.get("certControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#certID").val(ar[1]);
				$("#certName").val(ar[2]);
				$("#term").val(ar[3]);
				$("#termExt").val(ar[17]);
				$("#kindID").val(ar[4]);
				$("#status").val(ar[5]);
				$("#agencyID").val(ar[8]);
				$("#memo").val(ar[10]);
				$("#regDate").val(ar[11]);
				$("#registerName").val(ar[13]);
				$("#hours").val(ar[14]);
				$("#host").val(ar[15]);
				$("#type").val(ar[18]);
				$("#mark").val(ar[19]);
				$("#shortName").val(ar[21]);
				$("#days_study").val(ar[22]);
				$("#days_exam").val(ar[23]);
				$("#days_diploma").val(ar[24]);
				$("#days_archive").val(ar[25]);
				
				//getDownloadFile("certID");
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		//alert($("#certID").val() + "&item=" + ($("#memo").val()));
		$.get("certControl.asp?op=update&nodeID=" + $("#ID").val() + "&certID=" + $("#certID").val() + "&certName=" + escape($("#certName").val()) + "&shortName=" + escape($("#shortName").val()) + "&term=" + $("#term").val() + "&termExt=" + $("#termExt").val() + "&kindID=" + $("#kindID").val() + "&status=" + $("#status").val() + "&type=" + $("#type").val() + "&mark=" + $("#mark").val() + "&host=" + $("#host").val() + "&agencyID=" + $("#agencyID").val() + "&days_study=" + $("#days_study").val() + "&days_exam=" + $("#days_exam").val() + "&days_diploma=" + $("#days_diploma").val() + "&days_archive=" + $("#days_archive").val() + "&memo=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
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
		if(checkPermission("courseAdd")){
			$("#save").show();
		}
	}
	
	function setEmpty(){
		$("#ID").val(0);
		$("#certID").val("");
		$("#certName").val("");
		$("#shortName").val("");
		$("#memo").val("");
		$("#status").val(0);
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
				<td align="right">项目编号</td><input id="ID" type="hidden" />
				<td><input type="text" id="certID" size="25" /></td>
				<td align="right">项目名称</td>
				<td><input type="text" id="certName" size="25" /></td>
			</tr>
			<tr>
				<td align="right">课时</td>
				<td><input class="readOnly" type="text" id="hours" size="25" readOnly="true" /></td>
				<td align="right">发证机构</td>
				<td><select id="agencyID" style="width:180px;"></select></td>
			</tr>
			<tr>
				<td align="right">类型</td>
				<td><select id="kindID" style="width:100px;"></select></td>
				<td align="right">专属公司</td>
				<td><select id="host" style="width:180px;"></select></td>
			</tr>
			<tr>
				<td align="right">状态</td>
				<td><select id="status" style="width:100px;"></select></td>
				<td align="right">认证方式</td>
				<td><select id="type" style="width:100px;"></select></td>
			</tr>
			<tr>
				<td align="right">有效期限</td>
				<td><input type="text" id="term" size="3" />年&nbsp;&nbsp;&nbsp;系统内</td>
				<td align="right">有效期限</td>
				<td><input type="text" id="termExt" size="3" />年&nbsp;&nbsp;&nbsp;系统外</td>
			</tr>
			<tr>
				<td align="right">可选人员</td>
				<td><select id="mark" style="width:180px;"></select></td>
				<td align="right">简称</td>
				<td><input type="text" id="shortName" size="25" /></td>
			</tr>
			<tr>
				<td align="right">上课周期</td>
				<td><input type="text" id="days_study" size="25" /></td>
				<td align="right">考试周期</td>
				<td><input type="text" id="days_exam" size="25" /></td>
			</tr>
			<tr>
				<td align="right">制证周期</td>
				<td><input type="text" id="days_diploma" size="25" /></td>
				<td align="right">归档周期</td>
				<td><input type="text" id="days_archive" size="25" /></td>
			</tr>
			<tr>
				<td align="right">说明</td>
				<td colspan="5"><textarea id="memo" style="padding:2px; width:100%;" rows="5"></textarea></td>
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
