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
<link href="css/jquery-confirm.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="css/jquery.autocomplete.css" />
<script language="javascript" src="js/jquery-1.12.4.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js?v=1.8.6"></script>
<script src="js/jquery-confirm.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<script type='text/javascript' src='js/jquery.autocomplete.js'></script>
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var nodeID = 0;
	var op = 0;
	var refID = 0;
	var keyID = "A";
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";	//classID
		refID = "<%=refID%>";
		keyID = "<%=keyID%>";	// mark: A apply, B class
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 
		$("#btnDownload").click(function(){
			$.getJSON(uploadURL + "/outfiles/generate_excel?tag=class_checkin&mark=班级考勤&classID=" + nodeID + "&pobj=" + refID + "&keyID=" + keyID ,function(data){
				if(data>""){
					asyncbox.alert("请点击此处<a href='" + data + "' target='_blank'>下载文件</a>",'考勤表',function(action){
					　　//alert 返回action 值，分别是 'ok'、'close'。
					　　if(action == 'ok'){
					　　}
					　　if(action == 'close'){
					　　　　//alert('close');
					　　}
					});
					//getNodeInfo(nodeID);
				}else{
					alert("没有可供处理的数据。");
				}
			});
		});
		getClassCheckinList();
	});

	function getClassCheckinList(){
		$.getJSON(uploadURL + "/public/getClassCheckin?refID=" + nodeID + "&kindID=" + keyID + "&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			let i = 0;
			let j = 0;
			let c = 0;
			let showImg = 0;
			let imgChk = "<img src='images/green_check.png' />";
			$("#cover").empty();
			arr = [];					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='cardTab' width='100%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='2%'>No</th>");
			arr.push("<th width='6%'>姓名</th>");
			arr.push("<th width='12%'>身份证</th>");
			if(data>""){
				for(let key in data[0]){
					// 遍历数组，对每个元素进行操作
					if(j>2){
						arr.push("<th>" + key + "</th>");
					}
					j = j + 1;
				};
			}
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(data>""){
				$.each(data,function(iNum,val){
					i += 1;
					c = 0;
					j = 0;
					arr.push("<tr class='grade0'>");
					for(let key in val){
						if(j>0){	//第一列enterID不显示
							if(j<2){
								arr.push("<td" + val[key] + "</td>");
							}else{
								if($("#showPhoto").prop("checked")){
									showImg = 1;
								}
								if(showImg==0){
									arr.push("<td" + (val[key]>"" ? imgChk : "&nbsp;") + "</td>");
								}else{
									if(val[key]==""){
										arr.push("<td>&nbsp;</td>");
									}else{
										$.get(uploadURL + "/alis/get_OSS_file_base64?filename=" + val[key].split(",")[0],function(re1){
											arr.push("<td" + '<img src="/users' + val[key].split(",")[1] + '" style="max-width:50px;" />' + (re1>'' ? '<img src="data:image/png;base64,' + re1 + '" style="max-width:50px;" />' : '') + "</td>");
										});
									}
								}
							}
						}
						j += 1
					}
					arr.push("</tr>");
				});
			}
			arr.push("</tbody>");
			arr.push("<tfoot>");
			arr.push("<tr>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			j = 0;
			if(data>""){
				for(let key in data[0]){
					// 遍历数组，对每个元素进行操作
					if(j>2){
						arr.push("<th>&nbsp;</th>");
					}
					j = j + 1;
				};
			}
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#cover").html(arr.join(""));
			arr = [];
			$('#cardTab').dataTable({
				"aaSorting": [],
				"bFilter": false,
				"bPaginate": true,
				"bLengthChange": false,
				"aLengthMenu":[15,30,50,100,500],
				"iDisplayLength": 50,
				"bInfo": true,
				"aoColumnDefs": []
			});
		});
	}
</script>

</head>

<body style="background:#f0f0f0;">

<div id='layout' align='left' style="background:#f0f0f0;">	
	<div style='text-align:center; margin:10px 0 10px 0;'><h3 style='font-size:1.8em;'>班级线下课程考勤表</h3></div>
	<div style='float:right; padding-right:50px;'><input class="button" type="button" id="btnDownload" value="下载" /></div>
	<div><input style="border:0px;" type="checkbox" id="showPhoto" value="" />&nbsp;显示照片&nbsp;</div>
	<div id="cover" style="float:top;background:#f8fff8;">
	</div>
</div>
</body>
