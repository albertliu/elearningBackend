<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
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
	var nodeID = 0;
	var op = 0;
	var refID = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		refID = "<%=refID%>";
		op = "<%=op%>";

		getComList("lessonID","lessonInfo","lessonID","lessonName","status=0 order by lessonID",1);
		getDicList("statusEffect","status",0);
		
		$.ajaxSetup({ 
			async: false 
		}); 
		
		if(op==0){
			getNodeInfo(nodeID);
		}
		setButton();
		
		$("#add").click(function(){
			op = 1;
			setButton();
		});
		$("#save").click(function(){
			saveNode();
		});
	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		$.get("videoControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#videoID").val(ar[1]);
				$("#videoName").val(ar[2]);
				$("#minutes").val(ar[3]);
				$("#kindID").val(ar[4]);
				$("#status").val(ar[5]);
				$("#lessonID").val(ar[8]);
				$("#type").val(ar[9]);
				$("#author").val(ar[10]);
				$("#proportion").val(ar[11]);
				$("#memo").val(ar[12]);
				$("#regDate").val(ar[13]);
				//$("#registerName").val(ar[15]);
				$("#upload1").html("<a href='javascript:showLoadFile(\"course_video\",\"" + ar[1] + "\",\"course\",\"\");'>上传</a>");
				var c = "";
				if(ar[7] > ""){
					c += "&nbsp;&nbsp;<a href='/users" + ar[7] + "' target='_blank'>视频</a>";
				}
				if(c == ""){c = "&nbsp;&nbsp;还未上传";}
				$("#photo").html(c);
				
				//getDownloadFile("videoID");
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		//alert($("#videoID").val() + "&item=" + ($("#memo").val()));
		$.get("videoControl.asp?op=update&nodeID=" + $("#ID").val() + "&videoID=" + $("#videoID").val() + "&videoName=" + escape($("#videoName").val()) + "&minutes=" + $("#minutes").val() + "&type=" + $("#type").val() + "&refID=" + $("#lessonID").val() + "&proportion=" + $("#proportion").val() + "&author=" + $("#author").val() + "&kindID=0&status=" + $("#status").val() + "&memo=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				if(op == 1){
					op = 0;
					getNodeInfo(ar[1]);
				}
				jAlert("保存成功！","信息提示");
				updateCount += 1;
			}
			if(ar[0] != 0){
				jAlert("未能成功提交，请退出后重试。","信息提示");
			}
		});
		//return false;
	}
	
	function setButton(){
		$("#save").hide();
		$("#add").hide();
		if(checkPermission("courseAdd")){
			$("#save").show();
			$("#add").show();
		}
		if(op ==1){
			setEmpty();
			$("#add").hide();
		}
	}
	
	function setEmpty(){
		$("#ID").val(0);
		$("#kindID").val(0);
		$("#videoID").val("");
		$("#videoName").val("");
		$("#memo").val("");
		$("#status").val(0);
		$("#regDate").val(currDate);
		$("#registerName").val(currUserName);
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
	
	<div style="width:100%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8;">
			<form id="detailCover" name="detailCover" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
			<table>
			<tr>
				<td align="right">视频编号</td><input id="ID" type="hidden" />
				<td><input type="text" id="videoID" size="25" /></td>
				<td align="right">视频名称</td><input id="kindID" type="hidden" />
				<td><input type="text" id="videoName" size="25" /></td>
			</tr>
			<tr>
				<td align="right">课节</td>
				<td><select id="lessonID" style="width:100px;"></select></td>
				<td align="right">时长</td>
				<td><input type="text" id="minutes" size="15" />分钟</td>
			</tr>
			<tr>
				<td align="right">比重</td>
				<td><input type="text" id="proportion" size="15" />%</td>
				<td align="right">类型</td>
				<td><input type="text" id="type" size="15" /></td>
			</tr>
			<tr>
				<td align="right">作者</td>
				<td><input type="text" id="author" size="25" /></td>
				<td align="right">状态</td>
				<td><select id="status" style="width:100px;"></select></td>
			</tr>
			<tr>
				<td align="right">说明</td>
				<td colspan="5"><textarea id="memo" style="padding:2px;" rows="5" cols="75"></textarea></td>
			</tr>
			<tr>
				<td align="right">登记日期</td>
				<td><input class="readOnly" type="text" id="regDate" size="25" readOnly="true" /></td>
				<td align="right">文件</td>
				<td>
					<span id="upload1" style="margin-left:20px;"></span>
					<span id="photo" style="margin-left:20px;"></span>
				</td>
			</tr>
			</table>
			</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
  	<input class="button" type="button" id="save" name="save" value="保存" />&nbsp;
  	<input class="button" type="button" id="add" name="add" value="新增" />&nbsp;
  </div>
</div>
</body>
