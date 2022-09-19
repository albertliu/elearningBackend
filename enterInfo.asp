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
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";	//enterID
		refID = "<%=refID%>";	//username
		keyID = "<%=keyID%>";	//companyID
		op = "<%=op%>";

		getDicList("payKind","kindID",0);
		getDicList("payType","type",0);
		getDicList("statusPay","statusPay",0);
        getComList("fromID","userInfo","username","realName","status=0 and username in(select username from roleUserList where roleID='saler') order by realName",1);
		$("#datePay").click(function(){WdatePicker();});
		$("#dateRefund").click(function(){WdatePicker();});
		$("#dateInvoice").click(function(){WdatePicker();});
		$("#dateInvoicePick").click(function(){WdatePicker();});
		$("#currDiplomaDate").click(function(){WdatePicker();});
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
			$.get("studentControl.asp?op=getNodeInfo&nodeID=0&refID=" + refID + "&times=" + (new Date().getTime()),function(re){
				//alert(unescape(re));
				var ar = new Array();
				ar = unescape(re).split("|");
				if(ar > ""){
					$("#name").val(ar[2]);
				}
			});
		}else{
			getComList("projectID","projectInfo","projectID","projectName","status>0 order by projectID desc",1);
			getNodeInfo(nodeID);
		}

		$("#projectID").change(function(){
			if($("#projectID").val()>""){
				var id=$("#projectID").val();
				setClassList(id);
				$.get("projectControl.asp?op=getPrice&refID=" + id + "&times=" + (new Date().getTime()),function(re){
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

		$("#btnPreview").click(function(){
			printEntryform(0);
		});

		$("#kindID").change(function(){
			setButton();
		});

		$("#btnPay").click(function(){
			$("#statusPay").val(1);
			$("#datePay").val(currDate);
			$("#dateInvoice").val(currDate);
			$("#dateInvoicePick").val(currDate);
			var s = getDicItem(0,"invoiceNo");
			s = fillFormat(parseInt(s) + 1, s.length, "0", 0);
			$("#invoice").val(s);
			if($("#kindID").val()==0){
				$("#title").val($("#name").val());
			}
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
		$("#smsList").click(function(){
			//alert($("#username").val() + ":" + $("#studentCourseID").val());
			showStudentSmsList($("#username").val(),$("#studentCourseID").val(),0,1);
		});
		$("#examList").click(function(){
			showStudentExamList($("#username").val(),$("#name").val(),0,1);
		});
	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		$.get("studentCourseControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			var c = "";
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#studentCourseID").val(ar[0]);
				$("#username").val(ar[1]);
				$("#name").val(ar[2]);
				$("#statusName").val(ar[4]);
				$("#courseName").val(ar[6]);
				$("#regDate").val(ar[11]);
				if(ar[39]=="znxf"){	//非集团客户，显示自己的单位和部门
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
				$("#reexamineName").val(ar[41]);
				$("#submiterName").val(ar[44]);
				$("#currDiplomaID").val(ar[45]);
				$("#currDiplomaDate").val(ar[46]);
				$("#fromID").val(ar[47]);

				getPayDetailInfoByEnterID(ar[0]);
			//getDownloadFile("studentCourseID");
				var c1 = "";
				if(ar[35] > ""){
					c1 += "<a href='/users" + ar[35] + "' target='_blank'>下载</a>";
					entryform = "/users" + ar[35];
				}
				if(c1 == ""){c1 = "&nbsp;&nbsp;还未生成";}
				//$("#entryform").html(c1);
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

	function getPayDetailInfoByEnterID(id){
		$.get("studentCourseControl.asp?op=getPayDetailInfoByEnterID&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			var c = "";
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#payDetailID").val(ar[0]);
				$("#payID").val(ar[1]);
				$("#price").val(ar[3]);
				getPayInfo(ar[1]);
			}
		});
	}

	function getPayInfo(id){
		$.get("studentCourseControl.asp?op=getPayInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			var c = "";
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#payID").val(ar[0]);
				$("#invoice").val(ar[1]);
				if($("#classID").val()>""){
					$("#statusPay").val(ar[3]);
				}else{
					$("#statusPay").val(1);	//网上报名的，编班时默认为已付费。
				}
				$("#kindID").val(ar[5]);
				$("#type").val(ar[7]);
				$("#datePay").val(ar[9]);
				$("#dateInvoice").val(ar[10]);
				$("#dateInvoicePick").val(ar[11]);
				$("#dateRefund").val(ar[12]);
				$("#refunderName").val(ar[14]);
				$("#memo").val(ar[18]);
				$("#title").val(ar[22]);
			}else{
				//jAlert("缴费信息未找到！","信息提示");
			}
		});
	}
	
	function saveNode(){
		if($("#payID").val()==0){
			jAlert("没有要操作的数据。");
			return false;
		}
		if($("#classID").val() == "" || $("#classID").val() == null){
			jAlert("请选择班级。");
			return false;
		}
		var id=$("#classID").val();
		//alert(id);
		
		$.get("studentControl.asp?op=getClassRefrence&nodeID=" + $("#username").val() + "&refID=" + id, function(data){
			data = unescape(data);
			//alert(data);
			if(refAlert != id && data > ""){
				//参照预报名表进行校验，如果有出入则给出提示。同样的班级第二次则不给提示。
				jAlert("根据预报名情况，此人可能要报<a style='color:red;'>" + data + "</a>课程，请核实。");
				refAlert = id;
				return false;
			}else{
				//alert($("#studentID").val() + "&item=" + ($("#memo").val()));
				//@ID int,@invoice varchar(50),@projectID varchar(50),@kindID varchar(50),@type int,@status int,@datePay varchar(50),@dateInvoice varchar(50),@dateInvoicePick varchar(50),@memo
				//alert($("#payID").val() + "&refID=" + $("#username").val() + "&invoice=" + $("#invoice").val() + "&projectID=" + $("#projectID").val() + "&item=" + ($("#title").val()) + "&kindID=" + $("#kindID").val() + "&type=" + $("#type").val() + "&status=" + $("#status").val() + "&datePay=" + $("#datePay").val() + "&dateInvoice=" + $("#dateInvoice").val() + "&dateInvoicePick=" + $("#dateInvoicePick").val() + "&memo=" + ($("#memo").val()));
				$.get("studentCourseControl.asp?op=updatePayInfo&nodeID=" + $("#payID").val() + "&refID=" + $("#username").val() + "&invoice=" + $("#invoice").val() + "&projectID=" + $("#projectID").val() + "&item=" + escape($("#title").val()) + "&kindID=" + $("#kindID").val() + "&type=" + $("#type").val() + "&status=" + $("#statusPay").val() + "&datePay=" + $("#datePay").val() + "&dateInvoice=" + $("#dateInvoice").val() + "&dateInvoicePick=" + $("#dateInvoicePick").val() + "&memo=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
					//alert(unescape(re));
					updateCount += 1;
					jAlert("保存成功.","信息提示");
				});
				$.get("studentCourseControl.asp?op=updatePayPrice&nodeID=" + $("#payDetailID").val() + "&refID=" + $("#price").val() + "&times=" + (new Date().getTime()),function(re){
					//jAlert(unescape(re));
				});
				$.get("studentCourseControl.asp?op=updateEnterClass&nodeID=" + nodeID + "&refID=" + $("#classID").val() + "&keyID=" + $("#SNo").val() + "&currDiplomaID=" + $("#currDiplomaID").val() + "&currDiplomaDate=" + $("#currDiplomaDate").val() + "&fromID=" + $("#fromID").val() + "&times=" + (new Date().getTime()),function(re){
					//jAlert(unescape(re));
					getNodeInfo(nodeID);
					printEntryform(1);
				});
			}
		});
		
		return false;
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
			var id=$("#classID").val();
			//alert(id);
			$.get("studentControl.asp?op=getClassRefrence&nodeID=" + $("#username").val() + "&refID=" + id, function(data){
				data = unescape(data);
				//alert(data);
				if(refAlert != id && data > ""){
					//参照预报名表进行校验，如果有出入则给出提示。同样的班级第二次则不给提示。
					jAlert("根据预报名情况，此人可能要报<a style='color:red;'>" + data + "</a>课程，请核实。");
					refAlert = id;
					return false;
				}else{
					
					//@username,@classID,@price,@invoice,@projectID,@kindID,@type,@status,@datePay varchar(50),@dateInvoice varchar(50),@dateInvoicePick varchar(50),@memo,@registerID
					$.get("studentCourseControl.asp?op=doEnter&nodeID=" + $("#username").val() + "&classID=" + $("#classID").val() + "&fromID=" + $("#fromID").val() + "&price=" + $("#price").val() + "&invoice=" + $("#invoice").val() + "&projectID=" + $("#projectID").val() + "&item=" + escape($("#title").val()) + "&kindID=" + $("#kindID").val() + "&type=" + $("#type").val() + "&status=" + $("#statusPay").val() + "&datePay=" + $("#datePay").val() + "&dateInvoice=" + $("#dateInvoice").val() + "&dateInvoicePick=" + $("#dateInvoicePick").val() + "&currDiplomaID=" + $("#currDiplomaID").val() + "&currDiplomaDate=" + $("#currDiplomaDate").val() + "&memo=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
						//jAlert(unescape(re));
						var ar = new Array();
						ar = unescape(re).split("|");
						if(ar[0] == 0){
							op = 0;
							updateCount += 1;
							nodeID = ar[3];
							getPayInfo(ar[2]);
							getNodeInfo(ar[3]);
							generateEntryForm(1);
						}
						jAlert(ar[1],"信息提示");
					});
				}
			});
		}
		return false;
	}
	
	function setClassList(id){
		$("#classID").empty();
		if(op==1){
			getComList("classID","[dbo].[getClassListByProject]('" + id + "')","classID","classIDName"," status=0 order by batchID desc",1);
		}else{
			getComList("classID","[dbo].[getClassListByProject]('" + id + "')","classID","classIDName"," 1=1 order by batchID desc",1);
		}
	}
	
	function generateEntryForm(i){
		/*$.getJSON(uploadURL + "/outfiles/generate_entryform?certID=" + $("#certID").val() + "&enterID=" + $("#studentCourseID").val() + "&registerID=" + currUser ,function(data){
			if(data>""){
				if(i==0){
					asyncbox.alert("报名表已生成 <a href='users" + data + "' target='_blank'>下载文件</a>",'操作成功',function(action){
					　　//alert 返回action 值，分别是 'ok'、'close'。
					　　if(action == 'ok'){
					　　}
					　　if(action == 'close'){
					　　　　//alert('close');
					　　}
					});
				}
				getNodeInfo(nodeID);
				window.open("entryform_" + $("#certID").val() + ".asp?nodeID=" + nodeID + "&refID=" + refID + "&keyID=1", "_self");
			}else{
				alert("没有可供处理的数据。");
			}
		});
		*/
		var c = $("#certID").val();
		if(c == "C21" || c == "C20A"){
			c = "C20";
		}
		if(c == "C30" || c == "C31" || c == "C32"){
			c = "C2";
		}
		if(c == "C24" || c == "C25" || c == "C26" || c == "C25B" || c == "C26B" || c == "C14" || c == "C15"){
			c = "C12";
		}
		window.open("entryform_" + c + ".asp?nodeID=" + nodeID + "&refID=" + refID + "&keyID=1", "_self");
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
	
	function printEntryform(k){
		var c = $("#certID").val();
		c = "C2";
		if(c == "C21" || c == "C20A"){
			c = "C20";
		}
		if(c == "C30" || c == "C31" || c == "C32"){
			c = "C2";
		}
		if(c == "C24" || c == "C25" || c == "C26" || c == "C25B" || c == "C26B" || c == "C14" || c == "C15"){
			c = "C12";
		}
		window.open("entryform_" + c + ".asp?keyID=" + k + "&nodeID=" + nodeID + "&refID=" + refID + "&kindID=" + $("#certID").val(), "_self");
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
		$("#btnPrint").hide();
		if($("#statusPay").val()==0 && $("#kindID").val()==0){
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
			//$("#fromID").prop("disabled",true);
		}else{
			if(checkPermission("studentAdd")){
				//编辑状态：显示保存按钮；一定条件下可以退学、退款
				$("#save").show();
				if(!checkRole("partner")){
					$("#btnReturn").show();
					$("#btnRefund").show();
					$("#btnCloseStudentCourse").show();
					if(!$("#materialCheck").attr("checked")){
						$("#btnMaterialCheck").show();
					}
				}
			}
            //if(checkPermission("studentDel") && ($("#className").val()=="" || dateDiff(currDate, $("#regDate").val())<180) && $("#statusPay").val()==0 && $("#invoice").val()=="" && $("#dateInvoicePick").val()=="" || $("#name").val().indexOf("测试")>-1){
            if(checkPermission("studentDel") && ($("#className").val()=="" || dateDiff(currDate, $("#regDate").val())<180) || $("#name").val().indexOf("测试")>-1){
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
			$("#fromID").prop("disabled",false);
		}
	}
	function setEmpty(){
		$("#SNo").val("");
		if($("#kindID").val()==0){
			//个人缴费
			$("#statusPay").val(1);
			$("#datePay").val(currDate);
			$("#dateInvoice").val(currDate);
			$("#dateInvoicePick").val(currDate);
			//$("#invoice").val(parseInt(getDicItem(0,"invoiceNo")) + 1);
		}
		if($("#kindID").val()==1){
			//团体缴费
			$("#statusPay").val(1);
			$("#datePay").val("");
			$("#dateInvoice").val("");
			$("#dateInvoicePick").val("");
			$("#invoice").val("");
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
				<td><input style="border:0px;" type="checkbox" id="checked" value="" />&nbsp;&nbsp;<input class="readOnly" type="text" id="checkerName" size="5" readOnly="true" /></td>
				<td align="right">确认日期</td>
				<td><input class="readOnly" type="text" id="checkDate" size="25" readOnly="true" /></td>
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
				<td><input style="border:0px;" type="checkbox" id="materialCheck" value="" />&nbsp;&nbsp;<input class="readOnly" type="text" id="materialCheckerName" size="5" readOnly="true" />&nbsp;&nbsp;<input class="button" type="button" id="btnMaterials" value="查看" /></td>
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
				类别&nbsp;<input class="readOnly" type="text" id="reexamineName" style="width:50px" readOnly="true" />
				<br>
				<span id="class1">所属班级&nbsp;<select id="classID" style="width:250px"></select>&nbsp;&nbsp;</span>
				<span id="class0">所属班级&nbsp;<input class="readOnly" type="text" id="className" style="width:250px" readOnly="true" />&nbsp;&nbsp;经办人&nbsp;<input class="readOnly" type="text" id="submiterName" style="width:50px" readOnly="true" />&nbsp;&nbsp;</span>
				编号&nbsp;<input type="text" id="SNo" style="width:50px" />
				<div>
                <form style="width:99%;float:right;margin:1px;padding-left:2px;background:#f8f8ee;">
                <table>
                <tr>
                    <td align="right">初训证书编号</td>
                    <td><input type="text" id="currDiplomaID" style="width:140px;" /></td>
                    <td align="right">有效期</td>
                    <td><input type="text" id="currDiplomaDate" style="width:80px;" />&nbsp;销售<select id="fromID" style="width:80px;"></select></td>
                </tr>
                </table>
                </form>
				</div>
				<br>
					<span id="entryform" style="margin-left:20px;"></span>
					<input class="button" type="button" id="btnEntryform" value="生成" />
					<input class="button" type="button" id="save" value="保存" />
					<input class="button" type="button" id="btnPreview" value="预览" />
					<input class="button" type="button" id="btnPrint" value="打印" />
					<input class="button" type="button" id="btnFiremanMaterials" value="消防员" />
				</div>
			</div>

			<div style="width:100%;float:left;margin:10;height:4px;"></div>
			<form id="payCover" style="width:98%;float:right;margin:1px;padding-left:2px;background:#f8f8ee;">
			<table>
			<tr>
				<td align="right">缴费类型</td><input type="hidden" id="payID" /><input type="hidden" id="payDetailID" />
				<td><select id="kindID" style="width:180px;"></select></td>
				<td align="right">缴费金额</td>
				<td><input type="text" id="price" style="width:50px;" />&nbsp;&nbsp;<input class="button" type="button" id="btnPay" value="付款" /></td>
			</tr>
			<tr>
				<td align="right">支付方式</td>
				<td><select id="type" style="width:180px;"></select></td>
				<td align="right">支付状态</td>
				<td><select id="statusPay" style="width:180px;"></select></td>
			</tr>
			<tr>
				<td align="right">付款日期</td>
				<td><input type="text" id="datePay" size="25" /></td>
				<td align="right">发票号码</td>
				<td><input type="text" id="invoice" size="25" /></td>
			</tr>
			<tr>
				<td align="right">开票日期</td>
				<td><input type="text" id="dateInvoice" size="25" /></td>
				<td align="right">取票日期</td>
				<td><input type="text" id="dateInvoicePick" size="25" /></td>
			</tr>
			<tr>
				<td align="right">发票抬头</td>
				<td><input type="text" id="title" size="25" /></td>
				<td align="right">退款日期</td>
				<td><input type="text" id="dateRefund" style="width:80px;" />&nbsp;&nbsp;经办<input class="readOnly" type="text" id="refunderName" style="width:60px;" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">备注</td>
				<td colspan="5"><input type="text" id="memo" style="width:100%;" /></td>
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
		<input class="button" type="button" id="btnRefund" value="退款" />&nbsp;
		<input class="button" type="button" id="btnDel" value="删除" />&nbsp;
		<input class="button" type="button" id="btnCloseStudentCourse" value="关闭课程学习" />&nbsp;
		<input class="button" type="button" id="btnRebuildStudentLesson" value="刷新课表" />&nbsp;
		<input class="button" type="button" id="smsList" value="查看通知" />&nbsp;
		<input class="button" type="button" id="examList" value="查看考试信息" />
  	</div>
</div>
</body>
