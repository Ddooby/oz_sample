<%@page import="java.util.Hashtable"%>
<%@page import="java.io.FileOutputStream"%>
<%@page import="java.io.File"%>
<%@page import="java.io.DataOutputStream"%>
<%@page import="java.io.IOException"%>
<%@page import="java.io.OutputStream"%>
<%@page import="java.util.Enumeration"%>
<%@page contentType="text/html;charset=utf-8"%>
<%request.setCharacterEncoding("utf-8");response.setContentType("text/html;charset=utf-8");%>
<%!
/* OZ Java Serverbinding Example
  **********************************************************************************************************
  서버에서 바인딩 작업이 진행되므로 리포트 개발시 사용했던 폰트가 서버OS에 설치되어 있어야 합니다.
  **********************************************************************************************************
*/

/**
* 파일 체크
*/
public boolean fileExist(String fileNameAndPath) throws IOException{
	File f = new File(fileNameAndPath);
	if(f.exists() && f.length() > 0){
	 	return true;
	}else{
		return false; 
	}
}
/**
* 파일 Write
*/
public boolean fileExport(byte[] bb, String filePathAndName) throws IOException{
	DataOutputStream dOut = null;
	try{
		dOut = new DataOutputStream(new FileOutputStream(filePathAndName));
		dOut.write(bb,0,bb.length);  //데이터
		dOut.flush();
	}finally{
		if(dOut!=null){try{dOut.close();}catch(IOException e){e.printStackTrace();}}
	}
    
	return fileExist(filePathAndName);
}

public String toJS(String str){
	return str.replace("\\", "\\\\")
			  .replace("\'", "\\\'")
			  .replace("\"", "\\\"")
		      .replace("\r\n", "\\n")
			  .replace("\n", "\\n");
}
%>
<%
	Hashtable<String, String> param = new Hashtable<String, String>();
	String resultFiles = "";  
	String ozSap = ";OZ;"; //뷰어 패러미터 구분자
	String ozParamStr = request.getParameter("ozParamStr")==null?"":request.getParameter("ozParamStr"); //오즈 뷰어패러미터

	long start = System.currentTimeMillis();
	boolean result = false;

	try{
		// 뷰어패러미터	고정
		param.put("information.debug", "true");       // 서버에 패러미터 로그 남길지

		//뷰어패러미터 설정
 		String[] ozParam1 = ozParamStr.split(ozSap); 
		for(int i=0; i<ozParam1.length;i++){
			String [] paramKV = new String[2];
			String str = ozParam1[i];
			if(str.indexOf("=") > -1){
				paramKV[0] = str.substring(0, str.indexOf("="));
				paramKV[1] = str.substring(str.indexOf("=")+1);
				param.put(paramKV[0], paramKV[1]); //뷰어 패러미터 이름, 값
			}
		}
		
		//서버바인딩 요청
		request.setAttribute("OZViewerExportParam", param);
		RequestDispatcher dispatcher = application.getRequestDispatcher("/server");
		dispatcher.include(request, response);

		// 결과 파일 저장
		Object o = request.getAttribute("OZViewerExportResult");
		
		if (o == null){
			Throwable t = (Throwable)request.getAttribute("OZViewerExportError");
			out.println("{ \"result\":\"FAIL\", \"msg\":\""+t.toString()+"\" }");
		}else{
			Hashtable t = (Hashtable)o;
			Enumeration enu = t.keys();
			
			while(enu.hasMoreElements()){
				String exportFilePathAndName = (String)enu.nextElement();
				result = fileExport((byte[])t.get(exportFilePathAndName), (String)exportFilePathAndName); //파일 생성
				resultFiles = resultFiles + "\n - " + (String)exportFilePathAndName;
			}
			
			if(result){
				//export 결과 확인
				long end = System.currentTimeMillis();
				out.println("{ \"result\":\"SUCCESS\", \"exportTime\":\""+(end-start)+"\", \"filePathAndName\":\""+toJS(resultFiles)+"\" }");
				
			}else{
				out.println("{ \"result\":\"FAIL\" }");
			}
		}
	}catch (Exception e){
		e.printStackTrace();
		out.println("{ \"result\":\"FAIL\", \"msg\":\""+e.toString()+"\" }");
	}
%>