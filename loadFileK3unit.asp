<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner.css"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script type="text/javascript" src="js/jquery.blockUI.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>

<script language="javascript">
	var refID = "";
	var resultCount = 0;
	<!--#include file="js/commFunction.js"-->
	
	$(document).ready(function (){
		$("#item").html("导入市房租补贴情况表");
   	/*	
		$("#formLoad").ajaxForm(function(data){
			alert(data);
			if(data==""){
				jAlert("上传失败，请更修改一下文件名再试试。","信息提示");
			}else{
				$.get("readExcel.asp?kindID=getK3unitList&fName=" + escape(data) + "&times=" + (new Date().getTime()),function(re){
					alert(unescape(re));
					var ar = new Array();
					ar = unescape(re).split("|");
					if(ar[0]==-1){
						jAlert("导入的文件格式错误，请检查。");
					}else{
						var s = ""; 
						if(ar[2]==0 && ar[0]>-1){
							s = "成功地导入了 " + ar[1] + " 条数据。\n<hr size='1' width='80%' noshadow>"; 
							if(ar[0]>0){
								s += "以下<font color='red'>" + ar[0] + "</font>条转移记录已经存在，未被导入：\n<hr size='1' width='60%' noshadow>" + ar[4];
							}
							jAlert(s,"导入结果");
						}else{
							s = "导入的数据中包括<font color='red'>" + ar[2] + "</font>条记录需要核实，本次导入取消。\n<hr size='1' width='60%' noshadow>" + ar[5];
							jAlert(s,"错误提示");
						}
					}
				});
			}
			hideWaitMsg();
			return false;
		});*/
		
		$("#restore").click(function(){
			var s = "";
			var timer =  window.setInterval(function () {
				s = getSession("upload");
	    	if(s>""){
	    		window.clearInterval(timer);
					$.get("readExcel.asp?kindID=getK3unitList&fName=" + escape(s) + "&times=" + (new Date().getTime()),function(re){
						//alert(unescape(re));
						var ar = new Array();
						ar = unescape(re).split("|");
						if(ar[0]==-1){
							jAlert("导入的文件格式错误，请检查。");
						}else{
							var s = ""; 
							if(ar[1]>0 && ar[0]>-1){
								s = "总共导入了 " + ar[1] + " 条数据。\n<hr size='1' noshadow>"; 
								resultCount = ar[1];
								if(ar[0]>0){
									s += "以下<font color='red'>" + ar[0] + "</font>条记录已经存在，未被导入：\n<hr size='1' noshadow>" + ar[4];
								}
							}
							if(ar[2]>0){
								s += "\n其中包括<font color='red'>" + ar[2] + "</font>条记录需要核实，这部分数据已删除。\n<hr size='1' noshadow>" + ar[5];
							}
							jAlert(s,"错误提示");
						}
					});

	    		setSession("upload","");
	    	}else{
	    		jAlert("上传失败，请更修改一下文件名再试试。","信息提示");
	    	}
    	}, 1000);
			//hideWaitMsg();
		});
	});
</script>

</head>

<body>

<div id='layout' align='left'>	
	<div class="comm" style="background:#dddddd;"><h2><span id="item"></span></h2></div>
	<br>
  <hr color="#c0c0c0" noshadow>
	
	<div style="width:100%;float:left;margin:0;">
		<div class="comm" style="border:solid 1px #e0e0e0;width:98%;margin:1px;background:#ffffff;line-height:18px;">
			<form action="loadFile.asp?type=upload&kindID=1" id="formLoad" name="formLoad" encType="multipart/form-data"  method="post" target="hidden_frame" >
  				<input class="button" type="submit" name="restore"  id="restore" value="导入文件">
				<input type="file" id="file" name="file" style="width:300px;">
				<input id="loadFileKind" name="loadFileKind" type="hidden" value="1" />
				<input id="loadFileOperator" name="loadFileOperator" type="hidden" />
				<iframe name='hidden_frame' id="hidden_frame" style='display:none;'></iframe>
			</form>
		</div>
	</div>
</div>
</body>
