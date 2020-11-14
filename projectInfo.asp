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
		
		getComList("certID","certificateInfo","certID","certName","status=0 order by certID",1);
		getComList("host","hostInfo","hostNo","title","status=0 order by hostName",1);
		$("#deadline").click(function(){WdatePicker();});
		
		$.ajaxSetup({ 
			async: false 
		}); 
		
		if(op==0){
			getNodeInfo(nodeID);
		}
		setButton();

		$("#cancel").click(function(){
			jConfirm('确定要撤回这个通知吗?', '确认对话框', function(r) {
				if(r){
					setStatus(0);
				}
			});
		});

		$("#issue").click(function(){
			jConfirm('确定要发布这个通知吗?', '确认对话框', function(r) {
				if(r){
					setStatus(1);
				}
			});
		});

		$("#close").click(function(){
			jConfirm('确定要关闭这个通知吗?', '确认对话框', function(r) {
				if(r){
					setStatus(2);
				}
			});
		});

		$("#del").click(function(){
			jConfirm('确定要删除这个通知吗?', '确认对话框', function(r) {
				if(r){
					setStatus(9);
				}
			});
		});

		$("#btnEntryForm").click(function(){
			var n = $("#projectCount").val().split('/');
			if(n[0]==0){
				jAlert("已确认的学员为0，无法生成报名表。");
				return false;
			}
			jConfirm('确定要生成培训报名表[' + n[0] + '个学员]吗?', '确认对话框', function(r) {
				if(r){
					generateEntryForm();
				}
			});
		});
		
		$("#certID").change(function(){
			if(op==1){
				$("#projectName").val("关于《" + $("#certID").find("option:selected").text() + "》的招生通知");
			}
		});
		
		$("#save").click(function(){
			saveNode();
		});
	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		$.get("projectControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#projectID").val(ar[1]);
				$("#projectName").val(ar[2]);
				$("#certID").val(ar[3]);
				$("#kindID").val(ar[4]);
				$("#status").val(ar[5]);
				$("#object").val(ar[6]);
				$("#statusName").val(ar[8]);
				$("#address").val(ar[9]);
				$("#deadline").val(ar[10]);
				$("#host").val(ar[11]);
				$("#memo").val(ar[13]);
				$("#regDate").val(ar[14]);
				$("#registerName").val(ar[16]);
				$("#phone").val(ar[18]);
				$("#email").val(ar[19]);
				$("#projectCount").val(ar[20]);
				$("#upload1").html("<a href='javascript:showLoadFile(\"project_brochure\",\"" + ar[1] + "\",\"project\",\"" + ar[11] + "\");' style='padding:3px;'>上传</a>");
				var c = "";
				if(ar[21] > ""){
					c += "<a href='/users" + ar[21] + "' target='_blank'>招生简章</a>";
				}
				if(c == ""){c = "&nbsp;&nbsp;还未上传";}
				$("#photo").html(c);
				var c1 = "";
				if(ar[22] > ""){
					c1 += "<a href='/users" + ar[22] + "' target='_blank'>报名表</a>";
				}
				if(c1 == ""){c1 = "&nbsp;&nbsp;还未生成";}
				$("#entryform").html(c1);
				
				//getDownloadFile("projectID");
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		if($("#projectName").val().length < 3){
			jAlert("标题内容请至少填写3个字的内容。");
			return false;
		}
		//alert($("#projectID").val() + "&projectName=" + ($("#memo").val()));
		$.get("projectControl.asp?op=update&nodeID=" + $("#ID").val() + "&keyID=" + $("#projectID").val() + "&item=" + escape($("#projectName").val()) + "&refID=" + $("#certID").val() + "&kindID=" + $("#kindID").val() + "&deadline=" + $("#deadline").val() + "&object=" + escape($("#object").val()) + "&address=" + escape($("#address").val()) + "&phone=" + escape($("#phone").val()) + "&email=" + escape($("#email").val()) + "&host=" + $("#host").val() + "&memo=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				if(op == 1){
					op = 0;
				}
				jAlert("保存成功！","信息提示");
				nodeID = ar[1];
				getNodeInfo(nodeID);
				updateCount += 1;
			}
			if(ar[0] != 0){
				jAlert("未能成功提交，请退出后重试。","信息提示");
			}
		});
		//return false;
	}
	
	function generateEntryForm(){
		$.getJSON(uploadURL + "/outfiles/generate_entryform_byProjectID?certID=" + $("#certID").val() + "&projectID=" + $("#projectID").val() + "&registerID=" + currUser ,function(data){
			if(data>""){
				jAlert("报名表已生成 <a href='" + data + "' target='_blank'>下载文件</a>");
				getNodeInfo(nodeID);
			}else{
				jAlert("没有可供处理的数据。");
			}
		});
	}
	
	function setStatus(x){
		//alert($("#projectID").val() + "&projectName=" + ($("#memo").val()));
		$.get("projectControl.asp?op=setProjectStatus&nodeID=" + $("#ID").val() + "&status=" + x + "&times=" + (new Date().getTime()),function(data){
			jAlert("操作成功！","信息提示");
			getNodeInfo(nodeID);
			updateCount += 1;
		});
		//return false;
	}
	
	function setButton(){
		$("#cancel").hide();
		$("#del").hide();
		$("#close").hide();
		$("#issue").hide();
		$("#save").hide();
		$("#btnEntryForm").hide();
		if(checkPermission("projectAdd")){
			$("#save").show();
			$("#btnEntryForm").show();
			if(op == 0){
				var s = $("#status").val();
				if(s==1){	//发布的通知可以撤销
					$("#cancel").show();
				}
				if(s != 1){	//发布状态以外的其他状态都可以进行发布
					$("#issue").show();
				}
				if(s != 2){	//关闭状态以外的其他状态都可以进行关闭
					$("#close").show();
				}
				if(s != 9){	//删除状态以外的其他状态都可以进行删除
					$("#del").show();
				}
			}
		}
		if(op ==1){
			setEmpty();
		}
	}
	
	function setEmpty(){
		$("#ID").val(0);
		$("#projectID").val("");
		$("#certID").val("");
		$("#deadline").val("");
		$("#status").val(0);
		$("#kindID").val(0);
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
				<td align="right">编号</td><input id="ID" type="hidden" /><input type="hidden" id="kindID" /><input type="hidden" id="status" />
				<td><input class="readOnly" type="text" id="projectID" size="24" readOnly="true" /></td>
				<td align="right">项目</td>
				<td><select id="certID" style="width:200px;"></select></td>
			</tr>
			<tr>
				<td align="right">招生对象</td>
				<td><input type="text" id="object" size="24" /></td>
				<td align="right">标题</td>
				<td><input type="text" id="projectName" size="33" /></td>
			</tr>
			<tr>
				<td align="right">截止日期</td>
				<td><input type="text" id="deadline" size="24" /></td>
				<td align="right">培训地点</td>
				<td><input type="text" id="address" size="33" /></td>
			</tr>
			<tr>
				<td align="right">联系电话</td>
				<td><input type="text" id="phone" size="24" /></td>
				<td align="right">电子邮箱</td>
				<td><input type="text" id="email" size="33" /></td>
			</tr>
			<tr>
				<td align="right">状态</td>
				<td><input class="readOnly" type="text" id="statusName" size="24" readOnly="true" /></td>
				<td align="right">发布对象</td>
				<td><select id="host" style="width:200px;"></select></td>
			</tr>
			<tr>
				<td align="right">备注</td>
				<td colspan="5"><textarea id="memo" style="padding:2px;" rows="4" cols="75"></textarea></td>
			</tr>
			<tr>
				<td align="right">发布人</td>
				<td><input class="readOnly" type="text" id="registerName" size="24" readOnly="true" /></td>
				<td align="right">发布日期</td>
				<td><input class="readOnly" type="text" id="regDate" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">报名人数</td>
				<td><input class="readOnly" type="text" id="projectCount" size="10" readOnly="true" />&nbsp;确认/报名</td>
				<td align="right">招生简章</td>
				<td>
					<span id="upload1" style="margin-left:20px;border:1px solid orange;"></span>
					<span id="photo" style="margin-left:20px;"></span>
				</td>
			</tr>
			<tr>
				<td align="right">报名表</td>
				<td>
					<span ><input class="button" type="button" id="btnEntryForm" value="生成" />&nbsp;</span>
					<span id="entryform" style="margin-left:20px;"></span>
				</td>
				<td align="right"></td>
				<td></td>
			</tr>
			</table>
			</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
  	<input class="button" type="button" id="save" value="保存" />&nbsp;
  	<input class="button" type="button" id="issue" value="发布" />&nbsp;
  	<input class="button" type="button" id="close" value="关闭" />&nbsp;
  	<input class="button" type="button" id="cancel" value="撤回" />&nbsp;
  	<input class="button" type="button" id="del" value="删除" />&nbsp;
  </div>
</div>
</body>
