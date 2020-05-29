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
<link href="css/data_table_mini.css" rel="stylesheet" type="text/css" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var nodeID = "";
	var refID = "";
	var kindID = 0;
	var op = 0;
	var updateCount = 0;
	var chk = 0;
	<!--#include file="js/commFunction.js"-->
	
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		refID = "<%=refID%>";
		kindID = "<%=kindID%>";
		op = "<%=op%>";
		
    $.ajaxSetup({ 
  		async: false 
  	}); 

		$("#borrowDate").click(function(){WdatePicker();});
		$("#limitDate").click(function(){WdatePicker();});
		chk = checkPermission("borrowAdd",0);

		if(op==1){
			setButton();
			if(refID>0){
				findArchiveInfo("",refID);
				$("#borrower").focus();
			}else{
				$("#archiveNo").focus();
			}
		}

		if(op!=1){
			getNodeInfo(nodeID);
		}

		$("#addNew").click(function(){
			op = 1;
			setButton();
		});

		$("#save").click(function(){
			save($("#status").val());
		});
		$("#borrow").click(function(){
			$("#borrowDate").val(currDate);
			$("#borrowerID").val(currUser);
			jConfirm('确定要借出吗?', '确认对话框', function(r) {
				if(r){
					save(3);
				}
			});
		});
		$("#return").click(function(){
			$("#returnDate").val(currDate);
			$("#returnOperator").val(currUser);
			jConfirm('确定要归还吗?', '确认对话框', function(r) {
				if(r){
					save(4);
				}
			});
		});
		
		$("#archiveNo").keypress(function(event){
			if(event.keyCode==13){
				findArchiveInfo("No",$("#archiveNo").val());
			}      
		});

		$("#del").click(function(){
			jConfirm('确定要删除这份借阅申请吗?', '确认对话框', function(r) {
				if(r){
					$.get("archiveBorrowControl.asp?op=delNode&nodeID=" + $("#archiveBorrowID").val() + "&times=" + (new Date().getTime()),function(data){
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
		$.get("archiveBorrowControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#archiveBorrowID").val(ar[0]);
				nodeID = ar[0];
				$("#archiveNo").val(ar[1]);
				$("#item").val(ar[2]);
				$("#status").val(ar[3]);
				$("#statusName").val(ar[4]);
				$("#kindID").val(ar[5]);
				$("#kindName").val(ar[6]);
				$("#borrowDate").val(ar[7]);
				$("#limitDate").val(ar[8]);
				$("#page").val(ar[9]);
				$("#location").val(ar[10]);
				$("#borrower").val(ar[11]);
				$("#returnDate").val(ar[12]);
				$("#returnOperator").val(ar[13]);
				$("#returnOperatorName").val(ar[14]);
				$("#checkDate").val(ar[15]);
				$("#checkerID").val(ar[16]);
				$("#checkerName").val(ar[17]);
				$("#memo").val(ar[18]);
				$("#regDate").val(ar[19]);
				$("#regOperator").val(ar[20]);
				$("#registorName").val(ar[21]);
				$("#archiveID").val(ar[22]);
				getCheckFlowList(1,ar[0]);
				op = 0;
				getDownloadFile("archiveBorrowID");
				setButton();
			}else{
				//jAlert("该项目信息未找到！","信息提示");
				setEmpty();
				setButton();
			}
		});
	}
	
	function save(id){
		//alert($("#archiveBorrowID").val() + "&orderNo=" + $("#orderNo").val() + "&kindID=" + $("#kindID").val() + "&item=" + ($("#item").val()) + "&unitID=" + $("#unitID").val() + "&unitName=" + ($("#unitName").val()) + "&status=" + $("#status").val() + "&orderDate=" + $("#orderDate").val() + "&openDate=" + $("#openDate").val() + "&parkDate=" + $("#parkDate").val() + "&bossID=" + $("#bossID").val() + "&phone=" + ($("#phone").val()) + "&unitCode=" + $("#unitCode").val() + "&orderAmount=" + $("#orderAmount").val() + "&parkID=" + $("#parkID").val() + "&archiveBorrowID=" + $("#archiveBorrowID").val() + "&address=" + ($("#address").val()) + "&bank=" + ($("#bank").val()) + "&accountBank=" + $("#accountBank").val() + "&accountOwner=" + ($("#accountOwner").val()) + "&memo=" + ($("#memo").val()) + "&regDate=" + $("#regDate").val() + "&regOperator=" + ($("#regOperator").val()));
		$.get("archiveBorrowControl.asp?op=update&nodeID=" + $("#archiveBorrowID").val() + "&refID=" + $("#archiveID").val() + "&status=" + id + "&borrower=" + escape($("#borrower").val()) + "&borrowDate=" + $("#borrowDate").val() + "&limitDate=" + $("#limitDate").val() + "&returnDate=" + $("#returnDate").val() + "&returnOperator=" + escape($("#returnOperator").val()) + "&memo=" + escape($("#memo").val()) + "&regOperator=" + escape($("#regOperator").val()) + "&times=" + (new Date().getTime()),function(re){
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
				jAlert("归还期限不能为空。","信息提示");
				$("#limitDate").focus();
			}
			if(ar[0] == 2){
				jAlert("借阅人不能为空。","信息提示");
				$("#borrower").focus();
			}
			if(ar[0] == 3){
				jAlert("借阅事由不能为空。","信息提示");
				$("#memo").focus();
			}
		});
		return false;
	}

	function findArchiveInfo(op,id){
		if(id>""){
			if(op=="No"){
				op = "getNodeByNo";
			}else{
				op = "getNodeInfo";
			}
			$.get("archiveControl.asp?op=" + op + "&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
				//jAlert(unescape(re));
				var ar = new Array();
				ar = unescape(re).split("|");
				if(ar > ""){
					$("#archiveID").val(ar[0]);
					$("#archiveNo").val(ar[1]);
					$("#item").val(ar[2]);
					$("#kindID").val(ar[5]);
					$("#kindName").val(ar[6]);
					$("#page").val(ar[9]);
					$("#location").val(ar[10]);;
				}else{
					jAlert("该档案信息未找到！","信息提示");
					$("#archiveNo").val("");
				}
			});
			return false;
		}else{
			jAlert("请给出档案编号。");
		}    
	}
	
	function setButton(){
		//alert(op + ":" + $("#regOperator").val() + ":" + $("#projectID").val());
		$("#save").hide();
		$("#del").hide();
		$("#addNew").hide();
		$("#return").hide();
		$("#borrow").hide();
		$("#btnLoadFile").attr("disabled",true);
		if(op ==1){
			setEmpty();
			setObjMustFill("borrower|limitDate|archiveNo",1,0);
			$("#save").show();
		}
		if(op ==0){
			if(!chk || $("#status").val()>1){		//审批后不可修改
				setObjReadOnly("borrower|limitDate|archiveNo",1,0);
			}
			if(chk){
				$("#addNew").show();
			}
			if(chk && $("#archiveBorrowID").val()>0){
				$("#save").show();
				$("#btnLoadFile").attr("disabled",false);
				if($("#status").val()<2){	//审批前可删除
					$("#del").show();
				}
			}
			if(chk && $("#status").val()==2){	//审批后可借出
				$("#borrow").show();
			}
			if(chk && $("#status").val()==3){	//借出后可归还
				$("#return").show();
			}
		}
	}
	
	function setEmpty(){
		$("#archiveBorrowID").val(0);
		$("#archiveID").val(0);
		$("#borrower").val("");  //new item
		$("#borrowDate").val("");
		$("#limitDate").val(getWorkDateAfter(3,currDate));
		$("#status").val(0);
		$("#statusName").val("草稿");
		$("#kindName").val("");
		$("#archiveNo").val("");
		$("#returnDate").val("");
		$("#checkerID").val("");
		$("#checkDate").val("");
		$("#checkerName").val("");
		$("#returnOperator").val("");
		$("#returnOperatorName").val("");
		$("#item").val("");
		$("#memo").val("");
		$("#regDate").val(currDate);
		$("#regOperator").val(currUser);
		$("#registorName").val(currUserName);
		$("#downloadFile_archiveBorrowID").html("");
	}
	
	function getValList(){
		return $("#archiveBorrowID").val() + "|" + $("#item").val();
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
          	<td align="right">档案编号</td><input id="archiveBorrowID" type="hidden" /><input id="archiveID" type="hidden" />
          	<td><input class="mustFill" type="text" id="archiveNo" size="12" /></td>
          	<td align="right">类型</td><input id="kindID" type="hidden" />
          	<td><input class="readOnly" type="text" id="kindName" size="12" readOnly="true" /></td>
          	<td align="right">状态</td><input id="status" type="hidden" />
          	<td><input class="readOnly" type="text" id="statusName" size="12" readOnly="true" /></td>
          </tr>
          <tr>
          	<td>档案标题</td>
          	<td colspan="3"><input class="readOnly" type="text" id="item" size="46" readOnly="true" /></td>
          	<td align="right">库位</td>
          	<td><input class="readOnly" type="text" id="location" size="12" readOnly="true" /></td>
          </tr>
          <tr>
          	<td align="right">借阅人</td>
          	<td><input class="mustFill" type="text" id="borrower" size="12" /></td>
          	<td align="right">借阅日期</td>
          	<td><input class="readOnly" type="text" id="borrowDate" size="12" readOnly="true" /></td>
          	<td align="right">归还期限</td>
          	<td><input class="mustFill" type="text" id="limitDate" size="12" /></td>
          </tr>
          <tr>
          	<td>借阅事由</td>
          	<td colspan="5"><input class="mustFill" type="text" id="memo" size="70" /></td>
          </tr>
          <tr>
          	<td align="right">批准日期</td>
          	<td><input class="readOnly" type="text" id="checkDate" size="12" readOnly="true" /></td>
          	<td align="right">批准人</td><input type="hidden" id="checkerID" />
          	<td><input class="readOnly" type="text" id="checkerName" size="12" readOnly="true" /></td>
          	<td align="right">归还日期</td>
          	<td><input class="readOnly" type="text" id="returnDate" size="12" readOnly="true" /></td>
          </tr>
          <tr>
          	<td align="right">归还经手</td><input type="hidden" id="returnOperator" />
          	<td><input class="readOnly" type="text" id="returnOperatorName" size="12" readOnly="true" /></td>
          	<td align="right">申请日期</td>
          	<td><input class="readOnly" type="text" id="regDate" size="12" readOnly="true" /></td>
          	<td align="right">登记人</td><input type="hidden" id="regOperator" />
          	<td><input class="readOnly" type="text" id="registorName" size="12" readOnly="true" /></td>
          </tr>
          <tr>
            <td colspan="6">
							<div style="battachDoc:solid 1px #e0e0e0;width:99%;margin:1px;background:#AAAAFF;line-height:18px;">
								<span style="padding-left:10px;"><input class="button" id="btnLoadFile" onClick="showLoadFile('archiveBorrowID',0)" type="button" value="附件上传" /></span>
					      <span id="downloadFile_archiveBorrowID">&nbsp;</span>
					    </div>
            </td>
          </tr>
        	</table>
				</form>
			</div>
		</div>
	</div>
	
	<div style="width:99%;float:left;margin:10;height:4px;"></div>
  <div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
  	<input class="button" type="button" id="save" value="保存" />&nbsp;
  	<input class="button" type="button" id="addNew" value="新增" />&nbsp;
  	<input class="button" type="button" id="borrow" value="借出" />&nbsp;
  	<input class="button" type="button" id="return" value="归还" />&nbsp;
  	<input class="button" type="button" id="del" value="删除" />
  </div>
  
	<div style="width:99%;float:left;margin:10;height:4px;"></div>
	
	<div style="width:99%;float:left;margin:10;">
		<div id="checkFlowCover" style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
		</div>
	</div>
	
</div>
</body>
