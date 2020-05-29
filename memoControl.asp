<!--#include file="js/doc.js" -->

<%
if(op == "getMemoList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(item like('%" + where + "%') or memo like('%" + where + "%'))";
	}
	//如果有分类，按照分类查询
	if(kindID < 99 && kindID > ""){ // 有分类
		s = "kindID=" + kindID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果指定人员
	if(unescape(String(Request.QueryString("userID"))) > ""){ 
		s = "regOperator='" + unescape(String(Request.QueryString("userID"))) + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果指定范围
	if(String(Request.QueryString("private")) > ""){ 
		s = "private='" + String(Request.QueryString("private")) + "'";
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
	//如果有起始日期
	if(fStart > ""){ // 
		s = "keyDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有截止日期
	if(fEnd > ""){ // 
		s = "keyDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where>""){
		where = " where " + where;
	}

	sql = " FROM v_memoInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT item,keyDate,alertDays,kindName,statusName,privateName,holidayName,memo,regDate,registorName" + sql + " order by ID desc";
	sql = "SELECT top " + basket + " *" + sql + " order by ID desc";
	
	rs = conn.Execute(sql);
	
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("item").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("keyDate").value + "|" + rs("alertDays").value + "|" + rs("kindID").value + "|" + rs("kindName").value;
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value + "|" + rs("mark").value + "|" + rs("private").value + "|" + rs("privateName").value + "|" + rs("holiday").value + "|" + rs("holidayName").value;
		rs.MoveNext();
	}
	rs.Close();
	
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_memoInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("item").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("keyDate").value + "|" + rs("alertDays").value + "|" + rs("kindID").value + "|" + rs("kindName").value;
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value + "|" + rs("mark").value + "|" + rs("private").value + "|" + rs("privateName").value + "|" + rs("holiday").value + "|" + rs("holidayName").value;
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "update"){
	result = 0;
	if(unescape(String(Request.QueryString("item")))==""){
		result = 2;  //内容不能为空。
	}
	if(result == 0){
		sql = "exec updateMemoInfo " + nodeID + ",'" + unescape(String(Request.QueryString("item"))) + "','" + String(Request.QueryString("status")) + "','" + String(Request.QueryString("keyDate")) + "','" + String(Request.QueryString("alertDays")) + "','";
		sql += kindID + "','" + String(Request.QueryString("private")) + "','" + String(Request.QueryString("holiday")) + "','" + unescape(String(Request.QueryString("memo"))) + "','" + String(Request.QueryString("regDate")) + "','" + unescape(String(Request.QueryString("regOperator"))) + "'";

		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT max(ID) as maxID FROM memoInfo where regOperator='" + unescape(String(Request.QueryString("regOperator"))) + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}
	}

	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "delNode"){
	sql = "exec delMemoInfo '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

%>
