	var deptListLong = 0;		//0: 标准栏目  1：短栏目
	var deptListChk = 0;

	$(document).ready(function (){

		getDeptList(8);
	});

	function getDeptList(id){
		var dtree = getDeptTree(id);
		//jAlert(dtree);
		$("#tree1").treeview({
			data: dtree,
			onNodeSelected: function(event, data) {
				//alert(data.id);
				showDeptInfo(data.id,data.pID,0,1);
				//$("#f_deptInfo").html("<iframe id='iframe1' src='deptInfo.asp?op=0&nodeID=" + data.id + "&refID=" + data.id + "' frameborder='0' scrolling='auto' width='100%' onload='this.height=document.body.scrollHeight * 0.778'></iframe>");  // alert node text property when clicked
			}
			/*formatter:function(node){
				return node.text;
			},
			onClick: function(node){
				$("#f_fdaInfo").html("<iframe id='iframe1' src='deptInfo.asp?op=0&nodeID=" + node.id + "&refID=" + node.id + "' frameborder='0' scrolling='auto' width='100%' onload='this.height=document.body.scrollHeight * 0.778'></iframe>");  // alert node text property when clicked
			}*/
		});
	}
	