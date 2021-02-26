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
	var nodeID = "";
	var op = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 
		setButton();
		
		getNodeInfo(nodeID);
		getDiplomaListByBatch();

		$("#redo").click(function(){
			getSelCart("chkStamp");
			jConfirm("确定要重新制作证书吗？证书编号将保持不变。","确认",function(r){
				if(r){
					//alert($("#searchStudentNeedDiplomaCert").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&username=" + currUser);
					$.getJSON(uploadURL + "/outfiles/generate_diploma_byCertID?certID=" + $("#certID").val() + "&host=" + $("#host").val() + "&batchID=" + $("#ID").val() + "&selList1=" + selList + "&username=" + currUser ,function(data){
						if(data>""){
							jAlert("证书重新制作成功 <a href='" + data + "' target='_blank'>下载文件</a>");
							getGenerateDiplomaList();
						}else{
							jAlert("没有可供处理的数据。");
						}
					});
				}
			});
		});
		$("#save").click(function(){
			saveNode();
		});
	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		//alert(id);
		$.get("diplomaControl.asp?op=getGenerateDiplomaNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			var c = "";
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#certID").val(ar[1]);
				$("#certName").val(ar[2]);
				$("#qty").val(ar[3]);
				$("#host").val(ar[4]);
				$("#firstID").val(ar[8]);
				$("#lastID").val(ar[9]);
				$("#title").val(ar[6]);
				$("#memo").val(ar[10]);
				$("#regDate").val(ar[11]);
				$("#registerName").val(ar[12]);
				$("#upload1").html("<a href='javascript:showLoadFile(\"gen_diploma\",\"" + ar[0] + "\",\"diploma\",\"\");' style='padding:3px;'>上传</a>");
				var c = "";
				if(ar[7] > ""){
					c += "<a href='/users" + ar[7] + "' target='_blank'>证书打印版</a>";
				}
				if(c == ""){c = "&nbsp;&nbsp;还未上传";}
				$("#photo").html(c);
				//getDownloadFile("generateDiplomaID");
				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}

	function getDiplomaListByBatch(){
		//alert(nodeID);
		$.get("diplomaControl.asp?op=getDiplomaListByBatch&refID=" + nodeID,function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#dimplomaListByBatch").empty();
			arr = [];		
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='diplomaTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='18%'>身份证</th>");
			arr.push("<th width='12%'>姓名</th>");
			arr.push("<th width='30%'>部门</th>");
			arr.push("<th width='12%'>照</th>");
			arr.push("<th width='5%'>章</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				var imgChk = "";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='left'>" + ar1[1] + "</td>");
					arr.push("<td class='left'>" + ar1[2] + "</td>");
					arr.push("<td class='left'>" + ar1[3] + "</td>");
					imgChk = "<img src='users" + ar1[5] + "' style='width:50px;background: #ccc;border:2px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);'>";
					arr.push("<td class='center'>" + imgChk + "</td>");
					if(ar1[4]==1){
						h = "checked"
					}else{
						h = "";
					}
					arr.push("<td class='left'>" + "<input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + ar1[0] + "' name='chkStamp' " + h + ">" + "</td>");
					arr.push("</tr>");
				});
			}
			arr.push("</tbody>");
			arr.push("<tfoot>");
			arr.push("<tr>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#dimplomaListByBatch").html(arr.join(""));
			arr = [];
			$('#diplomaTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"iDisplayLength": 100,
				"bInfo": true,
				"aoColumnDefs": []
			});
		});
	}
	
	function saveNode(){
		if($("#memo").val().length < 3){
			jAlert("备注信息请至少填写3个字的内容。");
			return false;
		}
		//alert($("#studentID").val() + "&item=" + ($("#memo").val()));
		$.get("diplomaControl.asp?op=setGenerateDiplomaMemo&nodeID=" + $("#ID").val() + "&item=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				jAlert("保存成功！","信息提示");
				updateCount += 1;
			}
		});
		return false;
	}
	
	function setButton(){
		$("#upload1").hide();
		if(checkPermission("diplomaAdd")){
			$("#upload1").show();
			$("#redo").show();
		}
	}
	
	function setEmpty(){
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
				<td align="right">证书</td><input type="hidden" id="ID" /><input type="hidden" id="certID" />
				<td><input class="readOnly" type="text" id="certName" size="25" readOnly="true" /></td>
				<td align="right">数量</td><input type="hidden" id="host" />
				<td><input class="readOnly" type="text" id="qty" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">最小序号</td>
				<td><input class="readOnly" type="text" id="firstID" size="25" readOnly="true" /></td>
				<td align="right">最大序号</td>
				<td><input class="readOnly" type="text" id="lastID" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">公司</td>
				<td><input class="readOnly" type="text" id="title" size="25" readOnly="true" /></td>
				<td align="right">资料</td>
				<td>
					<span id="upload1" style="margin-left:10px;border:1px solid orange;"></span>
					<span id="photo" style="margin-left:10px;"></span>
				</td>
			</tr>
			<tr>
				<td align="right">制作日期</td>
				<td><input class="readOnly" type="text" id="regDate" size="25" readOnly="true" /></td>
				<td align="right">制作人</td>
				<td><input class="readOnly" type="text" id="registerName" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">备注</td>
				<td colspan="5"><input type="text" id="memo" size="70" /></td>
			</tr>
			</table>
			</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
  	<input class="button" type="button" id="save" name="save" value="保存备注" />&nbsp;
  	<input class="button" type="button" id="redo" name="redo" value="重新生成" />&nbsp;
	<hr size="1" noshadow />
	<div id="dimplomaListByBatch">
	</div>
  </div>
</div>
</body>
