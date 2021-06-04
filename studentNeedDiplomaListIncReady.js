	var studentNeedDiplomaListLong = 0;		//0: 标准栏目  1：短栏目
	var studentNeedDiplomaListChk = 0;

	$(document).ready(function (){
		var w1 = "status=0 and hostNo='" + currHost + "'";
		var w2 = "status=0 and host='" + currHost + "'";
		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("searchStudentNeedDiplomaHost","hostInfo","hostNo","title","status=0 order by hostName",1);
			getComList("searchStudentNeedDiplomaCert","v_certificateInfo","certID","certName","status=0 and host='' order by certID",1);
		}else{
			getComList("searchStudentNeedDiplomaHost","hostInfo","hostNo","title",w1,0);
			getComList("searchStudentNeedDiplomaCert","certificateInfo","certID","certName",w2,1);
		}
		
		$("#btnSearchStudentNeedDiploma").click(function(){
			getStudentNeedDiplomaList();
		});
		
		$("#btnStudentNeedDiplomaSel").click(function(){
			setSel("visitstockchkNeed");
			if(selCount == 0){
				selCount1 = 1;
			}else{
				selCount1 = 0;
			}
			setSel1("visitstockchkStamp");
		});
		
		$("#searchStudentNeedDiplomaCert").change(function(){
			getStudentNeedDiplomaList();
		});
		
		$("#btnStudentNeedDiplomaIssue").click(function(){
			getSelCart("visitstockchkNeed");
			getSelCart1("visitstockchkStamp");	//是否盖章
			if($("#searchStudentNeedDiplomaCert").val()==""){
				jAlert("请选择一个证书项目。");
				return false;
			}
			if(selCount==0){
				jAlert("请选择要制作证书的清单。");
				return false;
			}
			jConfirm("确定要制作证书(" + selCount + "个)吗？","确认",function(r){
				if(r){
					//alert($("#searchStudentNeedDiplomaCert").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&username=" + currUser);
					//jAlert(selList);
					$.getJSON(uploadURL + "/outfiles/generate_diploma_byCertID?certID=" + $("#searchStudentNeedDiplomaCert").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&batchID=0&selList=" + selList + "&selList1=" + selList1 + "&username=" + currUser ,function(data){
						if(data>""){
							jAlert("证书制作成功 <a href='" + data + "' target='_blank'>下载文件</a>");
							getStudentNeedDiplomaList();
						}else{
							jAlert("没有可供处理的数据。");
						}
					});
				}
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

		if(currHost>""){
			getStudentNeedDiplomaList();
		}
	});

	function getStudentNeedDiplomaList(){
		sWhere = $("#txtSearchStudentNeedDiploma").val();
		var photo = 0;
		var refuse = 0;
		if($("#searchStudentNeedDiplomaPhoto").attr("checked")){photo = 1;}
		if($("#searchStudentNeedDiplomaRefuse").attr("checked")){refuse = 1;}
		//alert((sWhere) + "&kindID=" + $("#searchStudentNeedDiplomaCert").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&keyID=" + photo);
		$.get("diplomaControl.asp?op=getStudentNeedDiplomaList&where=" + escape(sWhere) + "&kindID=" + $("#searchStudentNeedDiplomaCert").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&keyID=" + photo + "&refID=" + refuse + "&dk=21&times=" + (new Date().getTime()),function(data){
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
			arr.push("<th width='7%'>年龄</th>");
			arr.push("<th width='13%'>证书名称</th>");
			if(currHost==""){
				arr.push("<th width='12%'>公司</th>");
			}else{
				arr.push("<th width='12%'>部门</th>");
			}
			arr.push("<th width='8%'>工种</th>");
			arr.push("<th width='10%'>结束日期</th>");
			arr.push("<th width='6%'>照</th>");
			arr.push("<th width='5%'>证</th>");
			arr.push("<th width='5%'>章</th>");
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
					if(ar1[6]>55 && ar1[14]==1 && ar1[3]=="C5"){c = 2;}	//系统外单位，施工作业上岗证大于55岁的一律取消其证件(显示红色)
					if(currHost==""){h = ar1[12];}	//系统用户显示公司名称
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showStudentNeedDiplomaInfo(\"" + ar1[0] + "\",0,0,1);'>" + ar1[1] + "</a></td>");
					arr.push("<td class='left'>" + ar1[2] + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='left'>" + ar1[4] + "</td>");
					if(currHost==""){
						arr.push("<td class='left'>" + ar1[8] + "</td>");
					}else{
						arr.push("<td class='left'>" + ar1[9] + "</td>");
					}
					arr.push("<td class='left'>" + ar1[10] + "</td>");
					arr.push("<td class='left'>" + ar1[11] + "</td>");
					if($("#searchStudentNeedDiplomaShowPhoto").attr("checked")){
						imgChk = "<img src='users" + ar1[13] + "' style='width:50px;background: #ccc;border:2px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);'>";
					}
					if(ar1[13]==0){
						arr.push("<td class='center'>&nbsp;</td>");
					}else{
						arr.push("<td class='center'>" + imgChk + "</td>");
					}
					arr.push("<td class='left'>" + "<input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + ar1[0] + "' name='visitstockchkNeed'>" + "</td>");
					arr.push("<td class='left'>" + "<input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + ar1[0] + "' name='visitstockchkStamp'>" + "</td>");
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
			if($("#searchStudentNeedDiplomaCert").val()>""){
				setSel("");
			}
		});
	}
	