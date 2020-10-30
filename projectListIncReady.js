	var projectListLong = 0;		//0: 标准栏目  1：短栏目

	$(document).ready(function (){
		var w_project = "status=0 and hostNo='" + currHost + "'";
		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("searchProjectHost","hostInfo","hostNo","title","status=0 order by hostName",1);
		}else{
			getComList("searchProjectHost","hostInfo","hostNo","title",w_project,0);
		}
		$("#searchProjectStart").click(function(){WdatePicker();});
		$("#searchProjectEnd").click(function(){WdatePicker();});
		getComList("searchProjectCert","certificateInfo","certID","certName","status=0 order by certID",1);
		getDicList("statusIssue","searchProjectStatus",1);

		$("#btnSearchProject").click(function(){
			getProjectList();
		});
		
		if(projectListLong == 0){
			$("#projectListLongprojectName1").show();
		}else{
			$("#projectListLongprojectName1").hide();
		}
		
		//getProjectList();
	});

	function getProjectList(){
		sWhere = $("#txtSearchProject").val();
		//alert("&fStart=" + $("#searchProjectStart").val() + "&fEnd=" + $("#searchProjectEnd").val() + "&kindID=" + $("#searchProjectKind").val() + "&status=" + $("#searchProjectStatus").val() + "&host=" + $("#searchProjectHost").val());
		$.get("projectControl.asp?op=getProjectList&where=" + escape(sWhere) + "&fStart=" + $("#searchProjectStart").val() + "&fEnd=" + $("#searchProjectEnd").val() + "&certID=" + $("#searchProjectCert").val() + "&status=" + $("#searchProjectStatus").val() + "&host=" + $("#searchProjectHost").val() + "&dk=17&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#projectCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='projectTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='10%'>编号</th>");
			arr.push("<th width='25%'>内容</th>");
			arr.push("<th width='25%'>项目名称</th>");
			arr.push("<th width='12%'>参加对象</th>");
			arr.push("<th width='12%'>截止日期</th>");
			arr.push("<th width='8%'>阅读</th>");
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
					arr.push("<td class='link1'><a href='javascript:showProjectInfo(" + ar1[0] + "</a></td>");
					arr.push("<td class='left'>" + ar1[1] + "</td>");
					arr.push("<td class='left'>" + ar1[2] + "</td>");
					arr.push("<td class='left'>" + ar1[7] + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='left'>" + ar1[10] + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#projectCover").html(arr.join(""));
			arr = [];
			$('#projectTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"bInfo": true,
				"aoColumnDefs": []
			});
			floatCount = i;
			floatTitle = "";	//excel file's title in the 1st row, if it's blank then keep the excel's present one.
			floatprojectName = "";		//write to excel file's 2nd row
			floatLog = "打印日期：" + currDate + "&nbsp;&nbsp;&nbsp;&nbsp;打印人：" + currUserName;		//write to excel file's 3rd row
			floatKey = "";		//
			floatContent = "";	//records data for output
			floatModel = 1;
		});
	}

	
	