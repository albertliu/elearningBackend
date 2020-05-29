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
<link href="css/data_table.css" rel="stylesheet" type="text/css" />
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
	var keyID = "";
	var kindID = "";
	var op = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";		//orderID
		refID = "<%=refID%>";			//unitID
		keyID = "<%=keyID%>";			//ym
		kindID = "<%=kindID%>";		//SID
		op = "<%=op%>";

		getDicList("source","",0);
		$("#source").attr("disabled",true);
		var y = parseInt(currDate.substring(0,4));
		for(var i=0; i<5; i++){
			$("<option value='" + y + "'>" + y + "</option>").appendTo("#pYear");
			y = y - 1;
		}
		var m = "";
		for(var i=0; i<12; i++){
			m = i+1
			if(i+1<10){
				m = "0" + (i+1);
			}
			$("<option value='" + m + "'>" + m + "</option>").appendTo("#pMonth");
		}

		if(op==1){
			if(refID>0){
				$("#unitID").val(refID);
				$("#unitName").val(getUnitNameByCode(refID));
			}
			setButton();
		}
		
		if(op!=1){
			getNodeInfo();
		}
		
		if(kindID>""){
			$("#SID").val(kindID);
			checkSID();
		}
		
		$("#SID").keypress(function(event){
			if(op==1 && event.keyCode==13){
				checkSID();
			}      
		});
		
		$("#SID").blur(function(){
			checkSID();
		});

		$("#save").click(function(){
			saveNode();
		});

		$("#addNew").click(function(){
			op = 1;
			setButton();
		});

		$("#del").click(function(){
			jConfirm('你确定要删除这个条目吗?', '确认对话框', function(r) {
				if(r){
					$.get("employeeFundsControl.asp?op=delNode&nodeID=" + $("#employeeFundsID").val() + "&times=" + (new Date().getTime()),function(data){
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

	function getNodeInfo(){
		//alert(id);
		$.get("employeeFundsControl.asp?op=getNodeInfo&nodeID=" + kindID + "&refID=" + refID + "&keyID=" + keyID + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#employeeFundsID").val(ar[0]);
				$("#SID").val(ar[1]);
				$("#name").val(ar[2]);
				$("#status").val(ar[3]);
				$("#unitID").val(ar[5]);
				$("#unitName").val(ar[6]);
				$("#ym").val(ar[7]);
				$("#source").val(ar[8]);
				$("#age").val(ar[9]);
				$("#birthday").val(ar[10]);
				$("#sex").val(ar[11]);
				$("#sexName").val(ar[12]);
				$("#memo").val(ar[13]);
				$("#regDate").val(ar[14]);
				$("#regOperator").val(ar[15]);
				$("#registorName").val(ar[16]);
				getDownloadFile("employeeFundsID");
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		alert(nodeID + "&name=" + ($("#name").val()) + "&status=" + $("#status").val() + "&SID=" + $("#SID").val() + "&ym=" + $("#ym").val() + "&pYear=" + $("#pYear").val() + "&unitID=" + $("#unitID").val() + "&pMonth=" + $("#pMonth").val() + "&months=" + $("#months").val());
		$.get("employeeFundsControl.asp?op=update&nodeID=" + nodeID + "&name=" + escape($("#name").val()) + "&status=" + $("#status").val() + "&SID=" + $("#SID").val() + "&ym=" + $("#ym").val() + "&pYear=" + $("#pYear").val() + "&unitID=" + $("#unitID").val() + "&pMonth=" + $("#pMonth").val() + "&months=" + $("#months").val() + "&memo=" + escape($("#memo").val()) + "&regDate=" + $("#regDate").val() + "&regOperator=" + escape($("#regOperator").val()) + "&times=" + (new Date().getTime()),function(re){
			jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				jAlert("保存成功!","信息提示");
				if(op==1){	//新增
					op = 0;
				}
				updateCount += 1;
				//getNodeInfo();
			}
			if(ar[0] == 1){
				jAlert("姓名不能为空。","信息提示");
				$("#name").focus();
			}
			if(ar[0] == 2){
				jAlert("身份证不能为空。","信息提示");
				$("#SID").focus();
			}
			if(ar[0] == 3){
				jAlert("请选择一个单位。","信息提示");
				$("#unitID").focus();
			}
			if(ar[0] == 4){
				jAlert("月份不能为空。","信息提示");
				$("#ym").focus();
			}
			if(ar[0] == 5){
				jAlert("起始年月不能为空。","信息提示");
				$("#pYear").focus();
			}
			if(ar[0] == 6){
				jAlert("连续月数不能小于1。","信息提示");
				$("#months").focus();
			}
		});
		return false;
	}
	
	function checkSID(){
		if($("#SID").val()>""){
			var s = turnID15218($("#SID").val());
			$("#SID").val(s);
			if(checkIDcard(s)==1){
				var t = getEmployeeNameBySID(s);
				if(t > ""){
					$("#name").val(t);
					$("#name").attr("class","readOnly");
					$("#name").attr("readOnly",true);
				}else{
					$("#name").val("");
					$("#name").attr("class","mustFill");
					$("#name").attr("readOnly",false);
					$("#name").focus();
				}
			}else{
				jAlert("身份证号码有误，请核对");
				$("#SID").val("");
				$("#SID").focus();
			}
		}
	}
	
	function setButton(){
		//alert(op + ":" + $("#regOperator").val() + ":" + $("#employeeFundsID").val());
		$("#status").attr("disabled",true);
		setObjReadOnly("SID|name|ym",1,0);
		if(op ==1){
			setEmpty();
			$("#save").show();
			$("#del").hide();
			$("#btnLoadFile").attr("disabled",true);
			if(kindID==""){
				setObjReadOnly("SID|name",0,0);		//全新的添加
			}
			$("#SID").focus();
			$("#item_1").show();
		}
		if(op ==0){
			$("#item_1").hide();
			if($("#regOperator").val() == currUser && $("#employeeFundsID").val()>0 && $("#status").val()==0){
				$("#save").show();
				$("#del").show();
				$("#btnLoadFile").attr("disabled",false);
			}else{
				$("#save").hide();
				$("#del").hide();
				$("#btnLoadFile").attr("disabled",true);
			}
		}
	}
	
	function setEmpty(){
		$("#employeeFundsID").val(0);
		$("#status").val(0);
		$("#SID").val("");
		$("#name").val("");
		$("#ym").val("");
		$("#months").val(1);
		$("#age").val("");
		$("#birthday").val("");
		$("#sex").val("");
		$("#sexName").val("");
		$("#regDate").val(currDate);
		$("#regOperator").val(currUser);
		$("#registorName").val(currUserName);
		$("#downloadFile_employeeFundsID").html("");
	}
	
	function getUpdateCount(){
		return updateCount;
	}
</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
 <!--#include file='commLoadFileDetail.asp' -->
	
	<div style="width:100%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8;">
				<form id="detailCover" name="detailCover" style="width:100%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
					<table>
          <tr>
          	<td>身份证</td><input id="employeeFundsID" type="hidden" />
          	<td><input class="mustFill" type="text" id="SID" size="18" /></td>
          	<td>姓名</td>
          	<td><input class="mustFill" type="text" id="name" size="15" /></td>
          	<td>性别</td>
          	<td><input class="readOnly" readOnly="true" type="text" id="sexName" size="15" /></td>
          </tr>
          <tr>
          	<td>出生日期</td><input id="status" type="hidden" />
          	<td><input class="readOnly" readOnly="true" type="text" id="birthday" size="15" /></td>
          	<td>年龄</td>
          	<td><input class="readOnly" readOnly="true" type="text" id="age" size="15" /></td>
          	<td>来源</td>
          	<td><select id="source" style="width:90px"></select></td>
          </tr>
          <tr>
          	<td>单位</td><input id="unitID" type="hidden" />
          	<td colspan="3"><input class="readOnly" readOnly="true" type="text" id="unitName" size="44" /></td>
          	<td>缴金月份</td>
          	<td><input class="mustFill" type="text" id="ym" size="15" /></td>
          </tr>
          <tr id="item_1">
          	<td>起始年月</td>
          	<td colspan="5">
          		<select id="pYear" style="width:70px"></select>&nbsp;
          		<select id="pMonth" style="width:50px"></select>&nbsp;&nbsp;
          		连续缴纳&nbsp;<input class="mustFill" type="text" id="months" size="3" />个月
          	</td>
          </tr>
          <tr>
          	<td>说明</td>
          	<td colspan="5"><textarea id="memo" style="padding:2px;" rows="5" cols="80"/></textarea></td>
          </tr>
          <tr>
          	<td>登记日期</td>
          	<td><input class="readOnly" type="text" id="regDate" size="15" readOnly="true" /></td>
          	<td>登记人</td><input type="hidden" id="regOperator" />
          	<td><input class="readOnly" type="text" id="registorName" size="15" readOnly="true" /></td>
          	<td>&nbsp;</td>
          	<td>&nbsp;</td>
          </tr>
          <tr>
            <td colspan="6">
							<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#AAAAFF;line-height:18px;">
								<span style="padding-left:10px;"><input class="button" id="btnLoadFile" onClick="showLoadFile('employeeFundsID',0)" type="button" value="附件上传" /></span>
					      <span id="downloadFile_employeeFundsID">&nbsp;</span>
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
  	<input class="button" type="button" id="save" name="save" value="保存" />&nbsp;&nbsp;&nbsp;
  	<input class="button" type="button" id="addNew" name="addNew" value="新增" />&nbsp;&nbsp;&nbsp;
  	<input class="button" type="button" id="close" name="close" value="关闭" />&nbsp;&nbsp;&nbsp;
  	<input class="button" type="button" id="del" name="del" value="删除" />
  </div>
	
</div>
</body>
