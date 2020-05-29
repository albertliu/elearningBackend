<!--#include file="js/doc.js" -->

<%
if(op == "getEmployeeFundsList"){
	sql = " FROM dbo.getEmployeeFundTab(" + nodeID + "," + refID + ",'" + fStart + "','" + fEnd + "') order by seq";
	ssql = "SELECT item,keyDate,alertDays,kindName,statusName,unitName,privateName,holidayName,employeeFunds,regDate,registorName" + sql + " order by ID desc";
	sql = "SELECT *" + sql;
	
	rs = conn.Execute(sql);
	
	while (!rs.EOF){
		result += "%%" + rs("seq").value + "|" + rs("mark").value + "|" + rs("name").value + "|" + rs("SID").value + "|" + rs("item").value;
		rs.MoveNext();
	}
	rs.Close();
	if(result > ""){
		result = result.substr(2);
	}
	
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_employeeFundInfo where SID='" + nodeID + "' and unitID=" + refID + " and ym='" + keyID + "'";
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("SID").value + "|" + rs("name").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("unitID").value + "|" + rs("unitName").value + "|" + rs("ym").value + "|" + rs("source").value;
		result += "|" + rs("age").value + "|" + rs("birthday").value + "|" + rs("sex").value + "|" + rs("sexName").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value;
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "update"){
	result = 0;
	if(unescape(String(Request.QueryString("name")))==""){
		result = 1;  //内容不能为空。
	}
	if(result == 0 && String(Request.QueryString("SID"))==""){
		result = 2;  //内容不能为空。
	}
	if(result == 0 && String(Request.QueryString("unitID"))==0){
		result = 3;  //单位不能为空。
	}
	if(result == 0 && (String(Request.QueryString("ym"))=="")){
		//result = 4;  //月份不能为空。
	}
	if(result == 0 && (nodeID==0 && (String(Request.QueryString("pYear"))=="" || String(Request.QueryString("pMonth"))==""))){
		result = 5;  //起始年月不能为空。
	}
	if(result == 0 && (nodeID==0 && String(Request.QueryString("months"))<"1")){
		result = 6;  //连续月数不能小于1。
	}
	if(result == 0){
	//@ID int,@SID varchar(50),@name varchar(50),@ym varchar(50),@unitID int,@status int,@pY int,@pM int,@m int,@memo varchar(500),@regOperator varchar(50)

		sql = "exec updateEmployeeFundInfo " + nodeID + ",'" + String(Request.QueryString("SID")) + "','" + unescape(String(Request.QueryString("name"))) + "','" + String(Request.QueryString("ym")) + "','" + String(Request.QueryString("unitID")) + "','" + String(Request.QueryString("status")) + "','";
		sql += String(Request.QueryString("pYear")) + "','" + String(Request.QueryString("pMonth")) + "','" + String(Request.QueryString("months")) + "','" + unescape(String(Request.QueryString("memo"))) + "','" + unescape(String(Request.QueryString("regOperator"))) + "'";

		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT max(ID) as maxID FROM employeeFundInfo where regOperator='" + unescape(String(Request.QueryString("regOperator"))) + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}
	}

	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "delNode"){
	sql = "exec delEmployeeFundInfo '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "setOrderEmployeeConfirm"){
	sql = "exec setOrderEmployeeConfirm '" + nodeID + "','" + keyID + "','" + refID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
	//Response.Write(sql);
}

%>
