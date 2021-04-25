
	var need_username = "";
	$(document).ready(function (){
		var ar = new Array();
		ar.push("<div id='need_btn' style='padding-left:30px; margin:3px;'><input class='button' type='button' id='btnPrintNeed' style='border:1px solid #FF8888;' value='  打印  ' /></div>");
		ar.push("<div id='need_print'>");
		ar.push("</div");
		//$("#needCover").html("<div id='need_btn'></div><div id='need_print'><div id='needTitle' style='margin: 10px;'></div><div id='needSkill' style='margin: 10px;'></div><div id='needEducation' style='margin: 10px;'></div><div id='needJob' style='margin: 10px;'></div></div>");
		$("#needCover").html(ar.join(""));
		//getNeed(id);  //id:username
		$("#btnPrintNeed").click(function(){
			needPrint();
		});
		//$("body").attr('style',{'margin':0});	//打印时去掉页眉页脚
	});

	function getNeed2know(id){
		$.getJSON(uploadURL + "/public/getNeed2knowByEnterID?refID=" + id,function(data){
			//jAlert(unescape(data));
			var c = "";
			var arr = new Array();
			if(data.length>0){
				var val = data[0];
				arr.push('<div style="position: relative;">');
				arr.push('<div style="position: absolute; z-index:10; width:100%;">');
				arr.push('<div style="float:left;width:10%;">');
				arr.push('	<img src="/users/upload/companies/logo/znxf.png" style="width:93px;padding-top:10px;padding-left:20px;">');
				arr.push('</div>');
				arr.push('<div style="float:right;width:89%;">');
				arr.push('	<div style="text-align:center;"><h3>上海智能消防学校</h2></div>');
				arr.push('	<div style="text-align:center;"><h2>学员须知</h1></div>');
				arr.push('</div>');
				arr.push('<div style="clear: both;"></div>');
				arr.push('<hr size=1 color="red">');
				arr.push('<div style="float:left;width:100%;">');
				arr.push('	<table style="width:100%; padding-left:10px;">');
				arr.push('		<tr>');
				arr.push('			<td width="25%"><h3>姓&nbsp;名：</h3></td>');
				arr.push('			<td class="foot" width="25%"><h3>' + val["name"] + '</h3></td>');
				arr.push('			<td width="25%" align="right"><h3>性&nbsp;别：</h3></td>');
				arr.push('			<td class="foot" width="25%"><h3>' + val["sexName"] + '</h3></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td><h3>身份证号：</h3></td>');
				arr.push('			<td class="foot" colspan="3"><h3>' + val["username"] + '</h3></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td><h3>考生标识：</h3></td>');
//					arr.push('			<td class="foot"><h3>' + val["startDate"].replace(/-/g,"") + fillFormat(k,2,"0",0) + '</h3></td>');
				arr.push('			<td class="foot"><h3>' + val["passNo"] + '</h3></td>');
				arr.push('			<td align="right"><h3>密&nbsp;码：</h3></td>');
//					arr.push('			<td class="foot"><h3>' + val["username"].substr(12,6) + '</h3></td>');
				arr.push('			<td class="foot"><h3>' + val["password"] + '</h3></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td><h3>考试时间：</h3></td>');
				arr.push('			<td class="foot" colspan="3"><h3>' + val["startDate"] + '&nbsp;&nbsp;' + val["startTime"] + '</h3></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td><h3>考试地点：</h3></td>');
				arr.push('			<td class="foot" colspan="3"><h3>' + val["address"] + '</h3></td>');
				arr.push('		</tr>');
				arr.push('		<tr>');
				arr.push('			<td><h3>注意事项：</h3></td>');
				arr.push('			<td colspan="3"><h3>' + val["notes"] + '</h3></td>');
				arr.push('		</tr>');
				arr.push('	</table>');
				arr.push('</div>');
				arr.push('</div>');
				arr.push('</div>');
				$("#need_print").html(arr.join(""));
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