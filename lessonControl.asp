<!--#include file="js/doc.js" -->

<%

if(op == "getLessonList"){
	var s = "";
	//如果有课程
	if(refID > ""){ // 
		s = "courseID='" + refID + "'";
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

	sql = " FROM v_lessonInfo " + where;
	sql = "SELECT *" + sql + " order by lessonID, seq";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("lessonID").value + "|" + rs("lessonName").value + "|" + rs("hours").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//7
		result += "|" + rs("courseID").value + "|" + rs("seq").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		rs.MoveNext();
	}
/**/
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_lessonInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result =  rs("ID").value + "|" + rs("lessonID").value + "|" + rs("lessonName").value + "|" + rs("hours").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//7
		result += "|" + rs("courseID").value + "|" + rs("seq").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		execSQL(sql);
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "update"){
	result = 0;
	if(result == 0){
		sql = "exec updateLessonInfo " + nodeID + ",'" + String(Request.QueryString("lessonID")) + "','" + unescape(String(Request.QueryString("lessonName"))) + "','" + String(Request.QueryString("hours")) + "','" + String(Request.QueryString("courseID")) + "'," +  + String(Request.QueryString("seq")) + "," + kindID + "," + status + ",'" + memo + "','" + currUser + "'";

		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT max(ID) as maxID FROM lessonInfo where registerID='" + currUser + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}
	}

	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "cancelNode"){
	sql = "exec doCancelLesson " + nodeID;
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "delNode"){
	sql = "exec delLessonInfo " + nodeID + ",'" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}
%>
