<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
<link href="css/datatables.min.css" rel="stylesheet" type="text/css" />
<script language="javascript" src="js/jquery-3.7.0.min.js"></script>
<script language="javascript" type="text/javascript" src="js/datatables.min.js"></script>
    <style>
        td.details-control {
            /* Image in the first column to
                indicate expand*/
            background: #yellow;
                  
            cursor: pointer;
        }
  
        tr.shown td.details-control {
            background: #fff;
        }
    </style>

<script language="javascript">
	<!--#include file="js/commFunction.js"-->
	let table = "";
	let table1 = "";
	$(document).ready(function (){
		refID = "<%=refID%>";	//enterID
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 

		getCheckinListOnClass();
		// getCheckinListOutClass();
	});

	async function getCheckinListOnClass(){
		//alert(refID + ":" + nodeID);
		$.get("studentCourseControl.asp?op=getEnterCheckinListOnClass&refID=" + refID + "&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#cover").empty();
			arr = [];
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='cardTab' style='width:100%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='5%'>No</th>");
			arr.push("<th width='15%'>日期</th>");
			arr.push("<th width='50%'>课程内容</th>");
			arr.push("<th width='15%'>教师</th>");
			arr.push("<th width='15%'>签到</th>");
			arr.push("<th width='0%'></th>");
			arr.push("<th width='0%'></th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				let imgChk = "<img src='images/green_check.png' />";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='left'>" + ar1[0] + "</td>");
					arr.push("<td class='left'>" + ar1[1] + "</td>");
					arr.push("<td class='left'>" + ar1[2] + "</td>");
					arr.push("<td class='details-control' style='color:blue;text-align:center;'>" + (ar1[5] ? imgChk : "&nbsp;") + "</td>");
					arr.push("<td class='left'>" + ar1[5] + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
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
			$("#cover").html(arr.join(""));
			arr = [];
			table = $('#cardTab').DataTable({
				//配置相应部分的中文显示(废话，不然就显示英文了)
				"language": {
					"lengthMenu": "每页 _MENU_ 条记录",
					"zeroRecords": "没有找到记录",
					"info": "第 _PAGE_ 页 ( 总共 _PAGES_ 页 )",
					"infoEmpty": "无记录",
					"paginate": {
						"first": "第一页",
						"last": "最后一页",
						"next": "后一页",
						"previous": "上一页"
					},
				},
			
				"pageLength": 20,           //默认每页条数
				"lengthChange": false,      //禁掉表格自带的选择每页条数的下拉框
				"searching": false,
				"columnDefs": [
					{ "visible": false, "targets": [5] }
				]
			});

			$('#cardTab tbody').on('click', 'td.details-control', function () {
				var tr =$(this).closest('tr');
				var row = table.row(tr);

				if (row.child.isShown()) {

					// Closing the already opened row           
					row.child.hide();

					// Removing class to hide
					tr.removeClass('shown');
				}
				else {

					// Show the child row for detail
					// information
					getChildRow(row.data()[5],row.data()[6], function(data){
						row.child(data).show();
					});

					// To show details,add the below class
					tr.addClass('shown');
				}
			});
		});
	}

	async function getCheckinListOutClass(){
		//alert(refID + ":" + nodeID);
		$.get("studentCourseControl.asp?op=getEnterCheckinListOnClass&refID=" + refID + "&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#cover1").empty();
			arr = [];
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='cardTab1' style='width:100%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='5%'>No</th>");
			arr.push("<th width='15%'>日期</th>");
			arr.push("<th width='50%'>课程内容</th>");
			arr.push("<th width='10%'>教师</th>");
			arr.push("<th width='10%'>签到</th>");
			arr.push("<th width='0%'></th>");
			arr.push("<th width='0%'></th>");
			arr.push("<th width='10%'>班级</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				let imgChk = "<img src='images/green_check.png' />";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='left'>" + ar1[0] + "</td>");
					arr.push("<td class='left'>" + ar1[1] + "</td>");
					arr.push("<td class='left'>" + ar1[2] + "</td>");
					arr.push("<td class='details-control' style='color:blue;text-align:center;'>" + (ar1[5] ? imgChk : "&nbsp;") + "</td>");
					arr.push("<td class='left'>" + ar1[5] + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='left'>" + ar1[4] + "</td>");
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
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#cover1").html(arr.join(""));
			arr = [];
			table1 = $('#cardTab1').DataTable({
				//配置相应部分的中文显示(废话，不然就显示英文了)
				"language": {
					"lengthMenu": "每页 _MENU_ 条记录",
					"zeroRecords": "没有找到记录",
					"info": "第 _PAGE_ 页 ( 总共 _PAGES_ 页 )",
					"infoEmpty": "无记录",
					"paginate": {
						"first": "第一页",
						"last": "最后一页",
						"next": "后一页",
						"previous": "上一页"
					},
				},
			
				"pageLength": 20,           //默认每页条数
				"lengthChange": false,      //禁掉表格自带的选择每页条数的下拉框
				"searching": false,
				"columnDefs": [
					{ "visible": false, "targets": [5] }
				]
			});

			$('#cardTab1 tbody').on('click', 'td.details-control', function () {
				var tr =$(this).closest('tr');
				var row = table1.row(tr);

				if (row.child.isShown()) {

					// Closing the already opened row           
					row.child.hide();

					// Removing class to hide
					tr.removeClass('shown');
				}
				else {

					// Show the child row for detail
					// information
					getChildRow(row.data()[5],row.data()[6], function(data){
						row.child(data).show();
					});

					// To show details,add the below class
					tr.addClass('shown');
				}
			});
		});
	}

	function getChildRow(f1,f2, callback) {
		// alert(f1)
		let x = "";
		$.get(uploadURL + "/alis/get_OSS_file_base64?filename=" + f1,function(re1){
			// alert(re1);
			x += '<tr>' +
			'<td><img src="/users' + f2 + '" style="max-width:50px;" /></td>' +
			'<td>' + (re1>'' ? '<img src="data:image/png;base64,' + re1 + '" style="max-width:50px;" />' : '') + '</td>';
			'</tr>'
		});
		callback(x);
	}

</script>

</head>

<body>

<div id='layout' align='left' style="background:#f0f0f0;">	
	<div id="cover" style="float:left;width:100%;">
	</div>
</div>
</body>
