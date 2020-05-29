<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%Session.CodePage=65001%>
<SCRIPT LANGUAGE="VBSCRIPT" RUNAT="SERVER">
	
dim op,keyID
op = request("op")
keyID = request("keyID")

if op="getCode128" then
	response.write(escape(StringToCode128(keyID)))
end if

Function StringToCode128(input)
	'this function will transfer a string to zebra code 128B, add a pre-char,trail-char and check-char
		Dim endchar            
    Dim total
    total = 104            
    Dim tmp            
    For i = 1 To len(input)                
	    tmp = Asc(mid(input,i, 1))                
	    If tmp >= 32 Then                    
		    total = total + (tmp - 32) * i                
	    Else                    
		    total = total + (tmp + 64) * i                
	    End If            
    Next            
    Dim endAsc
    endAsc = total mod 103            
    If endAsc >= 95 Then                
	    endAsc = endAsc + 100                
	  Else                
	    endAsc = endAsc + 32                
    End If 
               
	  endchar = chrW(endAsc)    
	  'chrW() is a function specially for unicode        
    StringToCode128 = chrW(204) & input & endchar & chrW(206)       
End Function 

</script>
