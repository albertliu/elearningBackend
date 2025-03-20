<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">

<title></title>

<link href="css/style_inner1.css?v=1.0"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/data_table_mini.css?v=20150411" rel="stylesheet" type="text/css" />
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="css/jquery.autocomplete.css" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<script type='text/javascript' src='js/jquery.autocomplete.js'></script>
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var nodeID = "";
	var refID = "";
	var keyID = 0;
	var op = 0;
	var updateCount = 0;
	var lastone_item = new Array();
	var entryform = "";
	var refAlert = "";
	let uploadInvoice = 0;
	let invoicePDF = "";
	let ref_id = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";	//enterID
		refID = "<%=refID%>";	//username
		keyID = "<%=keyID%>";	//companyID
		op = "<%=op%>";

		getDicList("payKind","kindID",0);
		getDicList("payType","type",0);
		getDicList("statusPay","statusPay",0);
		getDicList("signatureType","signatureType",0);
		getDicList("payNow","payNow",0);
		getDicList("examResult","result",1);
        getComList("fromID","userInfo","username","realName","status=0 and username in(select username from roleUserList where roleID='saler') order by realName",1);
		getComList("host","hostInfo","hostNo","title","status=0 order by hostName",1);
		$("#datePay").click(function(){WdatePicker();});
		$("#dateRefund").click(function(){WdatePicker();});
		$("#dateInvoice").click(function(){WdatePicker();});
		$("#dateInvoicePick").click(function(){WdatePicker();});
		$("#currDiplomaDate").click(function(){WdatePicker();});
		$("#signatureDate").click(function(){WdatePicker();});
		$.ajaxSetup({ 
			async: false 
		}); 
		//alert(window.parent.lastone_item["price"]);
		if(op==1){
			var x = "dbo.getStudentProjectRestList('" + refID + "')";
			getComList("projectID",x,"projectID","projectName","1=1 order by projectID desc",1);
			//setClassList();
			setButton();
			$("#username").val(refID);
			var companyID = 0;
			lastone_item = getSession("lastone_item").split(",");
			//alert(lastone_item);
			$.each(lastone_item, function(i,val){
				var ar = new Array();
				ar = val.split("|");
				if(ar[0]=="companyID"){
					companyID = ar[1];
				}
				if(ar[0]=="projectID" && companyID==keyID){
					setClassList(ar[1]);
				}
				$("#" + ar[0]).val(ar[1]);
			});
			getStudentInfo();
		}else{
			getComList("projectID","projectInfo","projectID","projectName","status>0 order by projectID desc",1);
			getNodeInfo(nodeID);
		}

		$("#projectID").change(function(){
			if($("#projectID").val()>""){
				var id=$("#projectID").val();
				setClassList(id);
				$.get("projectControl.asp?op=getPrice&refID=" + id + "&keyID=" + $("#fromID").val() + "&times=" + (new Date().getTime()),function(re){
					var ar = re.split("|");
					$("#price").val(ar[0]);
					$("#kindID").val(ar[1]);
				});
			}
			
		});

		$("#fromID").change(function(){
			if($("#projectID").val()>""){
				var id=$("#projectID").val();
				$.get("projectControl.asp?op=getPrice&refID=" + id + "&keyID=" + $("#fromID").val() + "&times=" + (new Date().getTime()),function(re){
					var ar = re.split("|");
					$("#price").val(ar[0]);
					$("#kindID").val(ar[1]);
				});
			}
			
		});

		$("#save").click(function(){
			saveNode();
		});

		$("#btnEnter").click(function(){
			doEnter();
		});

		$("#reply").click(function(){
			showMessageInfo(0,0,1,0,$("#username").val());
		});

		$("#btnMaterials").click(function(){
			showMaterialsInfo(0,$("#username").val(),0,0);
		});

		$("#btnShowSignature").click(function(){
			showImage($("#signature").val(),0,0,0);
		});

		$("#btnEntryform").click(function(){
			generateEntryForm(0);
		});

		$("#btnFiremanMaterials").click(function(){
			generateFiremanMaterials();
		});

		$("#btnPrint").click(function(){
			printEntryform(1);
			//window.open("entryform_C13.asp?keyID=0&nodeID=" + nodeID + "&refID=" + refID, "_self");
		});

		$("#btnProof").click(function(){
			window.open("trainingProofPerson.asp?nodeID=" + nodeID + "&keyID=1&times=" + (new Date().getTime()), "_self");
		});

		$("#btnPreview").click(function(){
			printEntryform(0);
		});

		$("#kindID").change(function(){
			setButton();
		});

		$("#amount").change(function(){
			if(op==1){
				if($("#amount").val()>0 && $("#statusPay").val()==0){
					$("#statusPay").val(1);
				}
			}
			checkNum("amount");
		});

		$("#refund_amount").change(function(){
			checkNum("refund_amount");
		});

		$("#btnViewInvoice").click(function(){
			showPDF(invoicePDF,0,0,0);
		});

		$("#btnPay").click(function(){
			if($("#amount").val() > $("#price").val()){
				$.messager.alert("提示","付款金额大于应付金额。","warning");
				// return false;
			}

			jConfirm('确定要付款' + $("#amount").val() + '元吗?', '确认对话框', function(r) {
				if(r){
					$.get("studentCourseControl.asp?op=enterPay&nodeID=" + nodeID + "&amount=" + $("#amount").val() + "&kindID=" + $("#kindID").val() + "&refID=" + $("#type").val() + "&memo=" + escape($("#pay_memo").val()) + "&times=" + (new Date().getTime()),function(re){
						// alert(unescape(re))
						$.messager.alert("提示","操作成功。","info");
						updateCount += 1;
						getNodeInfo(nodeID);
					});
				}
			});
		});

		$("#btnRefund").click(function(){
			if($("#dateRefund").val() == ''){
				$.messager.alert("提示","请填写退款日期。","warning");
				return false;
			}
			if($("#refund_amount").val() == 0){
				$.messager.alert("提示","退款金额不能为0。","warning");
				return false;
			}
			jConfirm('确定要退款' + $("#refund_amount").val() + '元吗?', '确认对话框', function(r) {
				if(r){
					$.get("studentCourseControl.asp?op=enterRefund&nodeID=" + nodeID + "&amount=" + $("#refund_amount").val() + "&dateRefund=" + $("#dateRefund").val() + "&memo=" + escape($("#refund_memo").val()) + "&times=" + (new Date().getTime()),function(re){
						// alert(unescape(re))
						jAlert("操作成功。");
						updateCount += 1;
						getNodeInfo(nodeID);
					});
				}
			});
		});

		$("#btnMaterialCheck").click(function(){
			if($("#studentCourseID").val()>0){
				jConfirm('确定这个学员的报名材料齐全合规吗?', '确认对话框', function(r) {
					if(r){
						$.get("studentCourseControl.asp?op=doMaterial_check&nodeID=" + $("#studentCourseID").val() + "&times=" + (new Date().getTime()),function(re){
							jAlert("确认成功。");
							updateCount += 1;
							getNodeInfo($("#studentCourseID").val());
						});
					}
				});
			}else{
				jAlert("没有可操作的记录。");
			}
		});

		$("#btnDel").click(function(){
			jPrompt("请输入删除原因：","","输入窗口",function(x){
				if(x && x>""){
					jConfirm("确实要删除报名记录吗？", "确认对话框",function(r){
						if(r){
							$.get("studentCourseControl.asp?op=delNode&nodeID=" + $("#studentCourseID").val() + "&where=" + escape(x) + "&times=" + (new Date().getTime()),function(re){
								var ar = unescape(re).split("|");
								jAlert(ar[1]);
								if(ar[0]==0){
									updateCount += 1;
									op = 1;
									setButton();
								}
							});
						}
					});
				}
			});
		});

		$("#btnReturn").click(function(){
			jPrompt("请输入退课原因：","","输入窗口",function(x){
				if(x && x>""){
					jConfirm("确实要退课吗？", "确认对话框",function(r){
						if(r){
							$.get("studentCourseControl.asp?op=doReturn&nodeID=" + $("#studentCourseID").val() + "&where=" + escape(x) + "&times=" + (new Date().getTime()),function(re){
								var ar = unescape(re).split("|");
								jAlert(ar[1]);
								if(ar[0]==0){
									updateCount += 1;
									setButton();
								}
							});
						}
					});
				}
			});
		});

		$("#btnCloseStudentCourse").click(function(){
			jConfirm('确定要关闭这个学员的课程吗?', '确认对话框', function(r) {
				if(r){
					$.get("studentCourseControl.asp?op=closeStudentCourse&nodeID=" + $("#studentCourseID").val() + "&times=" + (new Date().getTime()),function(re){
						jAlert("关闭成功。");
						updateCount += 1;
						getNodeInfo($("#studentCourseID").val());
					});
				}
			});
		});

		$("#btnReviveStudentCourse").click(function(){
			jConfirm('确定要重启这个学员的课程吗?', '确认对话框', function(r) {
				if(r){
					$.get("studentCourseControl.asp?op=reviveStudentCourse&nodeID=" + $("#studentCourseID").val() + "&times=" + (new Date().getTime()),function(re){
						jAlert("重启成功。");
						updateCount += 1;
						getNodeInfo($("#studentCourseID").val());
					});
				}
			});
		});

		$("#btnRebuildStudentLesson").click(function(){
			jConfirm('确定要刷新这个学员的课表和模拟练习吗?', '确认对话框', function(r) {
				if(r){
					$.get("studentCourseControl.asp?op=rebuildStudentLesson&nodeID=" + $("#studentCourseID").val() + "&times=" + (new Date().getTime()),function(re){
						jAlert("刷新成功。");
						//updateCount += 1;
						//getNodeInfo($("#studentCourseID").val());
					});
				}
			});
		});

		$("#btnReInvoice").click(function(){
			jConfirm('确定要对当前发票进行红冲吗?', '确认对话框', function(r) {
				if(r){
					$.get("studentCourseControl.asp?op=removeInvoice&refID=0&nodeID=" + $("#studentCourseID").val() + "&times=" + (new Date().getTime()),function(re){
						jAlert("已移除原发票，请上传新发票。");
						getNodeInfo(nodeID)
					});
				}
			});
		});

		$("#btnReInvoice1").click(function(){
			jConfirm('确定要重开发票吗?', '确认对话框', function(r) {
				if(r){
					$.get("studentCourseControl.asp?op=removeInvoice&refID=1&nodeID=" + $("#studentCourseID").val() + "&times=" + (new Date().getTime()),function(re){
						jAlert("已移除原发票，请上传新发票。");
						getNodeInfo(nodeID)
					});
				}
			});
		});
		$("#smsList").click(function(){
			//alert($("#username").val() + ":" + $("#studentCourseID").val());
			showStudentSmsList($("#username").val(),$("#studentCourseID").val(),0,1);
		});
		$("#examList").click(function(){
			showStudentExamList($("#username").val(),$("#name").val(),0,1);
		});
		$("#opList").click(function(){
			showStudentOpList($("#studentCourseID").val(),0,0,1);
		});
		$("#btnReGetStudent").click(function(){
			getStudentInfo();
		});
		$("#btnUploadInvoice").click(function(){
			showLoadFile("invoice_pdf",nodeID,"invoice_pdf",$("#host").val());
			uploadInvoice = 1;
		});

		$("#btnShowCompletion").click(function(){
			showCompletionList(nodeID,0,0,0);
		});

		$("#btnShowEnterCheckin").click(function(){
			showEnterCheckin(nodeID,0,0,0);
		});

		$("#btnCheckPass").click(function(){
			jConfirm('确定要设置/取消免签吗?', '确认对话框', function(r) {
				if(r){
					$.get("studentCourseControl.asp?op=setCheckPass&nodeID=" + nodeID + "&times=" + (new Date().getTime()),function(re){
						// alert(unescape(re))
						$.messager.alert("提示","操作成功。","info");
						updateCount += 1;
						getNodeInfo(nodeID);
					});
				}
			});
		});

		$("#btnGenSignForm").click(function(){
			generateEntryFormSign();
			jAlert("已生成新的协议");
		});

		$("#btnGetNewReceipt").click(function(){
			let re = getDicItem('0','receipt');
			$("#receipt").val(parseInt(re) + 1);
		});

		$("#btnSaveScore").click(function(){
			$.get("studentCourseControl.asp?op=saveExamScore&refID=" + ref_id + "&score=" + $("#score").val() + "&score2=" + $("#score2").val() + "&result=" + $("#result").val() + "&times=" + (new Date().getTime()),function(re){
				// alert(unescape(re))
				$.messager.alert("提示","保存成功。","info");
				getNodeInfo(nodeID);
			});
		});

	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		$.get("studentCourseControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			// jAlert(unescape(re));
			var ar = new Array();
			var c = "";
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#studentCourseID").val(ar[0]);
				$("#username").val(ar[1]);
				$("#name").val(ar[2]);
				$("#status").val(ar[3]);
				$("#statusName").val(ar[4]);
				$("#courseName").val(ar[6]);
				$("#regDate").val(ar[11]);
				if(ar[39]!="spc" && ar[39]!="shm"){	//非集团客户，显示自己的单位和部门
					$("#hostName").val(ar[37]);
					$("#dept1Name").val(ar[38]);
					$("#dept2Name").val("");
				}else{
					$("#hostName").val(ar[12]);
					$("#dept1Name").val(ar[13]);
					$("#dept2Name").val(ar[14]);
				}
				$("#memo").val(ar[16]);
				$("#mobile").val(ar[17]);
				$("#startDate").val(ar[19]);
				$("#endDate").val(ar[20]);
				$("#SNo").val(ar[25]);
				$("#checkDate").val(ar[31]);
				$("#checkerName").val(ar[32]);
				$("#projectID").val(ar[26]);
				setClassList(ar[26]);
				if(ar[23]==1){
					$("#checked").prop("checked",true);
				}else{
					$("#checked").prop("checked",false);
				}
				if(ar[28]==1){
					$("#materialCheck").prop("checked",true);
				}else{
					$("#materialCheck").prop("checked",false);
				}

				$("#materialCheckerName").val(ar[30]);
				$("#projectName").val(ar[33] + ar[26]);
				$("#classID").val(ar[27]);
				$("#className").val(ar[34]);
				$("#certID").val(ar[36]);
				$("#host").val(ar[39]);
				$("#reexamineName").val(ar[41]);
				$("#submiterName").val(ar[44]);
				$("#currDiplomaID").val(ar[45]);
				$("#currDiplomaDate").val(ar[46]);
				$("#fromID").val(ar[47]);
				$("#signature").val(ar[48]);
				$("#signatureDate").val(ar[49]);
				$("#signatureType").val(ar[52]);
				$("#payNow").val(ar[59]);
				$("#title").val(ar[60]);
				$("#price").val(ar[62]);
				$("#amount").val(ar[63]);
				$("#kindID").val(ar[64]);
				$("#type").val(ar[65]);
				$("#datePay").val(ar[66]);
				$("#invoice").val(ar[67]);
				$("#dateInvoice").val(ar[68]);
				$("#dateInvoicePick").val(ar[69]);
				$("#dateRefund").val(ar[70]);
				$("#pay_memo").val(ar[74]);
				$("#statusPay").val(ar[75]);
				$("#refunderName").val(ar[79]);
				$("#refund_amount").val(ar[80]);
				$("#refund_memo").val(ar[81]);
				$("#file5").val(ar[84]);
				$("#pay_checkerName").val(ar[85]);
				$("#completionPass").val(ar[86]);
				$("#completion").val(ar[10]);
				$("#invoice_amount").val(ar[90]);
				$("#receipt").val(ar[92]);
				$("#score").val(nullNoDisp(ar[93]));
				$("#score2").val(nullNoDisp(ar[94]));
				$("#result").val(ar[95]);
				ref_id = ar[96];
				// let c = $("#certID").val();
				// if(c == "C21" || c == "C20A"){
				// 	c = "C20";
				// }
				// if(c == "C30" || c == "C31" || c == "C32" || c == "C35" || c == "C18" || c == "C19" || c == "C36" || c == "C37" || c == "C22" || c == "C23"){
				// 	c = "C2";
				// }
				// if(c == "C24" || c == "C25" || c == "C26" || c == "C25B" || c == "C26B" || c == "C14" || c == "C15" || c == "C27" || c == "C27B"){
				// 	c = "C12";
				// }
				// if(c == "C17"){
				// 	c = "C16";
				// }
				$("#examTimes").html("&nbsp;<a style='text-decoration: none;' href='javascript:showExamList(" + ar[0] + ",\"" + ar[2] + "\");'>" + ar[42] + "次</a>");
				entryform = ar[35];
				invoicePDF = ar[89];
				if(ar[48]>""){
					$("#signatureStatus").prop("checked",true);
				}else{
					$("#signatureStatus").prop("checked",false);
				}
				if(ar[48]>""){
					$("#btnShowSignature").prop("disabled",false);
				}else{
					$("#btnShowSignature").prop("disabled",true);
				}
				if(ar[57]==1){
					$("#overdue").prop("checked",true);
				}else{
					$("#overdue").prop("checked",false);
				}
				if(ar[58]==1){
					$("#express").prop("checked",true);
				}else{
					$("#express").prop("checked",false);
				}
				if(ar[61]==1){
					$("#needInvoice").prop("checked",true);
				}else{
					$("#needInvoice").prop("checked",false);
				}
				if(ar[88]==1){
					$("#noReceive").html("未到账");
				}else if(ar[88]==2){
					$("#noReceive").html("已到账");
				}else{
					$("#noReceive").html("");
				}


				// getPayDetailInfoByEnterID(ar[0]);
				if(ar[27]=="" && ar[26]>""){
					getComList("classID","[dbo].[getClassListByProject]('" + ar[26] + "')","classID","classIDName"," status=0 order by batchID desc",1);
				}

				setButton();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function saveNode(){
		doEnter();
	}
	
	function doEnter(){
		if($("#projectID").val() == "" || $("#projectID").val() == null){
			jAlert("请选择招生项目。");
			return false;
		}
		if($("#classID").val() == "" || $("#classID").val() == null){
			jAlert("请选择班级。");
			return false;
		}
		lastone_item = [];
		lastone_item.push("companyID|" + keyID);
		lastone_item.push("projectID|" + $("#projectID").val());
		lastone_item.push("price|" + $("#price").val());
		lastone_item.push("kindID|" + $("#kindID").val());
		lastone_item.push("classID|" + $("#classID").val());
		setSession("lastone_item", lastone_item.join(","));

		if($("#classID").val()>""){
			let over = 0;
			let express = 0;
			if($("#overdue").prop("checked")){
				over = 1;
			}
			if($("#express").prop("checked")){
				express = 1;
			}
			let needInvoice = 0;
			if($("#needInvoice").prop("checked")){
				needInvoice = 1;
				if($("#invoice_amount").val() == "" || $("#invoice_amount").val() == 0 || !check_str(7,$("#invoice_amount").val())){
					jAlert("请正确填写发票金额。");
					return false;
				}
				if($("#title").val() == ""){
					jAlert("请填写开票信息。");
					return false;
				}
			}
			
			//@username,@classID,@price,@invoice,@projectID,@kindID,@type,@status,@datePay varchar(50),@dateInvoice varchar(50),@dateInvoicePick varchar(50),@memo,@registerID
			$.get("studentCourseControl.asp?op=doEnter&nodeID=" + nodeID + "&username=" + $("#username").val() + "&classID=" + $("#classID").val() + "&overdue=" + over + "&express=" + express + "&needInvoice=" + needInvoice + "&host=" + $("#host").val() + "&fromID=" + $("#fromID").val() + "&price=" + $("#price").val() + "&amount=" + $("#amount").val() + "&invoice=" + $("#invoice").val() + "&receipt=" + $("#receipt").val() + "&invoice_amount=" + $("#invoice_amount").val() + "&projectID=" + $("#projectID").val() + "&item=" + escape($("#title").val()) + "&payNow=" + $("#payNow").val() + "&kindID=" + $("#kindID").val() + "&type=" + $("#type").val() + "&status=" + $("#statusPay").val() + "&datePay=" + $("#datePay").val() + "&dateInvoice=" + $("#dateInvoice").val() + "&dateInvoicePick=" + $("#dateInvoicePick").val() + "&currDiplomaID=" + $("#currDiplomaID").val() + "&currDiplomaDate=" + $("#currDiplomaDate").val() + "&pay_memo=" + escape($("#pay_memo").val()) + "&memo=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
				//jAlert(unescape(re));
				let ar = new Array();
				ar = unescape(re).split("|");
				if(ar[0] == 0){
					updateCount += 1;
					// getPayInfo(ar[2]);
					nodeID = ar[3];
					getNodeInfo(nodeID);
					if(op == 1){
						generateEntryForm(1);
						generateEntryFormSign();	//生成签名时显示的报名表
					}
					op = 0;
				}
				jAlert(ar[1],"信息提示");
			});
		}
		// return false;
	}
	
	function setClassList(id){
		$("#classID").empty();
		if(op==1){
			getComList("classID","[dbo].[getClassListByProject]('" + id + "')","classID","classIDName"," status<2 order by pre desc, batchID desc",1);
		}else{
			getComList("classID","[dbo].[getClassListByProject]('" + id + "')","classID","classIDName"," 1=1 order by pre desc, batchID desc",1);
		}
	}
	
	function getStudentInfo(){
		$.get("studentControl.asp?op=getNodeInfo&nodeID=0&refID=" + refID + "&times=" + (new Date().getTime()),function(re){
			//alert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#name").val(ar[2]);
				if(ar[29] == "spc"){
					// 石化公司员工自动填充开票信息
					$.get("studentControl.asp?op=getDeptPayTitle&refID=" + ar[27] + "&times=" + (new Date().getTime()),function(re1){
						//alert(unescape(re));
						var ar1 = new Array();
						ar1 = unescape(re1).split("|");
						if(ar1 > ""){
							$("#payNow").val(ar1[0]);
							$("#title").val(ar1[1]);
						}else{
							alert("加油站信息缺失，请检查。")
						}
					});
				}
			}
		});
	}
	
	function generateEntryForm(i){
		window.open("entryform_" + entryform + ".asp?nodeID=" + nodeID + "&refID=" + refID + "&keyID=1" + "&times=" + (new Date().getTime()), "_self");
	}
	
	function generateFiremanMaterials(){
		$.getJSON(uploadURL + "/outfiles/generate_fireman_materials?username=" + $("#username").val() + "&enterID=" + $("#studentCourseID").val() + "&registerID=" + currUser ,function(data){
			if(data>""){
				if(i==0){
					asyncbox.alert("已生成 <a href='users" + data + "' target='_blank'>下载文件</a>",'操作成功',function(action){
					　　//alert 返回action 值，分别是 'ok'、'close'。
					　　if(action == 'ok'){
					　　}
					　　if(action == 'close'){
					　　　　//alert('close');
					　　}
					});
				}
				//getNodeInfo(nodeID);
			}else{
				alert("没有可供处理的数据。");
			}
		});
	}

	function generateEntryFormSign(){
		$.getJSON(uploadURL + "/outfiles/generate_entryform_sign?refID=" + refID + "&status=0&nodeID=" + nodeID + "&entryform=" + entryform + "&host=" + currHost ,function(data){
			// no action
		});
	}
	
	function printEntryform(k){
		window.open("entryform_" + entryform + ".asp?keyID=" + k + "&status=0&nodeID=" + nodeID + "&refID=" + refID + "&kindID=" + $("#certID").val() + "&times=" + (new Date().getTime()), "_self");
	}
	
	function setButton(){
		$("#save").hide();
		//$("#new").hide();
		$("#btnEnter").hide();
		$("#btnReturn").hide();
		$("#btnRefund").hide();
		$("#btnMaterialCheck").hide();
		$("#reply").hide();
		$("#btnPay").hide();
		$("#btnDel").hide();
		$("#btnEntryform").hide();
		$("#btnFiremanMaterials").hide();
		$("#btnCloseStudentCourse").hide();
		$("#btnReviveStudentCourse").hide();
		$("#btnPrint").hide();
		$("#btnRebuildStudentLesson").hide();
		$("#btnSaveScore").hide();
		$("#amount").prop("readonly",false);
		// $("#btnViewInvoice").prop("disabled",true);
		$("#check_pass").checkbox({readonly:true});
		$("#fromID").prop("readonly",true);
		if($("#statusPay").val()==0 && $("#kindID").val()==0 && checkPermission("studentAdd")){
			//未支付的个人付款可以支付，团体付款应到发票管理中操作。
			$("#btnPay").show();
		}
		if(op==1){
			//新增报名：显示报名选项、报名按钮
			//$("#new").show();
			$("#btnEnter").show();
			$("#project0").hide();
			$("#project1").show();
			$("#class0").hide();
			$("#class1").show();
			setEmpty();
			$("#btnEnter").focus();
		}else{
			if($("#statusPay").val()==1){
				//未支付的个人付款可以支付，团体付款应到发票管理中操作。
				$("#amount").prop("readonly",true);
				$("#btnRefund").show();
				if(!checkPermission("editPayDate")){
					$("#datePay").prop("readonly",true);
				}
			}
			if(!checkPermission("invoiceUpload")){
				$("#btnUploadInvoice").prop("disabled",true);
			}
			if(checkPermission("invoiceRe") && $("#invoice").val()>""){
				$("#btnReInvoice").prop("disabled",false);
				$("#btnReInvoice1").prop("disabled",false);
			}else{
				$("#btnReInvoice").prop("disabled",true);
				$("#btnReInvoice1").prop("disabled",true);
			}
			if((checkPermission("invoiceRe") || checkPermission("studentAdd") || checkPermission("invoiceUpload")) && $("#invoice").val()==""){
				$("#invoice_amount").prop("disabled",false);
				$("#title").prop("disabled",false);
				$("#dateInvoice").prop("disabled",false);
				$("#invoice").prop("disabled",false);
			}else{
				if(!checkPermission("editPayDate")){
					$("#invoice_amount").prop("disabled",true);
					$("#title").prop("disabled",true);
					$("#dateInvoice").prop("disabled",true);
					$("#invoice").prop("disabled",true);
				}
			}

			// if($("#file5").val()>""){
			// 	$("#btnViewInvoice").prop("disabled",false);
			// }

			if(checkPermission("studentAdd") || checkPermission("editPayDate")){
				//编辑状态：显示保存按钮；一定条件下可以退学、退款
				$("#save").show();
				if(!checkRole("partner")){
					if($("#status").val() < 2){
						$("#btnReturn").show();
						$("#btnRefund").show();
						$("#btnCloseStudentCourse").show();
						// $("#btnReviveStudentCourse").show();
						$("#btnRebuildStudentLesson").show();
						// $("#btnReviveStudentCourse").hide();
						$("#signatureDate").prop("readonly",false);
						if(!$("#materialCheck").attr("checked")){
							$("#btnMaterialCheck").show();
						}
					}else{
						$("#btnReturn").hide();
						$("#btnRefund").hide();
						$("#btnCloseStudentCourse").hide();
						// $("#btnReviveStudentCourse").hide();
					}
				}
			}
			if(checkPermission("reviveStudentCourse")){
				$("#btnReviveStudentCourse").show();
			}
            //if(checkPermission("studentDel") && ($("#className").val()=="" || dateDiff(currDate, $("#regDate").val())<180) && $("#statusPay").val()==0 && $("#invoice").val()=="" && $("#dateInvoicePick").val()=="" || $("#name").val().indexOf("测试")>-1){
            if(checkPermission("studentDel") && ($("#className").val()=="" || dateDiff(currDate, $("#regDate").val())<720) || $("#name").val().indexOf("测试")>-1){
                //未支付未开票的可以删除。
                $("#btnDel").show();
            }
			$("#project0").show();
			$("#project1").hide();
			$("#class0").hide();
			//$("#class1").hide();
			//$("#reply").show();
			//$("#btnEntryform").show();
			//$("#btnFiremanMaterials").show();
			$("#btnPrint").show();
			if(checkPermission("salesChange")){
				$("#fromID").prop("readonly",false);
			}
			let certID = $("#certID").val();
			if(checkPermission("firemanScore") && (certID=="C20" || certID=="C20A" || certID=="C21")){
				$("#btnSaveScore").show();
			}
		}
	}
	function setEmpty(){
		$("#SNo").val("");
		$("#signatureType").val(1);
		$("#refund_amount").val(0);
		$("#amount").val(0);
		$("#price").val(0);
		$("#statusPay").val(0);
		$("#invoice").val("");
		nodeID = 0;
		if($("#kindID").val()==0){
			//个人缴费
			// $("#statusPay").val(1);
			$("#datePay").val("");
			$("#dateInvoice").val("");
			$("#dateInvoicePick").val("");
			//$("#invoice").val(parseInt(getDicItem(0,"invoiceNo")) + 1);
		}
		if($("#kindID").val()==1){
			//团体缴费
			// $("#statusPay").val(1);
			$("#datePay").val("");
			$("#dateInvoice").val("");
			$("#dateInvoicePick").val("");
		}
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
			<form id="detailCover" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
			<table>
			<tr>
				<td align="right">姓名</td><input type="hidden" id="studentCourseID" /><input type="hidden" id="certID" /><input type="hidden" id="status" />
				<td><input class="readOnly" type="text" id="name" size="25" readOnly="true" /></td>
				<td align="right">身份证</td>
				<td><input class="readOnly" type="text" id="username" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">课程名称</td>
				<td><input class="readOnly" type="text" id="courseName" size="25" readOnly="true" /></td>
				<td align="right">公司名称</td>
				<td><input class="readOnly" type="text" id="hostName" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">一级部门</td>
				<td><input class="readOnly" type="text" id="dept1Name" size="25" readOnly="true" /></td>
				<td align="right">二级部门</td>
				<td><input class="readOnly" type="text" id="dept2Name" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">公司确认</td>
				<td><input style="border:0px;" type="checkbox" id="checked" value="" />&nbsp;&nbsp;<input class="readOnly" type="text" id="checkerName" size="5" readOnly="true" /><input class="readOnly" type="text" id="checkDate" size="10" readOnly="true" /></td>
				<td align="right">来源</td>
				<td><select id="host" style="width:180px;"></select></td>
			</tr>
			<tr>
				<td align="right">开课日期</td>
				<td><input class="readOnly" type="text" id="startDate" size="25" readOnly="true" /></td>
				<td align="right">结束日期</td>
				<td><input class="readOnly" type="text" id="endDate" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">手机</td>
				<td><input class="readOnly" type="text" id="mobile" size="25" readOnly="true" /></td>
				<td align="right">资料确认</td>
				<td><input style="border:0px;" type="checkbox" id="materialCheck" value="" />&nbsp;&nbsp;<input class="readOnly" type="text" id="materialCheckerName" size="5" readOnly="true" />&nbsp;&nbsp;<input class="button" type="button" id="btnMaterials" value="查看材料" /></td>
			</tr>
			<tr>
				<td align="right">签名类型</td>
				<td colspan="3"><input type="hidden" id="signature" />
					<select id="signatureType" style="width:60px;"></select>&nbsp;&nbsp;
					已签名<input style="border:0px;" type="checkbox" id="signatureStatus" value="" />&nbsp;&nbsp;
					签名日期<input class="readOnly" type="text" id="signatureDate" size="15" readOnly="true" />&nbsp;&nbsp;
					<input class="button" type="button" id="btnShowSignature" value="查看签名" />
					<input class="button" type="button" id="btnGenSignForm" value="生成协议" />
				</td>
			</tr>
			<tr>
				<td align="right">报名状态</td>
				<td><input class="readOnly" type="text" id="statusName" size="25" readOnly="true" /></td>
				<td align="right">报名日期</td>
				<td><input class="readOnly" type="text" id="regDate" size="25" readOnly="true" /></td>
			</tr>
			</table>
			</form>

			<div style="width:100%;float:left;margin:10;height:4px;"></div>
			<div id="new" style="width:100%;margin:0; padding-left:12px; padding-top:5px;background:#fff8f8;">
				<div>
					<span id="project1">招生批次&nbsp;<select id="projectID" style="width:250px"></select>&nbsp;&nbsp;</span>
					<span id="project0">招生批次&nbsp;<input class="readOnly" type="text" id="projectName" style="width:250px" readOnly="true" />&nbsp;&nbsp;</span>
					类别&nbsp;<input class="readOnly" type="text" id="reexamineName" style="width:50px" readOnly="true" />&nbsp;&nbsp;<input type="checkbox" id="overdue" />复审过期
					<br>
					<span id="class1">所属班级&nbsp;<select id="classID" style="width:250px"></select>&nbsp;&nbsp;</span>
					<span id="class0">所属班级&nbsp;<input class="readOnly" type="text" id="className" style="width:250px" readOnly="true" />&nbsp;&nbsp;经办人&nbsp;<input class="readOnly" type="text" id="submiterName" style="width:50px" readOnly="true" />&nbsp;&nbsp;</span>
					编号&nbsp;<input type="text" id="SNo" style="width:70px" />&nbsp;&nbsp;<input type="checkbox" id="express" />延期换证
					<div>
						<form style="width:99%;float:right;margin:1px;padding-left:2px;background:#f8f8ee;">
						<table>
						<tr>
							<td align="right">在线进度</td>
							<td colspan="3">
								<input id="completion" name="completion" class="readOnly" size="4" readOnly="true" />&nbsp;%
								&nbsp;<input class="button" type="button" id="btnShowCompletion" value="在线考勤" />
								&nbsp;<input class="button" type="button" id="btnShowEnterCheckin" value="线下考勤" />
								&nbsp;<input class="button" type="button" id="btnProof" value="培训证明" />
								&nbsp;&nbsp;<input class="easyui-checkbox" id="check_pass" name="check_pass" value="1" />
								&nbsp;<input class="button" type="button" id="btnCheckPass" value="免签" />
								&nbsp;&nbsp;模拟练习&nbsp;<span id="examTimes"></span>
							</td>
						</tr>
						<tr>
							<td align="right">初训证书编号</td>
							<td><input type="text" id="currDiplomaID" style="width:140px;" /></td>
							<td align="right">应复训日期</td>
							<td><input type="text" id="currDiplomaDate" style="width:80px;" />&nbsp;销售<select id="fromID" style="width:80px;"></select></td>
						</tr>
						<tr>
							<td align="right">备注</td>
							<td colspan="3"><input type="text" id="memo" style="width:100%;" /></td>
						</tr>
						</table>
						</form>
					</div>
					<div>
						<span>
							<input class="button" type="button" id="btnEntryform" value="生成" />
							<input class="button" type="button" id="save" value="保存" />
							<input class="button" type="button" id="btnPreview" value="预览" />
							<input class="button" type="button" id="btnPrint" value="打印" />
							<input class="button" type="button" id="btnFiremanMaterials" value="消防员" />
						</span>
						<span style="padding-left:50px;">
							成绩：<select id="result" style="width:70px;"></select>
							&nbsp;&nbsp;应知<input type="text" id="score" style="width:50px;" />
							&nbsp;&nbsp;应会<input type="text" id="score2" style="width:50px;" />
							&nbsp;&nbsp;<input class="button" type="button" id="btnSaveScore" value="ok" />
						</span>
					</div>
				</div>
			</div>

			<div style="width:100%;float:left;margin:10;height:4px;"></div>
			<form id="payCover" style="width:98%;float:right;margin:1px;padding-left:2px;background:#f8f8ee;">
			<table>
			<tr>
				<td align="right">票据类型</td>
				<td colspan="3"><select id="kindID" style="width:100px;"></select>
					&nbsp;&nbsp;应付金额
					<input type="text" id="price" style="width:50px;" />
					&nbsp;&nbsp;实付金额
					<input type="text" id="amount" style="width:50px;" />
					&nbsp;&nbsp;<input class="button" type="button" id="btnPay" value="付款" />
					&nbsp;&nbsp;<input class="button" type="button" id="btnGetNewReceipt" value="收据" />
					<input type="text" id="receipt" style="width:80px;" />
				</td>
			</tr>
			<tr>
				<td align="right">支付方式</td>
				<td>
					<select id="type" style="width:80px;"></select>
					&nbsp;&nbsp;状态&nbsp;
					<select id="statusPay" style="width:55px;"></select>
					<span id="noReceive" style="color:red;"></span>
				</td>
				<td align="right">付款类型</td>
				<td><select id="payNow" style="width:100px;"></select>&nbsp;<input class="button" type="button" id="btnReGetStudent" value="刷新" /></td>
			</tr>
			<tr>
				<td align="right">付款说明</td>
				<td><input type="text" id="pay_memo" style="width:95%;" /></td>
				<td align="right">付款日期</td>
				<td><input type="text" id="datePay" style="width:80px;" />&nbsp;&nbsp;经办<input class="readOnly" type="text" id="pay_checkerName" style="width:60px;" readOnly="true" /></td>
			</tr>
			<tr>
				<td colspan="4">
					<input type="checkbox" id="needInvoice" />&nbsp;需开票<input type="hidden" id="file5" name="file5" />
					&nbsp;<input class="button" type="button" id="btnUploadInvoice" value="上传发票" />
					&nbsp;<input class="button" type="button" id="btnReInvoice" value="红冲" />
					&nbsp;<input class="button" type="button" id="btnReInvoice1" value="重开发票" />
					&nbsp;&nbsp;发票号码&nbsp;<input type="text" id="invoice" style="width:154px; background:lightgreen;" />
					&nbsp;&nbsp;开票日期&nbsp;<input type="text" id="dateInvoice" style="width:70px; background:lightgreen;" />
				</td>
			</tr>
			<tr>
				<td align="right">开票信息</td>
				<td colspan="3">
					<input type="text" id="title" style="width:400px; background:yellow;" />
					&nbsp;&nbsp;开票金额&nbsp;<input type="text" id="invoice_amount" style="width:50px; background:yellow;" />红冲为负
				</td>
			</tr>
			<tr>
			</tr>
			<tr>
				<td colspan="2">
					<input class="button" type="button" id="btnViewInvoice" value="查看发票" />
					&nbsp;&nbsp;取票日期&nbsp;<input type="text" id="dateInvoicePick" size="10" />
				</td>
				<td align="right">退款金额</td>
				<td>
				<input type="text" id="refund_amount" style="width:50px; background:lightPink;" />
				&nbsp;&nbsp;<input class="button" type="button" id="btnRefund" value="退款" />
			</tr>
			<tr>
				<td align="right">退款说明</td>
				<td><input type="text" id="refund_memo" style="width:95%;" /></td>
				</td>
				<td align="right">退款日期</td>
				<td><input type="text" id="dateRefund" style="width:80px; background:lightPink;" />&nbsp;&nbsp;经办<input class="readOnly" type="text" id="refunderName" style="width:60px;" readOnly="true" /></td>
			</tr>
			</table>
			</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
		<input class="button" type="button" id="reply" value="发通知" />&nbsp;
		<input class="button" type="button" id="btnEnter" value="报名" />&nbsp;
		<input class="button" type="button" id="btnMaterialCheck" value="资料确认" />&nbsp;
		<input class="button" type="button" id="btnReturn" value="退课" />&nbsp;
		<input class="button" type="button" id="btnDel" value="删除" />&nbsp;
		<input class="button" type="button" id="btnCloseStudentCourse" value="关闭课程学习" />&nbsp;
		<input class="button" type="button" id="btnReviveStudentCourse" value="重启课程学习" />&nbsp;
		<input class="button" type="button" id="btnRebuildStudentLesson" value="刷新课表" />&nbsp;
		<input class="button" type="button" id="smsList" value="查看通知" />&nbsp;
		<input class="button" type="button" id="opList" value="查看操作" />&nbsp;
		<input class="button" type="button" id="examList" value="查看考试信息" />
  	</div>
</div>
</body>
