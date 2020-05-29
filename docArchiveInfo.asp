<!--#include file="js/doc.js" -->

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/nav.dwt" codeOutsideHTMLIsLocked="false" -->
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

<title></title>

<link href="css/style_inner1.css"  rel="stylesheet" type="text/css" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/data_table.css" rel="stylesheet" type="text/css" />
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link href="css/asyncbox/asyncbox.css" type="text/css" rel="stylesheet" />
<script language="javascript" src="js/jquery-1.7.2.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script type="text/javascript" src="js/AsyncBox.v1.4.js"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var nodeID = "";
	var refID = "";
	var kindID = "archive";
	var op = 0;
	var updateCount = 0;
	var chk = 0;
	<!--#include file="js/commFunction.js"-->
	
	$(document).ready(function (){
		nodeID = "<%=nodeID%>";
		refID = "<%=refID%>";
		op = "<%=op%>";
		getDicList("status","",0);
		$("#dateArchive").click(function(){WdatePicker();});

    $.ajaxSetup({ 
  		async: false 
  	}); 
		if(nodeID==0 && op!=1 && refID>0){		//根据项目查找对应的
			$.get("docArchiveControl.asp?op=getIDbyProject&refID=" + refID + "&times=" + (new Date().getTime()),function(data){
				nodeID = unescape(data);
			});
		}
		if(op==1){
			if(refID>0){
				$("#refID").val(refID);
				$.get("projectControl.asp?op=getNodeInfo&nodeID=" + refID + "&times=" + (new Date().getTime()),function(re){
					//jAlert(unescape(re));
					var ar = new Array();
					ar = unescape(re).split("|");
					if(ar > ""){
						$("#projectID").val(ar[0]);
						$("#projectName").val(ar[1]);
						$("#engineeringID").val(ar[20]);
						chk = checkPermission("CA",$("#projectID").val());
					}
				});
			}
			setButton();
		}
		if(op!=1){
			getNodeInfo(nodeID);
		}

		$("#addNew").click(function(){
			op = 1;
			setButton();
		});

		$("#save").click(function(){
			//alert($("#docArchiveID").val() + "&refID=" + $("#refID").val() + "&dateReceive=" + $("#dateReceive").val() + "&kindID=" + $("#docKind").val() + "&docType=" + ($("#docType").val()) + "&status=" + $("#status").val() + "&page=" + $("#page").val() + "&title=" + ($("#title").val()) + "&item=" + ($("#item").val()) + "&memo=" + ($("#memo").val()));
			$.get("docArchiveControl.asp?op=update&nodeID=" + $("#docArchiveID").val() + "&refID=" + $("#projectID").val() + "&status=" + $("#status").val() + "&dateArchive=" + $("#dateArchive").val() + "&docNo=" + escape($("#docNo").val()) + "&item1=" + escape($("#item1").val()) + "&item2=" + escape($("#item2").val()) + "&item3=" + escape($("#item3").val()) + "&memo=" + escape($("#memo").val()) + "&regDate=" + $("#regDate").val() + "&regOperator=" + escape($("#regOperator").val()) + "&times=" + (new Date().getTime()),function(re){
				//jAlert(unescape(re));
				var ar = new Array();
				ar = unescape(re).split("|");
				if(ar[0] == 0){
					jAlert("保存成功！","信息提示");
					updateCount += 1;
					nodeID = ar[1];
					getNodeInfo(ar[1]);
				}
				if(ar[0] == 1){
					jAlert("资料类型不能为空。","信息提示");
					//$("#docKind").focus();
				}
				if(ar[0] == 2){
					jAlert("资料名称不能为空。","信息提示");
					//$("#title").focus();
				}
				if(ar[0] == 3){
					jAlert("资料内容不能为空。","信息提示");
					//$("#item").focus();
				}
				if(ar[0] == 9){
					jAlert("该项目中已经有归档目录，不能增加新的。","信息提示");
				}
			});
			return false;
		});

		$("#del").click(function(){
			jConfirm('你确定要删除这个项目吗?', '确认对话框', function(r) {
				if(r){
					$.get("docArchiveControl.asp?op=delNode&nodeID=" + $("#docArchiveID").val() + "&times=" + (new Date().getTime()),function(data){
						jAlert("删除成功！","信息提示");
						op = 1;
						setButton();
						updateCount += 1;
					});
				}
			});
		});
		
  	<!--#include file="commLoadFileReady.asp"-->
	});

	function getNodeInfo(id){
		$.get("docArchiveControl.asp?op=getNodeInfo&nodeID=" + id + "&times=" + (new Date().getTime()),function(re){
			//jAlert(unescape(re));
			var ar = new Array();
			ar = unescape(re).split("|");
			if(ar > ""){
				$("#docArchiveID").val(ar[0]);
				$("#docNo").val(ar[4]);
				$("#status").val(ar[2]);
				$("#item1").val(ar[4]);
				$("#item2").val(ar[5]);
				$("#item3").val(ar[6]);
				$("#dateArchive").val(ar[7]);
				$("#memo").val(ar[8]);
				$("#regDate").val(ar[9]);
				$("#regOperator").val(ar[10]);
				$("#registorName").val(ar[11]);
				$("#projectID").val(ar[12]);
				$("#projectName").val(ar[13]);
				$("#contractNo").val(ar[16]);
				$("#unitOwnerName").val(ar[18]);
				chk = checkPermission("CA",$("#projectID").val());
				op = 0;
				getDownloadFile("docArchiveID");
				getAttachDocList();
				setButton();
			}else{
				//jAlert("该项目信息未找到！","信息提示");
				setEmpty();
				setButton();
			}
		});
	}

	function getAttachDocList(){
		//alert(kindID+":"+nodeID);
		$.get("attachDocControl.asp?op=getAttachDocListByWhere&kindID=" + kindID + "&status=0&refID=" + nodeID + "&engineeringID=&projectID=&dk=11&times=" + (new Date().getTime()),function(data){
			//jAlert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#attachDocCover").empty();
			var ar0 = new Array();
			ar0 = ar.shift().split("|");
			floatCount = ar0[0];
			floatSum = "";
			arr = [];
			ar.shift();					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='attachDocTab' width='98%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='2%'>No</th>");
			arr.push("<th width='58%'>立卷材料排列次序</th>");
			arr.push("<th width='20%'>卷次</th>");
			arr.push("<th width='20%'>页数</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(ar>""){
				var i = 0;
				var tn = "attachDocInfo";
				var tc = "left";
				var tc1 = "link1";
				if(chk){
					tc = "editable"; 
					//tc1 = "editable";
				}
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					arr.push("<tr class='grade0'>");
					arr.push("<td width='2%' class='center'>" + i + "</td>");
					arr.push("<td width='58%' class='" + tc1 + "' align='left'><a href='javascript:showAttachDocInfo(\"" + ar1[0] + "\"," + ar1[1] + ",\"" + ar1[4] + "\",0,1);'>" + ar1[7] + "</a></td>");
					arr.push("<td width='20%' class='" + tc + "' align='left' alt='" + tn + "|item|" + ar1[0] + "|1'>" + ar1[8] + "</td>");
					arr.push("<td width='20%' class='" + tc + "' align='center' alt='" + tn + "|page|" + ar1[0] + "|1'>" + ar1[9] + "</td>");
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
			arr.push("</tr>");
			arr.push("</tfoot>");
			arr.push("</table>");
			$("#attachDocCover").html(arr.join(""));
			arr = [];
			$("#attachDocTab").dataTable({
				"aaSorting": [],
				"bFilter": false,
				"bPaginate": false,
				"bLengthChange": false,
				"bInfo": false,
				"aoColumnDefs": []
			});
			floatCount = i;
			floatTitle = "";	//excel file's title in the 1st row, if it's blank then keep the excel's present one.
			floatItem = "";		//write to excel file's 2nd row
			floatLog = "打印日期：" + currDate + "&nbsp;&nbsp;&nbsp;&nbsp;打印人：" + currUserName;		//write to excel file's 3rd row
			floatKey = "";		//
			floatContent = "";	//records data for output
			floatModel = 1;
			<!--#include file="js/commTabEdit.js"-->
		});
	}
	
	function getValList(){
		var s = "";
		s = "文件" + floatCount + "项  归档日期" + $("#dateArchive").val();
		return s;
	}
	
	function setButton(){
		//alert(op + ":" + $("#regOperator").val() + ":" + $("#projectID").val());
		$("#status").attr("disabled",true);
		$("#save").hide();
		$("#del").hide();
		$("#addNew").hide();
		$("#btnLoadFile").attr("disabled",true);
		if(op ==1){
			setEmpty();
			$("#save").show();
		}
		if(op ==0){
			if(chk){
				$("#addNew").show();
			}
			if(chk && $("#docArchiveID").val()>0){
				$("#save").show();
				$("#del").show();
				$("#btnLoadFile").attr("disabled",false);
			}
		}
	}
	
	function setEmpty(){
		$("#docArchiveID").val(0);
		$("#status").val(0);
		$("#docNo").val("");
		$("#item1").val("");
		$("#item2").val("");
		$("#item3").val("");
		$("#dateArchive").val("");
		$("#memo").val("");
		$("#regDate").val(currDate);
		$("#regOperator").val(currUser);
		$("#registorName").val(currUserName);
		$("#downloadFile_docArchiveID").html("");
	}
	
	function getUpdateCount(){
		//parent.$.close("orderteam");
		return updateCount;
	}
</script>

</head>

<body style="background:#f0f0f0;">
 <!--#include file='commFloatDetail.asp' -->
 <!--#include file='commLoadFileDetail.asp' -->

<div id='layout' align='left' style="background:#f0f0f0;">	
	
	<div style="width:100%;float:left;margin:0;">
		<div style="bdocArchive:solid 1px #e0e0e0;width:99%;margin:1px;background:#ffffff;line-height:18px;">
			<div class="comm" style="background:#f5faf8;">
				<form id="detailCover" name="detailCover" style="width:98%;float:right;margin:1px;padding-left:2px;background:#eefaf8;">
					<table>
          <tr>
          	<td align="right">合同编号</td><input id="docArchiveID" type="hidden" />
          	<td><input class="readOnly" type="text" id="contractNo" size="15" readOnly="true" /></td>
          	<td align="right">&nbsp;&nbsp;项目名称</td><input id="projectID" type="hidden" /><input id="engineeringID" type="hidden" />
          	<td colspan="2"><input class="readOnly" type="text" id="projectName" size="35" readOnly="true" /></td>
          </tr>
          <tr>
          	<td align="right">档案编号</td>
          	<td><input type="text" id="docNo" size="15" /></td>
          	<td align="right">委托单位</td>
          	<td colspan="2"><input class="readOnly" type="text" id="unitOwnerName" size="35" readOnly="true" /></td>
          </tr>
          <tr>
          	<td align="right">成果序号</td>
          	<td><input type="text" id="item1" size="15" /></td>
          	<td align="right">成果文件</td>
          	<td><input type="text" id="item2" size="15" /></td>
          	<td align="right">状态</td>
          	<td><select id="status" style="width:90px"></select></td>
          </tr>
          <tr>
          	<td align="right">归档日期</td>
          	<td><input type="text" id="dateArchive" size="15" /></td>
          	<td align="right">归档缺项</td>
          	<td><input type="text" id="item3" size="15" /></td>
          	<td colspan="2">备注<input type="text" id="memo" size="38" /></td>
          </tr>
          <tr>
          	<td align="right">登记日期</td>
          	<td><input class="readOnly" type="text" id="regDate" size="15" readOnly="true" /></td>
          	<td align="right">登记人</td><input type="hidden" id="regOperator" />
          	<td><input class="readOnly" type="text" id="registorName" size="10" readOnly="true" /></td>
          	<td align="right">&nbsp;</td>
          	<td align="right">&nbsp;</td>
          </tr>
          <tr>
            <td colspan="6">
							<div style="bdocArchive:solid 1px #e0e0e0;width:99%;margin:1px;background:#AAAAFF;line-height:18px;">
								<span style="padding-left:10px;"><input class="button" id="btnLoadFile" onClick="showLoadFile('docArchiveID',0)" type="button" value="附件上传" /></span>
					      <span id="downloadFile_docArchiveID">&nbsp;</span>
					    </div>
            </td>
          </tr>
        	</table>
				</form>
			</div>
		</div>
	</div>
	
	<div style="width:100%;float:left;margin:10;height:4px;"></div>
  <div class="comm" align="center" style="width:99%;float:top;margin:1px;background:#fccffc;">
  	<input class="button" type="button" id="save" name="save" value="保存" />&nbsp;&nbsp;&nbsp;
  	<input class="button" type="button" id="addNew" name="addNew" value="新增" />&nbsp;&nbsp;&nbsp;
  	<input class="button" type="button" id="del" name="del" value="删除" />
  </div>
	
	<div id="attachDocCover" style="float:top;width:99%;margin:0px;background:#f8fff8;">
	</div>
</div>
</body>
