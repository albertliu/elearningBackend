<!--#include file="js/doc.js" -->

<%
if(op == "signIn"){
	sql = "exec setSignIn '" + currUser + "'";
	rs = conn.Execute(sql);
	Response.Write(0);
}

if(op == "signOut"){
	result = 0;
	sql = "exec setSignOut '" + keyID + "'";
	rs = conn.Execute(sql);
	Response.Write(result);
}

if(op == "delNode"){
	sql = "exec delAttendance '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}
%>
