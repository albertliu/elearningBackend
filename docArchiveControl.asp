<!--#include file="js/doc.js" -->

<%

if(op == "getDocArchiveListByWhere"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(projectName like('%" + where + "%') or engineeringName like('%" + where + "%') or docNo like('%" + where + "%'))";
	}
	//如果有工程号
	if(String(Request.QueryString("engineeringID")) > "0"){ // 
		s = "engineeringID=" + String(Request.QueryString("engineeringID"));
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有项目号
	if(String(Request.QueryString("projectID")) > "0"){ // 
		s = "projectID=" + String(Request.QueryString("projectID"));
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where>""){
		where = " where " + where;
	}
	sql = " FROM v_docArchiveInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT docNo,item1,item2,item3,dateArchive,statusName,projectName,engineeringName,regDate,registorName" + sql + " order by projectID,ID";
	sql = "SELECT top " + basket + " *" + sql + " order by projectID,ID";
	
	rs = conn.Execute(sql);
	
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("docNo").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("item1").value + "|" + rs("item2").value + "|" + rs("item3").value + "|" + rs("dateArchive").value;
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value;
		result += "|" + rs("projectID").value + "|" + rs("projectName").value + "|" + rs("engineeringID").value + "|" + rs("engineeringName").value;
		result += "|" + rs("contractNo").value + "|" + rs("unitID_owner").value + "|" + rs("unitOwnerName").value + "|" + rs("unitID_builder").value + "|" + rs("unitBuilderName").value + "|" + rs("unitID_supervisor").value + "|" + rs("unitSupervisorName").value + "|" + rs("kind").value + "|" + rs("kindName").value + "|" + rs("type").value + "|" + rs("typeName").value;
		rs.MoveNext();
	}
	rs.Close();
	
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	result = 0;

	sql = "SELECT * FROM v_docArchiveInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("docNo").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("item1").value + "|" + rs("item2").value + "|" + rs("item3").value + "|" + rs("dateArchive").value;
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value;
		result += "|" + rs("projectID").value + "|" + rs("projectName").value + "|" + rs("engineeringID").value + "|" + rs("engineeringName").value;
		result += "|" + rs("contractNo").value + "|" + rs("unitID_owner").value + "|" + rs("unitOwnerName").value + "|" + rs("unitID_builder").value + "|" + rs("unitBuilderName").value + "|" + rs("unitID_supervisor").value + "|" + rs("unitSupervisorName").value + "|" + rs("kind").value + "|" + rs("kindName").value + "|" + rs("type").value + "|" + rs("typeName").value;
	}
	rs.Close();
	Response.Write(escape(result));
}	

if(op == "update"){
	result = 0;
	if(unescape(String(Request.QueryString("docNo")))==""){
		//result = 1;  //资料编号不能为空。
	}
	if(result == 0 && nodeID==0){
		sql = "SELECT ID FROM docArchiveInfo where projectID=" + refID;
		rs = conn.Execute(sql);
		if (!rs.EOF){
			result = 9;  //该项目中已经有任务单，不能增加新的。
		}
		rs.Close();
	}
	if(result == 0){
		sql = "exec updateDocArchiveInfo " + nodeID + ",'" + refID + "','" + unescape(String(Request.QueryString("docNo"))) + "','" + String(Request.QueryString("status")) + "','" + unescape(String(Request.QueryString("item1"))) + "','" + unescape(String(Request.QueryString("item2"))) + "','" + unescape(String(Request.QueryString("item3"))) + "','" + String(Request.QueryString("dateArchive")) + "','";
		sql += unescape(String(Request.QueryString("memo"))) + "','" + String(Request.QueryString("regDate")) + "','" + unescape(String(Request.QueryString("regOperator"))) + "'";

		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT max(ID) as maxID FROM docArchiveInfo where regOperator='" + unescape(String(Request.QueryString("regOperator"))) + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID").value;
		}
	}
	
	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "delNode"){
	sql = "exec delDocArchive '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "getIDbyProject"){  //根据项目编号返回编号
	result = 0;
	sql = "SELECT ID FROM docArchiveInfo where projectID='" + refID + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("ID").value;
	}
	rs.Close();

	Response.Write(escape(result));
}

%>
