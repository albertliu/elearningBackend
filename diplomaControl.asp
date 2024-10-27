<!--#include file="js/doc.js" -->

<%

if(op == "getDiplomaList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(name like('%" + where + "%') or username='" + where + "' or diplomaID='" + where + "')";
	}
	//如果有公司
	if(host > ""){ // 
		s = "host='" + host + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有部门
	if(refID > "" && refID != "null" && refID !="undefined"){ // 
		if(refID==99){
			s = "kindID=1";
		}else{
			s = "dept1=" + refID;
		}
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
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
	//如果有分类(证书类型)
	if(kindID > ""){ // 
		s = "certID='" + kindID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有发放标识
	if(keyID > ""){ // 
		s = "issued=" + keyID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fStart > ""){
		s = "startDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > ""){
		s = "startDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(String(Request.QueryString("issuedStartDate")) > "" && String(Request.QueryString("issuedEndDate")) != "undefined"){
		s = "issueDate>='" + String(Request.QueryString("issuedStartDate")) + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(String(Request.QueryString("issuedEndDate")) > "" && String(Request.QueryString("issuedEndDate")) != "undefined"){
		s = "issueDate<='" + String(Request.QueryString("issuedEndDate")) + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	//sql = " FROM v_studentDiplomaList " + where;
	sql = " FROM v_diplomaInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT diplomaID,certName,statusName,term,startDate,endDate,agencyName,username,name,sexName,age,hostName,dept1Name,dept2Name,job,mobile,email,memo,issueDate,issuerName,regDate,registerName" + sql + " order by diplomaID";
	sql = "SELECT top " + basket + " *" + sql + " order by diplomaID";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("certID").value + "|" + rs("certName").value + "|" + rs("diplomaID").value;
		//8
		result += "|" + rs("sexName").value + "|" + rs("age").value + "|" + rs("mobile").value + "|" + rs("email").value + "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("dept1Name").value + "|" + rs("dept2Name").value;
		//16
		result += "|" + rs("startDate").value + "|" + rs("endDate").value + "|" + rs("term").value + "|" + rs("memo").value + "|" + rs("agencyName").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("filename").value;
		//25
		result += "|" + rs("issued").value + "|" + rs("issueDate").value + "|" + rs("issueType").value + "|" + rs("issuedName").value + "|" + rs("issueTypeName").value + "|" + rs("issuer").value + "|" + rs("issuerName").value;
		rs.MoveNext();
	}
	rs.Close();
	
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getDiplomaLastList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(name like('%" + where + "%') or username='" + where + "' or diplomaID='" + where + "' or certName like('%" + where + "%'))";
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
	//如果有部门
	if(refID > ""){ // 
		s = "dept1=" + refID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
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
	//如果有分类(证书类型)
	if(kindID > ""){ // 
		s = "certID='" + kindID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fStart > ""){
		s = "endDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > ""){
		s = "endDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM v_diplomaLastInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT diplomaID,certName,statusName,term,startDate,endDate,agencyName,username,name,sexName,age,hostName,dept1Name,dept2Name,job,mobile,email,memo,regDate,registerName" + sql + " order by diplomaID";
	sql = "SELECT top " + basket + " *" + sql + " order by ID desc";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("certID").value + "|" + rs("certName").value + "|" + rs("diplomaID").value;
		//8
		result += "|" + rs("sexName").value + "|" + rs("age").value + "|" + rs("mobile").value + "|" + rs("email").value + "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("dept1Name").value + "|" + rs("dept2Name").value;
		//16
		result += "|" + rs("startDate").value + "|" + rs("endDate").value + "|" + rs("term").value + "|" + rs("memo").value + "|" + rs("agencyName").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("filename").value;
		rs.MoveNext();
	}
	rs.Close();
	
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getDiplomaListByBatch"){
	sql = "select a.*,c.SNo from v_diplomaInfo a, studentCertList b, v_studentCourseList c where b.ID=c.refID and a.diplomaID=b.diplomaID and a.batchID=" + refID + " order by c.SNo";
	//sql = "SELECT * FROM v_diplomaInfo where batchID=" + refID;
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("dept1Name").value + "|" + rs("stamp").value + "|" + rs("photo_filename").value + "|" + rs("age").value + "|" + rs("SNo").value + "|" + rs("diplomaID").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	result = "";
	sql = "SELECT * FROM v_diplomaInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("certID").value + "|" + rs("certName").value + "|" + rs("diplomaID").value;
		//8
		result += "|" + rs("sexName").value + "|" + rs("age").value + "|" + rs("mobile").value + "|" + rs("email").value + "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("dept1Name").value + "|" + rs("dept2Name").value;
		//16
		result += "|" + rs("startDate").value + "|" + rs("endDate").value + "|" + rs("term").value + "|" + rs("memo").value + "|" + rs("agencyName").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("filename").value;
		//25
		result += "|" + rs("issued").value + "|" + rs("issueDate").value + "|" + rs("issueType").value + "|" + rs("issuedName").value + "|" + rs("issueTypeName").value + "|" + rs("issuer").value + "|" + rs("issuerName").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfoShort"){
	result = "";
	sql = "SELECT * FROM v_diplomaInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("name").value + "|" + rs("certName").value + "|" + rs("diplomaID").value + "|" + rs("dept1Name").value + "|" + rs("job").value;
		//5
		result += "|" + rs("startDate").value + "|" + rs("term").value + "|" + rs("title").value + "|" + rs("photo_filename").value + "|" + rs("logo").value + "|" + rs("certID").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getStudentNeedDiplomaList"){
	result = "";
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(a.name like('%" + where + "%') or a.username='" + where + "' or a.certName like('%" + where + "%') or a.dept1Name like('%" + where + "%'))";
	}
	//如果有公司
	if(host > ""){ // 
		s = "a.host='" + host + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有部门
	var dept = String(Request.QueryString("dept"));
	if(dept > "" && dept != "null" && dept !="undefined"){ // 
		if(dept==99){
			s = "a.student_kindID=1";
		}else{
			s = "a.dept1=" + dept;
		}
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有分类(证书类型)
	if(kindID > ""){ // 
		s = "a.certID='" + kindID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有班级
	if(String(Request.QueryString("classID")) > "" && String(Request.QueryString("classID")) != "null" && String(Request.QueryString("classID")) !="undefined"){ // 
		s = "b.classID='" + String(Request.QueryString("classID")) + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fStart > ""){
		s = "c.startDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > ""){
		s = "c.startDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(String(Request.QueryString("closeStart")) > "" && String(Request.QueryString("closeStart")) != "null" && String(Request.QueryString("closeStart")) !="undefined"){
		s = "a.closeDate>='" + String(Request.QueryString("closeStart")) + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(String(Request.QueryString("closeEnd")) > "" && String(Request.QueryString("closeEnd")) != "null" && String(Request.QueryString("closeEnd")) !="undefined"){
		s = "a.closeDate<='" + String(Request.QueryString("closeEnd")) + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有照片
	if(keyID == 0){ // 
		s = "a.photo_filename>''";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果无照片
	if(keyID == 1){ // 
		s = "a.photo_filename=''";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果显示拒绝申请的人员
	if(refID == 1){ // 
		s = "a.diplomaID='*'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}else{
		s = "a.diplomaID=''";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " and " + where;
	}
	sql = " FROM v_studentCertList a INNER JOIN v_studentCourseList b ON a.ID = b.refID LEFT OUTER JOIN  dbo.classInfo d ON b.classID = d.classID LEFT OUTER JOIN v_generatePasscardInfo c ON b.passcardID = c.ID where a.type=" + String(Request.QueryString("mark")) + " and a.result=1" + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT a.username,b.name,b.sexName,b.age,a.certName,b.dept1Name,b.dept2Name,b.job,b.mobile" + sql + " order by b.dept1Name";
	sql = "SELECT top " + basket + " a.*,b.ID as enterID,b.payNow,b.signature,b.signatureDate,b.status_photo,b.status_signature, isnull(d.className,'') as className,isnull(b.classID,'') as classID, isnull(c.startDate,'') as testDate, b.SNo, b.pay_status,b.pay_statusName" + sql + " order by a.closeDate desc";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("certID").value + "|" + rs("certName").value;
		//5
		result += "|" + rs("sexName").value + "|" + rs("age").value + "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("dept1Name").value;
		//10
		result += "|" + rs("job").value + "|" + rs("closeDate").value + "|" + rs("agencyName").value + "|" + rs("photo_filename").value + "|" + rs("student_kindID").value;
		//15
		result += "|" + rs("className").value + "|" + rs("testDate").value + "|" + rs("classID").value + "|" + rs("educationName").value + "|" + rs("SNo").value;
		//20
		result += "|" + rs("pay_statusName").value + "|" + rs("pay_status").value + "|" + rs("enterID").value + "|" + rs("c555").value;
		//24
		result += "|" + rs("signature").value + "|" + rs("signatureDate").value + "|" + rs("status_photo").value + "|" + rs("status_signature").value + "|" + rs("payNow").value;
		rs.MoveNext();
	}
	rs.Close();
	/**/
	Session(op) = ssql;
	//result = sql;
	Response.Write(escape(result));
}	

if(op == "getNeedDiplomaNodeInfo"){
	result = "";
	sql = "SELECT * FROM v_studentCertList where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("certID").value + "|" + rs("certName").value;
		//5
		result += "|" + rs("sexName").value + "|" + rs("age").value + "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("dept1Name").value;
		//10
		result += "|" + rs("job").value + "|" + rs("closeDate").value + "|" + rs("agencyName").value + "|" + rs("photo_filename").value + "|" + rs("mobile").value + "|" + rs("student_kindName").value + "|" + rs("memo").value + "|" + rs("diplomaID").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getGenerateDiplomaList"){
	result = "";
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "((firstID <= '" + where + "' and lastID >= '" + where + "') or certName like('%" + where + "%'))";
	}

	//如果有公司
	if(host > ""){ // 
		s = "host='" + host + "'";
	}else{
		s = "host=''";
	}
	
	if(where > ""){
		where = where + " and " + s;
	}else{
		where = s;
	}

	//如果是教务
	if(currHost == ""){ // 
		s = "host=''";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	//如果有分类(证书类型)
	if(kindID > ""){ // 
		s = "certID='" + kindID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	//如果证书样式
	if(keyID > ""){ // 
		s = "styleID=" + keyID;
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

	if(where > ""){
		where = " where " + where;
	}

	sql = " FROM v_generateDiplomaInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT certName,qty,firstID,lastID,hostName,memo,regDate,registerName" + sql + " order by ID";
	sql = "SELECT top " + basket + " *" + sql + " order by ID desc";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("certID").value + "|" + rs("certName").value + "|" + rs("qty").value;
		//4
		result += "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("title").value + "|" + rs("filename").value;
		//8
		result += "|" + rs("firstID").value + "|" + rs("lastID").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value;
		//13
		result += "|" + rs("printed").value + "|" + rs("printDate").value + "|" + rs("delivery").value + "|" + rs("deliveryDate").value + "|" + rs("startDate").value + "|" + rs("photo").value + "|" + rs("photoDate").value;
		//20
		result += "|" + rs("styleID").value + "|" + rs("styleName").value;
		rs.MoveNext();
	}
	rs.Close();
	
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getGenerateDiplomaNodeInfo"){
	result = "";
	sql = "SELECT * FROM v_generateDiplomaInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("certID").value + "|" + rs("certName").value + "|" + rs("qty").value;
		//4
		result += "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("title").value + "|" + rs("filename").value;
		//8
		result += "|" + rs("firstID").value + "|" + rs("lastID").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value;
		//13
		result += "|" + rs("printed").value + "|" + rs("printDate").value + "|" + rs("delivery").value + "|" + rs("deliveryDate").value + "|" + rs("startDate").value;
		//18
		result += "|" + rs("class_startDate").value + "|" + rs("class_endDate").value + "|" + rs("photo").value + "|" + rs("photoDate").value + "|" + rs("kindID").value;
		//23
		result += "|" + rs("styleID").value + "|" + rs("styleName").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getGenerateMaterialList"){
	result = "";
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(kindName like('%" + where + "%'))";
	}
	//如果有公司
	if(host > ""){ // 
		s = "host='" + host + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有分类
	if(kindID > ""){ // 
		s = "kindID='" + kindID + "'";
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

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM v_generateMaterialInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT kindName,qty,hostName,memo,regDate,registerName" + sql + " order by ID";
	sql = "SELECT top " + basket + " *" + sql + " order by ID desc";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("kindID").value + "|" + rs("kindName").value + "|" + rs("qty").value;
		//4
		result += "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("title").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value;
		rs.MoveNext();
	}
	rs.Close();
	
	Session(op) = ssql;
	Response.Write(escape(result));
}	

if(op == "getGenerateMaterialNodeInfo"){
	result = "";
	sql = "SELECT * FROM v_generateMaterialInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("kindID").value + "|" + rs("kindName").value + "|" + rs("qty").value;
		//4
		result += "|" + rs("host").value + "|" + rs("hostName").value + "|" + rs("title").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getGeneratePasscardList"){
	result = "";
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(className like('%" + where + "%'))";
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
	//如果有课程
	if(kindID > ""){ // 
		s = "certID='" + kindID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有经办人
	if(refID > ""){ // 
		s = "registerID='" + refID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fStart > ""){
		s = "startDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > ""){
		s = "startDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM v_generatePasscardInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT kindName,qty,hostName,memo,regDate,registerName" + sql + " order by ID";
	sql = "SELECT top " + basket + " *" + sql + " order by startDate desc";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("classID").value + "|" + rs("className").value + "|" + rs("title").value + "|" + rs("qty").value + "|" + rs("startTime").value + "|" + rs("address").value;
		//7
		result += "|" + rs("notes").value + "|" + rs("startDate").value + "|" + rs("filename").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value + "|" + rs("startNo").value;
		//14
		result += "|" + rs("send").value + "|" + rs("sendDate").value + "|" + rs("senderName").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("filescore").value;
		//20
		result += "|" + rs("sendScore").value + "|" + rs("sendScoreDate").value + "|" + rs("senderScoreName").value + "|" + rs("qtyYes").value + "|" + rs("qtyNo").value + "|" + rs("qtyNull").value;
		//26
		result += "|" + rs("kindID").value + "|" + rs("kindName").value + "|" + rs("qtyDiploma").value;
		rs.MoveNext();
	}
	rs.Close();
	
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getPasscardListByExam"){
	result = "";
	var s = "";
	//如果有考试场次
	if(refID > ""){ // 
		s = "refID=" + refID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
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
	//如果有补考
	if(keyID > ""){
		s = "resit>=" + keyID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果需要补考
	if(String(Request.QueryString("needResit"))==1){ // 
		s = "status<>1";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM v_passcardInfo " + where;
	ssql = "SELECT kindName,qty,hostName,memo,regDate,registerName" + sql + " order by ID";
	sql = "SELECT *" + sql + " order by passNo, ID";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("refID").value + "|" + rs("enterID").value + "|" + rs("passNo").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("mobile").value;
		//7
		result += "|" + rs("score").value + "|" + rs("reExamCount").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value;
		//14
		result += "|" + rs("unit").value + "|" + rs("dept1Name").value + "|" + rs("dept2Name").value + "|" + rs("kind").value + "|" + rs("SNo").value + "|" + rs("diplomaID").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);
	Session(op) = ssql;
	Response.Write(escape(result));
}	

if(op == "getPasscardExamList"){
	result = "";
	var s = "";
	//如果有考试场次
	if(refID > ""){ // 
		s = "a.refID=" + refID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	sql = " FROM v_passcardInfo a, v_studentExamList b where a.ID=b.refID and " + where;
	sql = "SELECT a.ID,a.enterID,a.username,a.name,a.SNo,a.unit,a.dept1Name,a.dept2Name,a.mobile, b.score, b.status,b.statusName,b.startDate,b.endDate,b.secondRest/60 as secondRest" + sql + " order by passNo, ID";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("mobile").value;
		//4
		result += "|" + rs("score").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("startDate").value + "|" + rs("endDate").value + "|" + rs("secondRest").value;
		//10
		result += "|" + rs("unit").value + "|" + rs("dept1Name").value + "|" + rs("dept2Name").value + "|" + rs("SNo").value + "|" + rs("enterID").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);
	Response.Write(escape(result));
    //Response.Write(escape(sql));
}	

if(op == "getGeneratePasscardNodeInfo"){
	result = "";
	sql = "SELECT * FROM v_generatePasscardInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("certID").value + "|" + rs("certName").value + "|" + rs("title").value + "|" + rs("qty").value + "|" + rs("startTime").value + "|" + rs("address").value;
		//7
		result += "|" + rs("notes").value + "|" + rs("startDate").value + "|" + rs("filename").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value + "|" + rs("startNo").value;
		//14
		result += "|" + rs("send").value + "|" + rs("sendDate").value + "|" + rs("senderName").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("filescore").value;
		//20
		result += "|" + rs("sendScore").value + "|" + rs("sendScoreDate").value + "|" + rs("senderScoreName").value + "|" + rs("qtyYes").value + "|" + rs("qtyNo").value + "|" + rs("qtyNull").value;
		//26
		result += "|" + rs("kindID").value + "|" + rs("kindName").value + "|" + rs("closeDate").value + "|" + rs("minutes").value + "|" + rs("scorePass").value + "|" + rs("sync").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "updateGeneratePasscardInfo"){
	//@ID int,@certID varchar(50),@title nvarchar(100),@startNo int,@startDate varchar(100),@startTime varchar(100),@address nvarchar(100),@notes nvarchar(500),@memo nvarchar(500),@registerID
	sql = "exec updateGeneratePasscardInfo1 " + nodeID + ",'" + refID + "','" + item + "','" + keyID + "','" + kindID + "','" + String(Request.QueryString("startDate")) + "','" + String(Request.QueryString("startTime")) + "','" + unescape(String(Request.QueryString("address"))) + "','" + unescape(String(Request.QueryString("notes"))) + "'," + String(Request.QueryString("sync")) + ",'" + memo + "','" + currUser + "'";
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("re").value;
	}
	rs.Close();
	Response.Write(result);
	//Response.Write(escape(sql));
}

if(op == "updateGenerateDiplomaInfo"){
	//@ID int,@classID varchar(50),@title nvarchar(100),@qty int,@startTime varchar(100),@address nvarchar(100),@notes nvarchar(500),@memo nvarchar(500),@registerID
	sql = "exec updateGenerateDiplomaInfo " + nodeID + ",'','','','" + String(Request.QueryString("printed")) + "','" + String(Request.QueryString("printDate")) + "','" + String(Request.QueryString("delivery")) + "','" + String(Request.QueryString("deliveryDate")) + "','','" + memo + "','" + currUser + "'";
	rs = conn.Execute(sql);
	Response.Write(escape(0));
	//Response.Write(escape(sql));
}

if(op == "updateGenerateDiplomaMemo"){
	//@ID int,@classID varchar(50),@title nvarchar(100),@qty int,@startTime varchar(100),@address nvarchar(100),@notes nvarchar(500),@memo nvarchar(500),@registerID
	sql = "exec updateGenerateDiplomaMemo " + nodeID + ",'" + String(Request.QueryString("startDate")) + "','" + String(Request.QueryString("class_startDate")) + "','" + String(Request.QueryString("class_endDate")) + "','" + String(Request.QueryString("photo")) + "','" + String(Request.QueryString("photoDate")) + "','" + String(Request.QueryString("printed")) + "','" + String(Request.QueryString("printDate")) + "','" + String(Request.QueryString("delivery")) + "','" + String(Request.QueryString("deliveryDate")) + "'," + kindID + "," + keyID + ",'" + memo + "','" + currUser + "'";
	rs = conn.Execute(sql);
	Response.Write(escape(0));
	//Response.Write(escape(sql));
}

if(op == "issueDiploma"){
	result = 0;
	if(result == 0){
		sql = "exec issueDiploma '" + item + "'," + kindID + ",'" + host + "','" + currUser + "'";
		execSQL(sql);
	}
	Response.Write(escape(result));
}

if(op == "setMemo"){
	result = 0;
	if(result == 0){
		sql = "exec setDiplomaMemo " + nodeID + ",'" + item + "'";
		execSQL(sql);
	}
	Response.Write(escape(result));
}
if(op == "setNeedDiplomaMemo"){
	result = 0;
	if(result == 0){
		sql = "exec setNeedDiplomaMemo " + nodeID + ",'" + item + "'";
		execSQL(sql);
	}
	Response.Write(escape(result));
}
if(op == "setNeedDiplomaCancel"){
	result = 0;
	if(result == 0){
		sql = "exec setNeedDiplomaCancel " + nodeID + ",'" + item + "'," + kindID + ",'" + currUser + "'";
		execSQL(sql);
	}
	Response.Write(escape(result));
}
if(op == "setGenerateDiplomaMemo"){
	result = 0;
	if(result == 0){
		sql = "exec setGenerateDiplomaMemo " + nodeID + ",'" + item + "'";
		execSQL(sql);
	}
	Response.Write(escape(result));
}
if(op == "setGenerateMaterialMemo"){
	result = 0;
	if(result == 0){
		sql = "exec setGenerateMaterialMemo " + nodeID + ",'" + item + "'";
		execSQL(sql);
	}
	Response.Write(escape(result));
}

if(op == "delNode"){
	sql = "exec delDiplomaList '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "delGeneratePasscard"){
	sql = "exec delGeneratePasscard '" + nodeID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "closeGeneratePasscard"){
	sql = "exec closeGeneratePasscard " + nodeID + "," + refID + ",'" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "remove4GeneratePasscard"){
	sql = "exec changeExamer " + nodeID + ",'" + String(Request.Form("selList")) + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
	//Response.Write(sql);
}

if(op == "remove4GenerateApply"){
	sql = "exec changeApplier " + nodeID + ",'" + String(Request.Form("selList")) + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
	//Response.Write(sql);
}

if(op == "getGenerateApplyList"){
	result = "";
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(title like('%" + where + "%') or courseName like('%" + where + "%') or applyID like('%" + where + "%') or [dbo].[getApplyCount](ID,'" + where + "')>0)";
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
	//如果有课程
	if(kindID > ""){ // 
		s = "certID='" + kindID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有经办人
	if(refID > ""){ // 
		s = "registerID='" + refID + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//host
	if(host > ""){ // 
		s = "host='" + host + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fStart > ""){
		s = "startDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > ""){
		s = "startDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM v_generateApplyInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT kindName,qty,hostName,memo,regDate,registerName" + sql + " order by ID desc";
	sql = "SELECT top " + basket + " *" + sql + " order by ID desc";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("courseID").value + "|" + rs("courseName").value + "|" + rs("title").value + "|" + rs("qty").value + "|" + rs("applyID").value;
		//6
		result += "|" + rs("startDate").value + "|" + rs("filename").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value + "|" + rs("address").value;
		//12
		result += "|" + rs("send").value + "|" + rs("sendDate").value + "|" + rs("senderName").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("filescore").value;
		//18
		result += "|" + rs("sendScore").value + "|" + rs("sendScoreDate").value + "|" + rs("senderScoreName").value + "|" + rs("qtyYes").value + "|" + rs("qtyNo").value + "|" + rs("qtyNull").value;
		//24
		result += "|" + rs("reexamineName").value + "|" + rs("importApplyDate").value + "|" + rs("importScoreDate").value + "|" + rs("diplomaStartDate").value + "|" + rs("diplomaEndDate").value;
		//29
		result += "|" + rs("diplomaTerm").value + "|" + rs("qtyCheck").value + "|" + rs("diplomaReady").value;
		rs.MoveNext();
	}
	rs.Close();
	
	Session(op) = ssql;
	Response.Write(escape(result));
}	

if(op == "getApplyListByBatch"){
	result = "";
	var s = "";
	//如果有批次
	if(refID > ""){ // 
		s = "refID=" + refID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有状态
	if(status > ""){ // 
		s = "statusApply=" + status;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有退课状态
	if(String(Request.QueryString("drop"))==1){ // 
		s = "enterStatus=3";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}else{
		s = "enterStatus<3";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果有补申
	if(keyID > ""){
		s = "resit>=" + keyID;
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果需要补申
	if(String(Request.QueryString("needResit"))==1){ // 
		s = "status=2";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果未报名
	if(String(Request.QueryString("wait"))==1){ // 
		s = "step <> '已报名'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果未上传材料
	if(String(Request.QueryString("upload"))==1){ // 
		s = "upload=0";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//如果未上传照片
	if(String(Request.QueryString("uploadPhoto"))==1){ // 
		s = "uploadPhoto=0";
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
	//如果有公司
	if(host > ""){ // 
		s = "host='" + host + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM v_applyInfo " + where;
	ssql = "SELECT kindName,qty,hostName,memo,regDate,registerName" + sql + " order by ID";
	sql = "SELECT *" + sql + " order by passNo, ID";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("refID").value + "|" + rs("enterID").value + "|" + rs("passNo").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("mobile").value;
		//7
		result += "|" + rs("resit").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value;
		//13
		result += "|" + rs("unit").value + "|" + rs("dept1Name").value + "|" + rs("dept2Name").value + "|" + rs("statusApply").value + "|" + rs("statusApplyName").value + "|" + rs("examDate").value;
		//19
		result += "|" + rs("score").value + "|" + rs("score1").value + "|" + rs("score2").value + "|" + rs("SNo").value;
		//23
		result += "|" + rs("certID").value + "|" + rs("file1").value + "|" + rs("file2").value + "|" + rs("file3").value + "|" + rs("currDiplomaDate").value + "|" + rs("reexamine").value + "|" + rs("enterStatus").value;
		//30
		result += "|" + rs("upload").value + "|" + rs("uploadPhoto").value + "|" + rs("step").value + "|" + rs("memo1").value + "|" + rs("photo_filename").value;
		//35
		result += "|" + rs("signature").value + "|" + rs("photo_size").value + "|" + rs("signatureDate").value + "|" + rs("entryform").value + "|" + rs("memo_enter").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);
	Session(op) = ssql;
	Response.Write(escape(result));
}	

if(op == "getGenerateApplyNodeInfo"){
	result = "";
	sql = "SELECT * FROM v_generateApplyInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("courseID").value + "|" + rs("courseName").value + "|" + rs("title").value + "|" + rs("qty").value + "|" + rs("applyID").value;
		//6
		result += "|" + rs("startDate").value + "|" + rs("filename").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerName").value + "|" + rs("address").value;
		//12
		result += "|" + rs("send").value + "|" + rs("sendDate").value + "|" + rs("senderName").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("filescore").value;
		//18
		result += "|" + rs("sendScore").value + "|" + rs("sendScoreDate").value + "|" + rs("senderScoreName").value + "|" + rs("qtyYes").value + "|" + rs("qtyNo").value + "|" + rs("qtyNull").value;
		//24
		result += "|" + rs("reexamineName").value + "|" + rs("importApplyDate").value + "|" + rs("importScoreDate").value + "|" + rs("diplomaStartDate").value + "|" + rs("diplomaEndDate").value;
        //29
		result += "|" + rs("diplomaTerm").value + "|" + rs("qtyCheck").value + "|" + rs("certID").value + "|" + rs("host").value + "|" + rs("zip").value + "|" + rs("pzip").value + "|" + rs("ezip").value;
        //36
		result += "|" + rs("reexamine").value + "|" + rs("agencyID").value + "|" + rs("diplomaReady").value + "|" + rs("teacher").value + "|" + rs("classroom").value;
		//41
		result += "|" + rs("scheduleDate").value + "|" + rs("adviserID").value + "|" + rs("mark").value + "|" + rs("uploadScheduleDate").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "updateGenerateApplyInfo"){
	//@ID int,@courseID varchar(50),@applyID varchar(50),@title nvarchar(100),@startDate varchar(100),@memo nvarchar(500),@registerID
	sql = "exec updateGenerateApplyInfo " + nodeID + ",'" + refID + "','" + keyID + "','" + item + "','" + String(Request.QueryString("startDate")) + "','" + unescape(String(Request.QueryString("address"))) + "','" + String(Request.QueryString("teacher")) + "','" + unescape(String(Request.QueryString("classroom"))) + "','" + String(Request.QueryString("adviserID")) + "','" + String(Request.QueryString("diplomaReady")) + "','" + host + "','" + memo + "','" + currUser + "'";
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("re").value;
	}
	rs.Close();
	Response.Write(result);
	//Response.Write(escape(sql));
}

if(op == "getRptDailyInvoiceList"){
	result = "";
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(taxUnit like('%" + where + "%') or memo like('%" + where + "%') or invID='" + where + "')";
	}
	//如果有应收
	if(kindID == 1){ // 
		s = "payStatus=1";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fStart > "" && kindID != 1){
		s = "invDate>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > "" && kindID != 1){
		s = "invDate<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM v_invoiceInfo " + where;
	sql = "SELECT *" + sql + " order by ID desc";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		// @kind,@invCode,@invID,@taxNo,@taxUnit,@invDate,@item,@amount,@cancel,@cancelDate,@operator,@memo,@registerID
		result += "%%" + rs("ID").value + "|" + rs("kind").value + "|" + rs("invCode").value + "|" + rs("invID").value + "|" + rs("taxNo").value + "|" + rs("taxUnit").value + "|" + rs("invDate").value + "|" + rs("item").value;
		//8
		result += "|" + rs("amount").value + "|" + rs("cancel").value + "|" + rs("cancelDate").value + "|" + rs("payType").value + "|" + rs("payStatus").value + "|" + rs("operator").value;
		//14
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("checkDate").value + "|" + rs("checker").value + "|" + rs("checkerName").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);
	Response.Write(escape(result));
}	

if(op == "getRptDailyReceiptList"){
	result = "";
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(title like('%" + where + "%') or memo like('%" + where + "%') or invoice='" + where + "')";
	}
	if(fStart > ""){
		s = "datePay>='" + fStart + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	if(fEnd > ""){
		s = "datePay<='" + fEnd + "'";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where > ""){
		where = " where " + where;
	}
	sql = " FROM v_payReceiptInfo " + where;
	sql = "SELECT *" + sql + " order by ID desc";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		// @kind,@invCode,@invID,@taxNo,@taxUnit,@invDate,@item,@amount,@cancel,@cancelDate,@operator,@memo,@registerID
		result += "%%" + rs("ID").value + "|" + rs("invoice").value + "|" + rs("datePay").value + "|" + rs("typeName").value + "|" + rs("title").value;
		//5
		result += "|" + rs("amount").value + "|" + rs("memo").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("courseName").value;
		rs.MoveNext();
	}
	rs.Close();
	result = result.substr(2);
	Response.Write(escape(result));
}	

if(op == "getInvoiceNodeInfo"){
	result = "";
	sql = "SELECT * FROM v_invoiceInfo where ID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("ID").value + "|" + rs("kind").value + "|" + rs("invCode").value + "|" + rs("invID").value + "|" + rs("taxNo").value + "|" + rs("taxUnit").value + "|" + rs("invDate").value + "|" + rs("item").value;
		//8
		result += "|" + rs("amount").value + "|" + rs("cancel").value + "|" + rs("cancelDate").value + "|" + rs("payType").value + "|" + rs("payStatus").value + "|" + rs("operator").value;
		//14
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("registerID").value + "|" + rs("registerName").value + "|" + rs("checkDate").value + "|" + rs("checker").value + "|" + rs("checkerName").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "delGenerateApply"){
	sql = "exec delGenerateApplyInfo '" + nodeID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "closeGenerateApply"){
	sql = "exec closeGenerateApplyInfo " + nodeID + "," + refID + ",'" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "getLastExamAddress"){
	sql = "select top 1 address, notes from v_generatePasscardInfo where certID='" + refID + "' and kindID=" + kindID + " order by ID desc";
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("address").value + "|" + rs("notes").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "getLastApplyAddress"){
	sql = "select top 1 address from v_generateApplyInfo where courseID='" + refID + "' order by ID desc";
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("address").value;
	}
	rs.Close();
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

if(op == "closeExam"){
	sql = "exec closeExam " + nodeID + ",'" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "confirmExam"){
	sql = "exec confirmExam " + nodeID + ",'" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
	//Response.Write((sql));
}

if(op == "cancelDiploma"){
	sql = "exec cancelDiploma '" + nodeID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

if(op == "restartDiploma"){
	sql = "exec restartDiploma '" + nodeID + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}

%>
