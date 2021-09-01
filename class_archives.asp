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
	var updateCount = 1;
    var certID = "";
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";		//ID
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
            var qty = 0;
			if(ar > ""){
				refID = ar[1];
				$("#home_classID").html(ar[1]);
				$("#home_adviser").html(ar[9]);
				$("#home_certName").html(ar[4]);
				$("#home_startDate").html(ar[10] + "&nbsp;-&nbsp;" + ar[11]);
				$("#dateEnd").html(ar[11]);
				$("#classID").html(ar[1] + "&nbsp;&nbsp;[" + ar[17] + "]");
                qty = ar[20] - ar[33];
				$("#qty").html(qty);
				$("#summary").html(ar[25].replace(/\n/g,"<br/>"));
				$("#qtyExam").html(nullNoDisp(ar[27]));
				$("#qtyPass").html(nullNoDisp(ar[28]));
                certID = ar[3];
				x = ar[27];
				if(x > 0 && ar[28] > 0){
					x = (ar[28]*100/ar[27]).toFixed(2) + "&nbsp;%";
				}else{
					x = "%";
				}
				$("#pass_rate_exam").html(x);
				x = qty;
				if(x > 0 && ar[28] > 0){
					x = (ar[28]*100/qty).toFixed(2) + "&nbsp;%";
				}else{
					x = "%";
				}
				$("#pass_rate_training").html(x);
			}else{
				//alert("没有找到要打印的内容。");
				return false;
			}
		});

		$.get("classControl.asp?op=getStudentListByClassID&refID=" + refID + "&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
            var h = 0;
			ar = (unescape(data)).split("%%");
			$("#studentCover").empty();
			arr = [];			
			arr.push("<table cellpadding='0' cellspacing='0' border='1' width='99%'>");
			arr.push("<tr align='center'>");
			arr.push("<td align='center' width='9%' height='35px'>学号</td>");
			arr.push("<td align='center' width='8%'>姓名</td>");
			arr.push("<td align='center' width='6%'>性别</td>");
			arr.push("<td align='center' width='18%'>证件号码</td>");
			arr.push("<td align='center' width='14%'>联系电话</td>");
			arr.push("<td align='center' width='34%'>工作单位</td>");
			arr.push("<td align='center' width='6%'>状态</td>");
			arr.push("</tr>");
			var i = 0;
			
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr>");
					arr.push("<td align='center' height='35px'>" + ar1[4] + "</td>");
					arr.push("<td align='center'>" + ar1[1] + "</td>");
					arr.push("<td align='center'>" + ar1[2] + "</td>");
					arr.push("<td align='center'>" + ar1[0] + "</td>");
					arr.push("<td align='center'>" + ar1[5] + "</td>");
					arr.push("<td>" + ar1[6] + "</td>");
					arr.push("<td align='center'>" + ar1[12] + "</td>");
					arr.push("</tr>");
				});
			}
			arr.push("</table>");
			$("#studentCover").html(arr.join(""));
			arr = [];

			arr.push("<table cellpadding='0' cellspacing='0' border='1' width='99%'>");
			arr.push("<tr align='center'>");
			arr.push("<td align='center' width='10%' height='35px'>学号</td>");
			arr.push("<td align='center' width='8%'>姓名</td>");
			arr.push("<td align='center' width='6%'>性别</td>");
			arr.push("<td align='center' width='18%'>证件号码</td>");
			arr.push("<td align='center' width='8%'>成绩</td>");
			arr.push("<td align='center' width='15%'>证书编号</td>");
			arr.push("<td align='center' width='10%'>发证日期</td>");
			arr.push("</tr>");
			var i = 0;
			
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr>");
					arr.push("<td align='center' height='35px'>" + ar1[4] + "</td>");
					arr.push("<td align='center'>" + ar1[1] + "</td>");
					arr.push("<td align='center'>" + ar1[2] + "</td>");
					arr.push("<td align='center'>" + ar1[0] + "</td>");
                    h = ar1[7];
                    if(certID=="C12"){
                        h = ar1[10].replace(".00","") + "/" + ar1[11].replace(".00","");
                    }
					arr.push("<td align='center'>" + h + "</td>");
					arr.push("<td align='center'>" + ar1[9] + "</td>");
					arr.push("<td align='center'>" + ar1[8] + "</td>");
					arr.push("</tr>");
				});
			}
			arr.push("</table>");
			$("#scoreCover").html(arr.join(""));

			if(keyID==1){
				resumePrint();
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
			<div style='text-align:center; margin:150px 0 0 0;'><h3 style='font-size:3em;'>班级管理表册</h3></div>
			<table style="margin:300px 0 0 40px; width:85%;">
			<tr>
				<td style="width:30%; height:60px; text-align:right; vertical-align: bottom; font-size:1.8em;">培训机构</td><td style="width:65%; border-bottom: #333333 1px solid; font-size:1.8em; vertical-align: bottom; padding-left:15px;">上海智能消防学校</td><td style="width:5%; text-align:left; vertical-align: bottom; font-size:1.8em;">（章）</td>
			</tr>
			<tr>
				<td style="width:30%; height:60px; text-align:right; vertical-align: bottom; font-size:1.8em;">班级编号</td><td style="width:65%; border-bottom: #333333 1px solid; font-size:1.8em; vertical-align: bottom; padding-left:15px;" id="home_classID"></td><td></td>
			</tr>
			<tr>
				<td style="width:30%; height:60px; text-align:right; vertical-align: bottom; font-size:1.8em;">&nbsp;&nbsp;&nbsp;&nbsp;标&nbsp;&nbsp;&nbsp;&nbsp;号</td><td style="width:65%; border-bottom: #333333 1px solid; font-size:1.8em; vertical-align: bottom; padding-left:15px;" id="home_classID"></td><td></td>
			</tr>
			<tr>
				<td style="width:30%; height:60px; text-align:right; vertical-align: bottom; font-size:1.8em;">培训职业</td><td style="width:65%; border-bottom: #333333 1px solid; font-size:1.8em; vertical-align: bottom; padding-left:15px;" id="home_certName"></td><td></td>
			</tr>
			<tr>
				<td style="width:30%; height:60px; text-align:right; vertical-align: bottom; font-size:1.8em;">培训等级</td><td style="width:65%; border-bottom: #333333 1px solid; font-size:1.8em; vertical-align: bottom; padding-left:15px;" id="home_reexamine"></td><td></td>
			</tr>
			<tr>
				<td style="width:30%; height:60px; text-align:right; vertical-align: bottom; font-size:1.8em;">班&nbsp;主&nbsp;任</td><td style="width:65%; border-bottom: #333333 1px solid; font-size:1.8em; vertical-align: bottom; padding-left:15px;" id="home_adviser"></td><td></td>
			</tr>
			<tr>
				<td style="width:30%; height:60px; text-align:right; vertical-align: bottom; font-size:1.8em;">起迄日期</td><td style="width:65%; border: 0px; font-size:1.8em; vertical-align: bottom; padding-left:15px;" id="home_startDate"></td><td></td>
			</tr>
			</table>
			
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
				<td align="center" class='table_resume_title' width='15%' height='55px;'><p style='font-size:1em;' id="qty"></p></td><td align="right">%&nbsp;&nbsp;&nbsp;&nbsp;</td>
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

			<div style="page-break-after:always"></div>

			<div style='text-align:center; margin:10px 0 0 0;'><h3 style='font-size:1.8em;'>班级成员</h3></div>
			<div id="studentCover" style="float:center; margin:15px; font-size:1.2em;"></div>

			<div style="page-break-after:always"></div>

			<div style='text-align:center; margin:10px 0 0 0;'><h3 style='font-size:1.8em;'>成绩登记表</h3></div>
			<div id="scoreCover" style="float:center; margin:15px; font-size:1.2em;"></div>
		</div>
	</div>
</div>
</body>
