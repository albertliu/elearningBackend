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
	var kindID = 0;
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		kindID = "<%=nodeID%>";
		
		getComList("examID","v_generatePasscardInfo","ID","title","status<2 order by ID desc",1);
		
		$.ajaxSetup({ 
			async: false 
		}); 
		
		setButton();

		$("#btnCartSel").click(function(){
			setSel("");
		});
		
		$("#btnEmpty").click(function(){
			$.messager.confirm("确认","确定要清空购物车吗？",function(r){
				if(r){
					$.get("cartControl.asp?op=emptyCart&kindID=" + kindID + "&times=" + (new Date().getTime()),function(data){
						jAlert("购物车已清空！","信息提示");
						getCartList();
						updateCount += 1;
					});
				}
			});
		});
		
		$("#btnRemove").click(function(){
			getSelCart("");
			if(selCount==0){
				jAlert("请选择要移除的人员。");
				return false;
			}
			$.messager.confirm("确认","确定要从购物车中移除这些人吗？",function(r){
				if(r){
					$.get("cartControl.asp?op=remove4cart&kindID=" + kindID + "&item=" + selList + "&times=" + (new Date().getTime()),function(data){
						jAlert("移除成功！","信息提示");
						getCartList();
						updateCount += 1;
					});
				}
			});
		});
		
		$("#btnDo").click(function(){
			getSelCart("");
			if(selCount==0){
				jAlert("请选择要添加的人员。");
				return false;
			}
			if($("#examID").val()==""){
				jAlert("请选择要加入的考试场次。");
				return false;
			}
			$.messager.confirm("确认","确定将这" + selCount + "人加入到'" + $("#examID").find("option:selected").text() + "'考试吗？",function(r){
				if(r){
					//$.getJSON(uploadURL + "/outfiles/recommend_job4cart?jobID=" + $("#jobID").val() + "&selList=" + selList + "&username=" + currUser ,function(data){
					//$.get("cartControl.asp?op=pickExamer4cart&refID=" + $("#examID").val() + "&item=" + escape(selList) + "&times=" + (new Date().getTime()),function(data){
					$.post("cartControl.asp?op=pickExamer4cart&refID=" + $("#examID").val(), {"item":selList},function(data){
						if(data==0){
							jAlert("保存成功。");
							getCartList();
							updateCount += 1;
						}else{
							jAlert("没有处理任何数据。");
						}
					});
				}
			});
		});

		getCartList();

	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getCartList(){
		$.get("cartControl.asp?op=getCartList&kindID=" + kindID + "&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#cartCover").empty();
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='cartTab' width='100%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='5%'>No</th>");
			arr.push("<th width='20%'>身份证</th>");
			arr.push("<th width='12%'>姓名</th>");
			arr.push("<th width='15%'>备注</th>");
			arr.push("<th width='15%'>课程</th>");
			arr.push("<th width='18%'>添加人</th>");
			arr.push("<th width='10%'></th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showEnterInfo(\"" + ar1[1] + "\",0,0,1);' title='电话:" + ar1[6] + " 部门:" + ar1[11] + ", " + ar1[12] + ", " + ar1[13] + "'>" + ar1[2] + "</a></td>");
					arr.push("<td class='left'>" + ar1[3] + "</td>");
					arr.push("<td class='left'>" + ar1[7] + "</td>");
					arr.push("<td class='left'>" + ar1[14] + "</td>");
					arr.push("<td class='left'>" + ar1[10] + ar1[8] + "</td>");
					arr.push("<td class='left'><input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + ar1[0] + "' name='visitstockchk'></td>");
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
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#cartCover").html(arr.join(""));
			arr = [];
			$('#cartTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"bInfo": true,
				"aLengthMenu":[15,30,50,100,500],
				"iDisplayLength": 500,
				"aoColumnDefs": []
			});
		});
	}
	
	function setButton(){
		$("#btnDo").hide();
		$("#btnRemove").hide();
		$("#btnEmpty").hide();
		if(checkPermission("studentAdd")){
			$("#btnDo").show();
			$("#btnRemove").show();
			$("#btnEmpty").show();
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
	
	<div style="width:100%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:5px;background:#ffffff;line-height:18px;padding-left:20px;">
			<div>考试场次：<select id="examID" style="width:200px"></select></div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
  		<input class="button" type="button" id="btnCartSel" value="全选/取消" />&nbsp;
  		<input class="button" type="button" id="btnDo" value="加入考试" />&nbsp;
  		<input class="button" type="button" id="btnRemove" value="移除" />&nbsp;
  		<input class="button" type="button" id="btnEmpty" value="清空购物车" />&nbsp;
  	</div>
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
	<div id="cartCover" style="float:top;margin:3px;background:#f8fff8;">
	</div>
</div>
</body>
