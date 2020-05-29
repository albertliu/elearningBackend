<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Session.CodePage=65001%>
<!--#include file="Inc/upload_wj.inc"-->
<%
dim operaType,kindID,filePath,operator
dim sourceHome
  
operaType = ""
kindID = "0"
sourceHome = "upload\"

operaType = Request("type")
operator = Session("user_key")

if Request("kindID")>"" and isNull(Request("kindID"))=false then
	kindID = Request("kindID")
end if

if kindID > 0 then
	sourceHome = "temp\"
end if

function ifDateNull(mDate)
	if isnull(mDate) or mDate="" or mid(mDate,1,4)>"2100" or mid(mDate,1,4)<"1800" then
		ifDateNull = "null"
	else
		ifDateNull = "'" & mDate & "'"
	end if
end function
  
if operaType = "upload" then
	on error resume next
	
	dim upload, file, formName, path, titles, i, title, re, ext
	path = ""
	set upload = new upload_file
	Session("upload") = ""
	
	Set re = New RegExp
	re.Pattern = "[\\/:*?""<>|]"
	re.Global = True
	
	for each formName in upload.file
		set file = upload.file(formName)
		if file.FileSize>0 then
			ext = file.FileExt
			if len(ext)>4 then
				ext = right(ext,3)
			end if
			title = operator & getDateTime & "." & ext
			path = sourceHome & title
			file.SaveToFile Server.mappath(path)
		end if
		set file = nothing
		exit for
	next
	
	set upload = nothing
	
	if Err.Number > 0 then
		response.write("")
	else
		response.write(path)
		Session("upload") = path
	end if
end if

function getDateTime()
	getDateTime = year(now()) & month(now()) & day(now()) & hour(now()) & minute(now()) & second(now())
end function

%>