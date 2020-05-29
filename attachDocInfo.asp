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
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var nodeID = "";
	var refID = "";
	var kindID = "";
	var op = 0;
	var updateCount = 1;
	var unitID = 0;
	var street = 0;
	var chk = 0;
	<!--#include file="js/commFunction.js"-->
	
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		refID = "<%=refID%>";
		kindID = "<%=kindID%>";
		op = "<%=op%>";
		getDicList("status","",0);
		getDicList("need","paper",0);
		getDicList("need","photo",0);
		$("#kind").val(kindID);
		$("#datePaper").click(function(){WdatePicker();});
		$("#datePhoto").click(function(){WdatePicker();});

    $.ajaxSetup({ 
  		async: false 
  	}); 
		if(op==1){
			if(refID>0){
				$("#refID").val(refID);
			}
			setButton();
		}
		
		if(op!=1){
			getNodeInfo(nodeID);
		}

		$("#addNew").click(function(){
			op = 1;
			setButton();
		});

		$("#save").click(function(){
			//alert($("#attachDocID").val() + "&refID=" + $("#refID").val() + "&seq=" + $("#seq").val() + "&dateReceive=" + $("#dateReceive").val() + "&kindID=" + $("#docKind").val() + "&docType=" + ($("#docType").val()) + "&status=" + $("#status").val() + "&page=" + $("#page").val() + "&title=" + ($("#title").val()) + "&item=" + ($("#item").val()) + "&memo=" + ($("#memo").val()));
			$.get("attachDocControl.asp?op=update&nodeID=" + $("#attachDocID").val() + "&refID=" + $("#refID").val() + "&seq=" + $("#seq").val() + "&kindID=" + $("#kind").val() + "&mark=" + $("#mark").val() + "&status=" + $("#status").val() + "&paper=" + $("#paper").val() + "&photo=" + $("#photo").val() + "&datePaper=" + $("#datePaper").val() + "&datePhoto=" + $("#datePhoto").val() + "&title=" + escape($("#title").val()) + "&memo=" + escape($("#memo").val()) + "&regDate=" + $("#regDate").val() + "&regOperator=" + escape($("#regOperator").val()) + "&times=" + (new Date().getTime()),function(re){
				//jAlert(unescape(re));
				var ar = new Array();
				ar = unescape(re).split("|");
				if(ar[0] == 0){
					jAlert("保存成功！","信息提示");
					updateCount += 1;
					nodeID = ar[1];
					getNodeInfo(ar[1]);
				}
				if(ar[0] == 1){
					jAlert("资料类型不能为空。","信息提示");
					$("#kind").focus();
				}
				if(ar[0] == 2){
					jAlert("资料名称不能为空。","信息提示");
					$("#title").focus();
				}
			});
			return false;
		});

		$("#del").click(function(){
			jConfirm('你确定要删除这个项目吗?', '确认对话框', function(r) {
				if(r){
					$.get("attachDocControl.asp?op=delNode&nodeID=" + $("#attachDocID").val() + "&times=" + (new Date().getTime()),function(data){
						jAlert("删除成功！","信息提示");
						op = 1;
						setButton();
						updateCount += 1;
					});
				}
			});
		});
		
  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		//alert(id);
		$.get("attachDocControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#attachDocID").val(ar[0]);
				$("#refID").val(ar[1]);
				$("#status").val(ar[2]);
				$("#kind").val(ar[4]);
				$("#mark").val(ar[5]);
				$("#title").val(ar[6]);
				$("#paper").val(ar[7]);
				$("#photo").val(ar[9]);
				$("#datePaper").val(ar[11]);
				$("#datePhoto").val(ar[12]);
				$("#memo").val(ar[13]);
				$("#regDate").val(ar[14]);
				$("#regOperator").val(ar[15]);
				$("#registorName").val(ar[16]);
				$("#seq").val(ar[17]);
				if($("#kind").val()=="unit"){
					unitID = $("#refID").val();
				}
				if($("#kind").val()=="order"){
					unitID = getUnitIDByOrder($("#refID").val());
				}
				street = getStreetIDbyUnit(unitID);
				op = 0;
				getDownloadFile("attachDocID");
				setButton();
			}else{
				//jAlert("该项目信息未找到！","信息提示");
				setEmpty();
				setButton();
			}
		});
	}
	
	function setButton(){
		//alert(op + ":" + $("#regOperator").val() + ":" + $("#projectID").val());
		$("#status").attr("disabled",true);
		$("#save").hide();
		$("#del").hide();
		$("#addNew").hide();
		$("#btnLoadFile").attr("disabled",true);
		if(op ==1){
			setEmpty();
			$("#save").show();
		}
		if(op ==0){
			if(checkPermission("orderCheck0",0) || checkPermission("orderCheck1",0)){
				$("#addNew").show();
			}
			if((checkPermission("orderCheck0",street) || checkPermission("orderCheck1",0)) && $("#attachDocID").val()>0){
				$("#save").show();
				$("#del").show();
				$("#btnLoadFile").attr("disabled",false);
			}
		}
	}
	
	function setEmpty(){
		$("#attachDocID").val(0);
		$("#status").val(0);
		//$("#kind").val("");
		$("#seq").val(0);
		$("#mark").val(0);
		$("#title").val("");
		$("#paper").val(0);
		$("#datePaper").val("");
		$("#photo").val(0);
		$("#datePhoto").val("");
		$("#memo").val("");
		$("#regDate").val(currDate);
		$("#regOperator").val(currUser);
		$("#registorName").val(currUserName);
		$("#downloadFile_attachDocID").html("");
	}
	
	function getUpdateCount(){
		//parent.$.close("orderteam");
		return updateCount;
	}
</script>

</head>

<body style="background:#f0f0f0;">
 <!--#include file='commFloatDetail.asp' -->
 <!--#include file='commLoadFileDetail.asp' -->

<div id='layout' align='left' style="background:#f0f0f0;">	
	
	<div style="width:100%;float:left;margin:0;">
		<div style="battachDoc:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8;">
				<form id="detailCover" name="detailCover" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
					<table>
          <tr>
          	<td align="right">序号</td><input id="attachDocID" type="hidden" /><input id="refID" type="hidden" /><input id="mark" type="hidden" /><input id="kind" type="hidden" />
          	<td><input type="text" id="seq" size="12" /></td>
          	<td align="right">状态</td>
          	<td><select id="status" style="width:90px"></select></td>
         	</tr>
          <tr>
          	<td align="right">资料名称</td>
          	<td colspan="3"><input class="mustFill" type="text" id="title" size="50" /></td>
         	</tr>
          <tr>
          	<td align="right">纸质</td>
          	<td><select id="paper" style="width:90px"></select></td>
          	<td align="right">确认日期</td>
          	<td><input class="readOnly" readOnly="true" type="text" id="datePaper" size="12" /></td>
          </tr>
          <tr>
          	<td align="right">扫描件</td>
          	<td><select id="photo" style="width:90px"></select></td>
          	<td align="right">提交日期</td>
          	<td><input class="readOnly" readOnly="true" type="text" id="datePhoto" size="12" /></td>
          </tr>
          <tr>
          </tr>
          <tr>
          	<td align="right">说明</td>
          	<td colspan="5"><input type="text" id="memo" size="50" /></td>
          </tr>
          <tr>
          	<td align="right">登记日期</td>
          	<td><input class="readOnly" type="text" id="regDate" size="12" readOnly="true" /></td>
          	<td align="right">登记人</td><input type="hidden" id="regOperator" />
          	<td><input class="readOnly" type="text" id="registorName" size="12" readOnly="true" /></td>
          </tr>
          <tr>
            <td colspan="6">
							<div style="battachDoc:solid 1px #e0e0e0;width:99%;margin:1px;background:#AAAAFF;line-height:18px;">
								<span style="padding-left:10px;"><input class="button" id="btnLoadFile" onClick="showLoadFile('attachDocID',0)" type="button" value="附件上传" /></span>
					      <span id="downloadFile_attachDocID">&nbsp;</span>
					    </div>
            </td>
          </tr>
        	</table>
				</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  <div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
  	<input class="button" type="button" id="save" name="save" value="保存" />&nbsp;&nbsp;&nbsp;
  	<input class="button" type="button" id="addNew" name="addNew" value="新增" />&nbsp;&nbsp;&nbsp;
  	<input class="button" type="button" id="del" name="del" value="删除" />
  </div>
</div>
</body>
