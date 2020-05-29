<!--#include file="js/doc.js" -->

<%
var type = 0;
var mark = 0;
var user = "";
var unit = "";
var group = "";

if (String(Request.QueryString("type")) != "undefined" && 
    String(Request.QueryString("type")) != "" && String(Request.QueryString("type")) != "null") { 
  type = String(Request.QueryString("type"));
}
if (String(Request.QueryString("mark")) != "undefined" && 
    String(Request.QueryString("mark")) != "" && String(Request.QueryString("mark")) != "null") { 
  mark = String(Request.QueryString("mark"));
}
if (String(Request.QueryString("user")) != "undefined" && 
    String(Request.QueryString("user")) != "" && String(Request.QueryString("user")) != "null") { 
  user = String(Request.QueryString("user"));
}
if (String(Request.QueryString("group")) != "undefined" && 
    String(Request.QueryString("group")) != "" && String(Request.QueryString("group")) != "null") { 
  group = String(Request.QueryString("group"));
}

if(op == "getDailyStatStore"){
	sql = "SELECT * from dbo.getDailyStatStore('" + fStart + "','" + fEnd + "','" + user + "')";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs.Fields("item").value + "|" + rs("cAgent").value + "|" + rs("cSelf").value + "|" + rs("cMail").value + "|" + rs("cSum").value + "|" + rs("kind").value;
		rs.MoveNext();
	}
	if(result > ""){
		result = result.substr(2);
	}
	rs.Close();
	Response.Write(escape(result));
}

if(op == "getTodayCount"){
	sql = "SELECT * from dbo.getDailyStatStore('" + currDate + "','" + currDate + "','" + user + "')";
	
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("kind").value + "|" + rs("cSum").value;
		rs.MoveNext();
	}

	sql = "SELECT * from dbo.getBackOpCountDaily('" + currDate + "','" + currDate + "','" + user + "')";
	
	rs = conn.Execute(sql);
	if (!rs.EOF){
		result += "%%" + "Dismiss" + "|" + rs("rcDismiss").value + "%%" + "Payment" + "|" + rs("rcPayment").value + "%%" + "RegUnit" + "|" + rs("rcRegUnit").value + "%%" + "NewAccount" + "|" + rs("rcNewAccount").value;
	}
	rs.Close();
	if(result > ""){
		result = result.substr(2);
	}
	Response.Write(escape(result));
}

if(op == "getUserNewsStat"){
	sql = "SELECT * from dbo.getUserNewsStat('" + currUser + "')";
	rs = conn.Execute(sql);
	//item varchar(50),title varchar(50),pNew int,pEffect int,pAlert int
	while (!rs.EOF){
		result += "%%" + rs("item").value + "|" + rs("title").value + "|" + rs("pNew").value + "|" + rs("pEffect").value + "|" + rs("pAlert").value;
		rs.MoveNext();
	}
	rs.Close();
	if(result > ""){
		result = result.substr(2);
	}
	Response.Write(escape(result));
}	

if(op == "getArchiveStat"){
	result = "";
	sql = "select * from dbo.getArchiveStat()";
	rs = conn.Execute(sql);
	while (!rs.EOF){
		result += "%%" + rs("item").value + "|" + rs("title").value + "|" + rs("icount").value;
		rs.MoveNext();
	}
	rs.Close();
	if(result > ""){
		result = result.substr(2);
	}
	Response.Write(escape(result));
}

//超期保存档案
if(op == "getReportListExp"){
	result = "";
	sql = " FROM v_archiveInfo where expDate>'" + currDate.substring(0,7) + "'";
	var s = "";
	//如果有条件，按照条件查询
	if(where > ""){ // 有条件
		where = " and (item like('%" + where + "%') or archiveNo='" + where + "')";
	}
	//如果有分类
	if(kindID > ""){ // 
		s = "kindID='" + kindID + "'";
		where = where + " and " + s;
	}
	//如果有科目
	if(kindID > "" && String(Request.QueryString("type"))>""){ // 
		s = "type='" + String(Request.QueryString("type")) + "'";
		where = where + " and " + s;
	}
	//如果有状态，按照状态查询
	if(status < 99 && status > ""){ // 
		s = "status=" + status;
		where = where + " and " + s;
	}
	if(fStart > ""){
		s = " archiveDate>='" + fStart + "'";
		where = where + " and " + s;
	}
	if(fEnd > ""){
		s = " archiveDate<='" + fEnd + "'";
		where = where + " and " + s;
	}
	sql += where;
	result = getBasketTip(sql,"");
	ssql = "SELECT archiveNo,item,kindName,typeName,year,month,location,page,archiveDate,statusName,expDate,memo,registorName" + sql + " order by ID";
	sql = "SELECT top " + basket + " *" + sql + " order by ID";
	rs = conn.Execute(sql);
	
	while (!rs.EOF){
		result += "%%" + rs("ID").value + "|" + rs("archiveNo").value + "|" + rs("item").value + "|" + rs("status").value + "|" + rs("statusName").value + "|" + rs("kindID").value + "|" + rs("kindName").value + "|" + rs("type").value + "|" + rs("archiveDate").value + "|" + rs("page").value + "|" + rs("location").value;
		result += "|" + rs("memo").value + "|" + rs("regDate").value + "|" + rs("regOperator").value + "|" + rs("registorName").value + "|" + rs("year").value + "|" + rs("month").value + "|" + rs("typeName").value + "|" + rs("expDate").value;
		rs.MoveNext();
	}
	rs.Close();/**/
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

//分类汇总统计
if(op == "getReportListGroup"){
	result = "";
	var s = "";
	where = "";
	//如果有分类
	if(kindID > ""){ // 
		s = "kindID='" + kindID + "'";
		where = where + " and " + s;
	}
	//如果有科目
	if(kindID > "" && String(Request.QueryString("type"))>""){ // 
		s = "type='" + String(Request.QueryString("type")) + "'";
		where = where + " and " + s;
	}
	//如果有状态，按照状态查询
	if(status < 99 && status > ""){ // 
		s = "status=" + status;
		where = where + " and " + s;
	}
	if(fStart > ""){
		s = " archiveDate>='" + fStart + "'";
		where = where + " and " + s;
	}
	if(fEnd > ""){
		s = " archiveDate<='" + fEnd + "'";
		where = where + " and " + s;
	}
	if(where>""){
		where = " where " + where.substr(4);
	}
	sql = "SELECT a.item as kindName,b.item as typeName,c.year,c.count from archiveKind a,archiveSubKind b,(select kindID,type,year,count(*) as count from archiveInfo " + where + " group by kindID,type,year) c where a.kindID=b.kindID and b.kindID=c.kindID and b.subKindID=c.type";
	ssql = sql;
	rs = conn.Execute(sql);
	
	while (!rs.EOF){
		result += "%%" + rs("kindName").value + "|" + rs("typeName").value + "|" + rs("year").value + "|" + rs("count").value;
		rs.MoveNext();
	}
	rs.Close();/**/
	if(result > ""){
		result = result.substr(2);
	}
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

//分类汇总统计
if(op == "getReportListDaily"){
	result = "";
	var s = "";
	where = "";
	//如果有分类
	if(kindID > ""){ // 
		s = "b.kindID='" + kindID + "'";
		where = where + " and " + s;
	}
	//如果有科目
	if(kindID > "" && String(Request.QueryString("type"))>""){ // 
		s = "b.type='" + String(Request.QueryString("type")) + "'";
		where = where + " and " + s;
	}
	if(fStart > ""){
		s = " a.opDate>='" + fStart + "'";
		where = where + " and " + s;
	}
	if(fEnd > ""){
		s = " a.opDate<='" + fEnd + "'";
		where = where + " and " + s;
	}
	sql = "SELECT k.item as kindName,s.item as typeName,c.event,c.count from archiveKind k,archiveSubKind s,(SELECT event,b.kindID,b.type,count(*) as count from archivesOpLog a,archiveInfo b where a.archiveID=b.ID" + where + " group by a.event,b.kindID,b.type) c where k.kindID=s.kindID and s.kindID=c.kindID and s.subKindID=c.type";
	ssql = sql;
	rs = conn.Execute(sql);
	
	while (!rs.EOF){
		result += "%%" + rs("kindName").value + "|" + rs("typeName").value + "|" + rs("event").value + "|" + rs("count").value;
		rs.MoveNext();
	}
	rs.Close();/**/
	if(result > ""){
		result = result.substr(2);
	}
	Session(op) = ssql;
	Response.Write(escape(result));
	//Response.Write(escape(sql));
}

%>
