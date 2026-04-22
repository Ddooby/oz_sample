<%
%>
<html>
<body>
<form name='form1' method='post' action='/oz70/server'>
  <input type='hidden' name='ozserverexport' value='true'>
  <input type='hidden' name='exportview' value='false'>
  <input type='hidden' name='filename' value='jsonSampleTest.pdf'>
  <input type='hidden' name='pdf.fontembedding' value='true'>
  <input type='hidden' name='pdf.fontembedding_subset' value='true'>
  <input type='hidden' name='connection.reportname' value='jsonSampleTest.ozr'>
  <input type='hidden' name='connection.pcount' value='1'>
  <input type='hidden' name='connection.args1' value='jsondata={	"Category": [		{			"CategoryID": 1,			"CategoryName": "Drink",			"Description": "청량음료, 커피, 홍차, 맥주"		},		{			"CategoryID": 2,			"CategoryName": "조미료",			"Description": "감미료, 향신료, 양념, 스프레드"		}	],	"Product": [		{			"ProductID": 75,			"ProductName": "알파인 맥주",			"CategoryID": 1,			"QuantityPerUnit": "24 - 0.5 l bottles",			"UnitPrice": 24000.0,			"UnitsInStock": 125		},		{			"ProductID": 39,			"ProductName": "OK 바닐라 셰이크",			"CategoryID": 1,			"QuantityPerUnit": "750 cc per bottle",			"UnitPrice": 28000.0,			"UnitsInStock": 69		},		{			"ProductID": 34,			"ProductName": "태일 라이트 맥주",			"CategoryID": 1,			"QuantityPerUnit": "24 - 12 oz bottles",			"UnitPrice": 34000.0,			"UnitsInStock": 111		},		{			"ProductID": 65,			"ProductName": "루이지애나 특산 후추",			"CategoryID": 2,			"QuantityPerUnit": "32 - 8 oz bottles",			"UnitPrice": 21000.0,			"UnitsInStock": 76		},		{			"ProductID": 61,			"ProductName": "사계절 핫 소스",			"CategoryID": 2,			"QuantityPerUnit": "24 - 500 ml bottles",			"UnitPrice": 28000.0,			"UnitsInStock": 111		},		{			"ProductID": 6,			"ProductName": "대양 특선 블루베리 잼",			"CategoryID": 2,			"QuantityPerUnit": "12 - 8 oz jars",			"UnitPrice": 25000.0,			"UnitsInStock": 120		}	]}';'>
  
  <input type='hidden' name='odi.odinames' value='Customer'>
  <input type='hidden' name='odi.Customer.pcount' value='2'>
  <input type='hidden' name='odi.Customer.args1' value='Gender=F'>
  <input type='hidden' name='odi.Customer.args2' value='MemberCard=Golden'

  <input type='submit' name='submit' value='Search'>
</form>
</body>
</html>