	var agencyListLong = 0;		//0: 标准栏目  1：短栏目
	var agencyListChk = 0;

	$(document).ready(function (){
		getDicList("statusEffect","searchSourceStatus",1);
		if(checkPermission("editSource")){
			$("#btnAddSource").show();
		}
		$("#btnAddSource").click(function(){
			showSourceInfo(0,0,1,1);	//showSourceInfo(nodeID,refID,op,mark) op:0 浏览 1 新增  2 编辑  3 删除  4 审批; mark:0 不动作  1 有修改时刷新列表
		});
		
		$("#btnSearchSource").click(function(){
			getSourceList();
		});
		
		$("#txtSearchSource").keypress(function(event){
			if(event.keyCode==13){
				if($("#txtSearchSource").val()>""){
					getSourceList();
				}else{
					jAlert("请输入查询条件");
				}
			}
		});
	});

	function getSourceList(){
		sWhere = $("#txtSearchSource").val();
		$.get("agencyControl.asp?op=getSourceList&where=" + escape(sWhere) + "&status=" + $("#searchSourceStatus").val() + "&dk=45&times=" + (new Date().getTime()),function(data){
			// jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#sourceCover").empty();
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='sourceTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='40%'>来源名称</th>");
			arr.push("<th width='10%'>状态</th>");
			arr.push("<th width='20%'>登记日期</th>");
			arr.push("<th width='20%'>登记人</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			var i = 0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showSourceInfo(\"" + ar1[0] + "\",0,0,1);'>" + ar1[1] + "</a></td>");
					arr.push("<td class='left'>" + ar1[3] + "</td>");
					arr.push("<td class='left'>" + ar1[4] + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#sourceCover").html(arr.join(""));
			arr = [];
			$('#sourceTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"aLengthMenu":[15,30,50,100],
				"iDisplayLength": 100,
				"bInfo": true,
				"aoColumnDefs": []
			});
			floatCount = i;
			floatTitle = "";	//excel file's title in the 1st row, if it's blank then keep the excel's present one.
			floatItem = "";		//write to excel file's 2nd row
			floatLog = "打印日期：" + currDate + "&nbsp;&nbsp;&nbsp;&nbsp;打印人：" + currUserName;		//write to excel file's 3rd row
			floatKey = "";		//
			floatContent = "";	//records data for output
			floatModel = 1;
		});
	}
	