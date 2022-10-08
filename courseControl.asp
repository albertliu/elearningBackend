<!--#include file="js/doc.js" -->

<%

if(op == "getCourseList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(courseName like('%" + where + "%'))";
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

	sql = " FROM v_courseInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT courseID,courseName,hours,statusName,markName,memo,regDate,registerName" + sql + " order by courseID";
	sql = "SELECT top " + basket + " *" + sql + " order by courseID";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("courseID").value + "|" + rs("courseName").value + "|" + rs("hours").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//7
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("certID").value + "|" + rs("mark").value + "|" + rs("markName").value;
		//16
		result += "|" + rs("price").value + "|" + rs("reexamine").value + "|" + rs("reexamineName").value;
		rs.MoveNext();
	}
/**/
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getCertCourseList"){
	sql = "SELECT ID,courseID,courseName,hours FROM v_courseInfo where certID='" + refID + "' order by courseID";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("courseID").value + "|" + rs("courseName").value + "|" + rs("hours").value;
		rs.MoveNext();
	}
/**/
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_courseInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("ID").value + "|" + rs("courseID").value + "|" + rs("courseName").value + "|" + rs("hours").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//7
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("certID").value;
		//14
		result += "|" + rs("completionPass").value + "|" + rs("deadline").value + "|" + rs("deadday").value + "|" + rs("period").value + "|" + rs("mark").value + "|" + rs("markName").value;
		//20
		result += "|" + rs("price").value + "|" + rs("reexamine").value + "|" + rs("reexamineName").value + "|" + rs("shortName").value;
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "update"){
	result = 0;
	if(result == 0){
		sql = "exec updateCourseInfo " + nodeID + ",'" + String(Request.QueryString("courseID")) + "','" + unescape(String(Request.QueryString("courseName"))) + "','" + unescape(String(Request.QueryString("shortName"))) + "','" + String(Request.QueryString("hours")) + "','" + String(Request.QueryString("completionPass")) + "','" + String(Request.QueryString("deadline")) + "','" + String(Request.QueryString("deadday")) + "','" + String(Request.QueryString("period")) + "'," + kindID + "," + String(Request.QueryString("reexamine")) + "," + status + "," + String(Request.QueryString("mark")) + ",'" + refID + "','" + String(Request.QueryString("price")) + "','" + host + "','" + memo + "','" + currUser + "'";

		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT max(ID) as maxID FROM courseInfo where registerID='" + currUser + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}
	}

	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(1));
}

if(op == "getCoursePrice"){
	sql = "SELECT dbo.getCoursePrice('" + nodeID + "','" + refID + "','" + host + "'," + keyID + ") as price";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("price").value;
	}
	rs.Close();
	Response.Write((result));
}

if(op == "cancelNode"){
	sql = "exec doCancelCourse " + nodeID;
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "delNode"){
	sql = "exec delCourseInfo '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}
%>
