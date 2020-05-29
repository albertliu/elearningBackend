<!--#include file="js/doc.js" -->

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">
<HTML>
<HEAD>

<title>资生堂丽源化妆品有限公司</title>
<META content="text/html; charset=utf-8" http-equiv=Content-type><!-- TextboxList is not priceless for commercial use. See <http://devthought.com/projects/mootools/textboxlist/> --><!-- required stylesheet for TextboxList -->
<LINK rel=stylesheet type=text/css href="css/TextboxList.css">
<!-- required stylesheet for TextboxList.Autocomplete -->
<LINK rel=stylesheet type=text/css href="css/TextboxList.Autocomplete.css">
<SCRIPT type=text/javascript src="js/mootools-1.2.1-core-yc.js"></SCRIPT>
<!-- required for TextboxList -->
<SCRIPT type=text/javascript src="js/GrowingInput.js"></SCRIPT>

<SCRIPT type=text/javascript src="js/TextboxList.js"></SCRIPT>

<SCRIPT type=text/javascript src="js/TextboxList.Autocomplete.js"></SCRIPT>
<!-- required for TextboxList.Autocomplete if method set to 'binary' -->
<SCRIPT type=text/javascript src="js/TextboxList.Autocomplete.Binary.js"></SCRIPT>
<!--#include file="js/correctPng.js"-->
<!-- sample style -->
<STYLE type=text/css media=screen>.form_tags {
	MARGIN-BOTTOM: 10px
}
.textboxlist {
	WIDTH: 580px;
	Height: auto;
}
.textboxlist-loading {
	BACKGROUND: url(images/spinner.gif) no-repeat 380px center
}
.form_friends .textboxlist-autocomplete-result {
	ZOOM: 1; OVERFLOW: hidden
}
.form_friends .textboxlist-autocomplete-result IMG {
	PADDING-RIGHT: 10px; FLOAT: left
}
.note {
	COLOR: #666; FONT-SIZE: 90%
}
</STYLE>
<script type="text/javascript">
	var oldList = "";
	window.addEvent('load', function(){
				// Standard initialization
				var t = new TextboxList('form_tags_input', {unique: true,bitsOptions:{editable:{addKeys: 188}}});
				var ar = new Array();
				ar = ('<%=Session("userCart")%>').split(",");
				
				for(i=0; i<ar.length; i++){
					t.add(ar[i]);
				}
	});
	
	function openCart(){
		window.open("userManagement.asp","_self");
	}
	
</SCRIPT>


<!-- sample initialization -->
</HEAD>
<BODY>

				<DIV class=form_tags><INPUT id="form_tags_input" type=text name="form_tags_input"></DIV>

</BODY>
</HTML>
