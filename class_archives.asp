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
	var refID = 0;
	var updateCount = 1;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";		//ID
		refID = "<%=refID%>";		//username
		keyID = "<%=keyID%>";		//0 预览  1 打印
		
		$.ajaxSetup({ 
			async: false 
		}); 
		$("#print").click(function(){
			resumePrint();
		});
		getNodeInfo(nodeID);
	});

	function getNodeInfo(id){
		$.get("classControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			var x = 0;
			if(ar > ""){
				$("#dateEnd").html(ar[11]);
				$("#classID").html(ar[1] + "&nbsp;&nbsp;[" + ar[17] + "]");
				$("#qty").html(ar[20]);
				$("#summary").html(ar[25]);
				$("#qtyExam").html(nullNoDisp(ar[27]));
				$("#qtyPass").html(nullNoDisp(ar[28]));
				x = ar[27];
				if(x > 0 && ar[28] > 0){
					x = (ar[28]*100/ar[27]).toFixed(2) + "%";
				}else{
					x = "%";
				}
				$("#pass_rate_exam").html(x);
				x = ar[20];
				if(x > 0 && ar[28] > 0){
					x = (ar[28]*100/ar[20]).toFixed(2) + "%";
				}else{
					x = "%";
				}
				$("#pass_rate_training").html(x);
				if(keyID==1){
					resumePrint();
				}
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
			//window.parent.getStudentCourseLists(refID);
			window.parent.$.close("classInfo");
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
				<td align="center" class='table_resume_title' width='15%' height='55px;'><p style='font-size:1em;' id="qty"></p></td><td align="right">%&nbsp;&nbsp;</td>
				<td align="center" class='table_resume_title' width='15%'><p style='font-size:1em;' id="qtyExam"></p></td><td align="center" width='15%'><p style='font-size:1em;' id="qtyPass"></p></td>
				<td align="right" width='18%'><p style='font-size:1em; padding-right:10px;' id="pass_rate_exam"></p></td><td align="right" width='18%'><p style='font-size:1em; padding-right:10px;' id="pass_rate_training"></p></td>
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
					<table border="0" cellpadding="0" cellspacing="0" width="100%"><tr height='345px;'><td>
					<div style="float:left; padding-left:15px; font-size:1.15em;" id="summary"></div>
					</td></tr><tr height='55px;'><td>
					<div style="float:left; padding-left:50%; font-size:1.15em;">班主任（签名）：</div>
					</td></tr></table>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='5%' height='150px;'>领导意见</td>
				<td align="left" class='table_resume_title' colspan="5">
					<br><br><br>
					<span style='font-size:1em;float:center;padding-right:30px;'>签名：</span>
					<span style='font-size:1em;float:right; padding-right:10px;'>年&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;日</span>
				</td>
			</tr>
			</table>
		</div>
	</div>
</div>
</body>
