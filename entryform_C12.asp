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
<script language="javascript" src="js/jquery.form.js?v=1.0"></script>
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
	<!--#include file="commitment.js"-->
	<!--#include file="agreement.js"-->
	<!--#include file="materials_emergency.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";		//enterID
		refID = "<%=refID%>";		//username
		keyID = "<%=keyID%>";		//0 预览  1 打印  2 文件
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 
		$("#print").click(function(){
			resumePrint();
		});

		$("#btnGenerateMaterials").click(function(){
			generateMaterials();
		});
		$("#btnGenerateZip").click(function(){
			generateZip();
		});
		if(keyID==2){
			$("#pageTitle").hide();
		}
		getNodeInfo(nodeID, refID);
	});

	function getNodeInfo(id,ref){
		$.get("studentCourseControl.asp?op=getNodeInfo&nodeID=" + id + "&public=1&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > "0"){
				$("#SNo").html(ar[25] + "&nbsp;&nbsp;班级：" + ar[34]);
				$("#reexamine").html("上海市特种作业人员安全技术考核申请表");
				//$("#courseName").html(ar[6]);
				$("#C" + ar[36]).prop("checked",true);
				$("#R" + ar[40]).prop("checked",true);
				sign = (ar[52]==1?ar[48]:"");
				reex = ar[40];
				course = ar[56];
				sDate = ar[49];
				price = ar[53];
				$("#f_sign30").hide();
				
				if(sign>""){
					$("#f_sign1").attr("src","/users" + sign + "?times=" + (new Date().getTime()));
					$("#f_sign20").attr("src","/users" + sign + "?times=" + (new Date().getTime()));
					// $("#f_sign30").attr("src","/users" + sign + "?times=" + (new Date().getTime()));
					$("#f_sign40").attr("src","/users/upload/companies/stamp/sign_znxf.png?times=" + (new Date().getTime()));
					$("#date").html(sDate);
					var arr = new Array();
					arr.push('<div style="position: relative;width:100%;height:80%;">');
					arr.push('<div style="position: absolute; z-index:10;">');
					arr.push('<div style="float:left;">');
					arr.push('	<span style="padding-left:150px;"><img src="/users/upload/companies/stamp/station_znxf.png" style="width:150px;padding-top:860px;opacity:0.7;"></span>');
					arr.push('</div>');
					arr.push('</div>');
					arr.push('</div>');
					$("#stampCover").html(arr.join(""));
					//$("#f_sign40").hide();
					// $("#date2").html(sDate);
				}else{
					$("#f_sign1").hide();
					$("#f_sign20").hide();
					$("#f_sign40").hide();
				}
				
				var c = "";
				if(ar[54] > ""){
					c += "<a href='/users" + ar[54] + "?times=" + (new Date().getTime()) + "' target='_blank'>申报材料</a>";
				}
				if(c == ""){c = "&nbsp;&nbsp;申报材料还未生成";}
				$("#f_materials").html(c);
				if(reex == 1){
					$("#onShanghai").hide();
				}
			}else{
				//alert("没有找到要打印的内容。");
				return false;
			}
		});
		
		$.get("studentControl.asp?op=getNodeInfo&nodeID=0&refID=" + ref + "&public=1&times=" + (new Date().getTime()),function(re){
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
				if(ar[29]!="spc" && ar[29]!="shm"){
					$("#company").html(ar[35]);
					k = (ar[35]=="个人" || ar[35]=="个体"? 1: 0);
					//$("#dept2").html(ar[36]);
				}else{
					$("#company").html(ar[12] + "." + ar[13] + "." + ar[14]);
					k = 0;
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
				// if(ar[22] > ""){
				// 	$("#img_cardA").attr("src","/users" + ar[22]);
				// }else{
				// 	$("#img_cardA").attr("src","images/blank_cardA.png");
				// 	$("#f_sign1").hide();
				// }
				// if(sign=="" || ar[22] == ""){
				// 	$("#same1").hide();
				// }
				// if(ar[23] > ""){
				// 	$("#img_cardB").attr("src","/users" + ar[23]);
				// }else{
				// 	$("#img_cardB").attr("src","images/blank_cardB.png");
				// }
				var c = "";
				if(ar[21] > ""){
					c += "<a href='/users" + ar[21] + "?times=" + (new Date().getTime()) + "' target='_blank'>照片</a>";
				}
				if(c == ""){c = "&nbsp;&nbsp;照片还未上传";}
				$("#f_photo").html(c);
				var p = 1;
				if(keyID == 2){
					//打印学历证明
					p = 1;
				}else{
					getNeed2know(nodeID);
					getAgreement(ar[1],ar[2],course,sign,sDate,price);
				}
				if(reex==1){
					if(ar[44]==""){
						//情况说明模板
						getCommitment(ar[1],ar[2],course,sign,sDate,k);
					}else{
						//已上传的情况说明图片
						k = 1;
					}
				}
				getMaterials(ar[1],sign,p,k);
				//$("#date").html(currDate);
				if(keyID==1){
					resumePrint();
				}
			}else{
				alert("没有找到要打印的内容。");
				return false;
			}
		});
	}

	function generateMaterials(){
		$.getJSON(uploadURL + "/outfiles/generate_emergency_materials?refID=" + refID + "&nodeID=" + nodeID + "&keyID=2" ,function(data){
			if(data>""){
				alert("已生成文件");
				getNodeInfo(nodeID, refID);
			}else{
				alert("没有可供处理的数据。");
			}
		});
	}
	
	function generateZip(){
		$.getJSON(uploadURL + "/outfiles/generate_fireman_zip?username=" + refID + "&enterID=" + nodeID + "&registerID=" + currUser ,function(data){
			if(data>""){
				alert("已生成压缩包");
				getNodeInfo(nodeID, refID);
			}else{
				alert("没有可供处理的数据。");
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
			申报文件
			<span id="f_materials" style="margin-left:20px;"></span>
			<span id="f_photo" style="margin-left:20px;"></span>
			<input class="button" style="margin-left:20px;" type="button" id="btnGenerateMaterials" value="生成文件" />
			<input class="button" style="margin-left:20px;" type="button" id="btnGenerateZip" value="生成压缩包" />
		</div>
		<div id="resume_print" style="border:none;width:100%;margin:1px;background:#ffffff;line-height:18px;">
			<div style="position: relative;width:100%;height:99%;">
				<div style="position: absolute; z-index:10;">
					<div style='text-align:center; margin:10px 0 15px 0;'><h3 id="reexamine" style='font-size:1.75em; font-family: 幼圆;'></h3></div>
					<div style='text-align:left; margin:10px 0 15px 30px;'><p style='font-size:1.5em; font-family: 幼圆;'>申请考试类别：<input type="checkbox" id="R0" />&nbsp;初证 <input type="checkbox" id="R1" />&nbsp;复审</p></div>
					<table class='table_resume' style='width:99%;border:2px solid black;'>
					<tr>
						<td align="center" class='table_resume_title' width='10%' height='45px'>姓名</td><td align="center" width='13%'><p style='font-size:1em;' id="name"></p></td>
						<td align="center" class='table_resume_title' width='10%'>性别</td><td align="center" width='14%'><p style='font-size:1em;' id="sexName"></p></td>
						<td align="center" class='table_resume_title' width='13%'>出生年月</td><td class='table_resume_title' width='14%'><p style='font-size:1em;' id="birthday"></p></td>
						<td rowspan="4" colspan="2" align="center" class='table_resume_title' width='18%'>
							<img id="img_photo" src="" value="" style='width:100px;border:none;' />
						</td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='45px'>国籍</td><td align="center" width='13%'><p style='font-size:1em;'>中国</p></td>
						<td align="center" class='table_resume_title'>民族</td><td align="center" width='10%'><p style='font-size:1em;' id="ethnicity"></p></td>
						<td align="center" class='table_resume_title'>文化程度</td><td class='table_resume_title' width='14%'><p style='font-size:1em;' id="educationName"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='45px'>证件类型</td><td align="center" colspan="3" class="ef1p1"><input type="checkbox" id="IDK0" />&nbsp;身份证 <input type="checkbox" />&nbsp;护照 <input type="checkbox" id="IDK1" />&nbsp;其他</td>
						<td align="center" class='table_resume_title'>有效期限</td><td class='table_resume_title'><p style='font-size:1em;' id="IDdate"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='45px'>证件号码</td><td align="center" colspan="5"><p style='font-size:1em;' id="username"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='45px'>工作单位</td><td align="center" colspan="3"><p style='font-size:1em;' id="unit"></p></td>
						<td align="center" class='table_resume_title'>从事岗位</td><td align="center" colspan="3"><p style='font-size:1em;' id="job"></p></td>
					</tr>
					<tr>
						<td align="center" class='table_resume_title' height='45px'>联系地址</td><td align="center" colspan="3"><p style='font-size:1em;' id="address"></p></td>
						<td align="center" class='table_resume_title'>联系方式</td><td align="center" colspan="3"><p style='font-size:1em;' id="mobile"></p></td>
					</tr>
					<tr>
						<td align="center" rowspan="6" class='table_resume_title' height='45px'>申<br>请<br>考<br>试<br>项<br>目</td>
						<td align="left" colspan="2" class="ef1p1" style="padding-left:10px;" height='60px'>电工作业</td>
						<td align="left" colspan="5" class="ef1p1">
							<input type="checkbox" id="CC12" />&nbsp;低压电工作业 <input type="checkbox" id="CC27" />&nbsp;高压电工作业 <input type="checkbox" />&nbsp;电力电缆作业</br>
							<input type="checkbox" />&nbsp;继电保护作业 <input type="checkbox" />&nbsp;电气试验作业 <input type="checkbox" />&nbsp;防爆电气作业
						</td>
					</tr>
					<tr>
						<td align="left" colspan="2" class="ef1p1" style="padding-left:10px;" height='40px'>焊接与热切割作业</td>
						<td align="left" colspan="5" class="ef1p1">
							<input type="checkbox" id="CC24" />&nbsp;熔化焊接与热切割作业
						</td>
					</tr>
					<tr>
						<td align="left" colspan="2" class="ef1p1" style="padding-left:10px;" height='40px'>高处作业</td>
						<td align="left" colspan="5" class="ef1p1">
							<input type="checkbox" />&nbsp;登高架设作业 <input type="checkbox" id="CC15" />&nbsp;高处安装、维护、拆除作业
						</td>
					</tr>
					<tr>
						<td align="left" colspan="2" class="ef1p1" style="padding-left:10px;" height='40px'>制冷与空调作业</td>
						<td align="left" colspan="5" class="ef1p1">
							<input type="checkbox" id="CC25" />&nbsp;制冷与空调设备运行操作作业 <input type="checkbox" id="CC26" />&nbsp;制冷与空调设备安装修理作业
						</td>
					</tr>
					<tr>
						<td align="left" colspan="2" class="ef1p1" style="padding-left:10px;" height='45px'>冶金(有色)生产<br>安全作业</td>
						<td align="left" colspan="5" class="ef1p1">
							<input type="checkbox" />&nbsp;煤气作业
						</td>
					</tr>
					<tr>
						<td align="left" colspan="2" class="ef1p1" style="padding-left:10px;">危险化学品安全作业</td>
						<td align="left" colspan="5" class="ef1p1">
							<input type="checkbox" />&nbsp;光气及光气化工艺作业 <input type="checkbox" />&nbsp;氧碱电解工艺作业 <br>
							<input type="checkbox" />&nbsp;氯化工艺作业 <input type="checkbox" />&nbsp;硝化工艺作业 <input type="checkbox" />&nbsp;合成氧工艺作业 <br>
							<input type="checkbox" />&nbsp;裂解(裂化)工艺作业 <input type="checkbox" />&nbsp;氟化工艺作业 <input type="checkbox" />&nbsp;加氢工艺作业 <br>
							<input type="checkbox" />&nbsp;重氮化工艺作业 <input type="checkbox" />&nbsp;氧化工艺作业 <input type="checkbox" />&nbsp;过氧化工艺作业 <br>
							<input type="checkbox" />&nbsp;胺基化工艺作业 <input type="checkbox" />&nbsp;磺化工艺作业 <input type="checkbox" />&nbsp;聚合工艺作业 <br>
							<input type="checkbox" />&nbsp;烷基化工艺作业 <input type="checkbox" />&nbsp;化工自动化控制仪表作业
						</td>
					</tr>
					<tr>
						<td align="left" colspan="8" style="padding-left:5px;">
							<p class="ef1p1" style='font-weight:bold;'>注意事项：</p>
							<p class="ef1p1" style='text-indent:30px;'>
							1.申请人须年满18周岁，且不超过国家法定退休年龄。
							</p>
							<p class="ef1p1" style='text-indent:30px;'>
							2.申请人须经社区或者县级以上医疗机构体检健康合格，并无妨碍从事相应特种作业的器质性心脏病、癫痫病、美尼尔氏症、眩晕症、癔病、震颤麻痹症、精神病、痴呆症以及其他疾病和生理缺陷。
							</p>
							<p class="ef1p1" style='text-indent:30px;'>
							3.申请人须具有初中及以上文化程度（申请危险化学品安全作业考试的，须具备高中或者相当于高中及以上文化程度）。
							</p>
							<p class="ef1p1" id="onShanghai" style='text-indent:30px;'>
							4.初证申请人的户籍所在地、居住地或从业所在地须为上海市。
							</p><br />
							<p class="ef1p1" style='text-indent:30px;'>
							本人已阅读并充分了解上述注意事项，承诺所提供资料真实完整有效，如因提供资料虚假而产生相关影响，由本人承担全部责任。
							</p>
							<div style="display:table-cell;height:50px;vertical-align:middle;text-align:center">
								<span style='font-size:1.2em;padding-left:300px;'>申请人（签名）：</span>
								<span><img id="f_sign20" src="" style="max-width:150px;max-height:40px;padding-left:10px;"></span>
								<span id="date" style='font-size:1.5em;float:right;padding-left:10px;padding-top:20px;color:#555;font-family:"qyt","Ink Free";'></span>
							</div>
						</td>
					</tr>
					<tr>
						<td align="left" class='table_resume_title' height='100px' colspan="8">
							<div style="display:table-cell;height:100px;vertical-align:middle;text-align:left;">
								<div><p style='font-size:1.2em;'>考试点审查意见：</p></div>
								<div style="display:table-cell;vertical-align:middle;text-align:left;">
									<span style='font-size:1.2em;padding-left:150px;'>考试点（盖章）：</span>
									<span style='font-size:1.2em;padding-left:100px;'>经办人（签名）：</span>
									<span style='font-size:1.2em;'><img id="f_sign40" src="" style="width:100px;padding-left:10px;"></span>
									<span id="date2" style='font-size:1.4em;color:#555;font-family:"Aa跃然体","时光沙漏";'></span>
								</div>
							</div>
						</td>
					</tr>
					
					</table>
				</div>
				<div id="stampCover"></div>
			</div>
			</div>

			<div id="needCover"></div>
			<div id="commitmentCover"></div>
			<div id="agreementCover"></div>
			<div id="materialsCover"></div>
		</div>
	</div>
  </div>
</div>
</body>
