<!--#include file="js/doc.js" -->

<%
var nodeID = "";
var refID = "";
var kind = 0;
var operator = "";
var op = "";
var result = "";

if (String(Request.QueryString("op")) != "undefined" && 
    String(Request.QueryString("op")) != "" && String(Request.QueryString("op")) != "null") { 
  op = String(Request.QueryString("op"));
}
if (String(Request.QueryString("nodeID")) != "undefined" && 
    String(Request.QueryString("nodeID")) != "" && String(Request.QueryString("nodeID")) != "null") { 
  nodeID = String(Request.QueryString("nodeID"));
}
if (String(Request.QueryString("refID")) != "undefined" && 
    String(Request.QueryString("refID")) != "" && String(Request.QueryString("refID")) != "null") { 
  refID = String(Request.QueryString("refID"));
}
if (String(Request.QueryString("kind")) != "undefined" && 
    String(Request.QueryString("kind")) != "" && String(Request.QueryString("kind")) != "null") { 
  kind = String(Request.QueryString("kind"));
}
if (String(Request.QueryString("operator")) != "undefined" && 
    String(Request.QueryString("operator")) != "" && String(Request.QueryString("operator")) != "null") { 
  operator = String(Request.QueryString("operator"));
}

if(op == "getUnitLogList"){
	var cs = "";
	sql = "SELECT *,dbo.getDownloadFile('mergeDocID',refID) as downloadFile FROM v_unitOpLog where unitCode='" + nodeID + "'";
	if(kind<99){
		cs = " and kind=" + kind;
	}
	if(operator>""){
		cs += " and operator='" + operator + "'";
	}
	
	sql += cs + " order by opDate desc,ID desc";
	rs = conn.Execute(sql);
		
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("kindName").value + "|" + rs("event").value + "|" + rs("opDate").value + "|" + rs("operatorName").value + "|" + rs("memo").value + "|" + rs("typeName").value + "|" + rs("kind").value + "|" + rs("refID").value + "|" + rs("operator").value + "|" + rs("downloadFile").value;
		rs.MoveNext();
	}
	rs.Close();
	if(result > ""){
		result = result.substr(2);
	}
	Response.Write(escape(result));
}	

if(op == "getUnitLogKindList"){
	sql = "SELECT kind,kindName FROM v_unitOpLog where unitCode='" + nodeID + "' group by kind,kindName order by kind";
	rs = conn.Execute(sql);
		
	while (!rs.EOF){
		result += "%%" + rs("kind").value + "|" + rs("kindName").value;
		rs.MoveNext();
	}
	rs.Close();
	if(result > ""){
		result = result.substr(2);
	}
	Response.Write(escape(result));
}	

if(op == "getUnitLogUserList"){
	sql = "SELECT operator,operatorName FROM v_unitOpLog where unitCode='" + nodeID + "' group by operator,operatorName order by operator";
	rs = conn.Execute(sql);
		
	while (!rs.EOF){
		result += "%%" + rs("operator").value + "|" + rs("operatorName").value;
		rs.MoveNext();
	}
	rs.Close();
	if(result > ""){
		result = result.substr(2);
	}
	Response.Write(escape(result));
}	

if(op == "getLastRenameID"){
	sql = "select max(ID) as ID from unitOpLog where kind=3 and unitCode='" + nodeID + "' group by refID having count(*)=1";
	rs = conn.Execute(sql);
		
	if (!rs.EOF){
		result += rs("ID").value;
	}
	rs.Close();
	Response.Write(result);
}	
%>
