﻿<!--#include file="js/doc.js" -->

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
<style>
@font-face {
	font-family: 'qyt';
	src: url('fonts/QYSXT-Regular.ttf') format('truetype');
	font-weight: normal;
	font-style: normal;
}
</style>
<script language="javascript">
	var nodeID = 0;
	var op = 0;
	var refID = 0;
	var updateCount = 1;
	var k = 0;
	var sign = "";
	var reex = 0;
	var course = "";
	var sDate = "";
	var price = 0;
	var courseID = "";
	let unit = "";
	<!--#include file="js/commFunction.js"-->
	<!--#include file="need2know.js"-->
	<!--#include file="agreement.js"-->
	<!--#include file="materials_emergency.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";		//enterID
		refID = "<%=refID%>";		//username
		keyID = "<%=keyID%>";		//0 预览  1 打印  2 文件  5 仅报名表文件
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 
		$("#print").click(function(){
			resumePrint();
		});
		if(keyID==5){
			$("#keyItem4").hide();
			$("#resume_print").css("display", "flex");
		}else{
			$("#keyItem5").hide();
			// $("#keyItem6").hide();
			$("#keyItem7").hide();
		}
		// if(keyID>1){
			$("#pageTitle").hide();
		// }
		// getNeed2know(nodeID);
		getNodeInfo(nodeID, refID);
	});

	function getNodeInfo(id,ref){
		$.get("studentCourseControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > "0"){
				$("#SNo").html(ar[25] + "&nbsp;&nbsp;班级：" + ar[34]);
				$("#C" + ar[36]).prop("checked",true);
				$("#R" + ar[40]).prop("checked",true);
				//$("#reexamine").html(ar[41]);
				//$("#courseName").html(ar[6]);
				
				sign = (ar[52]==1?ar[48]:"");
				reex = ar[40];
				course = ar[56];
				sDate = ar[49];
				price = ar[53];
				if(ar[39] != 'spc' && ar[39] != 'shm'){
					unit = ar[37];
				}else{
					unit = ar[12];
				}
				$("#unit").html(unit);
				// courseID = ar[5];
				$("#date2").html("&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp");
				$("#date2M").html("&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp");
				$("#date2D").html("&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp");
				$("#f_sign40").hide();
				
				if(sign>""){
					//$("#f_sign1").attr("src","/users" + sign + "?times=" + (new Date().getTime()));
					$("#f_sign20").attr("src","/users" + sign + "?times=" + (new Date().getTime()));
					// $("#f_sign40").attr("src","/users/upload/companies/stamp/sign_znxf.png?times=" + (new Date().getTime()));
					let date1 = new Date(sDate).format("yyyy.MM.dd");
					$("#date").html(date1.substr(0,4));
					$("#dateM").html(date1.substr(5,2));
					$("#dateD").html(date1.substr(8,2));
					var arr = new Array();
					arr.push('<div style="position: relative;width:100%;height:80%;">');
					arr.push('<div style="position: absolute; z-index:10;">');
					arr.push('<div style="float:left;">');
					arr.push('	<span style="padding-left:150px;"><img src="/users/upload/companies/stamp/station_znxf.png" style="width:150px;padding-top:840px;opacity:0.7;"></span>');
					arr.push('</div>');
					arr.push('</div>');
					arr.push('</div>');
					// $("#stampCover").html(arr.join(""));
					//$("#date2").html(sDate);
					// $("#date2").html(new Date(addDays(sDate,3)).format("yyyy.M.d"));
				}else{
					//$("#f_sign1").hide();
					$("#f_sign20").hide();
					$("#f_sign40").hide();
					$("#date").html("&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp");
					$("#dateM").html("&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp");
					$("#dateD").html("&nbsp;&nbsp;&nbsp;&nbsp&nbsp;&nbsp");
				}
			}else{
				//alert("没有找到要打印的内容。");
				return false;
			}
		});
		$.get("studentControl.asp?op=getNodeInfo&nodeID=0&refID=" + ref + "&times=" + (new Date().getTime()),function(re){
			//alert(ref + ":" + unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#username").html(ar[1]);
				$("#name").html(ar[2]);
				$("#sexName").html(ar[8]);
				$("#mobile").html(ar[7]);
				$("#age").html(ar[9]);
				$("#job").html(ar[18]);
				//$("#phone").html(ar[17]);
				$("#job").html(ar[18]);
				// if(ar[29]=="znxf"){
				// 	$("#unit").html(ar[35] + "." + ar[36]);
				// }else{
				// 	if(keyID ==3){
				// 		$("#unit").html(ar[12]);
				// 	}else{
				// 		$("#unit").html(ar[12] + "." + ar[13] + "." + ar[14]);
				// 	}
				// }
				$("#educationName").html(ar[31]);
				$("#birthday").html(ar[33].substr(0,7));
				$("#address").html(ar[34]);
				$("#ethnicity").html(ar[37]);
				$("#IDdate").html(ar[40] + (ar[40]>"" && ar[41]==""? "<br>长期":"<br>" + ar[41]));
				if(ar[1].length==18){
					$("#IDK0").prop("checked",true);
				}else{
					$("#IDK1").prop("checked",true);
				}
				if(ar[21] > ""){
					$("#img_photo").attr("src","/users" + ar[21]);
				}else{
					$("#img_photo").attr("src","images/blank_photo.png");
				}
				if(ar[22] > ""){
					$("#img_cardA").attr("src","/users" + ar[22]);
				}else{
					$("#img_cardA").attr("src","images/blank_cardA.png");
					//$("#f_sign1").hide();
				}
				if(sign=="" || ar[22] == ""){
					//$("#same1").hide();
				}
				if(ar[23] > ""){
					$("#img_cardB").attr("src","/users" + ar[23]);
				}else{
					$("#img_cardB").attr("src","images/blank_cardB.png");
				}
				if(keyID ==5){
					$("#img_A").attr("src","/users" + ar[22]);
					$("#img_B").attr("src","/users" + ar[23]);
					// $("#img_E").attr("src","/users" + ar[24]);
					$("#img_F").attr("src","/users" + ar[44]);
					// if(reex == 0){	//初训报名表显示学历
					// }
				}
				//$("#date").html(currDate);
				var p = 0;
				k = 1;
				if(keyID == 5){
					//上传的报名表不打印附件
				}else{
					if(keyID<2){
						getNeed2know(nodeID);
						getAgreement(ar[1],ar[2],course,sign,sDate,price);
					}
					if(keyID != 4){
						getMaterials(ar[1],sign,p,k);
					}
				}
				if(keyID == 4){
					getAgreement(ar[1],ar[2],course,"","",price);	//无签名
				}
				if(keyID==1){
					resumePrint();
				}
			}else{
				alert("没有找到要打印的内容。");
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
			//window.parent.asyncbox.close("enterInfo");
			window.parent.getStudentCourseList(refID);
			window.parent.$.close("enterInfo");
			//refreshMsg();
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
		<div id="pageTitle" style="text-align:center;">
			<input class="button" type="button" id="print" value="打印" />&nbsp;
		</div>
		<div id="resume_print" style="border:none;width:100%;margin:1px;background:#ffffff;line-height:18px;">
			<div style="position: relative;width:800px;height:99%;">
				<div style="position: absolute; z-index:10;">
					<div style='text-align:center; margin:10px 0 20px 0;'><h3 style='font-size:1.45em;'>上海市高危行业负责人及安全生产管理人员安全知识和管理能力</h3></div>
					<div style='text-align:center; margin:10px 0 20px 0;'><h3 style='font-size:1.45em;'>考核申请表</h3></div>
					<div style='text-align:left; margin:10px 0 15px 30px;'>
						<span style='font-size:1.5em; font-family: 幼圆;'>申请考试类别：<input type="checkbox" id="R0" />&nbsp;初证 <input type="checkbox" id="R1" />&nbsp;复审</span>
						<span style='font-size:1.2em; padding-left:50px;'>学员编号：</span><span style='font-size:1.2em;' id="SNo"></span>
					</div>
					<table class='table_resume' style='width:99%;'>
					<tr>
						<td align="center" class='table_resume_title' width='15%' height='65px'>姓名</td><td align="center" width='13%'><p style='font-size:1em;' id="name"></p></td>
						<td align="center" class='table_resume_title' width='10%'>性别</td><td align="center" width='10%'><p style='font-size:1em;' id="sexName"></p></td>
						<td align="center" class='table_resume_title' width='13%'>出生年月</td><td class='table_resume_title' width='14%'><p style='font-size:1em;' id="birthday"></p></td>
						<td rowspan="4" colspan="2" align="center" class='table_resume_title' width='20%'>
							<img id="img_photo" src="" value="" style='width:100px;border:none;' />
						</td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' width='15%' height='65px'>国籍</td><td align="center" width='13%'><p style='font-size:1em;'>中国</p></td>
						<td align="center" class='table_resume_title' width='10%'>民族</td><td align="center" width='10%'><p style='font-size:1em;' id="ethnicity"></p></td>
						<td align="center" class='table_resume_title' width='13%'>文化程度</td><td class='table_resume_title' width='14%'><p style='font-size:1em;' id="educationName"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='65px'>证件类型</td><td align="center" colspan="3"><input type="checkbox" id="IDK0" />&nbsp;身份证 <input type="checkbox" />&nbsp;军官证 <input type="checkbox" />&nbsp;护照 <input type="checkbox" id="IDK1" />&nbsp;其他</td>
						<td align="center" class='table_resume_title'>证件有效期</td><td class='table_resume_title' width='14%'><p style='font-size:1em;' id="IDdate"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='65px'>证件号码</td><td align="center" colspan="5"><p style='font-size:1em;' id="username"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='65px'>工作单位</td><td align="center" colspan="3"><p style='font-size:1em;' id="unit"></p></td>
						<td align="center" class='table_resume_title'>从事岗位</td><td align="center" colspan="3"><p style='font-size:1em;' id="job"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='65px'>联系地址</td><td align="center" colspan="3"><p style='font-size:1em;' id="address"></p></td>
						<td align="center" class='table_resume_title'>联系方式</td><td align="center" colspan="3"><p style='font-size:1em;' id="mobile"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='200px'>申请考试<br>项目</td>
						<td align="left" colspan="7" style="line-height:30px;">
							<input type="checkbox" />&nbsp;危险化学品生产单位主要负责人 <input type="checkbox" />&nbsp;&nbsp;&nbsp;危险化学品生产单位安全生产管理人员<br/>
							<input type="checkbox" id="CC16" />&nbsp;危险化学品经营单位主要负责人 <input type="checkbox" id="CC17" />&nbsp;&nbsp;&nbsp;危险化学品经营单位安全生产管理人员<br/>
							<input type="checkbox" />&nbsp;金属冶炼（炼钢）单位主要负责人 <input type="checkbox" />&nbsp;金属冶炼（炼钢）单位安全生产管理人员<br/>
							<input type="checkbox" />&nbsp;金属冶炼（炼铁）单位主要负责人 <input type="checkbox" />&nbsp;金属冶炼（炼铁）单位安全生产管理人员<br/>
						</td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='140px;'>注意事项</td>
						<td align="left" colspan="7" style="padding-left:5px;line-height:30px;">
							<p style='font-size:1em;'>&nbsp;&nbsp;&nbsp;&nbsp;本人承诺所提供资料真实完整有效，如因提供资料虚假而产生相关影响，由本人承担全部责任。</p>
							<div style="display:table-cell;height:50px;vertical-align:middle;text-align:center">
								<span style='font-size:1.2em;padding-left:180px;'>申请人（签名）：</span>
								<span><img id="f_sign20" src="" style="max-width:150px;max-height:40px;padding-left:0px;"></span>
								<span id="date" style='font-size:1.5em;padding-left:10px;padding-top:20px;color:#555;font-family:"qyt","Ink Free";'></span>
								<span style='font-size:1.2em;'>年</span>
								<span id="dateM" style='font-size:1.5em;padding-top:20px;color:#555;font-family:"qyt","Ink Free";'></span>
								<span style='font-size:1.2em;'>月</span>
								<span id="dateD" style='font-size:1.5em;padding-top:20px;color:#555;font-family:"qyt","Ink Free";'></span>
								<span style='font-size:1.2em;'>日</span>
							</div>
						</td>
					</tr>
					<tr id="keyItem1">
						<td align="left" class='table_resume_title' height='80px' colspan="8">
							<div style="display:table-cell;height:80px;vertical-align:middle;text-align:left;">
								<div><p style='font-size:1.2em;'>考试点审查意见：</p></div>
								<div style="display:table-cell;vertical-align:middle;text-align:left;">
									<span style='font-size:1.2em;padding-left:130px;'>考试点（盖章）：</span>
									<span style='font-size:1.2em;padding-left:70px;'>经办人（签名）：</span>
									<span style='font-size:1.2em;'><img id="f_sign40" src="" style="width:100px;padding-left:0px;"></span>
									<span id="date2" style='padding-left:90px;font-size:1.4em;color:#555;font-family:"Aa跃然体","时光沙漏";'></span>
									<span style='font-size:1.2em;'>年</span>
									<span id="date2M" style='font-size:1.4em;color:#555;font-family:"Aa跃然体","时光沙漏";'></span>
									<span style='font-size:1.2em;'>月</span>
									<span id="date2D" style='font-size:1.4em;color:#555;font-family:"Aa跃然体","时光沙漏";'></span>
									<span style='font-size:1.2em;'>日</span>
								</div>
							</div>
						</td>
					</tr>
					</table>
				</div>
				<div id="stampCover"></div>
			</div>
			<div id="keyItem4">
				<div id="needCover"></div>
				<div id="agreementCover"></div>
				<div id="materialsCover"></div>
			</div>
			<div id="keyItem5" style="flex:1; text-align:center; width:800px;padding-left:20px;">
				<div><img id="img_A" src="" value="" style="max-width:800px;max-height:500px;padding-top:20px;" /></div>
				<div><img id="img_B" src="" value="" style="max-width:800px;max-height:500px;padding-top:20px;" /></div>
			</div>
			<div id="keyItem7" style="text-align:center; width:800px;padding-left:20px;">
				<div><img id="img_F" src="" value="" style="max-width:800px;max-height:980px;padding-top:20px;" /></div>
			</div>
		</div>
	</div>
</div>
</body>
