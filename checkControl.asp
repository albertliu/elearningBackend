<!--#include file="js/doc.js" -->

<%
if(op == "getCheckList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(item like('%" + where + "%') or memo like('%" + where + "%'))";
	}
	//如果有分类，按照分类查询
	if(kindID > ""){ // 有分类
		s = "checkKind=" + kindID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有状态，按照状态查询
	if(status > ""){ // 有分类
		s = "status=" + status;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果查找本人提交的
	if(keyID == 0){ // 
		s = "regOperator='" + currUser + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果查找本人审批的
	if(keyID == 1){ // 
		s = "dbo.userIsChecker('" + currUser + "',ID,0)>0";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有起始日期
	if(fStart > ""){ // 
		s = "dateStart>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有截止日期
	if(fEnd > ""){ // 
		s = "dateEnd<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where>""){
		where = " where " + where;
	}
	
	sql = " FROM v_checkInfo " + where;
	result = getBasketTip(sql,"");
	
	ssql = "SELECT item,statusName,checkKindName,checkClassName,currStep,dateStart,dateEnd,memo,regDate,registorName" + sql + " order by dateStart desc";
	sql = "SELECT top " + basket + " * " + sql + " order by dateStart desc";

	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("item").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("checkKind").value + "|" + rs("checkKindName").value + "|" + rs("checkClass").value + "|" + rs("checkClassName").value + "|" + rs("refID").value + "|" + rs("mark").value + "|" + rs("currStep").value + "|" + rs("dateStart").value + "|" + rs("dateEnd").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value + "|" + rs("checkCycle").value + "|" + rs("checkPeriod").value;
		rs.MoveNext();
	}
	rs.Close();

	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	
if(op == "getNodeInfo"){
	sql = "SELECT * FROM v_checkInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	result = rs("ID").value + "|" + rs("item").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("checkKind").value + "|" + rs("checkKindName").value + "|" + rs("checkClass").value + "|" + rs("checkClassName").value + "|" + rs("refID").value + "|" + rs("mark").value + "|" + rs("currStep").value + "|" + rs("dateStart").value + "|" + rs("dateEnd").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value + "|" + rs("checkCycle").value + "|" + rs("checkPeriod").value;
	rs.Close();
	Response.Write(escape(result));
}	
if(op == "update"){
	result = 0;
	if(unescape(String(Request.QueryString("item")))==""){
		result = 2;  //名称不能为空。
	}
	if(result == 0){
		sql = "exec updateCheckInfo " + nodeID + ",'" + unescape(String(Request.QueryString("item"))) + "','" + String(Request.QueryString("checkKind")) + "','" + refID + "','" + String(Request.QueryString("status")) + "','" + String(Request.QueryString("mark")) + "','" + unescape(String(Request.QueryString("regOperator"))) + "'";
		execSQL(sql);
		if(nodeID == 0){
			//这是一个新增的记录
			sql = "SELECT max(ID) as maxID FROM checkInfo where regOperator='" + currUser + "'";
			rs = conn.Execute(sql);
			nodeID = rs("maxID");
		}
	}
		
	result += "|" + nodeID;
	Response.Write(result);
	//Response.Write(escape(sql));
}
if(op == "getCheckIDbyRef"){
	sql = "SELECT ID FROM checkInfo where checkKind=" + kindID + " and refID=" + refID;
	rs = conn.Execute(sql);
	result = rs("ID").value;
	rs.Close();
	Response.Write(result);
}	

if(op == "delNode"){
	sql = "exec delCheckInfo '" + nodeID + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "commit4Check"){
	result = 0;
	//if(nodeID.length != 9){
	//	result = 1;  //组织机构代码应为9位
	//}
	if(result == 0){
		sql = "exec setCheckCommit'" + nodeID + "'";
		rs = conn.Execute(sql);
		execSQL(sql);
	}
	Response.Write(result);
}

%>
