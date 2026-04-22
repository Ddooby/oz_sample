<%@page contentType="text/html;charset=euc-kr"%>
<html>
<head>
<title>오즈 자바서버바인딩 구동예제</title>
<script type="text/javascript">
	var ozrParamCnt, odiParamCnt;
	ozrParamCnt = odiParamCnt = 0;

	function addTextbox (id, name, value)
	{
		if (value == null)
			value = '';
		document.getElementById(id).insertRow().insertCell(0).innerHTML = "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type='text' name='" + name + "' value='" + value + "' size='100' onfocus='javascript:this.select();'><br>";
		if (name.indexOf('ozr') > -1)
			ozrParamCnt++;
		else if (name.indexOf('odi') > -1)
			odiParamCnt++;
	}
	
	function delTextbox (id, name)
	{
		if (name.indexOf('ozr') > -1 && ozrParamCnt > 0) {
			ozrParamCnt--;
			document.getElementById(id).deleteRow(Number(document.getElementById(id).getElementsByTagName("tr").length)-1);
		}
		else if (name.indexOf('odi') > -1 && odiParamCnt > 0) {
			odiParamCnt--;
			document.getElementById(id).deleteRow(Number(document.getElementById(id).getElementsByTagName("tr").length)-1);
		}
	}	
	function getCurrentDate ()
	{
		var vDate = new Date();
		var m, d;
		m = (vDate.getMonth() + 1);
		if (m < 10) m = '0' + '' + m;
		d = vDate.getDate();
		if (d < 10) d = '0' + '' + d;
		return vDate.getFullYear() + '' + m + '' + d + '' + vDate.getHours() + '' + vDate.getMinutes() + '' + vDate.getSeconds() + '' + vDate.getMilliseconds();
	}
	function setInitialValues ()
	{
		document.form.serverUrl.value = "<%=request.getScheme()%>" + "://" + "<%=request.getServerName()%>:" + "<%=request.getServerPort()%>/oz80/server";
		document.form.ozrName.value = "/test.ozr";
		//document.form.odiName.value = "life_planning";
		//addTextbox("tb1", "ozrParamVal", "LPName=홍길동");
		//addTextbox("tb2", "odiParamVal", "onoff=dual");
		document.form.viewType.options.selectedIndex = 2;
		document.form.fileName.value = "test_01";//getCurrentDate()
		document.form.filePath.value = "C:\\Temp\\";
		change();	
	}	
	function change()
	{
		var idx = document.form.viewType.options.selectedIndex;
		if (idx == 0)
		{
			document.getElementById("divPath").style.display = "none";
			document.getElementById("divName").style.display = "none";
		}
		else if (idx == 1)
		{
			document.getElementById("divPath").style.display = "none";
			document.getElementById("divName").style.display = "block";
		}
		else if (idx == 2)
		{
			document.getElementById("divPath").style.display = "block";
			document.getElementById("divName").style.display = "block";
		}
	}	
	function go ()
	{
		var idx = document.form.viewType.options.selectedIndex;
		if (idx == 0 || idx == 1)
		{
			document.form.action = "second.jsp";
		}
		else if (idx == 2)
		{
			document.form.action = "third.jsp";
		}
		document.form.submit();
	}
</script>
</head>
<body onload="javascript:setInitialValues();">
<font face="돋움" size="2">
<b>☞</b> 오즈 자바서버바인딩을 사용하여 오즈보고서를 구동하는 예제입니다.
<form name="form" method="get">
	<b>★ OZ Server Info</b> 오즈서버 주소를 설정합니다.<br><br>
	URL&nbsp;&nbsp;<input type="text" name="serverUrl" size="50" onfocus="javascript:this.select();"><br><br><br>
	
	<b>★ OZ Report Info</b> 보고서 생성정보를 설정합니다.<br><br>
	OZR&nbsp;&nbsp;<input type="text" name="ozrName" size="50" onfocus="javascript:this.select();"> 보고서명을 카테고리까지 입력합니다. 예) /sample/sample.ozr<br><br>
	OZR Param&nbsp;<input type="button" onclick="javascript:addTextbox('tb1', 'ozrParamVal');" value="+">
	<input type="button" onclick="javascript:delTextbox('tb1', 'ozrParamVal');" value="-"> 폼패러미터가 있으면 갯수만큼 '+' 버튼으로 추가하여 이름과 값을 입력합니다. 예) formparam=value
	<table id="tb1"></table><br>

	ODI&nbsp;&nbsp;&nbsp;<input type="text" name="odiName" onfocus="javascript:this.select();"> odi파일명을 확장자 없이 입력합니다. 예) sample<br><br>
	ODI Param&nbsp;&nbsp;<input type="button" onclick="javascript:addTextbox('tb2', 'odiParamVal');" value="+">
	<input type="button" onclick="javascript:delTextbox('tb2', 'odiParamVal');" value="-"> odi패러미터가 있으면 갯수만큼 '+' 버튼으로 추가하여 이름과 값을 입력합니다. 예) odiparam=value
	<table id="tb2"></table><br><br>

	<b>★ File Info</b> 보기 방식을 설정합니다.<br><br>
	Format&nbsp;&nbsp;&nbsp;<select name="fileFormat">
	<option value="html">html</option>
	<option value="pdf" selected>pdf</option>
	<option value="xls">xls</option>
	<option value="doc">doc</option>
	<option value="ppt">ppt</option>
	<option value="csv">csv</option>
	<option value="txt">txt</option>
	<option value="hwp">hwp</option>
	<option value="png">png</option>
	<option value="svg">svg</option>
	<option value="jpg">jpg</option>
	</select> 사용할 파일형식을 선택합니다.<br><br>
	Type&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	<select name="viewType" onchange="javascript:change()">
	<option value="View">바로보기</option>
	<option value="Down">다운받기</option>
	<option value="Down">서버저장하기</option>
	</select> 미리보기/다운받기/서버저장하기 여부를 선택합니다.<br><br>
	<div id="divPath">
	Path&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="filePath" size="50" onfocus="javascript:this.select();"> 파일 생성경로를 설정합니다.<br><br>
	</div>
	<div id="divName">
	Name&nbsp;&nbsp;&nbsp;&nbsp;<input type="text" name="fileName" size="50" onfocus="javascript:this.select();"> 파일 이름을 설정합니다.<br><br>
	</div><br>

	<input type="button" value="시작" onclick="javascript:go();">
</form>
</font>
</body>
</html>