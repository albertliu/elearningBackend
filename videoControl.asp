<!--#include file="js/doc.js" -->

<%

if(op == "getVideoList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(videoName like('%" + where + "%') or videoID='" + where + "' or lessonID='" + where + "')";
	}
	//如果有课程
	if(refID > ""){ // 
		s = "lessonID='" + refID + "'";
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

	sql = " FROM v_videoInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT videoID,videoName,minutes,proportion,type,author,statusName,lessonID,memo,regDate,registerName" + sql + " order by videoID";
	sql = "SELECT top " + basket + " *" + sql + " order by videoID";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("videoID").value + "|" + rs("videoName").value + "|" + rs("minutes").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("filename").value;
		//8
		result += "|" + rs("lessonID").value + "|" + rs("type").value + "|" + rs("author").value + "|" + rs("proportion").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		rs.MoveNext();
	}
/**/
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_videoInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("ID").value + "|" + rs("videoID").value + "|" + rs("videoName").value + "|" + rs("minutes").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("filename").value;
		//8
		result += "|" + rs("lessonID").value + "|" + rs("type").value + "|" + rs("author").value + "|" + rs("proportion").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		execSQL(sql);
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "update"){
	result = 0;
	if(result == 0){
		sql = "exec updateVideoInfo " + nodeID + ",'" + String(Request.QueryString("videoID")) + "','" + unescape(String(Request.QueryString("videoName"))) + "','" + String(Request.QueryString("minutes")) + "','" + String(Request.QueryString("proportion")) + "','" + String(Request.QueryString("type")) + "','" + String(Request.QueryString("author")) + "','" + refID + "'," + kindID + "," + status + ",'" + memo + "','" + currUser + "'";

		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT max(ID) as maxID FROM videoInfo where registerID='" + currUser + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}
	}

	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "cancelNode"){
	sql = "exec doCancelVideo " + nodeID;
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "delNode"){
	sql = "exec delVideoInfo '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}
%>
