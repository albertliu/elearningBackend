<!--#include file="js/doc.js" -->

<%

if(op == "getStudentCourseList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(name like('%" + where + "%') or username='" + where + "' or courseName like('%" + where + "%'))";
	}
	//如果有公司
	if(host > ""){ // 
		s = "host='" + host + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
		//如果有部门
		if(currDeptID > 0){ // 
			s = "dept1=" + currDeptID;
			where = where + " and " + s;
		}
	}
	//如果有状态
	if(status > "" && status !="undefined"){ // 
		s = "status=" + status;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有人
	if(keyID > ""){ // 
		s = "username='" + keyID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有部门
	if(kindID > "" && kindID != "null" && kindID !="undefined"){ // 
		s = "dept1=" + kindID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有招生批次
	if(refID > "" && refID != "null" && refID !="undefined"){ // 
		s = "projectID='" + refID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有班级
	if(String(Request.QueryString("classID")) > "" && String(Request.QueryString("classID")) != "null" && String(Request.QueryString("classID")) !="undefined"){ // 
		s = "classID='" + String(Request.QueryString("classID")) + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有初训复训
	if(String(Request.QueryString("reexamine")) > "" && String(Request.QueryString("reexamine")) != "null" && String(Request.QueryString("reexamine")) !="undefined"){ // 
		s = "reexamine=" + String(Request.QueryString("reexamine"));
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有材料确认
	if(String(Request.QueryString("materialChecked")) > "" && String(Request.QueryString("materialChecked")) != "null" && String(Request.QueryString("materialChecked")) !="undefined"){ // 
		s = "materialCheck=" + String(Request.QueryString("materialChecked"));
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fStart > "" && fStart !="undefined"){
		if(currHost>""){
			s = "regDate>='" + fStart + "'";
		}else{
			s = "submitDate>='" + fStart + "'";
		}
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > "" && fEnd !="undefined"){
		if(currHost>""){
			s = "regDate<='" + fEnd + "'";
		}else{
			s = "submitDate<='" + fEnd + "'";
		}
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//mark=1: 学校教务查询。
	if(String(Request.QueryString("mark")) == 1){
		//s = "projectID>'' and ((host = 'spc' and checked=1) or host<>'spc')";
		s = "projectID>''";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//mark=2: 前台报名。
	if(String(Request.QueryString("mark")) == 2){
		s = "projectID>'' and ((host = 'spc' and checked<2) or host<>'spc')";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//课程
	if(String(Request.QueryString("courseID")) > "" && String(Request.QueryString("courseID")) !="undefined"){
		s = "courseID='" + String(Request.QueryString("courseID")) + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//确认
	if(String(Request.QueryString("checked")) > "" && String(Request.QueryString("checked")) !="undefined"){
		s = "checked=" + String(Request.QueryString("checked"));
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//提交
	if(String(Request.QueryString("submited")) > "" && String(Request.QueryString("submited")) !="undefined"){
		s = "submited=" + String(Request.QueryString("submited"));
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//未做准考证
	if(String(Request.QueryString("passcard")) == "0"){
		s = "passcardID=0";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//已做准考证
	if(String(Request.QueryString("passcard")) == "1"){
		s = "passcardID>0";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//不合格图片状态
	var photoStatus = String(Request.QueryString("photoStatus"));
	if(photoStatus > "" && photoStatus !="undefined"){
		s = "(status0=" + photoStatus + " or status1=" + photoStatus + " or status2=" + photoStatus + " or status3=" + photoStatus + " or status4=" + photoStatus + ")";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM v_studentCourseList " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT SNo,username,name,sexName,age,educationName,(case when host='znxf' then unit else hostName end),(case when host='znxf' then dept else dept1Name end),(case when host='znxf' then '' else dept2Name end),job,mobile,phone,checkName,projectID+projectName,classID,statusName,price,pay_typeName,pay_kindName,datePay,invoice,(case when diploma_score=0 then '' else cast(diploma_score as varchar) end),diplomaID,diploma_startDate,diploma_endDate,memo,regDate" + sql + " order by projectID,SNo";
	sql = "SELECT top " + basket + " *,[dbo].[getMissingItems](ID) as missingItems" + sql + " order by ID desc";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("courseID").value + "|" + rs("courseName").value;
		//7
		result += "|" + rs("sexName").value + "|" + rs("age").value + "|" + rs("hours").value + "|" + rs("completion").value + "|" + rs("regDate").value + "|" + rs("hostName").value + "|" + rs("dept1Name").value + "|" + rs("dept2Name").value + "|" + rs("examScore").value;
		//16
		result += "|" + rs("checked").value + "|" + rs("checkName").value + "|" + rs("photo_filename").value + "|" + rs("IDa_filename").value + "|" + rs("IDb_filename").value + "|" + rs("edu_filename").value + "|" + rs("cert_filename").value;
		//23
		result += "|" + rs("status0").value + "|" + rs("askerID0").value + "|" + rs("askDate0").value + "|" + rs("status1").value + "|" + rs("askerID1").value + "|" + rs("askDate1").value + "|" + rs("status2").value + "|" + rs("askerID2").value + "|" + rs("askDate2").value;
		//32
		result += "|" + rs("status3").value + "|" + rs("askerID3").value + "|" + rs("askDate3").value + "|" + rs("status4").value + "|" + rs("askerID4").value + "|" + rs("askDate4").value;
		//38
		result += "|" + rs("submited").value + "|" + rs("submitDate").value + "|" + rs("submitName").value;
		//41
		result += "|" + rs("projectID").value + "|" + rs("classID").value + "|" + rs("SNo").value + "|" + rs("materialCheck").value + "|" + rs("materialChecker").value + "|" + rs("materialCheckerName").value;
		//47
		result += "|" + rs("price").value + "|" + rs("pay_kindName").value + "|" + rs("pay_typeName").value + "|" + rs("pay_statusName").value;
		//51
		result += "|" + rs("projectName").value + "|" + rs("className").value + "|" + rs("passcardID").value + "|" + rs("unit").value + "|" + rs("dept").value + "|" + rs("host").value;
		//57
		result += "|" + rs("reexamine").value + "|" + rs("reexamineName").value + "|" + rs("examTimes").value + "|" + rs("certID").value + "|" + rs("missingItems").value + "|" + rs("shortName").value + "|" + rs("job").value;
		//64
		result += "|" + rs("diplomaID").value + "|" + rs("applyID").value + "|" + rs("score").value + "|" + rs("submiterName").value + "|" + rs("reExamCount").value;
		rs.MoveNext();
	}
	rs.Close();
	/**/
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write((sql));
}	

if(op == "getStudentListByClass"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(name like('%" + where + "%') or username='" + where + "')";
	}
	//报到日期
	if(fStart > "" && fStart !="undefined"){
		s = "submitDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//预报名
	if(kindID > ""){
		s = "mark=" + kindID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > "" && fEnd !="undefined"){
		s = "submitDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//确认
	if(String(Request.QueryString("checked")) > "" && String(Request.QueryString("checked")) !="undefined"){
		s = "checked=" + String(Request.QueryString("checked"));
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//报到
	if(String(Request.QueryString("submited")) > "" && String(Request.QueryString("submited")) !="undefined"){
		s = "submited=" + String(Request.QueryString("submited"));
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM dbo.getStudentListByClass('" + refID + "','" + host + "') " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT ID,SNo,username,name,education,deptName,stationName,job,mobile,memo,expireDate,invoice,checkDate,checkerName,submitDate,submiterName,(case when mark=0 then '计划内' else '计划外' end) as kind" + sql + " order by mark,ID";
	sql = "SELECT top " + basket + " *" + sql + " order by mark,ID";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("SNo").value + "|" + rs("education").value + "|" + rs("job").value + "|" + rs("mobile").value;
		//7
		result += "|" + rs("mark").value + "|" + rs("stationName").value + "|" + rs("dept1").value + "|" + rs("deptName").value + "|" + rs("expireDate").value;
		//12
		result += "|" + rs("invoice").value + "|" + rs("classID").value + "|" + rs("memo").value;
		//15
		result += "|" + rs("submited").value + "|" + rs("submitDate").value + "|" + rs("submiter").value + "|" + rs("submiterName").value;
		//19
		result += "|" + rs("checked").value + "|" + rs("checkDate").value + "|" + rs("checker").value + "|" + rs("checkerName").value + "|" + rs("enterID").value;
		rs.MoveNext();
	}
	rs.Close();
	/**/
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write((sql));
}	

if(op == "getStudentListByProject"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(name like('%" + where + "%') or username='" + where + "')";
	}
	//招生批次
	if(refID > ""){
		s = "projectID='" + refID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//报名日期
	if(fStart > "" && fStart !="undefined"){
		s = "regDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > "" && fEnd !="undefined"){
		s = "regDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//确认
	if(String(Request.QueryString("checked")) > "" && String(Request.QueryString("checked")) !="undefined"){
		s = "checked=" + String(Request.QueryString("checked"));
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//报到
	if(String(Request.QueryString("submited")) > "" && String(Request.QueryString("submited")) !="undefined"){
		s = "submited=" + String(Request.QueryString("submited"));
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM v_studentCourseList" + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT ID,username,name,educationName,dept1Name,dept2Name,job,mobile,memo,examScore,score,checkDate,checkerName,submitDate,submiterName" + sql + " order by dept2Name,ID";
	sql = "SELECT top " + basket + " *" + sql + " order by ID";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("sexName").value + "|" + rs("educationName").value + "|" + rs("job").value + "|" + rs("mobile").value;
		//7
		result += "|" + rs("examScore").value + "|" + rs("dept2Name").value + "|" + rs("dept1").value + "|" + rs("dept1Name").value + "|" + rs("score").value;
		//12
		result += "|" + rs("projectID").value + "|" + rs("classID").value + "|" + rs("memo").value;
		//15
		result += "|" + rs("submited").value + "|" + rs("submitDate").value + "|" + rs("submiter").value + "|" + rs("submiterName").value;
		//19
		result += "|" + rs("checked").value + "|" + rs("checkDate").value + "|" + rs("checker").value + "|" + rs("checkerName").value;
		//23
		result += "|" + rs("diplomaID").value + "|" + rs("diploma_startDate").value + "|" + rs("diploma_endDate").value + "|" + rs("reExamCount").value + "|" + rs("examTimes").value + "|" + rs("passcardID").value;
		rs.MoveNext();
	}
	rs.Close();
	/**/
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write((sql));
}	

if(op == "getNodeInfo"){
	result = "";
	sql = "SELECT *,[dbo].[getPassCondition](ID) as pass_condition,[dbo].[getMissingItems](ID) as missingItems FROM v_studentCourseList where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("courseID").value + "|" + rs("courseName").value;
		//7
		result += "|" + rs("sexName").value + "|" + rs("age").value + "|" + rs("hours").value + "|" + rs("completion").value + "|" + rs("regDate").value + "|" + rs("hostName").value + "|" + rs("dept1Name").value + "|" + rs("dept2Name").value + "|" + rs("examScore").value + "|" + rs("memo").value + "|" + rs("mobile").value + "|" + rs("email").value;
		//19
		result += "|" + rs("startDate").value + "|" + rs("endDate").value + "|" + rs("job").value + "|" + rs("pass_condition").value + "|" + rs("checked").value + "|" + rs("checkName").value + "|" + rs("SNo").value;
		//26
		result += "|" + rs("projectID").value + "|" + rs("classID").value + "|" + rs("materialCheck").value + "|" + rs("materialChecker").value + "|" + rs("materialCheckerName").value + "|" + rs("checkDate").value + "|" + rs("checkerName").value;
		//33
		result += "|" + rs("projectName").value + "|" + rs("className").value + "|" + rs("entryform").value + "|" + rs("certID").value + "|" + rs("unit").value + "|" + rs("dept").value + "|" + rs("host").value;
		//40
		result += "|" + rs("reexamine").value + "|" + rs("reexamineName").value + "|" + rs("examTimes").value + "|" + rs("missingItems").value + "|" + rs("submiterName").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getPayList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(name like('%" + where + "%') or username='" + where + "' or courseName like('%" + where + "%') or classID like('%" + where + "%') or invoice like('%" + where + "%'))";
	}
	//如果有公司
	if(host > ""){ // 
		s = "host='" + host + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
		//如果有部门
		if(currDeptID > 0){ // 
			s = "dept1=" + currDeptID;
			where = where + " and " + s;
		}
	}
	//如果有状态
	if(status > "" && status !="undefined"){ // 
		s = "pay_status=" + status;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有人
	if(keyID > "" && keyID != "null" && keyID !="undefined"){ // 
		s = "username='" + keyID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有部门
	if(kindID > "" && kindID != "null" && kindID !="undefined"){ // 
		s = "dept1=" + kindID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有招生批次
	if(refID > "" && refID != "null" && refID !="undefined"){ // 
		s = "projectID='" + refID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有班级
	if(String(Request.QueryString("classID")) > "" && String(Request.QueryString("classID")) != "null" && String(Request.QueryString("classID")) !="undefined"){ // 
		s = "classID='" + String(Request.QueryString("classID")) + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fStart > "" && fStart !="undefined"){
		s = "datePay>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > "" && fEnd !="undefined"){
		s = "datePay<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//课程
	if(String(Request.QueryString("courseID")) > "" && String(Request.QueryString("courseID")) !="undefined"){
		s = "courseID='" + String(Request.QueryString("courseID")) + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM v_payDetailInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT SNo,username,name,sexName,age,hostName,dept1Name,dept2Name,job,mobile,email,checkName,courseName,hours,statusName,startDate,completion,examScore,memo,regDate" + sql + " order by projectID,SNo";
	sql = "SELECT top " + basket + " *" + sql + " order by ID desc";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("payID").value + "|" + rs("enterID").value + "|" + rs("price").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//8
		result += "|" + rs("courseID").value + "|" + rs("courseName").value + "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("dept1").value + "|" + rs("dept1Name").value + "|" + rs("dept2").value + "|" + rs("dept2Name").value;
		//16
		result += "|" + rs("payID_old").value + "|" + rs("invoice").value + "|" + rs("datePay").value + "|" + rs("pay_checkDate").value + "|" + rs("pay_checkerID").value + "|" + rs("pay_checkerName").value;
		//22
		result += "|" + rs("dateInvoice").value + "|" + rs("dateInvoicePick").value + "|" + rs("dateRefund").value + "|" + rs("refunderID").value + "|" + rs("refunderName").value;
		//27
		result += "|" + rs("projectID").value + "|" + rs("projectName").value + "|" + rs("classID").value + "|" + rs("className").value + "|" + rs("SNo").value;
		//32
		result += "|" + rs("pay_kindID").value + "|" + rs("pay_kindName").value + "|" + rs("pay_type").value + "|" + rs("pay_typeName").value + "|" + rs("pay_status").value + "|" + rs("pay_statusName").value;
		//38
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("unit").value + "|" + rs("dept").value;
		rs.MoveNext();
	}
	rs.Close();
	/**/
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write((sql));
}	

if(op == "getPayInfo"){
	result = "";
	sql = "SELECT * FROM v_payInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("invoice").value + "|" + rs("amount").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("kindID").value + "|" + rs("kindName").value + "|" + rs("type").value + "|" + rs("typeName").value;
		//9
		result += "|" + rs("datePay").value + "|" + rs("dateInvoice").value + "|" + rs("dateInvoicePick").value + "|" + rs("dateRefund").value + "|" + rs("refunderID").value + "|" + rs("refunderName").value;
		//15
		result += "|" + rs("checkDate").value + "|" + rs("checkerID").value + "|" + rs("checkerName").value;
		//18
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("title").value + "|" + rs("projectID").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getInvoiceList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(invoice like('%" + where + "%'))";
	}
	//如果有状态
	if(status > "" && status !="undefined"){ // 
		s = "status=" + status;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有
	if(kindID > "" && kindID != "null" && kindID !="undefined"){ // 
		s = "kindID=" + kindID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有
	if(refID > "" && refID != "null" && refID !="undefined"){ // 
		s = "type=" + refID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fStart > "" && fStart !="undefined"){
		s = "dateInvoice>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > "" && fEnd !="undefined"){
		s = "dateInvoice<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//财务确认
	if(String(Request.QueryString("checked")) == 0 && String(Request.QueryString("checked")) !="undefined"){
		s = "checkDate=''";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//财务确认
	if(String(Request.QueryString("checked")) == 1 && String(Request.QueryString("checked")) !="undefined"){
		s = "checkDate>''";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM v_payInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT SNo,username,name,sexName,age,hostName,dept1Name,dept2Name,job,mobile,email,checkName,courseName,hours,statusName,startDate,completion,examScore,memo,regDate" + sql + " order by projectID,SNo";
	sql = "SELECT top " + basket + " *" + sql + " order by ID desc";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("invoice").value + "|" + rs("amount").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("kindID").value + "|" + rs("kindName").value + "|" + rs("type").value + "|" + rs("typeName").value;
		//9
		result += "|" + rs("datePay").value + "|" + rs("dateInvoice").value + "|" + rs("dateInvoicePick").value + "|" + rs("dateRefund").value + "|" + rs("refunderID").value + "|" + rs("refunderName").value;
		//15
		result += "|" + rs("checkDate").value + "|" + rs("checkerID").value + "|" + rs("checkerName").value;
		//18
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("title").value + "|" + rs("projectID").value;
		rs.MoveNext();
	}
	rs.Close();
	/**/
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write((sql));
}	

if(op == "getPayDetailInfoByEnterID"){
	result = "";
	sql = "SELECT * FROM v_payDetailInfo where enterID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("payID").value + "|" + rs("enterID").value + "|" + rs("price").value + "|" + rs("status").value + "|" + rs("statusName").value;
		//6
		result += "|" + rs("payID_old").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getFiremanEnterInfo"){
	result = "";
	sql = "SELECT * FROM v_firemanEnterInfo where enterID=" + refID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("enterID").value + "|" + rs("area").value + "|" + rs("address").value + "|" + rs("employDate").value + "|" + rs("university").value + "|" + rs("gradeDate").value + "|" + rs("profession").value + "|" + rs("area_now").value;
		//9
		result += "|" + rs("kind1").value + "|" + rs("kind2").value + "|" + rs("kind3").value + "|" + rs("kind4").value + "|" + rs("kind5").value + "|" + rs("kind6").value + "|" + rs("kind7").value + "|" + rs("kind8").value + "|" + rs("kind9").value + "|" + rs("kind10").value + "|" + rs("kind11").value + "|" + rs("kind12").value;
		//21
		result += "|" + rs("materials").value + "|" + rs("materials1").value + "|" + rs("zip").value + "|" + rs("memo").value + "|" + rs("registerID").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getStudentListByClassCheck"){
	result = "";
	sql = "SELECT name,username,dbo.getClassRefrence(username,classID) as item FROM dbo.getStudentListByClass('" + refID + "','" + host + "') where dbo.getClassRefrence(username,classID)>''";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("name").value + "|" + rs("username").value + "|" + rs("item").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getStudentListByProjectCheck"){
	result = "";
	sql = "SELECT name,username,(courseName1 + ', ' + courseName2) as item FROM dbo.getProjectRefrence('" + refID + "')";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("name").value + "|" + rs("username").value + "|" + rs("item").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "updatePayInfo"){
	//@ID int,@invoice varchar(50),@projectID varchar(50),@kindID varchar(50),@type int,@status int,@datePay varchar(50),@dateInvoice varchar(50),@dateInvoicePick varchar(50),@memo
	sql = "exec updatePayInfo " + nodeID + ",'" + String(Request.QueryString("invoice")) + "','" + String(Request.QueryString("projectID")) + "','" + item + "','" + kindID + "','" + String(Request.QueryString("type")) + "','" + status + "','" + String(Request.QueryString("datePay")) + "','" + String(Request.QueryString("dateInvoice")) + "','" + String(Request.QueryString("dateInvoicePick")) + "','" + refID + "','" + memo + "','" + currUser + "',''";
	rs = conn.Execute(sql);
	Response.Write(escape(0));
	//Response.Write(escape(sql));
}

if(op == "updateFiremanEnterInfo"){
	//enterID,area,address,employDate,university,gradeDate,profession,area_now,kind1,kind2,kind3,kind4,kind5,kind6,kind7,kind8,kind9,kind10,kind11,kind12,memo,registerID
	result = "";
	sql = "exec updateFiremanEnterInfo " + refID + ",'" + unescape(String(Request.QueryString("area"))) + "','" + unescape(String(Request.QueryString("address"))) + "','" + String(Request.QueryString("employDate")) + "','" + unescape(String(Request.QueryString("university"))) + "','" + String(Request.QueryString("gradeDate")) + "','" + unescape(String(Request.QueryString("profession"))) + "','" + unescape(String(Request.QueryString("area_now"))) + "','" + String(Request.QueryString("kind1")) + "','" + String(Request.QueryString("kind2")) + "','" + String(Request.QueryString("kind3")) + "','" + String(Request.QueryString("kind4")) + "','" + String(Request.QueryString("kind5")) + "','" + String(Request.QueryString("kind6")) + "','" + String(Request.QueryString("kind7")) + "','" + String(Request.QueryString("kind8")) + "','" + String(Request.QueryString("kind9")) + "','" + String(Request.QueryString("kind10")) + "','" + String(Request.QueryString("kind11")) + "','" + String(Request.QueryString("kind12")) + "','" + memo + "','" + currUser + "'";
	
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("status").value + "|" + rs("msg").value;
		execSQL(sql);
	}
	rs.Close();
	Response.Write(escape(result));
	/**/
	//Response.Write(escape(sql));
}

if(op == "delNode"){
	result = "";
	sql = "exec delEnter '" + nodeID + "','" + where + "','" + currUser + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("status").value + "|" + rs("msg").value;
		execSQL(sql);
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "doStudentCourse_check"){
	sql = "exec doStudentCourse_check " + status + ",'" + refID + "','" + keyID + "','" + host + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
	//Response.Write(sql);
}	

if(op == "doStudentPre_check"){
	sql = "exec doStudentPre_check " + status + ",'" + refID + "','" + keyID + "','" + host + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
	//Response.Write(sql);
}	

if(op == "doStudentCourse_submit"){
	sql = "exec doStudentCourse_submit '" + refID + "'," + status + ",'" + keyID + "','" + host + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}	

if(op == "doStudentMaterial_resubmit"){
	sql = "exec doStudentMaterial_resubmit " + status + ",'" + keyID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}	

if(op == "doMaterial_check"){
	sql = "exec doMaterial_check " + nodeID + ",'" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}	

if(op == "doMaterial_check_batch"){
	sql = "exec doMaterial_check_batch '" + keyID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}	

if(op == "updatePayPrice"){
	sql = "exec updatePayPrice " + nodeID + "," + refID;
	execSQL(sql);
	Response.Write(0);
}	

if(op == "updateEnterClass"){
	sql = "exec updateEnterClass " + nodeID + ",'" + refID + "','" + keyID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}	

if(op == "doEnter"){
	//@username varchar(50),@classID varchar(50),@price int,@invoice varchar(50),@projectID varchar(50),@kindID varchar(50),@type int,@status int,@datePay varchar(50),@dateInvoice varchar(50),@dateInvoicePick varchar(50),@memo,@registerID
	sql = "exec doEnter '" + nodeID + "','" + String(Request.QueryString("classID")) + "','" + String(Request.QueryString("price")) + "','" + String(Request.QueryString("invoice")) + "','" + String(Request.QueryString("projectID")) + "','" + item + "'," + kindID + "," + String(Request.QueryString("type")) + "," + status + ",'" + String(Request.QueryString("datePay")) + "','" + String(Request.QueryString("dateInvoice")) + "','" + String(Request.QueryString("dateInvoicePick"))  + "','" + memo + "','" + currUser + "'";
	
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("re").value + "|" + rs("msg").value + "|" + rs("payID").value + "|" + rs("enterID").value;
	}
	rs.Close();/**/
	Response.Write(result);
	//Response.Write(escape(sql));
}

%>
