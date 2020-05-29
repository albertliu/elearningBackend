<!--#include file="js/doc.js" -->

<%

if(op == "getEmployeeList"){
	var s = "";
	//如果单位
	if(String(Request.QueryString("unitID")) > "0"){ // 
		s = "unitID=" + String(Request.QueryString("unitID"));
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	//如果有申请单
	if(String(Request.QueryString("orderID")) > "0"){ // 
		s = "SID in(select SID from orderEmployeeList where orderID=" + String(Request.QueryString("orderID")) + ")";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where>""){
		where = " where " + where;
	}
	sql = " FROM v_employeeInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT item,typeName,amount,amountCheck,price,priceCheck,unit,amountA,statusName,engineeringName,projectName,feeCalNo,memo,regDate,registorName" + sql + " order by ID";
	sql = "SELECT top " + basket + " *" + sql + " order by ID";
	rs = conn.Execute(sql);
	
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("SID").value + "|" + rs("name").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("source").value + "|" + rs("age").value + "|" + rs("birthday").value + "|" + rs("sex").value + "|" + rs("sexName").value + "|" + rs("area").value;
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value;
		result += "|" + rs("unitID").value + "|" + rs("unitName").value;
		rs.MoveNext();
	}
	rs.Close();
	
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_employeeInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("SID").value + "|" + rs("name").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("source").value + "|" + rs("age").value + "|" + rs("birthday").value + "|" + rs("sex").value + "|" + rs("sexName").value + "|" + rs("area").value;
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value;
		result += "|" + rs("unitID").value + "|" + rs("unitName").value;
	}
	rs.Close();
	Response.Write(escape(result));
}	

if(op == "update"){
	result = 0;
	if(String(Request.QueryString("SID"))==""){
		result = 1;  //身份证不能为空。
	}
	if(result == 0 && unescape(String(Request.QueryString("name")))==""){
		result = 2;  //姓名不能为空。
	}
	if(result == 0 && String(Request.QueryString("unitID"))=="0"){
		result = 3;  //必须选择一个单位。
	}
	if(result == 0){
		sql = "exec updateEmployeeInfo " + nodeID + ",'" + String(Request.QueryString("SID")) + "','" + unescape(String(Request.QueryString("name"))) + "','" + String(Request.QueryString("area")) + "','" + String(Request.QueryString("unitID")) + "','" + String(Request.QueryString("status")) + "','";
		sql += unescape(String(Request.QueryString("memo"))) + "','" + unescape(String(Request.QueryString("regOperator"))) + "'";

		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT max(ID) as maxID FROM employeeInfo where regOperator='" + unescape(String(Request.QueryString("regOperator"))) + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}
	}
	
	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "delNode"){
	sql = "exec delEmployee '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "getEmployeeNameBySID"){  //根据身份证返回姓名
	result = "";
	sql = "SELECT dbo.getEmployeeNameBySID('" + nodeID + "') as name";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("name").value;
	}
	rs.Close();

	Response.Write(escape(result));
}

%>
