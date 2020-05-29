<!--#include file="js/doc.js" -->

<%
if(op == "getNewsList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "item like('%" + where + "%')";
	}
	//如果有分类，按照分类查询
	if(kindID > ""){ // 有分类
		s = "kindID='" + kindID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有状态，按照状态查询
	if(status < 99){ // 有分类
		s = "status=" + status;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	
	s = "(userName='" + currUser + "' or dbo.userHasPermission('" + currUser + "',userName,scopeID)>0)";
	if(where > ""){
		where = where + " and " + s;
	}else{
		where = s;
	}

	if(where>""){
		where = " where " + where;
	}
	
	sql = " FROM v_newsCenter " + where;
	result = getBasketTip(sql,"");
	
	ssql = "SELECT item,statusName,kindName,receiverName,alertDays,datePlan,dateConfirm,newsType,newsMark,memo,regDate,registorName" + sql;
	sql = "SELECT top " + basket + " * " + sql;

	rs = conn.Execute(sql);
	
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("item").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("refID").value + "|" + rs("scopeID").value + "|" + rs("userKind").value + "|" + rs("userName").value + "|" + rs("receiverName").value + "|" + rs("kindID").value + "|" + rs("kindName").value + "|" + rs("newsType").value + "|" + rs("newsTypeName").value + "|" + rs("newsMark").value + "|" + rs("alertDays").value + "|" + rs("datePlan").value + "|" + rs("dateConfirm").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value;
		rs.MoveNext();
	}
	rs.Close();

	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getCalenderData"){
	var pColor = ["#458B00","#FFB900","#FF0000","#AAAAAA","#FF00FF","#0000FF"];	//0 未到期  1 临近  2 当天  3 过期  4 节假日  5 调休上班
	sql = "SELECT * from dbo.getCalenderData('" + currUser + "')";
	rs = conn.Execute(sql);
	
	//ID,item,status,kindID,kindName,keyDate,alertDays,unitName,holidayName,memo,regDate,mark
	while (!rs.EOF){
		result += ',{"url":"' + rs('ID').value + '","title":"' + rs('item').value + '","start":"' + rs('keyDate').value + '","alertDays":"' + rs('alertDays').value + '","color":"' + pColor[rs('mark').value] + '","memo":"' + rs('memo').value + '","regDate":"' + rs('regDate').value + '"}';
		rs.MoveNext();
	}
	rs.Close();
	
	if(result > ""){
		result = "[" + result.substr(1) + "]";
	}
	Response.Write(result);
}

%>
