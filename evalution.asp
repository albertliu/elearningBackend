<!--#include file="js/doc1.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title></title>

<!--必要样式-->
<link href="css/style_inner1.css?ver=1.2"  rel="stylesheet" type="text/css" id="css" />
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>

<style>
    .thisTD {
        border: 1px solid orange;
		padding:3px;
		border-left: none;
		border-top: none;
		border-right: none; /* 移除左右边框 */
		font-size: 1.2em;
    }
</style>

<script language="javascript">
	var ID = 0;
	var nodeID = "";
	var updateCount = 0;
	var uploadURL = "<%=uploadURL%>";
	var courseName = "";
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";  //ID
		// alert(nodeID)
		var ar = new Array();
		ar = nodeID.split("|");
		ID = ar[0];
		courseName = ar[1];
		$("#courseName").text(courseName);
		$.ajaxSetup({ 
			async: false 
		});

		$("#btnSave").click(function(){
			let F1 = $("input[name='F1']:checked").val();
			let F2 = $("input[name='F2']:checked").val();
			let F3 = $("input[name='F3']:checked").val();
			let F4 = $("input[name='F4']:checked").val();
			let F5 = $("input[name='F5']:checked").val();
			let F6 = $("input[name='F6']:checked").val();
			let F7 = $("input[name='F7']:checked").val();
			$.post(uploadURL + "/public/postCommInfo", {proc:"updateEvalutionFormInfo", params:{ID:nodeID,enterID:0,F1,F2,F3,F4,F5,F6,F7,memo:$("#memo").val(),registerID:""}}, function(data){
				let status = data[0]["re"];
				if(status>0){  //successed
					jAlert("提交成功","提示");
				}else{  //wrong
					jAlert("提交失败","提示");
				}
			});
			return false;
		});
	});
</script>

</head>

<body>
	<div style="display: grid; justify-items: center;">
		<div><table style="border: 0 solid gray;">
			<tr>
				<td align="left" class="thisTD">
					课程名称：
				</td>
				<td class="thisTD">
					<div id="courseName" style="font-size:1.2em; color:orange;"></div>
				</td>
			</tr>
			<tr>
				<td align="left" class="thisTD">
					教学态度：
				</td>
				<td class="thisTD">
					<input style="border:0px;" type="radio" name="F1" value="0" checked />&nbsp;好&nbsp;&nbsp;
					<input style="border:0px;" type="radio" name="F1" value="1" />&nbsp;较好&nbsp;&nbsp;
					<input style="border:0px;" type="radio" name="F1" value="2" />&nbsp;尚可&nbsp;&nbsp;
					<input style="border:0px;" type="radio" name="F1" value="3" />&nbsp;差
				</td>
			</tr>
			<tr>
				<td align="left" class="thisTD">
					教学内容：
				</td>
				<td class="thisTD">
					<input style="border:0px;" type="radio" name="F2" value="0" checked />&nbsp;好&nbsp;&nbsp;
					<input style="border:0px;" type="radio" name="F2" value="1" />&nbsp;较好&nbsp;&nbsp;
					<input style="border:0px;" type="radio" name="F2" value="2" />&nbsp;尚可&nbsp;&nbsp;
					<input style="border:0px;" type="radio" name="F2" value="3" />&nbsp;差
				</td>
			</tr>
			<tr>
				<td align="left" class="thisTD">
					教学方法：
				</td>
				<td class="thisTD">
					<input style="border:0px;" type="radio" name="F3" value="0" checked />&nbsp;好&nbsp;&nbsp;
					<input style="border:0px;" type="radio" name="F3" value="1" />&nbsp;较好&nbsp;&nbsp;
					<input style="border:0px;" type="radio" name="F3" value="2" />&nbsp;尚可&nbsp;&nbsp;
					<input style="border:0px;" type="radio" name="F3" value="3" />&nbsp;差
				</td>
			</tr>
			<tr>
				<td align="left" class="thisTD">
					教学手段：
				</td>
				<td class="thisTD">
					<input style="border:0px;" type="radio" name="F4" value="0" checked />&nbsp;好&nbsp;&nbsp;
					<input style="border:0px;" type="radio" name="F4" value="1" />&nbsp;较好&nbsp;&nbsp;
					<input style="border:0px;" type="radio" name="F4" value="2" />&nbsp;尚可&nbsp;&nbsp;
					<input style="border:0px;" type="radio" name="F4" value="3" />&nbsp;差
				</td>
			</tr>
			<tr>
				<td align="left" class="thisTD">
					讲解示范：
				</td>
				<td class="thisTD">
					<input style="border:0px;" type="radio" name="F5" value="0" checked />&nbsp;好&nbsp;&nbsp;
					<input style="border:0px;" type="radio" name="F5" value="1" />&nbsp;较好&nbsp;&nbsp;
					<input style="border:0px;" type="radio" name="F5" value="2" />&nbsp;尚可&nbsp;&nbsp;
					<input style="border:0px;" type="radio" name="F5" value="3" />&nbsp;差
				</td>
			</tr>
			<tr>
				<td align="left" class="thisTD">
					巡回指导：
				</td>
				<td class="thisTD">
					<input style="border:0px;" type="radio" name="F6" value="0" checked />&nbsp;好&nbsp;&nbsp;
					<input style="border:0px;" type="radio" name="F6" value="1" />&nbsp;较好&nbsp;&nbsp;
					<input style="border:0px;" type="radio" name="F6" value="2" />&nbsp;尚可&nbsp;&nbsp;
					<input style="border:0px;" type="radio" name="F6" value="3" />&nbsp;差
				</td>
			</tr>
			<tr>
				<td align="left" class="thisTD">
					课时完成：
				</td>
				<td class="thisTD">
					<input style="border:0px;" type="radio" name="F7" value="0" checked />&nbsp;好&nbsp;&nbsp;
					<input style="border:0px;" type="radio" name="F7" value="1" />&nbsp;较好&nbsp;&nbsp;
					<input style="border:0px;" type="radio" name="F7" value="2" />&nbsp;尚可&nbsp;&nbsp;
					<input style="border:0px;" type="radio" name="F7" value="3" />&nbsp;差
				</td>
			</tr>
			<tr>
				<td align="left" class="thisTD">
					意见与建议：
				</td>
				<td class="thisTD">
					<textarea id="memo" style="padding:2px;width:100%;" rows="5"></textarea>
				</td>
			</tr>
			<tr>
				<td>&nbsp;
				</td>
				<td align="center">
					<br />
					<input class="button" type="button" id="btnSave" value="提交" />
				</td>
			</tr>
		</table></div>
    </div>
</body>
