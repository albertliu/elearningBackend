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
	var op = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		op = "<%=op%>";
		
		getDicList("fromKind","fromKind",0);
        getComList("saler","userInfo","username","realName","status=0 and host='" + currHost + "' and username in(select username from roleUserList where roleID='saler') order by realName",0);
		
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
		$.get("studentControl.asp?op=getSalerUnitNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#unitName").val(ar[1]);
				$("#taxNo").val(ar[2]);
				$("#fromKind").val(ar[6]);
				$("#saler").val(ar[3]);
				$("#phone").val(ar[9]);
				$("#email").val(ar[11]);
				$("#linker").val(ar[8]);
				$("#address").val(ar[10]);
				$("#association").val(ar[12]);
				$("#memo").val(ar[13]);
				$("#regDate").val(ar[14]);
				$("#registerID").val(ar[15]);
				$("#registerName").val(ar[16]);
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		if($("#memo").val()==""){
			jAlert("基本情况不能为空");
			return false;
		}
		if($("#unitName").val()==""){
			jAlert("企业名称不能为空");
			return false;
		}
		// alert($("#ID").val() + "&taxNo=" + $("#taxNo").val() + "&address=" + encodeURI($("#address").val()) + "&phone=" + encodeURI($("#phone").val()) + "&email=" + encodeURI($("#email").val()) + "&linker=" + encodeURI($("#linker").val()) + "&item=" + escape($("#unitName").val()) + "&association=" + encodeURI($("#association").val()) + "&memo=" + escape($("#memo").val()) + "&kindID=" + $("#fromKind").val() + "&saler=" + currUser);
		$.get("studentControl.asp?op=updateSalerUnitInfo&nodeID=" + $("#ID").val() + "&taxNo=" + $("#taxNo").val() + "&address=" + encodeURI($("#address").val()) + "&phone=" + encodeURI($("#phone").val()) + "&email=" + encodeURI($("#email").val()) + "&linker=" + encodeURI($("#linker").val()) + "&item=" + escape($("#unitName").val()) + "&association=" + encodeURI($("#association").val()) + "&memo=" + escape($("#memo").val()) + "&kindID=" + $("#fromKind").val() + "&refID=" + currUser + "&times=" + (new Date().getTime()),function(re){
			// jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(op == 1){
				op = 0;
				nodeID = ar[0];
				getNodeInfo(nodeID);
			}
			jAlert("保存成功！","信息提示");
			updateCount += 1;
		});
		//return false;
	}
	
	function setButton(){
		$("#btnSave").hide();
		$("#btnAdd").hide();
		if(checkRole("saler")){
			$("#btnAdd").show();
		}
		if(op ==1){
			setEmpty();
			$("#btnAdd").hide();
		}
		if($("#registerID").val() == currUser || $("#saler").val()==currUser || checkRole("leader")){
			$("#btnSave").show();
		}
	}
	
	function setEmpty(){
		nodeID = 0;
		$("#ID").val(0);
		$("#unitName").val("");
		$("#memo").val("");
		$("#taxNo").val("");
		$("#address").val("");
		$("#phone").val("");
		$("#email").val("");
		$("#linker").val("");
		$("#association").val("");
		$("#saler").val(currUser);
		$("#fromKind").val(0);
		$("#regDate").val(currDate);
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
				<td align="right">企业名称</td><input type="hidden" id="ID" /><input type="hidden" id="registerID" />
				<td><input type="text" id="unitName" style="width:300px;" /></td>
				<td align="right">统一编码</td>
				<td><input type="text" id="taxNo" style="width:150px;" /></td>
			</tr>
			<tr>
				<td align="right">资源属性</td>
				<td><select id="fromKind" style="width:100px;"></select>&nbsp;&nbsp;&nbsp;&nbsp;所属协会&nbsp;<input id="association" style="padding:2px;width:120px;" /></td>
				<td align="right">销售</td>
				<td><select id="saler" style="width:100px"></select></td>
			</tr>
			<tr>
				<td align="right">基本情况</td>
				<td colspan="3"><textarea id="memo" style="padding:2px;width:100%;" rows="5"></textarea></td>
			</tr>
			<tr>
				<td align="right">联系地址</td>
				<td colspan="3"><input id="address" style="padding:2px;width:100%;" /></td>
			</tr>
			<tr>
				<td align="right">联系人</td>
				<td colspan="3"><input id="linker" style="padding:2px;width:100%;" /></td>
			</tr>
			<tr>
				<td align="right">联系电话</td>
				<td><input type="text" id="phone" style="width:300px;" /></td>
				<td align="right">邮箱</td>
				<td><input type="text" id="email" style="width:150px;" /></td>
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
  	<input class="button" type="button" id="btnSave" value="保存" />&nbsp;
  	<input class="button" type="button" id="btnAdd" value="添加" />&nbsp;
  </div>
</div>
</body>
