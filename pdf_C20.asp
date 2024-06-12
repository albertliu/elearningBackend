<!--#include file="js/doc1.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title></title>
<meta name="viewport" content="width=device-width">

<!--必要样式-->
<link href="css/style.css?ver=1.0"  rel="stylesheet" type="text/css" id="css" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>


<script language="javascript">
	var item = "";
	var updateCount = 0;
	$(document).ready(function (){
		item = "<%=kindID%>";
		$.ajaxSetup({ 
			async: false 
		}); 
		//$("#test").html(item);
		$("#test").hide();
		getNodeInfo();
	});

	function getNodeInfo(){
		//$.get("diplomaControl.asp?op=getNodeInfoShort&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			var ar = new Array();
			//var c = "";
			ar = item.split(",");
			if(ar > ""){
				$("#diplomaNo").html(ar[0]);
				$("#name").html(ar[1]);
				$("#name1").html(ar[1]);
				$("#username").html(ar[2]);
				$("#birthday").html(ar[17]);
				$("#sexName").html(ar[12]);
				$("#class_startDate_y").html(ar[15].substring(0,4));
				$("#class_startDate_m").html(ar[15].substring(5,2));
				$("#class_startDate_d").html(ar[15].substring(7,2));
				$("#class_endDate_y").html(ar[16].substring(0,4));
				$("#class_endDate_m").html(ar[16].substring(5,2));
				$("#class_endDate_d").html(ar[16].substring(7,2));
				$("#class_endDate_y1").html(ar[7].substring(0,4));
				$("#class_endDate_m1").html(ar[7].substring(5,2));
				$("#class_endDate_d1").html(ar[7].substring(7,2));
			}/**/
		//});
	}
</script>

</head>

<body style="background: url(/images/background_diploma.jpg) repeat; opacity:0.75;">
		<div style="width:100%; padding-left:10mm;">
			<div style="float:left;width:100%; padding-top: 10mm;">
				<table style="width:100%;">
					<tr>
						<td style="height:45px;width:30%;height:45px;"></td>
						<td width="70%"><h5 id="name"></h5></td>
					</tr>
					<tr>
						<td style="height:45px;"></td>
						<td><h5 id="sexName"></h5></td>
					</tr>
					<tr>
						<td style="height:45px;"></td>
						<td><h5 id="birthday"></h5></td>
					</tr>
					<tr>
						<td style="height:45px;"></td>
						<td><h5 id="username"></h5></td>
					</tr>
					<tr>
						<td></td>
						<td><h5 id="diplomaNo"></h5></td>
					</tr>
				</table>
			</div>
		</div>
		<div style="float:left; padding-left:108mm;padding-top:15mm;">
			<div class="lineC1">
				<span id="name1" style="padding-left:10mm;"></span>
				<span id="class_startDate_y" style="padding-left:10mm;"></span>
				<span id="class_startDate_m" style="padding-left:10mm;"></span>
				<span id="class_startDate_d" style="padding-left:10mm;"></span>
				<span id="class_endDate_y" style="padding-left:10mm;"></span>
				<span id="class_endDate_m" style="padding-left:10mm;"></span>
				<span id="class_endDate_d" style="padding-left:10mm;"></span>
			</div>
			<div class="lineC1" style="padding-left:10mm; padding-top:150mm;">>
				<span id="class_endDate_y1" style="padding-left:10mm;"></span>
				<span id="class_endDate_m1" style="padding-left:10mm;"></span>
				<span id="class_endDate_d1" style="padding-left:10mm;"></span>
			</div>
		</div>
</body>
</html>
