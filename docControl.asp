<!--#include file="js/doc.js" -->

<%

if(op == "getDocListByWhere"){
	result = "";
	var s = "";
	//如果有状态，按照状态查询
	if(status < 99){ // 有分类
		s = "status=" + status;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fStart > ""){
		s += " regDate>='" + fStart + "";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > ""){
		s += " regDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有分类，按照分类查询
	if(kindID > ""){ //类型：0 公告  1通知  2 业务资料
		s = "kindID='" + kindID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(where>""){
		where = " where " + where;
	}
	sql = " FROM v_docInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "select item,docContent,statusName,description,regDate,registorName" + sql + " order by ID desc";
	sql = "select top " + basket + " *,dbo.getReturnLog('doc',ID,'" + currUser + "') as myRead,[dbo].[getUploadFileByNode](ID,'docID') as fileName,(case when kindID=1 then dbo.getReceiverReturnCount('doc',ID) else dbo.getReturnLog('doc',ID,'') end) as returnLog,dbo.getReceiverCount('doc',ID) as receiverCount" + sql + " order by ID desc";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("item").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("kindID").value + "|" + rs("description").value + "|" + rs("docContent").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value + "|" + rs("fileName").value + "|" + rs("myRead").value + "|" + rs("receiverCount").value + "|" + rs("returnLog").value;
		rs.MoveNext();
	}
	rs.Close();
	Session(op) = ssql;
/*
	*/
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	sql = "SELECT *,[dbo].[getUploadFileByNode](ID,'docID') as fileName FROM v_docInfo where ID='" + nodeID + "'";
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("item").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("kindID").value + "|" + rs("description").value + "|" + rs("docContent").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value + "|" + rs("fileName").value;
	}
	rs.Close();
	Response.Write(escape(result));
}	

if(op == "update"){
	result = 0;
	if(item==""){
		result = 1;  //标题不能为空。
	}

	if(result==0){
		sql = "exec updateDocInfo '" + nodeID + "','" + item + "'," + status + ",'" + kindID + "','" + unescape(String(Request.QueryString("description"))) + "','" + unescape(String(Request.QueryString("docContent"))) + "','" + unescape(String(Request.QueryString("userID"))) + "','" + currUser + "'";
		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT max(ID) as maxID FROM docInfo where regOperator='" + currUser + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}
	}
	
	result += "|" + nodeID;

	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "delNode"){
	sql = "exec delDoc '" + nodeID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "getDocUserName"){
	sql = "SELECT dbo.getDocUsersName('" + nodeID + "') as usersName";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("usersName").value;
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "getDocUserList"){
	sql = "SELECT * from v_returnReceiptList where kindID='" + kindID + "' and refID='" + nodeID + "'";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("userID").value + "|" + rs("userName").value + "|" + rs("receiptDate").value + "|" + rs("regDate").value;
		rs.MoveNext();
	}
	if(result>""){
		result = result.substr(2);
	}

	Response.Write(escape(result));
}	

if(op == "addUser"){
	sql = "exec updateReturnUser '" + kindID + "','" + refID + "','" + keyID + "'";
	execSQL(sql);
	Response.Write(0);
}

if(op == "removeUser"){
	sql = "exec delReturnUser '" + nodeID + "'";
	execSQL(sql);
	Response.Write(0);
}

if(op == "addUserBatch"){
	sql = "exec updateReturnUserBatch '" + kindID + "','" + refID + "','" + 0 + "','" + keyID + "'";
	execSQL(sql);
	Response.Write(0);
}

if(op == "removeUserBatch"){
	sql = "exec delReturnUserBatch '" + kindID + "','" + refID + "','" + 0 + "'";
	execSQL(sql);
	Response.Write(0);
}

if(op == "setReturnLog"){
	sql = "exec setReturnLog '" + kindID + "','" + refID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}

if(op == "test"){
	Response.Write(11);
}

%>
