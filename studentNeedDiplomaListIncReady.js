	var studentNeedDiplomaListLong = 0;		//0: 标准栏目  1：短栏目
	var studentNeedDiplomaListChk = 0;

	$(document).ready(function (){
		var w1 = "status=0 and hostNo='" + currHost + "'";
		var w2 = "status=0 and host='" + currHost + "'";
		$("#btnStudentNeedDiplomaIssue").hide();
		$("#btnStudentNeedDiplomaIssue1").hide();
		getDicList("statusYes","searchStudentNeedDiplomaHavePhoto",1);
		$("#searchStudentNeedDiplomaStartDate").click(function(){WdatePicker();});
		$("#searchStudentNeedDiplomaEndDate").click(function(){WdatePicker();});
		$("#searchStudentNeedDiplomaCloseStartDate").click(function(){WdatePicker();});
		$("#searchStudentNeedDiplomaCloseEndDate").click(function(){WdatePicker();});

		if(currHost==""){	//公司用户只能看自己公司内容
			getComList("searchStudentNeedDiplomaHost","hostInfo","hostNo","title","status=0 order by hostName",1);
			getComList("searchStudentNeedDiplomaCert","v_certificateInfo","certID","certName","status=0 and agencyID=4 and host='' order by certID",1);
			if(checkPermission("diplomaAdd")){
				$("#btnStudentNeedDiplomaIssue1").show();
			}
		}else{
			getComList("searchStudentNeedDiplomaHost","hostInfo","hostNo","title",w1,0);
			getComList("searchStudentNeedDiplomaCert","certificateInfo","certID","certName",w2,1);
			if(checkPermission("diplomaAdd")){
				$("#btnStudentNeedDiplomaIssue").show();
			}
			$("#searchStudentNeedDiplomaItem1").hide();
		}
		if(currHost!="spc"){	//
			$("#searchStudentNeedDiplomaItem2").hide();
		}else{
			getComList("searchStudentNeedDiplomaDept","dbo.getDept1List()","deptID","deptName","0=0 order by deptID",1);
		}
		if(!checkPermission("studentEdit")){
			$("#btnStudentNeedDiplomaAttentionPhotoClose").hide();
			$("#btnStudentNeedDiplomaAttentionPhoto").hide();
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
			$("#searchStudentNeedDiplomaPick").html(selCount);
		});
		
		$("#searchStudentNeedDiplomaCert").change(function(){
			if($("#searchStudentNeedDiplomaCert").val()>""){
				getComList("searchStudentNeedDiplomaClassID","v_classInfo","classID","classIDName","certID='" + $("#searchStudentNeedDiplomaCert").val() + "' order by cast(ID as int) desc",1);
			}
			getStudentNeedDiplomaList();
		});
		
		$("#searchStudentNeedDiplomaClassID").change(function(){
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
		
		$("#btnStudentNeedDiplomaIssue1").click(function(){
			getSelCart("visitstockchkNeed");
			if($("#searchStudentNeedDiplomaCert").val()==""){
				jAlert("请选择一个证书项目。");
				return false;
			}
			if(selCount==0){
				jAlert("请选择要制作证书的清单。");
				return false;
			}
			setSession("need2DiplomaList", selList);
			showGenerateDiplomaInfo1(0,$("#searchStudentNeedDiplomaCert").val(),"need2DiplomaList",selCount,$("#searchStudentNeedDiplomaClassID").find("option:selected").text(),1,1);
		});
		
		$("#btnStudentNeedDiplomaAttentionPhoto").click(function(){
			getSelCart("visitstockchkNeed");
			if(selCount==0){
				jAlert("请选择要通知的学员清单。");
				return false;
			}
			if(confirm("确定要通知这" + selCount + "个学员提交电子照片吗？")){
				$.post(uploadURL + "/public/send_message_submit_photo", {kind: "cert", selList: selList, SMS:1, registerID: currUser} ,function(data){
					jAlert("发送成功。");
					getStudentNeedDiplomaList();
				});
			}
		});
		
		$("#btnStudentNeedDiplomaAttentionPhotoClose").click(function(){
			getSelCart("visitstockchkNeed");
			if(selCount==0){
				jAlert("请选择要关闭的名单。");
				return false;
			}
			if(confirm("确定要将这" + selCount + "个提交电子照片通知关闭吗？")){
				$.post(uploadURL + "/public/send_message_submit_attention_close", {batchID: "", kindID:0, kind: "cert", selList: selList, SMS:1, registerID: currUser} ,function(data){
					jAlert("操作成功。");
					getStudentNeedDiplomaList();
				});
			}
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

		if(currHost>"" && currDeptID ==0){
			//getStudentNeedDiplomaList();
		}
	});

	function getStudentNeedDiplomaList(){
		sWhere = $("#txtSearchStudentNeedDiploma").val();
		var photo = $("#searchStudentNeedDiplomaHavePhoto").val();
		if(photo == ""){photo=3;}
		var refuse = 0;
		var mark = 1;
		if(currHost==""){mark=0;}
		//if($("#searchStudentNeedDiplomaPhoto").attr("checked")){photo = 1;}
		if($("#searchStudentNeedDiplomaRefuse").attr("checked")){refuse = 1;}
		//alert((sWhere) + "&kindID=" + $("#searchStudentNeedDiplomaCert").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&keyID=" + photo);
		$.get("diplomaControl.asp?op=getStudentNeedDiplomaList&where=" + escape(sWhere) + "&mark=" + mark + "&kindID=" + $("#searchStudentNeedDiplomaCert").val() + "&classID=" + $("#searchStudentNeedDiplomaClassID").val() + "&fStart=" + $("#searchStudentNeedDiplomaStartDate").val() + "&fEnd=" + $("#searchStudentNeedDiplomaEndDate").val() + "&closeStart=" + $("#searchStudentNeedDiplomaCloseStartDate").val() + "&closeEnd=" + $("#searchStudentNeedDiplomaCloseEndDate").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&dept=" + $("#searchStudentNeedDiplomaDept").val() + "&keyID=" + photo + "&refID=" + refuse + "&dk=21&times=" + (new Date().getTime()),function(data){
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
			arr.push("<th width='6%'>学号</th>");
			arr.push("<th width='11%'>身份证</th>");
			arr.push("<th width='6%'>姓名</th>");
			arr.push("<th width='5%'>年龄</th>");
			arr.push("<th width='12%'>证书名称</th>");
			if(currHost==""){
				arr.push("<th width='12%'>班级</th>");
				arr.push("<th width='8%'>学历</th>");
				arr.push("<th width='5%'>学费</th>");
			}else{
				arr.push("<th width='10%'>结束日期</th>");
			}
			arr.push("<th width='8%'>部门</th>");
			arr.push("<th width='6%'>照</th>");
			arr.push("<th width='5%'>证</th>");
			if(currHost>""){
				arr.push("<th width='5%'>章</th>");
			}
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				var imgChk = "";
				var attention_status = ["FFFFAA","AAFFAA","F3F3F3"];
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					imgChk = "<img src='images/green_check.png'>";
					//h = ar1[13];	//公司用户显示部门1名称
					//if(ar1[6]>60 && ar1[14]==1 && ar1[3]=="C5"){c = 2;}	//系统外单位，施工作业上岗证大于60岁的一律取消其证件(显示红色)
					if(ar1[6]>55 && ar1[3]=="C5" && ar1[23]==0){c = 2;}	//施工作业上岗证大于55岁且不在预批范围的一律提示(显示红色)
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='left'>" + ar1[19] + "</td>");
					arr.push("<td class='link1'><a href='javascript:showStudentNeedDiplomaInfo(\"" + ar1[0] + "\",0,0,1);'>" + ar1[1] + "</a></td>");
					arr.push("<td class='link1'><a href='javascript:showEnterInfo(" + ar1[22] + ",\"" + ar1[1] + "\",0,1,\"*\");'>" + ar1[2] + "</a></td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='left'>" + ar1[4] + "</td>");
					if(currHost==""){
						arr.push("<td class='left'>" + ar1[15] + "</td>");
						arr.push("<td class='left'>" + ar1[18] + "</td>");
						if(ar1[21]==1){
							arr.push("<td class='left'>" + imgChk + "</td>");
						}else{
							arr.push("<td class='left'>&nbsp;</td>");
						}
					}else{
						arr.push("<td class='left'>" + ar1[11] + "</td>");
					}
					arr.push("<td class='left'>" + ar1[9] + "</td>");
					if(ar1[26]>0){	//根据照片或签字提醒状态，显示不同背景颜色
						h = " style='background-color:#" + attention_status[ar1[26]-1] + ";'";
					}else{
						h = "";
					}
					if($("#searchStudentNeedDiplomaShowPhoto").attr("checked")){
						imgChk = "<img id='photoA" + ar1[1] + "' src='users" + ar1[13] + "?t=" + (new Date().getTime()) + "' onclick='showCropperInfo(\"users" + ar1[13] + "\",\"" + ar1[1] + "\",\"photo\",\"A\",0,1)' style='width:50px;background: #ccc;border:2px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);'>";
					}else{
						imgChk = "&nbsp;";
					}
					if(ar1[13].length==0){
						arr.push("<td class='center'" + h + ">&nbsp;</td>");
					}else{
						arr.push("<td class='center'" + h + ">" + imgChk + "</td>");
					}
					if(currHost>"" || ar1[21]==1){	//未交费的不能做证书
						arr.push("<td class='left'>" + "<input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + ar1[0] + "' name='visitstockchkNeed'>" + "</td>");
					}else{
						arr.push("<td class='center'>&nbsp;</td>");
					}
					if(currHost>""){
						arr.push("<td class='left'>" + "<input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + ar1[0] + "' name='visitstockchkStamp' checked='checked'>" + "</td>");
					}
					arr.push("</tr>");
				});
			}
			arr.push("</tbody>");
			arr.push("<tfoot>");
			arr.push("<tr>");
			arr.push("<th>&nbsp;</th>");
			if(currHost==""){
				arr.push("<th>&nbsp;</th>");
				arr.push("<th>&nbsp;</th>");
			}
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			if(currHost>""){
				arr.push("<th>&nbsp;</th>");
			}
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
				"aLengthMenu":[15,30,50,100,500],
				"iDisplayLength": 500,
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
			$("#searchStudentNeedDiplomaPick").html(0);
			$('input[type=checkbox][name=visitstockchkNeed]').change(function(){
				getSelCart("visitstockchkNeed");
				$("#searchStudentNeedDiplomaPick").html(selCount);
			});
		});
	}
	