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
	if(status > ""){ // 
		s = "status=" + status;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	/*//如果有分类
	if(kindID > ""){ // 
		s = "kindID=" + kindID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}*/
	//如果有部门
	if(kindID > "" && kindID != "null"){ // 
		s = "dept1=" + kindID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有招生批次
	if(refID > "" && refID != "null"){ // 
		s = "projectID='" + refID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fStart > ""){
		s = "regDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > ""){
		s = "regDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	/*
	if(String(Request.QueryString("old")) == 1){
		s = "age>=55";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}*/
	//课程
	if(String(Request.QueryString("courseID")) > ""){
		s = "courseID='" + String(Request.QueryString("courseID")) + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//确认
	if(String(Request.QueryString("checked")) > ""){
		s = "checked=" + String(Request.QueryString("checked"));
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//提交
	if(String(Request.QueryString("submited")) > ""){
		s = "submited=" + String(Request.QueryString("submited"));
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//不合格图片状态
	var photoStatus = String(Request.QueryString("photoStatus"));
	if(photoStatus > ""){
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
	ssql = "SELECT SNo,username,name,sexName,age,hostName,dept1Name,dept2Name,job,mobile,email,checkName,courseName,hours,statusName,startDate,completion,examScore,memo,regDate" + sql + " order by projectID,SNo";
	sql = "SELECT top " + basket + " *" + sql + " order by ID desc";
	
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
		result += "|" + rs("submited").value + "|" + rs("submitName").value;
		rs.MoveNext();
	}
	rs.Close();
	/**/
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write((sql));
	//Response.Write('["x":1, "y": "22"]');
}	

if(op == "getNodeInfo"){
	result = "";
	sql = "SELECT *,[dbo].[getPassCondition](ID) as pass_condition FROM v_studentCourseList where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("courseID").value + "|" + rs("courseName").value;
		//7
		result += "|" + rs("sexName").value + "|" + rs("age").value + "|" + rs("hours").value + "|" + rs("completion").value + "|" + rs("regDate").value + "|" + rs("hostName").value + "|" + rs("dept1Name").value + "|" + rs("dept2Name").value + "|" + rs("examScore").value + "|" + rs("memo").value + "|" + rs("mobile").value + "|" + rs("email").value;
		//19
		result += "|" + rs("startDate").value + "|" + rs("endDate").value + "|" + rs("job").value + "|" + rs("pass_condition").value + "|" + rs("checked").value + "|" + rs("checkName").value + "|" + rs("SNo").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "setMemo"){
	result = 0;
	if(result == 0){
		sql = "exec setStudentCourseMemo " + nodeID + ",'" + item + "'";
		execSQL(sql);
	}
	Response.Write(escape(result));
}

if(op == "delNode"){
	sql = "exec delStudentCourseList '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}

if(op == "doStudentCourse_check"){
	sql = "exec doStudentCourse_check '" + refID + "'," + status + ",'" + keyID + "','" + host + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
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

%>
