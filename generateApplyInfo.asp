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
	var updateCount = 0;
	var address = "";
    var certID = "";
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
		if(currHost==""){
			getComList("host","hostInfo","hostNo","title","status=0 and kindID=1 order by ID",1);
			getComList("courseID","v_courseInfo","courseID","shortName","status=0 and type=0 and agencyID not in(4,5) order by courseID",1);
		}else{
			getComList("host","hostInfo","hostNo","title","status=0 and kindID=1 and hostNo='" + currHost + "' order by ID",0);
			getComList("courseID","v_courseInfo a, hostCourseList b","a.courseID","a.shortName","a.courseID=b.courseID and a.status=0 and b.host='" + currHost + "' order by a.courseID",1);
		}
		$("#startDate").click(function(){WdatePicker();});
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
		$("#list").click(function(){
			//alert(nodeID+$("#courseName").val()+$("#reexamineName").val());
			outputExcelBySQL('x05','file',nodeID,$("#courseName").val(),$("#reexamineName").val());
		});
		$("#diplomaSign").click(function(){
			outputExcelBySQL('x06','file',nodeID,$("#courseName").val(),$("#reexamineName").val());
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
			jPrompt('发证日期:', currDate, '附加信息', function (r) {
				if (r>"" && isDate(r)) {
					showLoadFile("apply_score_list",$("#ID").val(),"studentList",'',r);
					updateCount += 1;
				}else{
					jAlert("请输入正确的发证日期");
				}
			});
		});
	
		$("#generateZip").click(function(){
			generateZip("m");
		});
	
		$("#generatePhotoZip").click(function(){
			generateZip("p");
		});

	  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		//alert(id);
		$.get("diplomaControl.asp?op=getGenerateApplyNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			var c = "";
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#ID").val(ar[0]);
				$("#courseID").val(ar[1]);
				$("#courseName").val(ar[2]);
				$("#title").val(ar[3]);
				$("#qty").val(ar[4]);
				$("#applyID").val(ar[5]);
				$("#startDate").val(ar[6]);
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
				certID = ar[31];
				$("#list").html("<a href=''>申报名单</a>");
				$("#diplomaSign").html("<a href=''>证书签收单</a>");
				if(ar[7] > ""){
					$("#sign").html("<a href='/users" + ar[7] + "' target='_blank'>申报结果</a>");
				}
				if(ar[17] > ""){
					$("#scoreResult").html("<a href='/users" + ar[17] + "' target='_blank'>成绩单</a>");
                    $("#diplomaSign").show();
				}else{
                    $("#diplomaSign").hide();
                }
				if(ar[33] > ""){
					$("#zip").html("<a href='/users" + ar[33] + "' target='_blank'>申报压缩包</a>");
				}
				if(ar[34] > ""){
					$("#zip").html("<a href='/users" + ar[34] + "' target='_blank'>照片压缩包</a>");
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
		if($("#startTime").val()==""){
			jAlert("请填写申报时间。");
			return false;
		}
		if($("#courseID").val()==""){
			jAlert("请选择申报科目。");
			return false;
		}
		//alert($("#studentID").val() + "&item=" + ($("#memo").val()));
		$.get("diplomaControl.asp?op=updateGenerateApplyInfo&nodeID=" + nodeID + "&refID=" + $("#courseID").val() + "&host=" + $("#host").val() + "&keyID=" + $("#applyID").val() + "&startDate=" + $("#startDate").val() + "&item=" + escape($("#title").val()) + "&address=" + escape($("#address").val()) + "&memo=" + escape($("#memo").val()) + "&times=" + (new Date().getTime()),function(re){
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
		if($("#needResit").attr("checked")){ need = 1;}
		$.get("diplomaControl.asp?op=getApplyListByBatch&refID=" + nodeID + "&status=" + $("#s_status").val() + "&keyID=" + $("#s_resit").val() + "&needResit=" + need + "&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#cover").empty();
			arr = [];		
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='cardTab' width='100%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='4%'>No</th>");
			arr.push("<th width='9%'>学号</th>");
			arr.push("<th width='10%'>身份证</th>");
			arr.push("<th width='8%'>姓名</th>");
			arr.push("<th width='16%'>单位</th>");
			arr.push("<th width='10%'>电话</th>");
			arr.push("<th width='8%'>申报</th>");
			arr.push("<th width='12%'>考试时间</th>");
			arr.push("<th width='8%'>成绩</th>");
			arr.push("<th width='8%'>结果</th>");
			arr.push("<th width='8%'>补考</th>");
			arr.push("<th width='2%'></th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var c = 0;
				var h = "";
				var k = 0;
				var s = $("#status").val();
				var imgChk = "<img src='images/green_check.png'>";
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					c = 0;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='left'>" + ar1[22] + "</td>");
					arr.push("<td class='link1'><a href='javascript:showEnterInfo(\"" + ar1[2] + "\",\"" + ar1[4] + "\",0,1);'>" + ar1[4] + "</a></td>");
					arr.push("<td class='link1'><a href='javascript:showStudentInfo(0,\"" + ar1[4] + "\",0,1);'>" + ar1[5] + "</a></td>");
					arr.push("<td class='left' title='" + ar1[13] + "." + ar1[14] + "'>" + ar1[13].substring(0,12) + "</td>");
					arr.push("<td class='left'>" + ar1[6] + "</td>");
					arr.push("<td class='left'>" + ar1[17] + "</td>");
					arr.push("<td class='left'>" + ar1[18] + "</td>");
                    h = ar1[19];
                    if(certID=="C12" || certID=="C14" || certID=="C15" || certID=="C24" || certID=="C25" || certID=="C26" || c == "C25B" || c == "C26B"){
                        h = ar1[20].replace(".00","") + "/" + ar1[21].replace(".00","");
                    }
					arr.push("<td class='left'>" + h + "</td>");
					arr.push("<td class='left'>" + ar1[9] + "</td>");
					if(ar1[7]>0){
						arr.push("<td class='center'>" + imgChk + "</td>");	//补考
					}else{
						arr.push("<td class='center'>&nbsp;</td>");
					}
					if(s==0){
						k = ar1[0];
					}else{
						k = ar1[2];
					}
					arr.push("<td class='left'><input style='BORDER-TOP-STYLE: none; BORDER-RIGHT-STYLE: none; BORDER-LEFT-STYLE: none; BORDER-BOTTOM-STYLE: none' type='checkbox' value='" + k + "' name='visitstockchk'></td>");
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
	
	function setButton(){
		var s = $("#status").val();
		$("#save").hide();
		$("#del").hide();
		$("#lock").hide();
		$("#close").hide();
		$("#open").hide();
		$("#doImportApply").hide();
		$("#doImportScore").hide();
		$("#sendMsgExam").hide();
		$("#sendMsgScore").hide();
		$("#sendMsgDiploma").hide();
		$("#btnRemove").hide();
		$("#btnResit").hide();
		$("#s_needResit").hide();
		if(op==1){
			setEmpty();
			$("#save").show();
			//$("#save").focus();
		}else{
			if(checkPermission("studentAdd")){
				if(s==0){		//考前可以删除申报、调整人员
					$("#save").show();
					$("#del").show();
					$("#lock").show();
					$("#btnRemove").show();
				}
				if(s==1){		//锁定后可以导入申报结果，发考试通知，上传成绩，发成绩通知，安排补考
					$("#save").show();
					$("#doImportApply").show();
					$("#sendMsgExam").show();
                    if($("#sign").html()>""){
                        $("#btnResit").show();
                    }
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
				}
			}
			if(checkPermission("scoreUpload") && s == 1){
				$("#doImportScore").show();
			}
			if(checkPermission("examOpen") && s > 0){
				$("#open").show();
			}
		}
	}
	
	function setEmpty(){
		//$("#title").val("中石化从业人员安全知识考核");
		$("#title").val("");
		$("#startDate").val(currDate);
		$("#qty").val(0);
		$("#address").val("黄兴路158号D103");
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
				<td align="right">申报日期</td>
				<td><input class="mustFill" type="text" id="startDate" size="25" /></td>
				<td align="right">申报科目</td><input type="hidden" id="ID" /><input type="hidden" id="status" />
				<td><select id="courseID" style="width:100%;"></select></td><input type="hidden" id="courseName" /><input type="hidden" id="reexamineName" />
			</tr>
			<tr>
				<td align="right">申报标识</td>
				<td colspan="3"><input class="mustFill" type="text" id="title" style="width:70%;" />&nbsp;&nbsp;状态<input class="readOnly" type="text" id="statusName" size="5" readOnly="true" /></td>
			</tr>
			<tr>
				<td align="right">申报批号</td>
				<td><input type="text" id="applyID" size="25" /></td>
				<td colspan="2">
					<span id="list" style="margin-left:10px;"></span>
					<span id="sign" style="margin-left:10px;"></span>
					<span id="scoreResult" style="margin-left:10px;"></span>
					<span id="diplomaSign" style="margin-left:10px;"></span>
					<span id="zip" style="margin-left:10px;"></span>
					<span id="pzip" style="margin-left:10px;"></span>
				</td>
			</tr>
			<tr>
				<td align="right">属性</td>
				<td><select id="host" style="width:180px;"></select></td>
				<td align="right">考试地址</td>
				<td><input type="text" id="address" style="width:100%;" /></td>
			</tr>
			<tr>
				<td align="right">申报结果</td>
				<td colspan="3">
					人数：<span id="qty" style="margin-left:10px;"></span>
					待定：<span id="qtyNull" style="margin-left:10px;"></span>
					通过：<span id="qtyYes" style="margin-left:10px;"></span>
					未通过<span id="qtyNo" style="margin-left:10px;"></span>
				</td>
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
			</table>
			</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  	<div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
		<input class="button" type="button" id="save" value="保存" />&nbsp;
		<input class="button" type="button" id="del" value="删除" />&nbsp;
		<input class="button" type="button" id="doImportApply" value="考试安排导入" />&nbsp;
		<input class="button" type="button" id="sendMsgExam" value="考试通知" />&nbsp;
		<input class="button" type="button" id="doImportScore" value="成绩证书导入" />&nbsp;
		<input class="button" type="button" id="sendMsgScore" value="成绩通知" />&nbsp;
		<input class="button" type="button" id="generateZip" value="生成申报压缩包" />&nbsp;
		<input class="button" type="button" id="generatePhotoZip" value="生成照片压缩包" />&nbsp;
		<input class="button" type="button" id="lock" value="锁定" />&nbsp;
		<input class="button" type="button" id="close" value="结束" />&nbsp;
		<input class="button" type="button" id="open" value="开启" />&nbsp;
		<a href="output/申报结果模板.xlsx">考试安排模板</a>&nbsp;&nbsp;
		<a href="output/成绩证书模板.xlsx">成绩证书模板</a>
  	</div>
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
	<div style="width:100%;float:left;margin:0;">
		<div style="border:solid 1px #e0e0e0;width:99%;margin:5px;background:#ffffff;line-height:18px;padding-left:20px;">
			<span>申报结果&nbsp;<select id="s_status" style="width:70px"></select></span>
			<span>&nbsp;&nbsp;申请补考&nbsp;<select id="s_resit" style="width:70px"></select></span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnSearch" value="查找" /></span>
			<span id="s_needResit"><input style="border:0px;" type="checkbox" id="needResit" value="" />&nbsp;需补考&nbsp;</span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnSel" value="全选/取消" /></span>
			<span>&nbsp;&nbsp;<input class="button" type="button" id="btnRemove" value="移出名单" /></span>
            <span>&nbsp;&nbsp;<input class="button" type="button" id="btnResit" value="加入补考购物车" /></span>
            <span>&nbsp;&nbsp;<input class="button" type="button" id="sendMsgDiploma" value="领证通知" /></span>
		</div>
	</div>
	<hr size="1" noshadow />
	<div id="cover" style="float:top;margin:3px;background:#f8fff8;">
	</div>
</div>
</body>
