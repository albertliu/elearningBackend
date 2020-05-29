<!--#include file="js/doc.js" -->
<%
var type = "";
var kindID = 0;
var modeID = 0;
var result = "";
var rs;

if (String(Request.QueryString("type")) != "undefined" && 
    String(Request.QueryString("type")) != "") { 
    type = String(Request.QueryString("type"));
}
if (String(Request.QueryString("kindID")) != "undefined" && 
    String(Request.QueryString("kindID")) != "") { 
  kindID = String(Request.QueryString("kindID"));
}
if (String(Request.QueryString("modeID")) != "undefined" && 
    String(Request.QueryString("modeID")) != "") { 
  modeID = String(Request.QueryString("modeID"));
}

if(modeID==1){  //档案月度统计
		if(type == "getTitle"){
			var t = "";
			if(kindID==0){t = "代保管";}
			if(kindID==1){t = "自管";}
			if(kindID==2){t = "邮寄";}
			result = "3";    								 //柱子数量
			result += "|" + t + "档案月度盘点情况";          //Title
			result += "|" + "期末数量,入库数量,出库数量";    //图例
			
			Response.Write(escape(result));
		}
		
		if(type=="getData"){
			var ym = "";
			var currCount = 0;
			var regCountSum = 0;
			var delCountSum = 0;
			var c = 0;
			
			var line0 = "";   //x轴刻度
			var line1 = "";   //第一柱
			var line2 = "";   //第二柱
			var line3 = "";   //第三柱
			var line9 = "";   //汇总名称
			var line10 = "";  //汇总数据

			sql = "select * from pool_archiveMonthRegRpt where type=" + kindID + " order by month";
			rs = conn.Execute(sql);
			while(!rs.EOF){
				if (rs("currCount").value>0){
					line0 += "," + rs("month").value;
					line1 += "," + rs("currCount").value;
					line2 += "," + rs("regCount").value;
					line3 += "," + rs("delCount").value;
					regCountSum += rs("regCount").value;
					delCountSum += rs("delCount").value;
					currCount += rs("currCount").value;
					c += 1;
				}
				rs.MoveNext();
			}
			
			if(c>0){
				line0 = line0.substr(1);
				line1 = line1.substr(1);
				line2 = line2.substr(1);
				line3 = line3.substr(1);
				line9 = "平均数量,平均入库,平均出库";
				line10 = parseInt(currCount/c) + "," + parseInt(regCountSum/c) + "," + parseInt(delCountSum/c);
			}
			
			rs.Close();
			Response.Write(escape(line0 + "|" + line1 + "|" + line2 + "|" + line3 + "|" + line9 + "|" + line10));
		}
}

%>