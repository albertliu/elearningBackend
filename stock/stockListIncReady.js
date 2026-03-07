	$(document).ready(function (){
		$("#searchStockStartDate").datebox("setValue", new Date().format("yyyy-MM-dd"));
			getStockList();
		$("#btnSearchStock").click(function(){
			alert(1)
			getStockList();
		});
	});

	function getStockList(){
		let sWhere = $("#txtSearchStock").val();
		alert(sWhere)
		$.post(uploadURL + "/public/postCommInfo", {proc:"getStockListBySearch", params:{item: sWhere, date:$("#searchStockStartDate").datebox("getValue")}}, function(data){
			let c = 0;
			let i = 0;
			let arr = [];
			arr.push("<div>" + ar.shift() + "</div>");					
			arr.push("<table cellpadding='0' cellspacing='0' border='0' class='display' id='stockTab' width='99%'>");
			arr.push("<thead>");
			arr.push("<tr align='center'>");
			arr.push("<th width='5%'>No</th>");
			arr.push("<th width='10%'>股票代码</th>");
			arr.push("<th width='10%'>股票名称</th>");
			arr.push("<th width='10%'>交易日期</th>");
			arr.push("<th width='8%'>开盘</th>");
			arr.push("<th width='8%'>最高</th>");
			arr.push("<th width='8%'>最低</th>");
			arr.push("<th width='8%'>收盘</th>");
			arr.push("<th width='8%'>昨收盘</th>");
			arr.push("<th width='8%'>涨幅</th>");
			arr.push("<th width='8%'>换手率</th>");
			arr.push("<th width='8%'>状态</th>");
			arr.push("</tr>");
			arr.push("</thead>");
			arr.push("<tbody id='tbody'>");
			if(data.length > 0){
				$.each(data,function(iNum,val){
					i += 1;
					arr.push("<tr class='grade" + c + "'>");
					arr.push("<td class='center'>" + i + "</td>");
					arr.push("<td class='link1'><a href='javascript:showStockInfo(" + val["code"] + ",\"\",0,1);'>" + val["symbol"] + "</a></td>");
					arr.push("<td class='left'>" + val["name"] + "</td>");
					arr.push("<td class='left'>" + val["tdate"] + "</td>");
					arr.push("<td class='left'>" + val["popen"] + "</td>");
					arr.push("<td class='left'>" + val["high"] + "</td>");
					arr.push("<td class='left'>" + val["low"] + "</td>");
					arr.push("<td class='left'>" + val["pclose"] + "</td>");
					arr.push("<td class='left'>" + val["preclose"] + "</td>");
					arr.push("<td class='left'>" + val["pctChg"] + "</td>");
					arr.push("<td class='left'>" + val["turn"] + "</td>");
					arr.push("<td class='left'>" + val["statusName"] + "</td>");
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
			$("#stockCover").html(arr.join(""));
			arr = [];
			$('#stockTab').dataTable({
				"aaSorting": [],
				"bFilter": true,
				"bPaginate": true,
				"bLengthChange": true,
				"bInfo": true,
				"aLengthMenu":[15,30,50,100,500],
				"iDisplayLength": 100,
				"aoColumnDefs": []
			});
			floatCount = i;
			floatTitle = "";	//excel file's title in the 1st row, if it's blank then keep the excel's present one.
			floatItem = "";		//write to excel file's 2nd row
			floatLog = "打印日期：&nbsp;&nbsp;&nbsp;&nbsp;打印人：";		//write to excel file's 3rd row
			floatKey = "";		//
			floatContent = "";	//records data for output
			floatModel = 1;
		});
	}
	