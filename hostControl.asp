<!--#include file="js/doc.js" -->

<%

if(op == "getHostList"){
	var s = "";
	sql = " FROM v_hostInfo ";
	if(currHost > ""){
		sql += "where hostNo='" + currHost + "'";
	}
	result = getBasketTip(sql,"");
	ssql = "SELECT hostNo,hostName,title,kindName,statusName,linker,phone,email,address,memo,regDate,registerName" + sql + " order by hostName";
	sql = "SELECT top " + basket + " *" + sql + " order by hostName";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("hostID").value + "|" + rs("hostNo").value + "|" + rs("hostName").value + "|" + rs("title").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("kindName").value + "|" + rs("statusName").value;
		//8
		result +=  "|" + rs("linker").value + "|" + rs("phone").value + "|" + rs("email").value + "|" + rs("address").value + "|" + rs("logo").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
		rs.MoveNext();
	}

	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_hostInfo where hostID=" + nodeID;
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("hostID").value + "|" + rs("hostNo").value + "|" + rs("hostName").value + "|" + rs("title").value + "|" + rs("kindID").value + "|" + rs("status").value + "|" + rs("kindName").value + "|" + rs("statusName").value;
		//8
		result +=  "|" + rs("linker").value + "|" + rs("phone").value + "|" + rs("email").value + "|" + rs("address").value + "|" + rs("logo").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("QR").value;
		execSQL(sql);
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "delNode"){
	sql = "exec delHostInfo '" + nodeID + "','" + item + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

%>
