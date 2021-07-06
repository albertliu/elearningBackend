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

<link href="css/style_main.css?ver=1.12"  rel="stylesheet" type="text/css" />
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
		<script src="js/jquery-1.7.2.min.js" type="text/javascript"></script>
        <script src="js/jquery.tabs.pack.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js?v=1.0"></script>
<script type="text/javascript" src="js/moment.min.js"></script>
<script type="text/javascript" src="js/fullcalendar.min.js"></script>
<script type="text/javascript" src="js/zh-cn.js"></script>
<script src="js/jquery.alerts.js?v=1.0" type="text/javascript"></script>
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
	var iEditMemo = 0;	//检测是否有备忘录更新
	var iSelProject = [0,0,0,0,0,0,0,0,0];	//指定项目展开属性(共计8个属性)
	
	<!--#include file="js/commFunction.js"-->
	<!--#include file="feedbackListIncReady.js"-->
	<!--#include file="messageListIncReady.js"-->
	<!--#include file="studentListIncReady.js"-->
	<!--#include file="studentCourseListIncReady.js"-->
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
	<!--#include file="payListIncReady.js"-->
	<!--#include file="invoiceListIncReady.js"-->
	<!--#include file="generatePasscardListIncReady.js"-->
	<!--#include file="generateApplyListIncReady.js"-->
	<!--#include file="rptStudentIncReady.js"-->
	<!--#include file="rptTrainningIncReady.js"-->
	<!--#include file="rptDiplomaIncReady.js"-->
	<!--#include file="rptDiplomaLastIncReady.js"-->

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
		$("#c_borrow").click(function(){
			$('#container-1').triggerTab(5);
			getArchiveBorrowList();
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
			$.getJSON(uploadURL + "/outfiles/compressImages?path=users/upload/students/photos",function(data){
				jAlert(data);
			});
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
		}else{
			$("#menu2").hide();
			//$("#menu3").hide();
		}
		
		if(currHostKind==0 && currHost > ""){	//集团用户不使用导入报名表, 照片批量上传，成绩导入功能
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
		
	    refreshMsg();
	});

	function refreshMsg(){
		getFeedbackList();
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

 <!-- InstanceBeginEditable name="EditRegion" -->

	<table border="0" cellpadding="0" cellspacing="0" valign="top" width="100%">
		<tr>
			<td valign="top" style="height:400px; text-align: left;">
				<div id="container-1" align="left">
					<ul class="tabs-nav">
						<li><a href="#fragment-0"><span>我的事务</span></a></li>
						<li><a href="#fragment-1"><span>学员管理</span></a></li>
						<li id="menu2"><a href="#fragment-2"><span>培训报名</span></a></li>
						<li id="menu10"><a href="#fragment-10"><span>报名管理</span></a></li>
						<li id="menu9"><a href="#fragment-9"><span>班级管理</span></a></li>
						<li id="menu3"><a href="#fragment-3"><span>证书管理</span></a></li>
						<li><a href="#fragment-4"><span>课程管理</span></a></li>
						<li id="menu5"><a href="#fragment-5"><span>题库管理</span></a></li>
						<li><a href="#fragment-6"><span>统计报表</span></a></li>
						<li><a href="#fragment-7"><span>用户管理</span></a></li>
						<li><a href="#fragment-8"><span>基础数据</span></a></li>
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
							    <li id="project_Tab"><a href="#" name="#tab0">招生通知</a></li> 
							    <li id="mTab1"><a href="#" name="#tab1">学员反馈</a></li>
							    <li><a href="#" name="#tab2">回复信息</a></li>
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
					
					<div id="fragment-2">
						<!--#include file="studentCourseListIncDetail.js"-->
					</div>
					
					<div id="fragment-10">
						<div id="dhtmlgoodies_tabView10">
							<div id="dtab101" class="dhtmlgoodies_aTab">
								<!--#include file="enterListIncDetail.js"-->
							</div>
							<div id="dtab104" class="dhtmlgoodies_aTab">
								<!--#include file="generatePasscardListIncDetail.js"-->
							</div>
							<div id="dtab106" class="dhtmlgoodies_aTab">
								<!--#include file="generateApplyListIncDetail.js"-->
							</div>
							<div id="dtab102" class="dhtmlgoodies_aTab">
								<!--#include file="payListIncDetail.js"-->
							</div>
							<div id="dtab103" class="dhtmlgoodies_aTab">
								<!--#include file="invoiceListIncDetail.js"-->
							</div>
							<div id="dtab105" class="dhtmlgoodies_aTab">
							</div>
						</div>
						<script type="text/javascript">
							initTabs('dhtmlgoodies_tabView10',Array("报名记录","考试管理","申报管理","收费记录","发票管理","日结报表"),0,960,400);
						</script>
					</div>
					
					<div id="fragment-9">
						<div id="dhtmlgoodies_tabView9">
							<div id="dtab91" class="dhtmlgoodies_aTab">
								<!--#include file="classListIncDetail.js"-->
							</div>
							<div id="dtab92" class="dhtmlgoodies_aTab">
							</div>
						</div>
						<script type="text/javascript">
							initTabs('dhtmlgoodies_tabView9',Array("班级列表","花名册"),0,960,400);
						</script>
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
							initTabs('dhtmlgoodies_tabView3',Array("证书制作","证书打印","证书发放","证书查询","换证提醒"),0,960,400);
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
							initTabs('dhtmlgoodies_tabView4',Array("认证项目","培训课程","视频管理","课件管理","知识点","试卷管理","认证机构","公司单位","公司部门"),0,960,400);
						</script>
					</div>
					
					<div id="fragment-5">
						<!--#include file="questionListIncDetail.js"-->
					</div>
					
					<div id="fragment-6">
						<div id="dhtmlgoodies_tabView6">
							<div id="dtab60" class="dhtmlgoodies_aTab">
								<!--#include file="rptStudentIncDetail.js"-->
							</div>
							<div id="dtab61" class="dhtmlgoodies_aTab">
								<!--#include file="rptTrainningIncDetail.js"-->
							</div>
							<div id="dtab62" class="dhtmlgoodies_aTab">
								<!--#include file="rptDiplomaIncDetail.js"-->
							</div>
							<div id="dtab63" class="dhtmlgoodies_aTab">
								<!--#include file="rptDiplomaLastIncDetail.js"-->
							</div>
						</div>
						<script type="text/javascript">
							initTabs('dhtmlgoodies_tabView6',Array("学员注册","学员培训","证书发放","证书到期"),0,960,400);
						</script>
					</div>
					
					
					<div id="fragment-7">
						<!--#include file="userListIncDetail.js"-->
					</div>
					
					<div id="fragment-8">
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
