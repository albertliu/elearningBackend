	var generatePasscardListLong = 0;		//0: 标准栏目  1：短栏目
	var generatePasscardListChk = 0;

	$(document).ready(function (){
		getComList("searchGeneratePasscardCert","v_certificateInfo","certID","certName","status=0 and type=0 order by certName",1);
		getComList("searchGeneratePasscardClass","v_classInfo","classID","className","1=1 order by ID desc",1);
		$("#searchGeneratePasscardStart").click(function(){WdatePicker();});
		$("#searchGeneratePasscardEnd").click(function(){WdatePicker();});
		
		$("#btnSearchGeneratePasscard").click(function(){
			getGeneratePasscardList();
		});
		
		$("#txtSearchGeneratePasscard").keypress(function(event){
			if(event.keyCode==13){
				if($("#txtSearchGeneratePasscard").val()>""){
					getGeneratePasscardList();
				}else{
					jAlert("请输入查询条件");
				}
			}
		});
		//getGeneratePasscardList();
	});

	function getGeneratePasscardList(){
		sWhere = $("#txtSearchGeneratePasscard").val();
		//alert((sWhere) + "&kindID=" + $("#searchGeneratePasscardCert").val() + "&host=" + $("#searchGeneratePasscardHost").val() + "&keyID=" + photo);
		$.get("diplomaControl.asp?op=getGeneratePasscardList&where=" + escape(sWhere) + "&kindID=" + $("#searchGeneratePasscardCert").val() + "&refID=" + $("#searchGeneratePasscardClass").val() + "&fStart=" + $("#searchGeneratePasscardStart").val() + "&fEnd=" + $("#searchGeneratePasscardEnd").val() + "&dk=104&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#generatePasscardCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='generatePasscardTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='10%'>班级编号</th>");
			arr.push("<th width='20%'>班级名称</th>");
			arr.push("<th width='8%'>数量</th>");
			arr.push("<th width='10%'>起始编号</th>");
			arr.push("<th width='20%'>考试日期</th>");
			arr.push("<th width='10%'>制作日期</th>");
			arr.push("<th width='8%'>制作</th>");
			arr.push("<th width='8%'>文件</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				var imgChk = "<img src='images/printer1.png'>";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showGeneratePasscardInfo(" + ar1[0] + ",0,0,1,\"\");'>" + ar1[1] + "</a></td>");
					arr.push("<td class='left'>" + ar1[2] + "</td>");
					arr.push("<td class='left'>" + ar1[4] + "</td>");
					arr.push("<td class='left'>" + ar1[13] + "</td>");
					arr.push("<td class='left'>" + ar1[8] + "  " + ar1[5] + "</td>");
					arr.push("<td class='left'>" + ar1[11] + "</td>");
					arr.push("<td class='left'>" + ar1[12] + "</td>");
					if(ar1[9]==''){
						arr.push("<td class='center'>&nbsp;</td>");
					}else{
						arr.push("<td class='center'><a href='/users" + ar1[9] + "' target='_blank'>" + imgChk + "</a></td>");
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
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#generatePasscardCover").html(arr.join(""));
			arr = [];
			$('#generatePasscardTab').dataTable({
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
