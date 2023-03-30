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
	var op = 0;
	var refID = 0;
	var updateCount = 1;
	var k = 0;
	var sign = "";
	var reex = 0;
	var course = "";
	var sDate = "";
	var price = 0;
	<!--#include file="js/commFunction.js"-->
	<!--#include file="need2know.js"-->
	<!--#include file="agreement.js"-->
	<!--#include file="materials_emergency.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";		//enterID
		refID = "<%=refID%>";		//username
		keyID = "<%=keyID%>";		//0 预览  1 打印  2 文件  3 仅报名表文件
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 
		$("#print").click(function(){
			resumePrint();
		});
		if(keyID>1){
			$("#pageTitle").hide();
		}
		//getNeed2know(nodeID);
		getNodeInfo(nodeID, refID);
});

	function getNodeInfo(id,ref){
		$.get("studentCourseControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > "0"){
				//$("#SNo").html(ar[25] + "&nbsp;&nbsp;班级：" + ar[34]);
				$("#C" + ar[36]).prop("checked",true);
				$("#reexamine" + ar[40]).prop("checked",true);
				//$("#reexamine").html(ar[41]);
				//$("#courseName").html(ar[6]);
				
				sign = (ar[52]==1?ar[48]:"");
				reex = ar[40];
				course = ar[56];
				sDate = ar[49];
				price = ar[53];
				if(reex==1){
					$("#check2").prop("checked",true);	//复训
				}else{
					if(ar[57]==1){
						$("#check3").prop("checked",true);	//复训过期，参加初训
					}else{
						$("#check1").prop("checked",true);	//第一次初训
					}
				}
				
				if(sign>""){
					//$("#f_sign1").attr("src","/users" + sign + "?times=" + (new Date().getTime()));
					$("#f_sign20").attr("src","/users" + sign + "?times=" + (new Date().getTime()));
					$("#f_sign30").attr("src","/users" + sign + "?times=" + (new Date().getTime()));
					$("#f_sign40").attr("src","/users/upload/companies/stamp/sign_znxf.png?times=" + (new Date().getTime()));
					$("#date").html(new Date(sDate).format("yyyy.M.d"));
					//$("#f_sign40").hide();
					//$("#date2").html(sDate);
					$("#date2").html(new Date(addDays(sDate,3)).format("yyyy.M.d"));
				}else{
					//$("#f_sign1").hide();
					$("#f_sign20").hide();
					$("#f_sign30").hide();
					$("#f_sign40").hide();
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
				$("#mobile").html(ar[7] + "&nbsp;&nbsp;" + ar[17]);
				$("#age").html(ar[9]);
				$("#job").html(ar[18]);
				//$("#phone").html(ar[17]);
				$("#job").html(ar[18]);
				if(ar[29]=="znxf"){
					$("#company").html(ar[35] + "." + ar[36]);
					//$("#dept2").html(ar[36]);
				}else{
					$("#company").html(ar[12] + "." + ar[13] + "." + ar[14]);
					//$("#dept2").html(ar[14]);
				}
				$("#educationName").html(ar[31]);
				$("#birthday").html(ar[33].substr(0,7));
				$("#address").html(ar[34]);
				$("#ethnicity").html(ar[37]);
				$("#IDdate").html(ar[40] + " " + ar[41]);
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
				//$("#date").html(currDate);
				var p = 0;
				if(keyID == 2){
					//打印学历证明
					p = 1;
				}
				if(keyID < 2){
					getNeed2know(nodeID);
					getAgreement(ar[1],ar[2],course,sign,sDate,price);
				}
				if(keyID <= 2){
					getMaterials(ar[1],sign,p,k);
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
			<div style="position: relative;width:100%;height:100%;">
				<div style="position: absolute; z-index:30;">
				</div>
				<div style="position: absolute; z-index:10;">
					<div style='text-align:center; margin:10px 0 20px 0;'><h3 style='font-size:1.45em;'>上海市高危行业负责人及安全生产管理人员安全知识和管理能力</h3></div>
					<div style='text-align:center; margin:10px 0 20px 0;'><h3 style='font-size:1.45em;'>考核申请表（2023版）</h3></div>
					<table class='table_resume' style='width:99%;'>
					<tr>
						<td align="center" class='table_resume_title' width='15%' height='60px'>姓名</td><td align="center" width='13%'><p style='font-size:1em;' id="name"></p></td>
						<td align="center" class='table_resume_title' width='10%'>性别</td><td align="center" width='10%'><p style='font-size:1em;' id="sexName"></p></td>
						<td align="center" class='table_resume_title' width='13%'>出生年月</td><td class='table_resume_title' width='14%'><p style='font-size:1em;' id="birthday"></p></td>
						<td rowspan="4" colspan="2" align="center" class='table_resume_title' width='20%'>
							<img id="img_photo" src="" value="" style='width:100px;border:none;' />
						</td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' width='15%' height='60px'>国籍</td><td align="center" width='13%'><p style='font-size:1em;'>中国</p></td>
						<td align="center" class='table_resume_title' width='10%'>民族</td><td align="center" width='10%'><p style='font-size:1em;' id="ethnicity"></p></td>
						<td align="center" class='table_resume_title' width='13%'>文化程度</td><td class='table_resume_title' width='14%'><p style='font-size:1em;' id="educationName"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='60px'>证件类型</td><td align="center" colspan="3"><input type="checkbox" id="IDK0" />&nbsp;身份证 <input type="checkbox" />&nbsp;军官证 <input type="checkbox" />&nbsp;护照 <input type="checkbox" id="IDK1" />&nbsp;其他</td>
						<td align="center" class='table_resume_title'>有效期限</td><td class='table_resume_title' width='14%'><p style='font-size:1em;' id="IDdate"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='60px'>证件号码</td><td align="center" colspan="5"><p style='font-size:1em;' id="username"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='60px'>工作单位</td><td align="center" colspan="3"><p style='font-size:1em;' id="company"></p></td>
						<td align="center" class='table_resume_title'>从事岗位</td><td align="center" colspan="3"><p style='font-size:1em;' id="job"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='60px'>联系地址</td><td align="center" colspan="3"><p style='font-size:1em;' id="address"></p></td>
						<td align="center" class='table_resume_title'>联系方式</td><td align="center" colspan="3"><p style='font-size:1em;' id="mobile"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='60px'>申请考核工种</td>
						<td align="left" colspan="7" style="line-height:30px;">
							<input type="checkbox" />&nbsp;危险化学品生产单位主要负责人 <input type="checkbox" />&nbsp;&nbsp;&nbsp;危险化学品生产单位安全生产管理人员</br>
							<input type="checkbox" id="CC16" />&nbsp;危险化学品经营单位主要负责人 <input type="checkbox" id="CC17" />&nbsp;&nbsp;&nbsp;危险化学品经营单位安全生产管理人员</br>
							<input type="checkbox" />&nbsp;金属冶炼（炼钢）单位主要负责人 <input type="checkbox" />&nbsp;金属冶炼（炼钢）单位安全生产管理人员</br>
							<input type="checkbox" />&nbsp;金属冶炼（炼铁）单位主要负责人 <input type="checkbox" />&nbsp;金属冶炼（炼铁）单位安全生产管理人员</br>
						</td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='40px;'>考核类型</td><td align="center" width='13%' colspan="3"><input type="checkbox" id="reexamine0" />&nbsp;初审 <input type="checkbox" id="reexamine1" />&nbsp;复审</td>
						<td align="center" class='table_resume_title'><p style='font-size:1em;'>是否参加</p><p style='font-size:1em;'>相应培训</p></td><td align="center" width='13%' colspan="3"><p style='font-size:1em;'><input type="checkbox" checked />&nbsp;&nbsp;是&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="checkbox" />&nbsp;&nbsp;否</p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='40px;'>承担高危行业相关岗位情况</td>
						<td align="left" colspan="7" style="padding-left:5px;line-height:30px;">
							<p style='font-size:1em;'><input id="check1" type="checkbox" />&nbsp;&nbsp;本人是初次参加高危行业人员安全知识和管理能力考核。</p>
							<p style='font-size:1em;'><input id="check2" type="checkbox" />&nbsp;&nbsp;本人此次参加高危行业人员安全知识和管理能力复审考核，在持原特种作业操作证书从事相应岗位期间，未发生过事故。</p>
							<p style='font-size:1em;'><input style="border:0px;" type="checkbox" id="check3" value="" />&nbsp;&nbsp;本人因未按时参加复审导致原操作证书过期，重新申请参加高危行业人员安全知识和管理能力考核。</p>
							<p style='font-size:1em;'>&nbsp;&nbsp;&nbsp;&nbsp;本人对填写所有信息以及提交材料的真实性、有效性和完整性负责，如有隐瞒，相关责任全部由本人承担。</p>
							<div style="display:table-cell;height:50px;vertical-align:middle;text-align:center">
								<span style='font-size:1.2em;padding-left:280px;'>承诺人签名：</span>
								<span><img id="f_sign20" src="" style="width:170px;padding-left:80px;"></span>
							</div>
						</td>
					</tr>
					<tr>
						<td align="left" class='table_resume_title' width='15%' height='55px' colspan="4">
							<div style="display:table-cell;height:50px;vertical-align:middle;text-align:center">
								<span style='font-size:1.2em;'>申请人签名：</span>
								<span><img id="f_sign30" src="" style="width:170px;padding-left:80px;"></span>
							</div>
							<p id="date" style='font-size:1em;float:right;padding-right:100px;padding-top:3px;color:#555;font-family:"Aa青叶体","Ink Free";'></p>
							<p style='font-size:1em;padding-left:190px;padding-top:60px;'>&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日</p>
						</td>
						<td align="left" class='table_resume_title' width='15%' height='80px;' colspan="4">
							<p style='font-size:1em;float:left;'>考试点意见：</p>
							<br><br>
							<div style="display:table-cell;height:30px;vertical-align:middle;text-align:center">
								<span style='font-size:1.2em;padding-left:80px;'>经办人签名：</span>
								<span><img id="f_sign40" src="" style="width:120px;padding-left:10px;"></span>
							</div>
							<p id="date2" style='font-size:1.4em;float:left;padding-left:190px;padding-top:3px;color:#555;font-family:"Aa跃然体","时光沙漏";'></p>
							<p style='font-size:1em;padding-left:190px;'>&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;日</p>
						</td>
					</tr>
					</table>
				</div>
			</div>
			<div id="needCover"></div>
			<div id="agreementCover"></div>
			<div id="materialsCover"></div>
		</div>
	</div>
</div>
</body>
