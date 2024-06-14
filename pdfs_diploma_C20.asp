<!--#include file="js/doc1.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<title></title>
<meta name="viewport" content="width=device-width">

<!--必要样式-->
<link href="css/style.css?ver=1.1"  rel="stylesheet" type="text/css" id="css" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>


<script language="javascript">
	var refID = 0;
	var updateCount = 0;
	var uploadURL = "<%=uploadURL%>";
	$(document).ready(function (){
		refID = "<%=refID%>";
		$.ajaxSetup({ 
			async: false 
		}); 
		//$("#test").html(refID);
		//$("#test").hide();
		getNodeInfo(refID);
	});

	function getNodeInfo(id){
		$.getJSON(uploadURL + "/public/getDiplomaListByBatchID?refID=" + id,function(data){
			//jAlert(unescape(data));
			var c = "";
			$("#cover").empty();
			var arr = new Array();
			if(data.length>0){
				var i = 0;
				var j = 0;
				var m = 1;  //rows per table
				var n = 1;  //columns per row
				var k = 0;
				$.each(data,function(iNum,val){
					k += 1;
					arr.push('<section class="login-form-wrap3s">');
					arr.push('<div>');
					arr.push('<div style="width:100%; padding-left:260mm; padding-top:137mm;">');
					arr.push('	<table style="width:100%;">');
					arr.push('		<tr>');
					arr.push('			<td style="height:67px;"><h5>' + val["name"] + '</h5></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td style="height:67px;"><h5>' + val["sexName"] + '</h5></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td style="height:67px;"><h5>' + val["birthday"] + '</h5></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td style="height:67px;"><h5>' + val["username"] + '</h5></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td style="height:67px;"><h5>' + val["diplomaID"] + '</h5></td>');
					arr.push('		</tr>');
					arr.push('	</table>');	
					arr.push('</div>');
					arr.push('</section><hr style="page-break-after:always; border:none;">');	//分页
					arr.push('<div style="width:100%; padding-left:200mm;padding-top:41mm;">');
					// arr.push('<div class="lineC1s" style="padding-top:10mm;padding-left:20mm;"><span>' + (val["name"].length>2?val["name"]:val["name"]+'&nbsp;&nbsp;') + '</span><span style="padding-left:45mm;">' + val["class_startDate"].substring(0,4) + '</span><span style="padding-left:15mm;">' + val["class_startDate"].substring(5,7) + '</span><span style="padding-left:15mm;">' + val["class_startDate"].substring(8,10) + '</span></div>');
					arr.push('<div class="lineC1s" style="padding-top:10mm;padding-left:15mm;"><span>' + (val["name"].length>2?val["name"]:val["name"]+'&nbsp;&nbsp;') + '</span><span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + val["class_startDate"].substring(0,4) + '</span><span style="padding-left:15mm;">' + val["class_startDate"].substring(5,7) + '</span><span style="padding-left:15mm;">' + val["class_startDate"].substring(8,10) + '</span></div>');
					arr.push('<div class="lineC1s" style="padding-top:15mm;padding-left:14mm;"><span>' + val["class_endDate"].substring(0,4) + '</span><span style="padding-left:15mm;">' + val["class_endDate"].substring(5,7) + '</span><span style="padding-left:15mm;">' + val["class_endDate"].substring(8,10) + '</span></div>');
					arr.push('<div class="lineC1s" style="padding-top:130mm;padding-left:75mm;"><span>' + val["startDate"].substring(0,4) + '</span><span style="padding-left:15mm;">' + val["startDate"].substring(5,7) + '</span><span style="padding-left:15mm;">' + val["startDate"].substring(8,10) + '</span></div>');
					arr.push('</div>');
					arr.push('</div>');
					arr.push('<hr style="page-break-after:always; border:none;">');	//分页
				});
				$("#cover").html(arr.join(""));
			}
		});
	}
	//fillFormat("1",3,"0",0) = "001"
	function fillFormat(strIn,intLng,strFill,location){
		var result = String(strIn);
		while(result.length < intLng){
			if(location==0){//填充在前面
				result = strFill + result;
			}else{
				result = result + strFill;
			}
		}
		return result;
	}
</script>

</head>

<body>
	<div id="cover"></div>
</body>
</html>
