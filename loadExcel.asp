<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Session.CodePage=65001%>
<!--#include file="Inc/upload_wj.inc"-->
<!--#include file="Connections/labour.asp" -->
<%
dim groupID,operaType,kindID,filePath,docItem
Dim rsRpt,rsRpt1,rsRpt001,rptItem,rsRptSum001
Dim rsRpt_numRows
dim rsTemp,Sql,whereMark,tblMark,force
dim sourceHome
  
groupID = 1
operaType = ""
kindID = "1"
force = 0
sourceHome = "reports\loadData\"

operaType = Request("type")

if Request("groupID")>"" and isNull(Request("groupID"))=false then
	groupID = Request("groupID")
end if

force = Request("force")
filePath = Request("filePath")
whereMark = replace(Request("whereMark"),"!~","%")
docItem = Request("docItem")
tblMark = replace(Request("tblMark"),"!~","%")

Set rsTemp = Server.CreateObject("ADODB.Recordset")
rsTemp.ActiveConnection = MM_labour_STRING
rsTemp.CursorType = 0
rsTemp.CursorLocation = 2
rsTemp.LockType = 1

Set rsRpt = Server.CreateObject("ADODB.Recordset")
rsRpt.ActiveConnection = MM_labour_STRING
'rsRpt.Source = "SELECT * FROM dbo.inputDataRpt_001"
'rsRpt.Open()
rsRpt.CursorType = 0
rsRpt.CursorLocation = 2
rsRpt.LockType = 1

Set rptItem = Server.CreateObject("ADODB.Recordset")
rptItem.ActiveConnection = MM_labour_STRING
rptItem.Source = "SELECT * FROM dbo.v_rptItemList WHERE ID = " & groupID
rptItem.CursorType = 0
rptItem.CursorLocation = 2
rptItem.LockType = 1
rptItem.Open()
kindID = rptItem("kindID")

function ifDateNull(mDate)
	if isnull(mDate) or mDate="" or mid(mDate,1,4)>"2100" or mid(mDate,1,4)<"1800" then
		ifDateNull = "null"
	else
		ifDateNull = "'" & mDate & "'"
	end if
end function

Dim   Conn,Driver,DBPath,Rs
  '   ����Connection����   
  Set   Conn   =   Server.CreateObject("ADODB.Connection")   
  Driver   =   "Driver={Microsoft Excel Driver (*.xls)};"  
  
if operaType = "upload" then
	dim upload, file, formName, path, titles, i, title, re
	
	set upload = new upload_file
	
	Set re = New RegExp
	re.Pattern = "[\\/:*?""<>|]"
	re.Global = True
	
	i = 0
	
	for each formName in upload.file
		set file = upload.file(formName)
		if file.FileSize>0 then
	
			'title = file.FileName
			title = "sourceRpt" & groupID & ".xls"
			path = sourceHome & title
			file.SaveToFile Server.mappath(path)
			
			i = i + 1
		end if
		set file = nothing
	next
	
	set upload = nothing
	response.write(path)
end if
  
if operaType = "emptyData" then
	delRptData()  '��ձ�������
	setSubStatus(0)
end if
if operaType = "loadData" then
	dim result
	result = inputRptData()  '�����µı�������
	setSubStatus(1)
	response.write(filePath)
	'Response.Write(result)
end if
if operaType = "delData" then
	delRptData()  'ɾ����������
end if
if operaType = "disData" then
	Sql = "update inputDataRpt_001 set dealStatus = 0,dealDate=null,changeMark=dbo.getRpt1ChangeItem(techID,jobID,salaryID,education) where groupID=" & groupID   
	rsTemp.Source = Sql
	rsTemp.Open()    '������״̬����Ϊ�ɱ༭״̬
	setSubStatus(2)  '�ַ���������
end if
if operaType = "calData" then
	if(force=0) then
		Sql = "select count(*) as count from inputDataRpt_001 where dealStatus<1 and groupID=" & groupID   
		rsTemp.Source = Sql
		rsTemp.Open()    '����Ƿ���δ��ɵ�����
		if(rsTemp("count")>0) then
			'��������ֹͳ��
			Response.Write(rsTemp("count"))
		else
			force = 1
		end if
	end if
	if(force=1) then
		'����ͳ��
		Sql = "delete from proDataRpt_001 where groupID=" & groupID   
		rsTemp.Source = Sql
		rsTemp.Open()    'ɾ���ɵ�ͳ������
		Sql = "delete from tempDataRpt_001 where groupID=" & groupID   
		rsTemp.Source = Sql
		rsTemp.Open()    'ɾ���ɵ�ͳ������
		Sql = "insert into proDataRpt_001(ID,groupID,cardID,jobRegDate) select ID," & groupID & ",cardID,jobRegDate from inputDataRpt_001 where (effectCount = 1) AND jobRegDate between '" & rptItem("Date0") & "' AND '" & rptItem("Date1") & "'"
		rsTemp.Source = Sql
		rsTemp.Open()    '����ҵ���ݵ���
		Sql = "insert into tempDataRpt_001(ID,groupID,cardID,jobQuitDate) select ID," & groupID & ",cardID,jobQuitDate from inputDataRpt_001 where (effectCount = -1) AND jobQuitDate between '" & rptItem("Date0") & "' AND '" & rptItem("Date1") & "' and cardID in(select cardID from proDataRpt_001 where groupID=" & groupID & ")"
		rsTemp.Source = Sql
		rsTemp.Open()    '���˹����ݵ���
		Sql = "update proDataRpt_001 set mark=1 from proDataRpt_001 a, tempDataRpt_001 b where a.cardID=b.cardID and a.groupID=b.groupID and a.jobRegDate<b.jobQuitDate and a.groupID=" & groupID
		rsTemp.Source = Sql
		rsTemp.Open()    '������˹���¼�ľ�ҵ����
		Sql = "delete from proDataRpt_001 where mark=1 and groupID=" & groupID   
		rsTemp.Source = Sql
		rsTemp.Open()    'ɾ����Ч�ľ�ҵ���ݣ��ڱ�ͳ���ڼ��Ⱦ�ҵ���˹���
		Sql = "delete from tempDataRpt_001 where groupID=" & groupID   
		rsTemp.Source = Sql
		rsTemp.Open()    'ɾ���ɵ�ͳ������
		
		Sql = "delete from rptLastData_001 where groupID=" & groupID   
		rsTemp.Source = Sql
		rsTemp.Open()    'ɾ���ɵ�ͳ������
		Sql = "insert into rptLastData_001(groupID,f0,f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,f13,f14,f15,f16,f17,f18,f19,f20,f21,f22,f23,f24,f25,f26,f27,f28,f29,f30,f31,f32,f33,f34,f35) select groupID,f0,f1,f2,f3,f4,f5,f6,f7,f8,f9,f10,f11,f12,f13,f14,f15,f16,f17,f18,f19,f20,f21,f22,f23,f24,f25,f26,f27,f28,f29,f30,f31,f32,f33,f34,f35 from v_rptGen_001 where groupID=" & groupID
		rsTemp.Source = Sql
		rsTemp.Open()    '����ͳ������
		Sql = "insert into rptLastData_001(groupID,f0) select " & groupID & ",jd from rpt001_jdList where jd not in (select f0 from rptLastData_001 where groupID=" & groupID & ")"   
		rsTemp.Source = Sql
		rsTemp.Open()    '�����ֵ������
		Sql = "update rptLastData_001 set indexID=b.ID from rptLastData_001 a,rpt001_jdList b where a.f0=b.jd and a.groupID=" & groupID
		rsTemp.Source = Sql
		rsTemp.Open()    'Ϊ����ȷ��˳��
		Sql = "update rptItemList set status=0,editorID=null,editDate=null,checkerID=null,checkDate=null,deployerID=null,deployDate=null where ID=" & groupID
		rsTemp.Source = Sql
		rsTemp.Open()    '������״̬��Ϊ��ʼֵ
		Sql = "delete from docAppendixList where docID=" & groupID
		rsTemp.Source = Sql
		rsTemp.Open()    '������ĸ���ɾ��
		setSubStatus(3)  'ͳ�Ʊ�������
		'Response.Write("OK")
	end if
end if
if operaType = "closeData" then
	setSubStatus(4)  '�رձ�������
end if
if operaType = "addRpt" then
	addRptItem()  '����µı�����Ŀ
end if
if operaType = "delRpt" then
	delRptItem()  'ɾ��������Ŀ
end if

   if operaType = "analyseQx" then
	  Sql = "update inputDataRpt_001 set jw=left(jw,len(jw)-1) where jw like '%��ί��' and groupID=" & groupID 
	  rsTemp.Source = Sql
	  rsTemp.Open()   '����ί�����ƹ淶����
	  Sql = "update inputDataRpt_001 set jw=b.itemSys from inputDataRpt_001 a,rptDataItemCompare b where a.jw=b.itemOut and b.kind='jw' and a.groupID=" & groupID
	  rsTemp.Source = Sql
	  rsTemp.Open()   '����ί�����ƹ淶����
	  Sql = "update inputDataRpt_001 set jd=b.itemSys from inputDataRpt_001 a,rptDataItemCompare b where a.jd=b.itemOut and b.kind='jd' and a.groupID=" & groupID
	  rsTemp.Source = Sql
	  rsTemp.Open()   '���ֵ����ƹ淶����
	  Sql = "update inputDataRpt_001 set education=dbo.transEducation2Rpt1(b.�Ļ��̶�),qx=b.����Ȩ��,jd=b.���ڽֵ�,jw=b.���ھ�ί��,noJobFamily=(case ���ҵ when '��' then 1 else 0 end),jobHard=(case b.˫�� when '��' then 1 else 0 end),newGrade=(case when convert(integer,getdate(),23)-convert(integer,b.gradeDate,23)<180 then 1 else 0 end),flag=b.flag from inputDataRpt_001 a,dbf_main b where a.cardID=b.���֤���� and a.groupID=" & groupID   
	  rsTemp.Source = Sql
	  rsTemp.Open()   '����ϵͳ��������Ϣ���һЩ��Ŀ�������֤Ϊ����ƥ��
	  Sql = "update inputDataRpt_001 set newOne=1 where qx is null and groupID=" & groupID
	  rsTemp.Source = Sql
	  rsTemp.Open()   '��ǳ�ϵͳ��δע�����Ա
	  Sql = "update inputDataRpt_001 set qx=b.qx from inputDataRpt_001 a,qx b where a.jw=b.jw and a.qx is null and a.groupID=" & groupID
	  rsTemp.Source = Sql
	  rsTemp.Open()   '��ϵͳ��û��ע�����Ա�����վ�ί���������
	  Sql = "update inputDataRpt_001 set qx=b.qx from inputDataRpt_001 a,qx b where a.jd=b.jd and a.qx is null and b.jw is null and a.groupID=" & groupID
	  rsTemp.Source = Sql
	  rsTemp.Open()   '�����޷���Ӧ��ί��ģ����սֵ���������
	  Sql = "update inputDataRpt_001 set effectCount=-1 where jobQuitDate is not null and groupID=" & groupID
	  rsTemp.Source = Sql
	  rsTemp.Open()   '�˹�����Ч����Ϊ-1����ҵ����Ч����Ϊ1.
	  Sql = "delete from inputDataRpt_001 where groupID=" & groupID & " and flag<>'N'"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '������Ч����Ա�ų���Ǩ�������������ݣ�.
	Response.Write("analyseQx Over")
   end if
   if operaType = "analyseIsLand" then
	  Sql = "update inputDataRpt_001 set isLand=1 where groupID=" & groupID & " and charindex('�ζ�',jobRegLocation)+charindex('¬��',jobRegLocation)+charindex('���',jobRegLocation)+charindex('����',jobRegLocation)+charindex('����',jobRegLocation)+charindex('����',jobRegLocation)+charindex('�ɽ�',jobRegLocation)+charindex('��ɽ',jobRegLocation)+charindex('����',jobRegLocation)+charindex('�ֶ�',jobRegLocation)+charindex('����',jobRegLocation)+charindex('����',jobRegLocation)+charindex('���',jobRegLocation)+charindex('��ɽ',jobRegLocation)+charindex('բ��',jobRegLocation)+charindex('����',jobRegLocation)+charindex('����',jobRegLocation)+charindex('��',jobRegLocation)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '���ݾ�ҵ�Ǽǵ����Ʒ������ڵ���.���а��������������ƺ͡��С����ƵĵǼǣ�����Ϊ���⡣
	  Sql = "update inputDataRpt_001 set isLand=1 where groupID=" & groupID & " and isLand=0 and charindex('�ζ�',unitName)+charindex('¬��',unitName)+charindex('���',unitName)+charindex('����',unitName)+charindex('����',unitName)+charindex('����',unitName)+charindex('�ɽ�',unitName)+charindex('��ɽ',unitName)+charindex('����',unitName)+charindex('�ֶ�',unitName)+charindex('����',unitName)+charindex('����',unitName)+charindex('���',unitName)+charindex('��ɽ',unitName)+charindex('բ��',unitName)+charindex('����',unitName)+charindex('����',unitName)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '���ݾ�ҵ��λ���Ʒ������ڵ���..���а��������������Ƶĵ�λ������Ϊ���⡣
   end if
   if operaType = "analyseJob" then
	  Sql = "update inputDataRpt_001 set jobID=2 where groupID=" & groupID & " and isLand=0 and jobID=0 and charindex('����',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('ӪҵԱ',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('���',jobKind)+charindex('����',jobKind)+charindex('��Ա',jobKind)+charindex('����',jobKind)+charindex('��',jobKind)+charindex('����Ա',jobKind)+charindex('��ʿ',jobKind)+charindex('ó',jobKind)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '���ݾ�ҵ��λ�������ڶ�Ӧ��ͳ����ҵ. 2 ��ҵ����
	  Sql = "update inputDataRpt_001 set jobID=1 where groupID=" & groupID & " and isLand=0 and jobID=0 and (charindex('����',jobKind)+charindex('ҵ��',jobKind)+charindex('Ӫ��',jobKind)+charindex('�ɹ�',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('���',jobKind)+charindex('����',jobKind)+charindex('ͳ��',jobKind)+charindex('����',jobKind)>0 or jobKind like '%��')"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '���ݾ�ҵ��λ�������ڶ�Ӧ��ͳ����ҵ. 1 ��ҵ��ҵ
	  Sql = "update inputDataRpt_001 set jobID=3 where groupID=" & groupID & " and isLand=0 and jobID=0 and charindex('����',jobKind)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '���ݾ�ҵ��λ�������ڶ�Ӧ��ͳ����ҵ. 3 ���η���
	  Sql = "update inputDataRpt_001 set jobID=4 where groupID=" & groupID & " and isLand=0 and jobID=0 and charindex('��ֲ',jobKind)+charindex('��ֳ',jobKind)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '���ݾ�ҵ��λ�������ڶ�Ӧ��ͳ����ҵ. 4 ũҵ��ҵ
	  Sql = "update inputDataRpt_001 set jobID=5 where groupID=" & groupID & " and isLand=0 and jobID=0 and charindex('����',jobKind)+charindex('��ʻԱ',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('�г�',jobKind)+charindex('����',jobKind)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '���ݾ�ҵ��λ�������ڶ�Ӧ��ͳ����ҵ. 5 ��ͨ����
	  Sql = "update inputDataRpt_001 set jobID=6 where groupID=" & groupID & " and isLand=0 and jobID=0 and charindex('����',jobKind)+charindex('����',jobKind)+charindex('ʩ��',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('װ��',jobKind)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '���ݾ�ҵ��λ�������ڶ�Ӧ��ͳ����ҵ. 6 ����ҵ
	  Sql = "update inputDataRpt_001 set jobID=9 where groupID=" & groupID & " and isLand=0 and jobID=0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '���ݾ�ҵ��λ�������ڶ�Ӧ��ͳ����ҵ. 9 ����
	  Sql = "update inputDataRpt_001 set jobID=11 where groupID=" & groupID & " and isLand=1 and jobID=0 and charindex('����',jobKind)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '���ݾ�ҵ��λ���������Ӧ��ͳ����ҵ. 11 ���⳵
	  Sql = "update inputDataRpt_001 set jobID=15 where groupID=" & groupID & " and isLand=1 and jobID=0 and charindex('��ʻԱ',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('�г�',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('ʩ��',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('װ��',jobKind)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '���ݾ�ҵ��λ���������Ӧ��ͳ����ҵ. 15 ���� ��ͨ����
	  Sql = "update inputDataRpt_001 set jobID=12 where groupID=" & groupID & " and isLand=1 and jobID=0 and charindex('����',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '���ݾ�ҵ��λ���������Ӧ��ͳ����ҵ. 12 ��������
	  Sql = "update inputDataRpt_001 set jobID=13 where groupID=" & groupID & " and isLand=1 and jobID=0 and (charindex('����',jobKind)+charindex('ҵ��',jobKind)+charindex('Ӫ��',jobKind)+charindex('�ɹ�',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('���',jobKind)+charindex('����',jobKind)+charindex('ͳ��',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('��Ա',jobKind)+charindex('����',jobKind)+charindex('��',jobKind)+charindex('�����',jobKind)+charindex('����',jobKind)+charindex('����ʦ',jobKind)+charindex('��ʦ',jobKind)>0 or jobKind like '%��')"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '���ݾ�ҵ��λ���������Ӧ��ͳ����ҵ. 13 ��ҵ��ҵ
	  Sql = "update inputDataRpt_001 set jobID=14 where groupID=" & groupID & " and isLand=1 and jobID=0 and charindex('ӪҵԱ',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('���',jobKind)+charindex('����Ա',jobKind)+charindex('��ʿ',jobKind)+charindex('ó',jobKind)+charindex('����',jobKind)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '���ݾ�ҵ��λ���������Ӧ��ͳ����ҵ. 14 ��ó����
	  Sql = "update inputDataRpt_001 set jobID=17 where groupID=" & groupID & " and isLand=1 and jobID=0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   '���ݾ�ҵ��λ���������Ӧ��ͳ����ҵ. 17 ����
   end if
   if operaType = "analyseTech" then
   	'���ݾ�ҵ��λ��������ˮƽ
	  Sql = "update inputDataRpt_001 set techID=3 where groupID=" & groupID & " and techID=0 and charindex('���',jobKind)+charindex('����',jobKind)+charindex('ͳ��',jobKind)+charindex('����',jobKind)+charindex('�����',jobKind)+charindex('����',jobKind)+charindex('ʦ',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   
	  Sql = "update inputDataRpt_001 set techID=2 where groupID=" & groupID & " and techID=0 and charindex('����',jobKind)+charindex('ҵ��',jobKind)+charindex('Ӫ��',jobKind)+charindex('�ɹ�',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('��Ա',jobKind)+charindex('����',jobKind)+charindex('��',jobKind)+charindex('��ֳ',jobKind)+charindex('��ֲ',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('�г�',jobKind)+charindex('����',jobKind)+charindex('ó��',jobKind)+charindex('��ó',jobKind)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   
	  Sql = "update inputDataRpt_001 set techID=1 where groupID=" & groupID & " and techID=0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   
   	
   	'����ѧ����������ˮƽ
	  Sql = "update inputDataRpt_001 set techID=2 where groupID=" & groupID & " and techID=1 and education=3"
	  rsTemp.Source = Sql
	  rsTemp.Open()   
   end if
   if operaType = "analyseSalary" then
   	'���ݾ�ҵ��λ��������ˮƽ
	  Sql = "update inputDataRpt_001 set salaryID=3 where groupID=" & groupID & " and salaryID=0 and charindex('����',jobKind)+charindex('����',jobKind)+charindex('ͳ��',jobKind)+charindex('�����',jobKind)+charindex('����',jobKind)+charindex('ʦ',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('ó��',jobKind)+charindex('��ó',jobKind)>0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   
	  Sql = "update inputDataRpt_001 set salaryID=2 where groupID=" & groupID & " and salaryID=0 and (charindex('����',jobKind)+charindex('ҵ��',jobKind)+charindex('Ӫ��',jobKind)+charindex('�ɹ�',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('��Ա',jobKind)+charindex('����',jobKind)+charindex('��',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('���',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('����',jobKind)+charindex('�г�',jobKind)+charindex('����',jobKind)>0 or jobKind like '%��')"
	  rsTemp.Source = Sql
	  rsTemp.Open()   
	  Sql = "update inputDataRpt_001 set salaryID=1 where groupID=" & groupID & " and salaryID=0"
	  rsTemp.Source = Sql
	  rsTemp.Open()   
   	
   	'����ѧ����������ˮƽ
	  Sql = "update inputDataRpt_001 set salaryID=2 where groupID=" & groupID & " and salaryID=1 and education=3"
	  rsTemp.Source = Sql
	  rsTemp.Open()   
   end if
   if operaType = "analyseEducation" then
   	'���ݹ���ˮƽ��ϵͳ��δע�����Ա����ѧ�����ơ�
	  Sql = "update inputDataRpt_001 set education=salaryID where groupID=" & groupID & " and education=0 and newOne=1"
	  rsTemp.Source = Sql
	  rsTemp.Open()   
   end if
   if operaType = "updateJobStatus" then
   	'�ɵ���ľ�ҵ���ݣ�����ϵͳ�ڶ�Ӧ��Ա�ľ�ҵ״̬��
	  Sql = "update inputDataRpt_001 set jobStatus='ũ�帻��' where groupID=" & groupID & " and jobStatus='ũ���ҵ'"
	  rsTemp.Source = Sql
	  rsTemp.Open()   
	  Sql = "update dbf_main set ��Ա���=b.jobStatus from dbf_main a,inputDataRpt_001 b where b.cardID=a.���֤���� and b.effectCount=-1 and b.groupID=" & groupID
	  rsTemp.Source = Sql
	  rsTemp.Open()   'ʧҵ ��ҵ ũ�帻�� ����
	  Sql = "update dbf_main set ��Ա���=b.jobStatus from dbf_main a,inputDataRpt_001 b where b.cardID=a.���֤���� and b.effectCount=1 and b.groupID=" & groupID
	  rsTemp.Source = Sql
	  rsTemp.Open()   '��ҵ
   end if

if operaType = "createExcel" then
	Set rsRpt001 = Server.CreateObject("ADODB.Recordset")
	rsRpt001.ActiveConnection = MM_labour_STRING
	rsRpt001.Source = "SELECT * FROM dbo.rptLastData_00" & rptItem("kindID") & " WHERE groupID = " & groupID & " order by indexID"
	rsRpt001.CursorType = 0
	rsRpt001.CursorLocation = 2
	rsRpt001.LockType = 1
	rsRpt001.Open()
	
	Set rsRptSum001 = Server.CreateObject("ADODB.Recordset")
	rsRptSum001.ActiveConnection = MM_labour_STRING
	rsRptSum001.Source = "SELECT * FROM dbo.v_rptLastDataSum_00" & rptItem("kindID") & " WHERE groupID = " & groupID
	rsRptSum001.CursorType = 0
	rsRptSum001.CursorLocation = 2
	rsRptSum001.LockType = 1
	rsRptSum001.Open()
	
	dim f1,f2,newFileName
	newFileName = "rptExcel" & rptItem("kindID") & "_" & groupID & ".xls"
	f1=Server.MapPath("reports\Template\Excel\rpt" & rptItem("kindID") & ".xls")
	f2=Server.MapPath("reports\excel\" & newFileName)
	Set fso = CreateObject("Scripting.FileSystemObject")
	fso.CopyFile f1,f2
	
	if fillExcel(f2) then
		'Response.write("OK")
		Sql = "delete from docAppendixList where docID=" & groupID & " and type='rpt'"
		rsTemp.Source = Sql
		rsTemp.Open()   
		Sql = "insert into docAppendixList(docID,type,url,fileType,uploaderID,memo) values(" & groupID & ",'rpt','" & "reports\excel\" & newFileName & "','xls','" & Session("user_key") & "','�ǼǾ�ҵͳ��')"
		rsTemp.Source = Sql
		rsTemp.Open()   
	end if

	rsRpt001.Close()
	Set rsRpt001 = Nothing
	rsRptSum001.Close()
	Set rsRptSum001 = Nothing
end if

if operaType = "createUserTempExcel" then
	dim f3,f4
	f3=Server.MapPath("reports\Template\Excel\blank.xls")
	f4=Server.MapPath(filePath)
	Set fso = CreateObject("Scripting.FileSystemObject")
	fso.CopyFile f3,f4

	response.write(createUserTempExcel(f4))
	'response.write(whereMark)
end if

function createUserTempExcel(fd)
    Dim oConn,result,i,m,c,k
	c = 0 '��������
	k = 0 '���

    Set oConn = Server.CreateObject("ADODB.Connection")
    oConn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & fd & ";Extended Properties=""Excel 8.0;HDR=NO;"""
    Set rs = Server.CreateObject("ADODB.Recordset")
    rs.Open "Select  *  From [sheet1$]", oConn, 2, 2

	Set rsTemp = Server.CreateObject("ADODB.Recordset")
	rsTemp.ActiveConnection = MM_labour_STRING
	rsTemp.Source = tblMark & whereMark
	rsTemp.CursorType = 0
	rsTemp.CursorLocation = 2
	rsTemp.LockType = 1
	rsTemp.Open()
	
	if rsTemp.Eof = false then
		c = rsTemp.fields.count

		rs.Fields(0).Value = docItem	'��1�б���
		rs.movenext
		rs.Fields(0).Value = "ͳ��ʱ��:  " & now()
		rs.Fields(4).Value = "ͳ����:  " & session("name_key")
		rs.movenext			'��2��
		rs.movenext			'��3�п�
		    
		rs.fields(0).Value = "���"
	    for i = 1 to c
	    	rs.fields(i).Value = rsTemp.fields(i-1).Name
		next
	    rs.movenext			'��5��  ��ͷ
		
		do while not rsTemp.eof
			k = k + 1
			for i = 1 to c
				rs.Fields(0).Value = k
				rs.Fields(i).Value = rsTemp.Fields(i-1).Value
			next
			rsTemp.movenext
			rs.movenext
		loop
	end if
    createUserTempExcel = k
    rs.Close
	oConn.Close
    Set oConn = Nothing
end function

function inputRptData() 
  dim result
  Dim Conn1,Driver,DBPath,Rs
  DBPath   =   "DBQ=" & Server.MapPath(filePath)   
  Driver = "Driver={Microsoft Excel Driver (*.xls)}; ReadOnly=1; "
  Set Conn1 = Server.CreateObject("ADODB.Connection")
  '����Open   ���������ݿ�   
  Conn1.Open   Driver & DBPath   
  'DSN���ӷ�ʽ   
  'Conn1.Open   "Dsn=test"   
  'ע��   ����һ��Ҫ���±����ָ���   "[����$]"   ��д   
  'Sql = "Select * From [ListView$];"  
  Sql = "Select * From [�й�$];"   
  Set Rs = Conn1.Execute(Sql)   
  'Set   Rs   =   Server.CreateObject("ADODB.Recordset")     
  'Sql = "select * from [ListView]"   
  'Rs.Open Sql, Conn, 1, 1   
  
  IF   Rs.Eof   And   Rs.Bof   Then   
      Response.write   "û���ҵ�����Ҫ������!!"   
      result = 0
  Else   
	  Sql = "delete from inputDataRpt_001 where groupID=" & groupID & ";"   
	  rsTemp.Source = Sql
	  rsTemp.Open()   'ɾ����ǰ���ܴ��ڵ�����
      dim k
      Do While (Not Rs.EOF)
	  	if (len(Rs("֤������")) > 14)  then
			Sql = "INSERT INTO inputDataRpt_001(groupID, indexID, name, sex, cardKind, cardID, unitName, jobType, jobKind, jobRegDate, jobQuitDate, jobRegLocation, jobRegister, jobStartDate, jobEndDate, jobStatus, docLocation, docLocationMemo, jd, jw, address,education,jobID,techID,salaryID,effectCount)"
			Sql = Sql & " values(" & groupID & ",'" & Rs("���") & "','" & Rs("����") & "','" & Rs("�Ա�") & "','" & Rs("֤������") & "','" & Rs("֤������") & "','" & Rs("��λ����") & "','" & Rs("��ҵ����") & "','" & Rs("ְҵ����") & "'," & ifDateNull(Rs("��ҵ�Ǽ�����")) & "," & ifDateNull(Rs("�˹��Ǽ�����")) & ",'" & Rs("��ҵ�Ǽ����ڵ�") & "','" & Rs("��ҵ�Ǽǲ���Ա����") & "'," & ifDateNull(Rs("��ҵ��ʼ����")) & "," & ifDateNull(Rs("������������")) & ",'" & Rs("��ҵ״̬") & "','" & Rs("�������ڵ�") & "','" & Rs("�������ڵر�ע") & "','" & Rs("���������ֵ�") & "','" & Rs("��ί��") & "','" & Rs("���ڵ�ַ") & "',0,0,0,0,1)"
			rsRpt.Source = Sql
			rsRpt.Open()
    	end if
      Rs.MoveNext   
      Loop
      
	  Sql = "update inputDataRpt_001 set bailerID='" & Session("user_key") & "',bailDate=getDate(),age=(year(getdate())*10000+month(getdate())*100+day(getdate())-substring(cardID,7,8))/10000 where groupID=" & groupID
	  rsTemp.Source = Sql
	  rsTemp.Open()   '���ί����
	  result = 1
  End IF   
    
  Rs.Close   
  Set Rs=nothing   
  Conn1.Close   
  Set Conn1=Nothing
  inputRptData = result
end function
  
function delRptData() 
	'if (groupID > 0)  then
		Sql = "delete from inputDataRpt_001 where groupID = " & groupID
		rsTemp.Source = Sql
		rsTemp.Open()
    'end if
end function
  
function setSubStatus(id) 
	if (groupID > 0)  then
		Sql = "update rptItemList set subStatus=" & id & " where ID = " & groupID
		rsTemp.Source = Sql
		rsTemp.Open()
    end if
end function
  
function addRptItem() 
	if (kindID > "")  then
		Sql = "select * from rptKindList where kindID='" & kindID & "'"
		rsRpt.Source = Sql
		rsRpt.Open()
		Sql = "insert into rptItemList(kindID,item,inputDate,inputOperator) values('0001','" & rsRpt("sourceItem") & "' + '(20������ - 20������)',getDate(),'" & Session("user_key") & "')"
		rsRpt.Source = Sql
		rsRpt.Open()
    end if
end function
  
function delRptItem() 
	if (groupID > 0)  then
		Sql = "delete from rptItemList where ID = " & groupID
		rsRpt.Source = Sql
		rsRpt.Open()
    end if
end function

function copyFile(fs,fd)
	Set fso = CreateObject("Scripting.FileSystemObject")
	fso.CopyFile fs,fd
end function

function fillExcel(fd)        
    Dim oConn,result,i,j,m,c
	m = 28 '��������
	c = 0 '��������
	if kindID="1" then
		c = 36
	end if
	if kindID="2" then
		c = 37
	end if
    Set oConn = Server.CreateObject("ADODB.Connection")
    oConn.Open "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" & fd & ";Extended Properties=""Excel 8.0;HDR=NO;"""
    Set rs = Server.CreateObject("ADODB.Recordset")
    rs.Open "Select  *  From [sheet1$]", oConn, 2, 2
	if rsRpt001.bof and rsRpt001.Eof then
		result = false
	else
		result = true
	    rs.Fields(0).Value = rptItem("kindName")	'��1�б���
	    rs.movenext
	    rs.Fields(31).Value = "��ֹ:  " & Year(rptItem("endDate")) & "��" & Month(rptItem("endDate")) & "��"
	    rs.movenext			'��2��
	    rs.movenext			'��3�п�
	    rs.movenext			'��4�п�
	    rs.movenext			'��5�п�  ��ͷ��
		m = m - 5
		do while not rsRpt001.eof
			for i = 0 to c
				if kindID="1" then
					rs.Fields(i).Value = rsRpt001("f" & i)
				end if
				
				if kindID="2" then
					if i<14 then
						rs.Fields(i).Value = rsRpt001("f" & i)
					end if
					if i=14 then
						rs.Fields(14).Value = rsRpt001("f37")
					end if
					if i>14 then
						rs.Fields(i).Value = rsRpt001("f" & i-1)
					end if
				end if
			next
			rsRpt001.movenext
			rs.movenext
			m = m - 1
		loop
		
		for j=1 to m - 1
			rs.movenext
		next
		for i = 1 to c-1     '����
				if kindID="1" then
					rs.Fields(i).Value = rsRptSum001("f" & i)
				end if
				
				if kindID="2" then
					if i<14 then
						rs.Fields(i).Value = rsRptSum001("f" & i)
					end if
					if i=14 then
						rs.Fields(14).Value = rsRptSum001("f37")
					end if
					if i>14 then
						rs.Fields(i).Value = rsRptSum001("f" & i-1)
					end if
				end if
		next
		rs.movenext
		rs.Fields(1).Value = rptItem("deployerName")     '������
		rs.Fields(6).Value = rptItem("deployDate")     '��������
		rs.Fields(11).Value = rptItem("kindID")   		 '�������
		rs.Fields(14).Value = rptItem("ID")    			 '������
		rs.movenext
	end if
    rs.Close
	oConn.Close
    Set oConn = Nothing
	fillExcel = result
end function

'rsRpt.Close()
'Set rsRpt = Nothing
rptItem.Close()
Set rptItem = Nothing
%>