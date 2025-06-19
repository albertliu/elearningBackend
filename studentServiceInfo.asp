<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>

<script language="javascript">
	var nodeID = 0;
	var refID = "";
	var keyID = "";
	var op = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		refID = "<%=refID%>";	//enterID
		keyID = "<%=keyID%>";	//username
		op = "<%=op%>";
		
		getDicList("serviceType","type",0);
		$("#serviceDate").click(function(){WdatePicker();});
		
		$.ajaxSetup({ 
			async: false 
		}); 
		
		if(op==0){
			getNodeInfo(nodeID);
		}
		setButton();
		
		$("#btnSave").click(function(){
			saveNode();
		});
		
		$("#btnAdd").click(function(){
			op = 1;
			setButton();
		});
	});

	function getNodeInfo(id){
		$.get("studentControl.asp?op=getStudentServiceNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				keyID = ar[2];
				refID = ar[3];
				$("#item").val(ar[1]);
				$("#type").val(ar[4]);
				$("#serviceDate").val(ar[6]);
				$("#memo").val(ar[7]);
				$("#regDate").val(ar[8]);
				$("#registerID").val(ar[9]);
				$("#registerName").val(ar[10]);
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		if($("#item").val()==""){
			jAlert("服务内容不能为空");
			return false;
		}
		if($("#serviceDate").val()==""){
			jAlert("服务日期不能为空");
			return false;
		}
		//alert($("#ID").val() + "&refID=" + $("#agencyID").val() + "&agencyName=" + ($("#agencyName").val()) + "&title=" + ($("#title").val()) + "&linker=" +  ($("#linker").val()) + "&kindID=" + $("#kindID").val() + "&status=" + $("#status").val() + "&phone=" +  ($("#phone").val()) + "&email=" + ($("#email").val()) + "&address=" + ($("#address").val()) + "&memo=" + ($("#memo").val()));
		$.get("studentControl.asp?op=updateStudentServiceInfo&nodeID=" + $("#ID").val() + "&item=" + escape($("#item").val()) + "&memo=" + escape($("#memo").val()) + "&keyID=" + keyID + "&refID=" + refID + "&kindID=" + $("#type").val() + "&serviceDate=" + $("#serviceDate").val() + "&times=" + (new Date().getTime()),function(re){
			// jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(op == 1){
				op = 0;
				nodeID = ar[0];
				getNodeInfo(nodeID);
			}
			// jAlert("保存成功！","信息提示");
			updateCount += 1;
		});
		//return false;
	}
	
	function setButton(){
		$("#btnSave").hide();
		$("#btnAdd").hide();
		$("#btnDel").hide();
		if(checkPermission("studentEdit") || checkRole("saler") || checkRole("adviser")){
			$("#btnAdd").show();
		}
		if(op ==1){
			setEmpty();
			$("#btnAdd").hide();
		}
		if($("#registerID").val() == currUser && $("#regDate").val()==currDate){
			$("#btnSave").show();
			$("#btnDel").show();
		}
	}
	
	function setEmpty(){
		nodeID = 0;
		$("#ID").val(0);
		$("#item").val("");
		$("#memo").val("");
		$("#type").val(0);
		$("#regDate").val(currDate);
		$("#serviceDate").val(currDate);
		$("#registerName").val(currUserName);
		$("#registerID").val(currUser);
	}
	
	function getUpdateCount(){
		return updateCount;
	}
</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
	
	<div style="width:100%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8;">
			<form id="detailCover" name="detailCover" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
			<table>
			<tr>
				<td align="right">服务方式</td><input type="hidden" id="ID" /><input type="hidden" id="registerID" />
				<td><select id="type" style="width:100px;"></select></td>
				<td align="right">服务日期</td>
				<td><input type="text" id="serviceDate" style="width:80px;" /></td>
			</tr>
			<tr>
				<td align="right">内容</td>
				<td colspan="3"><textarea id="item" style="padding:2px;width:100%;" rows="5"></textarea></td>
			</tr>
			<tr>
				<td align="right">备注</td>
				<td colspan="3"><textarea id="memo" style="padding:2px;width:100%;" rows="2"></textarea></td>
			</tr>
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
  	<input class="button" type="button" id="btnSave" value="保存" />&nbsp;
  	<input class="button" type="button" id="btnAdd" value="添加" />&nbsp;
  	<input class="button" type="button" id="btnDel" value="删除" />&nbsp;
  </div>
</div>
</body>
