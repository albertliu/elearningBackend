﻿
	function getAgreement(username,name,course,path,signDate,price,priceStandard){
		price = (price==0 ? price="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;":price)
		var arr = new Array();
		// arr.push('<div style="page-break-after:always">&nbsp;</div>');
		arr.push('<div style="">');
		arr.push('	<div style="text-align:center; margin:25px 0 20px 0;"><h2 style="font-size:1.7em;">培训协议书（2024版）</h2></div>');
		arr.push('</div>');
		arr.push('<div style="float:left;width:100%;">');
		arr.push('	<table style="width:100%; padding-left:10px;margin-top:25px;">');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p style="font-size:1.3em;text-indent:2em;">为了确保培训学员[' + name + ']身份证号[' + username + ']（乙方）和上海智能消防学校（甲方）的权益，明确甲乙双方的义务，经平等、自愿、协商签订本“培训协议书”。具体约定如下：</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p style="font-size:1.3em;text-indent:2em;line-height:50px;">1、乙方自主选择[' + course + ']培训项目，该项目培训费为：' + priceStandard + '元（包括培训费、申报考试鉴定费等），乙方缴纳' + price + '元（由单位支付培训费的部分无需缴纳）。</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p style="font-size:1.3em;text-indent:2em;">2、乙方已详细阅读甲方报名处公示的各项内容（属于单位集体报名的学员，开班当天须本人到报名处阅读各项公示内容，如有不解之处可向报名处工作人员咨询）。</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p style="font-size:1.3em;text-indent:2em;">3、该培训项目实行考培分离制度，学校负责培训。申请考试分两种情况：① 上海市应急管理局和社会评价机构（人社局）发证项目，由甲方统一申请考试； ② 其他考试项目由乙方自行向相关鉴定机构申报考试，若乙方申报遇到困难，可向甲方提出协助（甲方发证培训考核项目，此条款不适用）。</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p style="font-size:1.3em;text-indent:2em;">4、乙方在办理报名手续后，扫甲方二维码登陆后即进入了甲方线上教学平台开始学习，如要退学退款按以下规则处理：</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p style="font-size:1.3em;text-indent:3.5em;">1）报名后三天内申请退学，甲方收取20元报名手续费和书本费（书本不予退还）后退款；</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p style="font-size:1.3em;text-indent:3.5em;">2）报名后超过三天申请退学，甲方收取培训费的20%，退款金额为原支付金额的80%；</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p style="font-size:1.3em;text-indent:3.5em;">3）报名后超过五天申请退学，甲方收取培训费的30%，退款金额为原支付金额的70%；</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p style="font-size:1.3em;text-indent:3.5em;">4）开始线下培训的第二天申请退学，甲方收取培训费的50%，退款金额为原支付金额的50%；</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p style="font-size:1.3em;text-indent:3.5em;">5) 开始线下培训的第三天申请退学，培训费不予退还。</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p style="font-size:1.3em;text-indent:3.5em;">6) 乙方申请退学须携带缴费票据原件和身份证，填写退款申请，未提供票据原件的不予退费。</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p style="font-size:1.3em;text-indent:2em;">5、乙方上课期间必须自觉履行签到考勤制度，如本人没有签到，不来上课，作缺课处理。</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p style="font-size:1.3em;text-indent:2em;">6、乙方因自身原因未参加考试，作缺考处理；如要再次参加考试，须缴纳相关费用。</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p style="font-size:1.3em;text-indent:2em;">7、乙方承诺报名的各项信息真实、有效、正确，且本人签名。如乙方弄虚作假、不符合报名培训考试的规定而入学，所产生的一切后果自负，且一律不退任何费用。</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p style="font-size:1.3em;text-indent:2em;">8、乙方报名后须关注该培训项目班级群内由学校发布的相关培训考试信息，如因未关注班级群信息或手机号填写不正确而没有收到相关信息，乙方应承担由此而引起的一切责任。</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p style="font-size:1.3em;text-indent:2em;">9、乙方未完成线上理论教学80%的课时学习或线下80%的课时学习，甲方有权不予申报考试。</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p style="font-size:1.3em;text-indent:2em;">10、若乙方考试不及格，需自行到甲方报名处重新申请培训考试，并重新缴纳培训考试费。</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p style="font-size:1.3em;text-indent:2em;">11、本协议一式二份，甲、乙双方各执一份，乙方在签字前应认真阅读本协议各项条款内容和报名处公示的内容，本协议一经签字立即生效。</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td colspan="2" style="height:30px;"><p style="font-size:1.3em;text-indent:2em;"></p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td  style="height:50px;"><p style="font-size:1.3em;text-indent:2em;">甲方：上海智能消防学校</p></td>');
		arr.push('			<td  style="height:50px;"><p style="font-size:1.3em;">乙方（签字）：</p></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td style="height:50px;"><p style="font-size:1.3em;text-indent:2em;">（盖章）</p></td>');
		arr.push('			<td></td>');
		arr.push('		</tr>');
		arr.push('		<tr>');
		arr.push('			<td style="height:30px;"><p style="font-size:1.3em;text-indent:2em;">日&nbsp;&nbsp;&nbsp;&nbsp;期：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;年&nbsp;&nbsp;&nbsp;&nbsp;月&nbsp;&nbsp;&nbsp;&nbsp;日</p></td>');
		arr.push('			<td style="height:30px;"><p style="font-size:1.3em;">日&nbsp;&nbsp;&nbsp;&nbsp;期：&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + signDate + '</p></td>');
		arr.push('		</tr>');
		arr.push('	</table>');
		arr.push('</div>');
		
		if(path>""){
			//alert(path);
			arr.push('<div style="position: relative;width:100%;height:80%;">');
			arr.push('<div style="position: absolute; z-index:10;">');
			arr.push('<div style="float:left;">');
			if(path>''){
				arr.push('	<span><img src="/users' + path + '?times=' + (new Date().getTime()) + '" style="width:170px;margin:0px 0px 8px 480px;padding-left:80px;padding-top:855px;"></span>');
			}
			arr.push('</div>');
			arr.push('</div>');
			arr.push('<div style="position: absolute; z-index:10;">');
			arr.push('<div style="float:left;">');
			arr.push('	<span><img src="/users/upload/companies/stamp/znxf.png" style="opacity:0.6; width:200px;margin:0px 0px 8px 50px;padding-left:80px;padding-top:810px;"></span>');
			arr.push('</div>');
			arr.push('</div>');
			arr.push('</div>');
		}
		/**/
		$("#agreementCover").html(arr.join(""));
	}
