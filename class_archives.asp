<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css?v=1.2"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css?v=1.8.6">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/data_table_mini.css?v=20150411" rel="stylesheet" type="text/css" />
<link href="css/jquery-confirm.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="css/jquery.autocomplete.css" />
<script language="javascript" src="js/jquery-1.12.4.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js?v=1.8.6"></script>
<script src="js/jquery-confirm.js" type="text/javascript"></script>
<script type="text/javascript" src="js/asyncbox.v1.5.min.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<script src="js/jQuery.print.js" type="text/javascript"></script>
<script type='text/javascript' src='js/jquery.autocomplete.js'></script>
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var nodeID = 0;
	var refID = "";
	var kindID = "";
	var updateCount = 1;
    var certID = "";
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";		//ID
		keyID = "<%=keyID%>";		//0 预览  1 打印
		kindID = "<%=kindID%>";		//A 申报班  B 培训班
		
		$.ajaxSetup({ 
			async: false 
		}); 
		$("#print").click(function(){
			resumePrint();
		});
		getNodeInfo(nodeID);
	});

	function getNodeInfo(id){
		$.get("classControl.asp?op=getNodeInfoArchive&nodeID=" + id + "&kindID=" + kindID + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			var x = 0;
			var qty = 0;
			if(ar > ""){
				$("#home_classID").html(ar[1]);
				$("#home_adviser").html(ar[7]);
				$("#home_certName").html(ar[3]);
				$("#home_reexamine").html(ar[4]);
				$("#home_startDate").html(ar[5].substring(0,10) + "&nbsp;至&nbsp;" + ar[6]);
				$("#dateEnd").html(ar[6]);
				$("#classID").html(ar[1] + "&nbsp;&nbsp;[" + ar[0] + "]");
				qty = ar[8] - ar[9];
				$("#qty").html(qty);
				$("#summary").html(ar[12].replace(/\n/g,"<br/>"));
				$("#qtyExam").html(nullNoDisp(ar[10]));
				$("#qtyPass").html(nullNoDisp(ar[11]));
				$("#attendanceRate").html('%' + nullNoDisp(ar[12]));
				$("#home_transaction_id").html(nullNoDisp(ar[2]));
				x = ar[10];
				if(x > 0 && ar[11] > 0){
					x = (ar[11]*100/ar[10]).toFixed(2) + "&nbsp;%";
				}else{
					x = "%";
				}
				$("#pass_rate_exam").html(x);
				x = qty;
				if(x > 0 && ar[11] > 0){
					x = (ar[11]*100/qty).toFixed(2) + "&nbsp;%";
				}else{
					x = "%";
				}
				$("#pass_rate_training").html(x);

				$.get("classControl.asp?op=getClassSchedule&refID=" + nodeID + "&kindID=" + kindID + "&times=" + (new Date().getTime()),function(data1){
					//alert(unescape(data1));
					var ar2 = new Array();
					ar2 = (unescape(data1)).split("%%");
					$("#scheduleCover").empty();
					var arr1 = [];		
					//cn = ar2[0].split("|")[21];
					arr1.push("<table cellpadding='0' cellspacing='0' border='1' width='99%'>");
					arr1.push("<tr align='center'>");
					arr1.push("<td align='center' width='9%' height='35px'>培训职业（工种）</td>");
					arr1.push("<td align='center' width='20%' colspan='3'>" + ar[3] + "</td>");
					arr1.push("<td align='center' width='10%'>开班日期 </td>");
					arr1.push("<td align='center' width='10%'>" + ar[5].substring(0,10) + "</td>");
					arr1.push("<td align='center' width='8%'>结业日期</td>");
					arr1.push("<td align='center' width='10%'>" + ar[6] + "</td>");
					arr1.push("<td align='center' width='20%'>所属区县</td>");
					arr1.push("<td align='center' width='15%'>杨浦</td>");
					arr1.push("</tr>");
					arr1.push("<tr align='center'>");
					arr1.push("<td align='center' width='9%' height='35px'>班级编号</td>");
					arr1.push("<td align='center' width='8%' colspan='3'>" + ar[1] + "</td>");
					arr1.push("<td align='center' width='6%'>培训人数 </td>");
					arr1.push("<td align='center' width='8%'>" + qty + "</td>");
					arr1.push("<td align='center' width='6%'>班主任</td>");
					arr1.push("<td align='center' width='8%'>" + ar[7] + "</td>");
					arr1.push("<td align='center' width='8%'>开班号（申报批号）</td>");
					arr1.push("<td align='center' width='8%'>" + ar[2] + "</td>");
					arr1.push("</tr>");
					arr1.push("<tr align='center'>");
					arr1.push("<td align='center' width='9%' height='35px'>课次</td>");
					arr1.push("<td align='center' width='8%'>上课日期</td>");
					arr1.push("<td align='center' width='4%'>星期</td>");
					arr1.push("<td align='center' width='8%'>时段</td>");
					arr1.push("<td align='center' width='10%'>上课时间</td>");
					arr1.push("<td align='center' width='10%'>课时</td>");
					arr1.push("<td align='center' width='8%'>上课类型</td>");
					arr1.push("<td align='center' width='10%'>授课教师</td>");
					arr1.push("<td align='center' width='20%'>授课内容</td>");
					arr1.push("<td align='center' width='15%'>上课地点</td>");
					arr1.push("</tr>");
					
					if(ar2>""){
						$.each(ar2,function(iNum,val){
							var ar3 = new Array();
							ar3 = val.split("|");
							arr1.push("<tr>");
							arr1.push("<td align='center' height='35px'>" + ar3[3] + "</td>");
							arr1.push("<td align='center'>" + ar3[9] + "</td>");
							arr1.push("<td align='center'>" + ar3[10] + "</td>");
							arr1.push("<td align='center'>" + ar3[15] + "</td>");
							arr1.push("<td align='center'>" + ar3[8] + "</td>");
							arr1.push("<td align='center'>" + ar3[7] + "</td>");
							arr1.push("<td align='center'>" + ar3[14] + "</td>");
							arr1.push("<td align='center'>" + ar3[16] + "</td>");
							arr1.push("<td align='center'>" + ar3[11] + "</td>");
							arr1.push("<td align='center'>" + ar3[12] + "</td>");
							arr1.push("</tr>");/**/
						});
					}
					arr1.push("</table>");
					$("#scheduleCover").html(arr1.join(""));
					arr1 = [];
				});
				
				$.get("classControl.asp?op=getStudentListByClassID&refID=" + nodeID + "&kindID=" + kindID + "&times=" + (new Date().getTime()),function(data2){
					//alert(unescape(data2));
					var ar4 = new Array();
					ar4 = (unescape(data2)).split("%%");
					$("#studentCover").empty();
					var arr2 = [];			
					var h = "";
					$("#date_studentList").html(ar[5].substring(0,10));
					$("#title_studentList").html(ar[1] + "培训学员花名册");
					arr2.push("<table cellpadding='0' cellspacing='0' border='1' width='99%'>");
					arr2.push("<tr align='center'>");
					arr2.push("<td align='center' width='9%' height='35px'>学号</td>");
					arr2.push("<td align='center' width='8%'>姓名</td>");
					arr2.push("<td align='center' width='6%'>性别</td>");
					arr2.push("<td align='center' width='18%'>证件号码</td>");
					arr2.push("<td align='center' width='10%'>学历</td>");
					arr2.push("<td align='center' width='30%'>工作单位</td>");
					arr2.push("<td align='center' width='14%'>联系电话</td>");
					arr2.push("</tr>");
					var i = 0;
					
					if(ar4>""){
						$.each(ar4,function(iNum,val){
							var ar5 = new Array();
							ar5 = val.split("|");
							i += 1;
							arr2.push("<tr>");
							arr2.push("<td align='center' height='35px'>" + ar5[4] + "</td>");
							arr2.push("<td align='center'>" + ar5[1] + "</td>");
							arr2.push("<td align='center'>" + ar5[2] + "</td>");
							arr2.push("<td align='center'>" + ar5[0] + "</td>");
							arr2.push("<td align='center'>" + ar5[13] + "</td>");
							arr2.push("<td>" + ar5[6] + "</td>");
							arr2.push("<td align='center'>" + ar5[5] + "</td>");
							arr2.push("</tr>");
						});
					}
					arr2.push("</table>");
					$("#studentCover").html(arr2.join(""));
					arr2 = [];

					$("#date_scoreList").html(ar[5].substring(0,10));
					$("#adviser_scoreList").html(ar[7]);
					$("#title_scoreList").html(ar[1] + "培训学员成绩册");
					arr2.push("<table cellpadding='0' cellspacing='0' border='1' width='100%'>");
					arr2.push("<tr align='center'>");
					arr2.push("<td align='center' width='10%' height='35px'>学号</td>");
					arr2.push("<td align='center' width='8%'>姓名</td>");
					arr2.push("<td align='center' width='6%'>性别</td>");
					arr2.push("<td align='center' width='18%'>证件号码</td>");
					arr2.push("<td align='center' width='10%'>学历</td>");
					arr2.push("<td align='center' width='24%'>工作单位</td>");
					arr2.push("<td align='center' width='14%'>联系电话</td>");
					arr2.push("<td align='center' width='6%'>应知</td>");
					arr2.push("<td align='center' width='6%'>应会</td>");
					arr2.push("</tr>");
					var i = 0;
					
					if(ar4>""){
						$.each(ar4,function(iNum,val){
							var ar5 = new Array();
							ar5 = val.split("|");
							i += 1;
							arr2.push("<tr>");
							arr2.push("<td align='center' height='35px'>" + ar5[4] + "</td>");
							arr2.push("<td align='center'>" + ar5[1] + "</td>");
							arr2.push("<td align='center'>" + ar5[2] + "</td>");
							arr2.push("<td align='center'>" + ar5[0] + "</td>");
							arr2.push("<td align='center'>" + ar5[13] + "</td>");
							arr2.push("<td>" + ar5[6] + "</td>");
							arr2.push("<td align='center'>" + ar5[5] + "</td>");
							h = (ar5[7] || ar5[10]).replace(".00","");
							if(h=="" || h==0){
								h = "";
							}
							arr2.push("<td align='center'>" + h + "</td>");
							arr2.push("<td align='center'>" + ar5[11].replace(".00","") + "</td>");
							arr2.push("</tr>");
						});
					}
					arr2.push("</table>");
					$("#scoreCover").html(arr2.join(""));
					arr2 = [];

					$("#title_onlineList").html(ar[1] + "在线学习课时统计");
					arr2.push("<table cellpadding='0' cellspacing='0' border='1' width='100%'>");
					arr2.push("<tr align='center'>");
					arr2.push("<td align='center' width='10%' height='35px'>学号</td>");
					arr2.push("<td align='center' width='8%'>姓名</td>");
					arr2.push("<td align='center' width='6%'>性别</td>");
					arr2.push("<td align='center' width='18%'>证件号码</td>");
					arr2.push("<td align='center' width='10%'>总课时</td>");
					arr2.push("<td align='center' width='24%'>完成率%</td>");
					arr2.push("<td align='center' width='14%'>完成课时</td>");
					arr2.push("<td align='center' width='14%'>开始日期</td>");
					arr2.push("</tr>");
					var i = 0;
					
					if(ar4>""){
						$.each(ar4,function(iNum,val){
							var ar6 = new Array();
							ar6 = val.split("|");
							i += 1;
							arr2.push("<tr>");
							arr2.push("<td align='center' height='35px'>" + ar6[4] + "</td>");
							arr2.push("<td align='center'>" + ar6[1] + "</td>");
							arr2.push("<td align='center'>" + ar6[2] + "</td>");
							arr2.push("<td align='center'>" + ar6[0] + "</td>");
							arr2.push("<td align='center'>" + ar6[14] + "</td>");
							arr2.push("<td align='center'>" + nullNoDisp(ar6[15]) + "</td>");
							arr2.push("<td align='center'>" + nullNoDisp(ar6[16]) + "</td>");
							arr2.push("<td align='center'>" + ar6[17] + "</td>");
							arr2.push("</tr>");
						});
					}
					arr2.push("</table>");
					$("#onlineCover").html(arr2.join(""));

					if(keyID==1){
						resumePrint();
					}
				});
			}else{
				//alert("没有找到要打印的内容。");
				return false;
			}
		});

	}

	function resumePrint(){
		$("#resume_print").print({
			//Use Global styles
			globalStyles : true,
			//Add link with attrbute media=print
			mediaPrint : false,
			//Custom stylesheet
			stylesheet : "",
			//Print in a hidden iframe
			iframe : true,
			//Don't print this
			noPrintSelector : ".no-print",
			//Add this at top
			prepend : "",
			//Add this on bottom
			append : "<br/>"
		});
		window.setTimeout(function () {
			//window.parent.getStudentCourseList(refID);
			if(kindID=="B"){
				window.parent.$.close("classInfo");
			}
			if(kindID=="A"){
				window.parent.$.close("generateApplyInfo");
			}
		}, 1000);
	}

	function getUpdateCount(){
		return updateCount;
	}
</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
	
	<div style="width:100%;float:left;margin:0;">
		<div style="text-align:center;">
			<input class="button" type="button" id="print" value="打印" />&nbsp;
		</div>
		<div id="resume_print" style="border:none;width:100%;margin:1px;background:#ffffff;line-height:18px;padding-left:20px;">
			<div style='text-align:center; margin:150px 0 0 0;'><h3 style='font-size:3em;'>班级管理表册</h3></div>
			<table style="margin:300px 0 0 40px; width:85%;">
			<tr>
				<td style="width:30%; height:60px; text-align:right; vertical-align: bottom; font-size:1.8em;">培训机构</td><td style="width:65%; border-bottom: #333333 1px solid; font-size:1.8em; vertical-align: bottom; padding-left:15px;">上海智能消防学校</td><td style="width:5%; text-align:left; vertical-align: bottom; font-size:1.8em;">（章）</td>
			</tr>
			<tr>
				<td style="width:30%; height:60px; text-align:right; vertical-align: bottom; font-size:1.8em;">班级编号</td><td colspan="2" style="width:65%; border-bottom: #333333 1px solid; font-size:1.7em; vertical-align: bottom; padding-left:15px;" id="home_classID"></td>
			</tr>
			<tr>
				<td style="width:30%; height:60px; text-align:right; vertical-align: bottom; font-size:1.8em;">&nbsp;&nbsp;&nbsp;&nbsp;标&nbsp;&nbsp;&nbsp;&nbsp;号</td><td colspan="2" style="width:65%; border-bottom: #333333 1px solid; font-size:1.8em; vertical-align: bottom; padding-left:15px;" id="home_transaction_id"></td>
			</tr>
			<tr>
				<td style="width:30%; height:60px; text-align:right; vertical-align: bottom; font-size:1.8em;">培训职业</td><td colspan="2" style="width:65%; border-bottom: #333333 1px solid; font-size:1.8em; vertical-align: bottom; padding-left:15px;" id="home_certName"></td>
			</tr>
			<tr>
				<td style="width:30%; height:60px; text-align:right; vertical-align: bottom; font-size:1.8em;">培训等级</td><td colspan="2" style="width:65%; border-bottom: #333333 1px solid; font-size:1.8em; vertical-align: bottom; padding-left:15px;" id="home_reexamine"></td>
			</tr>
			<tr>
				<td style="width:30%; height:60px; text-align:right; vertical-align: bottom; font-size:1.8em;">班&nbsp;主&nbsp;任</td><td colspan="2" style="width:65%; border-bottom: #333333 1px solid; font-size:1.8em; vertical-align: bottom; padding-left:15px;" id="home_adviser"></td>
			</tr>
			<tr>
				<td style="width:30%; height:60px; text-align:right; vertical-align: bottom; font-size:1.8em;">起迄日期</td><td colspan="2" style="width:65%; border: 0px; font-size:1.8em; vertical-align: bottom; padding-left:15px;" id="home_startDate"></td>
			</tr>
			</table>

			<div style="page-break-after:always"></div>

			<div style='text-align:center; margin:10px 0 0 0;'><h3 style='font-size:1.8em;'>授课计划表</h3></div>
			<div id="scheduleCover" style="float:center; margin:15px; font-size:1.2em;"></div>

			<div style="page-break-after:always"></div>

			<div style='text-align:center; margin:10px 0 0 0;'><h3 style='font-size:1.8em;' id='title_studentList'>学员花名册</h3></div>
			<div style='margin: 12px;text-align:left; width:95%;'><span style='font-size:1.2em; padding-left:10px;'>培训日期：</span><span style='font-size:1.2em;' id='date_studentList'></span><span style='font-size:1.2em; padding-left:100px;'>考试日期：</span></div>
			<div id="studentCover" style="float:center; margin:15px; font-size:1.2em;"></div>

			<div style="page-break-after:always"></div>

			<div style='text-align:center; margin:10px 0 0 0;'><h3 style='font-size:1.8em;' id='title_onlineList'>在线学习课时统计</h3></div>
			<div id="onlineCover" style="float:center; margin:15px; font-size:1.2em;"></div>

			<div style="page-break-after:always"></div>

			<div style='text-align:center; margin:10px 0 0 0;'><h3 style='font-size:1.8em;' id='title_scoreList'>学员成绩册</h3></div>
			<div style='margin: 12px;text-align:left; width:95%;'><span style='font-size:1.2em; padding-left:10px;'>培训日期：</span><span style='font-size:1.2em;' id='date_scoreList'></span><span style='font-size:1.2em; padding-left:100px;'>考试日期：</span><span style='font-size:1.2em; padding-left:100px;'>班主任：</span><span style='font-size:1.2em;' id='adviser_scoreList'></span></div>
			<div id="scoreCover" style="float:center; margin:15px; font-size:1.2em;"></div>
			
			<div style="page-break-after:always"></div>

			<div style='text-align:center; margin:10px 0 20px 0;'><h3 style='font-size:1.45em;'>培训结果统计表</h3></div>
			<div style='margin: 12px;text-align:right; width:95%;'><span style='font-size:1.2em;'>班级编号：</span><span style='font-size:1.2em;' id="classID"></span></div>
			<table class='table_resume' style='width:99%;'>
			<tr>
				<td align="center" class='table_resume_title' width='100%' height='55px;' colspan="6"><h3 style='font-size:1.25em;'>培训鉴定情况分析</h3></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='55px;'>注册人数</td><td align="center" width='16%'>出勤率</td>
				<td align="center" class='table_resume_title' width='16%'>鉴定人数</td><td align="center" width='16%'>获证人数</td>
				<td align="center" class='table_resume_title' width='18%'>鉴定合格率</td><td class='table_resume_title' width='18%'>培训合格率</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='15%' height='55px;'><p style='font-size:1em;' id="qty"></p></td><td align="right"><p style='font-size:1em;' id="attendanceRate"></p></td>
				<td align="center" class='table_resume_title' width='15%'><p style='font-size:1em;' id="qtyExam"></p></td><td align="center" width='15%'><p style='font-size:1em;' id="qtyPass"></p></td>
				<td align="right" width='18%'><p style='font-size:1em; padding-right:15px;' id="pass_rate_exam"></p></td><td align="right" width='18%'><p style='font-size:1em; padding-right:15px;' id="pass_rate_training"></p></td>
			</tr>
			<tr>
				<td align="left" class='table_resume_title' height='110px;' rowspan="2" colspan="4">
				<p style="text-align:left; padding-left:10px;font-size:1em;">
				出勤率=全体学员实际出勤总次数/全体学员应出勤总次数<br />
				鉴定合格率=获证人数/鉴定人数<br />
				培训合格率=获证人数/注册人数
				</p>
				</td>
				<td align="center" height='55px;'>统计人签名</td>
				<td align="center">日&nbsp;&nbsp;期</td>
			</tr>
			<tr>
				<td align="center" height='55px;'>&nbsp;</td>
				<td align="center"><p style='font-size:1em;' id="dateEnd"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='100%' height='55px;' colspan="6"><h4 style='font-size:1em;'>班级工作小结</h4></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='100%' height='400px;' colspan="6">
					<table cellpadding="0" cellspacing="0" width="100%">
					<tr height='345px;'><td style="border:0px;">
						<div style="float:left; padding-left:15px;"><p style="font-size:1.2em; line-height:200%; text-indent:2em; white-space:pre-wrap;" id="summary"></p></div>
					</td></tr>
					<tr height='55px;'><td style="border:0px;">
						<div style="float:left; padding-left:50%; font-size:1.15em;">班主任（签名）：</div>
					</td></tr></table>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='5%' height='150px;'>领导意见</td>
				<td align="left" class='table_resume_title' colspan="5">
					<br><br><br>
					<span style='font-size:1em;float:center;padding-right:30px;'>签名：</span>
					<span style='font-size:1em;float:right; padding-right:10px;'>年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日</span>
				</td>
			</tr>
			</table>
		</div>
	</div>
</div>
</body>
