<!--#include file="js/doc.js" -->

<%
var rs;
var nodeID = "0";
var keyID = "";
var groupID = "0";
var where = "";
var op = "";
var result = "";

if (String(Request.QueryString("op")) != "undefined" && 
    String(Request.QueryString("op")) != "") { 
  op = String(Request.QueryString("op"));
}
if (String(Request.QueryString("nodeID")) != "undefined" && 
    String(Request.QueryString("nodeID")) != "") { 
  nodeID = String(Request.QueryString("nodeID"));
}
if (String(Request.QueryString("keyID")) != "undefined" && 
    String(Request.QueryString("keyID")) != "") { 
  keyID = String(Request.QueryString("keyID"));
}
if (String(Request.QueryString("groupID")) != "undefined" && 
    String(Request.QueryString("groupID")) != "") { 
  groupID = String(Request.QueryString("groupID"));
}
if (String(Request.QueryString("where")) != "undefined" && 
    String(Request.QueryString("where")) != "") { 
  where = unescape(String(Request.QueryString("where")));
}

if(op == "getListNoPrinted"){
	sql = "SELECT * from v_printBarCode where printTimes=0";
	rs = conn.Execute(sql);
			
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("archiveID").value + "|" + rs("name").value + "|" + rs("location").value + "|" + rs("printerName").value + "|" + rs("printDateTime").value;
		rs.MoveNext();
	}
	result = result.substr(2);
	rs.Close();

	Response.Write(escape(result));
}	

%>
