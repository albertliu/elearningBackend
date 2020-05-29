<!--#include file="js/doc.js" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title><%=pageTitle%></title>
<link href="css/style_main.css"  rel="stylesheet" type="text/css" />
<link type="text/css" href="css/jquery-ui-1.7.2.custom.css" rel="stylesheet" />	
<link href="css/jquery.alerts.css" rel="stylesheet" type="text/css" media="screen" />
<link rel="stylesheet" type="text/css" href="css/easyui/easyui.css">
<link rel="stylesheet" type="text/css" href="css/easyui/icon.css">
<link href="css/data_table.css" rel="stylesheet" type="text/css" />
        <link rel="stylesheet" href="css/jquery.tabs.css" type="text/css" media="print, projection, screen">
        <!-- Additional IE/Win specific style sheet (Conditional Comments) -->
        <!--[if lte IE 7]>
        <link rel="stylesheet" href="css/jquery.tabs-ie.css" type="text/css" media="projection, screen">
        <![endif]-->
<link href="css/ddaccordion.css" rel="stylesheet" type="text/css" />
	<link rel="stylesheet" href="css/emx_nav_left.css" type="text/css">
<script language="javascript" src="js/jquery-1.4.2.min.js"></script>
<script language="javascript" src="js/jquery.form.js"></script>
<script type="text/javascript" src="js/jquery.easyui.min.js"></script>
<script type="text/javascript" src="js/jquery.easing.min.js"></script>
<script type="text/javascript" src="js/jquery-ui-1.7.2.custom.min.js"></script>
<script language="javascript" type="text/javascript" src="js/jquery.dataTables.min.js"></script>
        <script src="js/jquery.history_remote.pack.js" type="text/javascript"></script>
        <script src="js/jquery.tabs.pack.js" type="text/javascript"></script>
<script src="js/jquery.floatDiv.js" type="text/javascript"></script>
<script src="js/jquery.alerts.js" type="text/javascript"></script>
<script src="js/jquery.barcode.min.js" type="text/javascript"></script>
<script src="js/datepicker/WdatePicker.js" type="text/javascript"></script>
<script src="js/ddaccordion.js" type="text/javascript"></script>
<!--#include file="js/correctPng.js"-->
<!--#include file="js/clickMenu.js"-->

<script language="javascript">
	var seeAll = 0;
	var dMark = 0;
	var dUser = "";
	var dItem = "";
	var dType = "";
	var dKind = "";
	var dStartDate = "";
	var dEndDate = "";
	var dGroupType = "11";
		
ddaccordion.init({
	headerclass: "silverheader", //Shared CSS class name of headers group
	contentclass: "submenu", //Shared CSS class name of contents group
	revealtype: "click", //Reveal content when user clicks or onmouseover the header? Valid value: "click", "clickgo", or "mouseover"
	mouseoverdelay: 200, //if revealtype="mouseover", set delay in milliseconds before header expands onMouseover
	collapseprev: true, //Collapse previous content (so only one open at any time)? true/false
	defaultexpanded: [1], //index of content(s) open by default [index1, index2, etc] [] denotes no content
	onemustopen: true, //Specify whether at least one header should be open always (so never all headers closed)
	animatedefault: false, //Should contents open by default be animated into view?
	persiststate: true, //persist state of opened contents within browser session?
	toggleclass: ["", "selected"], //Two CSS classes to be applied to the header when it's collapsed and expanded, respectively ["class1", "class2"]
	togglehtml: ["", "", ""], //Additional HTML added to the header when it's collapsed and expanded, respectively  ["position", "html1", "html2"] (see docs)
	animatespeed: "fast", //speed of animation: integer in milliseconds (ie: 200), or keywords "fast", "normal", or "slow"
	oninit:function(headers, expandedindices){ //custom code to run when headers have initalized
		//do nothing
	},
	onopenclose:function(header, index, state, isuseractivated){ //custom code to run whenever a header is opened or closed
		//do nothing
	}
})
		
	<!--#include file="js/commFunction.js"-->

	$(document).ready(function () {
  	currPage = "rptPage";
  	setCurrMenuItem();
		//$('#container-1').tabs({ fxAutoHeight: true });
		//$('#container-1').disableTab(4); // disables third tab
		if(checkPermission("seeAll")){seeAll = 1;}
		
		window.setInterval(function () {
			//refreshStatInfo();
    }, 30000);
    
    $("input[name='sType1']").click(function(){
  	    getRptList();
    });
    //$("#sStartDate").click(function(){WdatePicker();});
    //$("#sEndDate").click(function(){WdatePicker();});
    
    //showDailyStat();
    //getOperatorList();
    setSearchPanel(0);
    getKindList();
	});
	
	function showDailyStat(){
		setSearchPanel(99);
		setMap("今日统计");
		getDailyStat();
		return false;
	}
	
	function setSearchPanel(pItem){
		$("#searchPanel0").hide();
		$("#searchPanel1").hide();
		$("#searchPanel" + pItem).show();
	}
	
	function getKindList(){
		$.get("rptControl.asp?op=getKindList&times=" + (new Date().getTime()),function(re){
			var ar = new Array();
			ar = unescape(re).split("%%");
			//alert(ar);
			$("#reportList").empty();
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					$("<li><a href='#this' onclick='showRptList(\"" + ar1[0] + "\"," + ar1[1] + ",\"" + ar1[2] + "\",\"" + ar1[3] + "\")'><span>" + ar1[2] + "</span></a></li>").appendTo("#reportList");
				});
			}
		});
	}
	
	function showRptList(kindID,type,title,groupType){
		dKind = kindID;		//报表类型
		dType = type;			//报表数据类型
		dGroupType = groupType;		//明细及汇总数据
		dItem = title;
		setMap(title);
		getRptList();
    setSearchPanel(1);
	}
	
	function getRptList(){
		dMark = $("input[name='sType1']:checked").val();
		$.get("rptControl.asp?op=getRptList" + dType + "&kindID=" + dKind + "&mark=" + dMark + "&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#resultCover").empty();
			var s = "";					
			s += "<table cellpadding='0' cellspacing='0' border='0' class='display' id='archivesTab' width='95%'>";
			s += "<thead>";
			s += "<tr align='center'>";
			s += "<th width='5%'>No</th>";
			s += "<th align='center' width='24%'>项目名称</th>";
			if(dType==1){		//出入库
				s += "<th width='24%'>起止日期</th>";
				s += "<th width='9%'>代保管</th>";
				s += "<th width='9%'>自管</th>";
				s += "<th width='9%'>邮寄</th>";
			}
			if(dType==2){		//收费
				s += "<th width='24%'>起止日期</th>";
				s += "<th width='9%'>现金</th>";
				s += "<th width='9%'>支票</th>";
				s += "<th width='9%'>转账</th>";
			}
			if(dType==3){		//库存
				s += "<th width='24%'>截止日期</th>";
				s += "<th width='9%'>代保管</th>";
				s += "<th width='9%'>自管</th>";
				s += "<th width='9%'>邮寄</th>";
			}
			s += "<th width='9%'>合计</th>";
			s += "<th width='11%'>查看</th>";
			s += "</tr>";
			s += "</thead>";
			s += "<tbody id='tbody'>";
			var i = 0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					s += "<tr class='grade0'>";
					s += "<td width='5%' class='center'>" + i + "</td>";
					s += "<td width='24%' class='left'>" + ar1[1] + "</td>";
					if(ar1[2]==""){
						s += "<td width='24%' class='center'>" + nullNoDisp(ar1[3]) + "</td>";
					}else{
						s += "<td width='24%' class='center'>" + nullNoDisp(ar1[2]) + " - " + nullNoDisp(ar1[3]) + "</td>";
					}
					s += "<td width='9%' class='right'>" + nullNoDisp(ar1[4]) + "</td>";
					s += "<td width='9%' class='right'>" + nullNoDisp(ar1[5]) + "</td>";
					s += "<td width='9%' class='right'>" + nullNoDisp(ar1[6]) + "</td>";
					s += "<td width='9%' class='right'>" + nullNoDisp(ar1[7]) + "</td>";
					s += "<td width='11%' class='link1'>";
					if(dGroupType.substr(0,1)=="1"){
						s += "<a href='javascript:showRptDetail(0,\"" + ar1[0] + "\",\"" + ar1[2] + "\",\"" + ar1[3] + "\",\"" + ar1[1] + "\");'>明细</a>";
					}
					if(dGroupType.substr(1,1)=="1"){
						s += "&nbsp;&nbsp;<a href='javascript:showRptDetail(1,\"" + ar1[0] + "\",\"" + ar1[2] + "\",\"" + ar1[3] + "\",\"" + ar1[1] + "\");'>汇总</a>";
					}
					s += "</td>";
					s += "</tr>";
				});
			}
			s += "</tbody>";
			s += "<tfoot>";
			s += "<tr>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "</tr>";
			s += "</tfoot>";
			s += "</table>";
			$("#resultCover").html(s);
			$('#archivesTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"bInfo": true,
				"aoColumnDefs": []
			});
			floatCount = i;
			floatSum = "";
			floatTitle = dItem;
			floatItem = "";
			floatLog = "打印日期：" + currDate + "&nbsp;&nbsp;&nbsp;&nbsp;打印人：" + currUserName;
			floatKind = "getRptList" + dType;
			floatKey = "";
		});
	}
	
	function showRptDetail(group,nodeID,sDate,eDate,item){
		//dStartDate = sDate;
		//dEndDate = eDate;
		//alert(nodeID);
		if(dType==1){		//出入库报表
			if(group==0){	//明细
				floatContent = getRptDetailList1(nodeID);
			}else{				//汇总
				floatContent = getRptGroupList1(nodeID);
			}
		}
		if(dType==2){		//收费报表
			if(group==0){	//明细
				floatContent = getRptDetailList2(nodeID);
			}else{				//汇总
				floatContent = getRptGroupList2(nodeID);
			}
		}
		if(dType==3){		//库存报表
			if(group==0){	//明细
				floatContent = getRptDetailList3(nodeID);
			}else{				//汇总
				floatContent = getRptGroupList3(nodeID);
			}
		}
		floatTitle = item;
		floatItem = "";
		if(sDate>""){
			floatItem += "起始日期：" + sDate;
		}
		if(eDate>""){
			if(floatItem==""){
				floatItem += "截止日期：" + eDate;
			}else{
				floatItem += "&nbsp;&nbsp;&nbsp;&nbsp;截止日期：" + eDate;
			}
		}
		floatLog = "打印日期：" + currDate + "&nbsp;&nbsp;&nbsp;&nbsp;打印人：" + currUserName;
		if(group==0){	//明细
			floatKind = "getRptDetailList" + dType;
		}else{				//汇总
			floatKind = "getRptGroupList" + dType;
		}
		floatKey = "";
		showFloatCover();
	}

	function getRptDetailList1(nodeID){
		//出入库报表明细
		var s = "";	
		$.get("rptControl.asp?op=getRptDetailList1&nodeID=" + nodeID + "&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			s += "<table cellpadding='0' cellspacing='0' border='0' class='display' id='floatTab' width='95%'>";
			s += "<thead>";
			s += "<tr>";
			s += "<th width='8%'>No.</th>";
			s += "<th width='25%'>档案编号</th>";
			s += "<th width='13%'>姓名</th>";
			s += "<th width='15%'>库存位置</th>";
			s += "<th width='15%'>操作日期</th>";
			s += "<th width='13%'>操作人</th>";
			s += "<th width='11%'>类型</th>";
			s += "</tr>";
			s += "</thead>";
			s += "<tbody id='tbody'>";
			var i=0;
			var sum = 0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					//sum += parseInt(ar1[3]);
					s += "<tr class='grade" + ar1[7] + "'>";
					s += "<td width='8%' class='center'>" + i + "</td>";
					s += "<td width='25%' class='left'>" + ar1[1] + "</td>";
					s += "<td width='13%' class='left'>" + ar1[2] + "</td>";
					s += "<td width='15%' class='left'>" + ar1[3] + "</td>";
					s += "<td width='15%' class='left'>" + ar1[4] + "</td>";
					s += "<td width='13%' class='left'>" + ar1[5] + "</td>";
					s += "<td width='11%' class='left'>" + ar1[6] + "</td>";
					s += "</tr>";
				});
			}
			s += "</tbody>";
			s += "<tfoot>";
			s += "<tr>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "</tr>";
			s += "</tfoot>";
			s += "</table>";
			floatCount = i;
			floatSum = "合计数量：" + i;
		});
		return s;
	}

	function getRptGroupList1(nodeID){
		//出入库报表汇总
		var s = "";	
		$.get("rptControl.asp?op=getRptGroupList1&nodeID=" + nodeID + "&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			s += "<table cellpadding='0' cellspacing='0' border='0' class='display' id='floatTab' width='95%'>";
			s += "<thead>";
			s += "<tr>";
			s += "<th width='10%'>No.</th>";
			s += "<th width='30%'>操作人</th>";
			s += "<th width='15%'>类型</th>";
			s += "<th width='15%'>档案数量</th>";
			s += "<th width='30%'>最后操作日期</th>";
			s += "</tr>";
			s += "</thead>";
			s += "<tbody id='tbody'>";
			var i=0;
			var sum = 0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					sum += parseInt(ar1[3]);
					s += "<tr class='grade" + ar1[0] + "'>";
					s += "<td width='10%' class='center'>" + i + "</td>";
					s += "<td width='30%' class='left'>" + ar1[1] + "</td>";
					s += "<td width='15%' class='left'>" + ar1[2] + "</td>";
					s += "<td width='15%' class='left'>" + ar1[3] + "</td>";
					s += "<td width='30%' class='left'>" + ar1[4] + "</td>";
					s += "</tr>";
				});
			}
			s += "</tbody>";
			s += "<tfoot>";
			s += "<tr>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "</tr>";
			s += "</tfoot>";
			s += "</table>";
			floatCount = i;
			floatSum = "合计数量：" + sum;
		});
		return s;
	}

	function getRptDetailList2(nodeID){
		//收费报表明细
		var s = "";	
		$.get("rptControl.asp?op=getRptDetailList2&nodeID=" + nodeID + "&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			s += "<table cellpadding='0' cellspacing='0' border='0' class='display' id='floatTab' width='95%'>";
			s += "<thead>";
			s += "<tr>";
			s += "<th width='6%'>No.</th>";
			s += "<th width='15%'>收费日期</th>";
			s += "<th width='25%'>单位名称</th>";
			s += "<th width='10%'>收款人</th>";
			s += "<th width='10%'>金额</th>";
			s += "<th width='8%'>类型</th>";
			s += "<th width='13%'>凭证号码</th>";
			s += "<th width='13%'>发票号码</th>";
			s += "</tr>";
			s += "</thead>";
			s += "<tbody id='tbody'>";
			var i=0;
			var sum = 0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					sum += parseInt(ar1[4]);
					s += "<tr class='grade" + ar1[0] + "'>";
					s += "<td width='6%' class='center'>" + i + "</td>";
					s += "<td width='15%' class='left'>" + ar1[1] + "</td>";
					s += "<td width='25%' class='left'>" + ar1[2] + "</td>";
					s += "<td width='10%' class='left'>" + ar1[3] + "</td>";
					s += "<td width='10%' class='left'>" + ar1[4] + "</td>";
					s += "<td width='8%' class='left'>" + ar1[5] + "</td>";
					s += "<td width='13%' class='left'>" + ar1[6] + "</td>";
					s += "<td width='13%' class='left'>" + ar1[7] + "</td>";
					s += "</tr>";
				});
			}
			s += "</tbody>";
			s += "<tfoot>";
			s += "<tr>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "</tr>";
			s += "</tfoot>";
			s += "</table>";
			floatCount = i;
			floatSum = "合计金额：" + sum;
		});
		return s;
	}

	function getRptGroupList2(nodeID){
		//收费报表汇总
		var s = "";	
		$.get("rptControl.asp?op=getRptGroupList2&nodeID=" + nodeID + "&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			s += "<table cellpadding='0' cellspacing='0' border='0' class='display' id='floatTab' width='95%'>";
			s += "<thead>";
			s += "<tr>";
			s += "<th width='10%'>No.</th>";
			s += "<th width='30%'>操作人</th>";
			s += "<th width='15%'>支付类型</th>";
			s += "<th width='15%'>收费金额</th>";
			s += "<th width='30%'>最后操作日期</th>";
			s += "</tr>";
			s += "</thead>";
			s += "<tbody id='tbody'>";
			var i=0;
			var sum = 0;
			if(ar>""){
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					sum += parseInt(ar1[3]);
					s += "<tr class='grade" + ar1[0] + "'>";
					s += "<td width='10%' class='center'>" + i + "</td>";
					s += "<td width='30%' class='left'>" + ar1[1] + "</td>";
					s += "<td width='15%' class='left'>" + ar1[2] + "</td>";
					s += "<td width='15%' class='left'>" + ar1[3] + "</td>";
					s += "<td width='30%' class='left'>" + ar1[4] + "</td>";
					s += "</tr>";
				});
			}
			s += "</tbody>";
			s += "<tfoot>";
			s += "<tr>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "</tr>";
			s += "</tfoot>";
			s += "</table>";
			floatCount = i;
			floatSum = "合计金额：" + sum;
		});
		return s;
	}
	
	function setMap(pItem){
		dItem = pItem;
		$("#map").html("当前项目：&nbsp;<font color='orange'>" + pItem + "</font>");
	}

</script>
</head>
<body style="margin:0;">
<div id='layout' align='left'>
 <!--#include file='js/mainMenu.js' -->
 <!--#include file='commFloatDetail.asp' -->
 <!--#include file='commLoadFileDetail.asp' -->
	<div align='right' style='background:#f0f0ff;'>&nbsp;</div>
	<div id='map' align='left' style='background:#f9f9f9; padding-left:220px; height:18px;'>&nbsp;</div>
  	<table border='0' cellpadding='0' cellspacing='0' valign='top' width = '100%'>
  	    <tr height='490'>
  	    <td width='190' style='background:#f6f6ff;' valign='top'>
  	    	<div class='comm'><h2>查询内容</h2></div>
  	    	<br>
					<div class="applemenu">
						<div class="silverheader"><a href="#this">报表项目</a></div>
						<div class="submenu">
							<ul id="reportList">
					  	</ul>
						</div>
					</div>
  	    </td>
  	    <td valign="top">
					<div style="width:97%;float:left;margin:0;">
						<div id="searchCover" style="float:top;border:solid 1px #e0e0e0;width:100%%;margin:1px;background:#ffffff;line-height:18px;">

		  	    	<div class="comm" id="searchPanel1">
								<form>
									<table width="100%"><tr><td width="80%" align="left">
						        <input style="border:0px;" type="radio" name="sType1" value="1" checked />月报
						        <input style="border:0px;" type="radio" name="sType1" value="3" />年报
						      </td>
						      <td width="20%" align="right">
						        <input class="button" type="button" name="btnDownLoad1" id="btnDownLoad1" onClick="outputFloat('file')" value="下载">
						        <input class="button" type="button" name="btnPrint1" id="btnPrint1" onClick="outputFloat('print')" value="打印">
						    	</td></tr></table>
					      </form>
		  	    	</div>

						</div>
						<div id="resultCover" style="float:top;border:solid 1px #e0e0e0;width:100%;margin:1px;background:#ffffff;line-height:18px;">
							<div align="center"><img src="images/baobiao.jpg" style="filter:Alpha(Opacity=20) blur(add=true,direction=10,strength=25);" ></div>
						</div>
					</div>
  	    </td>
  	    </tr>
	</table>
	<div height="5" align="right" style="background:#f9f9f9;">&nbsp;</div>
</div>
</body>
</html>
