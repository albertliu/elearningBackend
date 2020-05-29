<!--#include file="js/doc.js" -->

<%
if(op == "getCheckFlowList"){
	sql = " FROM v_checkFlow a, orderInfo b where a.checkID=b.ID and b.kindID=" + kindID + " and b.refID=" + refID + " order by a.ID desc";
	//sql = "SELECT ID,checkID,checkStep,checkNo,item,status,statusName,checkCycle,checkerRight,planDate,checkDate,checkerID,checkerName,pID,pStatus,pStatusName,mark,checkType,memo,regDate,regOperator,registorName " + sql;
	sql = "SELECT a.* " + sql;

	rs = conn.Execute(sql);
	
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("checkID").value + "|" + rs("checkStep").value + "|" + rs("item").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("checkCycle").value + "|" + rs("checkerRight").value + "|" + rs("planDate").value + "|" + rs("checkDate").value + "|" + rs("checkerID").value + "|" + rs("checkerName").value + "|" + rs("pID").value + "|" + rs("pStatus").value + "|" + rs("pStatusName").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value + "|" + rs("mark").value + "|" + rs("checkType").value + "|" + rs("checkNo").value;
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
	sql = "SELECT * FROM v_checkFlow where ID=" + nodeID;
	rs = conn.Execute(sql);
	result = rs("ID").value + "|" + rs("checkID").value + "|" + rs("checkStep").value + "|" + rs("item").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("checkCycle").value + "|" + rs("checkerRight").value + "|" + rs("planDate").value + "|" + rs("checkDate").value + "|" + rs("checkerID").value + "|" + rs("checkerName").value + "|" + rs("pID").value + "|" + rs("pStatus").value + "|" + rs("pStatusName").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value + "|" + rs("mark").value + "|" + rs("checkType").value + "|" + rs("checkNo").value;
	rs.Close();
	Response.Write(escape(result));
}	
if(op == "update"){
	result = 0;
	if(unescape(String(Request.QueryString("memo")))==""){
		result = 2;  //内容不能为空。
	}
	if(result == 0){
		sql = "exec updateCheckFlow " + nodeID + ",'" + unescape(String(Request.QueryString("memo"))) + "','" + unescape(String(Request.QueryString("regOperator"))) + "'";
		execSQL(sql);
	}
		
	result += "|" + nodeID;
	Response.Write(result);
	//Response.Write(escape(sql));
}

if(op == "delNode"){
	sql = "exec delCheckFlow '" + nodeID + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "setCheckFlowAction"){
	//@ID 本节点流水号  0 当前活动节点；>0 指定节点
	//@returnStep 退回目标节点审批代码
	//@status 本节点审批结果  0 无；1 同意 2 退回 3 暂停
	//@memo 本节点审批意见
	//@checkID int,@ID int,@status int,@returnStep int,@memo varchar(5000),@regOperator varchar(50)
	result = 0;
	var s = "";

	if(result == 0 && status==2 && unescape(String(Request.QueryString("memo")))==""){
		result = 2;  //退回时审批意见不能为空。
	}
	if(result == 0){
		sql = "exec setCheckFlowAction 0," + nodeID + "," + status + "," + keyID + ",'" + unescape(String(Request.QueryString("memo"))) + "','" + currUser + "'";
		execSQL(sql);
	}
	result += "|" + nodeID + "|" + s;
	Response.Write(result);
	//Response.Write(escape(sql));
}

if(op == "setCheckFlowActionBatch"){
	result = 0;
	sql = "exec setCheckFlowActionBatch '" + kindID + "','" + refID + "','" + currUser + "'";
	execSQL(sql);
	sql = "SELECT dbo.getExecResult('" + op + "','" + currUser + "') as result";
	rs = conn.Execute(sql);
	result = rs("result");
	Response.Write(result);
	//Response.Write(escape(sql));
}

if(op == "getFlowList4Return"){
	sql = "SELECT checkStep,item FROM dbo.getFlowList4Return(" + nodeID + ")";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("checkStep").value + "|" + rs("item").value;
		rs.MoveNext();
	}
	rs.Close();
	
	if(result > ""){
		result = result.substr(2);
	}

	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	
%>
