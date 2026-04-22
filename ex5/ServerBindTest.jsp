<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
servlet으로 서버바인딩호출..3
<form name="form1" method="post" action="/oz70/serverbind" accept-charset="ks_c_5601-1987">
<!-- form name="form1" method="get" action="./export.jsp" accept-charset="ks_c_5601-1987" -->
  <input type="hidden" name="ozserverexport" value="true">
  <input type="hidden" name="download" value="true">
  <input type="hidden" name="filename" value="param1_servlet.pdf">
  <input type="hidden" name="exportview" value="true">
  <input type="hidden" name="connection.reportname" value="param1.ozr">
  <!--input type="hidden" name="odi.odinames" value="emp"-->
  <input type="submit" name="submit" value="조회">
</form>
</body>
</html>