	var feedbackListLong = 0;		//0: 标准栏目  1：短栏目

	$(document).ready(function (){
		var w_feedback = "status=0 and hostNo='" + currHost + "'";
		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("searchFeedbackHost","hostInfo","hostNo","title","status=0 order by hostName",1);
		}else{
			getComList("searchFeedbackHost","hostInfo","hostNo","title",w_feedback,0);
		}
		$("#searchFeedbackStart").click(function(){WdatePicker();});
		$("#searchFeedbackEnd").click(function(){WdatePicker();});
		getDicList("feedback","searchFeedbackKind",1);

		$("#btnSearchFeedback").click(function(){
			getFeedbackList();
		});
		
		if(feedbackListLong == 0){
			$("#feedbackListLongItem1").show();
		}else{
			$("#feedbackListLongItem1").hide();
		}
		
		getFeedbackList();
	});

	function getFeedbackList(){
		//alert("&fStart=" + $("#searchFeedbackStart").val() + "&fEnd=" + $("#searchFeedbackEnd").val() + "&kindID=" + $("#searchFeedbackKind").val());
		$.get("feedbackControl.asp?op=getFeedbackList&fStart=" + $("#searchFeedbackStart").val() + "&fEnd=" + $("#searchFeedbackEnd").val() + "&host=" + $("#searchFeedbackHost").val() + "&kindID=" + $("#searchFeedbackKind").val() + "&dk=1&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#feedbackCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='feedbackTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='4%'>No</th>");
			arr.push("<th width='45%'>消息内容</th>");
			arr.push("<th width='12%'>类型</th>");
			arr.push("<th width='12%'>发送日期</th>");
			arr.push("<th width='10%'>发送人</th>");
			arr.push("<th width='9%'>处理</th>");
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
					mNew = "";
					if(ar1[12]==""){	//no read
						mNew = "<span id='newFeedback" + ar1[0] + "'>&nbsp;<img src='images/new.gif'></span>";
					}
					arr.push("<tr class='grade0'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:closeObj(\"newFeedback" + ar1[0] + "\");showFeedbackInfo(\"" + ar1[0] + "\",0,0,1);'>" + ar1[2] + "</a>" + mNew + "</td>");
					arr.push("<td class='left'>" + ar1[7] + "</td>");
					arr.push("<td class='left'>" + ar1[17].substr(0,10) + "</td>");
					arr.push("<td class='left'>" + ar1[18] + "</td>");
					if(ar1[5]==0){
						arr.push("<td class='left'>&nbsp;</td>");
					}else{
						arr.push("<td class='left'>" + imgChk + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#feedbackCover").html(arr.join(""));
			arr = [];
			$('#feedbackTab').dataTable({
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

	
	