<!--#include file="js/doc.js" -->

<%

if(op == "getAttachDocList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(title like('%" + where + "%') or memo like('%" + where + "%')";
	}
	//如果有参考单号
	if(refID > 0 && kindID > ""){ // 
		s = "refID='" + refID + "' and kind = '" + kindID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where>""){
		where = " where " + where;
	}
	sql = " FROM v_attachDocInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT seq,title,paperName,photoName,datePaper,datePhoto,statusName,memo,regDate,registorName" + sql + " order by kind,refID,seq";
	sql = "SELECT top " + basket + " *,[dbo].[getUploadFileByNode](ID,'attachDocID') as fileName" + sql + " order by kind,refID,seq";
	
	rs = conn.Execute(sql);
	
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("refID").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("kind").value + "|" + rs("mark").value + "|" + rs("title").value + "|" + rs("paper").value + "|" + rs("paperName").value + "|" + rs("photo").value + "|" + rs("photoName").value + "|" + rs("datePaper").value + "|" + rs("datePhoto").value;
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value + "|" + rs("seq").value + "|" + rs("fileName").value;
		rs.MoveNext();
	}
	rs.Close();
	
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_attachDocInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("refID").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("kind").value + "|" + rs("mark").value + "|" + rs("title").value + "|" + rs("paper").value + "|" + rs("paperName").value + "|" + rs("photo").value + "|" + rs("photoName").value + "|" + rs("datePaper").value + "|" + rs("datePhoto").value;
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value + "|" + rs("seq").value;
	}
	rs.Close();
	Response.Write(escape(result));
}	

if(op == "update"){
	result = 0;
	if(kindID==""){
		result = 1;  //资料类型不能为空。
	}
	if(result == 0 && unescape(String(Request.QueryString("title")))==""){
		result = 2;  //资料名称不能为空。
	}
	if(result == 0){
		sql = "exec updateAttachDocInfo " + nodeID + ",'" + refID + "','" + String(Request.QueryString("status")) + "','" + String(Request.QueryString("seq")) + "','" + kindID + "','" + String(Request.QueryString("mark")) + "','" + String(Request.QueryString("paper")) + "','" + String(Request.QueryString("photo")) + "','" + unescape(String(Request.QueryString("title"))) + "','";
		sql += String(Request.QueryString("datePaper")) + "','" + String(Request.QueryString("datePhoto")) + "','" + unescape(String(Request.QueryString("memo"))) + "','" + String(Request.QueryString("regDate")) + "','" + unescape(String(Request.QueryString("regOperator"))) + "'";

		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT max(ID) as maxID FROM attachDocInfo where regOperator='" + unescape(String(Request.QueryString("regOperator"))) + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}
	}
	
	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "delNode"){
	sql = "exec delAttachDocInfo '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "setPaperConfirm"){
	sql = "exec setPaperConfirm '" + nodeID + "','" + keyID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "getAttachDocGap"){
	result = "";
	sql = "SELECT dbo.getAttachDocGap(" + refID + ",'" + kindID + "') as item";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("item").value;
	}
	rs.Close();
	Response.Write(escape(result));
}

%>
