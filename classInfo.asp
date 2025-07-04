﻿<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css?v=1.8.6">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/data_table_mini.css?v=20150411" rel="stylesheet" type="text/css" />
<link href="css/jquery-confirm.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="css/jquery.autocomplete.css" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js?v=1.8.6"></script>
<script src="js/jquery-confirm.js" type="text/javascript"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<script type='text/javascript' src='js/jquery.autocomplete.js'></script>
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var nodeID = 0;
	var op = 0;
	var refID = 0;
	var updateCount = 0;
	var at_name = "";	//@name
	var at_username = "";
	let fire = 0;
	var imgFile = "<img src='images/attachment.png' style='width:15px;'>";
	var imgFileRed = "<img src='images/attachmentRed.png' style='width:15px;'>";
	var imgFileBlue = "<img src='images/attachmentBlue.png' style='width:15px;'>";
	var timer1 = null;
	let entryForm = "";
	let reexamine = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		refID = "<%=refID%>";
		op = "<%=op%>";
		getComList("projectID","projectInfo","projectID","projectName","status=1 order by projectID desc",1);
		//getComList("teacher","v_courseTeacherList","teacherID","teacherName","status=0 group by teacherID,teacherName",1);
		if(currHost==""){
			getComList("host","hostInfo","hostNo","title","status=0 and kindID=1 order by ID",1);
			getComList("courseID","v_courseInfo","courseID","shortName","status=0 and host='' order by courseID",1);
		}else{
			getComList("host","hostInfo","hostNo","title","status=0 and kindID=1 and hostNo='" + currHost + "' order by ID",0);
			getComList("courseID","v_courseInfo a, hostCourseList b","a.courseID","a.shortName","a.certID=b.courseID and a.status=0 and b.host='" + currHost + "' order by a.courseID",1);
		}
		getComList("fromID","userInfo","username","realName","status=0 and username in(select username from roleUserList where roleID='saler') order by realName",1);
		if(currHost==""){
			getComList("partner","hostInfo","hostNo","title","status=0 and kindID=1 order by ID",1);
		}else{
			getComList("partner","hostInfo","hostNo","title","status=0 and kindID=1 and hostNo='" + currHost + "' order by ID",0);
		}

		getDicList("planStatus","status",0);
		getDicList("online","kindID",0);
		getDicList("pre","pre",0);
		getDicList("signatureType","signatureType",0);
		getDicList("examResult","examResult",1);
		$("#dateStart").click(function(){WdatePicker({dateFmt:'yyyy-MM-dd HH:mm'});});
		$("#dateEnd").click(function(){WdatePicker();});
		
		$.ajaxSetup({ 
			async: false 
		}); 
		
		if(op==0){
			getNodeInfo(nodeID);
		}
		setButton();
		
		$("#save").click(function(){
			saveNode();
		});
		$("#close").click(function(){
			if(confirm('确定要结束课程吗?')){
				$.get("classControl.asp?op=closeClass&nodeID=" + $("#ID").val() + "&refID=2&times=" + (new Date().getTime()),function(data){
					alert("已结课","信息提示");
					getNodeInfo(nodeID);
					updateCount += 1;
				});
			}
		});
		$("#open").click(function(){
			if(confirm('确定重新开启班级吗?')){
				$.get("classControl.asp?op=closeClass&nodeID=" + $("#ID").val() + "&refID=0&times=" + (new Date().getTime()),function(data){
					alert("已重新开启，请及时关闭。","信息提示");
					getNodeInfo(nodeID);
					updateCount += 1;
				});
			}
		});
		$("#del").click(function(){
			if($("#qty").val() > 0){
				alert("该班级还有学员，不能删除。");
				return false;
			}
			if(confirm('确定删除班级吗?')){
				var x = prompt("请输入删除原因：","");
				if(x && x>""){
					$.get("classControl.asp?op=delNode&nodeID=" + $("#classID").val() + "&where=" + escape(x) + "&times=" + (new Date().getTime()),function(data){
						//alert(unescape(data));
						alert("已成功删除。","信息提示");
						updateCount += 1;
						op = 1;
						setButton();
					});
				}
			}
		});
		$("#btnInvoiceGroup").click(function(){
			getSelCart("visitstockchk");
			if(selCount==0){
				alert("请选择学员名单。");
				return false;
			}
			if(confirm('确定这' + selCount + '个学员共用一个发票吗?')){
				var x = prompt("请输入发票号码：","");
				if(x && x>""){
					$.post(uploadURL + "/public/setInvoiceGroup", {classID:$("#classID").val(), kind: "B", selList: selList, invoice: x, registerID: currUser} ,function(data){
						alert(data.msg);
					});
				}
			}
		});
		$("#btnAutoSetClassSNo").click(function(){
			if(confirm('确定要重新建立学号吗?')){
				$.get("classControl.asp?op=autoSetClassSNo&nodeID=" + $("#ID").val() + "&times=" + (new Date().getTime()),function(data){
					alert("已完成","信息提示");
					getNodeInfo(nodeID);
					updateCount += 1;
				});
			}
		});
		$("#btnSummary").click(function(){
			$.get("classControl.asp?op=getRandSummary&refID=" + $("#ID").val() + "&times=" + (new Date().getTime()),function(data){
				if(data==""){
					alert("没有找到相关记录。","信息提示");
				}else{
					$("#summary").val(unescape(data));
				}
			});
		});

		$("#courseID").change(function(){
			if($("#courseID").val()>""){
				var id=$("#courseID").val();
				setProjectList(id,[]);
				if(currDate<"2022-01-01"){
					$("#className").val($("#courseID").find("option:selected").text() + $("#dateStart").val().substr(2,8).replace(/-/g,""));
				}
			}
		});
		$("#host").change(function(){
			setHostChange();
		});
		$("#pre").change(function(){
			if($("#pre").val() == 1){
				$("#memo").val("预备班");
			}else{
				$("#memo").val("");
			}
		});

		$("#doImportRef").click(function(){
			if($("#projectID").val()==""){
				alert("请选择招生批次。");
				return false;
			}
			showLoadFile("ref_student_list",$("#ID").val(),"studentList",'');
			updateCount += 1;
		});

		$("#doImport").click(function(){
			if($("#projectID").val()==""){
				alert("请选择招生批次。");
				return false;
			}
			showLoadFile("student_list",$("#ID").val(),"studentList",'');
			updateCount += 1;
		});

		$("#refundList").click(function(){
			getMarkList("generate_refund_list","退费清单",currDate,'',0,0);
		});
		$("#sign").click(function(){
			getMarkList("student_list_in_class","签到表",$("#teacherName").val(),$("#adviserName").val(),29,4);
		});
		$("#sign1").click(function(){
			getMarkList("student_list_in_class","考勤表",$("#dateStart").val().substr(0,10),$("#adviserName").val(),0,0);
		});

		$("#archive").click(function(){
			if($("#summary").val()==""){
				//alert("请填写工作小结。");
				//return false;
			}
			if($("#dateEnd").val()==""){
				alert("请填写班级结束日期。");
				return false;
			}
			//showLoadFile("ref_student_list",$("#ID").val(),"studentList",'');
			window.open("class_archives.asp?nodeID=" + nodeID + "&keyID=1&kindID=B", "_self");
		});

		$("#btnSel").click(function(){
			setSel("");
		});
		
		$("#btnClassCall").click(function(){
			getSelCart("visitstockchk");
			if(selCount==0){
				alert("请选择要通知的名单。");
				return false;
			}
			if(confirm("确定要通知这" + selCount + "个学员参加培训吗？\n时间：" + $("#dateStart").val() + "\n地点：" + $("#classroom").val())){
				$.post(uploadURL + "/public/send_message_class", {batchID: $("#classID").val(), selList: selList, SMS:1, registerID: currUser} ,function(data){
					getNodeInfo(nodeID);
					alert("发送成功。");
				});
			}
		});
		
		$("#btnClassAlert").click(function(){
			getSelCart("visitstockchk");
			if(selCount==0){
				alert("请选择要通知的名单。");
				return false;
			}
			if(confirm("确定要提醒这" + selCount + "个学员抓紧学习进度吗？")){
				$.post(uploadURL + "/public/send_message_study_alert", {batchID: $("#classID").val(), selList: selList, SMS:1, registerID: currUser} ,function(data){
					getNodeInfo(nodeID);
					alert("发送成功。");
				});
			}
		});
		
		$("#btnClassExamDeny").click(function(){
			getSelCart("visitstockchk");
			if(selCount==0){
				alert("请选择要通知的名单。");
				return false;
			}
			if(confirm("确定要通知这" + selCount + "个学员暂不安排考试吗？")){
				$.post(uploadURL + "/public/send_message_exam_deny", {batchID: $("#classID").val(), selList: selList, SMS:1, registerID: currUser} ,function(data){
					getNodeInfo(nodeID);
					alert("发送成功。");
				});
			}
		});
		
		$("#btnAttentionPhoto").click(function(){
			getSelCart("visitstockchk");
			if(selCount==0){
				alert("请选择要通知的名单。");
				return false;
			}
			if(confirm("确定要通知这" + selCount + "个学员提交电子照片吗？")){
				$.post(uploadURL + "/public/send_message_submit_photo", {kind: "", selList: selList, SMS:1, registerID: currUser} ,function(data){
					getNodeInfo(nodeID);
					alert("发送成功。");
				});
			}
		});
		
		$("#btnAttentionSignature").click(function(){
			getSelCart("visitstockchk");
			if(selCount==0){
				alert("请选择要通知的名单。");
				return false;
			}
			if(confirm("确定要通知这" + selCount + "个学员完成签名吗？")){
				$.post(uploadURL + "/public/send_message_submit_signature", {batchID: $("#classID").val(), selList: selList, SMS:1, registerID: currUser} ,function(data){
					getNodeInfo(nodeID);
					alert("发送成功。");
				});
			}
		});
		
		$("#btnAttentionLogin").click(function(){
			getSelCart("visitstockchk");
			if(selCount==0){
				alert("请选择要通知的名单。");
				return false;
			}
			if(confirm("确定要通知这" + selCount + "个学员登录系统吗？")){
				$.post(uploadURL + "/public/send_message_submit_login", {batchID: $("#classID").val(), selList: selList, SMS:1, registerID: currUser} ,function(data){
					getNodeInfo(nodeID);
					alert("发送成功。");
				});
			}
		});
		
		$("#btnAttentionPhotoClose").click(function(){
			getSelCart("visitstockchk");
			if(selCount==0){
				alert("请选择要关闭的名单。");
				return false;
			}
			if(confirm("确定要将这" + selCount + "个提交电子照片通知关闭吗？")){
				$.post(uploadURL + "/public/send_message_submit_attention_close", {batchID: "", kindID:0, kind: "", selList: selList, SMS:1, registerID: currUser} ,function(data){
					getNodeInfo(nodeID);
					alert("操作成功。");
				});
			}
		});
		
		$("#btnAttentionSignatureClose").click(function(){
			getSelCart("visitstockchk");
			if(selCount==0){
				alert("请选择要关闭的名单。");
				return false;
			}
			if(confirm("确定要将这" + selCount + "个提交签名通知关闭吗？")){
				$.post(uploadURL + "/public/send_message_submit_attention_close", {batchID: $("#classID").val(), kindID:1, kind: "", selList: selList, SMS:1, registerID: currUser} ,function(data){
					getNodeInfo(nodeID);
					alert("操作成功。");
				});
			}
		});
		
		$("#btnClassChange").click(function(){
			getSelCart("visitstockchk");
			if(selCount==0){
				alert("请选择要更换班级的名单。");
				return false;
			}
			if(confirm("确定要将这" + selCount + "个学员移动到其他班级吗？")){
				$.get("classControl.asp?op=getClassListByClassID&refID=" + $("#classID").val(),function(data){
					// alert(unescape(data));
					var ar = $.parseJSON(unescape(data));
					jSelect("请输入班级编号：", ar, "目标班级",function(d){
						d = d.replace(/\s*/g,"");
						// if(d > ""){
							//alert($("#searchStudentPreProjectID").val() + "&status=1&host=" + $("#searchStudentPreHost").val() + "&keyID=" + selList);
							$.post("studentCourseControl.asp?op=pick_students2class", {batchID: d, selList: selList, fromClass: $("#classID").val()} ,function(data1){
								// alert(data);
								if(data1>0){
									jAlert("成功将" + data1 + "个学员转入新班级。");
									getNodeInfo(nodeID);
									updateCount += 1;
								}else{
									jAlert("操作失败，没有符合要求的学员。");
								}
							});
						// }else{
						// 	jAlert("班级编号不能为空。");
						// }
					});
				});
			}
		});
		
		$("#btnPaynowChange").click(function(){
			getSelCart("visitstockchk");
			if(selCount==0){
				jAlert("请选择要操作的名单。");
				return false;
			}
			if(confirm("确定要更改这" + selCount + "个学员的付款类型吗？")){
				var ar = {"10":"后付费/未付","00":"预付费/未付","11":"后付费/已付","01":"预付费/已付"};
				jSelect("请选择付款类型：", ar, "付款类型",function(d){
					d = d.replace(/\s*/g,"");
					$.post("studentCourseControl.asp?op=pick_students2paynow", {payNow: d, selList: selList, fromClass: $("#classID").val()} ,function(data){
						// jAlert(data);
						if(data>0){
							jAlert("成功修改了" + data + "个学员的付款类型(已付款的不能修改)。");
						}else{
							jAlert("操作失败，没有符合要求的学员。");
						}
					});
				});
			}
		});

		$("#btnCloseStudentCourse").click(function(){
			getSelCart("visitstockchk");
			if(selCount==0){
				jAlert("请选择要操作的名单。");
				return false;
			}
			jConfirm('确定要关闭/重启这' + selCount + '个学员的课程吗?', '确认对话框', function(r) {
				if(r){
					$.post("studentCourseControl.asp?op=closeStudentCourseBatch", {selList: selList, classID: $("#classID").val()} ,function(data){
						jAlert("操作成功。");
					});
				}
			});
		});

		$("#btnMockView").click(function(){
			showClassExamStat($("#classID").val(),$("#className").val(),0,0);
		});

		$("#btnMockDetail").click(function(){
			outputExcelBySQL('x07','file',$("#classID").val(),0,0);
		});
		$("#schedule").click(function(){
			//setSession("page_params",{className:$("#className").val(), courseName:$("#courseName").val(), startDate:$("#dateStart").val(), endDate:$("#dateEnd").val(), adviser:$("#adviserName").val(), qty:$("#qty").val()});
			showClassSchedule($("#ID").val(),"B","{className:'" + $("#ID").val() + "', courseName:'" + $("#courseName").val()+"', transaction_id:'" + $("#transaction_id").val()+"', startDate:'"+$("#dateStart").val().substr(0,10)+"', endDate:'"+$("#dateEnd").val()+"', adviser:'"+$("#adviserName").val()+"', qty:"+$("#qty").val()+"}",0,1);
		});
		$("#showPhoto").change(function(){
			getStudentCourseList();
		});
		$("#btnFindStudent").click(function(){
			getStudentCourseList();
		});
		
		$("#btnSchedule").click(function(){
			if($("#dateStart").val()==""){
				alert("请确定开课日期。");
				return false;
			}
			if($("#teacher").val()==""){
				alert("请确定任课教师。");
				return false;
			}
			if($("#classroom").val()==""){
				alert("请确定上课地点。");
				return false;
			}
			if(confirm("确定要编排课表吗？")){
				$.get("classControl.asp?op=generateClassSchedule&refID=" + $("#ID").val() + "&kindID=B&times=" + (new Date().getTime()),function(re){
					getNodeInfo(nodeID);
					alert("课表编排完毕。");
				});
			}
		});

		$("#btnRebuildStudentLesson").click(function(){
			jConfirm('确定要刷新本班所有学员的课表吗?\n<p style="color:red; font-size:1.3em;">课程进度和练习记录将被删除且不可恢复!</p>', '确认对话框', function(r) {
				if(r){
					$.get("studentCourseControl.asp?op=rebuildLessonByClass&nodeID=" + $("#ID").val() + "&times=" + (new Date().getTime()),function(re){
						jAlert("刷新成功。");
						//updateCount += 1;
						//getNodeInfo($("#studentCourseID").val());
					});
				}
			});
		});

		$("#btnFireScore").click(function(){
				getSelCart("visitstockchk");
				if(selCount==0){
					$.messager.alert("提示","请选择要查询成绩的人员。","info");
					return false;
				}
				// jConfirm('确定要为这' + selCount + '个人报名吗?', "确认对话框",function(r){
				$.messager.confirm('确认对话框','确定查询这' + selCount + '个人的成绩吗?<br>可能要花几分钟时间，请稍候...', function(r){
					if(r){
						var start = performance.now(); 
						$.ajax({
							url: uploadURL + "/public/fireScoreCheck?host=" + currHost + "&register=" + currUserName,
							type: "post",
							data: {"selList":selList, "kindID":2, refID:$("#ID").val()},
							beforeSend: function() {   
								$.messager.progress();	// 显示进度条
							},
							success: function(data){
								//jAlert(data);
								if(data.err==0){
									var end = performance.now(); 
									jAlert("成功查询数量：" + data.count_s + "; &nbsp;失败数量：" + data.count_e + "; &nbsp;耗时：" + ((end-start)/1000).toFixed(2) + "秒","信息提示");
								}else{
									jAlert("操作失败，请稍后再试。" + data.errMsg,"信息提示");
								}
								getStudentCourseList();
								$.messager.progress('close');	// 如果提交成功则隐藏进度条 
							}
						});
					}
				});
		});
	
		$("#btnSetSource").click(function(){
			getSelCart("");
			if(selCount==0){
				$.messager.alert("提示","请选择要操作的名单。","info");
				return false;
			}
			if(confirm("确定为这" + selCount + "个学员设置来源吗？")){
				$.get("agencyControl.asp?op=getCurrSourceList",function(re){
					// alert(unescape(data));
					let ar0 = $.parseJSON(unescape(re));
					jSelect("请选择来源：", ar0, "学员来源",function(d){
						d = d.replace(/\s*/g,"");
						$.post(uploadURL + "/public/postCommInfo", {proc:"setStudentSource", params:{selList:selList, kind:"B", classID:$("#classID").val(), source:d, registerID:currUser}}, function(data){
							//alert(unescape(re));
							let ar = data[0]
							// alert(ar)
							if(ar["status"] == "0"){
								$.messager.alert("提示","操作成功","info");
								getApplyList();
							}else{
								$.messager.alert("提示",ar["msg"],"info");
							}
						});
					});
				});
			}
		});

		$("#btn_feedback_submit").click(function(){
			submit_feedback();
		});
		$("#btnDownload").click(function(){
			outputFloat(9101,'file');
		});
		$("#checkStudent").click(function(){
			showLoadFile("check_student_list",$("#certID").val(),"studentList",'');
		});
	
		$("#generateZip").click(function(){
			generateZip("m");
		});
	
		$("#generatePhotoZip").click(function(){
			generateZip("p");
		});
	
		$("#generateEntryZip").click(function(){
			generateZip("e");
		});
		
		$("#btnDiplomaIssue").click(function(){
			getSelCart("visitstockchk");
			if(selCount==0){
				jAlert("还没有选择名单");
				return false;
			}
			setSession("need2DiplomaList", selList);
			showGenerateDiplomaInfo1(0,$("#certID").val(),"need2DiplomaList",selCount,'',1,0);
		});

		var timer = setInterval(getFeedbackList, 300000);
		//var div = document.getElementById('feedback_list');
		//div.scrollTop = div.scrollHeight; 

	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		$.get("classControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#classID").val(ar[1]);
				//$("#projectID").val(ar[2]);
				$("#certID").val(ar[3]);
				$("#btnFireScore").hide();
				if(ar[3]=='C20' || ar[3]=='C20A' || ar[3]=='C21'){
					fire = 1;	//消防项目
					$("#btnFireScore").show();
				}
				//getComList("teacher","v_courseTeacherList","teacherID","teacherName","status=0 and courseID='" + $("#certID").val() + "' order by teacherID",1);
				$("#kindID").val(ar[5]);
				$("#status").val(ar[6]);
				$("#adviserName").val(ar[9]);
				$("#dateStart").val(ar[10]);
				$("#dateEnd").val(ar[11]);
				$("#classroom").val(ar[12]);
				$("#memo").val(ar[13]);
				$("#regDate").val(ar[14]);
				$("#registerName").val(ar[16]);
				$("#className").val(ar[17]);
				$("#timetable").val(ar[18]);
				$("#qty").val(ar[20]);
				$("#qtyApply").val(ar[26]);
				$("#qtyExam").val(ar[27]);
				$("#qtyPass").val(ar[28]);
				$("#qtyReturn").val(ar[33]);
				$("#summary").val(ar[25]);
				$("#archiveDate").val(ar[24]);
				$("#archiverName").val(ar[29]);
				$("#send").val(ar[30]);
				$("#sendDate").val(ar[31]);
				$("#senderName").val(ar[32]);
				$("#scheduleDate").val(ar[35]);
				$("#courseName").val(ar[37]);
				$("#teacherName").val(ar[38]);
				$("#host").val(ar[39]);
				$("#transaction_id").val(ar[40]);
				$("#signatureType").val(ar[45]);
				$("#pre").val(ar[50]);
				$("#courseID").val(ar[36]);
				setProjectList(ar[36],ar[2]);
				setHostChange();
				$("#adviserID").val(ar[8]);
				$("#courseID").val(ar[36]);
				entryForm = ar[51];
				reexamine = ar[52];
				if(ar[24]>""){
					$("#archived").prop("checked",true);
				}else{
					$("#archived").prop("checked",false);
				}
				var c = "";
				if(ar[21] > ""){
					c += "<a href='/users" + ar[21] + "' target='_blank'>报名清单</a>";
				}
				if(c == ""){c = "&nbsp;&nbsp;";}
				$("#photo").html(c);
				$("#refundList").html("<a>退费单</a>");
				$("#archive").html("<a>班级档案</a>");
				if(ar[35]>""){
					$("#schedule").html("<a>课程表</a>");
				}
				$("#sign").html("<a>签到表</a>");
				$("#sign1").html("<a>考勤表</a>");
				if(ar[47] > ""){
					$("#zip").html("<a href='/users" + ar[47] + "?times=" + (new Date().getTime()) + "' target='_blank'>归档压缩包</a>");
				}
				if(ar[48] > ""){
					$("#pzip").html("<a href='/users" + ar[48] + "?times=" + (new Date().getTime()) + "' target='_blank'>资料压缩包</a>");
				}
				if(ar[49] > ""){
					$("#ezip").html("<a href='/users" + ar[49] + "?times=" + (new Date().getTime()) + "' target='_blank'>报名表压缩包</a>");
				}
				getStudentCourseList();
				$("#teacher").val(ar[34]);
				//getDownloadFile("classID");
				getFeedbackList();
				setButton();
			}else{
				alert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}

	function getStudentCourseList(){
		//alert($("#classID").val());
        var mark = 1;
        if(checkRole("saler") && !checkRole("adviser")){
            mark = 3;
        }
		var photo = 0;
		$("#btnAttentionSignature").hide();
		$("#btnAttentionPhoto").hide();
		$("#btnAttentionSignatureClose").hide();
		$("#btnAttentionPhotoClose").hide();
		if($("#showPhoto").prop("checked")){
			photo = 1;
			$("#btnAttentionSignature").show();
			$("#btnAttentionPhoto").show();
			$("#btnAttentionSignatureClose").show();
			$("#btnAttentionPhotoClose").show();
		}
		$.get("studentCourseControl.asp?op=getStudentCourseList&classID=" + $("#classID").val() + "&mark=" + mark + "&examResult=" + $("#examResult").val() + "&fromID=" + $("#fromID").val() + "&host=" + $("#partner").val() + "&completion2=" + $("#s_completion2").val() + "&score2=" + $("#s_score2").val() + "&dk=9101&times=" + (new Date().getTime()),function(data){
			// alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#cover").empty();
			var ar0 = new Array();
			var i = 0;
			ar0 = ar.shift().split("|");
			arr = [];		
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='cardTab' width='100%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='5%'>学号</th>");
			arr.push("<th width='5%'>姓名</th>");
			arr.push("<th width='6%'>电话</th>");
			arr.push("<th width='6%'>来源</th>");
			arr.push("<th width='6%'>支付</th>");
			if(photo == 0){
				arr.push("<th width='10%'>单位</th>");
				arr.push("<th width='5%'>进度%</th>");
				arr.push("<th width='7%'>模拟</th>");
				if(fire==1){
					arr.push("<th width='6%'>考试日期</th>");
				}else{
					arr.push("<th width='5%'>准申</th>");
				}
				arr.push("<th width='5%'>成绩</th>");
				arr.push("<th width='5%'>证书</th>");
			}else{
				arr.push("<th width='6%'>照片</th>");
				arr.push("<th width='6%'>身份证</th>");
				arr.push("<th width='6%'>反面</th>");
				arr.push("<th width='6%'>签名</th>");
				arr.push("<th width='6%'>学历</th>");
				arr.push("<th width='6%'>在职</th>");
			}
			if(reexamine==1){
				arr.push("<th width='6%'>复训日期</th>");
			}
			arr.push("<th width='2%'>费</th>");
			// arr.push("<th width='2%'>报</th>");
			arr.push("<th width='10%'>备注</th>");
			arr.push("<th width='2%'></th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var c = 0;
				var h = "";
				var k = 0;
				var s = $("#status").val();
				var attention_status = ["FFFFAA","AAFFAA","F3F3F3"];
				var backcolor = ["#F0F0F0","#FFFF00","#00FF00","#FF8888"];
				var bc = "";
				let photo_size = 0;
				let photo_type = "jpg";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showEnterInfo(" + ar1[0] + ",\"" + ar1[1] + "\",0,1);'>" + ar1[43] + "</a></td>");
					arr.push("<td class='link1'><a href='javascript:showStudentInfo(0,\"" + ar1[1] + "\",0,1,\"class\");'>" + ar1[2] + "</a></td>");
					arr.push("<td class='left'>" + ar1[69] + "</td>");
					arr.push("<td class='left'>" + ar1[90] + "</td>");
					arr.push("<td class='left'>" + ar1[49] + "</td>");
					//arr.push("<td title='最好成绩' class='link1'><a href='javascript:showStudentExamStat(" + ar1[0] + ",\"" + ar1[2] + "\",0,0);'>" + c + "</a></td>");
					if(photo == 0){
						if(ar1[56]!="spc" && ar1[56]!="shm"){	//非集团客户，显示自己的单位和部门
							arr.push("<td class='left' title='" + ar1[54] + "'>" + ar1[54].substr(0,12) + "</td>");
						}else{
							arr.push("<td class='left' title='" + ar1[12] + "'>" + ar1[13].substr(0,12) + "</td>");
						}
						c = ar1[10];
						if(c>0){
							c = c;
						}else{
							c = "";
						}
						arr.push("<td class='center'>" + c + "</td>");	//学习进度
						arr.push("<td title='最好成绩' class='link1' onclick='showExamList(" + ar1[0] + ",\"" + ar1[2] + "\",0,0);'>" + nullNoDisp(ar1[15]) + "</td>");
						
						if(fire==1){
							arr.push("<td class='left'>" + ar1[86] + "</td>");
						}else{
							//申报
							if(ar1[65]>0 || ar1[53]>0){
								arr.push("<td class='center'>" + imgChk + "</td>");	//申报/准考证
							}else{
								arr.push("<td class='center'>&nbsp;</td>");
							}
						}
						h = ar1[66];
						if($("#certID").val()=="C12" || $("#certID").val()=="C20" || $("#certID").val()=="C20A" || $("#certID").val()=="C21" || $("#certID").val()=="C14" || $("#certID").val()=="C15" || $("#certID").val()=="C24" || $("#certID").val()=="C25" || $("#certID").val()=="C26" || $("#certID").val()=="C25B" || $("#certID").val()=="C26B"){
							h = ar1[70].replace(".00","") + "/" + ar1[71].replace(".00","");
							if(ar1[87]==3){h=ar1[88]}
						}
						arr.push("<td class='left'" + (fire==1 && (ar1[87]==2 || ar1[87]==3)?" style='background-color:#FFFFAA;'":"") + ">" + (fire==0?"<a href='javascript:showStudentExamPaper(" + ar1[0] + ",\"" + ar1[2] + "\");'>":"") + nullNoDisp(h) + (fire==0?"</a>":"") + "</td>");
						if(ar1[64]>""){
							arr.push("<td class='center'>" + imgChk + "</td>");	//证书
						}else{
							arr.push("<td class='center'>&nbsp;</td>");
						}
					}else{
						h = "";
						if(ar1[75]>0){	//根据照片或签字提醒状态，显示不同背景颜色
							h = " style='background-color:#" + attention_status[ar1[75]-1] + ";'";
						}
						photo_type = ar1[18].substr(ar1[18].indexOf("."));
						photo_size = ar1[85];
						if(photo_size > 100 || (photo_type !== ".jpg" && photo_type !== ".jpeg")){	//根据照片类型或文件大小，显示不同背景颜色
							h = " style='background-color:#FFFFAA;'";
						}
						if(ar1[18] > ""){
							arr.push("<td class='center'" + h + "><img id='photo" + ar1[1] + "' title='大小：" + photo_size + "k, 类型：" + photo_type + "' src='users" + ar1[18] + "?times=" + (new Date().getTime()) + "' onclick='showCropperInfo(\"users" + ar1[18] + "\",\"" + ar1[1] + "\",\"photo\",\"\",0,1)' style='width:50px;background: #ccc;border:2px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);'></td>");
						}else{
							arr.push("<td class='center'" + h + ">&nbsp;</td>");
						}
						if(ar1[19] > ""){
							arr.push("<td class='center'><img id='IDcardA" + ar1[1] + "' src='users" + ar1[19] + "?times=" + (new Date().getTime()) + "' onclick='showCropperInfo(\"users" + ar1[19] + "\",\"" + ar1[1] + "\",\"IDcardA\",\"\",0,1)' style='width:60px;background: #ccc;border:2px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);'></td>");
						}else{
							arr.push("<td class='center'>&nbsp;</td>");
						}
						if(ar1[20] > ""){
							arr.push("<td class='center'><img id='IDcardB" + ar1[1] + "' src='users" + ar1[20] + "?times=" + (new Date().getTime()) + "' onclick='showCropperInfo(\"users" + ar1[20] + "\",\"" + ar1[1] + "\",\"IDcardB\",\"\",0,1)' style='width:60px;background: #ccc;border:2px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);'></td>");
						}else{
							arr.push("<td class='center'>&nbsp;</td>");
						}
						if(ar1[76]>0){
							h = " style='background-color:#" + attention_status[ar1[76]-1] + ";'";
						}else{
							h = "";
						}
						if(ar1[73] > ""){
							arr.push("<td class='center'" + h + "><img src='users" + ar1[73] + "?times=" + (new Date().getTime()) + "' style='width:60px;background: #ccc;border:2px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);'></td>");
						}else{
							arr.push("<td class='center'" + h + ">&nbsp;</td>");
						}
						if(ar1[21] > ""){
							arr.push("<td class='center'><img id='education" + ar1[1] + "' src='users" + ar1[21] + "?times=" + (new Date().getTime()) + "' onclick='showCropperInfo(\"users" + ar1[21] + "\",\"" + ar1[1] + "\",\"education\",\"\",0,1)' style='width:60px;background: #ccc;border:2px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);'></td>");
						}else{
							arr.push("<td class='center'>&nbsp;</td>");
						}
						if(ar1[80] > ""){
							arr.push("<td class='center'><img id='employment" + ar1[1] + "' src='users" + ar1[80] + "?times=" + (new Date().getTime()) + "' onclick='showCropperInfo(\"users" + ar1[80] + "\",\"" + ar1[1] + "\",\"employment\",\"\",0,1)' style='width:60px;background: #ccc;border:2px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);'></td>");
						}else{
							arr.push("<td class='center'>&nbsp;</td>");
						}
						bc = "";
						if(ar1[57]==1 && ar1[3]<2){	//有复训日期且没有结束课程的
							if(ar1[83]>""){
								let x = dateDiff(ar1[83],(new Date().format("yyyy-MM-dd")));
								if(x<=30 && x>0){bc = backcolor[1]}
								if(x>30 && x <= 60){bc = backcolor[2]}
								if(x>60){bc = backcolor[3]}
							}
						}
					}
					if(reexamine==1){
						arr.push("<td class='left' " + (ar1[57]==1 && bc>"" ? "style='background:" + bc + ";'" : "") + ">" + ar1[83] + "</td>");	// 复训日期
					}
					arr.push("<td class='left'>" + (ar1[68]==1?imgChk:'&nbsp;') + "</td>");	// 
					arr.push("<td class='left'>" + ar1[82] + "</td>");
					// if(ar1[78]==''){
					// 	arr.push("<td class='center'><div id='material" + ar1[0] + "'><span onclick='generateMaterials(" + ar1[0] + ",\"" + ar1[1] + "\",\"" + ar1[60] + "\")' title='申报材料'><img src='images/addDoc.png' style='width:15px;'><span><div></td>");
					// }else{
					// 	arr.push("<td class='center'><div id='material" + ar1[0] + "'><a href='javascript:void(0);' onclick='openMaterial(\"/users" + ar1[78] + "?t=" + (new Date().getTime()) + "\");' ondblclick='generateMaterials(" + ar1[0] + ",\"" + ar1[1] + "\",\"" + ar1[60] + "\")' title='存档材料'>" + imgFile + "</a></div></td>");
					// }
					// if(ar1[79]==''){
					// 	arr.push("<td class='center'>&nbsp;</td>");
					// }else{
					// 	arr.push("<td class='center'><div id='material1" + ar1[0] + "'><a href='javascript:void(0);' onclick='openMaterial(\"/users" + ar1[79] + "?t=" + (new Date().getTime()) + "\");' title='报名材料'>" + imgFileBlue + "</a></div></td>");
					// }
					arr.push("<td class='left'><input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + ar1[1] + "' name='visitstockchk'></td>");
					arr.push("</tr>");
				});
			}
			arr.push("</tbody>");
			arr.push("<tfoot>");
			arr.push("<tr>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			if(reexamine==1){
				arr.push("<th>&nbsp;</th>");
			}
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#cover").html(arr.join(""));
			arr = [];
			$('#cardTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"aLengthMenu":[15,30,50,100,500],
				"iDisplayLength": 500,
				"bInfo": true,
				"aoColumnDefs": []
			});
			floatCount = i;
		});
	}
	
	function saveNode(){
		if(op==0 && $("#adviserID").val()!=currUser){
			//alert("只有该班的班主任才能操作。");
			//return false;
		}
		if(currDate<"2022-01-01" && $("#className").val()==""){
			alert("请填写班级名称。");
			return false;
		}
		if($("#dateStart").val()==""){
			alert("请填写开班日期。");
			return false;
		}
		if($("#projectID").val()==""){
			alert("请选择招生批次。");
			return false;
		}
		if($("#courseID").val()==""){
			alert("请选择课程。");
			return false;
		}
		var photo = 0;
		if($("#archived").prop("checked")){photo = 1;}
		//alert($("#ID").val() + "&signatureType=" + $("#signatureType").val() + "&projectID=" + $("#projectID").combobox("getValues") + "&className=" + ($("#className").val()) + "&classroom=" + ($("#classroom").val()) + "&timetable=" + escape($("#timetable").val()) + "&certID=" + $("#certID").val() + "&courseID=" + $("#courseID").val() + "&adviserID=" + $("#adviserID").val() + "&host=" + $("#host").val() + "&teacher=" + $("#teacher").val() + "&kindID=" + $("#kindID").val() + "&status=" + $("#status").val() + "&dateStart=" + $("#dateStart").val() + "&dateEnd=" + $("#dateEnd").val() + "&transaction_id=" + $("#transaction_id").val() + "&archived=" + photo);
		$.post("classControl.asp?op=update&nodeID=" + $("#ID").val() + "&signatureType=" + $("#signatureType").val() + "&projectID=" + $("#projectID").combobox("getValues") + "&className=" + escape($("#className").val()) + "&classroom=" + escape($("#classroom").val()) + "&timetable=" + escape($("#timetable").val()) + "&certID=" + $("#certID").val() + "&courseID=" + $("#courseID").val() + "&adviserID=" + $("#adviserID").val() + "&pre=" + $("#pre").val() + "&host=" + $("#host").val() + "&teacher=" + $("#teacher").val() + "&kindID=" + $("#kindID").val() + "&status=" + $("#status").val() + "&dateStart=" + $("#dateStart").val() + "&dateEnd=" + $("#dateEnd").val() + "&transaction_id=" + $("#transaction_id").val() + "&archived=" + photo, {"memo":$("#memo").val(), "summary":$("#summary").val()},function(re){
			// $.messager.alert("提示",unescape(re));
			if(re > 0){
				nodeID = re;
				if(op == 1){
					op = 0;
				}
				alert("保存成功！","信息提示");
				getNodeInfo(nodeID);
				updateCount += 1;
			}else{
				alert("未能成功提交。","信息提示");
			}
		});
		//return false;
	}
	
	function setProjectList(id,s){
		$("#projectID").empty();
		//alert(id + "&op=" + op + "&host=" + $("#host").val());
		//getComList("projectID","projectInfo","projectID","projectName"," status>0 and certID='" + id + "' order by projectID desc",1);
		var x = op;
		if($("#pre").val()==1){
			x = 1;	//预备班相当于新班
		}
		$.getJSON(uploadURL + "/public/getProjectListBycertID?certID=" + id + "&op=" + x + "&host=" + $("#host").val() ,function(data){
			if(data>""){
				//alert(data[0]["deptName"]);
				//data = [{"id":1,"text":"text1"},{"id":2,"text":"text2"},{"id":3,"text":"text3"},{"id":4,"text":"text4"},{"id":5,"text":"text5"}];
				$('#projectID').combobox({
					data: data,
					valueField:'projectID',
					textField:'projectName',
					//panelHeight: 200,
					multiple: true,
					editable: false,
					onLoadSuccess: function () { // 下拉框数据加载成功调用
						// 正常情况下是默认选中“所有”，但我想实现点击所有全选功能，这这样会冲突，暂时默认都不选
						//$("#dept").combobox('clear'); //清空
						$('#projectID').combobox("setValues",s);

						// var opts = $(this).combobox('options');
						// var values = $('#'+_id).combobox('getValues');
						// $.map(opts.data, function (opt) {
						//     if (opt.id === '') { // 将"所有"的复选框勾选
						//         $('#'+opt.domId + ' input[type="checkbox"]').prop("checked", true);
						//     }
						// });
					}
				});
			}
		});
		if($("#scheduleDate").val()>""){
			var h = $("#host").val();
			if(h>"" && h !="ding"){	//ding使用智能消防学校的资源
				getComList("teacher","v_courseTeacherList a, courseInfo b","teacherID","teacherName","a.courseID=b.certID and a.status=0 and b.courseID='" + $("#courseID").val() + "' and a.host='" + h + "' order by teacherID",1);
			}else{
				getComList("teacher","v_courseTeacherList a, courseInfo b","teacherID","teacherName","a.courseID=b.certID and a.status=0 and b.courseID='" + $("#courseID").val() + "' order by teacherID",1);
			}
		}else{
			getComList("teacher","dbo.getFreeTeacherList('','" + $("#ID").val() + "','B')","teacherID","teacherName","1=1 order by freePoint desc",1);
		// alert($("#ID").val());
		}
	}
	
	function setHostChange(){
		var h = $("#host").val();
		if(h>"" && h !="ding"){	//ding使用智能消防学校的资源
			getComList("courseID","[dbo].[getHostCourseList]('" + $("#host").val() + "')","courseID","courseName","1=1",1);
			getComList("adviserID","userInfo","username","realName","status=0 and username in(select username from roleUserList where roleID='adviser' and host='" + h + "') order by realName",1);
			$("#memo").val($("#host").find("option:selected").text());
		}else{
			getComList("courseID","v_courseInfo","courseID","shortName","status=0 and host='' order by courseID",1);
			getComList("adviserID","userInfo","username","realName","status=0 and username in(select username from roleUserList where roleID='adviser' and host='') order by realName",1);
		}
		if(h =="ding"){	//ding使用智能消防学校的资源
			getComList("courseID","[dbo].[getHostCourseList]('" + $("#host").val() + "')","courseID","courseName","1=1",1);
		}
	}
	
	function getMarkList(tag,mark, dt, ad, r, t){
		$.getJSON(uploadURL + "/outfiles/generate_excel?tag=" + tag + "&classID=" + $("#classID").val() + "&className=" + $("#className").val() + "&price=10&mark=" + mark + "&date=" + dt + "&adviser=" + ad + "&teacher=" + $("#teacherName").val() + "&row=" + r + "&top=" + t ,function(data){
			if(data>""){
				asyncbox.alert("已生成 <a href='" + data + "' target='_blank'>下载文件</a>",'操作成功',function(action){
				　　//alert 返回action 值，分别是 'ok'、'close'。
				　　if(action == 'ok'){
				　　}
				　　if(action == 'close'){
				　　　　//alert('close');
				　　}
				});
				//getNodeInfo(nodeID);
			}else{
				alert("没有可供处理的数据。");
			}
		});
	}
	
	function getFeedbackList(){
		//alert(currUser + "&classID=" + $("#classID").val());
		$.getJSON(uploadURL + "/public/get_feedback_class_list?username=" + currUser + "&classID=" + $("#classID").val() + "&type=1" ,function(data){
			if(data>""){
				//alert(data[0]["item"]);
				var ar = Array();
				ar.push("<ul style='list-style-type:none;width:100%;margin:0px;text-align:left;'>");
				$.each(data,function(iNum,val){
					ar.push("<li style='width:100%; float:left; color:#555;background:#EEE;'" + (val["title"]!="我"?" onclick='setAtUser(\"" + val["title"] + "\",\"" + val["username"] + "\");'":"") + ">" + val["title"] + "&nbsp;&nbsp;&nbsp;&nbsp;" + val["regDate"] + (val["title"]=="我" && val["cancelAllow"]==1?"&nbsp;&nbsp;&nbsp;&nbsp;<a href='javascript:doCancelFeedback(" + val["ID"] + ");'>撤回</a>":"") + "</li>");
					ar.push("<li style='width:100%; word-break: break-all;" + (val["title"]=="我"?"background:#00FF7F;":"") + "'>" + "&nbsp;&nbsp;&nbsp;&nbsp;" + val["item"] + "</li>");
				});
				ar.push("</ul>");
				$("#feedback_list").html(ar.join(""));
				var div = document.getElementById('feedback_list');
				div.scrollTop = div.scrollHeight; 
			}else{
				$("#feedback_list").html("没有任何消息。");
			}
		});
	}
	
	function submit_feedback(){
		if($("#feedback_item").val()==""){
			alert("请输入要发送的信息。");
			return false;
		}
		var item = $("#feedback_item").val();
		var at = "@" + at_name;
		if(item.indexOf(at)>=0){
			item = item.replace(at, "");
		}else{
			at_username = "";
		}
		var params = {username:currUser, classID: $("#classID").val(),item:item, type: 1, refID:0, readerID: at_username};
		//alert(params);
		
		$.post(uploadURL + "/public/submit_feedback_class", params ,function(data){
			getFeedbackList();
			at_name = "";
			at_username = "";
			$("#feedback_item").val("");
			//div.scrollTop = div.scrollHeight; 
		});
	}
	
	function doCancelFeedback(id){
		if(confirm("确定要撤回这条消息吗？")){
			$.post(uploadURL + "/public/cancel_feedback_class", {ID:id} ,function(data){
				getFeedbackList();
				at_name = "";
				at_username = "";
				$("#feedback_item").val("");
				//div.scrollTop = div.scrollHeight; 
			});
		}
	}
	
	function setAtUser(att,atu){
		at_username = atu;
		at_name = att;
		$("#feedback_item").val("@" + att + " ");
		$("#feedback_item").focus();
	}

	function generateMaterials(enterID,username,cert){
		clearTimeout(timer1);
		if(confirm("确定要生成报名材料吗？")){
			$.getJSON(uploadURL + "/outfiles/generate_emergency_materials?refID=" + username + "&nodeID=" + enterID + "&certID=" + cert + "&entryForm=" + entryForm + "&keyID=2" ,function(data){
				if(data>""){
					alert("已生成文件");
					$("#material" + enterID).html("<a href='/users" + data + "?t=" + (new Date().getTime()) + "' target='_blank' title='申报材料'>" + imgFileRed + "</a>");
				}else{
					alert("没有可供处理的数据。");
				}
			});
		}
	}

	function openMaterial(path){
		clearTimeout(timer1);
		timer1=setTimeout(function(){
			window.open(path);
		},300);
	}

	function generateZip(t){
		$.getJSON(uploadURL + "/outfiles/" + (t=="p"?"generate_student_material_zip":"generate_material_zip") + "?refID=" + $("#classID").val() + "&kind=class&type=" + t, function(data){
			if(data>""){
				alert("已生成压缩包");
				getNodeInfo(nodeID);
			}else{
				alert("没有可供处理的数据。");
			}
		});
	}

	function setButton(){
		var s = $("#status").val();
		$("#save").hide();
		$("#close").hide();
		$("#open").hide();
		$("#del").hide();
		$("#doImportRef").hide();
		$("#doImport").hide();
		$("#btnClassCall").hide();
		$("#btnMockView").hide();
		$("#btnSchedule").hide();
		$("#checkStudent").hide();
		$("#generateZip").hide();
		$("#generatePhotoZip").hide();
		$("#generateEntryZip").hide();
		$("#btnClassChange").hide();
		$("#btnPaynowChange").hide();
		$("#btnRebuildStudentLesson").hide();
		$("#btnAutoSetClassSNo").hide();
		$("#btnInvoiceGroup").hide();
		$("#btnCloseStudentCourse").hide();
		$("#archived").prop("disabled",true);
		$("#btnSetSource").hide();
		// $("#className").prop("disabled",true);
		$("#courseID").prop("disabled",true);
		$("#item_btn1").hide();
		$("#item_btn2").hide();
		if(!checkRole("sniper")){
			$("#item_btn1").show();
			$("#item_btn2").show();
		}
		if(op ==1){
			setEmpty();
			$("#feedback_item").prop("disabled",true);
			$("#courseID").prop("disabled",false);
			// $("#className").prop("disabled",false);
		}else{
			$("#pre").prop("disabled",true);
			if($("#pre").val()==0){
				if(checkPermission("classAdd") && s < 2){
					$("#close").show();
					$("#btnSchedule").show();
				}
				if(checkPermission("studentAdd") && s < 2){
					$("#generateZip").show();
					$("#generatePhotoZip").show();
					$("#generateEntryZip").show();
					$("#btnClassChange").show();
					$("#btnPaynowChange").show();
					$("#btnClassCall").show();
				}
				if(checkPermission("teacherAdd") && s < 2){
					$("#save").show();
					$("#btnSchedule").show();
				}
				if(checkRole("adviser") && s < 2){
					$("#btnSchedule").show();
					$("#save").show();
				}
				if((checkPermission("classAdd")) && currHost==""){
					$("#archived").prop("disabled",false);
				}
				if((checkPermission("rebuildStudentLesson") && s < 2)){
					$("#btnRebuildStudentLesson").show();
				}
				if(checkPermission("classOpen") && s > 0){
					$("#open").show();
				}
				if(checkPermission("classAdd")){
					$("#del").show();
				}
				if(checkPermission("feedbackAdd")){
					$("#feedback_item").prop("disabled",false);
				}
				if(checkPermission("classAdd") && s < 2){
					$("#btnAutoSetClassSNo").show();
				}
				$("#btnMockView").show();
				// $("#checkStudent").show();
				if(!checkPermission("diplomaAdd")){
					$("#btnDiplomaIssue").hide();
				}
			}
			if((checkPermission("studentAdd") || checkRole("adviser")) && s < 2){
				$("#btnClassChange").show();
				$("#btnPaynowChange").show();
				$("#doImport").show();
				$("#btnCloseStudentCourse").show();
				$("#btnSetSource").show();
			}
			if(checkPermission("setInvoiceGroup")){
				$("#btnInvoiceGroup").show();
			}
		}
		if((checkPermission("studentAdd") || currHost>"") && s < 2){
			$("#save").show();
		}
	}
	
	function setEmpty(){
		$("#ID").val(0);
		$("#classID").val("");
		$("#projectID").val("");
		$("#adviserID").val("");
		$("#memo").val("");
		$("#className").val("");
		$("#transaction_id").val("");
		$("#status").val(0);
		$("#kindID").val(0);
		$("#pre").val(0);
		$("#signatureType").val(1);
		$("#classroom").val("黄兴路158号D103三楼");
		$("#dateStart").val(addDays(currDate,3) + " 8:30");
		$("#dateEnd").val("");
		$("#regDate").val(currDate);
		$("#registerID").val(currUser);
		$("#registerName").val(currUserName);
		setHostChange();
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
			<div class="comm" style="background:#f5faf8; width:48%; float:left;">
			<form id="detailCover" name="detailCover" style="width:98%;margin:1px;padding-left:2px;background:#eefaf8;">
			<table>
			<tr>
				<td align="right">开课日期</td>
				<td><input type="text" id="dateStart" class="mustFill" size="15" /></td>
				<td align="right">结课日期</td>
				<td><input type="text" id="dateEnd" size="15" />&nbsp;预计</td>
			</tr>
			<tr>
				<input id="ID" type="hidden" /><input id="status" type="hidden" /><input id="classID" type="hidden" />
				<td align="right">属性</td>
				<td><select id="host" style="width:70px;"></select>&nbsp;&nbsp;&nbsp;类别&nbsp;<select id="pre" style="width:70px;"></select></td>
				<td align="right">课程名称</td><input id="certID" type="hidden" /><input id="courseName" type="hidden" />
				<td><select id="courseID" style="width:180px;"></select></td>
			</tr>
			<tr>
				<td align="right">班级名称</td>
				<td><input type="text" class="mustFill" id="className" size="25" /></td>
				<td align="right">招生批次</td>
				<td><input type="text" id="projectID" name="projectID" size="25" /></td>
			</tr>
			<tr>
				<td align="right">学员人数</td>
				<td colspan="3">
					<input type="text" class="readOnly" readOnly="true" id="qty" size="3" />
					申报<input type="text" class="readOnly" readOnly="true" id="qtyApply"  size="3" />
					考试<input type="text" class="readOnly" readOnly="true" id="qtyExam"  size="3" />
					合格<input type="text" class="readOnly" readOnly="true" id="qtyPass"  size="3" />
					退课<input type="text" class="readOnly" readOnly="true" id="qtyReturn"  size="3" />
				</td>
			</tr>
			<tr>
				<td align="right">课程类型</td><input id="adviserName" type="hidden" />
				<td><select id="kindID" style="width:50px;"></select>&nbsp;&nbsp;签字类型&nbsp;<select id="signatureType" style="width:60px;"></select></td>
				<td align="right">上课地点</td>
				<td><input type="text" id="classroom" size="25" /></td>
			</tr>
			<tr>
				<td align="left" colspan="2"><input id="teacherName" type="hidden" />
					任课教师<select id="teacher" style="width:60px;"></select>
					&nbsp;&nbsp;班主任&nbsp;<select id="adviserID" style="width:60px;"></select>
				</td>
				<td align="right"><input class="button" type="button" id="btnSchedule" value="排课表" /></td>
				<td><input type="text" id="scheduleDate" size="10" class="readOnly" readOnly="true" />&nbsp;&nbsp;<span id="schedule" style="margin-left:10px;"></span></td>
			</tr>
			<tr>
				<td colspan="4">
					资料归档<input style="border:0px;" type="checkbox" id="archived" value="" />&nbsp;&nbsp;<input class="readOnly" type="text" id="archiverName" size="6" readOnly="true" />&nbsp;&nbsp;<input class="readOnly" type="text" id="archiveDate" size="8" readOnly="true" />
				</td>
			</tr>
			<tr>
				<td colspan="4"><input id="timetable" type="hidden" />
					<span id="photo" style="margin-left:10px;"></span>
					<span id="refundList" style="margin-left:10px;"></span>
					<span id="archive" style="margin-left:10px;"></span>
					<span id="sign" style="margin-left:10px;"></span>
					<span id="sign1" style="margin-left:10px;"></span>
					<span id="zip" style="margin-left:10px;"></span>
					<span id="pzip" style="margin-left:10px;"></span>
					<span id="ezip" style="margin-left:10px;"></span>
				</td>
			</tr>
			<tr>
				<td align="right">
					工作小结<br />
					<div class="comm" align="center"><input class="button" type="button" id="btnSummary" value="..." /></div>
				</td>
				<td colspan="5"><textarea id="summary" style="padding:2px;width:100%;" rows="8"></textarea></td>
			</tr>
			<tr>
				<td align="right">开课通知</td>
				<td colspan="5">
					次数&nbsp;<input class="readOnly" type="text" id="send" size="2" readOnly="true" />&nbsp;&nbsp;
					日期&nbsp;<input class="readOnly" type="text" id="sendDate" size="6" readOnly="true" />&nbsp;&nbsp;
					发送人&nbsp;<input class="readOnly" type="text" id="senderName" size="5" readOnly="true" />&nbsp;&nbsp;
				</td>
			</tr>
			<tr>
				<td align="right">申报标号</td>
				<td colspan="3"><input type="text" id="transaction_id" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="right">备注</td>
				<td colspan="3"><input type="text" id="memo" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="right">登记人</td>
				<td><input class="readOnly" readOnly="true" type="text" id="registerName" size="25" /></td>
				<td align="right">登记日期</td>
				<td><input class="readOnly" type="text" id="regDate" size="25" readOnly="true" /></td>
			</tr>
			</table>
			</form>
			</div>
			<div class="comm" style="background:#f5f5f5; width:48%; float:left;">
			<form id="feedback" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
			<table>
			<tr>
				<td align="right" colspan="2" style="width:100%;"><div id="feedback_list" style="width:500px; height:453px;float:left;border:2px solid #888;padding:5px 10px;overflow:auto;"></div></td>
			</tr>
			<tr>
				<td style="background:#f5f5ff;"><input class="mustFill" type="text" id="feedback_item" style="width:450px; height:30px;" /></td>
				<td><input class="button" type="button" id="btn_feedback_submit" value="发送" /></td>
			</tr>
			</table>
			</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
  	<input class="button" type="button" id="save" value="保存" />&nbsp;&nbsp;
  	<input class="button" type="button" id="close" value="结束" />&nbsp;&nbsp;
  	<input class="button" type="button" id="open" value="开启" />&nbsp;&nbsp;
  	<input class="button" type="button" id="del" value="删除" />&nbsp;&nbsp;
	<input class="button" type="button" id="doImportRef" value="石化预报名表" />
	<input class="button" type="button" id="doImport" value="报名表导入" />&nbsp;&nbsp;
	<input class="button" type="button" id="checkStudent" value="报名表核对" />
	<input class="button" type="button" id="generateZip" value="生成归档压缩包" />&nbsp;&nbsp;
	<input class="button" type="button" id="generatePhotoZip" value="生成资料压缩包" />&nbsp;&nbsp;
	<input class="button" type="button" id="generateEntryZip" value="生成报名表压缩包" />&nbsp;&nbsp;
	<a href="output/学员报名表模板.xlsm">报名表模板</a>

	<div style="width:100%;float:left;margin:10;height:4px;"></div>
	<div style="width:100%;float:left;margin:0;">
		<div id="item_btn1" style="border:solid 1px #e0e0e0;width:99%;margin:5px;background:#ffffff;line-height:18px;padding-left:20px;">
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnSel" value="全选/取消" /></span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnClassChange" value="更换班级" /></span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnPaynowChange" value="更换支付" /></span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnClassCall" value="开课通知" /></span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnClassAlert" value="进度提醒" /></span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnClassExamDeny" value="不考试通知" /></span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnAttentionLogin" value="登录通知" /></span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnAttentionPhoto" value="照片通知" /></span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnAttentionSignature" value="签名通知" /></span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnAttentionPhotoClose" value="照片确认" /></span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnAttentionSignatureClose" value="签名确认" /></span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnRebuildStudentLesson" value="刷新课表" /></span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnDiplomaIssue" value="培训证书" /></span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnFireScore" value="消防成绩" /></span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnAutoSetClassSNo" value="调整学号" /></span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnInvoiceGroup" value="团体发票" /></span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnCloseStudentCourse" value="关/开课程" /></span>
		</div>
		<div id="item_btn2">
			学习进度&nbsp;&lt;=<input type="text" id="s_completion2" size="2" />%
			&nbsp;&nbsp;模拟成绩&nbsp;&lt;=<input type="text" id="s_score2" size="2" />
			&nbsp;&nbsp;销售&nbsp;<select id="fromID" style="width:80px;"></select>
			&nbsp;&nbsp;属性&nbsp;<select id="partner" style="width:70px"></select>
			&nbsp;&nbsp;考试&nbsp;<select id="examResult" style="width:60px;"></select>
			&nbsp;&nbsp;<input class="button" type="button" id="btnFindStudent" value="查找" />&nbsp;&nbsp;
			&nbsp;&nbsp;<input style="border:0px;" type="checkbox" id="showPhoto" value="" />&nbsp;显示照片和签名&nbsp;&nbsp;
			&nbsp;&nbsp;<input class="button" type="button" id="btnDownload" value="名单下载" />
			&nbsp;&nbsp;<input class="button" type="button" id="btnSetSource" value="来源设置" />
			<span id="btnMockView">&nbsp;&nbsp;模拟考试汇总</span>
			<span id="btnMockDetail">&nbsp;&nbsp;模拟考试明细</span>
		</div>
	</div>
	<hr size="1" noshadow />
	<div id="cover" style="float:top;background:#f8fff8;">
	</div>
  </div>
</div>
</body>
