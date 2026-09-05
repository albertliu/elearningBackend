<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/data_table_mini.css?v=20150411" rel="stylesheet" type="text/css" />
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="css/jquery.autocomplete.css" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<script type='text/javascript' src='js/jquery.autocomplete.js'></script>
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var nodeID = 0;
	var op = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		op = "<%=op%>";
		
		getDicList("examResult","status",0);
		
		$.ajaxSetup({ 
			async: false 
		}); 
		
		if(op==0){
			getNodeInfo();
		}
		setButton();
		
		$("#btnSave").click(function(){
			saveNode();
		});
	});

	function getNodeInfo(){
		//alert(refID + ":" + nodeID);
		$.post(uploadURL + "/public/postCommInfo", {proc:"getExamPlaceInfo", params:{ID:nodeID}}, function(data){
			let ar = data[0];
			if(data.length > 0){
				$("#courseName").val(ar["courseName"]);
				$("#examAddress").val(ar["examAddress"]);
				$("#examDate").val(ar["examDate"]);
				$("#s_all").val(ar["s_all"]);
				$("#s_free").val(ar["s_free"]);
				if(ar["warning"]==0){					
					$("#warning").prop("checked",true);
				}else{
					$("#warning").prop("checked",false);
				}
				$("#regDate").val(ar["regDate"]);
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
			}
		});
	}
	
	function saveNode(){
		let warning = 1;
		if($("#warning").prop("checked")){
			warning = 0;
		}
		alert("warning:" + warning);
		$.post(uploadURL + "/public/postCommInfo", {proc:"updateExamPlaceInfo", params:{ID:nodeID,warning:warning,registerID:currUser}}, function(data){
			getNodeInfo();
			jAlert("保存成功！","信息提示");
			updateCount += 1;
		});
	}
	
	function setButton(){
		$("#btnSave").hide();
		if(checkPermission("applyEdit") || checkPermission("studentAdd")){
			$("#btnSave").show();
		}
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
				<td align="right">项目名称</td>
				<td><input class="readOnly" type="text" id="courseName" style="width:100%;" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">考点名称</td>
				<td><input class="readOnly" type="text" id="examAddress" style="width:100%;" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">考试日期</td>
				<td><input class="readOnly" type="text" id="examDate" style="width:100%;" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">总考位</td>
				<td>
					<input class="readOnly" type="text" id="s_all" style="width:20%;" readOnly="true" />
					&nbsp;&nbsp;剩余&nbsp;&nbsp;
					<input class="readOnly" type="text" id="s_free" style="width:20%;" readOnly="true" />
				</td>
			</tr>
			<tr>
				<td align="right">报警</td>
				<td><input style="border:0px;" type="checkbox" id="warning" value="" /></td>
			</tr>
			<tr>
				<td align="right">登记日期</td>
				<td><input class="readOnly" type="text" id="regDate" readOnly="true" style="width:100%;" /></td>
			</tr>
			</table>
			</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
  	<input class="button" type="button" id="btnSave" value="保存" />&nbsp;
  </div>
</div>
</body>
