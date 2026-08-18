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
	let refID = 0;
	var op = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";		//ID
		refID = "<%=refID%>";		//applyID
		op = "<%=op%>";
		
		getDicList("scheduleKind","kind",0);
		getDicList("statusNo","free",0);
		
		$.ajaxSetup({ 
			async: false 
		}); 
		
		if(op==0){
			getNodeInfo();
		}
		if(op==1){
			setButton();
		}
		setButton();
		
		$("#btnSave").click(function(){
			saveNode();
		});
		
		$("#kind").change(function(){
			if(op==1){
				getNewSeq();
			}
		});
	});

	function getNodeInfo(){
		$.post(uploadURL + "/public/postCommInfo", {proc:"getApplyDetailInfo", params:{ID: nodeID}}, function(data){
			let ar = data[0];
			if(ar > ""){
				refID = ar["applyID"];
				$("#examNo").val(ar["examNo"]);
				$("#examDate").val(ar["examDate"]);
				$("#examAddress").val(ar["examAddress"]);
				$("#kind").val(ar["kind"]);
				$("#seq").val(ar["seq"]);
				$("#free").val(ar["free"]);
				$("#score").val(ar["score"]);
				$("#classID").val(ar["classID"]);
				$("#memo").val(ar["memo"]);
				$("#regDate").val(ar["regDate"] + " " + ar["registerName"]);
				$("#dateScore").val(ar["dateScore"] + " " + ar["scoreCheckerName"]);
				$("#dateExam").val(ar["dateExam"] + " " + ar["examCheckerName"]);
				
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
			}
		});
	}
	
	function saveNode(){
		// alert(nodeID + "," + refID + "," + $("#examNo").val() + "," + $("#examDate").val() + "," + $("#examAddress").val() + "," + $("#score").val() + "," + $("#kind").val() + "," + $("#free").val() + "," + $("#seq").val() + "," + $("#memo").val());
		$.post(uploadURL + "/public/postCommInfo", {proc:"updateApplyDetailInfo", params:{ID:nodeID,applyID:refID,examNo:$("#examNo").val(),examDate:$("#examDate").val(),examAddress:$("#examAddress").val(),score:$("#score").val(), kind:$("#kind").val(), free:$("#free").val(), seq:$("#seq").val(), memo:$("#memo").val(),registerID:currUser}}, function(data){
			getNodeInfo();
			jAlert("保存成功！","信息提示");
			updateCount += 1;
		});
	}
	
	function getNewSeq(){
		$.post(uploadURL + "/public/postCommInfo", {proc:"getApplyDetailNewSeq1", params:{applyID:refID,kindID:$("#kind").val()}}, function(data){
			let seq = [3,5,7,9,11,13,15,17,19,21];
			$("#seq").val(data[0]["seq"]);
			if(op==1 && seq.includes(data[0]["seq"])){
				jAlert("本次考试可能需要收费","信息提示");
				$("#free").val(1);
			}
		});
	}
	
	function setButton(){
		$("#btnSave").hide();
		if(checkPermission("applyEdit") || checkPermission("studentAdd")){
			$("#btnSave").show();
		}
		if(op==1){
			$("#classID").prop("disabled",true);
			setEmpty();
		}else{
			$("#classID").prop("disabled",false);
		}
	}
	function setEmpty(){
		$("#examNo").val("");
		$("#examDate").val("");
		$("#examAddress").val("");
		$("#kind").val(0);
		getNewSeq();
		$("#free").val(0);
		$("#score").val("");
		$("#classID").val('');
		$("#memo").val('');
		nodeID = 0;
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
				<td align="right">准考证号</td>
				<td colspan="3"><input type="text" id="examNo" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="right">考试日期</td>
				<td colspan="3"><input type="text" id="examDate" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="right">考试地址</td>
				<td colspan="3"><input type="text" id="examAddress" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="right">开班编号</td>
				<td colspan="3"><input type="text" id="classID" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="right">类型</td>
				<td><select id="kind" style="width:100px;"></select></td>
				<td align="right">成绩</td>
				<td><input type="text" id="score" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="right">收费</td>
				<td><select id="free" style="width:100px;"></select></td>
				<td align="right">第</td>
				<td><input type="text" id="seq" style="width:30%;" />次考试</td>
			</tr>
			<tr>
				<td align="right">备注</td>
				<td colspan="3"><input type="text" id="memo" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="right">考试导入</td>
				<td colspan="3"><input class="readOnly" type="text" id="dateExam" readOnly="true" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="right">成绩导入</td>
				<td colspan="3"><input class="readOnly" type="text" id="dateScore" readOnly="true" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="right">登记人</td>
				<td colspan="3"><input class="readOnly" type="text" id="regDate" readOnly="true" style="width:100%;" /></td>
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
