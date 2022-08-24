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
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		op = "<%=op%>";
		
		getDicList("hostKind","kindID",0);
		getDicList("statusEffect","status",0);
		
		$.ajaxSetup({ 
			async: false 
		}); 
		
		if(op==0){
			getNodeInfo(nodeID);
		}
		setButton();
		
		$("#btnSave").click(function(){
			saveNode();
		});
		$("#btnDel").click(function(){
			$.messager.confirm("确认","确定要删除该单位吗？",function(r){
				if(r){
					$.messager.prompt('信息记录', '请填写删除原因:', function(r){
						if (r.length > 1){
							$.get("hostControl.asp?op=delNode&nodeID=" + $("#hostID").val() + "&item=" + escape(r) + "&times=" + (new Date().getTime()),function(re){
								updateCount += 1;
								getNodeInfo(nodeID);
								jAlert("删除成功。");
							});
						}else{
							jAlert("请认真填写删除原因。");
						}
					});
				}
			});
		});
		
		$("#btnAdd").click(function(){
			op = 1;
			setButton();
		});
	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		$.get("hostControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#hostID").val(ar[0]);
				$("#hostNo").val(ar[1]);
				$("#hostName").val(ar[2]);
				$("#title").val(ar[3]);
				$("#kindID").val(ar[4]);
				$("#status").val(ar[5]);
				$("#linker").val(ar[8]);
				$("#phone").val(ar[9]);
				$("#email").val(ar[10]);
				$("#address").val(ar[11]);
				$("#memo").val(ar[13]);
				$("#regDate").val(ar[14]);
				$("#registerName").val(ar[16]);
				$("#upload1").html("<a href='javascript:showLoadFile(\"host_logo\",\"" + ar[1] + "\",\"host\",\"\");' style='padding:3px;'>上传</a>");
				var c = "";
				if(ar[12] > ""){
					c += "<a href='/users" + ar[12] + "' target='_blank'>LOGO</a>";
				}
				if(ar[17] > ""){
					c += "&nbsp;&nbsp;<a href='/users" + ar[17] + "' target='_blank'>登录二维码</a>";
				}
				if(c == ""){c = "&nbsp;&nbsp;还未上传";}
				$("#photo").html(c);
				
				//getDownloadFile("hostID");
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		//alert($("#hostID").val() + "&item=" + ($("#memo").val()));
		if($("#hostName").val()=="" || $("#title").val()==""){
			jAlert("单位名称或简称不能为空");
			return false;
		}
		$.get("hostControl.asp?op=update&nodeID=" + $("#hostID").val() + "&refID=" + $("#hostNo").val() + "&hostName=" + escape($("#hostName").val()) + "&title=" + escape($("#title").val()) + "&linker=" +  escape($("#linker").val()) + "&kindID=" + $("#kindID").val() + "&status=" + $("#status").val() + "&phone=" +  escape($("#phone").val()) + "&email=" + escape($("#email").val()) + "&address=" + escape($("#address").val()) + "&memo=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
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
		$("#btnSave").hide();
		$("#btnAdd").hide();
		$("#btnDel").hide();
		if(checkPermission("hostAdd")){
			$("#btnSave").show();
			$("#btnAdd").show();
			$("#btnDel").show();
		}
		if(op ==1){
			setEmpty();
			$("#btnAdd").hide();
			$("#btnDel").hide();
		}
	}
	
	function setEmpty(){
		nodeID = 0;
		$("#hosNo").val("");
		$("#hostID").val(0);
		$("#hostName").val("");
		$("#status").val(0);
		$("#kindID").val(0);
		$("#linker").val("");
		$("#phone").val("");
		$("#email").val("");
		$("#address").val("");
		$("#memo").val("");
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
				<td align="right">单位名称</td>
				<td><input type="text" id="hostName" size="25" /></td>
				<td align="right">单位简称</td>
				<td><input type="text" id="title" size="25" /></td>
			</tr>
			<tr>
				<td align="right">标识</td><input id="hostID" type="hidden" />
				<td><input type="text" id="hostNo" size="25" /></td>
				<td align="right">资料</td>
				<td>
					<span id="upload1" style="margin-left:10px;border:1px solid orange;"></span>
					<span id="photo" style="margin-left:10px;"></span>
				</td>
			</tr>
			<tr>
				<td align="right">类型</td>
				<td><select id="kindID" style="width:100px;"></select></td>
				<td align="right">状态</td>
				<td><select id="status" style="width:100px;"></select></td>
			</tr>
			<tr>
				<td align="right">联系人</td>
				<td><input type="text" id="linker" size="25" /></td>
				<td align="right">地址</td>
				<td><input type="text" id="address" size="25" /></td>
			</tr>
			<tr>
				<td align="right">电话</td>
				<td><input type="text" id="phone" size="25" /></td>
				<td align="right">邮箱</td>
				<td><input type="text" id="email" size="25" /></td>
			</tr>
			<tr>
				<td align="right">说明</td>
				<td colspan="5"><textarea id="memo" style="padding:2px; width:100%;" rows="5"></textarea></td>
			</tr>
			<tr>
				<td align="right">登记人</td>
				<td><input class="readOnly" type="text" id="registerName" size="25" readOnly="true" /></td>
				<td align="right">登记日期</td>
				<td><input class="readOnly" type="text" id="regDate" size="25" readOnly="true" /></td>
			</tr>
			</table>
			</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
  	<input class="button" type="button" id="btnSave" value="保存" />&nbsp;
  	<input class="button" type="button" id="btnAdd" value="添加" />&nbsp;
  	<input class="button" type="button" id="btnDel" value="删除" />&nbsp;
  </div>
</div>
</body>
