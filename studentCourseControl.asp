<!--#include file="js/doc.js" -->

<%

if(op == "getStudentCourseList"){
	var s = "";
	var d = 0;
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(name like('%" + where + "%') or username='" + where + "' or courseName like('%" + where + "%'))";
		d += 1;
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
	//如果需开票
	if(String(Request.QueryString("needInvoice")) == "1"){ // 
		s = "needInvoice=1";	//1 需开票
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
		d += 1;
	}
	//如果预备班
	if(String(Request.QueryString("pre")) == "1"){ // 
		s = "pre=1";	//1 
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fStart > "" && fStart !="undefined" && d == 0){
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
	if(fEnd > "" && fEnd !="undefined" && d == 0){
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
	//mark=3: 当前用户为销售
	if(String(Request.QueryString("mark")) == 3){
		s = "fromID='" + currUser + "'";
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
	//销售
	if(String(Request.QueryString("fromID")) > "" && String(Request.QueryString("fromID")) !="undefined"){
		s = "fromID='" + String(Request.QueryString("fromID")) + "'";
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
	//未做准考证/申报
	if(String(Request.QueryString("passcard")) == "0"){
		s = "passcardID=0 and applyID=0";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//已做准考证/申报
	if(String(Request.QueryString("passcard")) == "1"){
		s = "(passcardID>0 or applyID>0)";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//已做准考证/申报
	if(String(Request.QueryString("examResult")) > "" && String(Request.QueryString("examResult")) !="undefined"){
		s = "result=" + String(Request.QueryString("examResult"));
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
	//学习进度
	if(String(Request.QueryString("completion1")) > "" && String(Request.QueryString("completion1")) !="undefined"){
		s = "completion>=" + String(Request.QueryString("completion1"));
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//学习进度
	var completion2 = String(Request.QueryString("completion2"));
	var score2 = String(Request.QueryString("score2"));
	if(completion2 > "" && completion2 !="undefined"){
		s = "completion<=" + completion2;
		if(score2 > "" && score2 !="undefined"){
			s = "(" + s;
		}
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//模拟成绩
	if(String(Request.QueryString("score1")) > "" && String(Request.QueryString("score1")) !="undefined"){
		s = "examScore>=" + String(Request.QueryString("score1"));
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//模拟成绩
	if(score2 > "" && score2 !="undefined"){
		s = "examScore<=" + score2;
		if(completion2 > "" && completion2 !="undefined"){
			s = " or " + s + ")";
			where = where + s;
		}else{
			if(where > ""){
				where = where + " and " + s;
			}else{
				where = s;
			}
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM v_studentCourseList " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT SNo,username,name,sexName,age,educationName,(case when host<>'spc' and host<>'shm' then unit else hostName end),(case when host<>'spc' and host<>'shm' then dept else dept1Name end),(case when host='znxf' then '' else dept2Name end),job,mobile,phone,address,checkName,projectID+projectName,classID,statusName,price,pay_typeName,pay_kindName,datePay,invoice,completion,(case when examScore=0 then '' else cast(cast(examScore as int) as varchar) end),cast(score as varchar),cast(score2 as varchar),resultName,examDate,diplomaID,diploma_startDate,diploma_endDate,memo,regDate" + sql + " order by SNo";
	sql = "SELECT top 1000 *,[dbo].[getMissingItems](ID) as missingItems" + sql + " order by SNo";
	
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
		result += "|" + rs("diplomaID").value + "|" + rs("applyID").value + "|" + rs("score").value + "|" + rs("submiterName").value + "|" + rs("pay_status").value + "|" + rs("mobile").value + "|" + rs("score1").value + "|" + rs("score2").value;
		//72
		result += "|" + rs("fromID").value + "|" + rs("signature").value + "|" + rs("signatureDate").value + "|" + rs("status_photo").value + "|" + rs("status_signature").value + "|" + rs("signatureType").value;
		//78
		result += "|" + rs("file1").value + "|" + rs("file2").value + "|" + rs("employe_filename").value + "|" + rs("express").value + "|" + rs("memo").value + "|" + rs("currDiplomaDate").value + "|" + rs("needInvoice").value;
		//85
		result += "|" + rs("photo_size").value + "|" + rs("examDate").value + "|" + rs("result").value + "|" + rs("resultName").value + "|" + rs("entryform").value + "|" + rs("source").value;
		rs.MoveNext();
	}
	rs.Close();
	/**/
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write((sql));
}

//被移除班级的学员
if(op == "getStudentListOutClass"){
	// sql = "select * from studentCourseList where status<2 and classID='' and courseID in(select courseID from v_courseInfo where agencyID<>5) order by ID desc";
	where = " where ID in (select ID from studentCourseList where status<2 and classID='' and courseID in(select courseID from v_courseInfo where agencyID<>5))";
	sql = " FROM v_studentCourseList " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT SNo,username,name,sexName,age,educationName,(case when host<>'spc' and host<>'shm' then unit else hostName end),(case when host<>'spc' and host<>'shm' then dept else dept1Name end),(case when host='znxf' then '' else dept2Name end),job,mobile,phone,address,checkName,projectID+projectName,classID,statusName,price,pay_typeName,pay_kindName,datePay,invoice,completion,(case when examScore=0 then '' else cast(cast(examScore as int) as varchar) end),cast(score as varchar) + '/' + cast(score2 as varchar),diplomaID,diploma_startDate,diploma_endDate,memo,regDate" + sql + " order by SNo";
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
		result += "|" + rs("diplomaID").value + "|" + rs("applyID").value + "|" + rs("score").value + "|" + rs("submiterName").value + "|" + rs("pay_status").value + "|" + rs("mobile").value + "|" + rs("score1").value + "|" + rs("score2").value;
		//72
		result += "|" + rs("fromID").value + "|" + rs("signature").value + "|" + rs("signatureDate").value + "|" + rs("status_photo").value + "|" + rs("status_signature").value + "|" + rs("signatureType").value;
		//78
		result += "|" + rs("file1").value + "|" + rs("file2").value + "|" + rs("employe_filename").value + "|" + rs("express").value + "|" + rs("memo").value + "|" + rs("currDiplomaDate").value + "|" + rs("needInvoice").value;
		//85
		result += "|" + rs("photo_size").value + "|" + rs("examDate").value + "|" + rs("result").value + "|" + rs("resultName").value + "|" + rs("entryform").value;
		rs.MoveNext();
	}
	rs.Close();/**/
	
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
		//24
		result += "|" + rs("fromID").value + "|" + rs("signature").value + "|" + rs("signatureDate").value + "|" + rs("status_photo").value + "|" + rs("status_signature").value;
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
	//部门
	/*if(keyID > ""){
		s = "dept1='" + keyID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}*/
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
	//编班
	if(String(Request.QueryString("class")) > "" && String(Request.QueryString("class")) !="undefined"){
        if(String(Request.QueryString("class"))==0){
            s = "classID>''";
        }
        if(String(Request.QueryString("class"))==1){
            s = "classID=''";
        }
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
	ssql = "SELECT ID,username,name,educationName,dept1Name,dept2Name,job,mobile,memo,completion,examScore,score,checkDate,checkerName,submitDate,submiterName" + sql + " order by dept2Name,ID";
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
		//29
		result += "|" + rs("completion").value + "|" + rs("unit").value + "|" + rs("express").value + "|" + rs("accountKindName").value + "|" + rs("payNowName").value;
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
	sql = "SELECT *,[dbo].[getPassCondition](ID) as pass_condition,[dbo].[getMissingItems](ID) as missingItems,[dbo].[getCourseInvoice](ID) as invoicePDF FROM v_studentCourseList where ID=" + nodeID;
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
		result += "|" + rs("reexamine").value + "|" + rs("reexamineName").value + "|" + rs("examTimes").value + "|" + rs("missingItems").value + "|" + rs("submiterName").value + "|" + rs("currDiplomaID").value + "|" + rs("currDiplomaDate").value;
		//47
		result += "|" + rs("fromID").value + "|" + rs("signature").value + "|" + rs("signatureDate").value + "|" + rs("status_photo").value + "|" + rs("status_signature").value + "|" + rs("signatureType").value + "|" + rs("price").value;
		//54
		result += "|" + rs("file1").value + "|" + rs("file2").value + "|" + rs("shortName").value + "|" + rs("overdue").value + "|" + rs("express").value + "|" + rs("payNow").value + "|" + rs("title").value + "|" + rs("needInvoice").value;
		//62
		result += "|" + rs("price").value + "|" + rs("amount").value + "|" + rs("pay_kindID").value + "|" + rs("pay_type").value + "|" + rs("datePay").value + "|" + rs("invoice").value;
		//68
		result += "|" + rs("dateInvoice").value + "|" + rs("dateInvoicePick").value + "|" + rs("dateRefund").value + "|" + rs("refunderID").value + "|" + rs("pay_checkDate").value + "|" + rs("pay_checker").value;
		//74
		result += "|" + rs("pay_memo").value + "|" + rs("pay_status").value + "|" + rs("pay_kindName").value + "|" + rs("pay_typeName").value + "|" + rs("pay_statusName");
		//79
		result += "|" + rs("refunderName").value + "|" + rs("refund_amount").value + "|" + rs("refund_memo").value + "|" + rs("file3").value + "|" + rs("file4").value + "|" + rs("file5").value + "|" + rs("pay_checkerName").value + "|" + rs("completionPass").value;
		//87
		result += "|" + rs("check_pass").value + "|" + rs("noReceive").value + "|" + rs("invoicePDF").value + "|" + rs("invoice_amount").value + "|" + rs("priceStandard").value + "|" + rs("receipt").value;
		//93
		result += "|" + rs("score").value + "|" + rs("score2").value + "|" + rs("result").value + "|" + rs("refID").value + "|" + rs("source").value + "|" + rs("examDate").value + "|" + rs("fromKind").value;
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
	//mark=3: 当前用户为销售
	if(String(Request.QueryString("mark")) == 3){
		s = "fromID='" + currUser + "'";
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

if(op == "enterRefund"){
	//@enterID int,@amount decimal(18,2),@memo nvarchar(500), @registerID varchar(50)
	sql = "exec enterRefund " + nodeID + ",'" + String(Request.QueryString("amount")) + "','" + String(Request.QueryString("dateRefund")) + "','" + memo + "','" + currUser + "'";
	rs = conn.Execute(sql);
	Response.Write(escape(0));
	//Response.Write(escape(sql));
}

if(op == "enterPay"){
	//@enterID int,@amount decimal(18,2),@pay_kind int,@pay_type int,@memo nvarchar(500), @registerID
	sql = "exec enterPay " + nodeID + ",'" + String(Request.QueryString("amount")) + "'," + kindID + "," + refID + ",'" + memo + "','" + currUser + "'";
	rs = conn.Execute(sql);
	Response.Write(escape(0));
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

if(op == "getStudentExamStat"){
	result = "";
	sql = "EXEC getStudentExamStat " + refID;
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("regDate").value + "|" + rs("knowpointName").value + "|" + rs("kindName").value + "|" + rs("score").value + "|" + rs("qty").value + "|" + rs("qtyYes").value + "|" + rs("seq").value + "|" + rs("examID").value + "|" + rs("examName").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getClassExamStat"){
	result = "";
	sql = "EXEC getClassExamStat '" + refID + "'";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("examID").value + "|" + rs("examName").value + "|" + rs("knowPointName").value + "|" + rs("kindName").value + "|" + rs("qty").value + "|" + rs("qtyYes").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getStudentSMSList"){
	result = "";
	s = "";
	//如果有username
	if(nodeID > "" && nodeID != "null" && nodeID !="undefined"){ // 
		s = "username='" + nodeID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有enterID
	if(refID > "0" && refID != "null" && refID !="undefined"){ // 
		s = "refID=" + refID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(where > ""){
		where = " where " + where;
	}
	sql = "select * from v_log_sendsms " + where;
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("kind").value + "|" + rs("message").value + "|" + rs("regDate").value + "|" + rs("registerName").value + "|" + rs("mobile").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);/**/
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getStudentExamList"){
	result = "";
	s = "";
	//如果有username
	if(nodeID > "" && nodeID != "null" && nodeID !="undefined"){ // 
		s = "username='" + nodeID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(where > ""){
		where = " where " + where;
	}
	sql = "select kindID, enterID, certName, startDate as examDate, cast(score as varchar) as score, statusName as resultName, diplomaID,batchID as ID from v_passcardInfo" + where;
	sql += " union select 0, enterID, courseName, examDate, score1 + '/' + score2 , resultName, diplomaID,ID_batch from v_studentApplyList" + where;
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("enterID").value + "|" + rs("certName").value + "|" + rs("examDate").value + "||" + rs("score").value + "|" + rs("resultName").value + "|" + rs("diplomaID").value + "|" + rs("kindID").value + "|" + rs("ID").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);/**/
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getStudentOpList"){
	result = "";
	s = "";
	sql = "select opLogID,event,memo,convert(varchar(20),opDate,120) as opDate,operator from userOpLog where refID='" + nodeID + "'";
	if(refID==1){	//username
		sql += " union select opLogID,event,memo,convert(varchar(20),opDate,120) as opDate,operator from userOpLog where refID in (select cast(ID as varchar) as ID from studentCourseList where username='" + nodeID + "')";
		sql += " union select opLogID,event,memo,convert(varchar(20),opDate,120) as opDate,operator from userOpLog where refID in (select cast(ID as varchar) as ID from del_studentCourseList where username='" + nodeID + "')";
	}
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("opLogID").value + "|" + rs("event").value + "|" + rs("opDate").value + "|" + rs("operator").value + "|" + rs("memo").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);/**/
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
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "doReturn"){
	result = "";
	sql = "exec returnEnter '" + nodeID + "','" + where + "','" + currUser + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("status").value + "|" + rs("msg").value;
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
	sql = "exec doStudentPre_check " + status + ",'" + keyID + "','" + host + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
	//Response.Write(sql);
}	

if(op == "pick_students4class"){
	result = "";
	sql = "exec pickStudents4Class '" + String(Request.Form("batchID")) + "','" + String(Request.Form("selList")) + "','" + currUser + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("re").value;
	}
	rs.Close();
	Response.Write(result);
}

if(op == "pick_students2class"){
	result = "";
	sql = "exec pickStudents2Class '" + String(Request.Form("batchID")) + "','" + String(Request.Form("selList")) + "','" + String(Request.Form("fromClass")) + "','" + currUser + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("re").value;
	}
	rs.Close();
	Response.Write(result);
}

if(op == "pick_students2paynow"){
	result = "";
	sql = "exec pickStudents2Paynow '" + String(Request.Form("payNow")) + "','" + String(Request.Form("selList")) + "','" + String(Request.Form("fromClass")) + "','" + currUser + "'";
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("re").value;
	}
	rs.Close();
	Response.Write(result);
}

if(op == "set_students_express"){
	result = "";
	sql = "exec set_students_express '" + String(Request.Form("selList")) + "','" + currUser + "'";
	rs = conn.Execute(sql);
	//if (!rs.EOF){
		//result = rs("re").value;
		//execSQL(sql);
	//}
	rs.Close();
	Response.Write(1);
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
	sql = "exec updateEnterClass " + nodeID + ",'" + refID + "','" + keyID + "','" + String(Request.QueryString("currDiplomaID")) + "','" + String(Request.QueryString("currDiplomaDate")) + "','" + String(Request.QueryString("signatureDate")) + "','" + item + "'," + String(Request.QueryString("payNow")) + "," + String(Request.QueryString("overdue")) + ",'" + String(Request.QueryString("fromID")) + "','" + memo + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}	

if(op == "doEnter"){
	//@username varchar(50),@classID varchar(50),@price int,@invoice varchar(50),@projectID varchar(50),@kindID varchar(50),@type int,@status int,@datePay varchar(50),@dateInvoice varchar(50),@dateInvoicePick varchar(50),@memo,@registerID
	sql = "exec doEnter '" + nodeID + "','" + String(Request.QueryString("username")) + "','" + String(Request.QueryString("classID")) + "','" + String(Request.QueryString("price")) + "','" + String(Request.QueryString("amount")) + "','" + String(Request.QueryString("invoice")) + "','" + String(Request.QueryString("receipt")) + "','" + String(Request.QueryString("invoice_amount")) + "','" + String(Request.QueryString("projectID")) + "','" + item + "'," + String(Request.QueryString("payNow")) + "," + String(Request.QueryString("needInvoice")) + "," + kindID + "," + String(Request.QueryString("type")) + "," + status + ",'" + String(Request.QueryString("datePay")) + "','" + String(Request.QueryString("dateInvoice")) + "','" + String(Request.QueryString("dateInvoicePick")) + "','" + unescape(String(Request.QueryString("pay_memo"))) + "','" + String(Request.QueryString("currDiplomaID")) + "','" + String(Request.QueryString("currDiplomaDate")) + "'," + String(Request.QueryString("overdue")) + "," + String(Request.QueryString("express")) + ",'" + String(Request.QueryString("fromID"))  + "','" + String(Request.QueryString("fromKind"))  + "','" + String(Request.QueryString("source"))  + "',0,'" + memo + "','" + host + "','" + currUser + "'";
	
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result = rs("re").value + "|" + rs("msg").value + "|" + rs("payID").value + "|" + rs("enterID").value;
	}
	rs.Close();/**/
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "closeStudentCourse"){
	result = "";
	sql = "exec closeStudentCourse '" + nodeID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}

if(op == "closeStudentCourseBatch"){
	result = "";
	sql = "exec closeStudentCourseBatch '" + String(Request.Form("classID")) + "','" + String(Request.Form("selList")) + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}

if(op == "reviveStudentCourse"){
	result = "";
	sql = "exec reviveStudentCourse '" + nodeID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}

if(op == "rebuildStudentLesson"){
	result = "";
	sql = "exec rebuildStudentLesson '" + nodeID + "'";
	execSQL(sql);
	Response.Write(0);
}

if(op == "rebuildLessonByClass"){
	result = "";
	sql = "exec rebuildLessonByClass '" + nodeID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}

if(op == "getStudentLessonList"){
	result = "";
	sql = "select *, dbo.getVideoShots(ID) as shots from v_studentLessonList where refID=" + refID + " order by seq";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("lessonName").value + "|" + rs("hours").value + "|" + rs("completion").value + "|" + rs("shots").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);/**/
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "getFaceList"){
	result = "";
	sql = "select * from v_faceDetectInfo where refID in(select ID from studentVideoList where refID=" + refID + " and kindID=0) order by regDate";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += ",{'ID':'" + rs("ID").value + "','file1':'" + rs("file1").value + "','file2':'" + rs("file2").value + "','status':'" + rs("status").value + "','statusName':'" + rs("statusName").value + "','regDate':'" + rs("regDate").value + "'}";
		rs.MoveNext();
	}
	rs.Close();
	if(result>""){
		result = result.substr(1);
	}
	Response.Write(escape("{'list':[" + result + "]}"));
	//Response.Write(escape(sql));
}

if(op == "setCheckPass"){
	sql = "exec setCheckPass " + nodeID + ",'" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}

if(op == "getEnterCheckinListOnClass"){
	result = "";
	sql = "exec getEnterCheckinListOnClass " + nodeID + "," + refID;
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("theDate").value + "|" + rs("item").value + "|" + rs("teacherName").value + "|" + rs("kindName").value + "|" + rs("classID").value + "|" + rs("file1").value + "|" + rs("file2").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);/**/
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "getEnterCheckinListOutClass"){
	result = "";
	sql = "exec getEnterCheckinListOutClass " + nodeID + "," + refID;
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("theDate").value + "|" + rs("item").value + "|" + rs("teacherName").value + "|" + rs("kindName").value + "|" + rs("classID").value + "|" + rs("file1").value + "|" + rs("file2").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);/**/
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "removeInvoice"){
	result = "";
	sql = "exec removeInvoice '" + nodeID + "'," + refID + ",'" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}

if(op == "saveExamScore"){
	result = "";
	sql = "exec saveExamScore '" + refID + "','" + String(Request.QueryString("score")) + "','" + String(Request.QueryString("score2")) + "','" + String(Request.QueryString("result")) + "','" + String(Request.QueryString("examDate")) + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(0);
}

%>
