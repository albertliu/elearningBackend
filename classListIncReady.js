	var classListLong = 0;		//0: 标准栏目  1：短栏目

	$(document).ready(function (){
		getComList("searchClassCert","certificateInfo","certID","shortName","status=0 and type=0 order by certID",1);
		getDicList("planStatus","searchClassStatus",1);
		getComList("searchClassProject","projectInfo","projectID","projectName","status>0 and status<9 order by projectID desc",1);
		
		if(checkPermission("classAdd")){
			$("#btnAddClass").show();
		}else{
			$("#btnAddClass").hide();
		}
		$("#btnSearchClass").click(function(){
			getClassList();
		});
		
		$("#btnAddClass").click(function(){
			showClassInfo(0,0,1,1);	//showClassInfo(nodeID,refID,op,mark) op:0 浏览 1 新增; mark:0 不动作  1 有修改时刷新列表
		});
		
		//getClassList();
	});

	function getClassList(){
		sWhere = $("#txtSearchClass").val();
		//alert((sWhere) + "&refID=" + $("#searchClassCert").val() + "&status=" + $("#searchClassStatus").val() + "&project=" + $("#searchClassProject").val());
		$.get("classControl.asp?op=getClassList&where=" + escape(sWhere) + "&refID=" + $("#searchClassCert").val() + "&status=" + $("#searchClassStatus").val() + "&project=" + $("#searchClassProject").val() + "&dk=91&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#classCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='classTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='8%'>编号</th>");
			arr.push("<th width='20%'>班级名称</th>");
			arr.push("<th width='12%'>开课日期</th>");
			arr.push("<th width='12%'>结束日期</th>");
			arr.push("<th width='10%'>班主任</th>");
			arr.push("<th width='8%'>状态</th>");
			arr.push("<th width='6%'>人数</th>");
			arr.push("<th width='6%'>退课</th>");
			arr.push("<th width='6%'>报考</th>");
			arr.push("<th width='6%'>考试</th>");
			arr.push("<th width='6%'>合格</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			var i = 0;
			var c = 0;
			var mNew = "";
			var imgChk = "<img src='images/green_check.png'>";
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showClassInfo(" + ar1[0] + ",0,0,1);'>" + ar1[1] + "</a></td>");
					arr.push("<td class='left'>" + ar1[17] + "</td>");
					arr.push("<td class='left'>" + ar1[10] + "</td>");
					arr.push("<td class='left'>" + ar1[11] + "</td>");
					arr.push("<td class='left'>" + ar1[9] + "</td>");
					if(ar1[6]==0){
						arr.push("<td class='center'>&nbsp;</td>");
					}else{
						arr.push("<td class='center'>" + ar1[7] + "</td>");
					}
					arr.push("<td class='left'>" + ar1[20] + "</td>");
					arr.push("<td class='left'></td>");
					arr.push("<td class='left'></td>");
					arr.push("<td class='left'></td>");
					arr.push("<td class='left'></td>");
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
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#classCover").html(arr.join(""));
			arr = [];
			$('#classTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
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

	
	