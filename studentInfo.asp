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
<script language="javascript" src="js/jquery-2.1.1.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
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
	let scanPhoto = 0;
	let hasPhoto = 0;
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
		getDicList("sex","sex",0);
        getComList("fromID","userInfo","username","realName","status=0 and username in(select username from roleUserList where roleID='saler') order by realName",1);
		$("#IDdateStart").click(function(){WdatePicker();});
		$("#IDdateEnd").click(function(){WdatePicker();});
		$("#birthday").click(function(){WdatePicker();});

		var w = "dept_status=0 and pID=0 and host='" + currHost + "'";
		if(currHost==""){
			getComList("companyID","deptInfo","deptID","deptName","dept_status=0 and pID=0 order by deptID",0);
		}else{
			if(checkRole("partner")){
				getComList("companyID","deptInfo","deptID","deptName","deptID=46",0);	//合作单位以消防学校名义招生
			}else{
				getComList("companyID","deptInfo","deptID","deptName",w,0);
			}
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
		$("#smsList").click(function(){
			showStudentSmsList($("#username").val(),0,0,1);
		});
		$("#examList").click(function(){
			showStudentExamList($("#username").val(),$("#name").val(),0,1);
		});
		$("#opList").click(function(){
			showStudentOpList($("#username").val(),1,0,1);
		});
		$("#save").click(function(){
			fromCard = 0;
			saveNode();
		});
		$("#close").click(function(){
			$.messager.confirm('确认对话框', '你确定要禁用这个学员吗?', function(r) {
				if(r){
					$.get("studentControl.asp?op=setStatus&nodeID=" + $("#studentID").val() + "&status=1&times=" + (new Date().getTime()),function(data){
						$.messager.alert("信息提示","成功禁用！");
						getNodeInfo(nodeID);
						updateCount += 1;
					});
				}
			});
		});
		$("#open").click(function(){
			$.messager.confirm('确认对话框', '你确定要解禁这个学员吗?', function(r) {
				if(r){
					$.get("studentControl.asp?op=setStatus&nodeID=" + $("#studentID").val() + "&status=0&times=" + (new Date().getTime()),function(data){
						$.messager.alert("信息提示","成功解禁！");
						getNodeInfo(nodeID,"");
						updateCount += 1;
					});
				}
			});
		});
		$("#reset").click(function(){
			$.messager.confirm('确认对话框', '你确定要重置密码吗?', function(r) {
				if(r){
					$.get("studentControl.asp?op=reset&nodeID=" + $("#studentID").val() + "&times=" + (new Date().getTime()),function(data){
						$.messager.alert("信息提示","重置完成，当前密码为123456");
					});
				}
			});
		});
		$("#username").change(function(){
			if($("#username").val()>""){
				$("#username").val($("#username").val().toUpperCase());
				if(!$("#Tai").prop("checked")){
					if(checkIDcard($("#username").val())==1){
						var n = studentExist($("#username").val());
						if(n>0){
							alert("该身份证已经存在。");
							//已有该身份证记录，则调出原记录，进入编辑状态
							op = 0;
							getNodeInfo(0,$("#username").val());
						}
						replace_item = "";
						setDeptFromRefInfo();
					}else{
						alert("身份证号码有误，请核对。");
					}
				}
			}
		});

		$("#Tai").change(function(){
			if(!$("#Tai").prop("checked")){
				//普通身份证
				$("#sex").prop("disabled",true);
				$("#birthday").prop("disabled",true);
			}else{
				//台胞证
				$("#sex").prop("disabled",false);
				$("#birthday").prop("disabled",false);
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
		$("#add_img_promise").click(function(){
			showLoadFile("student_promise",$("#username").val(),"student",$("#host").val());
			getNodeInfo(nodeID,refID);
		});
		$("#add_img_social").click(function(){
			showLoadFile("student_social",$("#username").val(),"student",$("#host").val());
			getNodeInfo(nodeID,refID);
		});
		$("#img_photo").click(function(){
			if($("#img_photo").attr("value")>""){
				//window.open($("#img_photo").attr("value"));
				showCropperInfo($("#img_photo").attr("value"),$("#username").val(),"photo","img_photo",0,1);
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
		$("#img_promise").click(function(){
			if($("#img_promise").attr("value")>""){
				window.open($("#img_promise").attr("value"));
			}
		});
		$("#img_social").click(function(){
			if($("#img_social").attr("value")>""){
				window.open($("#img_social").attr("value"));
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
		
		// setDraggable();
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
				$("#sex").val(ar[48]);
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
				$("#birthday").val(ar[33]);
				$("#address").val(ar[34]);
				$("#unit").val(ar[35]);
				$("#dept").val(ar[36]);
				$("#ethnicity").val(ar[37]);
				$("#IDaddress").val(ar[38]);
				$("#bureau").val(ar[39]);
				$("#IDdateStart").val(ar[40]);
				$("#IDdateEnd").val(ar[41]);
				$("#experience").val(ar[42]);
				$("#linker").val(ar[46]);
				$("#fromID").val(ar[47]);
				if(ar[53]==1){
					$("#scanPhoto").checkbox({checked:true});
					scanPhoto = 1;
				}else{
					$("#scanPhoto").checkbox({checked:false});
					scanPhoto = 0;
				}
				//$("#upload1").html("<a href='javascript:showLoadFile(\"student_education\",\"" + ar[1] + "\",\"student\",\"\");' style='padding:3px;'>上传</a>");
				//<a href='/users" + ar[21] + "' target='_blank'></a>
				arr = [];
				if(ar[21] > ""){
					$("#img_photo").attr("src","/users" + ar[21] + "?times=" + (new Date().getTime()));
					$("#img_photo").attr("value","/users" + ar[21] + "?times=" + (new Date().getTime()));
					hasPhoto = 1;
				}else{
					$("#img_photo").attr("src","images/blank_photo.png" + "?times=" + (new Date().getTime()));
					arr.push("," + "photo");
					hasPhoto = 0;
				}
				if(ar[22] > ""){
					$("#img_cardA").attr("src","/users" + ar[22] + "?times=" + (new Date().getTime()));
					$("#img_cardA").attr("value","/users" + ar[22] + "?times=" + (new Date().getTime()));
				}else{
					$("#img_cardA").attr("src","images/blank_cardA.png" + "?times=" + (new Date().getTime()));
					arr.push("," + "cardA");
				}
				if(ar[23] > ""){
					$("#img_cardB").attr("src","/users" + ar[23] + "?times=" + (new Date().getTime()));
					$("#img_cardB").attr("value","/users" + ar[23] + "?times=" + (new Date().getTime()));
				}else{
					$("#img_cardB").attr("src","images/blank_cardB.png" + "?times=" + (new Date().getTime()));
					arr.push("," + "cardB");
				}
				if(ar[24] > ""){
					$("#img_education").attr("src","/users" + ar[24] + "?times=" + (new Date().getTime()));
					$("#img_education").attr("value","/users" + ar[24] + "?times=" + (new Date().getTime()));
				}else{
					$("#img_education").attr("src","images/blank_education.png" + "?times=" + (new Date().getTime()));
				}
				if(ar[43] > ""){
					$("#img_CHESICC").attr("src","/users" + ar[43] + "?times=" + (new Date().getTime()));
					$("#img_CHESICC").attr("value","/users" + ar[43] + "?times=" + (new Date().getTime()));
				}else{
					$("#img_CHESICC").attr("src","images/blank_CHESICC.png" + "?times=" + (new Date().getTime()));
				}
				if(ar[44] > ""){
					$("#img_employment").attr("src","/users" + ar[44] + "?times=" + (new Date().getTime()));
					$("#img_employment").attr("value","/users" + ar[44] + "?times=" + (new Date().getTime()));
				}else{
					$("#img_employment").attr("src","images/blank_employment.png" + "?times=" + (new Date().getTime()));
				}
				if(ar[45] > ""){
					$("#img_jobCertificate").attr("src","/users" + ar[45] + "?times=" + (new Date().getTime()));
					$("#img_jobCertificate").attr("value","/users" + ar[45] + "?times=" + (new Date().getTime()));
				}else{
					$("#img_jobCertificate").attr("src","images/blank_jobCertificate.png" + "?times=" + (new Date().getTime()));
				}
				if(ar[50] > ""){
					$("#img_promise").attr("src","/users" + ar[50] + "?times=" + (new Date().getTime()));
					$("#img_promise").attr("value","/users" + ar[50] + "?times=" + (new Date().getTime()));
				}else{
					$("#img_promise").attr("src","images/blank_promise.png" + "?times=" + (new Date().getTime()));
				}
				if(ar[51] > ""){
					$("#img_social").attr("src","/users" + ar[51] + "?times=" + (new Date().getTime()));
					$("#img_social").attr("value","/users" + ar[51] + "?times=" + (new Date().getTime()));
				}else{
					$("#img_social").attr("src","images/blank_social.png" + "?times=" + (new Date().getTime()));
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
				alert("该信息未找到！","信息提示");
				op = 1;
				setButton();
			}
		});
	}
	
	function saveNode(){
		if(!$("#Tai").prop("checked") && checkIDcard($("#username").val()) > 1){
			alert("身份证号码有误，请核对。");
			return false;
		}
		if($("#username").val()==""){
			alert("请填写证件号码。");
			return false;
		}
		if($("#companyID").val()==""){
			alert("请选择来源。");
			return false;
		}
		if($("#mobile").val() !="" && $("#mobile").val().length != 11){
			alert("请正确填写手机。");
			return false;
		}
		if($("#name").val()==""){
			alert("请填写姓名。");
			return false;
		}
		var k = 0;
		if(op==0){k=1;}
		//alert("nodeID=" + $("#username").val() + "&name=" + ($("#name").val()) + "&keyID=" + k + "&host=" + $("#host").val() + "&kindID=" + $("#kindID").val() + "&companyID=" + $("#companyID").val() + "&dept1=" + $("#dept1").val() + "&dept2=" + $("#dept2").val() + "&limitDate=" + $("#limitDate").val() + "&mobile=" + ($("#mobile").val()) + "&phone=" + ($("#phone").val()) + "&email=" + ($("#email").val()) + "&job=" + ($("#job").val()) + "&education=" + ($("#education").val()) + "&memo=" + ($("#memo").val()));
		if(!$("#Tai").prop("checked")){		//普通身份证
			$.get("studentControl.asp?op=update&nodeID=" + $("#username").val() + "&name=" + escape($("#name").val()) + "&linker=" + escape($("#linker").val()) + "&unit=" + escape($("#unit").val()) + "&dept=" + escape($("#dept").val()) + "&ethnicity=" + escape($("#ethnicity").val()) + "&IDaddress=" + escape($("#IDaddress").val()) + "&bureau=" + escape($("#bureau").val()) + "&IDdateStart=" + $("#IDdateStart").val() + "&IDdateEnd=" + $("#IDdateEnd").val() + "&experience=" + escape($("#experience").val()) + "&keyID=" + k + "&host=" + $("#host").val() + "&kindID=" + $("#kindID").val() + "&companyID=" + $("#companyID").val() + "&dept1=" + $("#dept1").val() + "&dept2=" + $("#dept2").val() + "&job_status=" + $("#job_status").val() + "&limitDate=" + $("#limitDate").val() + "&mobile=" + escape($("#mobile").val()) + "&phone=" + escape($("#phone").val()) + "&email=" + escape($("#email").val()) + "&address=" + escape($("#address").val()) + "&job=" + escape($("#job").val()) + "&education=" + $("#education").val() + "&fromID=" + $("#fromID").val() + "&memo=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
				//alert(unescape(re));
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
							alert("保存成功！","信息提示");
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
					if(val=="photo" && scanPhoto == 0){
						if(hasPhoto == 1){
							$.messager.confirm('确认对话框', '要覆盖原来的照片吗?', function(r) {
								if(r){
									scanPhoto = 0;
								}
							});
						}
						if(scanPhoto == 0){		//当前没有照片，或有照片但未识别过且同意替换的
							//替换照片
							$.post(uploadURL + "/outfiles/uploadBase64img",{upID:"student_photo",username:$("#username").val(),name:$("#name").val(),currUser:currUser,imgData:cardJson.base64Data},function(re){
								//alert(re.status);
							});
						}
					}
					if(val=="cardA"){
						//替换身份证正面
						$.post(uploadURL + "/outfiles/uploadBase64img",{upID:"student_IDcardA",username:$("#username").val(),name:$("#name").val(),currUser:currUser,imgData:cardJson.imageFront},function(re){
							//alert(re.status);
						});
					}
					if(val=="cardB"){
						//替换身份证反面
						$.post(uploadURL + "/outfiles/uploadBase64img",{upID:"student_IDcardB",username:$("#username").val(),name:$("#name").val(),currUser:currUser,imgData:cardJson.imageBack},function(re){
							//alert(re.status);
						});
					}
				});
			}
		}else{	//港澳台证
			if($("#birthday").val()==""){
				alert("请填写出生日期。");
				return false;
			}
			$.get("studentControl.asp?op=updateTai&nodeID=" + $("#username").val() + "&name=" + escape($("#name").val()) + "&sex=" + $("#sex").val() + "&birthday=" + $("#birthday").val() + "&linker=" + escape($("#linker").val()) + "&unit=" + escape($("#unit").val()) + "&dept=" + escape($("#dept").val()) + "&ethnicity=" + escape($("#ethnicity").val()) + "&IDaddress=" + escape($("#IDaddress").val()) + "&bureau=" + escape($("#bureau").val()) + "&IDdateStart=" + $("#IDdateStart").val() + "&IDdateEnd=" + $("#IDdateEnd").val() + "&experience=" + escape($("#experience").val()) + "&keyID=" + k + "&host=" + $("#host").val() + "&kindID=" + $("#kindID").val() + "&companyID=" + $("#companyID").val() + "&dept1=" + $("#dept1").val() + "&dept2=" + $("#dept2").val() + "&job_status=" + $("#job_status").val() + "&limitDate=" + $("#limitDate").val() + "&mobile=" + escape($("#mobile").val()) + "&phone=" + escape($("#phone").val()) + "&email=" + escape($("#email").val()) + "&address=" + escape($("#address").val()) + "&job=" + escape($("#job").val()) + "&education=" + $("#education").val() + "&fromID=" + $("#fromID").val() + "&memo=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
				//alert(unescape(re));
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
							alert("保存成功！","信息提示");
						}
						fromCard = 0;
						$("#enter").focus();
					}
				}
				setSession("lastcompany", $("#companyID").val());
				setSession("lastdept1", $("#dept1").val());
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
		$.get("studentCourseControl.asp?op=getStudentCourseList&mark=2&keyID=" + id,function(data1){
			//alert(unescape(data1));
			var ar = new Array();
			var arr1 = new Array();
			ar = unescape(data1).split("%%");
			ar.shift();
			ar.shift();
			arr1.push("<table class='table_help' width='100%'>");
			arr1.push("<tr align='center' bgcolor='#e0e0e0'>");
			arr1.push("<td width='25%'>课程</td><td width='12%'>批次</td><td width='15%'>班级</td><td width='10%'>学号</td><td width='10%'>材料</td><td width='10%'>缴费</td><td width='10%'>经办</td>");
			arr1.push("</tr>");
			var imgChk = "<img src='images/green_check.png'>";
			if(ar > ""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					var d = "";
					if(ar1[44]==1){
						d = imgChk;
					}
					var c = "#90EE90;";
					if(ar1[16]==0){
						c = "#FFFACD;";
					}
					if(ar1[42] > ""){
						c = "#E8E8E8;";
					}
					arr1.push("<tr style='background-color:" + c + "'>");
					arr1.push("<td><a href='javascript:showEnterInfo(" + ar1[0] + ",\"" + $("#username").val() + "\",0,1,0);'>" + ar1[62] + "</a></td><td>" + ar1[41] + "</td><td>" + ar1[42] + "</td><td>" + ar1[43] + "</td><td>" + d + "</td><td>" + ar1[50] + "</td><td>" + ar1[67] + "</td>");
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
		$("#reset").hide();
		$("#btnDel").hide();
		//$("#upload1").hide();
		$("#enter").hide();
		$("#username").prop("disabled",true);
		$("*[tag='plus'").hide();
		$("#sex").prop("disabled",true);
		$("#birthday").prop("disabled",true);
		$("#scanPhoto").checkbox({readonly:true});
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
				$("#reset").show();
			}
			if(checkPermission("studentPhoto")){
				//$("#upload1").show();
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
		$("#host").val(currHost);
		$("#education").val(0);
		$("#enterCover").empty();
		$("#img_photo").attr("src","");
		$("#img_cardA").attr("src","");
		$("#img_cardB").attr("src","");
		$("#img_education").attr("src","");
		$("#img_promise").attr("src","");
		$("#img_social").attr("src","");
	}

	function setZNXF(){
		$("#kindID").hide();
		if($("#companyID").val()!=8 && $("#companyID").val()!=1813){
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
				//showUseCardInfo();
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
				//replaceImgFromCard("photo,cardA,cardB");
			}
		}
		if(k==0 && op==0 && re.certNo == $("#username").val()){
			//编辑状态，如果是当前的身份证，则比较其信息
			checkName(re.name);
			//弹出窗口，可选择覆盖原来的照片、身份证图片
			//替换原来的图片资料
			//showUseCardInfo();
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
				//showUseCardInfo();
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
				//replaceImgFromCard("photo,cardA,cardB");
			}
		}
		//填充全部图片
		replaceImgFromCard("photo,cardA,cardB");
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
		}else{
			fromCard = 1;
			setTimeout(function(){
				saveNode();
			},1000);
			
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

	function getEnterList(){
		//nothing, just callback enterInfo return's event
	}

	function setDraggable(){
		//setting draggable
		$("img[id^='img_']").draggable({
			proxy:'clone',
			revert:true,
			cursor:'pointer',
			onStartDrag:function(){
				// $(this).draggable('options').cursor='not-allowed';//设置鼠标样式为不可拖动
				$(this).draggable('proxy').addClass('dp');//设置样式
			},
			onStopDrag:function(){
				$(this).draggable('options').cursor='auto';//设置鼠标
			}
		});

		$("img[id^='img_']").droppable({
			accept:"img[id^='img_']",
			onDragEnter:function(e,source){//拖入
				$(source).draggable('options').cursor='auto';
				$(source).draggable('proxy').css('border','1px solid red');
				$(this).addClass('over');
			},
			onDragLeave:function(e,source){//脱离
				$(source).draggable('options').cursor='not-allowed';
				$(source).draggable('proxy').css('border','1px solid #ccc');
				$(this).removeClass('over');
			},
			onDrop:function(e,source){//放下
				$(this).append(source)
				$(this).removeClass('over');
				exchangeImg(source, this);
			} ,
			//onDropOver当元素被拖出(成功放入到某个容器)的时候触发
			onDragOver:function(e,source){
				// alert("我被拖出去了");//先于alert("我被放下了");执行,表明其触发在onDrop之前。
            }
		});
	}

	function exchangeImg(source, target){
		// 通过拖动图片，交换两个图片的所属标识
		var msg = "确定要互换这两个图片吗？";
		if($(source).attr("value") == ""){
			$.messager.alert("信息提示","没有可操作的图片。");
			resetDraggable(source);
		}else{
			if($(target).attr("value") == ""){
				msg = "确定要将图片调换到这里吗？";
			}
			$.messager.confirm('确认对话框', msg, function(r) {
				if(r){
					// alert($("#username").val() + "&kindID=" + $(source).attr("tag") + "&refID=" + $(target).attr("tag"))
					$.get("studentControl.asp?op=exchangeMaterial&nodeID=" + $("#username").val() + "&kindID=" + $(source).attr("tag") + "&refID=" + $(target).attr("tag") + "&times=" + (new Date().getTime()),function(data){
						if(data == 0){
							$.messager.alert("信息提示","操作成功。");
						}else{
							$.messager.alert("信息提示","操作失败。");
						}
						resetDraggable(source);
					});
				}
			});
		}
	}

	function resetDraggable(source){
		//nothing, just callback enterInfo return's event
		var s = $(source).clone().appendTo("#td_" + $(source).attr("id"));
		$(source).remove();
		getNodeInfo(0,$("#username").val());
		setDraggable();
	}

	function getUpdateCount(){
		return updateCount;
	}
</script>

</head>

<body style="background:#f0f0f0;">
 <!--#include file='commFloatDetail.asp' -->
 <!--#include file='commLoadFileDetail.asp' -->

    <style type="text/css">
        .drag{
            width:100px;
            height:50px;
            padding:10px;
            margin:5px;
            border:1px solid #ccc;
            background:#AACCFF;
        }
        .dp{
            opacity:0.5;
            filter:alpha(opacity=50);
        }
        .over{
            background:#FBEC88;
        }
    </style>

<div id='layout' align='left' style="background:#f0f0f0;">	
	<div style="float:left;width:70%;">
	<div style="width:100%;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8; float:left;width:100%;">
			<form id="detailCover" name="detailCover" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
			<table style="width:100%;">><input type="hidden" id="bureau" />
			<input type="hidden" id="experience" />
			<tr>
				<td align="right">身份证</td><input type="hidden" id="status" /><input type="hidden" id="host" />
				<td><input type="text" id="username" size="18" /><input style="border:0px;" type="checkbox" id="Tai" value="" />&nbsp;台胞</td>
				<td align="right">姓名</td><input type="hidden" id="studentID" />
				<td><input class="mustFill" type="text" id="name" size="25" /></td>
			</tr>
			<tr>
				<td align="right">性别</td>
				<td><select id="sex" style="width:180px;"></select></td>
				<td align="right">年龄</td>
				<td><input class="readOnly" readOnly="true" type="text" id="age" size="2" />&nbsp;出生日期<input type="text" id="birthday" size="8" /></td>
			</tr>
			<tr>
				<td align="left">证件期限</td>
				<td align="left" colspan="2">
					<input type="text" id="IDdateStart" size="15" />&nbsp;至&nbsp;<input type="text" id="IDdateEnd" size="15" />
				</td>
				<td align="left">民族&nbsp;<input id="ethnicity" name="ethnicity" type="text" size="10" /></td>
			</tr>
			<tr>
				<td align="right">身份证地址</td>
				<td colspan="3"><input type="text" id="IDaddress" style="width:95%;" /></td>
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
				<td align="right">岗位/职务</td>
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
				<td align="right">销售标识</td><td><select id="fromID" style="width:100px;"></select></td>
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
		<input class="button" type="button" id="reset" value="重置密码" />&nbsp;
		<input class="button" type="button" id="smsList" value="查看通知" />&nbsp;
		<input class="button" type="button" id="opList" value="查看操作" />&nbsp;
		<input class="button" type="button" id="examList" value="查看考试信息" />
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
		<td align="right" style="width:15%;">
			<img id="add_img_photo" src="images/plus.png" tag="plus" />
			<div style="padding-top:5px;"><input class="easyui-checkbox" id="scanPhoto" name="scanPhoto" />识</div>
		</td>
		<td id="td_img_photo" align="center" style="width:85%;">
			<img id="img_photo" tag="student_photo" src="" value="" style='width:100px;border:none;' />
		</td>
	</tr>
	<tr>
		<td align="right" style="width:15%;"><img id="add_img_cardA" src="images/plus.png" tag="plus" /></td>
		<td id="td_img_cardA" style="width:85%;">
			<img id="img_cardA" tag="student_IDcardA" src="" value="" style='width:150px;border:none;' />
		</td>
	</tr>
	<tr>
		<td align="right" style="width:15%;"><img id="add_img_cardB" src="images/plus.png" tag="plus" /></td>
		<td id="td_img_cardB" style="width:85%;">
			<img id="img_cardB" tag="student_IDcardB" src="" value="" style='width:150px;border:none;' />
		</td>
	</tr>
	<tr>
		<td align="right" style="width:15%;"><img id="add_img_education" src="images/plus.png" tag="plus" /></td>
		<td id="td_img_education" style="width:85%;">
			<img id="img_education" tag="student_education" src="" value="" style='width:150px;border:none;' />
		</td>
	</tr>
	<tr>
		<td align="right" style="width:15%;"><img id="add_img_CHESICC" src="images/plus.png" tag="plus" /></td>
		<td id="td_img_CHESICC" style="width:85%;">
			<img id="img_CHESICC" tag="student_CHESICC" src="" value="" style='width:150px;border:none;' />
		</td>
	</tr>
	<tr>
		<td align="right" style="width:15%;"><img id="add_img_employment" src="images/plus.png" tag="plus" /></td>
		<td id="td_img_employment" style="width:85%;">
			<img id="img_employment" tag="student_employment" src="" value="" style='width:150px;border:none;' />
		</td>
	</tr>
	<tr>
		<td align="right" style="width:15%;"><img id="add_img_jobCertificate" src="images/plus.png" tag="plus" /></td>
		<td id="td_img_jobCertificate" style="width:85%;">
			<img id="img_jobCertificate" tag="student_jobCertificate" src="" value="" style='width:150px;border:none;' />
		</td>
	</tr>
	<tr>
		<td align="right" style="width:15%;"><img id="add_img_promise" src="images/plus.png" tag="plus" /></td>
		<td id="td_img_promise" style="width:85%;">
			<img id="img_promise" tag="student_promise" src="" value="" style='width:150px;border:none;' />
		</td>
	</tr>
	<tr>
		<td align="right" style="width:15%;"><img id="add_img_social" src="images/plus.png" tag="plus" /></td>
		<td id="td_img_social" style="width:85%;">
			<img id="img_social" tag="student_social" src="" value="" style='width:150px;border:none;' />
		</td>
	</tr>
	<tr>
		<td align="left" colspan="2" style="width:100%;"><textarea id="text_reader_result" style="padding:5px;width:90%;background: #eeeeee;border:solid 1px #ccc;color:#ff0000;" rows="2"></textarea></td>
	</tr>
	</table>
</div>
</div>
</body>
