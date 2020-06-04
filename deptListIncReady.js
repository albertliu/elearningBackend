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
			}
		});
	}
	