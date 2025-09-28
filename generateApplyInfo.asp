<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/default/easyui.css?v=1.11">
	<link rel="stylesheet" type="text/css" href="js/easyui/themes/icon.css?v=1.19">
<link href="css/data_table_mini.css?v=20150411" rel="stylesheet" type="text/css" />
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="css/jquery.autocomplete.css" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script language="javascript" src="js/jquery.form.js"></script>
	<script type="text/javascript" src="js/easyui/jquery.easyui.min.js?v=1.2"></script>
	<script type="text/javascript" src="js/easyui/locale/easyui-lang-zh_CN.js?v=1.0"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<script type='text/javascript' src='js/jquery.autocomplete.js'></script>
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var nodeID = "";
	var refID = "";
	let classID = 0;
	var op = 0;
	var updateCount = 0;
	var address = "";
    var certID = "";
	var reexamine = 0;
	var agencyID = 0;
	var imgFile = "<img src='images/attachment.png' style='width:15px;'>";
	var imgFileRed = "<img src='images/attachmentRed.png' style='width:15px;'>";
	var timer1 = null;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";		//
		refID = "<%=refID%>";		//
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 
		getDicList("statusApply","s_status",1);
		getDicList("statusNo","s_resit",1);
		getComList("courseID","v_courseInfo","courseID","shortName","status=0 and type=0 and agencyID not in(4,5) order by courseID",1);
		if(currHost==""){
			getComList("host","hostInfo","hostNo","title","status=0 and kindID=1 order by ID",1);
			getComList("partner","hostInfo","hostNo","title","status=0 and kindID=1 order by ID",1);
		}else{
			getComList("host","hostInfo","hostNo","title","status=0 and kindID=1 and hostNo='" + currHost + "' order by ID",0);
			getComList("partner","hostInfo","hostNo","title","status=0 and kindID=1 and hostNo='" + currHost + "' order by ID",0);
			// getComList("courseID","v_courseInfo a, hostCourseList b","a.courseID","a.shortName","a.courseID=b.courseID and a.status=0 and b.host='" + currHost + "' order by a.courseID",1);
		}
		getComList("fromID","userInfo","username","realName","status=0 and username in(select username from roleUserList where roleID='saler') order by realName",1);

		$("#startDate").click(function(){WdatePicker();});
		$("#endDate").click(function(){WdatePicker();});
		setButton();
		if(nodeID>0 && op==0){
			getNodeInfo(nodeID);
		}

		$("#sendMsgExam").click(function(){
			if(address==""){
				jAlert("请填写考试地址并保存。");
				return false;
			}
			jConfirm("确定向这批考生发送考试通知吗？","确认",function(r){
				if(r){
					//alert($("#searchStudentNeedDiplomaCert").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&username=" + currUser);
					$.getJSON(uploadURL + "/public/send_message_exam_apply?SMS=1&batchID=" + nodeID + "&registerID=" + currUser ,function(data){
						if(data>""){
							jAlert("通知发送成功。");
							getNodeInfo(nodeID);
						}else{
							jAlert("没有可供处理的数据。");
						}
					});
				}
			});
		});

		$("#sendMsgScore").click(function(){
			jConfirm("确定向这批考生发送成绩单吗？","确认",function(r){
				if(r){
					//alert($("#searchStudentNeedDiplomaCert").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&username=" + currUser);
					$.getJSON(uploadURL + "/public/send_message_score_apply?SMS=1&batchID=" + nodeID + "&registerID=" + currUser ,function(data){
						if(data>""){
							jAlert("通知发送成功。");
							getNodeInfo(nodeID);
						}else{
							jAlert("没有可供处理的数据。");
						}
					});
				}
			});
		});

		$("#sendMsgDiploma").click(function(){
			getSelCart("");
			if(selCount==0){
				jAlert("请选择要通知的人员。");
				return false;
			}
			jConfirm("确定通知这些人领证吗？","确认",function(r){
				if(r){
					//alert($("#searchStudentNeedDiplomaCert").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&username=" + currUser);
					$.post(uploadURL + "/public/send_message_diploma_apply?SMS=1&batchID=" + nodeID + "&registerID=" + currUser,{"selList":selList} ,function(data){
						if(data>""){
							jAlert("通知发送成功。");
							getNodeInfo(nodeID);
						}else{
							jAlert("没有可供处理的数据。");
						}
					});
				}
			});
		});
		$("#btnInvoiceGroup").click(function(){
			getSelCart("");
			if(selCount==0){
				jAlert("请选择学员名单。");
				return false;
			}
			jConfirm('确定这' + selCount + '个学员共用一个发票吗?',"确认",function(r){
				if(r){
					var x = prompt("请输入发票号码：","");
					if(x && x>""){
						$.post(uploadURL + "/public/setInvoiceGroup", {classID:$("#ID").val(), kind: "A", selList: selList, invoice: x, registerID: currUser} ,function(data){
							jAlert(data.msg);
						});
					}
				}
			});
		});

		$("#showPhoto").checkbox({
			onChange: function(val){
				getApplyList();
			}
		});

		$("#showWait").checkbox({
			onChange: function(val){
				getApplyList();
			}
		});

		$("#showWaitUpload").checkbox({
			onChange: function(val){
				getApplyList();
			}
		});

		$("#showWaitUploadPhoto").checkbox({
			onChange: function(val){
				getApplyList();
			}
		});

		$("#showDrop").checkbox({
			onChange: function(val){
				getApplyList();
			}
		});
		$("#studyOnline").click(function(){
			showClassStudyOnline(nodeID,"A","",0,1);
		});

		$("#save").click(function(){
			saveNode();
		});

		$("#del").click(function(){
			if($("#qty").val()>0){
				jAlert("该批申报还有考生，请将其清空后再删除。");
				return false;
			}
			jConfirm('你确定要删除申报信息吗?', '确认对话框', function(r) {
				if(r){
					$.get("diplomaControl.asp?op=delGenerateApply&nodeID=" + nodeID + "&&times=" + (new Date().getTime()),function(data){
						jAlert("成功删除！","信息提示");
						op = 1;
						setButton();
						updateCount += 1;
					});
				}
			});
		});
		$("#close").click(function(){
			if(confirm('确定要结束本次申报吗?')){
				$.get("diplomaControl.asp?op=closeGenerateApply&nodeID=" + $("#ID").val() + "&refID=2&times=" + (new Date().getTime()),function(data){
					jAlert("已关闭申报","信息提示");
					getNodeInfo(nodeID);
					updateCount += 1;
				});
			}
		});
		$("#lock").click(function(){
			if(confirm('确定要锁定本次申报吗? 将无法调整考生名单。')){
				$.get("diplomaControl.asp?op=closeGenerateApply&nodeID=" + $("#ID").val() + "&refID=1&times=" + (new Date().getTime()),function(data){
					jAlert("已锁定申报","信息提示");
					getNodeInfo(nodeID);
					updateCount += 1;
				});
			}
		});
		$("#open").click(function(){
			if(confirm('确定要重新开启本次申报吗? 如果有人员调整，请注意重新生成数据。')){
				$.get("diplomaControl.asp?op=closeGenerateApply&nodeID=" + $("#ID").val() + "&refID=0&times=" + (new Date().getTime()),function(data){
					jAlert("已重新开启申报，请及时关闭或锁定。","信息提示");
					getNodeInfo(nodeID);
					updateCount += 1;
				});
			}
		});
		$("#btnRemove").click(function(){
			getSelCart("");
			if(selCount==0){
				jAlert("请选择要移除的人员。");
				return false;
			}
			jConfirm('确定要将这' + selCount + '个人从本次申报移除吗?', "确认对话框",function(r){
				if(r){
					$.post("diplomaControl.asp?op=remove4GenerateApply&nodeID=0", {"selList":selList},function(data){
						//jAlert(data);
						jAlert("已成功移除","信息提示");
						getNodeInfo(nodeID);
						updateCount += 1;
					});
				}
			});
		});

		$("#doApplyEnter").linkbutton({
			iconCls:'icon-gear',
			width:85,
			height:25,
			text:'自动报名',
			onClick:function() {
				getSelCart("");
				if(selCount==0){
					$.messager.alert("提示","请选择要报名的人员。","info");
					return false;
				}
				// jConfirm('确定要为这' + selCount + '个人报名吗?', "确认对话框",function(r){
				$.messager.confirm('确认对话框','确定要为这' + selCount + '个人报名吗?<br>可能要花几分钟时间，请稍候...', function(r){
					if(r){
						var start = performance.now(); 
						$.ajax({
							url: uploadURL + "/public/applyEnter?SMS=1&reexamine=" + reexamine + "&register=" + currUserName + "&host=znxf&classID=1&courseName=" + $("#courseName").val() + "&reex=" + (reexamine==0?"初证":"复审"),
							type: "post",
							data: {"selList":selList},
							beforeSend: function() {   
								$.messager.progress();	// 显示进度条
							},
							success: function(data){
								if(data.count_s>0){
									var end = performance.now(); 
									$.messager.alert("提示","成功报名数量：" + data.count_s + "; &nbsp;失败数量：" + data.count_e + "; &nbsp;耗时：" + ((end-start)/1000).toFixed(2) + "秒","info");
								}else{
									$.messager.alert("提示","操作失败，请稍后再试。" + data.errMsg,"info");
								}
								getApplyList();
								$.messager.progress('close');	// 如果提交成功则隐藏进度条 
							},
							error: function () {
								$.messager.progress('close');
							}
						});
					}
				});
			}
		});
		
		$("#doApplyUpload").linkbutton({
			iconCls:'icon-upload',
			width:85,
			height:25,
			text:'上传材料',
			onClick:function() {
				getSelCart("");
				if(selCount==0){
					$.messager.alert("提示","请选择要上传报名表的人员。","info");
					return false;
				}
				if($("#applyID").val()==""){
					$.messager.alert("提示","请填写开班编号并保存。","info");
					return false;
				}
				// jConfirm('确定要为这' + selCount + '个人报名吗?', "确认对话框",function(r){
				$.messager.confirm('确认对话框','确定要为这' + selCount + '个人上传报名表吗?<br>可能要花几分钟时间，请稍候...', function(r){
					if(r){
						var start = performance.now(); 
						$.ajax({
							url: uploadURL + "/public/applyEnter?SMS=1&reexamine=9&register=" + currUserName + "&host=znxf&classID=" + $("#applyID").val() + "&courseName=" + $("#courseName").val() + "&reex=" + (reexamine==0?"初证":"复审"),
							type: "post",
							data: {"selList":selList},
							beforeSend: function() {   
								$.messager.progress();	// 显示进度条
							},
							success: function(data){
								if(data.count_s>0){
									var end = performance.now(); 
									$.messager.alert("提示","成功上传数量：" + data.count_s + "; &nbsp;失败数量：" + data.count_e + "; &nbsp;耗时：" + ((end-start)/1000).toFixed(2) + "秒","info");
								}else{
									$.messager.alert("提示","操作失败，请稍后再试。" + data.errMsg,"info");
								}
								getApplyList();
								$.messager.progress('close');	// 如果提交成功则隐藏进度条 
							},
							error: function () {
								$.messager.progress('close');
							}
						});
					}
				});
			}
		});
		
		$("#doApplyUploadPhoto").linkbutton({
			iconCls:'icon-upload',
			width:85,
			height:25,
			text:'上传照片',
			onClick:function() {
				getSelCart("");
				if(selCount==0){
					$.messager.alert("提示","请选择要上传照片的人员。","info");
					return false;
				}
				if($("#applyID").val()==""){
					$.messager.alert("提示","请填写开班编号并保存。","info");
					return false;
				}
				// jConfirm('确定要为这' + selCount + '个人报名吗?', "确认对话框",function(r){
				$.messager.confirm('确认对话框','确定要为这' + selCount + '个人上传照片吗?<br>可能要花几分钟时间，请稍候...', function(r){
					if(r){
						var start = performance.now(); 
						$.ajax({
							url: uploadURL + "/public/applyEnter?SMS=1&reexamine=8&register=" + currUserName + "&host=znxf&classID=" + $("#applyID").val() + "&courseName=" + $("#courseName").val() + "&reex=" + (reexamine==0?"初证":"复审"),
							type: "post",
							data: {"selList":selList},
							beforeSend: function() {   
								$.messager.progress();	// 显示进度条
							},
							success: function(data){
								if(data.count_s>0){
									var end = performance.now(); 
									$.messager.alert("提示","成功上传数量：" + data.count_s + "; &nbsp;失败数量：" + data.count_e + "; &nbsp;耗时：" + ((end-start)/1000).toFixed(2) + "秒","info");
								}else{
									$.messager.alert("提示","操作失败，请稍后再试。" + data.errMsg,"info");
								}
								getApplyList();
								$.messager.progress('close');	// 如果提交成功则隐藏进度条 
							},
							error: function () {
								$.messager.progress('close');
							}
						});
					}
				});
			}
		});
		
		$("#doApplyUploadSchedule").linkbutton({
			iconCls:'icon-upload',
			width:85,
			height:25,
			text:'创建计划',
			onClick:function() {
				if($("#startDate").val()==""){
					alert("请确定开课日期。");
					return false;
				}
				if($("#endDate").val()==""){
					alert("请确定结束日期。");
					return false;
				}
				if($("#notes").val()==""){
					$.messager.alert("提示","请填写办学地点并保存。","info");
					return false;
				}
				if($("#adviserID").val()==""){
					$.messager.alert("提示","请选择班主任并保存。","info");
					return false;
				}
				// jConfirm('确定要为这' + selCount + '个人报名吗?', "确认对话框",function(r){
				$.messager.confirm('确认对话框','确定要创建新的计划吗?<br>可能要花几分钟时间，请稍候...', function(r){
					if(r){
						var start = performance.now(); 
						$.ajax({
							url: uploadURL + "/public/applyEnter?SMS=1&reexamine=7&register=" + currUserName + "&host=znxf&classID=" + $("#ID").val() + "&courseName=" + $("#courseName").val() + "&reex=" + (reexamine==0?"初证":"复审"),
							type: "post",
							data: {"selList":$("#adviserID").find("option:selected").text()},
							beforeSend: function() {   
								$.messager.progress();	// 显示进度条
							},
							success: function(data){
								if(data.count_s>0){
									var end = performance.now(); 
									$.messager.alert("提示","成功上传数量：" + data.count_s + "; &nbsp;失败数量：" + data.count_e + "; &nbsp;耗时：" + ((end-start)/1000).toFixed(2) + "秒","info");
								}else{
									$.messager.alert("提示","操作失败，请稍后再试。" + data.errMsg,"info");
								}
								$.messager.progress('close');	// 如果提交成功则隐藏进度条 
							},
							error: function () {
								$.messager.progress('close');
							}
						});
					}
				});
			}
		});
		
		$("#doApplyDownload").linkbutton({
			iconCls:'icon-download',
			width:85,
			height:25,
			text:'下载成绩',
			onClick:function() {
				getSelCart("");
				if(selCount==0){
					$.messager.alert("提示","请选择要下载成绩的人员。","info");
					return false;
				}
				if($("#applyID").val()==""){
					$.messager.alert("提示","请填写开班编号并保存。","info");
					return false;
				}
				// jConfirm('确定要为这' + selCount + '个人报名吗?', "确认对话框",function(r){
				$.messager.confirm('确认对话框','确定要为这' + selCount + '个人下载成绩吗?<br>可能要花几分钟时间，请稍候...', function(r){
					if(r){
						var start = performance.now(); 
						$.ajax({
							url: uploadURL + "/public/applyEnter?SMS=1&reexamine=10&register=" + currUserName + "&host=znxf&classID=" + $("#applyID").val() + "&courseName=" + $("#courseName").val() + "&reex=" + (reexamine==0?"初证":"复审"),
							type: "post",
							data: {"selList":selList},
							beforeSend: function() {   
								$.messager.progress();	// 显示进度条
							},
							success: function(data){
								//jAlert(data);
								if(data.err==0){
									var end = performance.now(); 
									jAlert("成功下载数量：" + data.count_s + "; &nbsp;失败数量：" + data.count_e + "; &nbsp;耗时：" + ((end-start)/1000).toFixed(2) + "秒","信息提示");
								}else{
									jAlert("操作失败，请稍后再试。" + data.errMsg,"信息提示");
								}
								getApplyList();
								$.messager.progress('close');	// 如果提交成功则隐藏进度条 
							},
							error: function () {
								$.messager.progress('close');
							}
						});
					}
				});
			}
		});
		
		$("#doApplyDownloadExamDate").linkbutton({
			iconCls:'icon-download',
			width:85,
			height:25,
			text:'考试时间',
			onClick:function() {
				getSelCart("");
				if(selCount==0){
					$.messager.alert("提示","请选择要下载考试时间的人员。","info");
					return false;
				}
				if($("#applyID").val()==""){
					$.messager.alert("提示","请填写开班编号并保存。","info");
					return false;
				}
				// jConfirm('确定要为这' + selCount + '个人报名吗?', "确认对话框",function(r){
				$.messager.confirm('确认对话框','确定要为这' + selCount + '个人下载考试时间吗?<br>可能要花几分钟时间，请稍候...', function(r){
					if(r){
						var start = performance.now(); 
						$.ajax({
							url: uploadURL + "/public/applyEnter?SMS=1&reexamine=11&register=" + currUserName + "&host=znxf&classID=" + $("#applyID").val() + "&courseName=" + $("#courseName").val() + "&reex=" + (reexamine==0?"初证":"复审"),
							type: "post",
							data: {"selList":selList},
							beforeSend: function() {   
								$.messager.progress();	// 显示进度条
							},
							success: function(data){
								//jAlert(data);
								if(data.err==0){
									var end = performance.now(); 
									jAlert("成功下载数量：" + data.count_s + "; &nbsp;失败数量：" + data.count_e + "; &nbsp;耗时：" + ((end-start)/1000).toFixed(2) + "秒","信息提示");
								}else{
									jAlert("操作失败，请稍后再试。" + data.errMsg,"信息提示");
								}
								getApplyList();
								$.messager.progress('close');	// 如果提交成功则隐藏进度条 
							},
							error: function () {
								$.messager.progress('close');
							}
						});
					}
				});
			}
		});

		$("#list").click(function(){
			//alert(nodeID+$("#courseName").val()+$("#reexamineName").val());
			outputExcelBySQL('x05','file',nodeID,$("#courseName").val(),$("#reexamineName").val());
		});
		$("#diplomaSign").click(function(){
			outputExcelBySQL('x06','file',nodeID,$("#courseName").val(),$("#ID").val() + "-" + $("#applyID").val());
		});
		$("#courseID").change(function(){
			var c = $("#courseID").find("option:selected").text();
			if($("#startDate").val()>"" && c > ""){
				$("#title").val(c + $("#startDate").val());
			}
            $.get("diplomaControl.asp?op=getLastApplyAddress&refID=" + $("#courseID").val() + "&times=" + (new Date().getTime()),function(re){
                //alert(unescape(re));
                var ar = new Array();
                ar = unescape(re).split("|");
                if(ar > ""){
                    $("#address").val(ar[0]);
                }
            });
		});
		$("#btnSearch").click(function(){
			getApplyList();
		});

		$("#btnSel").click(function(){
			setSel("");
		});
		
		$("#btnResit").click(function(){
			if($("#status").val()==0){
				jAlert("请先结束申报，再安排补申。");
				return false;
			}
			getSelCart("");
			if(selCount==0){
				jAlert("请选择要加入购物车的人员。");
				return false;
			}
			jConfirm('确定要安排这' + selCount + '个人补申吗?', "确认对话框",function(r){
				if(r){
					add2Cart("","examer","*补考*");
					updateCount += 1;
				}
			});
		});
		$("#doImportApply").click(function(){
			showLoadFile("apply_list",$("#ID").val(),"studentList",'');
			updateCount += 1;
		});
		$("#doImportScore").click(function(){
			jPrompt('发证日期:\n(不填写将使用本次考试日期)', currDate, '附加信息', function (r) {
				if ((r>"" && isDate(r)) || r=="") {
					showLoadFile("apply_score_list",$("#ID").val(),"studentList",'',r);
					updateCount += 1;
				}else{
					jAlert("请输入正确的发证日期");
				}
			});
		});
		$("#doImportApplyResit").click(function(){
			showLoadFile("apply_resit_list",$("#ID").val(),"studentList",'');
			updateCount += 1;
		});
	
		$("#generateClassDoc").click(function(){
			getSelCart("");
			if(selCount==0){
				$.messager.alert("提示","请选择要操作的名单。","info");
				return false;
			}
			if(confirm("确定要生成这" + selCount + "个存档资料吗？")){
				$.post(uploadURL + "/outfiles/generate_emergency_exam_materials_byclass?refID=" + nodeID + "&keyID=2&registerID=" + currUser, {selList:selList}, function(data){
					if(data>"0"){
						// generateZip("e");
						alert("已生成" + data + "份文档");
						getApplyList();
					}else{
						alert("没有可供处理的数据。");
					}
				});
			}
		});
	
		$("#btnSetSource").click(function(){
			getSelCart("");
			if(selCount==0){
				$.messager.alert("提示","请选择要操作的名单。","info");
				return false;
			}
			if(confirm("确定为这" + selCount + "个学员设置来源吗？")){
				$.get("agencyControl.asp?op=getCurrSourceList",function(re){
					// alert(unescape(data));
					let ar0 = $.parseJSON(unescape(re));
					jSelect("请选择来源：", ar0, "学员来源",function(d){
						d = d.replace(/\s*/g,"");
						$.post(uploadURL + "/public/postCommInfo", {proc:"setStudentSource", params:{selList:selList, kind:"A", classID:nodeID, source:d, registerID:currUser}}, function(data){
							//alert(unescape(re));
							let ar = data[0]
							// alert(ar)
							if(ar["status"] == "0"){
								$.messager.alert("提示","操作成功","info");
								getApplyList();
							}else{
								$.messager.alert("提示",ar["msg"],"info");
							}
						});
					});
				});
			}
		});
	
		$("#generateEntryDoc").click(function(){
			generateEntryDoc(0);
		});
	
		$("#generateEntryDoc1").click(function(){
			generateEntryDoc(1);
		});
	
		// $("#generateEntryDoc").click(function(){
		// 	getSelCart("");
		// 	if(selCount==0){
		// 		$.messager.alert("提示","请选择要操作的名单。","info");
		// 		return false;
		// 	}
		// 	if(confirm("确定要生成这" + selCount + "个报名表吗？")){
		// 		$.post(uploadURL + "/outfiles/generate_emergency_exam_materials_byclass?refID=" + nodeID + "&keyID=5&registerID=" + currUser, {selList:selList}, function(data){
		// 			if(data>"0"){
		// 				// generateZip("e");
		// 				alert("已生成" + data + "份文档");
		// 				getApplyList();
		// 			}else{
		// 				alert("没有可供处理的数据。");
		// 			}
		// 		});
		// 	}
		// });
	
		$("#generateZip").click(function(){
			generateZip("m");
		});
	
		$("#generatePhotoZip").click(function(){
			generateZip("p");
		});
	
		$("#generateEntryZip").click(function(){
			generateZip("e");
		});
		
		$("#btnSchedule").click(function(){
			if($("#startDate").val()==""){
				alert("请确定开课日期。");
				return false;
			}
			if($("#teacher").val()==""){
				alert("请确定任课教师。");
				return false;
			}
			if($("#classroom").val()==""){
				alert("请确定教室。");
				return false;
			}
			if(confirm(($("#scheduleDate").val()>""?"课表已经存在，要重新安排吗？":"确定要编排课表吗？"))){
				$.get("classControl.asp?op=generateClassSchedule&refID=" + $("#ID").val() + "&kindID=A&times=" + (new Date().getTime()),function(re){
					if(re==0){
						getNodeInfo(nodeID);
						jAlert("课表编排完毕。");
					}else{
						jAlert("已有考勤记录，不能重新生成课表。");
					}
				});
			}
		});
		$("#schedule").click(function(){
			showClassSchedule($("#ID").val(),"A","{className:'" + $("#ID").val() + "', courseName:'" + $("#courseName").val()+"', transaction_id:'" + $("#applyID").val()+"', startDate:'"+$("#startDate").val().substr(0,10)+"', endDate:'', adviser:'" + $("#adviserID").find("option:selected").text() + "', qty:"+$("#qty").val()+"}",0,1);
		});
		
		$("#btnArchive").click(function(){
			if($("#summary").val()==""){
				jAlert("请填写工作小结。");
				return false;
			}
			window.open("class_archives.asp?nodeID=" + nodeID + "&keyID=1&kindID=A", "_self");
		});

		$("#checkin").click(function(){
			if($("#scheduleDate").val()>""){
				showClassCheckin($("#ID").val(),"A","",0,1);
			}else{
				alert("请先生成课表。");
				return false;
			}
		});

		$("#btnProof").click(function(){
			$.get(uploadURL + "/outfiles/get_trainProof_shot?nodeID=" + nodeID, function(data){
				$.messager.alert("提示","已生成","info");
				getNodeInfo(nodeID);
			});
		});

	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		// alert(id);
		$.get("diplomaControl.asp?op=getGenerateApplyNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			// alert(unescape(re));
			var ar = new Array();
			var c = "";
			ar = unescape(re).split("|");
			if(ar > ""){
				getComList("teacher","dbo.getFreeTeacherList('','" + ar[0] + "','A')","teacherID","teacherName","1=1 order by freePoint desc",1);
				getComList("adviserID","userInfo","username","realName","status=0 and username in(select username from roleUserList where roleID='adviser' and host='') order by realName",1);
				$("#ID").val(ar[0]);
				$("#courseID").val(ar[1]);
				$("#courseName").val(ar[2]);
				$("#title").val(ar[3]);
				$("#qty").val(ar[4]);
				$("#applyID").val(ar[5]);
				if(ar[5] > ""){
					$("#showPhoto").checkbox({checked:false});	//有班级编号的默认不显示照片
				}else{
					$("#showPhoto").checkbox({checked:true});
				}
				$("#startDate").val(ar[6]);
				$("#endDate").val(ar[53]);
				$("#address").val(ar[11]);
				address = ar[11];
				$("#memo").val(ar[8]);
				$("#regDate").val(ar[9]);
				$("#registerName").val(ar[10]);
				$("#status").val(ar[15]);
				$("#statusName").val(ar[16]);
				$("#send").val(ar[12]);
				$("#sendDate").val(ar[13]);
				$("#senderName").val(ar[14]);
				$("#sendScore").val(ar[18]);
				$("#sendScoreDate").val(ar[19]);
				$("#senderScoreName").val(ar[20]);
				$("#reexamineName").val(ar[24]);
				$("#host").val(ar[32]);
				if(ar[38]==1){
					$("#diplomaReady").prop("checked",true);
				}else{
					$("#diplomaReady").prop("checked",false);
				}
				$("#teacher").val(ar[39]);
				$("#classroom").val(ar[40]);
				$("#scheduleDate").val(ar[41]);
				$("#adviserID").val(ar[42]);
				$("#uploadScheduleDate").val(ar[44]);
				$("#planID").val(ar[50]);
				$("#planQty").val(ar[51]);
				$("#notes").val(ar[52]);
				if(ar[41]>""){
					$("#schedule").html("<a>课程表</a>");
				}
				reexamine = ar[36];
				agencyID = ar[37];
				certID = ar[31];
				$("#summary").val(ar[49]);
				$("#archiveDate").val(ar[48]);
				$("#archiverName").val(ar[47]);
				$("#list").html("<a href=''>申报名单</a>");
				$("#diplomaSign").html("<a href=''>证书签收单</a>");
				if(ar[7] > ""){
					$("#proof").html("<a href='/users" + ar[7] + "?" + (new Date().getTime()) + "' target='_blank' style='text-decoration:none;color:green;'>&nbsp;&nbsp;培训证明</a>");
				}
				if(ar[17] > ""){
					$("#scoreResult").html("<a href='/users" + ar[17] + "' target='_blank'>成绩单</a>");
				}
                $("#diplomaSign").show();
				if(ar[33] > ""){
					$("#zip").html("<a href='/users" + ar[33] + "?times=" + (new Date().getTime()) + "' target='_blank'>归档压缩包</a>");
				}
				if(ar[34] > ""){
					$("#pzip").html("<a href='/users" + ar[34] + "?times=" + (new Date().getTime()) + "' target='_blank'>照片压缩包</a>");
				}
				if(ar[35] > ""){
					$("#ezip").html("<a href='/users" + ar[35] + "?times=" + (new Date().getTime()) + "' target='_blank'>报名表压缩包</a>");
				}
				//getDownloadFile("generateDiplomaID");
				nodeID = ar[0];
				setButton();
				getApplyList();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		if($("#title").val()==""){
			jAlert("请填写标题。");
			return false;
		}
		if($("#startDate").val()==""){
			jAlert("请填写申报日期。");
			return false;
		}
		// if($("#startTime").val()==""){
		// 	jAlert("请填写申报时间。");
		// 	return false;
		// }
		if($("#courseID").val()==""){
			jAlert("请选择申报科目。");
			return false;
		}				
		var diplomaReady = 0;
		if($("#diplomaReady").prop("checked")){
			diplomaReady = 1;
		}

		//alert($("#studentID").val() + "&item=" + ($("#memo").val()));
		$.post("diplomaControl.asp?op=updateGenerateApplyInfo&nodeID=" + nodeID + "&planID=" + $("#planID").val() + "&planQty=" + $("#planQty").val() + "&notes=" + escape($("#notes").val()) + "&teacher=" + $("#teacher").val() + "&classroom=" + escape($("#classroom").val()) + "&adviserID=" + $("#adviserID").val() + "&diplomaReady=" + diplomaReady + "&refID=" + $("#courseID").val() + "&host=" + $("#host").val() + "&keyID=" + $("#applyID").val() + "&fStart=" + $("#startDate").val()  + "&fEnd=" + $("#endDate").val()+ "&item=" + escape($("#title").val()) + "&address=" + escape($("#address").val()), {"memo":$("#memo").val(), "summary":$("#summary").val()},function(re){
			//alert(unescape(re));
			if(re>0){
				jAlert("保存成功");
				op = 0;
				updateCount = 1;
				getNodeInfo(re);
				nodeID = re;
			}else{
				jAlert("没有可供处理的数据。");
			}
		});
		return false;
	}

	function getApplyList(){
		var need = 0;
		var wait = 0;
		var upload = 0;
		var uploadPhoto = 0;
		var photo = 0;
		let drop = 0;
		if($("#showPhoto").checkbox("options").checked){
			photo = 1;
		}
		if($("#showWait").checkbox("options").checked){
			wait = 1;
		}
		if($("#showWaitUpload").checkbox("options").checked){
			upload = 1;
		}
		if($("#showWaitUploadPhoto").checkbox("options").checked){
			uploadPhoto = 1;
		}
		if($("#showDrop").checkbox("options").checked){
			drop = 1;
		}
		if($("#needResit").attr("checked")){ need = 1;}
		$.get("diplomaControl.asp?op=getApplyListByBatch&refID=" + nodeID + "&drop=" + drop + "&fromID=" + $("#fromID").val() + "&host=" + $("#partner").val() + "&status=" + $("#s_status").val() + "&keyID=" + $("#s_resit").val() + "&needResit=" + need + "&wait=" + wait + "&upload=" + upload + "&uploadPhoto=" + uploadPhoto + "&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#cover").empty();
			arr = [];		
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='cardTab' width='100%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='3%'>No</th>");
			arr.push("<th width='6%'>学号</th>");
			arr.push("<th width='10%'>身份证</th>");
			arr.push("<th width='6%'>姓名</th>");
			arr.push("<th width='8%'>单位</th>");
			arr.push("<th width='7%'>申报</th>");
			if(reexamine == 1){
				arr.push("<th width='5%'>照片</th>");
			}
			if(photo == 0){
				arr.push("<th width='6%'>来源</th>");
				arr.push("<th width='6%'>上传</th>");
				arr.push("<th width='12%'>考试时间</th>");
				arr.push("<th width='7%'>成绩</th>");
				arr.push("<th width='7%'>结果</th>");
			}else{
				arr.push("<th width='10%'>报名备注</th>");
				arr.push("<th width='6%'>照片</th>");
				arr.push("<th width='6%'>签名</th>");
				arr.push("<th width='6%'>证明</th>");
				arr.push("<th width='10%'>统一编码</th>");
			}
			arr.push("<th width='12%'>备注</th>");
			// arr.push("<th width='7%'>补考</th>");
			arr.push("<th width='10%'>复训日期</th>");
			arr.push("<th width='1%'>材</th>");
			arr.push("<th width='1%'></th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				var k = 0;
				var s = $("#status").val();
				let backcolor = ["#F0F0F0","#FFFF00","#00FF00","#FF8888"];
				let jobbc = ["#C5FFC5","#FFFFC5","#E5E5E5"];
				let jobtt = ["工作证明","社保","居住证"];
				let bc = "";
				let photo_size = 0;
				let photo_type = "jpg";
				$.each(ar,function(iNum,val){
					let ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='left'>" + ar1[22] + "</td>");
					arr.push("<td class='link1' " + (ar1[40]>"" && ar1[40]<addDays(currDate,90) ? "style='background:yellow;' title='注意身份证有效期'" : "") + "><a href='javascript:showEnterInfo(\"" + ar1[2] + "\",\"" + ar1[4] + "\",0,1);'>" + ar1[4] + "</a></td>");
					arr.push("<td class='link1'><a href='javascript:showStudentInfo(0,\"" + ar1[4] + "\",0,1);'>" + ar1[5] + "</a></td>");
					arr.push("<td class='left' title='" + ar1[13] + "." + ar1[14] + "'>" + ar1[13].substr(0,10) + "</td>");	//unit
					arr.push("<td class='left'>" + ar1[32] + "</td>");
					if(reexamine == 1){
						arr.push("<td class='left'>" + (ar1[31]==1?imgChk:'&nbsp;') + "</td>");	// 上传照片
					}
					if(photo == 0){
						arr.push("<td class='left'>" + ar1[41] + "</td>");	//source
						arr.push("<td class='left'>" + (ar1[30]==1?imgChk:'&nbsp;') + "</td>");	// 上传报名表
						arr.push("<td class='left'>" + ar1[18] + "</td>");
						h = ar1[19];
						if(agencyID == "1"){
							h = ar1[20].replace(".00","") + "/" + ar1[21].replace(".00","");
						}
						arr.push("<td class='left'>" + h + "</td>");
						arr.push("<td class='left'>" + ar1[9] + "</td>");
					}else{
						arr.push("<td class='left'>" + ar1[39] + "</td>");
						photo_type = ar1[34].substr(ar1[34].indexOf("."));
						photo_size = ar1[36];
						if(photo_size > 99 || (photo_type !== ".jpg" && photo_type !== ".jpeg")){	//根据照片类型或文件大小，显示不同背景颜色
							h = " style='background-color:#FFFFAA;'";
						}else{
							h = "";
						}
						if(ar1[34] > ""){	//照片
							arr.push("<td class='center'" + h + "><img id='photo" + ar1[4] + "' title='大小：" + photo_size + "k, 类型：" + photo_type + "' src='users" + ar1[34] + "?times=" + (new Date().getTime()) + "' onclick='showCropperInfo(\"users" + ar1[34] + "\",\"" + ar1[4] + "\",\"photo\",\"\",0,1)' style='width:50px;background: #ccc;border:2px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);'></td>");
						}else{
							arr.push("<td class='center'" + h + ">&nbsp;</td>");
						}
						if(ar1[35] > ""){	//签字
							arr.push("<td class='center'><img src='users" + ar1[35] + "?times=" + (new Date().getTime()) + "' style='width:60px;background: #ccc;border:2px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);'></td>");
						}else{
							arr.push("<td class='center'>&nbsp;</td>");
						}
						if(ar1[42] > "" || ar1[43] > "" || ar1[44] > ""){	//工作证明、社保证明、居住证三选一, 按顺序优先取前面文件
							let t = (ar1[42] > "" ? 0 : (ar1[43] > "" ? 1 : 2));
							arr.push("<td class='center' title='" + jobtt[t] + "' style='background-color:" + jobbc[t] + "'><img src='users" + (ar1[42] || ar1[43] || ar1[44]) + "?times=" + (new Date().getTime()) + "' style='width:60px;background: #ccc;border:2px #fff solid;box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-moz-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);-webkit-box-shadow: 0 0 1px rgba(0, 0, 0, 0.8);'></td>");
						}else{
							arr.push("<td class='center'>&nbsp;</td>");
						}
						arr.push("<td class='left'>" + ar1[45] + "</td>");	//tax
					}
					arr.push("<td class='link1'><a href='javascript:showMsg(\"" + ar1[33] + "\",\"历史数据\");'>" + ar1[10] + "</a></td>");	// 备注
					// if(ar1[7]>0){
					// 	arr.push("<td class='center'>" + imgChk + "</td>");	//补考
					// }else{
					// 	arr.push("<td class='center'>&nbsp;</td>");
					// }
					bc = "";
					if(ar1[28]==1 && ar1[29]<2){	//有复训日期且没有结束课程的
						if(ar1[27]>""){
							let x = dateDiff(ar1[27],(new Date().format("yyyy-MM-dd")));
							if(x<=30 && x>0){bc = backcolor[1]}
							if(x>30 && x <= 60){bc = backcolor[2]}
							if(x>60){bc = backcolor[3]}
						}
					}
					// arr.push("<td class='left'>" + ar1[27] + "</td>");
					arr.push("<td class='left' " + (ar1[28]==1 && bc>"" ? "style='background:" + bc + ";'" : "") + ">" + ar1[27] + "</td>");	// 复训日期
					if(s==0){
						k = ar1[0];
					}else{
						k = ar1[2];
					}
					if(ar1[25]==''){
						arr.push("<td class='center'></td>");
					}else{
						arr.push("<td class='center'><a href='javascript:void(0);' title='申报材料' onclick='showPic(\"" + ar1[25] + "\");' title='申报材料'>" + imgFile + "</a></td>");
					}
					arr.push("<td class='left'><input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + ar1[0] + "' name='visitstockchk'></td>");
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
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");
			arr.push("<th>&nbsp;</th>");					
			if(reexamine == 1){
				arr.push("<th>&nbsp;</th>");
			}
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#cover").html(arr.join(""));
			arr = [];
			$('#cardTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"aLengthMenu":[15,30,50,100,500],
				"iDisplayLength": 500,
				"bInfo": true,
				"aoColumnDefs": []
			});
		});
	}

	function generateMaterials(enterID,username,cert){
		clearTimeout(timer1);
		if(confirm("确定要生成报名材料吗？")){
			$.getJSON(uploadURL + "/outfiles/generate_emergency_materials?refID=" + username + "&nodeID=" + enterID + "&certID=" + cert + "&keyID=2" ,function(data){
				if(data>""){
					$("#material" + enterID).html("<a href='/users" + data + "?t=" + (new Date().getTime()) + "' target='_blank' title='申报材料'>" + imgFileRed + "</a>");
					alert("已生成文件");
				}else{
					alert("没有可供处理的数据。");
				}
			});
		}
	}

	function openMaterial(path){
		clearTimeout(timer1);
		timer1=setTimeout(function(){
			window.open(path);
		},300);
	}

	function generateZip(t){
		$.getJSON(uploadURL + "/outfiles/generate_material_zip?refID=" + nodeID + "&kind=apply&type=" + t, function(data){
			if(data>""){
				alert("已生成压缩包");
				getNodeInfo(nodeID);
			}else{
				alert("没有可供处理的数据。");
			}
		});
	}

	function generateEntryDoc(k){
		//k: 0 普通  1 带培训证明
		getSelCart("");
		if(selCount==0){
			$.messager.alert("提示","请选择要操作的名单。","info");
			return false;
		}
		if(confirm("确定要生成这" + selCount + "个报名表吗？")){
			$.post(uploadURL + "/outfiles/generate_emergency_exam_materials_byclass?refID=" + nodeID + "&keyID=5&registerID=" + currUser + "&kindID=" + k + "&host=" + currHost, {selList:selList}, function(data){
				if(data>"0"){
					$.messager.alert("提示","已生成" + data + "份文档","info");
					getApplyList();
				}else{
					$.messager.alert("提示","没有可供处理的数据。","info");
				}
			});
		}
	}

	function showPic(path){
		showImage(path,2.2,2.2,0,1);
	}
	
	function setButton(){
		var s = $("#status").val();
		$("#save").hide();
		$("#del").hide();
		$("#lock").hide();
		$("#close").hide();
		$("#open").hide();
		$("#doImportApply").hide();
		$("#doImportApplyResit").hide();
		$("#doImportScore").hide();
		$("#sendMsgExam").hide();
		$("#sendMsgScore").hide();
		$("#sendMsgDiploma").hide();
		$("#btnRemove").hide();
		$("#btnResit").hide();
		$("#btnSchedule").hide();
		$("#doApplyUploadSchedule").hide();
		$("#s_needResit").hide();
		$("#generateZip").hide();
		$("#generatePhotoZip").hide();
		$("#generateEntryZip").hide();
		$("#btnInvoiceGroup").hide();
		$("#item_btn1").hide();
		$("#item_btn2").hide();
		$("#btnArchive").hide();
		$("#btnSetSource").hide();
		if(currHost=="" && !checkRole("sniper")){
			$("#item_btn1").show();
			$("#item_btn2").show();
		}
			
		if(op==1){
			setEmpty();
			$("#save").show();
			//$("#save").focus();
		}else{
			if(checkPermission("studentAdd") && currHost==""){
				if(s==0){		//考前可以删除申报、调整人员
					$("#save").show();
					$("#del").show();
					$("#lock").show();
					$("#btnRemove").show();
					// if($("#title").val().indexOf("补考") > -1){		// 标题中含有补考字样的，可以导入补考名单。
					// 	$("#doImportApplyResit").show();
					// }
				}
				if(s==1){		//锁定后可以导入申报结果，发考试通知，上传成绩，发成绩通知，安排补考
					$("#save").show();
					$("#doImportApply").show();
					$("#sendMsgExam").show();
				}
				if(s==2){
					//结束后什么都不能做
					$("#sendMsgScore").show();
					$("#sendMsgDiploma").show();
					$("#btnResit").show();
					$("#s_needResit").show();
				}
				if(s<2){
					$("#close").show();
					$("#generateZip").show();
					$("#generatePhotoZip").show();
					$("#generateEntryZip").show();
					$("#btnSetSource").show();
				}
				$("#btnArchive").show();
			}
			if(checkPermission("scoreUpload") && s == 1){
				$("#doImportScore").show();
			}
			if(checkPermission("examOpen") && s > 0){
				$("#open").show();
			}
			if(checkPermission("applyEdit") && s < 2){
				if(agencyID==1){
					$("#doApplyEnter").show();	// 应急局项目可以自动报名
					$("#doApplyUpload").show();	// 
					$("#doApplyDownload").show();	// 
					$("#doApplyUploadSchedule").show();	// 
					if(reexamine==1){
						$("#doApplyUploadPhoto").show();	// 复训的可上传照片
					}
				}
				$("#btnSchedule").show();	// 
			}
			if(checkPermission("setInvoiceGroup") && s < 2){
				$("#btnInvoiceGroup").show();
			}
		}
	}
	
	function setEmpty(){
		//$("#title").val("中石化从业人员安全知识考核");
		$("#title").val("");
		$("#startDate").val(currDate);
		$("#qty").val(0);
		$("#planQty").val(0);
		$("#address").val("黄兴路158号D103三楼");
		$("#notes").val("上海市杨浦区黄兴路158号D");
		$("#host").val('znxf');
	}
	
	function getUpdateCount(){
		return updateCount;
	}
</script>

</head>

<body style="background:#f0f0f0;">
 <!--#include file='commFloatDetail.asp' -->
 <!--#include file='commLoadFileDetail.asp' -->

<div id='layout' align='left' style="background:#f0f0f0;">	
	
	<div style="width:100%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8;">
			<form id="detailCover" name="detailCover" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
			<table>
			<tr>
				<td align="right">培训日期</td>
				<td><input class="mustFill" type="text" id="startDate" size="9" />-<input class="mustFill" type="text" id="endDate" size="9" /></td>
				<td align="right">申报科目</td><input type="hidden" id="ID" /><input type="hidden" id="status" />
				<td><select id="courseID" style="width:100%;"></select></td><input type="hidden" id="courseName" /><input type="hidden" id="reexamineName" />
			</tr>
			<tr>
				<td align="right">申报标识</td>
				<td colspan="3">
					<input class="mustFill" type="text" id="title" style="width:55%;" />&nbsp;&nbsp;
					状态<input class="readOnly" type="text" id="statusName" size="5" readOnly="true" />&nbsp;&nbsp;
					属性<select id="host" style="width:60px;"></select>
				</td>
			</tr>
			<tr>
				<td align="right">开班编号</td>
				<td colspan="3">
					<input type="text" id="applyID" size="12" />&nbsp;&nbsp;
					计划编号&nbsp;<input type="text" id="planID" size="13" />&nbsp;&nbsp;
					<span id="list" style="margin-left:10px;"></span>
					<span id="proof" style="margin-left:2px;"></span>
					<span id="scoreResult" style="margin-left:10px;"></span>
					<span id="diplomaSign" style="margin-left:10px;"></span>
				</td>
			</tr>
			<tr>
				<td align="right">计划数量</td>
				<td colspan="3">
					<input type="text" id="planQty" size="5" />&nbsp;&nbsp;
					办学地点&nbsp;<input type="text" id="notes" size="40" />
				</td>
			</tr>
			<tr>
				<td align="right">打包文件</td>
				<td>
					<span id="zip" style="margin-left:10px;"></span>
					<span id="pzip" style="margin-left:10px;"></span>
					<span id="ezip" style="margin-left:10px;"></span>
				</td>
				<td align="right">考试地址</td>
				<td><input type="text" id="address" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="right">申报结果</td>
				<td colspan="2">
					人数：<span id="qty" style="margin-left:10px;"></span>
					待定：<span id="qtyNull" style="margin-left:10px;"></span>
					通过：<span id="qtyYes" style="margin-left:10px;"></span>
					未通过<span id="qtyNo" style="margin-left:10px;"></span>
				</td>
				<td><input style="border:0px;" type="checkbox" id="diplomaReady" value="" />&nbsp;证书已到</td>
			</tr>
			<tr>
				<td align="right">考试通知</td>
				<td>
					日期&nbsp;<input class="readOnly" type="text" id="sendDate" size="6" readOnly="true" />&nbsp;&nbsp;
					<input class="readOnly" type="text" id="senderName" size="5" readOnly="true" />
				</td>
				<td align="right">成绩通知</td>
				<td>
					日期&nbsp;<input class="readOnly" type="text" id="sendScoreDate" size="6" readOnly="true" />&nbsp;&nbsp;
					&nbsp;<input class="readOnly" type="text" id="senderScoreName" size="5" readOnly="true" />
				</td>
			</tr>
			<tr>
				<td align="right"><input class="button" type="button" id="btnSchedule" value="排课表" /></td>
				<td><input type="text" id="scheduleDate" size="12" class="readOnly" readOnly="true" />&nbsp;&nbsp;<span id="schedule" style="margin-left:10px; color:blue;"></span></td>
				<td colspan="2">
					上传课表日期&nbsp;<input type="text" id="uploadScheduleDate" size="12" class="readOnly" readOnly="true" />&nbsp;&nbsp;
					<span id="checkin" style="margin-left:10px; color:blue;">考勤</span>&nbsp;&nbsp;
					<span id="studyOnline" style="margin-left:10px; color:blue;">在线学习</span>
				</td>
			</tr>
			<tr>
				<td align="right">任课教师</td>
				<td colspan="3">
					<select id="teacher" style="width:65;"></select>
					&nbsp;&nbsp;教室&nbsp;<input type="text" id="classroom" style="width:150px;" />
					&nbsp;&nbsp;班主任&nbsp;<select id="adviserID" style="width:65px;"></select>
					&nbsp;&nbsp;<input class="button" type="button" id="btnArchive" value="班级档案" /><input class="readOnly" type="text" id="archiveDate" size="8" readOnly="true" /><input class="readOnly" type="text" id="archiverName" size="6" readOnly="true" />
				</td>
			</tr>
			<tr>
				<td align="right">
					工作小结
				</td>
				<td colspan="3"><textarea id="summary" style="padding:2px;width:100%;" rows="3"></textarea></td>
			</tr>
			<tr>
				<td align="right">备注</td>
				<td><input type="text" id="memo" style="width:95%;" /></td>
				<td align="right" colspan="2">
					制作日期&nbsp;<input class="readOnly" type="text" id="regDate" size="10" readOnly="true" />
					&nbsp;&nbsp;制作人&nbsp;<input class="readOnly" type="text" id="registerName" size="10" readOnly="true" />
				</td>
			</tr>
			</table>
			</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div id="item_btn1" class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
		<input class="button" type="button" id="save" value="保存" />&nbsp;
		<input class="button" type="button" id="del" value="删除" />&nbsp;
		<input class="button" type="button" id="doImportApply" value="考试安排导入" />&nbsp;
		<input class="button" type="button" id="sendMsgExam" value="考试通知" />&nbsp;
		<input class="button" type="button" id="doImportScore" value="成绩证书导入" />&nbsp;
		<input class="button" type="button" id="doImportApplyResit" value="补考名单导入" />&nbsp;
		<input class="button" type="button" id="sendMsgScore" value="成绩通知" />&nbsp;
		<input class="button" type="button" id="btnInvoiceGroup" value="团体发票" />&nbsp;
		<input class="button" type="button" id="generateClassDoc" value="生成归档文件" />&nbsp;
		<input class="button" type="button" id="generateEntryDoc" value="生成报名表" />&nbsp;
		<input class="button" type="button" id="generateEntryDoc1" value="生成报名表带培训证明" />&nbsp;
		<input class="button" type="button" id="btnProof" value="生成培训证明" />&nbsp;
		<input class="button" type="button" id="generateZip" value="生成归档压缩包" />&nbsp;
		<input class="button" type="button" id="generatePhotoZip" value="生成照片压缩包" />&nbsp;
		<input class="button" type="button" id="generateEntryZip" value="生成报名表压缩包" />&nbsp;
		<input class="button" type="button" id="lock" value="锁定" />&nbsp;
		<input class="button" type="button" id="close" value="结束" />&nbsp;
		<input class="button" type="button" id="open" value="开启" />&nbsp;
		<a href="output/申报结果模板.xlsx">考试安排模板</a>
  	</div>
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
	<div id="item_btn2" align="center" style="border:solid 1px #e0e0e0;width:99%;margin:5px;background:#ffffff;line-height:18px;">
		<a class="easyui-linkbutton" id="doApplyEnter" href="javascript:void(0)"></a>
		<a class="easyui-linkbutton" id="doApplyUpload" href="javascript:void(0)"></a>
		<a class="easyui-linkbutton" id="doApplyUploadPhoto" href="javascript:void(0)"></a>
		<a class="easyui-linkbutton" id="doApplyUploadSchedule" href="javascript:void(0)"></a>
		<a class="easyui-linkbutton" id="doApplyDownloadExamDate" href="javascript:void(0)"></a>
		<a class="easyui-linkbutton" id="doApplyDownload" href="javascript:void(0)"></a>
		&nbsp;&nbsp;<input class="easyui-checkbox" id="showPhoto" name="showPhoto" checked value="1"/>&nbsp;显示照片&nbsp;
		&nbsp;&nbsp;<input class="easyui-checkbox" id="showWait" name="showWait" value="1"/>&nbsp;未报名&nbsp;
		&nbsp;&nbsp;<input class="easyui-checkbox" id="showWaitUpload" name="showWaitUpload" value="1"/>&nbsp;未传材料&nbsp;
		&nbsp;&nbsp;<input class="easyui-checkbox" id="showWaitUploadPhoto" name="showWaitUploadPhoto" value="1"/>&nbsp;未传照片&nbsp;
		&nbsp;&nbsp;<input class="easyui-checkbox" id="showDrop" name="showDrop" value="1"/>&nbsp;已退课&nbsp;
	</div>
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
	<div style="width:100%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:5px;background:#ffffff;line-height:18px;padding-left:20px;">
			<span>申报结果&nbsp;<select id="s_status" style="width:70px"></select></span>
			<span>&nbsp;&nbsp;申请补考&nbsp;<select id="s_resit" style="width:70px"></select></span>
			<span>&nbsp;&nbsp;销售&nbsp;<select id="fromID" style="width:80px;"></select></span>
			<span>&nbsp;&nbsp;属性&nbsp;<select id="partner" style="width:70px"></select></span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnSearch" value="查找" /></span>
			<span id="s_needResit"><input style="border:0px;" type="checkbox" id="needResit" value="" />&nbsp;需补考&nbsp;</span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnSel" value="全选/取消" /></span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnRemove" value="移出名单" /></span>
            <span>&nbsp;&nbsp;<input class="button" type="button" id="btnResit" value="加入补考购物车" /></span>
            <span>&nbsp;&nbsp;<input class="button" type="button" id="sendMsgDiploma" value="领证通知" /></span>
            <span>&nbsp;&nbsp;<input class="button" type="button" id="btnSetSource" value="来源设置" /></span>
		</div>
	</div>
	<hr size="1" noshadow />
	<div id="cover" style="float:top;margin:3px;background:#f8fff8;">
	</div>
</div>
</body>
