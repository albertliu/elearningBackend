<!--#include file="js/doc.js" -->

<%

if(op == "getArchiveLogList"){
	var cs = "";
	sql = "SELECT * FROM v_archivesOpLog where archiveID='" + nodeID + "'";
	if(kindID>""){
		cs = " and kind=" + kindID;
	}
	sql += cs + " order by ID desc";
	rs = conn.Execute(sql);
		
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("archiveNo").value + "|" + rs("item").value + "|" + rs("kindName").value + "|" + rs("event").value + "|" + rs("memo").value + "|" + rs("opDate").value + "|" + rs("operatorName").value;
		rs.MoveNext();
	}
	rs.Close();
	if(result > ""){
		result = result.substr(2);
	}
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

%>
