﻿	var studentNeedDiplomaListLong = 0;		//0: 标准栏目  1：短栏目
	var studentNeedDiplomaListChk = 0;

	$(document).ready(function (){
		var w1 = "status=0 and hostNo='" + currHost + "'";
		var w2 = "status=0 and (kindID=0 or host='" + currHost + "')";
		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("searchStudentNeedDiplomaHost","hostInfo","hostNo","title","status=0 order by hostName",1);
			getComList("searchStudentNeedDiplomaCert","certificateInfo","certID","certName","status=0 order by certID",1);
		}else{
			getComList("searchStudentNeedDiplomaHost","hostInfo","hostNo","title",w1,0);
			getComList("searchStudentNeedDiplomaCert","certificateInfo","certID","certName",w2,1);
		}
		
		$("#btnSearchStudentNeedDiploma").click(function(){
			getStudentNeedDiplomaList();
		});
		
		$("#btnStudentNeedDiplomaIssue").click(function(){
			if($("#searchStudentNeedDiplomaCert").val()==""){
				jAlert("请选择一个证书项目。");
				return false;
			}
			//alert($("#searchStudentNeedDiplomaCert").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&username=" + currUser);
			$.getJSON(uploadURL + "/outfiles/generate_diploma_byCertID?certID=" + $("#searchStudentNeedDiplomaCert").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&username=" + currUser ,function(data){
				jAlert("证书颁发成功 <a href='" + data["filename"] + "' target='_blank'>下载文件</a>");
				getStudentNeedDiplomaList();
			});
	
		});
		
		$("#txtSearchStudentNeedDiploma").keypress(function(event){
			if(event.keyCode==13){
				if($("#txtSearchStudentNeedDiploma").val()>""){
					getStudentNeedDiplomaList();
				}else{
					jAlert("请输入查询条件");
				}
			}
		});
		if(!checkPermission("diplomaAdd")){
			$("#btnStudentNeedDiplomaIssue").hide();
		}
		getStudentNeedDiplomaList();
	});

	function getStudentNeedDiplomaList(){
		sWhere = $("#txtSearchStudentNeedDiploma").val();
		var photo = 0;
		if($("#searchStudentNeedDiplomaPhoto").attr("checked")){photo = 1;}
		//alert((sWhere) + "&kindID=" + $("#searchStudentNeedDiplomaCert").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&keyID=" + photo);
		$.get("diplomaControl.asp?op=getStudentNeedDiplomaList&where=" + escape(sWhere) + "&kindID=" + $("#searchStudentNeedDiplomaCert").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&keyID=" + photo + "&dk=31&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#studentNeedDiplomaCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='studentNeedDiplomaTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='11%'>身份证</th>");
			arr.push("<th width='8%'>姓名</th>");
			arr.push("<th width='7%'>性别</th>");
			arr.push("<th width='7%'>年龄</th>");
			arr.push("<th width='13%'>证书名称</th>");
			if(currHost==""){
				arr.push("<th width='12%'>公司</th>");
			}else{
				arr.push("<th width='12%'>部门</th>");
			}
			arr.push("<th width='8%'>工种</th>");
			arr.push("<th width='10%'>结束日期</th>");
			arr.push("<th width='6%'>照片</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				var imgChk = "<img src='images/green_check.png'>";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					h = ar1[13];	//公司用户显示部门1名称
					if(ar1[9]>=55){c = 2;}	//55岁红色
					if(currHost==""){h = ar1[12];}	//系统用户显示公司名称
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showStudentNeedDiplomaInfo(\"" + ar1[0] + "\",0,0,1);'>" + ar1[1] + "</a></td>");
					arr.push("<td class='left'>" + ar1[2] + "</td>");
					arr.push("<td class='left'>" + ar1[5] + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='left'>" + ar1[4] + "</td>");
					if(currHost==""){
						arr.push("<td class='left'>" + ar1[8] + "</td>");
					}else{
						arr.push("<td class='left'>" + ar1[9] + "</td>");
					}
					arr.push("<td class='left'>" + ar1[10] + "</td>");
					arr.push("<td class='left'>" + ar1[11] + "</td>");
					if(ar1[13]==0){
						arr.push("<td class='center'>&nbsp;</td>");
					}else{
						arr.push("<td class='center'>" + imgChk + "</td>");
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
			arr.push("<th>&nbsp;</th>");
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#studentNeedDiplomaCover").html(arr.join(""));
			arr = [];
			$('#studentNeedDiplomaTab').dataTable({
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
	