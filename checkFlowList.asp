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
	var op = 0;
	var updateCount = 0;
	var pickBefore = "";
	var timer;
	<!--#include file="js/commFunction.js"-->
	
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		op = "<%=op%>";

		getDicList("planKind","kindID",0);
		getComList("engineeringID","engineeringInfo","ID","item","status>0",1);
		getDicList("private","",0);
		$("#startDate").click(function(){WdatePicker();});
		$("#endDate").click(function(){WdatePicker();});
		$("#finalDate").click(function(){WdatePicker();});
    $.ajaxSetup({ 
  		async: false 
  	}); 
		if(op==1){
			$("#kindID").val(2);
			$("#private").val(1);
			setButton();
		}
		if(op!=1){
			getNodeInfo(nodeID);
		}
		
		$("#kindID").change(function(){
			if($("#kindID").val()==0){
				$("#engineeringID").attr("disabled",true);
				$("#projectID").attr("disabled",true);
				$("#engineeringID").val("");
				$("#projectID").val("");
			}
			if($("#kindID").val()==1){
				$("#engineeringID").attr("disabled",false);
				$("#projectID").attr("disabled",true);
				$("#projectID").val("");
				$("#engineeringID").focus();
			}
			if($("#kindID").val()==2){
				$("#engineeringID").attr("disabled",false);
				$("#projectID").attr("disabled",false);
				$("#engineeringID").change();
				$("#engineeringID").focus();
			}
		});
		
		$("#engineeringID").change(function(){
			if($("#kindID").val()==2 && $("#engineeringID").val()>0){
				getComList("projectID","projectInfo","ID","item","engineeringID=" + $("#engineeringID").val() + " and status>0",1);
			}
		});

		$("#save").click(function(){
			saveNode();
		});

		$("#commit").click(function(){
			$("#status").val(1);
			saveNode();
		});

		$("#addNew").click(function(){
			op = 1;
			setButton();
		});

		$("#del").click(function(){
			jConfirm('你确定要删除这个计划条目吗?', '确认对话框', function(r) {
				if(r){
					$.get("planControl.asp?op=delNode&nodeID=" + $("#planID").val() + "&times=" + (new Date().getTime()),function(data){
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
		$.get("planControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#planID").val(ar[0]);
				$("#item").val(ar[1]);
				$("#status").val(ar[2]);
				$("#statusName").val(ar[3]);
				$("#userName").val(ar[4]);
				$("#userRealName").val(ar[5]);
				$("#startDate").val(ar[6]);
				$("#endDate").val(ar[7]);
				$("#finalDate").val(ar[8]);
				$("#kindID").val(ar[9]);
				if(ar[9]==0){
					$("#engineeringID").val("");
					$("#projectID").val("");
				}
				if(ar[9]==1){
					$("#engineeringID").val(ar[11]);
					$("#projectID").val("");
				}
				if(ar[9]==2){
					$("#engineeringID").val(ar[11]);
					getComList("projectID","projectInfo","ID","item","engineeringID=" + ar[11] + " and status>0",1);
					$("#projectID").val(ar[13]);
				}
				$("#remark").val(ar[15]);
				$("#memo").val(ar[16]);
				$("#regDate").val(ar[17]);
				$("#regOperator").val(ar[18]);
				$("#registorName").val(ar[19]);
				$("#title").val(ar[20]);
				$("#private").val(ar[21]);
				getDownloadFile("planID");
				setButton();
			}else{
				jAlert("该计划信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		var eID = 0;
		var pID = 0;
		if($("#kindID").val()==1){
			eID = $("#engineeringID").val();
		}
		if($("#kindID").val()==2){
			eID = $("#engineeringID").val();
			pID = $("#projectID").val();
		}
		//alert($("#planID").val() + "&pCode=" + $("#pCode").val() + "&item=" + ($("#item").val()) + "&title=" + ($("#title").val()) + "&type=" + $("#type").val() + "&kind=" + $("#kind").val() + "&status=" + $("#status").val() + "&engineeringID=" + $("#engineeringID").val() + "&dateStart=" + $("#dateStart").val() + "&dateEnd=" + $("#dateEnd").val() + "&memo=" + ($("#memo").val()) + "&mark=" + ($("#mark").val()) + "&regDate=" + $("#regDate").val() + "&regOperator=" + ($("#regOperator").val()));
		$.get("planControl.asp?op=update&nodeID=" + $("#planID").val() + "&title=" + escape($("#title").val()) + "&item=" + escape($("#item").val()) + "&status=" + $("#status").val() + "&userName=" + escape($("#userName").val()) + "&startDate=" + $("#startDate").val() + "&endDate=" + $("#endDate").val() + "&finalDate=" + $("#finalDate").val() + "&kindID=" + $("#kindID").val() + "&engineeringID=" +eID + "&projectID=" + pID + "&private=" + $("#private").val() + "&memo=" + escape($("#memo").val()) + "&remark=" + escape($("#remark").val()) + "&regDate=" + $("#regDate").val() + "&regOperator=" + escape($("#regOperator").val()) + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				jAlert("保存成功!","信息提示");
				if(op==1){	//新增
					if($("#status").val()==0){	//提醒草稿状态
						jAlert("当前为草稿状态，提交后才能生效。");
					}
					op = 0;
				}
				updateCount += 1;
				getNodeInfo(ar[1]);
			}
			if(ar[0] == 2){
				jAlert("项目名称不能为空。","信息提示");
				$("#item").focus();
			}
			if(ar[0] == 3){
				jAlert("请选择一个工程。","信息提示");
				$("#engineeringID").focus();
			}
			if(ar[0] == 4){
				jAlert("请选择一个项目。","信息提示");
				$("#projectID").focus();
			}
		});
		return false;
	}
	
	function setButton(){
		//alert(op + ":" + $("#regOperator").val() + ":" + $("#planID").val());
		$("#status").attr("disabled",true);
		$("#kindID").attr("disabled",true);
		$("#commit").hide();
		if(op ==1){
			setEmpty();
			$("#save").show();
			$("#commit").show();
			$("#del").hide();
			$("#kindID").attr("disabled",false);
			$("#btnLoadFile").attr("disabled",true);
			$("#item").focus();
		}
		if(op ==0){
			if($("#regOperator").val() == currUser && $("#planID").val()>0 && $("#status").val()!=2){
				$("#save").show();
				$("#del").show();
				$("#btnLoadFile").attr("disabled",false);
				$("#kindID").attr("disabled",false);
				if($("#status").val()==0){
					$("#commit").show();
				}
			}else{
				$("#save").hide();
				$("#del").hide();
				$("#btnLoadFile").attr("disabled",true);
			}
		}
		if($("#kindID").val()==0){
			$("#engineeringID").attr("disabled",true);
			$("#projectID").attr("disabled",true);
		}
	}
	
	function setEmpty(){
		$("#planID").val(0);
		$("#status").val(0);
		$("#statusName").val("草稿");
		$("#item").val("");
		if($("#title").val()==""){
			$("#title").val(currYear + "-" + fillFormat((parseInt(currWeek)+1),2,"0",0));
		}
		$("#userName").val(currUser);
		$("#userRealName").val(currUserName);
		//$("#kindID").val("");
		//$("#engineeringID").val(0);
		//$("#projectID").val(0);
		$("#startDate").val("");
		$("#endDate").val("");
		$("#finalDate").val("");
		$("#remark").val("");
		$("#memo").val("");
		$("#regDate").val(currDate);
		$("#regOperator").val(currUser);
		$("#registorName").val(currUserName);
		$("#downloadFile_planID").html("");
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
          	<td>计划周</td>
          	<td><input type="text" id="title" size="18" /></td>
          	<td>范围</td>
          	<td><select id="private" style="width:100px"></select></td>
          	<td>&nbsp;</td>
          	<td>&nbsp;</td>
         </tr>
          <tr>
          	<td>计划标题</td><input id="planID" type="hidden" />
          	<td><input class="mustFill" type="text" id="item" size="25" /></td>
          	<td>状态</td><input id="status" type="hidden" />
          	<td><input class="readOnly" type="text" id="statusName" size="18" readOnly="true" /></td>
          	<td>执行人</td><input id="userName" type="hidden" />
          	<td><input class="readOnly" type="text" id="userRealName" size="18" readOnly="true" /></td>
          </tr>
          <tr>
          	<td>计划类型</td>
          	<td><select id="kindID" style="width:100px"></select></td>
          	<td>工程</td>
          	<td><select id="engineeringID" style="width:100px"></select></td>
          	<td>项目</td>
          	<td><select id="projectID" style="width:100px"></select></td>
          </tr>
          </tr>
          	<td>计划内容</td>
          	<td colspan="5"><textarea id="memo" style="padding:2px;" rows="5" cols="92"/></textarea></td>
          <tr>
          <tr>
          	<td>开始日期</td>
          	<td><input type="text" id="startDate" size="20" /></td>
          	<td>结束日期</td>
          	<td><input type="text" id="endDate" size="18" /></td>
          	<td>实际完成</td>
          	<td><input type="text" id="finalDate" size="18" /></td>
          </tr>
          </tr>
          	<td>完成情况</td>
          	<td colspan="5"><textarea id="remark" style="padding:2px;" rows="5" cols="92"/></textarea></td>
          <tr>
          <tr>
          	<td>登记日期</td>
          	<td><input class="readOnly" type="text" id="regDate" size="20" readOnly="true" /></td>
          	<td>登记人</td><input type="hidden" id="regOperator" />
          	<td><input class="readOnly" type="text" id="registorName" size="18" readOnly="true" /></td>
          	<td>&nbsp;</td>
          	<td>&nbsp;</td>
         </tr>
          <tr>
            <td colspan="6">
							<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#AAAAFF;line-height:18px;">
								<span style="padding-left:10px;"><input class="button" id="btnLoadFile" onClick="showLoadFile('planID',0)" type="button" value="附件上传" /></span>
					      <span id="downloadFile_planID">&nbsp;</span>
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
  	<input class="button" type="button" id="commit" name="commit" value="提交" />&nbsp;&nbsp;&nbsp;
  	<input class="button" type="button" id="del" name="del" value="删除" />
  </div>
	
</div>
</body>
