<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title></title>

<link href="css/style_inner1.css?v=1.3"  rel="stylesheet" type="text/css" />
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
	var refID = "";
	var op = 0;
	var updateCount = 0;
	var username = "";
	var replace_item = "";
	var original_item = "";
	var cardJson = "";
	var fromCard = 0;
	<!--#include file="js/commFunction.js"-->
	<!--#include file="js/EST_reader.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		refID = "<%=refID%>";	//username
		op = "<%=op%>";
		$.ajaxSetup({ 
			async: false 
		}); 
		getDicList("student","kindID",0);
		getDicList("statusJob","job_status",0);
		getDicList("education","education",1);
		var w = "dept_status=0 and pID=0 and host='" + currHost + "'";
		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("companyID","deptInfo","deptID","deptName","dept_status=0 and pID=0 order by deptID",0);
		}else{
			getComList("companyID","deptInfo","deptID","deptName",w,0);
		}
		//setButton();
		if(op==0){
			getNodeInfo(nodeID,refID);
		}

		$("#add").click(function(){
			op = 1;
			setButton();
		});
		$("#reply").click(function(){
			showMessageInfo(0,0,1,0,$("#username").val());
		});
		$("#enter").click(function(){
			showEnterInfo(0,$("#username").val(),1,1,$("#companyID").val(),0);
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
				$("#username").val($("#username").val().toUpperCase());
				if(checkIDcard($("#username").val())==1){
					var n = studentExist($("#username").val());
					if(n>0){
						jAlert("该身份证已经存在。");
						//已有该身份证记录，则调出原记录，进入编辑状态
						op = 0;
						getNodeInfo(0,$("#username").val());
					}
					replace_item = "";
					setDeptFromRefInfo();
				}else{
					jAlert("身份证号码有误，请核对。");
				}
			}
		});

		$("#add_img_photo").click(function(){
			showLoadFile("student_photo",$("#username").val(),"student",$("#host").val());
		});
		$("#add_img_cardA").click(function(){
			showLoadFile("student_IDcardA",$("#username").val(),"student",$("#host").val());
		});
		$("#add_img_cardB").click(function(){
			showLoadFile("student_IDcardB",$("#username").val(),"student",$("#host").val());
		});
		$("#add_img_education").click(function(){
			showLoadFile("student_education",$("#username").val(),"student",$("#host").val());
		});
		$("#add_img_CHESICC").click(function(){
			showLoadFile("student_CHESICC",$("#username").val(),"student",$("#host").val());
			getNodeInfo(nodeID,refID);
		});
		$("#add_img_employment").click(function(){
			showLoadFile("student_employment",$("#username").val(),"student",$("#host").val());
			getNodeInfo(nodeID,refID);
		});
		$("#add_img_jobCertificate").click(function(){
			showLoadFile("student_jobCertificate",$("#username").val(),"student",$("#host").val());
			getNodeInfo(nodeID,refID);
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
		$("#img_CHESICC").click(function(){
			if($("#img_CHESICC").attr("value")>""){
				window.open($("#img_CHESICC").attr("value"));
			}
		});
		$("#img_employment").click(function(){
			if($("#img_employment").attr("value")>""){
				window.open($("#img_employment").attr("value"));
			}
		});
		$("#img_jobCertificate").click(function(){
			if($("#img_jobCertificate").attr("value")>""){
				window.open($("#img_jobCertificate").attr("value"));
			}
		});
		$("#kindID").change(function(){
			setDeptList($("#companyID").val(),1,$("#kindID").val());
			$("#dept2").empty();
			setDeptList($("#dept1").val(),2,$("#kindID").val());
		});
		$("#companyID").change(function(){
			setZNXF();
			setDeptList($("#companyID").val(),1,$("#kindID").val());
		});
		$("#dept1").change(function(){
			setDeptList($("#dept1").val(),2,$("#kindID").val());
		});
		if(op==1){
			setButton();
			if($("#companyID").val()>0){
				setDeptList($("#companyID").val(),1,$("#kindID").val());
			}
			$("#dept1").val(getSession("lastdept1"));
			if($("#dept1").val()>0){
				setDeptList($("#dept1").val(),2,$("#kindID").val());
			}
		}
		/*
		var imgArr = $("#xx").find("img");
		//alert(imgArr.length);
		$.each(imgArr,function(){
			var img = $(this);
			alert(img.parent().width());
		});*/

	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id,ref){
		$.get("studentControl.asp?op=getNodeInfo&nodeID=" + id + "&refID=" + ref + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
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
				$("#job_status").val(ar[32]);
				$("#address").val(ar[34]);
				$("#unit").val(ar[35]);
				$("#dept").val(ar[36]);
				$("#ethnicity").val(ar[37]);
				$("#IDaddress").val(ar[38]);
				$("#bureau").val(ar[39]);
				$("#IDdateStart").val(ar[40]);
				$("#IDdateEnd").val(ar[41]);
				$("#experience").val(ar[42]);
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
					$("#img_cardA").attr("value","/users" + ar[22]);
				}else{
					$("#img_cardA").attr("src","images/blank_cardA.png");
					arr.push("," + "cardA");
				}
				if(ar[23] > ""){
					$("#img_cardB").attr("src","/users" + ar[23]);
					$("#img_cardB").attr("value","/users" + ar[23]);
				}else{
					$("#img_cardB").attr("src","images/blank_cardB.png");
					arr.push("," + "cardB");
				}
				if(ar[24] > ""){
					$("#img_education").attr("src","/users" + ar[24]);
					$("#img_education").attr("value","/users" + ar[24]);
				}else{
					$("#img_education").attr("src","images/blank_education.png");
				}
				if(ar[43] > ""){
					$("#img_CHESICC").attr("src","/users" + ar[43]);
					$("#img_CHESICC").attr("value","/users" + ar[43]);
				}else{
					$("#img_CHESICC").attr("src","images/blank_CHESICC.png");
				}
				if(ar[44] > ""){
					$("#img_employment").attr("src","/users" + ar[44]);
					$("#img_employment").attr("value","/users" + ar[44]);
				}else{
					$("#img_employment").attr("src","images/blank_employment.png");
				}
				if(ar[45] > ""){
					$("#img_jobCertificate").attr("src","/users" + ar[45]);
					$("#img_jobCertificate").attr("value","/users" + ar[45]);
				}else{
					$("#img_jobCertificate").attr("src","images/blank_jobCertificate.png");
				}
				//$("#photo").html(c);
				//getDownloadFile("studentID");
				if(ar[29] !== "spc"){
					$("#kindID").hide();
				}
				original_item = arr.join("").substr(1);
				getStudentCourseList(ar[1]);
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				op = 1;
				setButton();
			}
		});
	}
	
	function saveNode(){
		if(checkIDcard($("#username").val()) > 1){
			jAlert("身份证号码有误，请核对。");
			return false;
		}
		if($("#companyID").val()==""){
			jAlert("请选择来源。");
			return false;
		}
		if($("#mobile").val() !="" && $("#mobile").val().length != 11){
			jAlert("请正确填写手机。");
			return false;
		}
		if($("#name").val()==""){
			jAlert("请填写姓名。");
			return false;
		}
		var k = 0;
		if(op==0){k=1;}
		//alert("nodeID=" + $("#username").val() + "&name=" + ($("#name").val()) + "&keyID=" + k + "&host=" + $("#host").val() + "&kindID=" + $("#kindID").val() + "&companyID=" + $("#companyID").val() + "&dept1=" + $("#dept1").val() + "&dept2=" + $("#dept2").val() + "&limitDate=" + $("#limitDate").val() + "&mobile=" + ($("#mobile").val()) + "&phone=" + ($("#phone").val()) + "&email=" + ($("#email").val()) + "&job=" + ($("#job").val()) + "&education=" + ($("#education").val()) + "&memo=" + ($("#memo").val()));
		$.get("studentControl.asp?op=update&nodeID=" + $("#username").val() + "&name=" + escape($("#name").val()) + "&unit=" + escape($("#unit").val()) + "&dept=" + escape($("#dept").val()) + "&ethnicity=" + escape($("#ethnicity").val()) + "&IDaddress=" + escape($("#IDaddress").val()) + "&bureau=" + escape($("#bureau").val()) + "&IDdateStart=" + $("#IDdateStart").val() + "&IDdateEnd=" + $("#IDdateEnd").val() + "&experience=" + escape($("#experience").val()) + "&keyID=" + k + "&host=" + $("#host").val() + "&kindID=" + $("#kindID").val() + "&companyID=" + $("#companyID").val() + "&dept1=" + $("#dept1").val() + "&dept2=" + $("#dept2").val() + "&job_status=" + $("#job_status").val() + "&limitDate=" + $("#limitDate").val() + "&mobile=" + escape($("#mobile").val()) + "&phone=" + escape($("#phone").val()) + "&email=" + escape($("#email").val()) + "&address=" + escape($("#address").val()) + "&job=" + escape($("#job").val()) + "&education=" + $("#education").val() + "&memo=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				updateCount += 1;
				var i = op;
				op = 0;
				getNodeInfo(0,$("#username").val());
				if(i==1){
					//新学员保存后直接进入报名页面
					showEnterInfo(0,$("#username").val(),1,1,$("#companyID").val(),0);
				}else{
					if(fromCard==0){
						jAlert("保存成功！","信息提示");
					}
					fromCard = 0;
					$("#enter").focus();
				}
			}
			setSession("lastcompany", $("#companyID").val());
			setSession("lastdept1", $("#dept1").val());
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
		$("#enter").focus();
		return false;
	}
	
	function setDeptList(pID,n,kind){
		if(pID>0){
			getComList("dept" + n,"deptInfo","deptID","deptName","dept_status=0 and pID=" + pID + " and kindID=" + kind + " order by deptName",1);
		}else{
			$("#dept" + n).empty();
		}
	}

	function getStudentCourseList(id){
		//alert(id);
		$.get("studentCourseControl.asp?op=getStudentCourseList&mark=1&keyID=" + id,function(data1){
			//alert(unescape(data1));
			var ar = new Array();
			var arr1 = new Array();
			ar = unescape(data1).split("%%");
			ar.shift();
			ar.shift();
			arr1.push("<table class='table_help' width='100%'>");
			arr1.push("<tr align='center' bgcolor='#e0e0e0'>");
			arr1.push("<td width='25%'>课程</td><td width='12%'>批次</td><td width='15%'>班级</td><td width='10%'>学号</td><td width='10%'>材料</td><td width='10%'>缴费</td><td width='10%'>状态</td>");
			arr1.push("</tr>");
			var imgChk = "<img src='images/green_check.png'>";
			if(ar > ""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					var c = "";
					if(ar1[44]==1){
						c = imgChk;
					}
					arr1.push("<tr>");
					arr1.push("<td><a href='javascript:showEnterInfo(" + ar1[0] + ",\"" + $("#username").val() + "\",0,1,0);'>" + ar1[6] + "</a></td><td>" + ar1[41] + "</td><td>" + ar1[42] + "</td><td>" + ar1[43] + "</td><td>" + c + "</td><td>" + ar1[50] + "</td><td>" + ar1[4] + "</td>");
					arr1.push("</tr>");
				});
			}
			arr1.push("</table>");
			$("#enterCover").html(arr1.join(""));
		});
	}
	
	function setButton(){
		$("#reply").hide();
		$("#add").hide();
		$("#save").hide();
		$("#open").hide();
		$("#close").hide();
		$("#upload1").hide();
		$("#enter").hide();
		$("#username").prop("disabled",true);
		$("*[tag='plus'").hide();
		if(op==1){
			$("#save").show();
			$("#add_img_education").hide();
			$("#username").prop("disabled",false);
			setEmpty();
			//$("#save").focus();
		}else{
			if(checkPermission("messageAdd")){
				$("#reply").show();
			}
			if(checkPermission("studentAdd")){
				$("#open").show();
				$("#close").show();
				$("#save").show();
				$("#enter").show();
				$("#add").show();
			}
			if(checkPermission("studentEdit")){
				$("#save").show();
			}
			if(checkPermission("studentPhoto")){
				$("#upload1").show();
				$("*[tag='plus'").show();
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
		setZNXF();
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
		$("#address").val("");
		$("#experience").val("");
		$("#ethnicity").val("汉");
		$("#IDaddress").val("");
		$("#bureau").val("");
		$("#IDdateStart").val("");
		$("#IDdateEnd").val("");
		$("#companyID").val(getSession("lastcompany"));
		setZNXF();
		setDeptList($("#companyID").val(),1,$("#kindID").val());
		//$("#dept1").val(ar[26]);				
		//$("#dept2").val(ar[27]);
		$("#job_status").val(1);	//默认就业
		$("#memo").val("");
		$("#regDate").val(currDate);
		//$("#host").val();
		$("#education").val(0);
		$("#enterCover").empty();
		$("#img_photo").attr("src","");
		$("#img_cardA").attr("src","");
		$("#img_cardB").attr("src","");
		$("#img_education").attr("src","");
	}

	function setZNXF(){
		$("#kindID").hide();
		if($("#companyID").val()==46){
			$("#kindID").val(0);
			$("#spc_dept").hide();
			$("#dept3").hide();
			$("#znxf_dept").show();
		}else{
			$("#spc_dept").show();
			$("#znxf_dept").hide();
			$("#dept3").show();
		}
		if($("#companyID").val()==8){
			$("#kindID").show();
		}
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
				checkName(re.name);
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
			checkName(re.name);
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
				checkName(re.name);
				//if(re.name != $("#name").val()){
					//校验姓名
				//	alert("姓名与身份证信息不符，请核对。");
				//}
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
		setDeptFromRefInfo();	//读取预报名表信息

		//填充身份证信息
		$("#ethnicity").val(re.nation);
		$("#IDaddress").val(re.address);
		$("#bureau").val(re.department);
		$("#IDdateStart").val(re.effectData);
		$("#IDdateEnd").val(re.expire);
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
		if(op==1){
			$("#save").focus();
		}
	}
	
	function checkName(cname){
		if(cname != $("#name").val()){
			//校验姓名
			alert("当前姓名[" + $("#name").val() + "]与身份证信息不符，已更正。");
			$("#name").val(cname);
		}
	}
	
	function setDeptFromRefInfo(){
		//检查参考数据，更新一级、二级部门
		//alert($("#username").val());
		$.get("studentControl.asp?op=getDeptRefrence&nodeID=" + $("#username").val(),function(re){
			//alert(re);
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				if(ar[0] > 0){
					$("#companyID").val(ar[0]);
					setDeptList(ar[0],1,0);
				}
				if(ar[1] > 0){
					$("#dept1").val(ar[1]);
					setDeptList(ar[1],2,0);
				}
				$("#dept2").val(ar[2]);
				if(ar[3]>''){
					$("#mobile").val(ar[3]);
				}
				if(ar[4]>0){
					$("#education").val(ar[4]);
				}
				if(ar[5]>''){
					$("#job").val(ar[5]);
				}
				if(ar[6]>''){
					$("#memo").val(ar[6]);
				}
				setZNXF();
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
			<input type="hidden" id="ethnicity" /><input type="hidden" id="IDaddress" /><input type="hidden" id="bureau" />
			<input type="hidden" id="IDdateStart" /><input type="hidden" id="IDdateEnd" /><input type="hidden" id="experience" />
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
				<td align="right">学历</td>
				<td><select id="education" style="width:180px;"></select></td>
			</tr>
			<tr>
				<td align="right">来源</td>
				<td><select id="companyID" style="width:180px;"></select></td>
				<td align="right">类型</td>
				<td><select id="kindID" style="width:180px;"></select></td>
			</tr>
			<tr id="spc_dept">
				<td align="right">一级部门</td>
				<td><select id="dept1" style="width:180px;"></select></td>
				<td align="right">二级部门</td>
				<td><select id="dept2" style="width:180px;"></select></td>
			</tr>
			<tr id="znxf_dept">
				<td align="right">单位</td>
				<td><input type="text" id="unit" size="25" /></td>
				<td align="right">部门</td>
				<td><input type="text" id="dept" size="25" /></td>
			</tr>
			<tr>
				<td align="right">三级部门</td>
				<td><select id="dept3" style="width:180px;"></select></td>
				<td align="right">岗位</td>
				<td><input type="text" id="job" size="25" /></td>
			</tr>
			<tr>
				<td align="right">手机</td>
				<td><input class="mustFill" type="text" id="mobile" size="25" /></td>
				<td align="right">邮箱</td>
				<td><input type="text" id="email" size="25" /></td>
			</tr>
			<tr>
				<td align="right">联系地址</td>
				<td><input type="text" id="address" size="25" /></td>
				<td align="right">单位电话</td>
				<td><input type="text" id="phone" size="25" /></td>
			</tr>
			<tr>
				<td align="right">就业状态</td>
				<td><select id="job_status" style="width:180px;"></select></td>
				<td align="right">有效期</td>
				<td><input type="text" id="limitDate" size="25" /></td>
			</tr>
			<tr>
				<td align="right">备注</td>
				<td colspan="3"><input type="text" id="memo" style="width:95%;" /></td>
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

	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fcfcfc;clear:both;">
		<input class="button" type="button" id="enter" value="去报名" />&nbsp;
  	</div>
	<hr size="1" noshadow />
	<div id='enterCover'></div>
</div>
<div style="padding: 5px;text-align:center;overflow:hidden;margin:0 auto;flot:right;background: #eeeeff;" id="xx">
	<table style="width:99%;">
	<tr>
		<td align="right" style="width:15%;"><img id="add_img_photo" src="images/plus.png" tag="plus" /></td>
		<td align="center" style="width:85%;">
			<img id="img_photo" src="" value="" style='width:100px;border:none;' />
		</td>
	</tr>
	<tr>
		<td align="right" style="width:15%;"><img id="add_img_cardA" src="images/plus.png" tag="plus" /></td>
		<td style="width:85%;">
			<img id="img_cardA" src="" value="" style='width:150px;border:none;' />
		</td>
	</tr>
	<tr>
		<td align="right" style="width:15%;"><img id="add_img_cardB" src="images/plus.png" tag="plus" /></td>
		<td style="width:85%;">
			<img id="img_cardB" src="" value="" style='width:150px;border:none;' />
		</td>
	</tr>
	<tr>
		<td align="right" style="width:15%;"><img id="add_img_education" src="images/plus.png" tag="plus" /></td>
		<td style="width:85%;">
			<img id="img_education" src="" value="" style='width:150px;border:none;' />
		</td>
	</tr>
	<tr>
		<td align="right" style="width:15%;"><img id="add_img_CHESICC" src="images/plus.png" tag="plus" /></td>
		<td style="width:85%;">
			<img id="img_CHESICC" src="" value="" style='width:150px;border:none;' />
		</td>
	</tr>
	<tr>
		<td align="right" style="width:15%;"><img id="add_img_employment" src="images/plus.png" tag="plus" /></td>
		<td style="width:85%;">
			<img id="img_employment" src="" value="" style='width:150px;border:none;' />
		</td>
	</tr>
	<tr>
		<td align="right" style="width:15%;"><img id="add_img_jobCertificate" src="images/plus.png" tag="plus" /></td>
		<td style="width:85%;">
			<img id="img_jobCertificate" src="" value="" style='width:150px;border:none;' />
		</td>
	</tr>
	<tr>
		<td align="left" colspan="2" style="width:100%;"><textarea id="text_reader_result" style="padding:5px;width:90%;background: #eeeeee;border:solid 1px #ccc;color:#ff0000;" rows="2"></textarea></td>
	</tr>
	</table>
</div>
</div>
</body>
