<!--#include file="js/doc.js" -->

<%
var result = 0;
var receiver = "";
var subject = "";
var content = "";
subject = String(Request.Form("subject"));
receiver = String(Request.Form("receiver"));
content = String(Request.Form("content"));

sql = "";
if(receiver == ""){
	result = 1;
}else{
	sql = "EXEC send_dbmailByUserList '" + receiver + "','" + subject + "','" + content + "','9'";
	//'9' means it's a menual email
	execSQL(sql);
}	
/*
*/
Response.Write(result);
%>
