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
	var op = 0;
	var updateCount = 0;
	var chk = 0;
	<!--#include file="js/commFunction.js"-->
	
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		refID = "<%=refID%>";
		op = "<%=op%>";
		getDicList("status","",0);
		
    $.ajaxSetup({ 
  		async: false 
  	}); 
		if(op==1){
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
			//alert($("#employeeID").val() + "&refID=" + $("#refID").val() + "&keyID=" + $("#type").val() + "&status=" + $("#status").val() + "&amount=" + $("#amount").val() + "&amountCheck=" + $("#amountCheck").val() + "&discount0=" + $("#discount0").val() + "&discount1D=" + $("#discount1D").val() + "&discount1A=" + $("#discount1A").val() + "&memo0=" + ($("#memo0").val()) + "&memo1D=" + ($("#memo1D").val()) + "&memo1A=" + ($("#memo1A").val()) + "&regDate=" + $("#regDate").val() + "&regOperator=" + ($("#regOperator").val()));
			$.get("employeeControl.asp?op=update&nodeID=" + $("#employeeID").val() + "&SID=" + $("#SID").val() + "&name=" + escape($("#name").val()) + "&status=" + $("#status").val() + "&area=" + $("#area").val() + "&unitID=" + $("#unitID").val() + "&memo=" + escape($("#memo").val()) + "&regDate=" + $("#regDate").val() + "&regOperator=" + escape($("#regOperator").val()) + "&times=" + (new Date().getTime()),function(re){
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
					jAlert("身份证不能为空。","信息提示");
					$("#SID").focus();
				}
				if(ar[0] == 2){
					jAlert("姓名不能为空。","信息提示");
					$("#name").focus();
				}
				if(ar[0] == 3){
					jAlert("请选择一个单位。","信息提示");
				}
			});
			return false;
		});

		$("#del").click(function(){
			jConfirm('你确定要删除这个项目吗?', '确认对话框', function(r) {
				if(r){
					$.get("employeeControl.asp?op=delNode&nodeID=" + $("#employeeID").val() + "&times=" + (new Date().getTime()),function(data){
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
		$.get("employeeControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#employeeID").val(ar[0]);
				$("#SID").val(ar[1]);
				$("#name").val(ar[2]);
				$("#status").val(ar[3]);
				$("#age").val(ar[6]);
				$("#birthday").val(ar[7]);
				$("#sexName").val(ar[9]);
				$("#memo").val(ar[11]);
				$("#regDate").val(ar[12]);
				$("#regOperator").val(ar[13]);
				$("#registorName").val(ar[14]);
				$("#unitID").val(ar[15]);
				$("#unitName").val(ar[16]);
				chk = 1;
				op = 0;
				getDownloadFile("employeeID");
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
			if(chk){
				$("#addNew").show();
			}
			if(chk && $("#employeeID").val()>0){
				$("#save").show();
				$("#del").show();
				$("#btnLoadFile").attr("disabled",false);
			}
		}
	}
	
	function setEmpty(){
		$("#employeeID").val(0);
		$("#status").val(0);
		//$("#unitID").val(0);
		$("#SID").val("");
		$("#name").val("");
		$("#area").val(0);
		$("#memo").val("");
		$("#regDate").val(currDate);
		$("#regOperator").val(currUser);
		$("#registorName").val(currUserName);
		$("#downloadFile_employeeID").html("");
	}
	
	function getValList(){
		return $("#unit").val() + " / " + $("#amount").val();
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
		<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8;">
				<form id="detailCover" name="detailCover" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
					<table>
          <tr>
          	<td align="right">专业</td>
          	<td><select id="type" style="width:90px"></select></td>
          	<td align="right">&nbsp;状态</td>
          	<td><select id="status" style="width:90px"></select></td>
          	<td align="right">&nbsp;内容</td><input id="refID" type="hidden" /><input id="employeeID" type="hidden" />
          	<td><input class="mustFill" type="text" id="item" size="16" /></td>
          </tr>
          <tr>
          	<td align="right">送审量</td>
          	<td><input type="text" id="amount" size="16" /></td>
          	<td align="right">&nbsp;送审价</td>
          	<td><input type="text" id="price" size="16" />元</td>
          	<td align="right">&nbsp;单位</td>
          	<td><input class="mustFill" type="text" id="unit" size="16" /></td>
          </tr>
          <tr>
          	<td align="right">审定量</td>
          	<td><input type="text" id="amountCheck" size="16" /></td>
          	<td align="right">&nbsp;审定价</td>
          	<td><input type="text" id="priceCheck" size="16" />元</td>
          	<td align="right">&nbsp;核增金额</td>
          	<td><input class="readOnly" type="text" id="amountA" size="14" readOnly="true" />元</td>
          </tr>
          <tr>
          	<td>备注</td>
          	<td colspan="5"><textarea id="memo" style="padding:2px;" rows="3" cols="80"/></textarea></td>
          </tr>
          <tr>
          	<td align="right">登记日期</td>
          	<td><input class="readOnly" type="text" id="regDate" size="12" readOnly="true" /></td>
          	<td align="right">&nbsp;登记人</td><input type="hidden" id="regOperator" />
          	<td><input class="readOnly" type="text" id="registorName" size="12" readOnly="true" /></td>
          	<td align="right">&nbsp;</td>
          	<td align="right">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="6">
							<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#AAAAFF;line-height:18px;">
								<span style="padding-left:10px;"><input class="button" id="btnLoadFile" onClick="showLoadFile('employeeID',0)" type="button" value="附件上传" /></span>
					      <span id="downloadFile_employeeID">&nbsp;</span>
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
