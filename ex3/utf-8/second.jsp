<%
/*----------------------------------------------------------------------------------
	
	Name
		second.jsp
		이 파일은 first.jsp 와 같이 동작합니다.

	Description
		오즈보고서를 ozd 형 변환하여 파일정장하는 예제

	Arguments
		String serverUrl
			OZ 서버 URL
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
		String fileName
			파일 명
		String fileFormat
			파일 형식 (html/pdf/xls/doc/ppt/csv/txt/hwp/svg)
		String viewType
			미리보기/다운받기 여부 (View/Down)

	Remarks
		api 함수에 대한 prototype 과 추가 예제는 메뉴얼을 참조하세요.
		OZ API Developer's Guide (for Java).pdf
		131 ~ 168 쪽 입니다. (Scheduler Class)

	Advanced Work
		본 jsp 파일은 오즈서버와 동일한 Context 에서 구동되어야 합니다.
		예) http://127.0.0.1/oz80/jsp/first.jsp
----------------------------------------------------------------------------------*/
%>
<%@ page import="oz.framework.api.Service"	%>
<%@ page contentType="text/html;charset=utf-8"	%>
<%	request.setCharacterEncoding("utf-8");	%>
<%
	String		serverUrl	= request.getParameter("serverUrl");

	String		ozrName		= request.getParameter("ozrName");
	String[]	ozrParamVal	= request.getParameterValues("ozrParamVal");

	String		odiName		= request.getParameter("odiName");
	String[] 	odiParamVal	= request.getParameterValues("odiParamVal");

	String		fileName	= request.getParameter("fileName");
	String		fileFormat	= request.getParameter("fileFormat");
	String		viewType	= request.getParameter("viewType");

	Service 	service		= null;
	String		ozParam		= "";
	String		ozDiv		= "&";

	try
	{
		service = new Service(serverUrl, "admin", "password", false, false); // 오즈 서버의 admin 계정 암호를 올바르게 변경하세요.

		// 오즈서버 구동여부를 확인한다.
		if (service.ping())
		{

			ozParam += serverUrl + "?";
			ozParam += "ozserverexport=true" + ozDiv;

			// 파일형식을 설정한다.
			ozParam += "filename=" + fileName + "." + fileFormat + ozDiv;

			// 미리보기/다운받기 여부를 설정한다.
			ozParam += "exportview=" + (viewType.compareTo("View") == 0 ? "true" : "false") + ozDiv;

			// 보고서정보를 설정한다.
			ozParam += "connection.reportname=" + ozrName + ozDiv;

			// 폼패러미터값을 설정한다.
			if (ozrParamVal != null)
			{
				ozParam = ozParam + "connection.pcount=" + Integer.toString(ozrParamVal.length) + ozDiv;

				for (int i = 0; i < ozrParamVal.length; i++)
				{
					if (ozrParamVal[i].indexOf("=") > -1)
					{
						ozParam += "connection.args" + (i + 1) + "=" + ozrParamVal[i] + ozDiv;
					}
				}
			}

			// ODI패러미터값을 설정한다.
			if (odiParamVal != null)
			{
				ozParam = ozParam + "connection.pcount=" + Integer.toString(odiParamVal.length) + ozDiv;

				for (int i = 0; i < odiParamVal.length; i++)
				{
					if (odiParamVal[i].indexOf("=") > -1)
					{
						ozParam += "odi." + odiName + ".args" + (i + 1) + "=" + odiParamVal[i] + ozDiv;
					}
				}
			}

			// 기타 패러미터값을 설정한다.
			ozParam += "pdf.fontembedding=true" + ozDiv;
			ozParam += "pdf.fontembedding_subset=true" + ozDiv;

		//	ozParam += "html.pagebreaktag=<!-- MarkAny Page Gubun -->";
%>
<meta http-equiv="refresh" content="0;url=<%= ozParam %>">
<%
		}
		else
		{
			out.println("OZ Server is dead.<p>Check URL : <a href='" + serverUrl + "'>" + serverUrl + "</a>");
		}
	}
	catch (Exception e)
	{
		e.printStackTrace();
		return;
	}
%>