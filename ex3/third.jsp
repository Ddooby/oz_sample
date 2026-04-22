<%@page import="java.util.Enumeration"%>
<%
/*----------------------------------------------------------------------------------
	
	Name
		third.jsp
		이 파일은 first.jsp 와 같이 동작합니다.

	Description
		오즈 자바서버바인딩 제품을 사용하여 오즈보고서를 파일 저장하는 예제

	Arguments
		String ozrName
			ozr 파일경로
		String[] ozrParamVa
			폼패러미터
		String[] ozrParamCn
			폼패러미터
		odiNameString odiNa
			odi 파일 명
		String[] odiParamNa
			ODI패러미터
		String[] odiParamCn
			ODI패러미터
		String filePath
			파일 경로
		String fileName
			파일 명
		String fileFormat
			파일 형식
	Remarks
		api 함수에 대한 prototype 과 추가 예제는 메뉴얼을 참조하세요.
		OZ API Developer's Guide (for Java).pdf
		131 ~ 168 쪽 입니다. (Scheduler Class)

	Advanced Work
		first.jsp 와 thrid.jsp 는 오즈서버와 동일한 Context 에서 구동되어야 합니다.
		예) http://127.0.0.1/oz80/jsp/first.jsp

	* 20150907 kosh 이미지 파일 첫페이지만 export 되는 문제로 전체 파일 export 처리 추가
----------------------------------------------------------------------------------*/
%>
<%@page contentType="text/html;charset=euc-kr"%>
<%request.setCharacterEncoding("euc-kr");response.setContentType("text/html;charset=euc-kr");%>
<%@ page import = "java.io.File,
		java.util.Hashtable,
		java.io.FileOutputStream,
		oz.framework.api.Service"
%>
<!doctype html>
<html lang="en" style="height:100%">
<body style="height:100%">
<%
	String		ozrName		= request.getParameter("ozrName");
	String[]	ozrParamVal	= request.getParameterValues("ozrParamVal");

	String		odiName		= request.getParameter("odiName");
	String[] 	odiParamVal	= request.getParameterValues("odiParamVal");

	String		fileFormat	= request.getParameter("fileFormat");
	String		filePath	= request.getParameter("filePath");
	String		fileName	= request.getParameter("fileName");

	try
	{
		// 파일 경로를 설정합니다. 해당 폴더에 WAS 계정이 Write 권한이 있어야 합니다.
		fileName += "." + fileFormat;
		//filePath += File.separator;

		Hashtable param = new Hashtable();

		//param.put("export.saveonefile", "false");
		//param.put("export.mode", "silent");
		//param.put("export.confirmsave", "false");
		
		param.put("export.format", fileFormat);
		param.put("export.path", filePath);
		param.put("export.filename", fileName);

		param.put("pdf.fontembedding", "true");
		param.put("pdf.fontembedding_subset", "true");

		// 보고서정보를 설정합니다.
		param.put("connection.reportname", ozrName);

		// 폼패러미터값을 설정합니다.
		if (ozrParamVal != null){
			param.put("connection.pcount", Integer.toString(ozrParamVal.length));

			for (int i = 0; i < ozrParamVal.length; i++){
				if (ozrParamVal[i].indexOf("=") > -1){
					param.put("connection.args" + (i + 1), ozrParamVal[i]);
				}
			}
		}

		// ODI패러미터값을 설정합니다.
		if (odiParamVal != null){
			param.put("odi.odinames", odiName);
			param.put("odi." + odiName + ".pcount", Integer.toString(odiParamVal.length));

			for (int i = 0; i < odiParamVal.length; i++){
				if (odiParamVal[i].indexOf("=") > -1){
					param.put("odi." + odiName + ".args" + (i + 1), odiParamVal[i]);
				}
			}
		}

		param.put("html.pagebreaktag", "<!-- MarkAny Page Gubun -->");

		request.setAttribute("OZViewerExportParam", param);
		RequestDispatcher dispatcher = application.getRequestDispatcher("/server");
		dispatcher.include(request, response);

		Boolean result = false;
		Object o = request.getAttribute("OZViewerExportResult");

		if (o == null){
			Throwable t = (Throwable)request.getAttribute("OZViewerExportError");
			t.printStackTrace();
		}else{
			Hashtable t = (Hashtable)o;
			
			Enumeration enu = t.keys();
			
			while(enu.hasMoreElements()){
				String pathAndName = (String)enu.nextElement();
				byte[] b = (byte[])t.get(pathAndName);
				out.println("pathAndName : " + pathAndName+"<br>");
				
				if (b != null){
					FileOutputStream fos = null;
					File file = new File(filePath);
	System.out.println(filePath+" 디렉토리 존재여부:"+file.isDirectory());				
					if(!file.isDirectory()){
						file.mkdir();
					}
					try{
						fos = new FileOutputStream(pathAndName);
						fos.write(b);
						fos.flush();
					}catch (Exception e){
						result = false;
						e.printStackTrace();
					}
					finally{
						if (fos != null){
							fos.close();
						}
					}
	
					//File file = new File(filePath + fileName);
	
					result = file.exists() ? true : false;
				}else{
	System.out.println("result=false");
					result = false;
				}
			}
		}

		out.println("<font face=\"맑은 고딕\"><br>");
		out.println("Result : " + result);
		if (result){
			out.println("<br>Check : " + filePath + fileName+"<br>");
		}
	}catch (Exception e){
		e.printStackTrace();
		return;
	}
%>
</body>
</html>