<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
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
	var nodeID = 1;
	var kindID = 0;
	var item = "";
	var memo = "";
	var refID = "";
	var updateCount = 0;
	var payUrl = "";
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		// test();
		
		$("#btnPay").click(function(){
			pay();
		});
		$("#btnRefund").click(function(){
			refund();
		});
		$("#btnQuestion").click(function(){
			$.post(uploadURL + "/outfiles/readQustionOther?mark=" + $("#mark").val(), function(re){
				alert(re);
			});
		});
	});

	function test(){
		$.post(uploadURL + "/nuonuo/oderPaymentReturn" ,function(data){
			alert(data)
		});
	}

	function pay(){
		$.ajax({
			url: uploadURL + "/public/enterPay",
			type: "post",
			data: {"host":"znxf", "kindID":0, "enterID":$("#orderNo").val(), "amount":$("#amount").val(), "item":"从业人员初训报名费","name":"310108199320320021张三丰","sales":"大佬"},
			beforeSend: function() {   
				$.messager.progress();	// 显示进度条
			},
			success: function(data){
				//jAlert(data);
				$("#result").val(data);
				if(data.code=="JH200"){
					$("#url").val(data.result.payUtl);
					// window.open(data.result.payUtl, "_blank");
					payUrl = data.result.payUtl;
					var text = uploadURL + "/public/get_qr_img?size=10&text=" + encodeURIComponent(payUrl);
					// alert(text)
					$("#imgPay").prop("src", text);
				}
				$("#code").html(data.code);
				$("#memo").html(data.describe);
				$.messager.progress('close');	// 如果提交成功则隐藏进度条 
			},
			error: function () {
				$.messager.progress('close');
			}
		});
	}


	function refund(){
		$.ajax({
			url: uploadURL + "/public/enterPay",
			type: "post",
			data: {"host":"znxf", "kindID":1, "enterID":$("#orderNo").val(), "amount":0.01, "item":"测试","name":"desk","sales":"system"},
			beforeSend: function() {   
				$.messager.progress();	// 显示进度条
			},
			success: function(data){
				//jAlert(data);
				$("#result").val(data);
				if(data.code=="JH200"){
					$("#url").val(data.result.refundNo);
				}
				$.messager.progress('close');	// 如果提交成功则隐藏进度条 
			},
			error: function () {
				$.messager.progress('close');
			}
		});
	}

</script>

</head>

<body style="background:#f0f0f0;">
 <!--#include file='commFloatDetail.asp' -->
 <!--#include file='commLoadFileDetail.asp' -->

<div id='layout' align='left' style="background:#f0f0f0;">	

	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
  		<input type="text" id="result" style="width:100%;" />
  		<input type="text" id="url" style="width:100%;" />
  		订单号：<input type="text" id="orderNo" style="width:20%;" value="206" />
  		&nbsp;&nbsp;金额：<input type="text" id="amount" style="width:20%;" value="0" />
		<img id="imgPay" src="" />
  		&nbsp;<input class="button" type="button" id="btnPay" value="付款" />&nbsp;
  		&nbsp;<input class="button" type="button" id="btnRefund" value="退款" />&nbsp;
  	</div>
	<div>返回代码：<span id="code"></span>&nbsp;&nbsp;错误信息：<span id="memo"></span></div>
  	<div>
		<input type="text" id="mark" style="width:20%;" />
		<input class="button" type="button" id="btnQuestion" value="录入题库" />
	</div>
</div>
</body>
