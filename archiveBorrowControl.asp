<!--#include file="js/doc.js" -->

<%

if(op == "getArchiveBorrowList"){
	var s = "";
	sql = " FROM v_archiveBorrow ";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(kindName like('%" + where + "%') or item like('%" + where + "%') or archiveNo='" + where + "')";
	}
	//如果有分类
	if(kindID < 99 && kindID > ""){ // 
		s = "kindID='" + kindID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有状态，按照状态查询
	if(status < 99 && status > ""){ // 
		s = "status=" + status;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fStart > ""){
		s += " borrowDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > ""){
		s += " borrowDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where>""){
		where = " where " + where;
	}
	sql += where;
	result = getBasketTip(sql,"");
	ssql = "SELECT item,kindName,seq,version,statusName,memo,regDate,registorName" + sql + " order by version desc,kindID,seq";
	sql = "SELECT top " + basket + " *" + sql + " order by ID desc";
	
	rs = conn.Execute(sql);
	
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("archiveNo").value + "|" + rs("item").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("kindID").value + "|" + rs("kindName").value + "|" + rs("borrowDate").value + "|" + rs("limitDate").value + "|" + rs("page").value + "|" + rs("location").value;
		//10
		result += "|" + rs("borrower").value + "|" + rs("returnDate").value + "|" + rs("returnOperator").value + "|" + rs("returnOperatorName").value + "|" + rs("checkDate").value + "|" + rs("checkerID").value + "|" + rs("checkerName").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value + "|" + rs("archiveID").value;
		rs.MoveNext();
	}
	rs.Close();
	
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	getNodeInfo();
	Response.Write(escape(result));
}	

if(op == "update"){
	result = 0;
	if(String(Request.QueryString("limitDate"))==""){
		result = 1;  //归还期限不能为空。
	}
	if(result==0 && unescape(String(Request.QueryString("borrower")))==""){
		result = 2;  //借阅人不能为空。
	}
	if(result==0 && unescape(String(Request.QueryString("memo")))==""){
		result = 3;  //借阅事由不能为空。
	}
	if(result == 0){
		sql = "exec updateArchiveBorrow " + nodeID + ",'" + refID + "','" + status + "','" + unescape(String(Request.QueryString("borrower"))) + "','" + unescape(String(Request.QueryString("returnOperator"))) + "','" + String(Request.QueryString("borrowDate")) + "','" + String(Request.QueryString("limitDate")) + "','" + String(Request.QueryString("returnDate")) + "','" + unescape(String(Request.QueryString("memo"))) + "','" + currUser + "'";
		
		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT max(ID) as maxID FROM archiveBorrow where regOperator='" + unescape(String(Request.QueryString("regOperator"))) + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}
	}
	
	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "delNode"){
	sql = "exec delArchiveBorrow '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

function getNodeInfo(){
	result = "";
	sql = "SELECT * FROM v_archiveBorrow where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("archiveNo").value + "|" + rs("item").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("kindID").value + "|" + rs("kindName").value + "|" + rs("borrowDate").value + "|" + rs("limitDate").value + "|" + rs("page").value + "|" + rs("location").value;
		//10
		result += "|" + rs("borrower").value + "|" + rs("returnDate").value + "|" + rs("returnOperator").value + "|" + rs("returnOperatorName").value + "|" + rs("checkDate").value + "|" + rs("checkerID").value + "|" + rs("checkerName").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value + "|" + rs("archiveID").value;
	}
	rs.Close();
}	

%>
