<!--#include file="js/doc.js" -->

<%

if(op == "getAgencyList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(agencyID ='" + where + "' or agencyName like('%" + where + "%')";
	}
	//如果有状态
	if(status > ""){ // 
		s = "status=" + status;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有分类
	if(kindID > ""){ // 
		s = "kindID=" + kindID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(where>""){
		where = " where " + where;
	}
	sql = " FROM v_agencyInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT agencyNo,agencyName,title,statusName,linker,phone,email,address,memo,regDate,registerName" + sql + " order by agencyID";
	sql = "SELECT top " + basket + " *" + sql + " order by agencyID";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("agencyID").value + "|" + rs("agencyName").value + "|" + rs("title").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("kindName").value + "|" + rs("statusName").value;
		//8
		result +=  "|" + rs("linker").value + "|" + rs("phone").value + "|" + rs("email").value + "|" + rs("address").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		rs.MoveNext();
	}

	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_agencyInfo where agencyID=" + nodeID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("ID").value + "|" + rs("agencyID").value + "|" + rs("agencyName").value + "|" + rs("title").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("kindName").value + "|" + rs("statusName").value;
		//8
		result +=  "|" + rs("linker").value + "|" + rs("phone").value + "|" + rs("email").value + "|" + rs("address").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		execSQL(sql);
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "update"){
	result = 0;
	if(result == 0){
		sql = "exec updateAgencyInfo " + nodeID + ",'" + refID + "','" + unescape(String(Request.QueryString("agencyName"))) + "','" + unescape(String(Request.QueryString("title"))) + "'," + kindID + "," + status + ",'" + unescape(String(Request.QueryString("linker"))) + "','" + unescape(String(Request.QueryString("phone"))) + "','" + unescape(String(Request.QueryString("email"))) + "','" + unescape(String(Request.QueryString("address"))) + "','" + memo + "','" + currUser + "'";

		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT ID as maxID FROM agencyInfo where agencyID='" + refID + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}
	}

	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "delNode"){
	sql = "exec delAgencyInfo '" + nodeID + "','" + item + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "getSourceList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(source like('%" + where + "%')";
	}
	//如果有状态
	if(status > ""){ // 
		s = "status=" + status;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(where>""){
		where = " where " + where;
	}
	sql = " FROM v_sourceInfo " + where;
	ssql = "SELECT source,statusName,regDate,registerName" + sql + " order by ID";
	sql = "SELECT *" + sql + " order by ID";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("source").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//4
		result +=  "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		rs.MoveNext();
	}

	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "getCurrSourceList"){
	sql = "select * from dbo.[getCurrSourceList]() order by ID";

	result = "";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += ',"' + rs("ID").value + '":"' + rs("item").value + '"';
		rs.MoveNext();
	}
	result = '{"":""' + (result>''? ','+result.substr(1):'') + '}';
	Response.Write(escape(result));/**/
	//Response.Write(escape(sql));
}

if(op == "getSourceNodeInfo"){
	sql = "SELECT * FROM v_sourceInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("ID").value + "|" + rs("source").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//4
		result +=  "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		execSQL(sql);
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "updateSource"){
	result = 0;
	sql = "exec updateSourceInfo " + nodeID + ",'" + unescape(String(Request.QueryString("source"))) + "'," + status + ",'" + currUser + "'";

	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("re").value;
	}
	rs.Close();
	Response.Write(result);
	//Response.Write(escape(sql));
}

if(op == "delSourceNode"){
	sql = "exec delSourceInfo '" + nodeID + "','" + item + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

%>
