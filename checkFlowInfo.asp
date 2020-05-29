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
<script type="text/javascript" src="js/Asyncbox.v1.4.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var nodeID = "";
	var op = 0;
	var updateCount = 0;
	var cCheckerRight = "";
	var cCheckStep = 0;
	<!--#include file="js/commFunction.js"-->
	
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		op = "<%=op%>";
    $.ajaxSetup({ 
  		async: false 
  	}); 
		if(op!=1){
			getNodeInfo(nodeID);
		}

		$("#save").click(function(){
			saveNode();
		});

		$("#btnAgree").click(function(){
			var s = "";
			if($("#checkType").val()=="order"){
				s = "申请";
			}
			if($("#checkType").val()=="check"){
				s = "批准";
			}
			jConfirm("确定要" + s + "吗?", "确认对话框", function(r) {
				if(r){
					setCheckFlowAction(1,0);
				}
			});
		});
		$("#btnReturn").click(function(){
			jConfirm('你确定要退回该项申请吗?', '确认对话框', function(r) {
				if(r){
					if($("#memo").val()>""){
						arr = [];
						arr.push("<div class='comm'>");
						arr.push("<hr size='1' noshadow>");
						$.get("checkFlowControl.asp?op=getFlowList4Return&nodeID=" + $("#checkFlowID").val() + "&times=" + (new Date().getTime()),function(data){
							var ar = new Array();
							ar = (unescape(data)).split("%%");
							if(ar>""){
								var i = 0;
								$.each(ar,function(iNum,val){
									var ar1 = new Array();
									ar1 = val.split("|");
									arr.push("<div>");
									arr.push("<input style='border:0px;' type='radio' name='tempRadio' value='" + ar1[0] + "' />" + ar1[1]);
									arr.push("</div>");
								});
								asyncbox.open({
									html: arr.join(""),
									title: "您要退回到哪里？",
									width: 300,
									height: 250,
									cover : {
							          //透明度
							          opacity : 0,
							          //背景颜色
							           background : '#000'
							          },
						
									btnsbar : $.btn.OKCANCEL,
									callback : function(action){
										//setReturnLog("cake",iframe.nodeID);	//写回执（审批件）
										var m = $("input[name='tempRadio']:checked").val();
										if(action == 'ok' && m>0){
											//alert(m);
											setCheckFlowAction(2,m);
										}else{
											jAlert("已经取消操作。");
										}
						　　　}
								});
							}else{
								jAlert("没有可退回的节点。");
							}
						});
					}else{
						jAlert("请在审批意见中说明退回原因。");
					}
				}
			});
		});
		
		$("#btnCallback").click(function(){
			jConfirm('你确定要撤回这个审核吗?', '确认对话框', function(r) {
				if(r){
					setCheckFlowAction(4,0);
				}
			});
		});

		$("#del").click(function(){
			jConfirm('你确定要删除这个条目吗?', '确认对话框', function(r) {
				if(r){
					$.get("checkFlowControl.asp?op=delNode&nodeID=" + $("#checkFlowID").val() + "&times=" + (new Date().getTime()),function(data){
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
		$.get("checkFlowControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#checkFlowID").val(ar[0]);
				$("#checkID").val(ar[1]);
				$("#checkStep").val(ar[2]);
				cCheckStep = ar[2];
				$("#item").html(ar[3]);
				$("#status").val(ar[4]);
				$("#statusName").val(ar[5]);
				$("#checkCycle").val(ar[6]);
				$("#checkerRight").val(ar[7]);
				cCheckerRight = ar[7];
				$("#planDate").val(ar[8]);
				$("#checkDate").val(ar[9]);
				$("#checkerID").val(ar[10]);
				$("#checkerName").val(ar[11]);
				$("#pID").val(ar[12]);
				$("#pStatus").val(ar[13]);
				$("#memo").val(ar[15]);
				$("#regDate").val(ar[16]);
				$("#regOperator").val(ar[17]);
				//$("#registorName").val(ar[18]);
				$("#mark").val(ar[19]);
				$("#checkType").val(ar[20]);
				$("#checkNo").val(ar[21]);
				op = 0;
				getDownloadFile("checkFlowID");
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		//alert($("#checkFlowID").val() + "&status=" + status + "&userID=" + ($("#userID").val()) + "&fStart=" + $("#dateStart").val() + "&fEnd=" + $("#dateEnd").val() + "&period=" + $("#period").val() + "&kindID=" + $("#kindID").val() + "&memo=" + ($("#memo").val()) + "&regDate=" + $("#regDate").val() + "&regOperator=" + ($("#regOperator").val()));
		$.get("checkFlowControl.asp?op=update&nodeID=" + $("#checkFlowID").val() + "&memo=" + escape($("#memo").val()) + "&regOperator=" + escape($("#regOperator").val()) + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				jAlert("保存成功!","信息提示");
				updateCount += 1;
				getNodeInfo(ar[1]);
			}
			if(ar[0] == 2){
				jAlert("说明不能为空。","信息提示");
				$("#memo").focus();
			}
		});
		return false;
	}
	
	function setCheckFlowAction(id,k){
		//alert($("#checkFlowID").val() + "&status=" + id + "&keyID=" + k + "&memo=" + ($("#memo").val()));
		$.get("checkFlowControl.asp?op=setCheckFlowAction&nodeID=" + $("#checkFlowID").val() + "&status=" + id + "&keyID=" + k + "&memo=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				jAlert("操作成功!","信息提示");
				updateCount += 1;
				getNodeInfo(ar[1]);
			}
			if(ar[0] == 1){
				jAlert("该申请不符合政策要求。\n<hr><br>" + ar[2],"信息提示");
			}
			if(ar[0] == 2){
				jAlert("请填写审批意见。","信息提示");
				$("#memo").focus();
			}
		});
		return false;
	}
	
	function setButton(){
		$("#save").hide();
		$("#btnAgree").hide();
		$("#btnReturn").hide();
		$("#btnCallback").hide();
		$("#btnStop").hide();
		$("#btnLoadFile").attr("disabled",true);
		var cRightClass = $("#checkNo").val().substring(0,1);
		//$("#i_payAmountB").hide();
		if($("#checkType").val()=="order"){
			$("#btnAgree").attr("value","申请");
		}
		if($("#checkType").val()=="sign"){
			$("#btnAgree").attr("value","受理");
		}
		if($("#checkType").val()=="check"){
			$("#btnAgree").attr("value","通过");
		}
		if(op ==1){
			//setEmpty();
			$("#save").show();
			$("#btnLoadFile").attr("disabled",true);
		}
		if(op ==0){
			if($("#checkFlowID").val()>0){
				//申请操作项目
				if(cRightClass=="A" && checkPermission(cCheckerRight,0) && $("#status").val()==0){
					$("#save").show();
					$("#btnStop").show();
					//$("#btnPause").show();
					$("#btnAgree").show();
					$("#btnLoadFile").attr("disabled",false);
				}
				//审批操作项目;
				if(cRightClass=="B" && checkPermission(cCheckerRight,0) && $("#status").val()==0){
					$("#btnAgree").show();
					$("#save").show();
					$("#btnReturn").show();
					$("#btnLoadFile").attr("disabled",false);
				}
				//当前节点为待审批状态时，可以撤回到申请节点;
				if((($("#checkNo").val()=="B1" && checkPermission("borrowAdd",0)) || ($("#checkNo").val()=="B2" && checkPermission("disposalAdd",0))) && $("#status").val()==0){
					$("#btnCallback").show();
				}
			}
		}
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
	
	<div style="font-size:11pt;color:red;text-align:center;background:#EEEEEE;" id="item"></div>
	<div style="width:100%;float:left;margin:0;height:4px;background:#EEEEEE;"></div>
	<div style="width:100%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8;">
				<form id="detailCover" name="detailCover" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
					<table>
          <tr>
          	<td>操作人</td><input id="checkerID" type="hidden" /><input id="checkFlowID" type="hidden" /><input id="checkID" type="hidden" />
          	<td><input class="readOnly" type="text" id="checkerName" size="20" readOnly="true" /></td>
          	<td>审批日期</td><input id="mark" type="hidden" /><input id="checkType" type="hidden" /><input id="checkNo" type="hidden" />
          	<td><input class="readOnly" readOnly="true" type="text" id="checkDate" size="20" /></td>
          </tr>
          <tr>
          	<td>状态</td><input id="status" type="hidden" /><input id="checkerRight" type="hidden" />
          	<td><input class="readOnly" readOnly="true" type="text" id="statusName" size="20" /></td>
          	<td>审批周期</td>
          	<td><input class="readOnly" readOnly="true" type="text" id="checkCycle" size="10" />个工作日</td>
          </tr>
          <tr>
          	<td>开始日期</td><input id="regOperator" type="hidden" />
          	<td><input class="readOnly" readOnly="true" type="text" id="regDate" size="20" /></td>
          	<td>计划完成</td><input id="checkStep" type="hidden" />
          	<td><input class="readOnly" readOnly="true" type="text" id="planDate" size="20" /></td>
          </tr>
          </tr>
          	<td>审批意见</td><input id="pID" type="hidden" /><input id="pStatus" type="hidden" />
          	<td colspan="3"><textarea id="memo" style="padding:2px;" rows="5" cols="66S"/></textarea></td>
          <tr>
          <tr>
            <td colspan="6">
							<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#AAAAFF;line-height:18px;">
								<span style="padding-left:10px;"><input class="button" id="btnLoadFile" onClick="showLoadFile('checkFlowID',0)" type="button" value="附件上传" /></span>
					      <span id="downloadFile_checkFlowID">&nbsp;</span>
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
  	<input class="button" type="button" id="save" value="保存" />
  	<input class="button" type="button" id="btnAgree" value="同意" />
  	<input class="button" type="button" id="btnReturn" value="退回" />
  	<input class="button" type="button" id="btnCallback" value="撤回" />
  	<input class="button" type="button" id="btnStop" value="终止" />
  </div>
	
</div>
</body>
