<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/data_table.css" rel="stylesheet" type="text/css" />
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var nodeID = "";
	var refID = "";
	var kindID = "archive";
	var op = 0;
	var updateCount = 0;
	var chk = 0;
	<!--#include file="js/commFunction.js"-->
	<!--#include file="checkFlowBarReady.js"-->
	
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		refID = "<%=refID%>";
		op = "<%=op%>";
		getDicList("status","",0);
		getDicList("yesno","selfCheck",0);
		$("#dateArchive").click(function(){WdatePicker();});

    $.ajaxSetup({ 
  		async: false 
  	}); 
		if(nodeID==0 && op!=1 && refID>0){		//根据项目查找对应的
			$.get("docResultControl.asp?op=getIDbyProject&refID=" + refID + "&times=" + (new Date().getTime()),function(data){
				nodeID = unescape(data);
			});
		}
		
		if(refID>0){
			getProjectInfo(refID);
		}
		if(nodeID==0 && op!=1 && refID>0 && chk){		//自动设为新增状态
			op = 1;
			setButton();
		}
		
		if(op!=1){
			getNodeInfo(nodeID);
		}

		$("#addNew").click(function(){
			op = 1;
			setButton();
		});
		
		$("#btnPickMan").click(function(){
			var s = "reporterID|reporterName";
			setSession("userList",s);
			showUserList();
		});

		$("#save").click(function(){
			//alert($("#docResultID").val() + "&refID=" + $("#projectID").val() + "&dateReport=" + $("#dateReport").val() + "&status=" + $("#status").val() + "&selfCheck=" + $("#selfCheck").val() + "&docNo=" + ($("#docNo").val()) + "&reporterID=" + ($("#reporterID").val()) + "&memo=" + ($("#memo").val()));
			$.get("docResultControl.asp?op=update&nodeID=" + $("#docResultID").val() + "&refID=" + $("#projectID").val() + "&status=" + $("#status").val() + "&dateReport=" + $("#dateReport").val() + "&selfCheck=" + $("#selfCheck").val() + "&docNo=" + escape($("#docNo").val()) + "&reporterID=" + escape($("#reporterID").val()) + "&memo=" + escape($("#memo").val()) + "&regDate=" + $("#regDate").val() + "&regOperator=" + escape($("#regOperator").val()) + "&times=" + (new Date().getTime()),function(re){
				//jAlert(unescape(re));
				var ar = new Array();
				ar = unescape(re).split("|");
				if(ar[0] == 0){
					if(op==1){	//新增
						if($("#selfCheck").val()==1){
							jAlert("保存成功！现在可以<font color='red'>提交审批</font>。","信息提示");
						}else{
							jAlert("保存成功！自检完成后才可以<font color='red'>提交审批</font>。","信息提示");
						}
					}else{
						jAlert("保存成功!","信息提示");
					}
					updateCount += 1;
					nodeID = ar[1];
					getNodeInfo(ar[1]);
				}
				if(ar[0] == 1){
					jAlert("编号不能为空。","信息提示");
					$("#docNo").focus();
				}
				if(ar[0] == 2){
					jAlert("编制人不能为空。","信息提示");
					$("#reporterName").focus();
				}
				if(ar[0] == 3){
					jAlert("资料内容不能为空。","信息提示");
					//$("#item").focus();
				}
				if(ar[0] == 9){
					jAlert("该项目中已经有成果包，不能增加新的。","信息提示");
				}
			});
			return false;
		});

		$("#del").click(function(){
			jConfirm('你确定要删除这个项目吗?', '确认对话框', function(r) {
				if(r){
					$.get("docResultControl.asp?op=delNode&nodeID=" + $("#docResultID").val() + "&times=" + (new Date().getTime()),function(data){
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
		$.get("docResultControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#docResultID").val(ar[0]);
				$("#docNo").val(ar[1]);
				$("#status").val(ar[2]);
				$("#reporterID").val(ar[4]);
				$("#reporterName").val(ar[5]);
				$("#dateReport").val(ar[6]);
				$("#memo").val(ar[7]);
				$("#regDate").val(ar[8]);
				$("#regOperator").val(ar[9]);
				$("#registorName").val(ar[10]);
				$("#projectID").val(ar[11]);
				$("#projectName").val(ar[12]);
				$("#contractNo").val(ar[15]);
				$("#unitOwnerName").val(ar[17]);
				$("#unitBuilderName").val(ar[19]);
				$("#typeName").val(ar[25]);
				$("#amountC").val(ar[26]);
				$("#amount").val(ar[26]);
				$("#amountCheck").val(ar[27]);
				$("#amountD").val(ar[28]);
				$("#amountA").val(ar[29]);
				$("#reduceRate").val(ar[30]);
				$("#selfCheck").val(ar[31]);
				chk = checkPermission("CA",$("#projectID").val());
				op = 0;
				getCheckFlowBar(2,ar[0]);	//kind: 0 合同 1 项目登记  2 成果报告  3 发票  4归档  5 工作评价  6 收费计算表  9 请假
				if($("#selfCheck").val()==1){
					$("#commCheckFlowBar").show();
				}else{
					$("#commCheckFlowBar").hide();
				}
				if(op==1 && $("#selfCheck").val()==1){	//新增
					$("#btnCommit4Check").click();
					op = 0;
				}
				getDownloadFile("docResultID");
				setButton();
			}else{
				//jAlert("该项目信息未找到！","信息提示");
				setEmpty();
				setButton();
			}
		});
	}

	function getProjectInfo(id){
		//alert(id);
		$.get("projectControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#projectName").val(ar[1]);
				$("#engineeringID").val(ar[20]);
				//$("#engineeringName").val(ar[21]);
				$("#projectID").val(ar[0]);
				$("#contractNo").val(ar[22]);
				$("#unitOwnerName").val(ar[7]);
				$("#unitBuilderName").val(ar[9]);
				$("#typeName").val(ar[15]);
				chk = checkPermission("CA",$("#projectID").val());
			}
		});
	}
	
	function getValList(){
		var s = "";
		s = "文件" + floatCount + "项  归档日期" + $("#dateArchive").val();
		return s;
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
			if(chk && $("#docResultID").val()>0){
				$("#save").show();
				$("#del").show();
				$("#btnLoadFile").attr("disabled",false);
			}
		}
	}
	
	function setEmpty(){
		$("#docResultID").val(0);
		$("#status").val(0);
		$("#docNo").val("");
		$("#reporterID").val(currUser);
		$("#reporterName").val(currUserName);
		$("#dateReport").val("");
		$("#memo").val("");
		$("#regDate").val(currDate);
		$("#regOperator").val(currUser);
		$("#registorName").val(currUserName);
		$("#downloadFile_docResultID").html("");
		$("#commCheckFlowBar").empty();
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
		<div style="bdocResult:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8;">
				<form id="detailCover" name="detailCover" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
					<table>
          <tr>
          	<td align="right">成果编号</td><input id="docResultID" type="hidden" /><input id="dateReport" type="hidden" />
          	<td><input class="readOnly" type="text" id="docNo" size="15" readOnly="true" /></td>
          	<td align="right">状态</td>
          	<td><select id="status" style="width:90px"></select></td>
          	<td align="right">自检</td>
          	<td><select id="selfCheck" style="width:90px"></select></td>
          </tr>
          <tr>
          	<td align="right">委托单位</td>
          	<td colspan="3"><input class="readOnly" type="text" id="unitOwnerName" size="35" readOnly="true" /></td>
          	<td align="right">&nbsp;&nbsp;合同编号</td>
          	<td><input class="readOnly" type="text" id="contractNo" size="15" readOnly="true" /></td>
          </tr>
          <tr>
          	<td align="right">项目名称</td><input id="projectID" type="hidden" /><input id="engineeringID" type="hidden" />
          	<td colspan="3"><input class="readOnly" type="text" id="projectName" size="35" readOnly="true" /></td>
          	<td align="right">编制人</td><input id="reporterID" type="hidden" />
          	<td><input class="mustFill" type="text" id="reporterName" size="10" />
          		<input type="button"  style="width:19px;background-image: url('images/find.png')" id="btnPickMan" value="" />
          	</td>
          </tr>
          <tr>
          	<td align="right">施工单位</td>
          	<td colspan="3"><input class="readOnly" type="text" id="unitBuilderName" size="35" readOnly="true" /></td>
          	<td align="right">计价方式</td>
          	<td><input class="readOnly" type="text" id="typeName" size="15" readOnly="true" /></td>
          </tr>
          <tr>
          	<td align="right">合同价</td>
          	<td align="right"><input class="readOnly" type="text" id="amountC" size="35" readOnly="true" /></td>
          	<td align="right">送审价</td>
          	<td><input class="readOnly" type="text" id="amount" size="15" readOnly="true" /></td>
          	<td align="right">审定价</td>
          	<td><input class="readOnly" type="text" id="amountCheck" size="15" readOnly="true" /></td>
          </tr>
          <tr>
          	<td align="right">核减金额</td>
          	<td align="right"><input class="readOnly" type="text" id="amountD" size="35" readOnly="true" /></td>
          	<td align="right">核增金额</td>
          	<td><input class="readOnly" type="text" id="amountA" size="15" readOnly="true" /></td>
          	<td align="right">核减率</td>
          	<td><input class="readOnly" type="text" id="reduceRate" size="12" readOnly="true" />&nbsp;%</td>
          </tr>
          <tr>
          <tr>
          	<td align="right">备注</td>
          	<td colspan="5"><textarea id="memo" style="padding:2px;" rows="3" cols="80"/></textarea></td>
          </tr>
          </tr>
          <tr>
          	<td align="right">登记日期</td>
          	<td><input class="readOnly" type="text" id="regDate" size="15" readOnly="true" /></td>
          	<td align="right">登记人</td><input type="hidden" id="regOperator" />
          	<td><input class="readOnly" type="text" id="registorName" size="10" readOnly="true" /></td>
          	<td align="right">&nbsp;</td>
          	<td align="right">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="6">
							<div style="bdocResult:solid 1px #e0e0e0;width:99%;margin:1px;background:#AAAAFF;line-height:18px;">
								<span style="padding-left:10px;"><input class="button" id="btnLoadFile" onClick="showLoadFile('docResultID',0)" type="button" value="附件上传" /></span>
					      <span id="downloadFile_docResultID">&nbsp;</span>
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
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  
  <!--#include file="checkFlowBarDetail.js"-->
</div>
</body>
