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
	var nodeID = "";
	var op = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 
		setButton();
		
		getNodeInfo(nodeID);

		$("#save").click(function(){
			saveNode();
		});
	});

	function getNodeInfo(id){
		$.get("diplomaControl.asp?op=getInvoiceNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			var c = "";
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#kind").val(ar[1]);
				$("#invCode").val(ar[2]);
				$("#invID").val(ar[3]);
				$("#taxNo").val(ar[4]);
				$("#taxUnit").val(ar[5]);
				$("#invDate").val(ar[6]);
				$("#item").val(ar[7]);
				$("#amount").val(ar[8]);
				$("#cancel").val(ar[9]==1 ? '是' : '');
				$("#cancelDate").val(ar[10]);
				$("#payType").val(ar[11]);
				$("#payStatus").val(ar[12]==1 ? '是' : '');
				$("#operator").val(ar[13]);
				$("#memo").val(ar[14]);
				$("#checkDate").val(ar[18]);
				$("#checkerName").val(ar[20]);
				$("#regDate").val(ar[15]);
				$("#registerName").val(ar[17]);
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		if($("#memo").val().length < 3){
			jAlert("备注信息请至少填写3个字的内容。");
			return false;
		}
		//alert($("#studentID").val() + "&item=" + ($("#memo").val()));
		$.get("diplomaControl.asp?op=setMemo&nodeID=" + $("#diplomaID").val() + "&item=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				jAlert("保存成功！","信息提示");
				updateCount += 1;
			}
		});
		return false;
	}
	
	function setButton(){
		if(!checkPermission("invoiceEdit")){
			$("#save").hide();
		}
	}
	
	function setEmpty(){
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
				<td align="right">发票种类</td><input type="hidden" id="ID" />
				<td><input class="readOnly" type="text" id="kind" size="25" readOnly="true" /></td>
				<td align="right">购方名称</td>
				<td><input class="readOnly" type="text" id="taxUnit" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">发票代码</td>
				<td><input class="readOnly" type="text" id="invCode" size="25" readOnly="true" /></td>
				<td align="right">发票号码</td>
				<td><input class="readOnly" type="text" id="invID" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">购方税号</td>
				<td><input class="readOnly" type="text" id="taxNo" size="25" readOnly="true" /></td>
				<td align="right">开票日期</td>
				<td><input class="readOnly" type="text" id="invDate" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">收费项目</td>
				<td><input class="readOnly" type="text" id="item" size="25" readOnly="true" /></td>
				<td align="right">发票金额</td>
				<td><input class="readOnly" type="text" id="amount" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">作废标志</td>
				<td><input class="readOnly" type="text" id="cancel" size="25" readOnly="true" /></td>
				<td align="right">作废日期</td>
				<td><input class="readOnly" type="text" id="cancelDate" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">开票人</td>
				<td><input class="readOnly" type="text" id="operator" size="25" readOnly="true" /></td>
				<td align="right">应收标志</td>
				<td><input class="readOnly" type="text" id="payStatus" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">收款确认</td>
				<td><input class="readOnly" type="text" id="checkerName" size="25" readOnly="true" /></td>
				<td align="right">确认日期</td>
				<td><input class="readOnly" type="text" id="checkDate" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">上传日期</td>
				<td><input class="readOnly" type="text" id="regDate" size="25" readOnly="true" /></td>
				<td align="right">上传人</td>
				<td><input class="readOnly" type="text" id="registerName" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">备注</td>
				<td colspan="5"><input type="text" id="memo" size="70" /></td>
			</tr>
			</table>
			</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
  		<input class="button" type="button" id="save" value="保存备注" />&nbsp;
  	</div>
</div>
</body>
