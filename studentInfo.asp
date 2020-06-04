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
	var op = 0;
	var updateCount = 0;
	var username = "";
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 
		setButton();
		
		getNodeInfo(nodeID);

		$("#reply").click(function(){
			showMessageInfo(0,0,1,0,$("#username").val());
		});
		$("#save").click(function(){
			saveNode();
		});
		$("#close").click(function(){
			jConfirm('你确定要禁用这个学员用户吗?', '确认对话框', function(r) {
				if(r){
					$.get("studentControl.asp?op=setStatus&nodeID=" + $("#studentID").val() + "&status=1&times=" + (new Date().getTime()),function(data){
						jAlert("成功禁用！","信息提示");
						getNodeInfo(nodeID);
						updateCount += 1;
					});
				}
			});
		});
		$("#open").click(function(){
			jConfirm('你确定要解禁这个学员用户吗?', '确认对话框', function(r) {
				if(r){
					$.get("studentControl.asp?op=setStatus&nodeID=" + $("#studentID").val() + "&status=0&times=" + (new Date().getTime()),function(data){
						jAlert("成功解禁！","信息提示");
						getNodeInfo(nodeID);
						updateCount += 1;
					});
				}
			});
		});
	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		$.get("studentControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#studentID").val(ar[0]);
				$("#name").val(ar[2]);
				$("#username").val(ar[1]);
				$("#sexName").val(ar[8]);
				$("#age").val(ar[9]);
				$("#mobile").val(ar[7]);
				$("#phone").val(ar[17]);
				$("#email").val(ar[16]);
				$("#kindName").val(ar[6]);
				$("#status").val(ar[3]);
				$("#statusName").val(ar[4]);
				$("#limitDate").val(ar[20]);
				$("#hostName").val(ar[12]);
				$("#dept1Name").val(ar[13]);
				$("#dept2Name").val(ar[14]);
				$("#job").val(ar[18]);
				$("#memo").val(ar[10]);
				$("#regDate").val(ar[11]);
				$("#upload1").html("<a href='javascript:showLoadFile(\"student_photo\",\"" + ar[1] + "\",\"student\");' style='padding:3px;'>上传</a>");
				var c = "";
				if(ar[21] > ""){
					c += "<a href='/users" + ar[21] + "' target='_blank'>照片</a>";
				}
				if(ar[22] > ""){
					c += "&nbsp;&nbsp;<a href='/users" + ar[22] + "' target='_blank'>身份证正面</a>";
				}
				if(ar[23] > ""){
					c += "&nbsp;&nbsp;<a href='/users" + ar[23] + "' target='_blank'>身份证反面</a>";
				}
				if(ar[24] > ""){
					c += "&nbsp;&nbsp;<a href='/users" + ar[24] + "' target='_blank'>学历证书</a>";
				}
				if(c == ""){c = "&nbsp;&nbsp;还未上传";}
				$("#photo").html(c);
				//getDownloadFile("studentID");
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		if($("#memo").val().length < 3){
			jAlert("备注信息请至少填写3个字的内容。");
			return false;
		}
		//alert($("#studentID").val() + "&item=" + ($("#memo").val()));
		$.get("studentControl.asp?op=setMemo&nodeID=" + $("#studentID").val() + "&item=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				jAlert("保存成功！","信息提示");
				updateCount += 1;
			}
		});
		return false;
	}
	
	function setButton(){
		//$("#reply").hide();
		if($("#status").val()==0){
			$("#open").hide();
			$("#close").show();
		}else{
			$("#open").show();
			$("#close").hide();
		}
	}
	
	function setEmpty(){
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
				<td align="right">姓名</td><input type="hidden" id="studentID" />
				<td><input class="readOnly" type="text" id="name" size="25" readOnly="true" /></td>
				<td align="right">身份证</td><input type="hidden" id="status" />
				<td><input class="readOnly" type="text" id="username" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">性别</td>
				<td><input class="readOnly" type="text" id="sexName" size="25" readOnly="true" /></td>
				<td align="right">年龄</td>
				<td><input class="readOnly" type="text" id="age" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">手机</td>
				<td><input class="readOnly" type="text" id="mobile" size="25" readOnly="true" /></td>
				<td align="right">电话</td>
				<td><input class="readOnly" type="text" id="phone" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">邮箱</td>
				<td><input class="readOnly" type="text" id="email" size="25" readOnly="true" /></td>
				<td align="right">类型</td>
				<td><input class="readOnly" type="text" id="kindName" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">状态</td>
				<td><input class="readOnly" type="text" id="statusName" size="25" readOnly="true" /></td>
				<td align="right">有效期</td>
				<td><input class="readOnly" type="text" id="limitDate" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">公司</td>
				<td><input class="readOnly" type="text" id="hostName" size="25" readOnly="true" /></td>
				<td align="right">一级部门</td>
				<td><input class="readOnly" type="text" id="dept1Name" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">二级部门</td>
				<td><input class="readOnly" type="text" id="dept2Name" size="25" readOnly="true" /></td>
				<td align="right">岗位</td>
				<td><input class="readOnly" type="text" id="job" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">备注</td>
				<td colspan="5"><input type="text" id="memo" size="70" /></td>
			</tr>
			<tr>
				<td align="right">注册日期</td>
				<td><input class="readOnly" type="text" id="regDate" size="25" readOnly="true" /></td>
				<td align="right">资料</td>
				<td>
					<span id="upload1" style="margin-left:10px;border:1px solid orange;"></span>
					<span id="photo" style="margin-left:10px;"></span>
				</td>
			</tr>
			</table>
			</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
  	<input class="button" type="button" id="reply" name="reply" value="发通知" />&nbsp;
  	<input class="button" type="button" id="save" name="save" value="保存备注" />&nbsp;
  	<input class="button" type="button" id="open" name="open" value="解禁" />&nbsp;
  	<input class="button" type="button" id="close" name="close" value="禁用" />&nbsp;
  </div>
</div>
</body>
