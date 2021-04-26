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
		
		getComList("host","hostInfo","hostNo","hostName","status=0 order by hostNo",1);
		getComList("certID","certificateInfo","certID","certName","status=0 order by certID",1);
		getDicList("certKind","kindID",0);
		getDicList("statusEffect","status",0);
		getDicList("courseMark","mark",0);
		
		$.ajaxSetup({ 
			async: false 
		}); 
		
		if(op==0){
			getNodeInfo(nodeID);
		}
		setButton();
		
		$("#save").click(function(){
			saveNode();
		});
	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		$.get("courseControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#courseID").val(ar[1]);
				$("#courseName").val(ar[2]);
				$("#hours").val(ar[3]);
				$("#kindID").val(ar[4]);
				$("#status").val(ar[5]);
				$("#memo").val(ar[7]);
				$("#regDate").val(ar[8]);
				$("#registerName").val(ar[10]);
				$("#host").val(ar[11]);
				$("#certID").val(ar[13]);
				$("#completionPass").val(ar[14]);
				$("#deadline").val(ar[15]);
				$("#deadday").val(ar[16]);
				$("#period").val(ar[17]);
				$("#mark").val(ar[18]);
				$("#price").val(ar[20]);
				$("#price1").val(ar[21]);
				
				//getDownloadFile("courseID");
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		//alert("nodeID=" + $("#ID").val() + "&courseID=" + $("#courseID").val() + "&courseName=" + ($("#courseName").val()) + "&hours=" + $("#hours").val() + "&host=" + $("#host").val() + "&kindID=" + $("#kindID").val() + "&status=" + $("#status").val() + "&memo=" + ($("#memo").val()));
		$.get("courseControl.asp?op=update&nodeID=" + $("#ID").val() + "&courseID=" + $("#courseID").val() + "&price=" + $("#price").val() + "&price1=" + $("#price1").val() + "&courseName=" + escape($("#courseName").val()) + "&hours=" + $("#hours").val() + "&completionPass=" + $("#completionPass").val() + "&deadline=" + $("#deadline").val() + "&period=" + $("#period").val() + "&deadday=" + $("#deadday").val() + "&host=" + $("#host").val() + "&kindID=" + $("#kindID").val() + "&refID=" + $("#certID").val() + "&status=" + $("#status").val() + "&mark=" + $("#mark").val() + "&memo=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
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
		if(op ==1){
			setEmpty();
		}
		if(checkPermission("courseAdd")){
			$("#save").show();
		}
	}
	
	function setEmpty(){
		$("#ID").val(0);
		$("#courseID").val("");
		$("#courseName").val("");
		$("#memo").val("");
		$("#status").val(0);
		$("#regDate").val(currDate);
		$("#registerID").val(currUser);
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
				<td align="right">课程编号</td><input id="ID" type="hidden" />
				<td><input type="text" id="courseID" size="25" /></td>
				<td align="right">课程名称</td>
				<td><input type="text" id="courseName" size="25" /></td>
			</tr>
			<tr>
				<td align="right">课时</td>
				<td><input type="text" id="hours" size="15" />小时</td>
				<td align="right">认证项目</td>
				<td><select id="certID" style="width:180px;"></select></td>
			</tr>
			<tr>
				<td align="right">类型</td>
				<td><select id="kindID" style="width:100px;"></select></td>
				<td align="right">专属公司</td>
				<td><select id="host" style="width:180px;"></select></td>
			</tr>
			<tr>
				<td align="right">培训周期</td>
				<td><input type="text" id="period" size="15" />天</td>
				<td align="right">完成率</td>
				<td><input type="text" id="completionPass" size="5" />% (无证书课程)</td>
			</tr>
			<tr>
				<td align="right">退课限制</td>
				<td><input type="text" id="deadline" size="5" />% 完成率</td>
				<td align="right">退课限制</td>
				<td><input type="text" id="deadday" size="5" />开始天数</td>
			</tr>
			<tr>
				<td align="right">可选人员</td>
				<td><select id="mark" style="width:180px;"></select></td>
				<td align="right">收费标准</td>
				<td>&nbsp;初训<input type="text" id="price" size="3" />&nbsp;复训<input type="text" id="price1" size="3" />&nbsp;元</td>
			</tr>
			<tr>
				<td align="right">说明</td>
				<td colspan="5"><textarea id="memo" style="padding:2px;" rows="5" cols="75"></textarea></td>
			</tr>
			<tr>
				<td align="right">状态</td>
				<td><select id="status" style="width:100px;"></select></td>
				<td align="right">登记人</td>
				<td><input class="readOnly" type="text" id="registerName" size="25" readOnly="true" /></td>
			</tr>
			</table>
			</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
  	<input class="button" type="button" id="save" name="save" value="保存" />&nbsp;
  </div>
</div>
</body>
