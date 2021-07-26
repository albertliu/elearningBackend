<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css?v=1.11"  rel="stylesheet" type="text/css" />
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
	var op = 0;
	var refID = 0;
	var updateCount = 1;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";		//enterID
		refID = "<%=refID%>";		//username
		keyID = "<%=keyID%>";		//0 预览  1 打印
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 
		$("#print").click(function(){
			resumePrint();
		});
		//getNeed2know(nodeID);
		getNodeInfo(nodeID, refID);
});

	function getNodeInfo(id,ref){
		$.get("studentCourseControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > "0"){
				$("#SNo").html(ar[25] + "&nbsp;&nbsp;班级：" + ar[34]);
			}else{
				//alert("没有找到要打印的内容。");
				return false;
			}
		});
		$.get("studentControl.asp?op=getNodeInfo&nodeID=0&refID=" + ref + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#username").html(ar[1]);
				$("#name").html(ar[2]);
				$("#sexName").html(ar[8]);
				$("#mobile").html(ar[7]);
				$("#phone").html(ar[17]);
				$("#job").html(ar[18]);
				if(ar[29]=="znxf"){
					$("#company").html(ar[35] + " ." + ar[36]);
				}else{
					$("#company").html(ar[12] + " ." + ar[13] + " ." + ar[14]);
				}
				$("#educationName").html(ar[31]);
				$("#address").html(ar[34]);
				if(ar[22] > ""){
					$("#img_cardA").attr("src","/users" + ar[22]);
				}else{
					$("#img_cardA").attr("src","images/blank_cardA.png");
				}
				$("#date").html(currDate);
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
			window.parent.getStudentCourseLists(refID);
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
		<div style="text-align:center;">
		<input class="button" type="button" id="print" value="打印" />&nbsp;
		</div>
		<div id="resume_print" style="border:none;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div style='margin: 20px;text-align:center;'><h2 style='font-size:1.3em;'>上海智能消防学校</h2></div>
			<div style='text-align:center; margin:10px 0 20px 0;'><h3 style='font-size:1.45em;'>重点岗位消防安全培训学员信息采集表</h3></div>
			<div style='margin: 12px;text-align:left; width:95%;'><span style='font-size:1.2em;'>学员编号：</span><span style='font-size:1.2em;' id="SNo"></span></div>
			<table class='table_resume' style='width:95%;'>
			<tr>
				<td align="center" class='table_resume_title' width='15%' height='60px;'>学员姓名</td><td align="center" width='35%'><p style='font-size:1em;' id="name"></p></td><td align="center" class='table_resume_title' width='15%'>性别</td><td align="center" width='35%'><p style='font-size:1em;' id="sexName"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='15%' height='60px;'>证件号码</td><td align="center" colspan="3"><p style='font-size:1em;' id="username"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='15%' height='60px;'>学历</td><td align="center" width='35%'><p style='font-size:1em;' id="educationName"></p></td><td align="center" class='table_resume_title' width='15%'>手机号码</td><td align="center" width='35%'><p style='font-size:1em;' id="mobile"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='15%' height='60px;'>工作单位</td><td align="center" colspan="3"><p style='font-size:1em;' id="company"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='15%' height='60px;'>职位</td><td align="center" width='35%'><p style='font-size:1em;' id="job"></p></td><td align="center" class='table_resume_title' width='15%'>单位电话</td><td align="center" width='35%'><p style='font-size:1em;' id="phone"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='15%' height='60px;'>单位地址</td><td align="center" colspan="3"><p style='font-size:1em;' id="address"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='15%' height='300px;'>身份证<br>复印件</td><td colspan="3" align="center">
					<img id="img_cardA" src="" value="" style='width:350px;border:none;' />
				</td>
			</tr>
			</table>
			<div style='margin: 12px;text-align:left; width:95%;'><p style='font-size:1.2em;'>&bull; 本表作为学员参加消防培训的重要材料入档，请学员务必准备、完整填写，不得有空项，填写完成后在下方签名，并于规定时间上交。</p></div>
			<div style='margin: 12px;text-align:left; width:95%;'><p style='font-size:1.2em;'>&bull; 表格有空项、无学员签名、表格未在规定时间内上交的，均不予办理《消防培训合格证》、不进行网上注册。</p></div>
			<div style='margin: 12px;text-align:left; width:95%;'><p style='font-size:1.2em;'>&bull; 提交1张2寸免冠彩色照片。</p></div>
			<div style='margin: 12px;text-align:right; width:95%; padding-right:100px;'><p style='font-size:1.3em;'>学员签名：</p></div>
			<div style='margin: 12px;text-align:right; width:95%;'><p id="date" style='font-size:1.3em;'></p></div>
		</div>
	</div>
  </div>
</div>
</body>
