﻿
	var need_username = "";
	$(document).ready(function (){
		var ar = new Array();
		//ar.push("<div id='need_btn' style='padding-left:30px; margin:3px;'><input class='button' type='button' id='btnPrintNeed' style='border:1px solid #FF8888;' value='  打印  ' /></div>");
		//ar.push("<div id='need_print'>");
		//ar.push("</div");
		//$("#needCover").html("<div id='need_btn'></div><div id='need_print'><div id='needTitle' style='margin: 10px;'></div><div id='needSkill' style='margin: 10px;'></div><div id='needEducation' style='margin: 10px;'></div><div id='needJob' style='margin: 10px;'></div></div>");
		//$("#needCover").html(ar.join(""));
		
		//$("body").attr('style',{'margin':0});	//打印时去掉页眉页脚
	});

	function getNeed2know(id){
		$.getJSON(uploadURL + "/public/getNeed2knowByEnterID?refID=" + id,function(data){
			var c = "";
			var arr = new Array();
			if(data.length>0){
				var val = data[0];
	
				arr.push('<div style="position: relative;">');
				arr.push('<div style="position: absolute; z-index:10; width:100%;">');
				arr.push('<div style="float:left;width:32%;">');
				arr.push('	<span><img src="/users/upload/companies/logo/znxf.png" style="width:85px;margin:0px 0px 8px 0px;padding-left:20px;"></span>');
				arr.push('	<span><img src="" id="qr-img" style="width:110px;padding-top:8px;padding-left:20px;"></span>');
				arr.push('</div>');
				arr.push('<div style="float:left;width:50%;margin-top:20px;">');
				arr.push('	<div style="text-align:center;margin:8px 0 0 0;"><h3 style="font-size:1.4em;">上海智能消防学校</h2></div>');
				arr.push('	<div style="text-align:center;margin:15px 0 10px 0;"><h2 style="font-size:1.7em;">学员须知</h2></div>');
				arr.push('</div>');
				arr.push('<div style="float:left;width:17%;margin-top:70px;">');
				arr.push('	<div style="text-align:right;padding-right:3px;"><p style="font-size:1.3em;">编号：' + val["SNo"] + '</p></div>');
				arr.push('</div>');
				arr.push('<div style="clear: both;"></div>');
				arr.push('<hr size=1 color="gray">');
				arr.push('<div style="float:left;width:100%;">');
				arr.push('	<table style="width:100%; padding-left:10px;margin-top:25px;">');
				arr.push('		<tr>');
				arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">' + val["name"] + '同学，你好！</p></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;text-indent:30px;">欢迎参加' + val["courseName"] + '培训课程，为顺利完成学习任务，请遵守以下规定：</p></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">1. 填写报名表并签字。准备一张2寸照片，背面写上编号、姓名、部门（加油站）。</p></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">2. 到教室将上述材料一起交给老师审核，并领取教材，开始上课。</p></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">3. 不迟到不早退不大声喧哗，保持环境卫生。</p></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">4. 服从老师安排，有事请及时与老师沟通。</p></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td class="foot" colspan="4" style="height:30px;"><h3></h3></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td colspan="4" style="height:50px;"><p style="font-size:1.3em;text-indent:30px;">请扫描本页上的二维码，登录在线培训系统，用户名为身份证号码，密码默认为123456(登录后可自己修改)。</p></td>');
				arr.push('		</tr>');
				if(val["missingItems"]>""){
					arr.push('		<tr>');
					arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">&bull;&nbsp;&nbsp;您尚未填写' + val["missingItems"] + '，请尽快在"个人信息"中补充。否则可能会影响您的学习和证书办理。</p></td>');
					arr.push('		</tr>');
				}
				arr.push('		<tr>');
				arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">&bull;&nbsp;&nbsp;在"我的课程"中，可选择相关课程，进行在线学习和模拟考试。</p></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">&bull;&nbsp;&nbsp;在"个人信息"中，可上传照片、身份证、学历证书等图片。</p></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">&bull;&nbsp;&nbsp;在"我的证书"中，可查看已获得的证书。</p></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">&bull;&nbsp;&nbsp;可在"反馈"中提交反馈信息，老师将及时处理。可在“消息”中查看回复信息。</p></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td class="foot" colspan="4" style="height:30px;"><h3></h3></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">课程安排：' + val["timetable"] + '</p></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td colspan="4" style="height:30px;"><p style="font-size:1.3em;">培训地点：' + val["classroom"] + '</p></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td colspan="2" style="height:30px;width:30%;"><p style="font-size:1.3em;">班&nbsp;主&nbsp;任：' + val["adviserName"] + '</p></td>');
				arr.push('			<td colspan="2" style="height:30px;width:70%;"><p style="font-size:1.3em;">联系电话：' + val["phone"] + '</p></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td class="foot" colspan="4" style="height:50px;"><h3></h3></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td style="width:40%;"><h3></h3></td>');
				arr.push('			<td colspan="3" style="width:60%;height:20px; align:center;"><p style="font-size:1.3em;">上海智能消防学校&nbsp;&nbsp;&nbsp;&nbsp;' + currDate + '</p></td>');
				arr.push('		</tr>');
				arr.push('	</table>');
				arr.push('</div>');
				arr.push('</div>');
				arr.push('</div>');
				$("#needCover").html(arr.join(""));
				var text = uploadURL + "/public/get_user_qr?username=" + val["username"] + "&size=4";
				$("#qr-img").attr("src", text);
			}
		});
	}

	function needPrint(){
		$("#need_print").print({
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
			//prepend : "<div style='text-align:center; margin:50px 0 20px 0;'><h3 style='font-size:1.5em;'>" + need_username + "个人简历</h3></div>",
			//Add this on bottom
			append : "<br/>"
		});
	}