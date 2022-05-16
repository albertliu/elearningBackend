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
			//alert(data);
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
					arr.push('<section class="login-form-wrap3p">');
					arr.push('<div style="position: relative;">');
					arr.push('<div style="position: absolute; z-index:10; width:100%; padding-left:8mm;padding-top:10mm;">');
					arr.push('	<table style="font-size: 28px; width:146mm;">');
					arr.push('		<tr>');
					arr.push('			<td style="height:68px; width:40mm;"><h6a>证书编号</h6a></td><td colspan="3"><h6>' + val["diplomaID"] + '</h6></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td><h6a>姓名</h6a></td><td><h6>' + val["name"] + '</h6></td><td><h6a>性别</h6a></td><td style="height:68px;"><h6>' + val["sexName"] + '</h6></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td><h6a>身份证号</h6a></td><td colspan="3" style="height:68px;"><h6>' + val["username"] + '</h6></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td><h6a>证书名称</h6a></td><td colspan="3" style="height:68px;"><h6>' + val["certName"] + '</h6></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td><h6a>有效期限</h6a></td><td colspan="3" style="height:68px;"><h6>' + val["startDate"] + '至' + val["endDate"] + '</h6></td>');
					arr.push('		</tr>');
					arr.push('		<tr>');
					arr.push('			<td><h6a>发证机构</h6a></td><td colspan="3" style="height:68px;"><h6>上海智能消防学校</h6></td>');
					arr.push('		</tr>');
					arr.push('	</table>');	
					arr.push('</div>');
					arr.push('<div style="position: absolute; z-index:30;padding-top:13mm;padding-left:155mm;">');
					arr.push('<img id="photo" src="users' + val["photo_filename"] + '" style="opacity:1; width:70mm;max-height:93mm;">');
					arr.push('</div>');	
					arr.push('</div>');
					arr.push('</section>');
					arr.push('<hr style="page-break-after:always; border:none;" />');	//分页
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
