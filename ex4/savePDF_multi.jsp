<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html style="height:100%">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<script src="http://code.jquery.com/jquery-2.0.3.min.js"></script>
<script type="text/javascript">
//서버바인딩 이용하여 서버에 PDF 생성
var ozServerBind = function(){
	//뷰어패러미터 갱신
	setParam();
	
	var data = {"ozParamStr":ozParamStr};

	$.ajax({
		type : "post",
		url : "./oz_serverbind.jsp",
		dataType : "json",
		data : data,
		cache:false
	}).done(function(data) {
		if(data.result == "SUCCESS"){
			alert("result : "+data.result+"\r\nexportTime : "+data.exportTime +" \r\nfilePathAndName : "+data.filePathAndName);
		}else if(data.result == "FAIL"){
			alert("result : FAIL"+" \r\nmsg :"+data.msg);
		}else {
			alert("");
		}
	}).error(function(request, status, error) {
		if (request.status != "0") {
			alert("code : " + request.status + "\r\nmessage : "	+ request.reponseText + "\r\nerror : " + error);
		}
	});
}

//서버바인딩에서 서식 호출할 뷰어패러미터 세팅
function setParam(){
	var ozsep = ";OZ;";
	ozParamStr = "";
	// 저장할 포맷, 저장옵션
	ozParamStr += "viewer.childcount=2"+ozsep;
	ozParamStr += "global.inheritparameter=true"+ozsep; //child에 패러미터 상속
	ozParamStr += "export.format=pdf"+ozsep;
	ozParamStr += "export.savemultidoc=true"+ozsep;
	ozParamStr += "pdf.fontembedding=true"+ozsep;
	ozParamStr += "pdf.fontembedding_subset=true"+ozsep;

	// 첫번째 보고서 이름,패러미터,저장경로
	ozParamStr += "connection.reportname=test1.ozr"+ozsep;
	ozParamStr += "connection.pcount=1"+ozsep;
	ozParamStr += "connection.args1=year=2010"+ozsep;
	ozParamStr += "export.path=c:\\temp\\"+ozsep;
	ozParamStr += "export.filename=test11.pdf"+ozsep;

	// 두번째 보고서 이름,패러미터,저장경로
	ozParamStr += "child1.connection.reportname=test2.ozr"+ozsep;
	ozParamStr += "child1.connection.pcount=2"+ozsep;
	ozParamStr += "child1.connection.args1=year=2015"+ozsep;
	ozParamStr += "child1.connection.args2=month=3"+ozsep;
	ozParamStr += "child1.export.path=c:\\temp\\"+ozsep;
	ozParamStr += "child1.export.filename=test22.pdf"+ozsep;

	// 세번째 보고서 이름,패러미터,저장경로
	ozParamStr += "child2.connection.reportname=test3.ozr"+ozsep;
	ozParamStr += "child2.connection.pcount=3"+ozsep;
	ozParamStr += "child2.connection.args1=year=2020"+ozsep;
	ozParamStr += "child2.connection.args2=month=5"+ozsep;
	ozParamStr += "child2.connection.args3=day=14"+ozsep;
	ozParamStr += "child2.export.path=c:\\temp\\"+ozsep;
	ozParamStr += "child2.export.filename=test33.pdf"+ozsep;
}

$(document).ready(function(){
	$("#savePDF").click(function(){
		ozServerBind();
	});
});
</script>
</head>
<body style="width:98%;height:98%">
<input type="button" id="savePDF" value="PDF저장" />
</body>
</html>
