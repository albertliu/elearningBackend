
		document.getElementById("lightLoadFile").style.display="none";
		document.getElementById("fadeLoadFile").style.display="none";
		
		$("input[name='uploadKind']").change(function(){
			//alert($("input[name='uploadKind']:checked").val());
			$("#formUpload").attr("action", action + "?upID=" + $("input[name='uploadKind']:checked").val() + "&username=" + username);
		});
		/*
		$("#restore").click(function(){
			alert($("#formUpload").attr("action"));
			$("#formUpload").ajaxSubmit(function(data){
                alert(data);
				document.getElementById("lightLoadFile").style.display="none";
				document.getElementById("fadeLoadFile").style.display="none";
				//alert(nodeID);
				getNodeInfo(nodeID);
           	});
		});
		*/
		
		$("#restore").click(function(){
            var form = new FormData(document.getElementById("formUpload"));
			var act = action + "?upID=" + $("input[name='uploadKind']:checked").val() + "&username=" + username;
            $.ajax({
                url: act,
                type:"post",
                data:form,
                processData:false,
                contentType:false,
                success:function(data){
 					document.getElementById("lightLoadFile").style.display="none";
					document.getElementById("fadeLoadFile").style.display="none";
					getNodeInfo(nodeID);
	                //alert(data);
                },
                error:function(e){
					document.getElementById("lightLoadFile").style.display="none";
					document.getElementById("fadeLoadFile").style.display="none";
					getNodeInfo(nodeID);
					//alert(e);
                }
            });        
		});

