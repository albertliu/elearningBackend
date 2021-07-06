	var generateApplyListLong = 0;		//0: 标准栏目  1：短栏目
	var generateApplyListChk = 0;

	$(document).ready(function (){
		getComList("searchGenerateApplyCourse","v_courseInfo","courseID","courseName","status=0 and type=0 and agencyID<>4 order by courseName",1);
		getDicList("statusPlan","searchGenerateApplyStatus",0);
		$("#searchGenerateApplyStart").click(function(){WdatePicker();});
		$("#searchGenerateApplyEnd").click(function(){WdatePicker();});
		
		$("#btnSearchGenerateApply").click(function(){
			getGenerateApplyList();
		});
		
		$("#txtSearchGenerateApply").keypress(function(event){
			if(event.keyCode==13){
				if($("#txtSearchGenerateApply").val()>""){
					getGenerateApplyList();
				}else{
					jAlert("请输入查询条件");
				}
			}
		});
		
		if(!checkPermission("studentAdd")){
			$("#btnSearchGenerateApplyAdd").hide();
		}
		
		$("#btnSearchGenerateApplyAdd").click(function(){
			showGenerateApplyInfo(0,0,1,1);
		});
		//getGenerateApplyList();
	});

	function getGenerateApplyList(){
		sWhere = $("#txtSearchGenerateApply").val();
		//alert((sWhere) + "&kindID=" + $("#searchGenerateApplyCourse").val() + "&host=" + $("#searchGenerateApplyHost").val() + "&keyID=" + photo);
		$.get("diplomaControl.asp?op=getGenerateApplyList&where=" + escape(sWhere) + "&kindID=" + $("#searchGenerateApplyCourse").val() + "&status=" + $("#searchGenerateApplyStatus").val() + "&fStart=" + $("#searchGenerateApplyStart").val() + "&fEnd=" + $("#searchGenerateApplyEnd").val() + "&dk=106&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#generateApplyCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='generateApplyTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='20%'>申报名称</th>");
			arr.push("<th width='8%'>人数</th>");
			arr.push("<th width='10%'>申报日期</th>");
			arr.push("<th width='10%'>状态</th>");
			arr.push("<th width='12%'>申报批号</th>");
			arr.push("<th width='10%'>申报结果</th>");
			arr.push("<th width='20%'>备注</th>");
			arr.push("<th width='8%'>制作</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				var imgChk = "<img src='images/printer1.png'>";
				var imgChk1 = "<img src='images/green_check.png'>";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showGenerateApplyInfo(" + ar1[0] + ",0,0,1);'>" + ar1[3] + "</a></td>");
					arr.push("<td class='left'>" + ar1[4] + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='center'>" + ar1[12] + "</td>");
					arr.push("<td class='left'>" + ar1[5] + "</td>");
					arr.push("<td class='left' title='通过/未通过/待定'>" + ar1[13] + "/" + ar1[14] + "/" + ar1[15] + "</td>");
					arr.push("<td class='left'>" + ar1[8] + "</td>");
					arr.push("<td class='left'>" + ar1[10] + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#generateApplyCover").html(arr.join(""));
			arr = [];
			$('#generateApplyTab').dataTable({
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
