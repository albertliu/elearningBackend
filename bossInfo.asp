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
	var val = 0;
	var cStreet = 0;
	<!--#include file="js/commFunction.js"-->
	
	$(document).ready(function (){
		nodeID = "<%=nodeID%>"; //SID
		refID = "<%=refID%>";	  //unitID
		op = "<%=op%>";
		getDicList("status","",0);
		getDicList("area","",0);
		getDicList("education","",0);
		
    $.ajaxSetup({ 
  		async: false 
  	}); 
  	
  	if(refID>0){
  		cStreet = getStreetIDbyUnit(refID);
  	}
  	
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
		
		$("#SID").blur(function(){
			checkSID();
		});

		$("#save").click(function(){
			//alert($("#SID").val() + "&name=" + ($("#name").val()) + "&status=" + $("#status").val() + "&area=" + $("#area").val() + "&education=" + $("#education").val() + "&phone=" + ($("#phone").val()) + "&email=" + ($("#email").val()) + "&IM=" + ($("#IM").val()) + "&memo=" + ($("#memo").val()) + "&regDate=" + $("#regDate").val() + "&regOperator=" + ($("#regOperator").val()));
			$.get("bossControl.asp?op=update&nodeID=" + $("#SID").val() + "&name=" + escape($("#name").val()) + "&status=" + $("#status").val() + "&area=" + $("#area").val() + "&education=" + $("#education").val() + "&phone=" + escape($("#phone").val()) + "&email=" + escape($("#email").val()) + "&IM=" + escape($("#IM").val()) + "&memo=" + escape($("#memo").val()) + "&regDate=" + $("#regDate").val() + "&regOperator=" + escape($("#regOperator").val()) + "&times=" + (new Date().getTime()),function(re){
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
					jAlert("联系电话不能为空。","信息提示");
					$("#phone").focus();
				}
			});
			return false;
		});

		$("#del").click(function(){
			jConfirm('你确定要删除这个项目吗?', '确认对话框', function(r) {
				if(r){
					$.get("bossControl.asp?op=delNode&nodeID=" + $("#bossID").val() + "&times=" + (new Date().getTime()),function(data){
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
		$.get("bossControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#bossID").val(ar[0]);
				$("#SID").val(ar[1]);
				$("#name").val(ar[2]);
				$("#statusName").val(ar[4]);
				$("#age").val(ar[5]);
				$("#birthday").val(ar[6]);
				$("#sexName").val(ar[8]);
				$("#area").val(ar[9]);
				$("#education").val(ar[11]);
				$("#phone").val(ar[13]);
				$("#email").val(ar[14]);
				$("#IM").val(ar[15]);
				$("#memo").val(ar[16]);
				$("#regDate").val(ar[17]);
				$("#regOperator").val(ar[18]);
				$("#registorName").val(ar[19]);
				chk = 1;
				op = 0;
				getDownloadFile("bossID");
				setButton();
			}else{
				//jAlert("该项目信息未找到！","信息提示");
				setEmpty();
				setButton();
			}
		});
	}
	
	function checkSID(){
		if($("#SID").val()>""){
			var s = turnID15218($("#SID").val());
			$("#SID").val(s);
			if(checkIDcard(s)==1){
				var t = getBossNameBySID(s);
				if(t > ""){
					jAlert("此人信息已存在。");
					getNodeInfo(s);
				}
			}else{
				jAlert("身份证号码有误，请核对");
				$("#SID").val("");
				$("#SID").focus();
			}
		}
	}

	function setButton(){
		//alert(op + ":" + $("#regOperator").val() + ":" + $("#projectID").val());
		chk = checkPermission("unitAdd",0);
		$("#status").attr("disabled",true);
		$("#save").hide();
		$("#del").hide();
		$("#addNew").hide();
		$("#btnLoadFile").attr("disabled",true);
		$("#SID").attr("class","readOnly");
		$("#SID").attr("readOnly",true);
		if(op ==1){
			setEmpty();
			$("#save").show();
			$("#SID").attr("class","mustFill");
			$("#SID").attr("readOnly",false);
		}
		if(op ==0){
			if((checkPermission("orderCheck1",cStreet) || checkPermission("unitEditS",0)) && $("#bossID").val()>0){
				$("#save").show();
				$("#del").show();
				$("#btnLoadFile").attr("disabled",false);
			}
		}
	}
	
	function setEmpty(){
		$("#bossID").val(0);
		$("#status").val(0);
		$("#eduction").val(0);
		$("#SID").val("");
		$("#name").val("");
		$("#area").val(0);
		$("#phone").val("");
		$("#email").val("");
		$("#IM").val("");
		$("#memo").val("");
		$("#regDate").val(currDate);
		$("#regOperator").val(currUser);
		$("#registorName").val(currUserName);
		$("#downloadFile_bossID").html("");
	}
	
	function getValList(){
		return $("#SID").val() + "|" + $("#name").val();
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
          	<td>身份证</td><input id="bossID" type="hidden" />
          	<td><input class="mustFill" type="text" id="SID" size="18" /></td>
          	<td>姓名</td>
          	<td><input class="mustFill" type="text" id="name" size="15" /></td>
          	<td>性别</td>
          	<td><input class="readOnly" readOnly="true" type="text" id="sexName" size="15" /></td>
          </tr>
          <tr>
          	<td>出生日期</td>
          	<td><input class="readOnly" readOnly="true" type="text" id="birthday" size="15" /></td>
          	<td>年龄</td>
          	<td><input class="readOnly" readOnly="true" type="text" id="age" size="15" /></td>
          	<td>户籍区县</td>
          	<td><select id="area" style="width:90px"></select></td>
          </tr>
          <tr>
          	<td>学历</td>
          	<td><select id="education" style="width:90px"></select></td>
          	<td>状态</td><input id="status" type="hidden" />
          	<td><input class="readOnly" readOnly="true" type="text" id="statusName" size="15" /></td>
          	<td>&nbsp;</td>
          	<td>&nbsp;</td>
          </tr>
          <tr>
          	<td>电话</td>
          	<td><input class="mustFill" type="text" id="phone" size="15" /></td>
          	<td>邮箱</td>
          	<td><input type="text" id="email" size="15" /></td>
          	<td>其他</td>
          	<td><input type="text" id="IM" size="15" /></td>
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
								<span style="padding-left:10px;"><input class="button" id="btnLoadFile" onClick="showLoadFile('bossID',0)" type="button" value="附件上传" /></span>
					      <span id="downloadFile_bossID">&nbsp;</span>
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
