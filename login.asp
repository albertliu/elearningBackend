<%@LANGUAGE="JAVASCRIPT" CODEPAGE="65001"%>
<%Session.CodePage=65001%>
<!--#include file="Connections/conn_js.asp" -->

<%
var op = String(Request.QueryString("op"));
var result = 0;
Date.prototype.format = function(format) //author: meizz 
{ 
  var o = { 
    "M+" : this.getMonth()+1, //month 
    "d+" : this.getDate(),    //day 
    "h+" : this.getHours(),   //hour 
    "m+" : this.getMinutes(), //minute 
    "s+" : this.getSeconds(), //second 
    "q+" : Math.floor((this.getMonth()+3)/3),  //quarter 
    "S" : this.getMilliseconds() //millisecond 
  } 
  if(/(y+)/.test(format)) format=format.replace(RegExp.$1, 
    (this.getFullYear()+"").substr(4 - RegExp.$1.length)); 
  for(var k in o)if(new RegExp("("+ k +")").test(format)) 
    format = format.replace(RegExp.$1, 
      RegExp.$1.length==1 ? o[k] : 
        ("00"+ o[k]).substr((""+ o[k]).length)); 
  return format; 
} 
var username = String(Request.QueryString("username")).replace(/\'/g,"").replace(/\ /g,"").replace(/\=/g,"");
var passwd = String(Request.QueryString("passwd"));
var currHost = String(Request.QueryString("host"));
var currDate = new Date().format("yyyy-MM-dd");

if(op == "login"){
	sql = "SELECT * from dbo.userLogin('" + username + "','" + passwd + "','" + currHost + "')";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		if(rs("e").value==0){
			Session("name_key") = rs("realName").value;
			Session("user_key") = rs("userName").value;
			Session("user_id") = rs("userID").value;
			Session("user_host") = currHost;
			Session("user_hostName") = rs("hostName").value;
			Session("user_hostKind") = rs("hostKind").value;
			Session("user_deptID") = rs("deptID").value;
			Session.Timeout=360; //SEESION有效时间为360分钟
		}
		result = rs("e").value + "|" + rs("msg").value+"|"+currHost+"|"+rs("deptID").value;
	}	
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}
/*
sub setSID()
	if (Session("SID")>"") then
		dim rsTemp

		Set rsTemp = Server.CreateObject("ADODB.Recordset")
		sql = "update vistLog set userID='" & Session("user_key") & "' where SID=" & Session("SID")
		rsTemp.Open sql,conn,1,3
		
		'rsTemp.Close()
		'Set rsTemp = Nothing
	end if
end sub
*/
%>
