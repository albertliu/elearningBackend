<!--#include file="js/doc.js" -->

<%

if(op == "getBossList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(bossName like('%" + where + "%') or SID='" + where + "' or unitName like('%" + where + "%') or unitCode='" + where + "' or regNo='" + where + "')";
	}else{
		//如果有单位类别
		if(String(Request.QueryString("unitKind")) > "0"){ // 
			s = "unitKind=" + String(Request.QueryString("unitKind"));
			if(where > ""){
				where = where + " and " + s;
			}else{
				where = s;
			}
		}
		//如果有状态
		if(status > ""){ // 
			s = "a.status=" + status;
			if(where > ""){
				where = where + " and " + s;
			}else{
				where = s;
			}
		}
		//如果有街道
		if(String(Request.QueryString("street")) > "0"){ // 
			s = "unitStreet=" + String(Request.QueryString("street"));
			if(where > ""){
				where = where + " and " + s;
			}else{
				where = s;
			}
		}
		//如果有园区
		if(String(Request.QueryString("parkID")) > "0"){ // 
			s = "park=" + String(Request.QueryString("parkID"));
			if(where > ""){
				where = where + " and " + s;
			}else{
				where = s;
			}
		}
		if(fStart > ""){
			s += " regTime>='" + fStart + "'";
			if(where > ""){
				where = where + " and " + s;
			}else{
				where = s;
			}
		}
		if(fEnd > ""){
			s += " regTime<='" + fEnd + "'";
			if(where > ""){
				where = where + " and " + s;
			}else{
				where = s;
			}
		}
	}

	if(where>""){
		where = " where " + where;
	}
	sql = " FROM v_bossInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT item,typeName,amount,amountCheck,price,priceCheck,unit,amountA,statusName,engineeringName,projectName,feeCalNo,memo,regDate,registorName" + sql + " order by ID";
	sql = "SELECT top " + basket + " *" + sql + " order by SID";
	rs = conn.Execute(sql);
	
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("SID").value + "|" + rs("bossName").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("age").value + "|" + rs("birthday").value + "|" + rs("sex").value + "|" + rs("sexName").value + "|" + rs("area").value + "|" + rs("areaName").value + "|" + rs("education").value + "|" + rs("educationName").value;
		result += "|" + rs("phone").value + "|" + rs("email").value + "|" + rs("IM").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value;
		result += "|" + rs("unitID").value + "|" + rs("unitName").value + "|" + rs("unitCode").value + "|" + rs("regNo").value + "|" + rs("regTime").value + "|" + rs("unitKind").value + "|" + rs("unitKindName").value + "|" + rs("park").value + "|" + rs("parkName").value + "|" + rs("street").value + "|" + rs("streetName").value;
		rs.MoveNext();
	}
	rs.Close();
	
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_bossInfo where SID='" + nodeID + "'";
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("SID").value + "|" + rs("bossName").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("age").value + "|" + rs("birthday").value + "|" + rs("sex").value + "|" + rs("sexName").value + "|" + rs("area").value + "|" + rs("areaName").value + "|" + rs("education").value + "|" + rs("educationName").value;
		result += "|" + rs("phone").value + "|" + rs("email").value + "|" + rs("IM").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value;
	}
	rs.Close();
	Response.Write(escape(result));
}	

if(op == "update"){
	result = 0;
	if(nodeID==""){
		result = 1;  //身份证不能为空。
	}
	if(result == 0 && unescape(String(Request.QueryString("name")))==""){
		result = 2;  //姓名不能为空。
	}
	if(result == 0 && String(Request.QueryString("phone"))==""){
		result = 3;  //联系电话不能为空。
	}
	if(result == 0){
		sql = "exec updateBossInfo '" + nodeID + "','" + unescape(String(Request.QueryString("name"))) + "','" + String(Request.QueryString("area")) + "','" + String(Request.QueryString("education")) + "','" + String(Request.QueryString("status")) + "','";
		sql += unescape(String(Request.QueryString("phone"))) + "','" + unescape(String(Request.QueryString("email"))) + "','" + unescape(String(Request.QueryString("IM"))) + "','" + unescape(String(Request.QueryString("memo"))) + "','" + unescape(String(Request.QueryString("regOperator"))) + "'";

		execSQL(sql);
	}
	
	result += "|" + nodeID;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "delNode"){
	sql = "exec delBossInfo '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "getBossNameBySID"){  //根据身份证返回姓名
	result = "";
	sql = "SELECT bossName FROM bossInfo where SID='" + nodeID + "'";
	
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("bossName").value;
	}
	rs.Close();

	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

%>
