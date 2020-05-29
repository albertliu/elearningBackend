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
	var nodeID = 0;
	var op = 0;
	var kindID = 0;
	var refID = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	<!--#include file="checkFlowBarReady.js"-->
	
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		kindID = "<%=kindID%>";
		refID = "<%=refID%>";
		op = <%=op%>;

		getDicList("checkStatus","status",0);
    $.ajaxSetup({ 
  		async: false 
  	}); 
  	
		//getDicList("flowStatus","flowStatus0",0);
		//getDicList("flowStatus","flowStatus1",0);
		getDicList("flowStatus","flowStatus2",0);
		getDicList("flowStatus","flowStatus3",0);
		getDicList("flowStatus","flowStatus4",0);
  	
		if(op==1){
			setButton();
		}
		if(nodeID==0){
			$.get("checkControl.asp?op=getCheckIDbyRef&kindID=" + kindID + "&refID=" + refID + "&times=" + (new Date().getTime()),function(re){
				nodeID = re;
			});
		}
		if(op!=1){
			getNodeInfo(nodeID);
		}

		$("#orderCheck").click(function(){
			setCheckFlow($("#flowID0").val(),1,$("#memo0").val());  //setCheckFlow(id,op,memo)
			updateCount += 1;
		});
		$("#confirm1").click(function(){
			setCheckFlow($("#flowID1").val(),1,$("#memo1").val());  //setCheckFlow(id,op,memo)
			updateCount += 1;
		});
		$("#confirm2").click(function(){
			setCheckFlow($("#flowID2").val(),1,$("#memo2").val());  //setCheckFlow(id,op,memo)
			updateCount += 1;
		});
		$("#confirm3").click(function(){
			setCheckFlow($("#flowID3").val(),1,$("#memo3").val());  //setCheckFlow(id,op,memo)
			updateCount += 1;
		});
		$("#confirm4").click(function(){
			setCheckFlow($("#flowID4").val(),1,$("#memo4").val());  //setCheckFlow(id,op,memo)
			updateCount += 1;
		});

		$("#refuse1").click(function(){
			setCheckFlow($("#flowID1").val(),2,$("#memo1").val());  //setCheckFlow(id,op,memo)
			updateCount += 1;
		});
		$("#refuse2").click(function(){
			setCheckFlow($("#flowID2").val(),2,$("#memo2").val());  //setCheckFlow(id,op,memo)
			updateCount += 1;
		});
		$("#refuse3").click(function(){
			setCheckFlow($("#flowID3").val(),2,$("#memo3").val());  //setCheckFlow(id,op,memo)
			updateCount += 1;
		});
		$("#refuse4").click(function(){
			setCheckFlow($("#flowID4").val(),2,$("#memo4").val());  //setCheckFlow(id,op,memo)
			updateCount += 1;
		});
		
		$("#flowSave0").click(function(){
			setCheckFlow($("#flowID0").val(),0,$("#memo0").val());  //setCheckFlow(id,op,memo)
		});
		$("#flowSave1").click(function(){
			setCheckFlow($("#flowID1").val(),0,$("#memo1").val());  //setCheckFlow(id,op,memo)
		});
		$("#flowSave2").click(function(){
			setCheckFlow($("#flowID2").val(),0,$("#memo2").val());  //setCheckFlow(id,op,memo)
		});
		$("#flowSave3").click(function(){
			setCheckFlow($("#flowID3").val(),0,$("#memo3").val());  //setCheckFlow(id,op,memo)
		});
		$("#flowSave4").click(function(){
			setCheckFlow($("#flowID4").val(),0,$("#memo4").val());  //setCheckFlow(id,op,memo)
		});

		$("#save").click(function(){
			//alert($("#ID").val() + "&name=" + ($("#name").val()) + "&title=" + ($("#title").val()) + "&status=" + $("#status").val() + "&kind=" + $("#kind").val() + "&unitID=" + $("#unitID").val() + "&projectID=" + projectID + "&engineeringID=" + engineeringID + "&address=" + ($("#address").val()) + "&zip=" + ($("#zip").val()) + "&phone=" + ($("#phone").val()) + "&phoneCell=" + ($("#phoneCell").val()) + "&fax=" + ($("#fax").val()) + "&email=" + ($("#email").val()) + "&emailPerson=" + ($("#emailPerson").val()) + "&memo=" + ($("#memo").val()) + "&mark=" + ($("#mark").val()) + "&regDate=" + ($("#regDate").val()) + "&regOperator=" + ($("#regOperator").val()));
			$.get("checkControl.asp?op=update&nodeID=" + $("#ID").val() + "&name=" + escape($("#name").val()) + "&title=" + escape($("#title").val()) + "&status=" + $("#status").val() + "&kind=" + $("#kind").val() + "&unitID=" + $("#unitID").val() + "&projectID=" + projectID + "&engineeringID=" + engineeringID + "&address=" + escape($("#address").val()) + "&zip=" + escape($("#zip").val()) + "&phone=" + escape($("#phone").val()) + "&phoneCell=" + escape($("#phoneCell").val()) + "&fax=" + escape($("#fax").val()) + "&email=" + escape($("#email").val()) + "&emailPerson=" + escape($("#emailPerson").val()) + "&memo=" + escape($("#memo").val()) + "&mark=" + escape($("#mark").val()) + "&regDate=" + escape($("#regDate").val()) + "&regOperator=" + escape($("#regOperator").val()) + "&times=" + (new Date().getTime()),function(re){
				//jAlert(unescape(re));
				var ar = new Array();
				ar = unescape(re).split("|");
				if(ar[0] == 0){
					getNodeInfo(ar[1]);
					jAlert("保存成功!","信息提示");
					if(op==1){	//新增
						op = 0;
					}
					updateCount += 1;
				}
				if(ar[0] == 2){
					jAlert("姓名不能为空。","信息提示");
					$("#name").focus();
				}
				if(ar[0] == 5){
					jAlert("电话或手机至少要填写一个。","信息提示");
					$("#phone").focus();
				}
			});
			return false;
		});

		$("#cancel").click(function(){
			jConfirm('你确定要撤销这个审批流程吗?', '确认对话框', function(r) {
				if(r){
					$.get("checkControl.asp?op=cancelCheck&nodeID=" + $("#checkID").val() + "&times=" + (new Date().getTime()),function(data){
						jAlert("撤销成功！","信息提示");
						getNodeInfo($("#checkID").val());
						updateCount += 1;
					});
				}
			});
		});
		
		$("#title_status").hide();
		$("#checkStatusName").hide();
		$("#btnCommit4Check").hide();
  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getCheckFlowList(){
		$("#flow0").hide();
		$("#flow1").hide();
		$("#flow2").hide();
		$("#flow3").hide();
		$("#flow4").hide();
		$("#flowMemo0").hide();
		$("#flowMemo1").hide();
		$("#flowMemo2").hide();
		$("#flowMemo3").hide();
		$("#flowMemo4").hide();
		$.get("checkFlowControl.asp?op=getCheckFlowList&refID=" + nodeID + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("%%");
			if(ar > ""){
				var i = 0;
				var c = 0;
				var bc = new Array();
				bc[0] = "#cccccc";//bc[ar1[3]]
				bc[1] = "#FF8888";
				bc[2] = "#00FF00";
				bc[3] = "#FF8888";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					$("#flowID" + i).val(ar1[0]);
					$("#flow" + i).show();
					$("#flowMemo" + i).show();
					c = ar1[3];		//flow status
					$("#item" + i).html("&nbsp;&nbsp;" + ar1[2] + "&nbsp;&nbsp;");
					$("#item" + i).css("background",bc[c]);
					$("#memoTitle" + i).html(ar1[2] + "意见");
					$("#flowStatus" + i).val(ar1[3]);
					$("#flowStatusName" + i).val(ar1[4]);
					$("#orderDate" + i).val(ar1[8]);
					$("#planDate" + i).val(ar1[9]);
					$("#checkDate" + i).val(ar1[10]);
					$("#checkerID" + i).val(ar1[11]);
					$("#checkerName" + i).val(ar1[12]);
					$("#memo" + i).val(ar1[14]);
					if(i>0){
						$("#memo" + i).attr("disabled",true);
						$("#memo" + i).css("background","#eeeeee");
					}
					//alert($("#status").val() + ":" + ar1[3] + ":" + ar1[7] + ":" + ar1[13] + ":" + checkPermission(ar1[7],ar1[13]));
					if($("#status").val()=="1" && ar1[3]=="1" && checkPermission(ar1[7],ar1[13])){
						$("#flowSave" + i).show();
						$("#confirm" + i).show();
						$("#refuse" + i).show();
						$("#memo" + i).attr("disabled",false);
						$("#memo" + i).css("background","#ffff99");
					}
					i = i + 1;
				});
			}
		});
	}

	function getNodeInfo(id){
		//alert(id);
		$.get("checkControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#checkID").val(ar[0]);
				$("#title").html(ar[1]);
				$("#status").val(ar[2]);
				$("#checkKind").val(ar[4]);
				$("#checkKindName").val(ar[5])
				$("#checkClass").val(ar[6]);
				$("#checkClassName").val(ar[7]);
				$("#refID").val(ar[8]);
				$("#mark").val(ar[9]);
				$("#currStep").val(ar[10]);
				$("#dateStart").val(ar[11]);
				$("#dateEnd").val(ar[12]);
				$("#memo").val(ar[13]);
				$("#regDate").val(ar[14]);
				$("#regOperator").val(ar[15]);
				$("#registorName").val(ar[16]);
				refID = ar[8];
				nodeID = ar[0];
				setButton();
				getCheckFlowBar(ar[4],ar[8]);
				getCheckFlowList();
				getDownloadFile("checkID");
			}else{
				jAlert("该审批信息未找到！","信息提示");
				setEmpty();
				setButton();
			}
		});
	}
	
	function setCheckFlow(id,op,memo){
		//alert("nodeID=" + id + "&keyID=" + op + "&item=" + (memo));
		$.get("checkFlowControl.asp?op=setCheckFlow&nodeID=" + id + "&keyID=" + op + "&item=" + escape(memo) + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			if(re > 0){
				jAlert("保存成功。","信息提示");
				getNodeInfo($("#checkID").val());
			}
		});
	}
	
	function setButton(){
		/*
		先判断审批状态：
		1.如果为待申请，注册人可以进行关闭操作，并在申请流程里提交申请及保存操作。
		2.如果为批准、不批准或关闭状态，不可做任何操作。
		3.如果为暂停状态，可以进行启动、关闭操作。
		4.如果为审批状态，注册人可以进行撤销、暂停、关闭操作。当前活动节点可以修改状态及进行保存操作，非活动节点不可操作。
		*/
		$("#status").attr("disabled",true);
		$("#save").hide();
		$("#cancel").hide();
		$("#suspend").hide();
		$("#restart").hide();
		$("#close").hide();
		$("#orderCheck").hide();
		$("#flowSave0").hide();
		$("#flowSave1").hide();
		$("#flowSave2").hide();
		$("#flowSave3").hide();
		$("#flowSave4").hide();
		$("#confirm1").hide();
		$("#confirm2").hide();
		$("#confirm3").hide();
		$("#confirm4").hide();
		$("#refuse1").hide();
		$("#refuse2").hide();
		$("#refuse3").hide();
		$("#refuse4").hide();
		$("#memo0").attr("disabled",true);
		$("#memo0").css("background","#eeeeee");
		if(op ==1){
			setEmpty();
			$("#save").show();
			$("#btnLoadFile").attr("disabled",true);
		}
		if(op ==0){
			if($("#status").val()=="0" && $("#regOperator").val() == currUser){
				//1.
				$("#orderCheck").show();
				$("#flowSave0").show();
				$("#close").show();
				$("#memo0").attr("disabled",false);
				$("#memo0").css("background","#ffff99");
				$("#btnLoadFile").attr("disabled",false);
			}
			if($("#status").val()=="4" && $("#regOperator").val() == currUser){
				//3.
				$("#restart").show();
				$("#close").show();
				$("#btnLoadFile").attr("disabled",false);
			}
			if($("#status").val()=="1"){
				//4.
				if($("#regOperator").val() == currUser){
					$("#cancel").show();
					$("#suspend").show();
					$("#close").show();
					$("#btnLoadFile").attr("disabled",false);
				}
				//others see flowList		
			}
		}
	}
	
	function setEmpty(){
		$("#ID").val(0);
		$("#item").val("");  //new item
		$("#status").val(0);
		$("#checkKind").val(0);
		$("#checkKindName").val("");
		$("#checkClass").val(0);
		$("#checkClassName").val("");
		$("#refID").val(0);
		$("#mark").val(0);
		$("#currStep").val("");
		$("#dateStart").val("");
		$("#dateEnd").val("");
		$("#memo").val("");
		$("#regDate").val(currDate);
		$("#regOperator").val(currUser);
		$("#registorName").val(currUserName);
	}
	
	function getUpdateCount(){
		return updateCount;
	}
</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
 <!--#include file='commFloatDetail.asp' -->
 <!--#include file='commLoadFileDetail.asp' -->
	<div id="title" style="color:blue;margin:0;padding:5px;text-align:center;width:97%;"></div>
  <!--#include file="checkFlowBarDetail.js"-->
	
	<div style="width:100%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" id="detailCover" style="background:#f5faf8;">
				<form id="detailCover" name="detailCover" enctype="multipart/form-data" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
        <table border="0" cellpadding="0" cellspacing="0" width="98%" style="line-height:10px;">
          <tr>
          	<td>类别</td><input id="checkID" type="hidden" /><input id="checkKind" type="hidden" />
          	<td><input class="readOnly" type="text" id="checkKindName" size="14" readOnly="true" /></td>
          	<td>状态</td>
          	<td><select id="status" style="width:100px"></select></td>
          	<td>审批等级</td><input id="checkClass" type="hidden" /><input id="memo" type="hidden" />
          	<td><input class="readOnly" type="text" id="checkClassName" size="14" readOnly="true" /></td>
          	<td>审批变量</td><input id="currStep" type="hidden" /><input id="regOperator" type="hidden" />
          	<td><input class="readOnly" type="text" id="mark" size="10" readOnly="true" /></td>
          </tr>
        	</table>
				</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
	
  <div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
  	<input class="button" type="button" id="save" value="保存" />&nbsp;&nbsp;&nbsp;
  	<input class="button" type="button" id="cancel" value="撤销" />&nbsp;&nbsp;&nbsp;
  	<input class="button" type="button" id="restart" value="启动" />&nbsp;&nbsp;&nbsp;
  	<input class="button" type="button" id="suspend" value="暂停" />&nbsp;&nbsp;&nbsp;
  	<input class="button" type="button" id="close" value="关闭" />
  </div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
	<div style="width:100%;float:left;margin:10;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8;">
				<form id="statCover" name="statCover" style="width:98%;float:right;margin:1px;padding-left:2px;background:#f5f0f0;">
					<table>
			      <tr id="flow0">
			      	<td><span id="item0">申请</span><input id="flowID0" type="hidden" /></td>
			      	<td><input class="readOnly" type="text" id="checkerName0" size="8" readOnly="true" /><input id="checkerID0" type="hidden" /></td>
			      	<td>&nbsp;</td>
			      	<td>&nbsp;</td>
			      	<td>&nbsp;</td>
			      	<td>&nbsp;</td>
			      	<td><span id="checkDateTitle0">申请日期</span></td>
			      	<td><input class="readOnly" type="text" id="checkDate0" size="10" readOnly="true" /></td>
			      	<td align="right"><input class="button" type="button" id="orderCheck" value="提交审批" /></td>
			      </tr>
			      <tr id="flowMemo0">
			      	<td><span id="memoTitle0">申请意见</span></td>
			      	<td colspan="8"><textarea id="memo0" style="padding:2px;" rows="1" cols="88"/></textarea>
			      		<a href="javascript:void(0);" onclick="showDescriptionGlass('memo0')"><img src='images/comment.png' border='0'></a>
			      	</td>
			      	<td><input class="button" type="button" id="flowSave0" value="保存" /></td>
			      </tr>
			      <tr id="flow1">
			      	<td><span id="item1">初审</span><input id="flowID1" type="hidden" /></td>
			      	<td><input class="readOnly" type="text" id="checkerName1" size="8" readOnly="true" />&nbsp;<input class="readOnly" type="text" id="flowStatusName1" size="3" readOnly="true" />
			      		<input id="flowStatus1" type="hidden" /><input id="checkerID1" type="hidden" /></td>
			      	<td><span id="orderDateTitle1">流转</span></td>
			      	<td><input class="readOnly" type="text" id="orderDate1" size="10" readOnly="true" /></td>
			      	<td><span id="planDateTitle1">期限</span></td>
			      	<td><input class="readOnly" type="text" id="planDate1" size="10" readOnly="true" /></td>
			      	<td><span id="checkDateTitle1">审批日期</span></td>
			      	<td><input class="readOnly" type="text" id="checkDate1" size="10" readOnly="true" /></td>
			      	<td align="right">&nbsp;<input class="button" type="button" id="confirm1" value="同意" />&nbsp;<input class="button" type="button" id="refuse1" value="不同意" /></td>
			      </tr>
			      <tr id="flowMemo1">
			      	<td><span id="memoTitle1">初审意见</span></td>
			      	<td colspan="8"><textarea id="memo1" style="padding:2px;" rows="1" cols="88"/></textarea>
			      		<a href="javascript:void(0);" onclick="showDescriptionGlass('memo1')"><img src='images/comment.png' border='0'></a>
			      	</td>
			      	<td><input class="button" type="button" id="flowSave1" value="保存" /></td>
			      </tr>
			      <tr id="flow2">
			      	<td><span id="item2">审核</span><input id="flowID2" type="hidden" /></td>
			      	<td><input class="readOnly" type="text" id="checkerName2" size="8" readOnly="true" />&nbsp;<input class="readOnly" type="text" id="flowStatusName2" size="3" readOnly="true" />
			      		<input id="flowStatus2" type="hidden" /><input id="checkerID2" type="hidden" /></td>
			      	<td><span id="orderDateTitle2">流转</span></td>
			      	<td><input class="readOnly" type="text" id="orderDate2" size="10" readOnly="true" /></td>
			      	<td><span id="planDateTitle2">期限</span></td>
			      	<td><input class="readOnly" type="text" id="planDate2" size="10" readOnly="true" /></td>
			      	<td><span id="checkDateTitle2">审批日期</span></td>
			      	<td><input class="readOnly" type="text" id="checkDate2" size="10" readOnly="true" /></td>
			      	<td align="right">&nbsp;<input class="button" type="button" id="confirm2" value="同意" />&nbsp;<input class="button" type="button" id="refuse2" value="不同意" /></td>
			      </tr>
			      <tr id="flowMemo2">
			      	<td><span id="memoTitle2">审核意见</span></td>
			      	<td colspan="8"><textarea id="memo2" style="padding:2px;" rows="1" cols="88"/></textarea>
			      		<a href="javascript:void(0);" onclick="showDescriptionGlass('memo2')"><img src='images/comment.png' border='0'></a>
			      	</td>
			      	<td><input class="button" type="button" id="flowSave2" value="保存" /></td>
			      </tr>
			      <tr id="flow3">
			      	<td><span id="item3">复审</span><input id="flowID3" type="hidden" /></td>
			      	<td><input class="readOnly" type="text" id="checkerName3" size="8" readOnly="true" />&nbsp;<input class="readOnly" type="text" id="flowStatusName3" size="3" readOnly="true" />
			      		<input id="flowStatus3" type="hidden" /><input id="checkerID3" type="hidden" /></td>
			      	<td><span id="orderDateTitle3">流转</span></td>
			      	<td><input class="readOnly" type="text" id="orderDate3" size="10" readOnly="true" /></td>
			      	<td><span id="planDateTitle3">期限</span></td>
			      	<td><input class="readOnly" type="text" id="planDate3" size="10" readOnly="true" /></td>
			      	<td><span id="checkDateTitle3">审批日期</span></td>
			      	<td><input class="readOnly" type="text" id="checkDate3" size="10" readOnly="true" /></td>
			      	<td align="right">&nbsp;<input class="button" type="button" id="confirm3" value="同意" />&nbsp;<input class="button" type="button" id="refuse3" value="不同意" /></td>
			      </tr>
			      <tr id="flowMemo3">
			      	<td><span id="memoTitle3">复审意见</span></td>
			      	<td colspan="8"><textarea id="memo3" style="padding:2px;" rows="1" cols="88"/></textarea>
			      		<a href="javascript:void(0);" onclick="showDescriptionGlass('memo3')"><img src='images/comment.png' border='0'></a>
			      	</td>
			      	<td><input class="button" type="button" id="flowSave3" value="保存" /></td>
			      </tr>
			      <tr id="flow4">
			      	<td><span id="item4">审核</span><input id="flowID4" type="hidden" /></td>
			      	<td><input class="readOnly" type="text" id="checkerName4" size="8" readOnly="true" />&nbsp;<input class="readOnly" type="text" id="flowStatusName4" size="3" readOnly="true" />
			      		<input id="flowStatus4" type="hidden" /><input id="checkerID4" type="hidden" /></td>
			      	<td><span id="orderDateTitle4">流转</span></td>
			      	<td><input class="readOnly" type="text" id="orderDate4" size="10" readOnly="true" /></td>
			      	<td><span id="planDateTitle4">期限</span></td>
			      	<td><input class="readOnly" type="text" id="planDate4" size="10" readOnly="true" /></td>
			      	<td><span id="checkDateTitle4">审批日期</span></td>
			      	<td><input class="readOnly" type="text" id="checkDate4" size="10" readOnly="true" /></td>
			      	<td align="right">&nbsp;<input class="button" type="button" id="confirm4" value="同意" />&nbsp;<input class="button" type="button" id="refuse4" value="不同意" /></td>
			      </tr>
			      <tr id="flowMemo4">
			      	<td><span id="memoTitle4">审核意见</span></td>
			      	<td colspan="8"><textarea id="memo4" style="padding:2px;" rows="1" cols="88"/></textarea>
			      		<a href="javascript:void(0);" onclick="showDescriptionGlass('memo4')"><img src='images/comment.png' border='0'></a>
			      	</td>
			      	<td><input class="button" type="button" id="flowSave4" value="保存" /></td>
			      </tr>
			    </table>
				</form>
			</div>
			<div style="border:solid 1px #e0e0e0;width:99%;float:right;margin:1px;background:#AAAAFF;line-height:18px;">
				<span style="padding-left:10px;"><input class="button" id="btnLoadFile" onClick="showLoadFile('checkID',0)" type="button" value="附件上传" /></span>
	      <span id="downloadFile_checkID">&nbsp;</span>
	    </div>
		</div>
	</div>
</div>
</body>
