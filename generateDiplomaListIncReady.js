	var generateDiplomaListLong = 0;		//0: 标准栏目  1：短栏目
	var generateDiplomaListChk = 0;

	$(document).ready(function (){
		var w1 = "status=0 and hostNo='" + currHost + "'";
		var w2 = "status=0 and host='" + currHost + "'";
		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("searchGenerateDiplomaHost","hostInfo","hostNo","title","status=0 order by hostName",1);
			getComList("searchGenerateDiplomaCert","v_certificateInfo","certID","certName","status=0 and host='' order by certID",1);
			$("#searchGenerateDiplomaItem1").hide();
		}else{
			getComList("searchGenerateDiplomaHost","hostInfo","hostNo","title",w1,0);
			getComList("searchGenerateDiplomaCert","certificateInfo","certID","certName",w2,1);
		}
		$("#searchGenerateDiplomaStart").click(function(){WdatePicker();});
		$("#searchGenerateDiplomaEnd").click(function(){WdatePicker();});
		
		$("#btnSearchGenerateDiploma").click(function(){
			getGenerateDiplomaList();
		});
		
		$("#txtSearchGenerateDiploma").keypress(function(event){
			if(event.keyCode==13){
				if($("#txtSearchGenerateDiploma").val()>""){
					getGenerateDiplomaList();
				}else{
					jAlert("请输入查询条件");
				}
			}
		});
		//getGenerateDiplomaList();
	});

	function getGenerateDiplomaList(){
		sWhere = $("#txtSearchGenerateDiploma").val();
		//alert((sWhere) + "&kindID=" + $("#searchGenerateDiplomaCert").val() + "&host=" + $("#searchGenerateDiplomaHost").val() + "&keyID=" + photo);
		$.get("diplomaControl.asp?op=getGenerateDiplomaList&where=" + escape(sWhere) + "&kindID=" + $("#searchGenerateDiplomaCert").val() + "&host=" + $("#searchGenerateDiplomaHost").val() + "&fStart=" + $("#searchGenerateDiplomaStart").val() + "&fEnd=" + $("#searchGenerateDiplomaEnd").val() + "&dk=22&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#generateDiplomaCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='generateDiplomaTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='15%'>证书名称</th>");
			arr.push("<th width='8%'>数量</th>");
			arr.push("<th width='25%'>编号范围</th>");
			arr.push("<th width='10%'>打印日期</th>");
			arr.push("<th width='10%'>发放日期</th>");
			arr.push("<th width='15%'>说明</th>");
			arr.push("<th width='10%'>制作日期</th>");
			arr.push("<th width='6%'></th>");
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
					if(currHost>""){
						arr.push("<td class='link1'><a href='javascript:showGenerateDiplomaInfo(\"" + ar1[0] + "\",0,0,1);'>" + ar1[2] + "</a></td>");
					}else{
						arr.push("<td class='link1'><a href='javascript:showGenerateDiplomaInfo1(\"" + ar1[0] + "\",0,0,0,0,1);'>" + ar1[2] + "</a></td>");
					}
					arr.push("<td class='left'>" + ar1[3] + "</td>");
					arr.push("<td class='left'>" + ar1[8] + " ~ " + ar1[9] + "</td>");
					arr.push("<td class='left'>" + ar1[14] + "</td>");
					arr.push("<td class='left'>" + ar1[16] + "</td>");
					arr.push("<td class='left'>" + ar1[10] + "</td>");
					arr.push("<td class='left'>" + ar1[11] + "</td>");
					if(ar1[7]==''){
						arr.push("<td class='center'>&nbsp;</td>");
					}else{
						arr.push("<td class='center'><a href='/users" + ar1[7] + "' target='_blank'>" + imgChk + "</a></td>");
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
			$("#generateDiplomaCover").html(arr.join(""));
			arr = [];
			$('#generateDiplomaTab').dataTable({
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
