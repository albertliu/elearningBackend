﻿<!--#include file="js/doc.js" -->

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
	var kindID = "";
	var refID = "";
	var keyID = 0;
	var item = "";
	var op = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		kindID = "<%=kindID%>";		//certID
		refID = "<%=refID%>";		//selList
		keyID = "<%=keyID%>";		//selCount
		item = "<%=item%>";		//className
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 
		$("#startDate").click(function(){WdatePicker();});
		$("#class_startDate").click(function(){WdatePicker();});
		$("#class_endDate").click(function(){WdatePicker();});
		getDicList("diplomaFontSize","kindID",0);
		getDicList("diplomaStyle","styleID",0);
		setButton();
		
		if(op==0){
			getNodeInfo(nodeID);
			getDiplomaListByBatch();
		}

		if(item>""){
			$("#memo").val(item);
		}

		$("#do").click(function(){
			if($("#startDate").val()==""){
				jAlert("请填写发证日期。");
				return false;
			}
			if($("#class_startDate").val()==""){
				jAlert("请填写培训起始日期。");
				return false;
			}
			if($("#class_endDate").val()==""){
				jAlert("请填写培训结束日期。");
				return false;
			}
			if($("#class_endDate").val() < $("#class_startDate").val()){
				jAlert("开始日期不得大于结束日期。");
				return false;
			}
			if($("#class_endDate").val() > $("#startDate").val()){
				jAlert("结束日期不得大于发证日期。");
				return false;
			}
			//jAlert(getSession(refID));
			
			jConfirm("确定要制作" + keyID + "个[" + $("#styleID").find("option:selected").text() + "]样式的证书吗？","确认",function(r){
				if(r){
					//$.getJSON(uploadURL + "/outfiles/generate_diploma_byClassID?ID=0&mark=0&certID=" + kindID + "&selList=" + refID + "&startDate=" + $("#startDate").val() + "&class_startDate=" + $("#class_startDate").val() + "&class_endDate=" + $("#class_endDate").val() + "&registerID=" + currUser ,function(data){
					$.post(uploadURL + "/outfiles/generate_diploma_byClassID?ID=0&card=" + $("#styleID").val() + "&mark=0&certID=" + kindID + "&startDate=" + $("#startDate").val() + "&class_startDate=" + $("#class_startDate").val() + "&class_endDate=" + $("#class_endDate").val() + "&memo=" + $("#memo").val() + "&registerID=" + currUser, {"selList": getSession(refID)} ,function(data){
						if(data>0){
							jAlert("证书制作成功。");
							nodeID = data;
							op = 0;
							updateCount += 1;
							getNodeInfo(nodeID);
						}else{
							jAlert("已保存。");
						}
					});
				}
			});
		});

		$("#redo").click(function(){
			jConfirm("确定要重新制作证书吗？证书编号将保持不变。","确认",function(r){
				if(r){
					//alert($("#searchStudentNeedDiplomaCert").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&username=" + currUser);
					$.post(uploadURL + "/outfiles/generate_diploma_byClassID?card=" + $("#styleID").val() + "&ID=" + $("#ID").val() + "&mark=0&certID=" + $("#certID").val() + "&kindID=" + $("#kindID").val() + "&startDate=" + $("#startDate").val() + "&class_startDate=" + $("#class_startDate").val() + "&class_endDate=" + $("#class_endDate").val() + "&registerID=" + currUser, {selList:""} ,function(data){
						if(data>""){
							jAlert("证书重新制作成功 <a href='" + data + "' target='_blank'>下载文件</a>");
							updateCount += 1;
						}else{
							jAlert("没有可供处理的数据。");
						}
					});
				}
			});
		});

		$("#cancelDiploma").click(function(){
			getSelCart("");
			if(selCount==0){
				jAlert("请选择要撤销证书的人员。");
				return false;
			}
			jConfirm("确定要撤销这" + selCount + "个人的证书吗？将重新回到待发证状态。","确认",function(r){
				if(r){
					//alert($("#searchStudentNeedDiplomaCert").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&username=" + currUser);
					$.post(uploadURL + "/outfiles/cancel_diplomas?kind=0&registerID=" + currUser, {"selList":selList} ,function(data){
						if(data>""){
							jAlert("证书已撤销");
							updateCount += 1;
							getDiplomaListByBatch();
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
		$("#list").click(function(){
			outputExcelBySQL('x04','file',nodeID,0,0);
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
				//$("#title").val(ar[6]);
				$("#memo").val(ar[10]);
				$("#regDate").val(ar[11]);
				$("#registerName").val(ar[12]);
				$("#printDate").val(ar[14]);
				$("#deliveryDate").val(ar[16]);
				$("#startDate").val(ar[17]);
				$("#class_startDate").val(ar[18]);
				$("#class_endDate").val(ar[19]);
				$("#photoDate").val(ar[21]);
				$("#kindID").val(ar[22]);
				$("#styleID").val(ar[23]);
				if(ar[13]==1){
					$("#printed").prop("checked",true);
				}else{
					$("#printed").prop("checked",false);
				}
				if(ar[15]==1){
					$("#delivery").prop("checked",true);
				}else{
					$("#delivery").prop("checked",false);
				}
				if(ar[20]==1){
					$("#photos").prop("checked",true);
				}else{
					$("#photos").prop("checked",false);
				}
				var c = "";
				if(ar[7] > ""){
					c += "<a href='/users" + ar[7] + "' target='_blank'>证书打印</a>";
					$("#list").html("<a href=''>证书清单</a>");
				}
				if(c == ""){c = "&nbsp;&nbsp;还未制作";}
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
			arr.push("<th width='14%'>姓名</th>");
			arr.push("<th width='30%'>部门</th>");
			arr.push("<th width='15%'>学号</th>");
			arr.push("<th width='12%'>照</th>");
			arr.push("<th width='1%'></th>");
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
					if(ar1[5]>""){
						imgChk = "<img id='photo" + ar1[1] + "' src='users" + ar1[5] + "?times=" + (new Date().getTime()) + "' onclick='showCropperInfo(\"users" + ar1[5] + "\",\"" + ar1[1] + "\",\"photo\",\"\",0,1)' style='width:50px;background: #ccc;border:2px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);'>";
					}else{
						imgChk = "";
					}
					arr.push("<td class='left'>" + ar1[7] + "</td>");
					arr.push("<td class='center'>" + imgChk + "</td>");
					arr.push("<td class='left'>" + "<input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + ar1[0] + "' name='visitstockchk'></td>");
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
				"aLengthMenu":[15,30,50,100,500],
				"iDisplayLength": 500,
				"bInfo": true,
				"aoColumnDefs": []
			});
		});
	}
	
	function saveNode(){
		if($("#startDate").val()==""){
			jAlert("请填写发证日期。");
			return false;
		}
		if($("#class_startDate").val()==""){
			jAlert("请填写培训起始日期。");
			return false;
		}
		if($("#class_endDate").val()==""){
			jAlert("请填写培训结束日期。");
			return false;
		}
		if($("#class_endDate").val() < $("#class_startDate").val()){
			jAlert("开始日期不得大于结束日期。");
			return false;
		}
		if($("#class_endDate").val() > $("#startDate").val()){
			jAlert("结束日期不得大于发证日期。");
			return false;
		}
		var printed = 0;
		if($("#printed").attr("checked")){printed = 1;}
		var delivery = 0;
		if($("#delivery").attr("checked")){delivery = 1;}
		var photo = 0;
		if($("#photos").attr("checked")){photo = 1;}
		//alert($("#studentID").val() + "&item=" + ($("#memo").val()));
		$.get("diplomaControl.asp?op=updateGenerateDiplomaMemo&nodeID=" + $("#ID").val() + "&keyID=" + $("#styleID").val() + "&kindID=" + $("#kindID").val() + "&printed=" + printed + "&delivery=" + delivery + "&photo=" + photo + "&printDate=" + $("#printDate").val() + "&deliveryDate=" + $("#deliveryDate").val() + "&photoDate=" + $("#photoDate").val() + "&startDate=" + $("#startDate").val() + "&class_startDate=" + $("#class_startDate").val() + "&class_endDate=" + $("#class_endDate").val() + "&memo=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar[0] == 0){
				jAlert("保存成功！","信息提示");
				updateCount += 1;
				getNodeInfo(nodeID);
			}
		});
		return false;
	}
	
	function setButton(){
		$("#upload1").hide();
		$("#redo").hide();
		$("#do").hide();
		$("#save").hide();
		$("#cancelDiploma").hide();
		if(op == 1){
			$("#do").show();
			setEmpty();
		}
		if(op==0 && checkPermission("diplomaAdd")){
			$("#upload1").show();
			$("#redo").show();
		}
		if(op==0 && checkPermission("cancelDiploma")){
			$("#cancelDiploma").show();
		}
		if(op==0 && (checkPermission("diplomaPrint") || checkPermission("diplomaAdd"))){
			$("#save").show();
		}
	}
	
	function setEmpty(){
		$("#startDate").val(currDate);
		$("#class_startDate").val(currDate);
		$("#class_endDate").val(currDate);
		$("#styleID").val(1);
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
				<td align="right">培训开始</td>
				<td><input class="mustFill" type="text" id="class_startDate" size="25" /></td>
				<td align="right">培训结束</td>
				<td><input class="mustFill" type="text" id="class_endDate" size="25" /></td>
			</tr>
			<tr>
				<td align="right">发证日期</td>
				<td><input class="mustFill" type="text" id="startDate" size="25" /></td>
				<td align="right">资料</td>
				<td>
					<span id="list" style="margin-left:10px;"></span>
					<span id="photo" style="margin-left:10px;"></span>
				</td>
			</tr>
			<tr>
				<td align="right">证书样式</td>
				<td><select id="styleID" style="width:60px;"></select>&nbsp;&nbsp;&nbsp;字体<select id="kindID" style="width:60px;"></select></td>
				<td align="right">制作</td>
				<td><input class="readOnly" type="text" id="registerName" size="10" readOnly="true" />&nbsp;&nbsp;<input class="readOnly" type="text" id="regDate" size="10" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">备注</td>
				<td colspan="5"><input type="text" id="memo" size="70" /></td>
			</tr>
			<tr>
				<td align="right" colspan="6">
				照片移交<input style="border:0px;" type="checkbox" id="photos" value="" />&nbsp;&nbsp;<input class="readOnly" type="text" id="photoDate" size="8" readOnly="true" />
				&nbsp;证书打印<input style="border:0px;" type="checkbox" id="printed" value="" />&nbsp;&nbsp;<input class="readOnly" type="text" id="printDate" size="8" readOnly="true" />
				&nbsp;证书发放<input style="border:0px;" type="checkbox" id="delivery" value="" />&nbsp;&nbsp;<input class="readOnly" type="text" id="deliveryDate" size="8" readOnly="true" />
				</td>
			</tr>
			</table>
			</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
		<input class="button" type="button" id="save" value="保存" />&nbsp;
		<input class="button" type="button" id="redo" value="重新生成" />&nbsp;
		<input class="button" type="button" id="do" value="生成证书" />&nbsp;
		<input class="button" type="button" id="cancelDiploma" value="撤销证书" />
	</div>
	<hr size="1" noshadow />
	<div id="dimplomaListByBatch">
	</div>
</div>
</body>
