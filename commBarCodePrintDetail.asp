<script language="javascript">
	function getBarCodePrintList(){
		$.get("barCodeControl.asp?op=getListNoPrinted&times=" + (new Date().getTime()),function(data){
			//alert(unescape(data));
			var ar = new Array();
			ar = (unescape(data)).split("%%");
			$("#barCodeCover").empty();
			var s = "";					
			s += "<table cellpadding='0' cellspacing='0' border='0' class='display' id='barCodeTab' width='95%'>";
			s += "<thead>";
			s += "<tr>";
			s += "<th width='6%'>No</th>";
			s += "<th width='20%'>档案编号</th>";
			s += "<th width='15%'>姓名</th>";
			s += "<th width='20%'>存放位置</th>";
			s += "<th width='15%'>打印人</th>";
			s += "<th width='24%'>提交时间</th>";
			s += "</tr>";
			s += "</thead>";
			s += "<tbody id='tbody'>";
			if(ar>""){
				var i = 0;
				$.each(ar,function(iNum,val){
					var ar1 = new Array();
					ar1 = val.split("|");
					i += 1;
					s += "<tr class='grade0'>";
					s += "<td width='6%' class='center'>" + i + "</td>";
					s += "<td width='20%' class='left'>" + ar1[1] + "</td>";
					s += "<td width='15%' class='left'>" + ar1[2] + "</td>";
					s += "<td width='20%' class='left'>" + ar1[3] + "</td>";
					s += "<td width='15%' class='left'>" + ar1[4] + "</td>";
					s += "<td width='24%' class='left'>" + ar1[5] + "</td>";
					s += "</tr>";
				});
			}
			s += "</tbody>";
			s += "<tfoot>";
			s += "<tr>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "<th>&nbsp;</th>";
			s += "</tr>";
			s += "</tfoot>";
			s += "</table>";
			$("#barCodeCover").html(s);
			$('#barCodeTab').dataTable({
				"aaSorting": [[ 0, "asc" ]],
				"aLengthMenu": [[15, 25, 50, -1], [15, 25, 50, "All"]]
			});
			document.getElementById("lightBarCode").style.display="block";
			document.getElementById("fadeBarCode").style.display="block";
		});
	}
</script>

<div valign="baseline">
	<div id="lightBarCode" class="white_content" STYLE="font-family: Arial; font-size: 12px; color: black"> 
		<div align="right">
		  <span align="right" onclick="document.getElementById('lightBarCode').style.display='none';document.getElementById('fadeBarCode').style.display='none'"><img src="../Images/close3.gif" />
		  </span>
		</div>    
		<br>
		<div class="comm" id="barCodeTitle" align="center"></div>
		<br>
		<div id="barCodeCover">
		</div>
		<br>
		<div class="comm" align="center"><input id="refreshBarCodeList" type="button" value=" 刷新 "></div>
	</div> 
	<div id="fadeBarCode" class="black_overlay"></div> 
</div>
