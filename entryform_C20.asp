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
		$("#img_photo").click(function(){
			if($("#img_photo").attr("value")>""){
				window.open($("#img_photo").attr("value"));
			}
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
				$("#SNo").html(ar[25]);
				$("#reexamine").html(ar[41]);
				$("#courseName").html(ar[6]);
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
				if(ar[29]=="znxf"){
					$("#company").html(ar[35]);
					//$("#dept2").html(ar[36]);
				}else{
					$("#company").html(ar[12] + "." + ar[13] + "." + ar[14]);
					//$("#dept2").html(ar[14]);
				}
				$("#educationName").html(ar[31]);
				$("#birthday").html(ar[33]);
				$("#address").html(ar[34]);
				$("#ethnicity").html(ar[37]);
				if(ar[21] > ""){
					$("#img_photo").attr("src","/users" + ar[21]);
				}else{
					$("#img_photo").attr("src","images/blank_photo.png");
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
		<div style="text-align:center;">
		<input class="button" type="button" id="print" value="打印" />&nbsp;
		</div>
		<div id="resume_print" style="border:none;width:100%;margin:1px;background:#ffffff;line-height:18px;">
			<div style='text-align:center; margin:10px 0 20px 0;'><h3 style='font-size:1.45em;'>全国消防行业职业技能鉴定报名表</h3></div>
			<div style='margin: 12px;text-align:left; width:95%;'><span style='font-size:1.2em;'>学员编号：</span><span style='font-size:1.2em;' id="SNo"></span></div>
			<table class='table_resume' style='width:99%;'>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>姓名</td><td align="center" width='32%'><p style='font-size:1em;' id="name"></p></td>
				<td align="center" class='table_resume_title' width='16%'>性别</td><td align="center" width='16%'><p style='font-size:1em;' id="sexName"></p></td>
				<td rowspan="4" align="center" class='table_resume_title' width='20%'>
					<img id="img_photo" src="" value="" style='width:100px;border:none;' />
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>身份证号</td><td align="center"><p style='font-size:1em;' id="username"></p></td>
				<td align="center" class='table_resume_title' width='16%'>出生日期</td><td class='table_resume_title'><p style='font-size:1em;' id="birthday"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>年龄</td><td align="center" width='20%'><p style='font-size:1em;' id="age"></p></td>
				<td align="center" class='table_resume_title' width='16%'>民族</td><td align="center"><p style='font-size:1em;' id="ethnicity"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>人员属性</td><td align="left">
					<span style='font-size:1em;'><input type="checkbox" name="fire_kind" value=0 />&nbsp;&nbsp;社会人员</span>
					<span style='font-size:1em;'><input type="checkbox" name="fire_kind" value=1 />&nbsp;&nbsp;公职人员</span>
					<span style='font-size:1em;'><input type="checkbox" name="fire_kind" value=2 />&nbsp;&nbsp;其他</span>
				</td>
				<td align="center" class='table_resume_title' width='16%'>户口所在地</td><td class='table_resume_title'><p style='font-size:1em;' id="bureau"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>政治面貌</td><td align="left" colspan="4">
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;群众</span>
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;党员</span>
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;团员</span>
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;其他</span>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>身份证地址</td><td align="center" colspan="4"><p style='font-size:1em;' id="IDaddress"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>在职情况</td><td align="left" colspan="4">
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;在职人员</span>
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;待业人员</span>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' height='45px;'>工作单位</td><td align="center" colspan="2"><p style='font-size:1em;' id="unit"></p></td>
				<td align="center" class='table_resume_title'>参加工作时间</td><td align="center"><p style='font-size:1em;'></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>从事职业</td><td align="center" colspan="4"><p style='font-size:1em;'></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>所在学校</td><td align="center" colspan="2"><p style='font-size:1em;'></p></td>
				<td align="center" class='table_resume_title'>学校类型</td><td align="center"><p style='font-size:1em;'></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>学历</td><td align="center" colspan="2"><p style='font-size:1em;' id="educationName"></p></td>
				<td align="center" class='table_resume_title'>毕业时间</td><td align="center"><p style='font-size:1em;'></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>专业名称</td><td align="center" colspan="4"><p style='font-size:1em;'></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>手机号码</td><td align="center"><p style='font-size:1em;' id="mobile"></p></td>
				<td align="center" class='table_resume_title'>常住地市</td><td align="center" colspan="2"><p style='font-size:1em;' id="address"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>详细地址</td><td align="center" colspan="4"><p style='font-size:1em;'></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>报考工种</td><td align="center" colspan="4"><p style='font-size:1em;' id="courseName"></p></td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>职业方向</td><td align="left" colspan="4">
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;灭火救援员</span>
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;消防通讯员</span>
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;计算机管理员</span>
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;搜救犬训导员</span>
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;消防车驾驶员</span>
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;装备维护员</span>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>职业等级</td><td align="left" colspan="4">
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;灭火救援员</span>
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;消防通讯员</span>
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;计算机管理员</span>
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;搜救犬训导员</span>
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;消防车驾驶员</span>
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;装备维护员</span>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>鉴定分类</td><td align="left" colspan="4">
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;一级/高级技师</span>
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;二级/技师</span>
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;三级/高级工</span>
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;四级/中级工</span>
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;五级/初级工</span>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>满足资格所属类</td><td align="left" colspan="4">
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;相关职业</span>
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;本职业方向</span>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>相关职业</td><td align="left" colspan="4">
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;消防员</span>
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;人民警察</span>
					<span style='font-size:1em;'><input type="checkbox" />&nbsp;&nbsp;....</span>
				</td>
			</tr>
			<tr>
				<td align="center" class='table_resume_title' width='16%' height='45px;'>申报资格</td><td align="left" colspan="4"><p style='font-size:1em;' id="courseName"></p></td>
			</tr>
			</table>
		</div>
	</div>
  </div>
</div>
</body>
