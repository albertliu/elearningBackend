<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css?v=1.8.6">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/data_table_mini.css?v=20150411" rel="stylesheet" type="text/css" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<link href="css/jquery-confirm.css" rel="stylesheet" type="text/css" media="screen" />
<script language="javascript" src="js/jquery-1.12.4.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js?v=1.8.6"></script>
<script src="js/jquery-confirm.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>

<script language="javascript">
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		$.ajaxSetup({ 
			async: false 
		});
		getDicList("fromKind","fromKind",1);
        getComboList("saler","userInfo","username","realName","status=0 and host='" + currHost + "' and username in(select username from roleUserList where roleID='saler') order by realName",1);
		
		$("#btnSearch").click(function(){
			getSalerUnitList();
		});
		
		$("#txtSearch").keypress(function(event){
			if(event.keyCode==13){
				if($("#txtSearch").val()>""){
					getSalerUnitList();
				}else{
					jAlert("请输入查询条件");
				}
			}
		});
		
		$("#btnAdd").click(function(){
			showSalerUnitInfo(0,1,1);	//
		});
		
		$("#txtSearch").keypress(function(event){
			if(event.keyCode==13){
				if($("#txtSearch").val()>""){
					getSalerUnitList();
				}else{
					jAlert("请输入查询条件");
				}
			}
		});

		if(!checkRole("saler")){
			$("#btnAdd").hide();
		}
		
		$("#saler").combobox({
			onChange:function() {
				getSalerUnitList();
			}
		});

		if(checkRole("saler")){
			$("#saler").combobox("setValue", currUser);
			if(!checkRole("leader")){
				$("#saler").combobox("disable");
			}
		}
		// getSalerUnitList();
	});

	function getSalerUnitList(){
		//alert(refID + ":" + nodeID);
		sWhere = $("#txtSearch").val();
		let kindID = $("#fromKind").val();
		$.get("studentControl.asp?op=getSalerUnitList&where=" + escape(sWhere) + "&refID=" + $("#saler").combobox("getValue") + "&kindID=" + kindID + "&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#cover").empty();
			arr = [];					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='cardTab' width='100%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='20%'>企业名称</th>");
			arr.push("<th width='10%'>属性</th>");
			arr.push("<th width='20%'>联系人</th>");
			arr.push("<th width='35%'>基本情况</th>");
			arr.push("<th width='12%'>所属协会</th>");
			// arr.push("<th width='12%'>登记日期</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var imgChk = "<img src='images/green_check.png'>";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					arr.push("<tr class='grade0'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showSalerUnitInfo(" + ar1[0] + ",0,1);'>" + ar1[1] + "</a></td>");
					arr.push("<td class='left'>" + ar1[7] + "</td>");
					arr.push("<td class='left'>" + ar1[8] + "</td>");
					arr.push("<td class='left'>" + ar1[13] + "</td>");
					arr.push("<td class='left'>" + ar1[12] + "</td>");
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
			// arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#cover").html(arr.join(""));
			arr = [];
			$('#cardTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"aLengthMenu":[15,30,50,100],
				"iDisplayLength": 100,
				"bInfo": true,
				"aoColumnDefs": []
			});
		});
	}
</script>

</head>

<body>

<div id='layout' align='left' style="background:#f0f0f0;">
	<form><label>搜索：</label>
		<input type="text" id="txtSearch" name="txtSearch" size="15" title="企业名称" style="background:yellow;" />
		<input class="button" type="button" name="btnSearch" id="btnSearch" value="查找" />
		<input class="button" type="button" id="btnAdd" name="btnAdd" value="新增" />
		<span style="padding-left:50px;">
			销售&nbsp;<select id="saler" style="width:90px"></select>
		</span>
		<span style="padding-left:20px;">
			资源&nbsp;<select id="fromKind" style="width:80px;"></select>
		</span>
	</form>
	<div id="cover" style="float:left;width:100%;">
	</div>
</div>
</body>
