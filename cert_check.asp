<!--#include file="js/doc1.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title></title>

<!--必要样式-->
<link href="css/style_inner1.css?ver=1.2"  rel="stylesheet" type="text/css" id="css" />
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>


<script language="javascript">
	var nodeID = 0;
	var updateCount = 0;
	var uploadURL = "<%=uploadURL%>";
	var kindID = "";
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";  //username
		kindID = "<%=kindID%>";  //source
		$.ajaxSetup({ 
			async: false 
		});

		$("#log_in").click(function(){
			let username = $("#username").val();
			let name = $("#name").val();
			if(username==""){
				$.messager.alert("提示","请填写身份证","info");
				return false;
			}
			if(name==""){
				$.messager.alert("提示","请填写姓名","info");
				return false;
			}
          	
			$.post(uploadURL + "/public/postCommInfo", {proc:"getStudentDiplomas", params:{username:username,name:name}}, function(data){
				let status = data[0]["status"];
				if(status==0){  //passed
					let ar = data[0]["re"].split("**");
					let arr = [];
					let i = 0;
					$.each(ar,function(iNum,val){
						if(val > ""){
							arr.push('<iframe src="' + (val.indexOf("https://")==-1?"users":"") + val + '?times=' + (new Date().getTime()) + '#view=fit" width="600" height="600" style="border:0px;"></iframe>');
							i += 1;
						}
					});
					if(i===0){
						arr.push('<input type="text" size="40" style="font-size:1.3em;align:center;color:red;height:18px;vertical-align:middle;border:solid 1px gray;" value="无相关文档" />');
					}
					// alert(arr.join(""))
					$("#cover").html(arr.join(""));
				}
				if(status==1){  //username is wrong
					jAlert("身份证未找到","提示");
				}
				if(status==2){  //name is wrong
					jAlert("姓名不正确","提示");
				}
			});
			return false;
		});
	});
</script>

</head>

<body>

<div>
	<div style="text-align:center;align:center">
		<table>
			<tr>
				<td align="left">
					<label>身份证：</label>
				</td>
				<td align="left">
					<input type="text" id="username" size="40" style="height:18px;vertical-align:middle;border:solid 1px gray;" value="" />
				</td>
			</tr>
			<tr>
				<td>
					<label>姓&nbsp;&nbsp;名：</label> 
				</td>
				<td>
					<input type="text" id="name"  size="40" style="height:18px;vertical-align:middle;border:solid 1px gray;" value="" />
				</td>
			</tr>
			<tr>
				<td>&nbsp;
				</td>
				<td align="center">
					<br />
					<input class="button" type="button" id="log_in" value="查询" />
				</td>
			</tr>
		</table>
    </div>
	<div id="cover"></div>
</div>
</body>
