<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="edge" />
<!-- InstanceBeginEditable name="doctitle" -->
<title><%=pageTitle%></title>
<!-- InstanceEndEditable -->
<!-- InstanceBeginEditable name="head" -->
<!-- InstanceEndEditable -->

<link href="css/style_main.css?ver=1.15"  rel="stylesheet" type="text/css" />
<link type="text/css" href="css/jquery-ui-1.7.2.custom.css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="css/minimalTabs.css">
<link href="css/data_table.css" rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/ddaccordion.css">
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
	<link rel="stylesheet" href="css/tab-view.css?v=1.0" type="text/css" media="screen">
        <link rel="stylesheet" href="css/jquery.tabs.css" type="text/css" media="print, projection, screen">
        <!-- Additional IE/Win specific style sheet (Conditional Comments) -->
        <!--[if lte IE 7]>
        <link rel="stylesheet" href="css/jquery.tabs-ie.css" type="text/css" media="projection, screen">
        <![endif]-->
<link rel="stylesheet" type="text/css" href="css/fullcalendar.min.css">
<link rel="stylesheet" type="text/css" href="css/fullcalendar.print.css" media="print">
		<link href="css/tabStyle.css" rel="stylesheet" type="text/css">
	<link href="css/bootstrap-3.3.4.css" rel="stylesheet">
<link href="css/jquery.alerts.css?v=1.1" rel="stylesheet" type="text/css" media="screen" />
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/default/easyui.css?v=1.11">
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.21">
		<script src="js/jquery-1.7.2.min.js" type="text/javascript"></script>
	<script type="text/javascript" src="js/easyui/jquery.easyui.min.js?v=1.23"></script>
	<script type="text/javascript" src="js/easyui/locale/easyui-lang-zh_CN.js?v=1.0"></script>
	<script type="text/javascript" src="js/echarts.min.js"></script>
        <script src="js/jquery.tabs.pack.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js?v=1.0"></script>
<script type="text/javascript" src="js/moment.min.js"></script>
<script type="text/javascript" src="js/fullcalendar.min.js"></script>
<script type="text/javascript" src="js/zh-cn.js"></script>
<script src="js/jquery.alerts.js?v=1.2" type="text/javascript"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
	<script type="text/javascript" src="js/ajax.js"></script>
	<script type="text/javascript" src="js/tab-view.js"></script>
	<script type="text/javascript" src="js/bootstrap-treeview.min.js"></script>
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var seeAll = 0;
	var dMark = 0;
	var dUser = "";
	var sWhere = "";
	var sTitle = "";
	var dKind = "";
	let currSales = "";
	var iEditMemo = 0;	//检测是否有备忘录更新
	var iSelProject = [0,0,0,0,0,0,0,0,0];	//指定项目展开属性(共计8个属性)
	
	<!--#include file="js/commFunction.js"-->
	<!--#include file="feedbackListIncReady.js"-->
	<!--#include file="messageListIncReady.js"-->
	<!--#include file="studentListIncReady.js"-->
	<!--#include file="diplomaListIncReady.js"-->
	<!--#include file="diplomaLastListIncReady.js"-->
	<!--#include file="certListIncReady.js"-->
	<!--#include file="courseListIncReady.js"-->
	<!--#include file="certCourseListIncReady.js"-->
	<!--#include file="courseLessonListIncReady.js"-->
	<!--#include file="examListIncReady.js"-->
	<!--#include file="examRuleListIncReady.js"-->
	<!--#include file="videoListIncReady.js"-->
	<!--#include file="coursewareListIncReady.js"-->
	<!--#include file="knowPointListIncReady.js"-->
	<!--#include file="questionListIncReady.js"-->
	<!--#include file="userListIncReady.js"-->
	<!--#include file="deptListIncReady.js"-->
	<!--#include file="hostListIncReady.js"-->
	<!--#include file="agencyListIncReady.js"-->
	<!--#include file="studentNeedDiplomaListIncReady.js"-->
	<!--#include file="issuedDiplomaListIncReady.js"-->
	<!--#include file="projectListIncReady.js"-->
	<!--#include file="generateDiplomaListIncReady.js"-->
	<!--#include file="generateStudentListIncReady.js"-->
	<!--#include file="generateScoreListIncReady.js"-->
	<!--#include file="generateMaterialListIncReady.js"-->
	<!--#include file="classListIncReady.js"-->
	<!--#include file="enterListIncReady.js"-->
	<!--#include file="generatePasscardListIncReady.js"-->
	<!--#include file="generateApplyListIncReady.js"-->
	<!--#include file="rptStudentIncReady.js"-->
	<!--#include file="rptTrainningIncReady.js"-->
	<!--#include file="rptDiplomaIncReady.js"-->
	<!--#include file="rptDiplomaLastIncReady.js"-->
	<!--#include file="rptOtherIncReady.js"-->
	<!--#include file="studentPreListIncReady.js"-->
	<!--#include file="rptSalesIncReady.js"-->
	<!--#include file="rptPayInvoiceIncReady.js"-->
	<!--#include file="chartsIncomeIncReady.js"-->
	<!--#include file="teacherListIncReady.js"-->

	unitListLong = 0;
	memoListLong = 0;
	checkListLong = 0;
	grantListLong = 0;
	taskListLong = 0;
  
	$(document).ready(function (){
		$.ajaxSetup({ 
			async: false 
		}); 
		currPage = "homePage";
		$("#currUser").html(currUserName);
		//setCurrMenuItem();
		//写登录日志
		//setOpLog("login",23,'','');
		$('#container-1').tabs({ 
			fxAutoHeight: true
		});
		$('#calendar').fullCalendar({
			header: {
				left: 'prev,next today',
				center: 'title',
				right: 'month,agendaWeek,agendaDay'
			},
			height:400,
			defaultDate: currDate,
			editable: true,
			eventLimit: true, // allow "more" link when too many events
			eventSources: "newsControl.asp?op=getCalenderData",
	    eventClick: function(event) {
	        if (event.url) {
	            //window.open(event.url,"_blank");
	            showMemoInfo(event.url,0,3);
	            return false;
	        }
	    },
	    //eventColor: '#378006',
	    eventTextColor: '#ffffff'
		});

		//$('form').jqTransform({imgPath:'images/jqtransform/'});
		$("#resetPassword").click(function(){
			showUserPasswdInfo();
		});
		$("#mTab1").click(function(){
			if(iEditMemo > 0){
				$("#calendar").fullCalendar("refetchEvents");
				iEditMemo = 0;
			}
		});
		
		$("#c_notice").click(function(){
			$('#container-1').triggerTab(7);
			getDocList();
		});
		
		$("#c_memo").click(function(){
			resetTabs();
			$("a[name='#tab2']").attr("id","current"); // Activate this
			$("#tab2").fadeIn(); // Show content for current tab
			getMemoList();
		});
		$("#c_message").click(function(){
			resetTabs();
			$("a[name='#tab3']").attr("id","current"); // Activate this
			$("#tab3").fadeIn(); // Show content for current tab
			getMessageList();
		});
		$("#c_grant").click(function(){
			resetTabs();
			$("a[name='#tab4']").attr("id","current"); // Activate this
			$("#tab4").fadeIn(); // Show content for current tab
			getGrantList();
		});
		$("#c_task").click(function(){
			resetTabs();
			$("a[name='#tab5']").attr("id","current"); // Activate this
			$("#tab5").fadeIn(); // Show content for current tab
			getTaskList();
		});
		
		$("#changePasswd").click(function(){
			showUserPasswdInfo();
		});
		
		$("#signOut").click(function(){
			//if(currUser == 'undefined' || currUser == null || currUser == ""){
			//	window.parent.open('default.asp?event=logout&msg=" + escape("因长时间未使用，系统已关闭，请重新登录，本次签退操作不成功。") + "&times=' + (new Date().getTime()),'_self');
			//}else{
				window.parent.open('default.asp?times=' + (new Date().getTime()),'_self');
			//}
		});
		
		$("#compress").click(function(){
			//showCropperInfo('users/upload/students/photos/120107196604032113.png','120107196604032113',"",0,1);
			/*
			$.get(uploadURL + "/public/getPDF2img2?path=users/upload/students/diplomas/C1-22-01352.pdf",function(data){
				//alert(data[0]["error"]["code"]);
				jAlert(uploadURL);
			});
			$.getJSON(uploadURL + "/outfiles/compressImages?path=users/upload/students/photos",function(data){
				jAlert(data);
			});*/
			// showSignatureInfo(33612);
			window.open("test_pay.asp", "_blank");
		});
		
		window.setInterval(function () {
			chkUserActive();
			//refreshMsg();
    	}, 30000);
		document.getElementById("lightFloat").style.display="none";
		document.getElementById("fadeFloat").style.display="none";
		$('#container-1').triggerTab(0); // disables third tab
		//alert(checkPermission("examBrowse") + currUser);
		if(!checkPermission("examBrowse")){
			$("#menu5").hide();
			deleteTab("试卷管理");
		}
		//if(!checkPermission("classBrowse")){
		if(currHost > ""){	//公司的人看不到班级
			$("#menu9").hide();
			$("#menu10").hide();
			$("#menu12").hide();
			$("#menu2").hide();
			deleteTab("统计图表");
			deleteTab("招生概况");
			// deleteTab("收费概况");
			deleteTab("收费发票");
		}else{
			$("#menu11").hide();
			$("#menu2").hide();
		}
		if(currUser=="desk." || checkRole("adviser") || checkRole("operator")){
			$("#menu11").show();
		}
		if(currHost > ""){	//集团用户不使用导入报名表, 照片批量上传，成绩导入功能
			$("#generateStudent_Tab").hide();
			$("#tab3").hide();
			$("#generateScore_Tab").hide();
			$("#tab4").hide();
			$("#generatePhoto_Tab").hide();
			$("#tab5").hide();
		}
		if(!checkPermission("courseAdd")){
			deleteTab("视频管理");
			deleteTab("课件管理");
			deleteTab("知识点");
		}
		if(currUser != "desk."){
			$("#compress").hide();
		}
		if(checkRole("partner")){
			$("#menu4").hide();		//课程
			$("#menu3").hide();		//证书
			$("#menu6").hide();		//统计
			$("#menu11").hide();	//预报名
			$("#menu9").show();		//班级
			$("#menu10").show();	//报名
			$("#menu12").show();	//考试
			deleteTab("收费记录");
			deleteTab("发票管理");
			deleteTab("考试管理");
		}
		// if(checkRole("saler")){
		// 	$("#menu2").hide();
		// 	$("#menu3").hide();
		// 	$("#menu4").hide();
		// 	$("#menu5").hide();
		// 	$("#menu11").hide();
		// 	$("#menu12").hide();
		// 	deleteTab("发票管理");
		// }
		if(!checkRole("leader") && !checkRole("saler") && currUser != "desk."){
		}
			deleteTab("收费概况");
		if(checkRole("saler")){
			currSales = currUser;
		}
		if(currUser == "amra." || currUser == "jiacaiyun."){
			deleteTab("收费发票");
			deleteTab("学员注册");
			deleteTab("证书获取");
			deleteTab("证书到期");
			deleteTab("其他报表");
			deleteTab("收费记录");
			deleteTab("发票管理");
			$("#menu1").hide();
			$("#menu3").hide();
			$("#menu4").hide();
			$("#menu7").hide();
			$("#menu12").hide();
			$("#generatePhoto_Tab").hide();
			$("#generateScore_Tab").hide();
			$("#generateStudent_Tab").hide();
			$("#rptDaily_Tab").hide();
			$("#feedback_Tab").hide();
			$("#mTab1").hide();
			$("#project_Tab").hide();
			$("#project_Tab").hide();
			$("#content").hide();
		}
		if(currUser == "jiacaiyun."){
			$("#menu01").hide();
			$("#menu6").hide();
			$("#menu10").hide();
		}
		if(checkRole("emergency")){
			$("#menu6").hide();		//统计
		}
        deleteTab("日结报表");
        deleteTab("花名册");
		<!--#include file="commLoadFileReady.asp"-->
	    refreshMsg();
	});

	function refreshMsg(){
		//getFeedbackList();
	}

	function showList(title,where,f){
		if(where>""){
			if(f != ""){
				sWhere = where + "='" + f + "'";
			}else{
				sWhere = where;
			}
			sTitle = title;
			//alert(sWhere);
			$("#hTitle").val(title);
			$("#hWhere").val(sWhere);
			$("#floatTitle").html("<h4>" + title + "</h4>");
			$("#floatTab").load("floatUserList.asp?sWhere=" + escape(sWhere) + "&times=" + (new Date().getTime()));
			document.getElementById("lightFloat").style.display="block";
			document.getElementById("fadeFloat").style.display="block";
		}
	}

	function showListDetail(){
		sTitle = $("#hTitle").val();
		sWhere = $("#hWhere").val();
		//alert(sTitle + "  " + sWhere);
		window.open("userManagement.asp?sWhere=" + escape(sWhere) + "&tLen=" + sTitle.length + "&sTitle=" + escape(sTitle) + "&times=" + (new Date().getTime()),"_self")
	}

	function showBaseData(id){
		window.open("baseDataManagement.asp?nodeID=" + escape(id) + "&tLen=" + id.length + "&times=" + (new Date().getTime()),"_self")
	}

	function showChart(id){
		asyncbox.open({
			url:'archiveChart.asp?nodeID=' + id + '&p=1&times=' + (new Date().getTime()),
			title: '统计图表',
　　　width : 780,
　　　height : 500
		});
	}
	
	function mSubstr(str,slen)
	{ 
		var tmp = 0;
		var len = 0;
		var okLen = 0;
		for(var i=0;i<slen;i++)
		{
			if(str.charCodeAt(i)>255){
				tmp += 2;
			}else{
				len += 1;
			}
			okLen += 1;
			if(tmp + len == slen) 
			{
				return (str.substring(0,okLen));
				break;
			}
			if(tmp + len > slen)
			{
				return (str.substring(0,okLen - 1)); 
				break;
			}
		}
	}

</script>

</head>

<body>
<div id="layout">
	<div id="header">
	<h1>SLC NAC</h1>
	</div>
 <!--#include file='commFloatDetail.asp' -->
 <!--#include file='commLoadFileDetail.asp' -->

 <!-- InstanceBeginEditable name="EditRegion" -->

	<table border="0" cellpadding="0" cellspacing="0" valign="top" width="100%">
		<tr>
			<td valign="top" style="height:400px; text-align: left;">
				<div id="container-1" align="left">
					<ul class="tabs-nav">
						<li id="menu0"><a href="#fragment-0"><span>我的事务</span></a></li>
						<li id="menu1"><a href="#fragment-1"><span>学员管理</span></a></li>
						<li id="menu11"><a href="#fragment-11"><span>预报名管理</span></a></li>
						<li id="menu10"><a href="#fragment-10"><span>报名管理</span></a></li>
						<li id="menu9"><a href="#fragment-9"><span>班级管理</span></a></li>
						<li id="menu2"><a href="#fragment-2"><span>预报名管理</span></a></li>
						<li id="menu12"><a href="#fragment-12"><span>考试申报</span></a></li>
						<li id="menu3"><a href="#fragment-3"><span>证书管理</span></a></li>
						<li id="menu4"><a href="#fragment-4"><span>课程管理</span></a></li>
						<li id="menu5"><a href="#fragment-5"><span>题库管理</span></a></li>
						<li id="menu6"><a href="#fragment-6"><span>统计报表</span></a></li>
						<li id="menu7"><a href="#fragment-7"><span>用户管理</span></a></li>
					</ul>
					<div id="fragment-0">
						<div align="center" style="width:480px; text-align: center;"><h4></h4></div>
						<div class="urbangreymenu" style="width:14%;float:left;">
							<h3 class="headerbar">信息提示</h3>
							<ul class="submenu">
							<li id="c_notice"></li>
							<li id="c_message"></li>
							<li id="c_memo"></li>
							<li id="c_checkFlow"></li>
							<li id="c_task"></li>
							<li id="c_grant"></li>
							<li id="c_borrow">&nbsp;</li>
							<li>&nbsp;</li>
							<li>&nbsp;</li>
							<li>&nbsp;</li>
							</ul>
							<div class="comm" style="background:#fcfccc;border:solid 1px gray;width:60%;">
								<div style="margin: 2px 5px;" id="c_total"></div>
								<div style="margin: 2px 5px;" id="c_prepare"></div>
								<div style="margin: 2px 5px;" id="c_inBox"></div>
								<div style="margin: 2px 5px;" id="c_inStore"></div>
								<div style="margin: 2px 5px;" id="c_exp"></div>
								<div style="margin: 2px 5px;" id="c_disposal"></div>
							</div>
							<div class="comm" align='left' style="background:#fdfdfd;padding-top:10px;">
								<div>当前用户：<span style="color:gray;" id="currUser"></span></div>
								<div style="align:center; padding:10px;"><input class="button" type="button" id="changePasswd" value=" 修改密码 "></div>
								<div style="align:center; padding:10px;"><input class="button" type="button" id="signOut" value=" 退出 "></div>
								<div style="align:center; padding:10px;"><input class="button" type="button" id="compress" value=" 压缩照片 "></div>
							</div>
						</div>
						<div id="minialDiv" style="width:85%;float:right;">
							<ul id="tabs">
							    <li id="project_Tab"><a href="#" name="#tab0">招生计划</a></li> 
							    <li id="mTab1"><a href="#" name="#tab1">学员反馈</a></li>
							    <li id="feedback_Tab"><a href="#" name="#tab2">回复信息</a></li>
							    <li id="generateStudent_Tab"><a href="#" name="#tab3">学员报名</a></li> 
							    <li id="generateScore_Tab"><a href="#" name="#tab4">成绩导入</a></li> 
							    <li id="generatePhoto_Tab"><a href="#" name="#tab5">图片上传</a></li> 
							</ul>
							
							<div id="content"> 
							    <div id="tab0"><!--#include file="projectListIncDetail.js"--></div>
							    <div id="tab1"><!--#include file="feedbackListIncDetail.js"--></div>
							    <div id="tab2"><!--#include file="messageListIncDetail.js"--></div>
							    <div id="tab3"><!--#include file="generateStudentListIncDetail.js"--></div>
							    <div id="tab4"><!--#include file="generateScoreListIncDetail.js"--></div>
							    <div id="tab5"><!--#include file="generateMaterialListIncDetail.js"--></div>
							</div>
						</div>
						<script type="text/javascript">
					
					    function resetTabs(){
					        $("#content > div").hide(); //Hide all content
					        $("#tabs a").attr("id",""); //Reset id's      
					    }
					
					    var myUrl = window.location.href; //get URL
					    var myUrlTab = myUrl.substring(myUrl.indexOf("#")); // For localhost/tabs.html#tab2, myUrlTab = #tab2     
					    var myUrlTabName = myUrlTab.substring(0,4); // For the above example, myUrlTabName = #tab
					
					    (function(){
					        $("#content > div").hide(); // Initially hide all content
					        $("#tabs li:first a").attr("id","current"); // Activate first tab
					        $("#content > div:first").fadeIn(); // Show first tab content
					        
					        $("#tabs a").on("click",function(e) {
					            e.preventDefault();
					            if ($(this).attr("id") == "current"){ //detection for current tab
					             return       
					            }
					            else{             
					            resetTabs();
					            $(this).attr("id","current"); // Activate this
					            $($(this).attr('name')).fadeIn(); // Show content for current tab
					            }
					        });
					
					        for (i = 1; i <= $("#tabs li").length; i++) {
					          if (myUrlTab == myUrlTabName + i) {
					              resetTabs();
					              $("a[name='"+myUrlTab+"']").attr("id","current"); // Activate url tab
					              $(myUrlTab).fadeIn(); // Show url tab content        
					          }
					        }
					    })()
					  </script>
					</div>
					
					<div id="fragment-1">
						<!--#include file="studentListIncDetail.js"-->
					</div>
					
					<div id="fragment-10">
						<!--#include file="enterListIncDetail.js"-->
					</div>
					
					<div id="fragment-9">
						<!--#include file="classListIncDetail.js"-->
					</div>
					
					<div id="fragment-2">
						
					</div>
					
					<div id="fragment-11">
						<!--#include file="studentPreListIncDetail.js"-->
					</div>
					
					<div id="fragment-3">
						<div id="dhtmlgoodies_tabView3">
							<div id="dtab21" class="dhtmlgoodies_aTab">
								<!--#include file="studentNeedDiplomaListIncDetail.js"-->
							</div>
							<div id="dtab22" class="dhtmlgoodies_aTab">
								<!--#include file="generateDiplomaListIncDetail.js"-->
							</div>
							<div id="dtab24" class="dhtmlgoodies_aTab">
								<!--#include file="issuedDiplomaListIncDetail.js"-->
							</div>
							<div id="dtab20" class="dhtmlgoodies_aTab">
								<!--#include file="diplomaListIncDetail.js"-->
							</div>
							<div id="dtab23" class="dhtmlgoodies_aTab">
								<!--#include file="diplomaLastListIncDetail.js"-->
							</div>
						</div>
						<script type="text/javascript">
							initTabs('dhtmlgoodies_tabView3',Array("证书制作","证书打印","证书发放","证书查询","换证提醒"),0,1260,400);
						</script>
					</div>
					
					<div id="fragment-12">
						<div id="dhtmlgoodies_tabView12">
							<div id="dtab121" class="dhtmlgoodies_aTab">
								<!--#include file="generatePasscardListIncDetail.js"-->
							</div>
							<div id="dtab122" class="dhtmlgoodies_aTab">
								<!--#include file="generateApplyListIncDetail.js"-->
							</div>
						</div>
						<script type="text/javascript">
							initTabs('dhtmlgoodies_tabView12',Array("考试管理","申报管理"),0,1260,400);
						</script>
					</div>
					
					<div id="fragment-4">
						<div id="dhtmlgoodies_tabView4">
							<div id="dtab0" class="dhtmlgoodies_aTab">
								<div style="float:left;width:72%;">
									<!--#include file="certListIncDetail.js"-->
								</div>
								<div style="float:right;width:27%;">
									<!--#include file="certCourseListIncDetail.js"-->
								</div>
							</div>
							<div id="dtab1" class="dhtmlgoodies_aTab">
								<div style="float:left;width:55%;">
									<!--#include file="courseListIncDetail.js"-->
								</div>
								<div style="float:right;width:44%;">
									<!--#include file="courseLessonListIncDetail.js"-->
								</div>
							</div>
							<div id="dtab2" class="dhtmlgoodies_aTab">
								<!--#include file="videoListIncDetail.js"-->
							</div>
							<div id="dtab3" class="dhtmlgoodies_aTab">
								<!--#include file="coursewareListIncDetail.js"-->
							</div>
							<div id="dtab4" class="dhtmlgoodies_aTab">
								<!--#include file="knowPointListIncDetail.js"-->
							</div>
							<div id="dtab5" class="dhtmlgoodies_aTab">
								<div style="float:left;width:65%;">
									<!--#include file="examListIncDetail.js"-->
								</div>
								<div style="float:right;width:34%;">
									<!--#include file="examRuleListIncDetail.js"-->
								</div>
							</div>
							<div id="dtab6" class="dhtmlgoodies_aTab">
								<!--#include file="agencyListIncDetail.js"-->
							</div>
							<div id="dtab7" class="dhtmlgoodies_aTab">
								<!--#include file="hostListIncDetail.js"-->
							</div>
							<div id="dtab8" class="dhtmlgoodies_aTab">
								<!--#include file="deptListIncDetail.js"-->
							</div>
						</div>
						<script type="text/javascript">
							initTabs('dhtmlgoodies_tabView4',Array("认证项目","培训课程","视频管理","课件管理","知识点","试卷管理","认证机构","公司单位","公司部门"),0,1260,400);
						</script>
					</div>
					
					<div id="fragment-5">
						<!--#include file="questionListIncDetail.js"-->
					</div>
					
					<div id="fragment-6">
						<div id="dhtmlgoodies_tabView6">
							<div id="dtab61" class="dhtmlgoodies_aTab">
								<!--#include file="rptTrainningIncDetail.js"-->
							</div>
							<div id="dtab69" class="dhtmlgoodies_aTab">
								<!--#include file="rptSalesIncDetail.js"-->
							</div>
							<div id="dtab67" class="dhtmlgoodies_aTab">
								<!--#include file="chartsIncomeIncDetail.js"-->
							</div>
							<div id="dtab68" class="dhtmlgoodies_aTab">
								<!--#include file="rptPayInvoiceIncDetail.js"-->
							</div>
							<div id="dtab60" class="dhtmlgoodies_aTab">
								<!--#include file="rptStudentIncDetail.js"-->
							</div>
							<div id="dtab62" class="dhtmlgoodies_aTab">
								<!--#include file="rptDiplomaIncDetail.js"-->
							</div>
							<div id="dtab63" class="dhtmlgoodies_aTab">
								<!--#include file="rptDiplomaLastIncDetail.js"-->
							</div>
							<div id="dtab64" class="dhtmlgoodies_aTab">
								<!--#include file="rptOtherIncDetail.js"-->
							</div>
						</div>
						<script type="text/javascript">
							initTabs('dhtmlgoodies_tabView6',Array("收费日报","销售日报","收费概况","收费发票","学员注册","证书获取","证书到期","其他报表"),0,1260,400);
						</script>
					</div>
					
					
					<div id="fragment-7">
						<div id="dhtmlgoodies_tabView7">
							<div id="dtab71" class="dhtmlgoodies_aTab">
								<!--#include file="userListIncDetail.js"-->
							</div>
							<div id="dtab72" class="dhtmlgoodies_aTab">
								<!--#include file="teacherListIncDetail.js"-->
							</div>
						</div>
						<script type="text/javascript">
							initTabs('dhtmlgoodies_tabView7',Array("用户管理","教师管理"),0,1260,400);
						</script>
					</div>
				</div>
			</td>
		</tr>
	</table>
<input type="hidden" id="hTitle" value="" />
<input type="hidden" id="hWhere" value="" />
<div class="clear"></div>
<!-- InstanceEndEditable -->

 <!--#include file="js/mainFooter.js" -->

</div>
  
</body>
<!-- InstanceEnd --></html>
