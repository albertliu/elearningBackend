<!--#include file="js/doc.js" -->

<%

if(op == "getStudentList"){
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = "(name like('%" + where + "%') or username='" + where + "')";
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
		s = "kindID=" + kindID;
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
	if(String(Request.QueryString("old"))==1){
		s = "age>=55";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//缺照片
	if(String(Request.QueryString("photo"))==1){
		s = "photo_filename=''";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}
	//缺身份证
	if(String(Request.QueryString("IDcard"))==1){
		s = "(IDa_filename='' or IDb_filename='')";
		if(where > ""){
			where = where + " and " + s;
		}else{
			where = s;
		}
	}

	if(where>""){
		where = " where " + where;
	}
	sql = " FROM v_studentInfo " + where;
	result = getBasketTip(sql,"");
	ssql = "SELECT username,name,sexName,age,birthday,kindName,statusName,hostName,dept1Name,dept2Name,mobile,phone,email,memo,regDate,(case when photo_filename>'' then '+' else '' end) as photo,(case when IDa_filename>'' then '+' else '' end) as ida,(case when IDb_filename>'' then '+' else '' end) as idb" + sql + " order by username";
	sql = "SELECT top " + basket + " *" + sql + " order by userID desc";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("userID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("user_status").value + "|" + rs("statusName").value + "|" + rs("kindID").value + "|" + rs("kindName").value;
		//7
		result += "|" + rs("mobile").value + "|" + rs("sexName").value + "|" + rs("age").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("hostName").value + "|" + rs("dept1Name").value + "|" + rs("dept2Name").value + "|" + rs("photo").value;
		rs.MoveNext();
	}
	rs.Close();
/*	*/
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}	

if(op == "getNodeInfo"){
	result = "";
	sql = "SELECT * FROM v_studentInfo where userID=" + nodeID;
	rs = conn.Execute(sql);
	if(!rs.EOF){
		result = rs("userID").value + "|" + rs("username").value + "|" + rs("name").value + "|" + rs("user_status").value + "|" + rs("statusName").value + "|" + rs("kindID").value + "|" + rs("kindName").value;
		//7
		result += "|" + rs("mobile").value + "|" + rs("sexName").value + "|" + rs("age").value + "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("hostName").value + "|" + rs("dept1Name").value + "|" + rs("dept2Name").value + "|" + rs("photo").value;
		//16
		result += "|" + rs("email").value + "|" + rs("phone").value + "|" + rs("job").value + "|" + rs("dept3Name").value + "|" + rs("limitDate").value;
		//21
		result += "|" + rs("photo_filename").value + "|" + rs("IDa_filename").value + "|" + rs("IDb_filename").value + "|" + rs("edu_filename").value;
	}
	rs.Close();
	Response.Write(escape(result));
}	

if(op == "setMemo"){
	result = 0;
	if(result == 0){
		sql = "exec setStudentMemo " + nodeID + ",'" + item + "'";
		execSQL(sql);
	}
	Response.Write(escape(result));
}

if(op == "setStatus"){
	result = 0;
	if(result == 0){
		sql = "exec setStudentStatus " + nodeID + "," + status;
		execSQL(sql);
	}
	Response.Write(escape(result));
}

if(op == "delNode"){
	sql = "exec delStudentInfo '" + nodeID + "','" + where + "','" + currUser + "'";
	execSQL(sql);
	Response.Write(nodeID);
}
	


%>
