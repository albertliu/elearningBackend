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
		getDicList("student","kindID",0);
		getDicList("education","education",1);
		var w = "dept_status=0 and pID=0 and host='" + currHost + "'";
		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("companyID","deptInfo","deptID","deptName","dept_status=0 and pID=0 order by deptID",0);
		}else{
			getComList("companyID","deptInfo","deptID","deptName",w,0);
		}
		//setButton();
		
		getNodeInfo(nodeID);

		$("#reply").click(function(){
			showMessageInfo(0,0,1,0,$("#username").val());
		});
		$("#save").click(function(){
			saveNode();
		});
		$("#close").click(function(){
			jConfirm('你确定要禁用这个学员吗?', '确认对话框', function(r) {
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
			jConfirm('你确定要解禁这个学员吗?', '确认对话框', function(r) {
				if(r){
					$.get("studentControl.asp?op=setStatus&nodeID=" + $("#studentID").val() + "&status=0&times=" + (new Date().getTime()),function(data){
						jAlert("成功解禁！","信息提示");
						getNodeInfo(nodeID);
						updateCount += 1;
					});
				}
			});
		});
		$("#kindID").change(function(){
			setDeptList($("#companyID").val(),1,$("#kindID").val());
			$("#dept2").empty();
			setDeptList($("#dept1").val(),2,$("#kindID").val());
		});
		$("#companyID").change(function(){
			setDeptList($("#companyID").val(),1,$("#kindID").val());
		});
		$("#dept1").change(function(){
			setDeptList($("#dept1").val(),2,$("#kindID").val());
		});
	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		$.get("studentControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				setDeptList(ar[25],1,ar[5]);
				setDeptList(ar[26],2,ar[5]);
				$("#studentID").val(ar[0]);
				$("#username").val(ar[1]);
				$("#name").val(ar[2]);
				$("#sexName").val(ar[8]);
				$("#age").val(ar[9]);
				$("#mobile").val(ar[7]);
				$("#phone").val(ar[17]);
				$("#email").val(ar[16]);
				$("#kindID").val(ar[5]);
				$("#status").val(ar[3]);
				$("#statusName").val(ar[4]);
				$("#limitDate").val(ar[20]);
				$("#companyID").val(ar[25]);
				$("#dept1").val(ar[26]);				
				$("#dept2").val(ar[27]);
				$("#job").val(ar[18]);
				$("#memo").val(ar[10]);
				$("#regDate").val(ar[11]);
				$("#host").val(ar[29]);
				$("#education").val(ar[30]);
				$("#upload1").html("<a href='javascript:showLoadFile(\"student_photo\",\"" + ar[1] + "\",\"student\",\"\");' style='padding:3px;'>上传</a>");
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
				if(ar[29] !== "spc"){
					$("#kindID").hide();
				}
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		if($("#companyID").val()==""){
			jAlert("请选择公司。");
			return false;
		}
		//alert($("#studentID").val() + "&item=" + ($("#memo").val()));
		$.get("studentControl.asp?op=update&nodeID=" + $("#username").val() + "&name=" + escape($("#name").val()) + "&host=" + $("#host").val() + "&kindID=" + $("#kindID").val() + "&companyID=" + $("#companyID").val() + "&dept1=" + $("#dept1").val() + "&dept2=" + $("#dept2").val() + "&limitDate=" + $("#limitDate").val() + "&mobile=" + escape($("#mobile").val()) + "&phone=" + escape($("#phone").val()) + "&email=" + escape($("#email").val()) + "&job=" + escape($("#job").val()) + "&education=" + escape($("#education").val()) + "&memo=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
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
	
	function setDeptList(pID,n,kind){
		getComList("dept" + n,"deptInfo","deptID","deptName","dept_status=0 and pID=" + pID + " and kindID=" + kind + " order by deptID",1);
	}
	
	function setButton(){
		$("#reply").hide();
		$("#save").hide();
		$("#open").hide();
		$("#close").hide();
		$("#upload1").hide();
		if(checkPermission("messageAdd")){
			$("#reply").show();
		}
		if(checkPermission("studentAdd")){
			$("#open").show();
			$("#close").show();
			$("#save").show();
		}
		if(checkPermission("studentEdit")){
			$("#save").show();
		}
		if(checkPermission("studentPhoto")){
			$("#upload1").show();
		}
		if(checkPermission("studentDel")){
			$("#close").show();
		}
		if($("#status").val()==0){
			$("#open").hide();
		}else{
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
				<td align="right">身份证</td><input type="hidden" id="status" /><input type="hidden" id="host" />
				<td><input class="readOnly" type="text" id="username" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">性别</td>
				<td><input class="readOnly" type="text" id="sexName" size="25" readOnly="true" /></td>
				<td align="right">年龄</td>
				<td><input class="readOnly" type="text" id="age" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">状态</td>
				<td><input class="readOnly" readOnly="true" type="text" id="statusName" size="25" /></td>
				<td align="right">类型</td>
				<td><select id="kindID" style="width:180px;"></select></td>
			</tr>
			<tr>
				<td align="right">公司</td>
				<td><select id="companyID" style="width:180px;"></select></td>
				<td align="right">一级部门</td>
				<td><select id="dept1" style="width:180px;"></select></td>
			</tr>
			<tr>
				<td align="right">二级部门</td>
				<td><select id="dept2" style="width:180px;"></select></td>
				<td align="right">三级部门</td>
				<td><select id="dept3" style="width:180px;"></select></td>
			</tr>
			<tr>
				<td align="right">岗位</td>
				<td><input type="text" id="job" size="25" /></td>
				<td align="right">学历</td>
				<td><select id="education" style="width:180px;"></select></td>
			</tr>
			<tr>
				<td align="right">手机</td>
				<td><input class="mustFill" type="text" id="mobile" size="25" /></td>
				<td align="right">电话</td>
				<td><input type="text" id="phone" size="25" /></td>
			</tr>
			<tr>
				<td align="right">邮箱</td>
				<td><input type="text" id="email" size="25" /></td>
				<td align="right">有效期</td>
				<td><input type="text" id="limitDate" size="25" /></td>
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
					<span id="upload1" style="margin-left:20px;border:1px solid orange;"></span>
					<span id="photo" style="margin-left:20px;"></span>
				</td>
			</tr>
			</table>
			</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
  	<input class="button" type="button" id="save" name="save" value="保存" />&nbsp;
  	<input class="button" type="button" id="open" name="open" value="解禁" />&nbsp;
  	<input class="button" type="button" id="close" name="close" value="禁用" />&nbsp;
  	<input class="button" type="button" id="reply" name="reply" value="发通知" />&nbsp;
  </div>
</div>
</body>
