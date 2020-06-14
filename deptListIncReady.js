	var deptListLong = 0;		//0: 标准栏目  1：短栏目
	var deptListChk = 0;

	$(document).ready(function (){
		$.get("deptControl.asp?op=getRootDeptByHost&refID=" + currHost + "&times=" + (new Date().getTime()),function(re){
			if(re>0){
				getDeptList(re);
			}
		});
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
	