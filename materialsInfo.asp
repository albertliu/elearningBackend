<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title></title>

<link href="css/style_inner1.css?v=1.0"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/data_table_mini.css?v=20150411" rel="stylesheet" type="text/css" />
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="css/jquery.autocomplete.css" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<script type='text/javascript' src='js/jquery.autocomplete.js'></script>
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var refID = "";
	var op = 0;
	var updateCount = 0;
	var username = "";
	var replace_item = "";
	var original_item = "";
	var cardJson = "";
	<!--#include file="js/commFunction.js"-->
	<!--#include file="js/EST_reader.js"-->
	$(document).ready(function (){
		refID = "<%=refID%>";
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 
		if(op==0){
			getNodeInfo(0,refID);
		}

		$("#add_img_photo").click(function(){
			showLoadFile("student_photo",$("#username").val(),"student",$("#host").val());
		});
		$("#add_img_cardA").click(function(){
			showLoadFile("student_IDcardA",$("#username").val(),"student",$("#host").val());
		});
		$("#add_img_cardB").click(function(){
			showLoadFile("student_IDcardB",$("#username").val(),"student",$("#host").val());
		});
		$("#add_img_education").click(function(){
			showLoadFile("student_education",$("#username").val(),"student",$("#host").val());
		});
		$("#img_photo").click(function(){
			if($("#img_photo").attr("value")>""){
				window.open($("#img_photo").attr("value"));
			}
		});
		$("#img_cardA").click(function(){
			if($("#img_cardA").attr("value")>""){
				window.open($("#img_cardA").attr("value"));
			}
		});
		$("#img_cardB").click(function(){
			if($("#img_cardB").attr("value")>""){
				window.open($("#img_cardB").attr("value"));
			}
		});
		$("#img_education").click(function(){
			if($("#img_education").attr("value")>""){
				window.open($("#img_education").attr("value"));
			}
		});
	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id,ref){
		$.get("studentControl.asp?op=getNodeInfo&nodeID=" + id + "&refID=" + ref + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#studentID").val(ar[0]);
				$("#username").val(ar[1]);
				$("#name").val(ar[2]);
				$("#host").val(ar[29]);
				arr = [];
				if(ar[21] > ""){
					$("#img_photo").attr("src","/users" + ar[21]);
					$("#img_photo").attr("value","/users" + ar[21]);
				}else{
					$("#img_photo").attr("src","images/blank_photo.png");
					arr.push("," + "photo");
				}
				if(ar[22] > ""){
					$("#img_cardA").attr("src","/users" + ar[22]);
					$("#img_cardA").attr("value","/users" + ar[22]);
				}else{
					$("#img_cardA").attr("src","images/blank_cardA.png");
					arr.push("," + "cardA");
				}
				if(ar[23] > ""){
					$("#img_cardB").attr("src","/users" + ar[23]);
					$("#img_cardB").attr("value","/users" + ar[23]);
				}else{
					$("#img_cardB").attr("src","images/blank_cardB.png");
					arr.push("," + "cardB");
				}
				if(ar[24] > ""){
					$("#img_education").attr("src","/users" + ar[24]);
					$("#img_education").attr("value","/users" + ar[24]);
				}else{
					$("#img_education").attr("src","images/blank_education.png");
				}
				//$("#photo").html(c);
				//getDownloadFile("studentID");
				original_item = arr.join("").substr(1);
			}else{
				jAlert("该信息未找到！","信息提示");
			}
		});
	}
	
	function saveNode(){
		if(replace_item > ""){
			//上传被替换的图片
			//替换原来的图片资料
			var ar = new Array();
			ar = replace_item.split(",");
			$.each(ar,function(iNum,val){
				if(val=="photo"){
					//替换照片
					$.post(uploadURL + "/outfiles/uploadBase64img",{upID:"student_photo",username:$("#username").val(),currUser:currUser,imgData:cardJson.base64Data},function(re){
						//alert(re.status);
					});
				}
				if(val=="cardA"){
					//替换身份证正面
					$.post(uploadURL + "/outfiles/uploadBase64img",{upID:"student_IDcardA",username:$("#username").val(),currUser:currUser,imgData:cardJson.imageFront},function(re){
						//alert(re.status);
					});
				}
				if(val=="cardB"){
					//替换身份证反面
					$.post(uploadURL + "/outfiles/uploadBase64img",{upID:"student_IDcardB",username:$("#username").val(),currUser:currUser,imgData:cardJson.imageBack},function(re){
						//alert(re.status);
					});
				}
			});
		}
		jAlert("保存成功！","信息提示");
		return false;
	}
	
	function setButton(){
		$("#save").hide();
		$("*[tag='plus'").hide();
			if(checkPermission("studentAdd")){
				$("#save").show();
			}
			if(checkPermission("studentEdit")){
				$("#save").show();
			}
			if(checkPermission("studentPhoto")){
				$("*[tag='plus'").show();
				$("#save").show();
			}
	}

	function dealResponse(re){
		var k = 0;
		var n = studentExist(re.certNo);
		cardJson = re;
		if(re.expire<currDate.replace("-","")){
			alert("该身份证已过有效期。");
		}
		if(k==0 && op==0 && re.certNo != $("#username").val()){
			//编辑状态，如果是新的身份证，提示错误。
			k = 1;
			alert("身份证与当前人员信息不符。");
		}
		if(k==0 && op==0 && re.certNo == $("#username").val()){
			//编辑状态，如果是当前的身份证，则比较其信息
			checkName(re.name);
			//弹出窗口，可选择覆盖原来的照片、身份证图片
			//替换原来的图片资料
			showUseCardInfo();
			k = 1;
		}
	}
	
	function replaceImgFromCard(item){
		replace_item = item;
		//替换原来的图片资料
		var ar = new Array();
		ar = item.split(",");
		$.each(ar,function(iNum,val){
			if(val=="photo"){
				//替换照片
				$("#img_photo").attr("src","data:image/jpeg;base64,"+cardJson.base64Data);
			}
			if(val=="cardA"){
				//替换身份证正面
				$("#img_cardA").attr("src","data:image/jpeg;base64,"+cardJson.imageFront);
			}
			if(val=="cardB"){
				//替换身份证反面
				$("#img_cardB").attr("src","data:image/jpeg;base64,"+cardJson.imageBack);
			}
		});
	}
	
	function checkName(cname){
		if(cname != $("#name").val()){
			//校验姓名
			alert("当前姓名[" + $("#name").val() + "]与身份证信息不符。");
		}
	}

	function getUpdateCount(){
		return updateCount;
	}
</script>

</head>

<body style="background:#f0f0f0;">
 <!--#include file='commFloatDetail.asp' -->
 <!--#include file='commLoadFileDetail.asp' -->

<div id='layout' align='left' style="background:#f0f0f0;">	
	<div style="float:left;width:100%;">
		<div style="width:100%;float:left;margin:10;height:4px;"></div>
		<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;clear:both;">
			<input class="button" type="button" id="save" value="保存" />&nbsp;
			<input type="hidden" id="studentID" /><input type="hidden" id="username" /><input type="hidden" id="name" /><input type="hidden" id="host" />
		</div>

		<div style="width:100%;float:left;margin:10;height:4px;"></div>
	</div>
	<div style="padding: 5px;text-align:center;overflow:hidden;margin:0 auto;flot:right;background: #eeeeff;">
		<table style="width:99%;">
		<tr>
			<td align="right" style="width:15%;"><img id="add_img_photo" src="images/plus.png" tag="plus" /></td>
			<td align="center" style="width:85%;">
				<img id="img_photo" src="" value="" style='width:100px;background: #ccc;border:1px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);opacity: 0.8;' />
			</td>
		</tr>
		<tr>
			<td align="right" style="width:15%;"><img id="add_img_cardA" src="images/plus.png" tag="plus" /></td>
			<td style="width:85%;">
				<img id="img_cardA" src="" value="" style='width:150px;background: #ccc;border:1px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);opacity: 0.8;' />
			</td>
		</tr>
		<tr>
			<td align="right" style="width:15%;"><img id="add_img_cardB" src="images/plus.png" tag="plus" /></td>
			<td style="width:85%;">
				<img id="img_cardB" src="" value="" style='width:150px;background: #ccc;border:1px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);opacity: 0.8;' />
			</td>
		</tr>
		<tr>
			<td align="right" style="width:15%;"><img id="add_img_education" src="images/plus.png" tag="plus" /></td>
			<td style="width:85%;">
				<img id="img_education" src="" value="" style='width:150px;background: #ccc;border:1px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);opacity: 0.8;' />
			</td>
		</tr>
		<tr>
			<td align="left" colspan="2" style="width:100%;"><textarea id="text_reader_result" style="padding:5px;width:90%;background: #eeeeee;border:solid 1px #ccc;color:#ff0000;" rows="2"></textarea></td>
		</tr>
		</table>
	</div>
</div>
</body>
