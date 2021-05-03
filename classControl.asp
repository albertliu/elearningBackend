<!--#include file="js/doc.js" -->

<%

if(op == "getClassList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(certName like('%" + where + "%') or classID='" + where + "')";
	}
	//如果有课程
	if(refID > ""){ // 
		s = "certID='" + refID + "'";
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
	//如果有批次
	if(String(Request.QueryString("projectID")) > "" && String(Request.QueryString("projectID")) !="undefined"){ // 
		s = "projectID='" + String(Request.QueryString("projectID")) + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where>""){
		where = " where " + where;
	}

	sql = " FROM v_classInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT classID,className,certID,certName,courseID,courseName,statusName,scoreTotal,scorePass,minutes,memo,regDate,registerName" + sql + " order by classID";
	sql = "SELECT top " + basket + " *" + sql + " order by classID";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("classID").value + "|" + rs("projectID").value + "|" + rs("certID").value + "|" + rs("certName").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//8
		result += "|" + rs("adviserID").value + "|" + rs("adviserName").value + "|" + rs("dateStart").value + "|" + rs("dateEnd").value + "|" + rs("classroom").value;
		//13
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("className").value + "|" + rs("timetable").value + "|" + rs("phone").value;
		rs.MoveNext();
	}
/**/
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_classInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("ID").value + "|" + rs("classID").value + "|" + rs("projectID").value + "|" + rs("certID").value + "|" + rs("certName").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//8
		result += "|" + rs("adviserID").value + "|" + rs("adviserName").value + "|" + rs("dateStart").value + "|" + rs("dateEnd").value + "|" + rs("classroom").value;
		//13
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("className").value + "|" + rs("timetable").value + "|" + rs("phone").value;
		execSQL(sql);
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "update"){
	result = 0;
	if(result == 0){
		sql = "exec updateClassInfo " + nodeID + ",'" + unescape(String(Request.QueryString("className"))) + "','" + String(Request.QueryString("certID")) + "','" + String(Request.QueryString("projectID")) + "','" + String(Request.QueryString("adviserID")) + "'," + kindID + "," + status + ",'" + String(Request.QueryString("dateStart")) + "','" + String(Request.QueryString("dateEnd")) + "','" + unescape(String(Request.QueryString("classroom"))) + "','" + unescape(String(Request.QueryString("timetable"))) + "','" + memo + "','" + currUser + "'";

		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT max(ID) as maxID FROM classInfo where registerID='" + currUser + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}
	}

	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "cancelNode"){
	sql = "exec doCancelClass " + nodeID;
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "delNode"){
	sql = "exec delClassInfo '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}
%>
