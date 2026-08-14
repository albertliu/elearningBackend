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
	var keyID = 0;
	var sign = "";
	var reex = 0;
	var course = "";
	var sDate = "";
	var price = 0;
	let agreement = "A4";
	let courseNo = "";
	var updateCount = 1;
	<!--#include file="js/commFunction.js"-->
	<!--#include file="need2know.js"-->
	<!--#include file="agreement.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";		//enterID
		refID = "<%=refID%>";		//username
		keyID = "<%=keyID%>";		//0 预览  1 打印
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 
		if(keyID==2){	//培训协议不带报名表
			$("#item0").hide();
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
				$("#SNo").html(ar[25] + "&nbsp;&nbsp;班级：" + ar[34]);
				sign = (ar[52]==1?ar[48]:"");
				reex = ar[40];
				course = ar[56];
				sDate = ar[49];
				price = ar[53];
				courseNo = ar[102];
				// if(ar[48] > "" && keyID != 4){
				// 	$("#img_signature").attr("src","/users" + ar[48] + "?times=" + (new Date().getTime()));
				// 	$("#signatureDate").html(ar[49]);
				// }else{
				// 	$("#img_signature").attr("src","images/blank_signature.png");
				// }
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
				$("#phone").html(ar[17]);
				$("#job").html(ar[18]);
				if(ar[29]=="znxf"){
					$("#company").html(ar[35]);
					$("#dept2").html(ar[36]);
				}else{
					$("#company").html(ar[12] + " ." + ar[13]);
					$("#dept2").html(ar[14]);
				}
				$("#educationName").html(ar[31]);
				$("#birthday").html(ar[33]);
				$("#address").html(ar[34]);
				$("#linker").html(ar[46]);
				$.post(uploadURL + "/public/postCommInfo", {proc:"getDicItem", params:{kind:"SE", ID:courseNo}}, function(data){
					let ar4 = data[0];
					if(keyID < 3 || keyID == 4){
						getAgreement(ar[1],ar[2],ar4["item"],sign,sDate,price,price,agreement,ar4["memo"]);	//无签名
					}
					if(keyID==1){
						resumePrint();
					}
				});
				
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
		<div id="resume_print" style="border:none;width:100%;margin:1px;background:#ffffff;line-height:18px;">
		<div id="item0" style="width:100%;float:left;margin:0;">
			<div style='text-align:center; margin:10px 0 20px 0;'><h2 style='font-size:1.45em;'>特种设备作业人员资格复审申请表</h2></div>
			<table class='table_resume' style='width:99%;'>
			<tr>
				<td align="center" class='table_resume_title' width='15%' height='45px;' colspan="2">姓名</td><td align="center" width='25%'><p style='font-size:1em;' id="name"></p></td>
				<td align="center" class='table_resume_title' width='15%'>性别</td><td align="center" width='25%'><p style='font-size:1em;' id="sexName"></p></td>
				<td rowspan="4" align="left" class='table_resume_title' width='20%'>
					<p style='font-size:0.85em;'>近期2寸正面免<br>冠白底彩色照片</p>
				</td>
			</tr>
			<tr>
				<td align="left" class='table_resume_title' height='45px;' colspan="2">通信地址</td><td align="left" colspan="3"><p style='font-size:1em; padding-left:10px;' id="address"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' height='45px;' colspan="2">文化程度</td><td class='table_resume_title'><p style='font-size:1em;' id="educationName"></p></td>
				<td align="left" class='table_resume_title'>邮政编码</td><td align="center"><p style='font-size:1em;' id="zip"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' height='45px;' colspan="2">身份证号</td><td align="center"><p style='font-size:1em;' id="username"></p></td>
				<td align="left" class='table_resume_title'>联系电话</td><td class='table_resume_title'><p style='font-size:1em;' id="mobile"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' height='45px;' colspan="2">作业项目</td><td class='table_resume_title'><p style='font-size:1em;' id="courseName"></p></td>
				<td align="left" class='table_resume_title'>项目代号</td><td align="center" colspan="2"><p style='font-size:1em;' id="zipCode"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' height='45px;' colspan="2">证件编号</td><td class='table_resume_title'><p style='font-size:1em;' id="diplomaID"></p></td>
				<td align="left" class='table_resume_title'>首次发证日期</td><td align="center" colspan="2"><p style='font-size:1em;' id="diplomaDate"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' height='45px;' colspan="2">用人单位</td><td align="left" colspan="4"><p style='font-size:1em; padding-left:10px;' id="unit"></p></td></tr>
			<tr>
				<td align="left" class='table_resume_title' height='45px;' colspan="2">单位地址</td><td align="left" colspan="4"><p style='font-size:1em; padding-left:10px;' id="companyAddress"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' height='45px;' colspan="2">单位联系人</td><td align="center"><p style='font-size:1em;' id="linker"></p></td>
				<td align="left" class='table_resume_title'>联系电话</td><td align="center" colspan="2"><p style='font-size:1em;' id="phone"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='5%' height='270px;'>持证期间作业经历</td>
				<td align="right" colspan="5"></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' height='45px;'>复审资料</td>
				<td align="left" colspan="5"><p style='font-size:1em; padding-left:20px;'>☑&nbsp;《特种设备安全管理和作业人员证》（原件）</p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' height='45px;' rowspan="2">自我承诺</td>
				<td align="left" colspan="5" align="center"><p style='font-size:1em; padding-left:20px;'>持证期间是否发生过违章作业行为和责任事故：</p></td>
			</tr>
			<tr>
				<td align="left" colspan="5"><p style='font-size:1em; padding-left:20px;'>☑&nbsp;未发生过 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;□&nbsp;发生过</p></td>
			</tr>
			<tr>
				<td align="left" colspan="6">
					<p style='font-size:1em; padding-left:20px;'>本人声明，以上填写信息及所提交的资料均合法、真实、有效，并承诺对填写的内容负责。</p>
					<div style="display:table-cell;height:40px;vertical-align:middle;text-align:center">
						<span style='font-size:1.2em;padding-left:300px;'>申请人（签字）：</span>
						<span style="position: relative; top: 5px;"></span>
						<span id="date1" style='font-size:1.5em;padding-left:10px;padding-top:20px;color:#555;font-family:"qyt","Ink Free";'></span>
						<span style='font-size:1.2em; padding-left:100px;'>年</span>
						<span id="date1M" style='font-size:1.5em;padding-top:20px;color:#555;font-family:"qyt","Ink Free";'></span>
						<span style='font-size:1.2em; padding-left:30px;'>月</span>
						<span id="date1D" style='font-size:1.5em;padding-top:20px;color:#555;font-family:"qyt","Ink Free";'></span>
						<span style='font-size:1.2em; padding-left:30px;'>日</span>
					</div>
				</td>
			</tr>
			</table>
			<div style='margin: 12px;text-align:left; width:95%;'><p style='font-size:1.2em;'>&bull; 注：申请人在网上申请的，填写申请表后打印签字并扫描上传。</p></div>
		</div>
		<div id="agreementCover"></div>
		</div>
	</div>
  </div>
</div>
</body>
