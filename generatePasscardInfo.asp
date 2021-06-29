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
	var nodeID = "";
	var refID = "";
	var op = 0;
	var fn = "";
	var updateCount = 0;
	<!--#include file="js/commFunction.js"-->
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";		//
		refID = "<%=refID%>";		//
		op = "<%=op%>";
		
		$.ajaxSetup({ 
			async: false 
		}); 
		getComList("certID","certificateInfo","certID","shortName","status=0 and type=0 order by certID",1);
		getDicList("examResult","s_status",1);
		getDicList("statusNo","s_resit",1);
		$("#startDate").click(function(){WdatePicker();});
		setButton();
		if(nodeID>0 && op==0){
			getNodeInfo(nodeID);
		}

		$("#sendMsgExam").click(function(){
			jConfirm("确定向这批考生发送考试通知吗？","确认",function(r){
				if(r){
					//alert($("#searchStudentNeedDiplomaCert").val() + "&host=" + $("#searchStudentNeedDiplomaHost").val() + "&username=" + currUser);
					$.getJSON(uploadURL + "/public/send_message_exam?SMS=1&batchID=" + nodeID + "&registerID=" + currUser ,function(data){
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
					$.getJSON(uploadURL + "/public/send_message_score?SMS=1&batchID=" + nodeID + "&registerID=" + currUser ,function(data){
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

		$("#save").click(function(){
			saveNode();
		});

		$("#del").click(function(){
			if($("#qty").val()>0){
				jAlert("该场次还有考生，请将其清空后再删除。");
				return false;
			}
			jConfirm('你确定要删除考试信息吗?', '确认对话框', function(r) {
				if(r){
					$.get("diplomaControl.asp?op=delGeneratePasscard&nodeID=" + nodeID + "&&times=" + (new Date().getTime()),function(data){
						jAlert("成功删除！","信息提示");
						op = 1;
						setButton();
						updateCount += 1;
					});
				}
			});
		});
		$("#close").click(function(){
			if(confirm('确定要结束本场考试吗?')){
				$.get("diplomaControl.asp?op=closeGeneratePasscard&nodeID=" + $("#ID").val() + "&times=" + (new Date().getTime()),function(data){
					jAlert("已关闭考试","信息提示");
					getNodeInfo(nodeID);
					updateCount += 1;
				});
			}
		});
		$("#doPasscard").click(function(){
			doPasscard();
		});
		$("#list").click(function(){
			outputExcelBySQL('x01','file',nodeID,0,0);
		});
		$("#sign").click(function(){
			outputExcelBySQL('x02','file',nodeID,0,0);
		});
		$("#score").click(function(){
			outputExcelBySQL('x03','file',nodeID,0,0);
		});
		$("#certID").change(function(){
			c = $("#certID").find("option:selected").text();
			if($("#startDate").val()>"" && c > ""){
				$("#title").val(c + $("#startDate").val());
			}
		});
		$("#btnSearch").click(function(){
			getPasscardList();
		});

		$("#btnSel").click(function(){
			setSel("");
		});
		
		$("#btnResit").click(function(){
			if($("#status").val()==0){
				jAlert("请先结束考试，再安排补考。");
				return false;
			}
			getSelCart("");
			if(selCount==0){
				jAlert("请选择要加入购物车的人员。");
				return false;
			}
			jConfirm('确定要安排这' + selCount + '个人补考吗?', "确认对话框",function(r){
				if(r){
					add2Cart("","examer","*补考*");
					updateCount += 1;
				}
			});
		});
		$("#doImportScore").click(function(){
			showLoadFile("score_list",$("#ID").val(),"studentList",'');
			updateCount += 1;
		});
	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		//alert(id);
		$.get("diplomaControl.asp?op=getGeneratePasscardNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			var c = "";
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#certID").val(ar[1]);
				//$("#className").val(ar[2]);
				$("#title").val(ar[3]);
				$("#qty").val(ar[4]);
				$("#startTime").val(ar[5]);
				$("#address").val(ar[6]);
				$("#notes").val(ar[7]);
				$("#startDate").val(ar[8]);
				//$("#filename").val(ar[9]);
				fn = ar[9];
				$("#memo").val(ar[10]);
				$("#regDate").val(ar[11]);
				$("#registerName").val(ar[12]);
				$("#startNo").val(ar[13]);
				$("#send").val(ar[14]);
				$("#sendDate").val(ar[15]);
				$("#senderName").val(ar[16]);
				$("#send").val(ar[20]);
				$("#sendDate").val(ar[21]);
				$("#senderName").val(ar[22]);
				$("#status").val(ar[17]);
				$("#statusName").val(ar[18]);
				var c = "";
				if(ar[9] > ""){
					c += "<a href='/users" + ar[9] + "' target='_blank'>准考证</a>";
					$("#list").html("<a href=''>考站数据</a>");
					$("#sign").html("<a href=''>签到表</a>");
					$("#score").html("<a href=''>评分表</a>");
					if(ar[19] > ""){
						$("#scoreResult").html("<a href='/users" + ar[19] + "' target='_blank'>成绩单</a>");
					}
				}
				if(c == ""){c = "&nbsp;&nbsp;还未生成";}
				$("#photo").html(c);
				//getDownloadFile("generateDiplomaID");
				nodeID = ar[0];
				setButton();
				getPasscardList();
			}else{
				jAlert("该信息未找到！","信息提示");
				setEmpty();
			}
		});
	}
	
	function doPasscard(){
		if($("#title").val()==""){
			jAlert("请填写标题。");
			return false;
		}
		if($("#startDate").val()==""){
			jAlert("请填写考试日期。");
			return false;
		}
		if($("#startTime").val()==""){
			jAlert("请填写考试时间。");
			return false;
		}
		if($("#startNo").val()=="" || $("#startNo").val()<1 || $("#startNo").val()>1000){
			jAlert("请检查起始编号值。");
			return false;
		}
		var s = "确定要制作准考证吗?";
		if(fn > ""){
			s = "要重新制作准考证吗？请随后下载新的考站数据、签到表。";
		}

		jConfirm('确定要制作准考证吗?', '确认对话框', function(r) {
			if(r){
				//alert($("#studentID").val() + "&item=" + ($("#memo").val()));
				$.getJSON(uploadURL + "/outfiles/generate_passcard_byExamID?mark=0&ID=" + nodeID + "&username=" + currUser ,function(data){
					if(data>""){
						jAlert("准考证制作成功");
						op = 0;
						updateCount = 1;
						nodeID = data;
						getNodeInfo(data);
					}else{
						jAlert("没有可供处理的数据。");
					}
				});
			}
		});
		return false;
	}
	
	function saveNode(){
		if($("#title").val()==""){
			jAlert("请填写标题。");
			return false;
		}
		if($("#startDate").val()==""){
			jAlert("请填写考试日期。");
			return false;
		}
		if($("#startTime").val()==""){
			jAlert("请填写考试时间。");
			return false;
		}
		if($("#certID").val()==""){
			jAlert("请选择考试科目。");
			return false;
		}
		//alert($("#studentID").val() + "&item=" + ($("#memo").val()));
		$.get("diplomaControl.asp?op=updateGeneratePasscardInfo&nodeID=" + nodeID + "&refID=" + $("#certID").val() + "&keyID=" + $("#startNo").val() + "&startDate=" + $("#startDate").val() + "&startTime=" + $("#startTime").val() + "&item=" + escape($("#title").val()) + "&address=" + escape($("#address").val()) + "&notes=" + escape($("#notes").val()) + "&memo=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
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

	function getPasscardList(){
		$.get("diplomaControl.asp?op=getPasscardListByExam&refID=" + nodeID + "&status=" + $("#s_status").val() + "&keyID=" + $("#s_resit").val() + "&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#cover").empty();
			arr = [];		
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='cardTab' width='100%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='4%'>No</th>");
			arr.push("<th width='20%'>身份证</th>");
			arr.push("<th width='10%'>姓名</th>");
			arr.push("<th width='25%'>单位</th>");
			arr.push("<th width='15%'>电话</th>");
			arr.push("<th width='10%'>成绩</th>");
			arr.push("<th width='10%'>补考</th>");
			arr.push("<th width='8%'></th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				var imgChk = "<img src='images/green_check.png'>";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showEnterInfo(\"" + ar1[2] + "\",0,0,1);'>" + ar1[4] + "</a></td>");
					arr.push("<td class='left'>" + ar1[5] + "</td>");
					arr.push("<td class='left'>" + ar1[14] + ar1[15].substring(0,2) + "." + ar1[16] + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='left'>" + ar1[7] + "</td>");
					if(ar1[8]>0){
						arr.push("<td class='center'>" + imgChk + "</td>");	//补考
					}else{
						arr.push("<td class='center'>&nbsp;</td>");
					}
					arr.push("<td class='left'><input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + ar1[2] + "' name='visitstockchk'></td>");
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
	
	function setButton(){
		$("#save").hide();
		$("#del").hide();
		$("#doPasscard").hide();
		$("#doImportScore").hide();
		$("#sendMsgExam").hide();
		$("#sendMsgScore").hide();
		$("#startNo").prop("disabled",true);
		if(op==1){
			setEmpty();
			$("#save").show();
			//$("#save").focus();
		}else{
			if(checkPermission("studentAdd")){
				$("#save").show();
				$("#del").show();
				$("#doPasscard").show();
				$("#sendMsgExam").show();
				$("#sendMsgScore").show();
				$("#doImportScore").show();
			}
		}
	}
	
	function setEmpty(){
		//$("#title").val("中石化从业人员安全知识考核");
		$("#title").val("");
		$("#startDate").val(currDate);
		$("#qty").val(0);
		$("#startTime").val("15:00 - 16:00");
		$("#startNo").val(1);
		$("#address").val("黄兴路158号1182幢D103室");
		$("#notes").val("请务必携带身份证和准考证；迟到15分钟不得入场。");
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
				<td align="right">考试日期</td>
				<td><input class="mustFill" type="text" id="startDate" size="25" /></td>
				<td align="right">考试时间</td>
				<td><input class="mustFill" type="text" id="startTime" size="25" /></td>
			</tr>
			<tr>
				<td align="right">考试科目</td><input type="hidden" id="ID" /><input type="hidden" id="status" />
				<td><select id="certID" style="width:100%;"></select></td>
				<td align="right">人数</td>
				<td><input class="readOnly" type="text" id="qty" size="3" readOnly="true" />&nbsp;&nbsp;&nbsp;&nbsp;起始编号&nbsp;<input class="readOnly" type="text" id="startNo" size="3" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">场次标识</td>
				<td colspan="3"><input class="mustFill" type="text" id="title" style="width:70%;" />&nbsp;&nbsp;状态<input class="readOnly" type="text" id="statusName" size="5" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">考试地址</td>
				<td><input type="text" id="address" size="25" /></td>
				<td colspan="2">
					<span id="photo" style="margin-left:10px;"></span>
					<span id="list" style="margin-left:10px;"></span>
					<span id="sign" style="margin-left:10px;"></span>
					<span id="score" style="margin-left:10px;"></span>
					<span id="scoreResult" style="margin-left:10px;"></span>
				</td>
			</tr>
			<tr>
				<td align="right">注意事项</td>
				<td colspan="3"><input type="text" id="notes" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="right">备注</td>
				<td colspan="5"><input type="text" id="memo" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="right">制作日期</td>
				<td><input class="readOnly" type="text" id="regDate" size="25" readOnly="true" /></td>
				<td align="right">制作人</td>
				<td><input class="readOnly" type="text" id="registerName" size="25" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">考试通知</td>
				<td colspan="5">
					次数&nbsp;<input class="readOnly" type="text" id="send" size="2" readOnly="true" />&nbsp;&nbsp;
					日期&nbsp;<input class="readOnly" type="text" id="sendDate" size="6" readOnly="true" />&nbsp;&nbsp;
					发送人&nbsp;<input class="readOnly" type="text" id="senderName" size="5" readOnly="true" />&nbsp;&nbsp;
				</td>
			</tr>
			<tr>
				<td align="right">成绩通知</td>
				<td colspan="5">
					次数&nbsp;<input class="readOnly" type="text" id="sendScore" size="2" readOnly="true" />&nbsp;&nbsp;
					日期&nbsp;<input class="readOnly" type="text" id="sendScoreDate" size="6" readOnly="true" />&nbsp;&nbsp;
					发送人&nbsp;<input class="readOnly" type="text" id="senderScoreName" size="5" readOnly="true" />&nbsp;&nbsp;
				</td>
			</tr>
			</table>
			</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
		<input class="button" type="button" id="save" value="保存" />&nbsp;
		<input class="button" type="button" id="del" value="删除" />&nbsp;
		<input class="button" type="button" id="doPasscard" value="做准考证" />&nbsp;
		<input class="button" type="button" id="sendMsgExam" value="考试通知" />&nbsp;
		<input class="button" type="button" id="doImportScore" value="成绩导入" />&nbsp;
		<input class="button" type="button" id="sendMsgScore" value="成绩通知" />&nbsp;
		<input class="button" type="button" id="close" value="结束" />&nbsp;
  	</div>
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
	<div style="width:100%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:5px;background:#ffffff;line-height:18px;padding-left:20px;">
			<span>鉴定结果&nbsp;<select id="s_status" style="width:70px"></select></span>
			<span>&nbsp;&nbsp;申请补考&nbsp;<select id="s_resit" style="width:70px"></select></span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnSearch" value="查找" /></span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnSel" value="全选/取消" /></span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnResit" value="加入补考购物车" /></span>
		</div>
	</div>
	<hr size="1" noshadow />
	<div id="cover" style="float:top;margin:3px;background:#f8fff8;">
	</div>
</div>
</body>
