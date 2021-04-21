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
	var refID = "";
	var keyID = "";
	var op = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";		//
		refID = "<%=refID%>";		//selList
		keyID = "<%=keyID%>";		//classID
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 
		setButton();
		if(nodeID>0 && op==0){
			getNodeInfo(nodeID);
		}

		$("#redo").click(function(){
			getSelCart("chkStamp");
			jConfirm("确定要重新制作准考证吗？证书编号将保持不变。","确认",function(r){
				if(r){
					//alert($("#searchStudentNeedDiplomaCert").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&username=" + currUser);
					$.getJSON(uploadURL + "/outfiles/generate_diploma_byCertID?certID=" + $("#certID").val() + "&host=" + $("#host").val() + "&batchID=" + $("#ID").val() + "&selList1=" + selList + "&username=" + currUser ,function(data){
						if(data>""){
							jAlert("证书重新制作成功 <a href='" + data + "' target='_blank'>下载文件</a>");
							getGenerateDiplomaList();
						}else{
							jAlert("没有可供处理的数据。");
						}
					});
				}
			});
		});
		$("#save").click(function(){
			saveNode();
		});
		$("#doPasscard").click(function(){
			doPasscard();
		});
		$("#list").click(function(){
			outputExcelBySQL('x01','file',nodeID,0,0);
		});
		$("#sign").click(function(){
			outputExcelBySQL('x02','file',nodeID,0,0);
		});
	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		//alert(id);
		$.get("diplomaControl.asp?op=getGeneratePasscardNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			var c = "";
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#classID").val(ar[1]);
				$("#className").val(ar[2]);
				$("#title").val(ar[3]);
				$("#qty").val(ar[4]);
				$("#startTime").val(ar[5]);
				$("#address").val(ar[6]);
				$("#notes").val(ar[7]);
				$("#startDate").val(ar[8]);
				//$("#filename").val(ar[9]);
				$("#memo").val(ar[10]);
				$("#regDate").val(ar[11]);
				$("#registerName").val(ar[12]);
				var c = "";
				if(ar[9] > ""){
					c += "<a href='/users" + ar[9] + "' target='_blank'>准考证</a>";
				}
				if(c == ""){c = "&nbsp;&nbsp;还未生成";}
				$("#photo").html(c);
				//getDownloadFile("generateDiplomaID");
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function doPasscard(){
		if($("#title").val()==""){
			jAlert("请填写标题。");
			return false;
		}
		if($("#startDate").val()==""){
			jAlert("请填写考试日期。");
			return false;
		}
		if($("#startTime").val()==""){
			jAlert("请填写考试时间。");
			return false;
		}
		//alert($("#studentID").val() + "&item=" + ($("#memo").val()));
		$.getJSON(uploadURL + "/outfiles/generate_passcard_byClassID?mark=0&classID=" + keyID + "&ID=" + nodeID + "&selList=" + refID + "&title=" + $("#title").val() + "&startDate=" + $("#startDate").val() + "&startTime=" + $("#startTime").val() + "&address=" + $("#address").val() + "&notes=" + $("#notes").val() + "&memo=" + $("#memo").val() + "&username=" + currUser ,function(data){
			if(data>""){
				jAlert("准考证制作成功");
				op = 0;
				updateCount = 1;
				nodeID = data;
				getNodeInfo(data);
			}else{
				jAlert("没有可供处理的数据。");
			}
		});
		return false;
	}
	
	function saveNode(){
		if($("#title").val()==""){
			jAlert("请填写标题。");
			return false;
		}
		if($("#startDate").val()==""){
			jAlert("请填写考试日期。");
			return false;
		}
		if($("#startTime").val()==""){
			jAlert("请填写考试时间。");
			return false;
		}
		//alert($("#studentID").val() + "&item=" + ($("#memo").val()));
		$.getJSON(uploadURL + "/outfiles/generate_passcard_byClassID?mark=1&classID=" + keyID + "&ID=" + nodeID + "&selList=&title=" + $("#title").val() + "&startDate=" + $("#startDate").val() + "&startTime=" + $("#startTime").val() + "&address=" + $("#address").val() + "&notes=" + $("#notes").val() + "&memo=" + $("#memo").val() + "&username=" + currUser ,function(data){
			if(data>""){
				jAlert("保存成功");
				op = 0;
				updateCount = 1;
				getNodeInfo(data);
			}else{
				jAlert("没有可供处理的数据。");
			}
		});
		return false;
	}
	
	function setButton(){
		$("#save").hide();
		$("#doPasscard").hide();
		if(op==1){
			$("#doPasscard").show();
			$("#doPasscard").val("制作准考证");
			setEmpty();
			//$("#save").focus();
		}else{
			if(checkPermission("studentAdd")){
				$("#save").show();
				$("#doPasscard").show();
				$("#doPasscard").val("重新制作");
			}
		}
	}
	
	function setEmpty(){
		$("#title").val("中石化从业人员安全知识考核");
		$("#startDate").val(currDate);
		$("#startTime").val("15:00 - 16:30");
		$("#address").val("黄兴路158号D栋103室");
		$("#notes").val("请务必携带身份证和准考证；迟到15分钟不得入场。");
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
				<td align="right">班级</td><input type="hidden" id="ID" /><input type="hidden" id="classID" />
				<td><input class="readOnly" type="text" id="className" size="25" readOnly="true" /></td>
				<td align="right">数量</td>
				<td><input class="readOnly" type="text" id="qty" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">证书标题</td>
				<td colspan="3"><input class="mustFill" type="text" id="title" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="right">考试日期</td>
				<td><input class="mustFill" type="text" id="startDate" size="25" /></td>
				<td align="right">考试时间</td>
				<td><input class="mustFill" type="text" id="startTime" size="25" /></td>
			</tr>
			<tr>
				<td align="right">考试地址</td>
				<td><input type="text" id="address" size="25" /></td>
				<td align="right">文件下载</td>
				<td>
					<span id="photo" style="margin-left:10px;"></span>
					<span id="list" style="margin-left:10px;"><a>考生数据</a></span>
					<span id="sign" style="margin-left:10px;"><a>签到表</a></span>
				</td>
			</tr>
			<tr>
				<td align="right">注意事项</td>
				<td colspan="3"><input type="text" id="notes" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="right">备注</td>
				<td colspan="5"><input type="text" id="memo" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="right">制作日期</td>
				<td><input class="readOnly" type="text" id="regDate" size="25" readOnly="true" /></td>
				<td align="right">制作人</td>
				<td><input class="readOnly" type="text" id="registerName" size="25" readOnly="true" /></td>
			</tr>
			</table>
			</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
  	<input class="button" type="button" id="save" value="保存" />&nbsp;
  	<input class="button" type="button" id="doPasscard" value="" />&nbsp;
  </div>
</div>
</body>
