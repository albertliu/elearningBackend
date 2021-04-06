<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

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
	var replace_item = "";
	var original_item = "";
	var cardJson = "";
	<!--#include file="js/commFunction.js"-->
	<!--#include file="js/EST_reader.js"-->
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
		getNodeInfo(nodeID,"");

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
						getNodeInfo(nodeID,"");
						updateCount += 1;
					});
				}
			});
		});
		$("#username").change(function(){
			if($("#username").val()>""){
				if(checkIDcard($("#username").val())==1){
					var n = studentExist($("#username").val());
					if(n>0){
						jAlert("该身份证已经存在。");
						//已有该身份证记录，则调出原记录，进入编辑状态
						op = 0;
						getNodeInfo(0,$("#username").val());
					}
				}else{
					jAlert("身份证号码有误，请核对。");
				}
			}
		});

		$("#add_img_photo").click(function(){
			showLoadFile("student_photo",$("#username").val(),"student","");
		});
		$("#add_img_cardA").click(function(){
			showLoadFile("student_IDcardA",$("#username").val(),"student","");
		});
		$("#add_img_cardB").click(function(){
			showLoadFile("student_IDcardB",$("#username").val(),"student","");
		});
		$("#add_img_education").click(function(){
			showLoadFile("student_education",$("#username").val(),"student","");
		});
		$("#img_photo").click(function(){
			if($("#img_photo").attr("value")>""){
				window.open($("#img_photo").attr("value"));
			}
		});
		$("#img_cardA").click(function(){
			if($("#img_cardA").attr("value")>""){
				window.open($("#img_cardA").attr("value"));
			}
		});
		$("#img_cardB").click(function(){
			if($("#img_cardB").attr("value")>""){
				window.open($("#img_cardB").attr("value"));
			}
		});
		$("#img_education").click(function(){
			if($("#img_education").attr("value")>""){
				window.open($("#img_education").attr("value"));
			}
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
		if(op==1){
			if($("#companyID").val()>0){
				setDeptList($("#companyID").val(),1,$("#kindID").val());
			}
			if($("#dept1").val()>0){
				setDeptList($("#dept1").val(),2,$("#kindID").val());
			}
		}
	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id,ref){
		$.get("studentControl.asp?op=getNodeInfo&nodeID=" + id + "&refID=" + ref + "&times=" + (new Date().getTime()),function(re){
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
				if(ar[25]>0){
					setDeptList(ar[25],1,ar[5]);
				}
				$("#dept1").val(ar[26]);				
				if(ar[26]>0){
					setDeptList(ar[26],2,ar[5]);
				}
				$("#dept2").val(ar[27]);
				$("#job").val(ar[18]);
				$("#memo").val(ar[10]);
				$("#regDate").val(ar[11]);
				$("#host").val(ar[29]);
				$("#education").val(ar[30]);
				//$("#upload1").html("<a href='javascript:showLoadFile(\"student_education\",\"" + ar[1] + "\",\"student\",\"\");' style='padding:3px;'>上传</a>");
				//<a href='/users" + ar[21] + "' target='_blank'></a>
				arr = [];
				if(ar[21] > ""){
					$("#img_photo").attr("src","/users" + ar[21]);
					$("#img_photo").attr("value","/users" + ar[21]);
				}else{
					$("#img_photo").attr("src","images/blank_photo.png");
					arr.push("," + "photo");
				}
				if(ar[22] > ""){
					$("#img_cardA").attr("src","/users" + ar[22]);
				}else{
					$("#img_cardA").attr("src","images/blank_cardA.png");
					arr.push("," + "cardA");
				}
				if(ar[23] > ""){
					$("#img_cardB").attr("src","/users" + ar[23]);
				}else{
					$("#img_cardB").attr("src","images/blank_cardB.png");
					arr.push("," + "cardB");
				}
				if(ar[24] > ""){
					$("#img_education").attr("src","/users" + ar[24]);
				}else{
					$("#img_education").attr("src","images/blank_education.png");
				}
				//$("#photo").html(c);
				//getDownloadFile("studentID");
				if(ar[29] !== "spc"){
					$("#kindID").hide();
				}
				original_item = arr.join("").substr(1);
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		if(checkIDcard($("#username").val()) > 1){
			jAlert("身份证号码有误，请核对。");
			return false;
		}
		if($("#companyID").val()==""){
			jAlert("请选择公司。");
			return false;
		}
		if($("#mobile").val()==""){
			jAlert("请填写手机。");
			return false;
		}
		if($("#name").val()==""){
			jAlert("请填写姓名。");
			return false;
		}
		var k = 0;
		if(op==0){k=1;}
		//alert("nodeID=" + $("#username").val() + "&name=" + ($("#name").val()) + "&keyID=" + k + "&host=" + $("#host").val() + "&kindID=" + $("#kindID").val() + "&companyID=" + $("#companyID").val() + "&dept1=" + $("#dept1").val() + "&dept2=" + $("#dept2").val() + "&limitDate=" + $("#limitDate").val() + "&mobile=" + ($("#mobile").val()) + "&phone=" + ($("#phone").val()) + "&email=" + ($("#email").val()) + "&job=" + ($("#job").val()) + "&education=" + ($("#education").val()) + "&memo=" + ($("#memo").val()));
		$.get("studentControl.asp?op=update&nodeID=" + $("#username").val() + "&name=" + escape($("#name").val()) + "&keyID=" + k + "&host=" + $("#host").val() + "&kindID=" + $("#kindID").val() + "&companyID=" + $("#companyID").val() + "&dept1=" + $("#dept1").val() + "&dept2=" + $("#dept2").val() + "&limitDate=" + $("#limitDate").val() + "&mobile=" + escape($("#mobile").val()) + "&phone=" + escape($("#phone").val()) + "&email=" + escape($("#email").val()) + "&job=" + escape($("#job").val()) + "&education=" + $("#education").val() + "&memo=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				jAlert("保存成功！","信息提示");
				updateCount += 1;
				op = 0;
			}
		});
		if(replace_item > ""){
			//上传被替换的图片
			//替换原来的图片资料
			var ar = new Array();
			ar = replace_item.split(",");
			$.each(ar,function(iNum,val){
				if(val=="photo"){
					//替换照片
					$.post(uploadURL + "/outfiles/uploadBase64img",{upID:"student_photo",username:$("#username").val(),currUser:currUser,imgData:cardJson.base64Data},function(re){
						//alert(re.status);
					});
				}
				if(val=="cardA"){
					//替换身份证正面
					$.post(uploadURL + "/outfiles/uploadBase64img",{upID:"student_IDcardA",username:$("#username").val(),currUser:currUser,imgData:cardJson.imageFront},function(re){
						//alert(re.status);
					});
				}
				if(val=="cardB"){
					//替换身份证反面
					$.post(uploadURL + "/outfiles/uploadBase64img",{upID:"student_IDcardB",username:$("#username").val(),currUser:currUser,imgData:cardJson.imageBack},function(re){
						//alert(re.status);
					});
				}
			});
		}
		return false;
	}
	
	function setDeptList(pID,n,kind){
		getComList("dept" + n,"deptInfo","deptID","deptName","dept_status=0 and pID=" + pID + " and kindID=" + kind + " order by deptID",1);
	}
	
	function setButton(){
		$("#reply").hide();
		$("#add").hide();
		$("#save").hide();
		$("#open").hide();
		$("#close").hide();
		$("#upload1").hide();
		$("#username").prop("disabled",true);
		if(op==1){
			$("#save").show();
			$("#add_img_education").hide();
			$("#username").prop("disabled",false);
			setEmpty();
		}else{
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
	}
	
	function setEmpty(){
		$("#studentID").val(0);
		$("#username").val("");
		$("#name").val("");
		$("#sexName").val("");
		$("#age").val("");
		$("#mobile").val("");
		$("#phone").val("");
		$("#email").val("");
		$("#kindID").val(0);
		$("#limitDate").val("");
		//$("#companyID").val();
		//$("#dept1").val(ar[26]);				
		//$("#dept2").val(ar[27]);
		//$("#job").val(ar[18]);
		$("#memo").val("");
		$("#regDate").val(currDate);
		//$("#host").val();
		$("#education").val(0);
	}

	function dealResponse(re){
		var k = 0;
		var n = studentExist(re.certNo);
		cardJson = re;
		if(re.expire<currDate.replace("-","")){
			alert("该身份证已过有效期。");
		}
		if(k==0 && op==0 && re.certNo != $("#username").val()){
			//编辑状态，如果是新的身份证，则自动定位到身份证之人，并进入编辑状态。
			k = 1;
			if(n>0){
				//已有该身份证记录，则调出原记录，进入编辑状态
				getNodeInfo(0,re.certNo);
				//弹出窗口，可选择覆盖原来的照片、身份证图片
				//替换原来的图片资料
				showUseCardInfo();
			}else{
				op = 1;
				setButton();
				//填充文字
				$("#studentID").val(0);
				$("#username").val(re.certNo);
				$("#name").val(re.name);
				$("#sexName").val(re.sex);

				//填充全部图片
				replaceImgFromCard("photo,cardA,cardB");
			}
		}
		if(k==0 && op==0 && re.certNo == $("#username").val()){
			//编辑状态，如果是当前的身份证，则比较其信息
			if(re.name != $("#name").val()){
				//校验姓名
				alert("姓名与身份证信息不符，请核对。");
			}
			//弹出窗口，可选择覆盖原来的照片、身份证图片
			//替换原来的图片资料
			showUseCardInfo();
			k = 1;
		}
		if(k==0 && op==1){
			//添加状态，先检查是否有该身份证的记录。
			k = 1;
			if(n>0){
				//已有该身份证记录，则调出原记录，进入编辑状态
				op = 0;
				getNodeInfo(0,re.certNo);
				//弹出窗口，可选择覆盖原来的照片、身份证图片
				//替换原来的图片资料
				showUseCardInfo();
			}else{
				//填充文字
				$("#studentID").val(0);
				$("#username").val(re.certNo);
				$("#name").val(re.name);
				$("#sexName").val(re.sex);

				//填充全部图片
				replaceImgFromCard("photo,cardA,cardB");
			}
		}
	}
	
	function replaceImgFromCard(item){
		replace_item = item;
		//替换原来的图片资料
		var ar = new Array();
		ar = item.split(",");
		$.each(ar,function(iNum,val){
			if(val=="photo"){
				//替换照片
				$("#img_photo").attr("src","data:image/jpeg;base64,"+cardJson.base64Data);
			}
			if(val=="cardA"){
				//替换身份证正面
				$("#img_cardA").attr("src","data:image/jpeg;base64,"+cardJson.imageFront);
			}
			if(val=="cardB"){
				//替换身份证反面
				$("#img_cardB").attr("src","data:image/jpeg;base64,"+cardJson.imageBack);
			}
		});
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
	<div style="float:left;width:70%;">
	<div style="width:100%;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8; float:left;width:100%;">
			<form id="detailCover" name="detailCover" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
			<table style="width:100%;">
			<tr>
				<td align="right">身份证</td><input type="hidden" id="status" /><input type="hidden" id="host" />
				<td><input type="text" id="username" size="25" /></td>
				<td align="right">姓名</td><input type="hidden" id="studentID" />
				<td><input class="mustFill" type="text" id="name" size="25" /></td>
			</tr>
			<tr>
				<td align="right">性别</td>
				<td><input class="readOnly" type="text" id="sexName" size="25" readOnly="true" /></td>
				<td align="right">年龄</td>
				<td><input class="readOnly" readOnly="true" type="text" id="age" size="25" /></td>
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
				<td colspan="5"><input type="text" id="memo" style="width:95%;" /></td>
			</tr>
			<tr>
				<td align="right">注册日期</td>
				<td><input class="readOnly" type="text" id="regDate" size="25" readOnly="true" /></td>
				<td align="right">其他资料</td>
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
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;clear:both;">
		<input class="button" type="button" id="add" value="添加" />&nbsp;
		<input class="button" type="button" id="save" value="保存" />&nbsp;
		<input class="button" type="button" id="open" value="解禁" />&nbsp;
		<input class="button" type="button" id="close" value="禁用" />&nbsp;
		<input class="button" type="button" id="reply" value="发通知" />&nbsp;
  	</div>
</div>
<div style="padding: 5px;text-align:center;overflow:hidden;margin:0 auto;flot:right;">
	<table style="width:99%;">
	<tr>
		<td align="right" style="width:15%;"><img id="add_img_photo" src="images/plus.png" /></td>
		<td align="center" style="width:85%;">
			<img id="img_photo" src="" value="" style='width:100px;background: #ccc;border:1px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);opacity: 0.8;' />
		</td>
	</tr>
	<tr>
		<td align="right" style="width:15%;"><img id="add_img_cardA" src="images/plus.png" /></td>
		<td style="width:85%;">
			<img id="img_cardA" src="" style='width:150px;background: #ccc;border:1px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);opacity: 0.8;' />
		</td>
	</tr>
	<tr>
		<td align="right" style="width:15%;"><img id="add_img_cardB" src="images/plus.png" /></td>
		<td style="width:85%;">
			<img id="img_cardB" src="" style='width:150px;background: #ccc;border:1px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);opacity: 0.8;' />
		</td>
	</tr>
	<tr>
		<td align="right" style="width:15%;"><img id="add_img_education" src="images/plus.png" /></td>
		<td style="width:85%;">
			<img id="img_education" src="" style='width:150px;background: #ccc;border:1px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);opacity: 0.8;' />
		</td>
	</tr>
	<tr>
		<td align="left" colspan="2" style="width:100%;"><textarea id="text_reader_result" style="padding:5px;width:100%;background: #fcfcfc;border:solid 1px #ccc;" rows="2"></textarea></td>
	</tr>
	</table>
</div>
</div>
</body>
