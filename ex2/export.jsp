<%@ page contentType="charset=UTF-8" autoFlush="true"%><%@ page import="java.util.*,java.io.*"%><%!
	
	public String getParameter(HttpServletRequest req, String key) {
  	
		String value = req.getParameter(key);
		
		try {
		  	//System.out.println(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>" + key +":"+ value);
			return unescape(new String(value.getBytes("8859_1"), "EUC-KR"));
		}catch(Exception e) {
			return value;
		}
	}	

       public static String unescape(String src) {   
               StringBuffer tmp = new StringBuffer();   
               tmp.ensureCapacity(src.length());   
               int lastPos = 0, pos = 0;   
               char ch;   
               while (lastPos < src.length()) {   
                       pos = src.indexOf("%", lastPos);   
                       if (pos == lastPos) {   
                               if (src.charAt(pos + 1) == 'u') {   
                                       ch = (char) Integer.parseInt(src   
                                                       .substring(pos + 2, pos + 6), 16);   
                                       tmp.append(ch);   
                                       lastPos = pos + 6;   
                               } else {   
                                       ch = (char) Integer.parseInt(src   
                                                       .substring(pos + 1, pos + 3), 16);   
                                       tmp.append(ch);   
                                       lastPos = pos + 3;   
                               }   
                       } else {   
                               if (pos == -1) {   
                                       tmp.append(src.substring(lastPos));   
                                       lastPos = src.length();   
                               } else {   
                                       tmp.append(src.substring(lastPos, pos));   
                                       lastPos = pos;   
                               }   
                       }   
               }   
               return tmp.toString();   
       }

	   public boolean doImageSessionProcess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        String key = request.getParameter("ie_image_url");

        if(key != null && !"".equals(key)){
            HttpSession session = request.getSession();
            Object obj = session.getAttribute(key);

            if(obj != null){
                response.setContentType("image/jpg");
                byte[] data = (byte[])obj;
                ServletOutputStream oout = response.getOutputStream();
                oout.write(data);
                oout.close();
            }
            return true;
        }
        else{
            return false;
        }
    }
	   
	public boolean writefile(byte[] b, String path)
	{
		BufferedOutputStream fout = null;
		boolean result = false;
		try{
			fout = new BufferedOutputStream(new FileOutputStream(path));
			fout.write(b);
			fout.flush();
			fout.close();
			fout = null;
			result = true;
		}catch(Exception e){
			result = false; 
		}finally{
			if(fout!=null) try{fout.close();}catch(Exception e){}
		}
		return result;
	}
%><%


try {
		if (doImageSessionProcess(request, response))
        {
            return;
        }

  	  	//out.clear();
		Hashtable param = new Hashtable(); // 뷰어 파라미터
		boolean isFileDown = Boolean.parseBoolean(getParameter(request, "download"));
		String fileDownType = "inline";
		if(isFileDown) {
			fileDownType = "attachment";
		}

		String fileName = getParameter(request, "filename");
		if (fileName == null || fileName.length() == 0 || fileName.lastIndexOf(".") == -1) {
			throw new Exception("filename request parameter is not exist.");
		}

		String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1);
		String exportFormat = "";
		String strContentType = "";

        int index = fileName.lastIndexOf(".") + 1;
      	fileName = fileName.substring(0, index-1)+"."+fileExt.toLowerCase();
      	//String exportResultPath = "/app/oz80/export/pdf";
      	String exportResultPath = "C:\\Temp"; // 서버에 export한 파일을 저장할 경로
     	String exportResultKey = exportResultPath + File.separator + fileName;

		if (fileExt.equalsIgnoreCase("HTML")) {
			exportFormat = "html";
			strContentType = "text/html";
		} else if (fileExt.equalsIgnoreCase("PDF")) {
			exportFormat = "pdf";
			strContentType = "application/pdf";
		} else if (fileExt.equalsIgnoreCase("DOC")) {
			exportFormat = "doc";
			strContentType = "application/doc";
		} else if (fileExt.equalsIgnoreCase("PPT")) {
			exportFormat = "ppt";
			strContentType = "application/ppt";
		} else if (fileExt.equalsIgnoreCase("XLS")) {
			exportFormat = "xls";
			strContentType = "application/excel";
		} else if (fileExt.equalsIgnoreCase("HWP")) {
			exportFormat = "hwp";
			strContentType = "application/hwp";
		} else if (fileExt.equalsIgnoreCase("TIF")) {
			exportFormat = "tif";
			strContentType = "image/tiff";
		}else if (fileExt.equalsIgnoreCase("JPG")) {
			exportFormat = "jpg";
			strContentType = "image/jpg";
		}else if (fileExt.equalsIgnoreCase("GIF")) {
			exportFormat = "gif";
			strContentType = "image/gif";
		} else if (fileExt.equalsIgnoreCase("CSV")) {
			exportFormat = "csv";
			strContentType = "text/plain";
		} else if (fileExt.equalsIgnoreCase("TXT")) {
			exportFormat = "txt";
			strContentType = "text/plain";
			//			exportFormat = "txt";
			//strContentType = "application/oz";
		} else if (fileExt.equalsIgnoreCase("MHT")) {
			exportFormat = "mht";
			strContentType = "message/rfc822";
			strContentType = "text/html";
		} else {
			exportFormat = "txt";
			strContentType = "application/oz";
		}

		Enumeration keys = request.getParameterNames();
		while(keys.hasMoreElements()) {
			String key = (String)keys.nextElement();
			param.put(key, getParameter(request, key));
		}

		/////////////////////////////////// 변경되면 안되는 파라미터 ////////////////////////////////////
		String strClient = request.getHeader("user-agent");
		boolean isIEOld6 = false;
        if(strClient.indexOf("MSIE") != -1) {
			int msiePos = strClient.indexOf("MSIE ");
			String numberString = strClient.substring(msiePos + 5);
			int version = 0;
			if (numberString == null || numberString.length() == 0) {
			 	version=  -1;
			} else {
				int endOfNumbers = 0;
				while (Character.isDigit(numberString.charAt(endOfNumbers)))
				{
				    endOfNumbers++;
				}

				try
				{
					version=  Integer.parseInt(numberString.substring(0, endOfNumbers));
				}
				catch (NumberFormatException ex)
				{
					version = -1;
				}
			}

			if(version > 6) {
				isIEOld6 = false;
			} else {
				isIEOld6 = true;
			}
        }
        if(strClient.indexOf("MSIE 5.5") > -1)
        {
       	 strClient = "MSIE 5.5";
        }else if (strClient.indexOf("MSIE") >= 0)
        {
       	 strClient = "MSIE";
        }else
        {
       	 strClient = "";
        }

        String ie_image_url = request.getContextPath()+request.getServletPath()+"?ie_image_url="+Thread.currentThread().hashCode()+"_contains_img_";
        if(exportFormat.equalsIgnoreCase("HTML") || exportFormat.equalsIgnoreCase("MHT")){
       	 param.put("client_browser", strClient);
       	 param.put("ie_old_version", String.valueOf(isIEOld6));
            if(!fileDownType.equals("attachment") && strClient.indexOf("MSIE") > -1)
                param.put("ie_image_url", ie_image_url);
        }
		System.out.println("strClient="+strClient);
		//param.put("client_browser", strClient);
		param.put("export.format", exportFormat);
		param.put("export.path", exportResultPath);
		param.put("export.filename", fileName);
				
		param.put("pdf.fontembedding", "true");
		param.put("pdf.fontembedding_subset", "true");
		
		param.put("html.charset", "unicode"); // html 은 unicode
		param.put("tiff.savemultipage", "true");
		param.put("information.debug", "true");
	    ///////////////////////////////////////////////////////////////////////////////////////////

		request.setAttribute("OZViewerExportParam", param);
		String movePage = "/server"; // 오즈서버 주소
		//RequestDispatcher dispatcher = getServletContext().getRequestDispatcher(movePage);
		RequestDispatcher dispatcher = pageContext.getServletContext().getRequestDispatcher(movePage);

		dispatcher.include(request, response);
		boolean isSave = false;
		Object o = request.getAttribute("OZViewerExportResult");

		if (o == null) {
			// 서버에서 에러가 발생한 경우
			Throwable t = (Throwable) request.getAttribute("OZViewerExportError");
			if(t != null) {
				throw t;
			} else {

				throw new Exception("OZ Server do not return any Value. View OZ Server log.");
			}
		} else {
			Hashtable t = (Hashtable) o;
			
			Enumeration enumKeys = t.keys();
			while(enumKeys.hasMoreElements()){
				System.out.println("======================"+enumKeys.nextElement());
			}
			

				// 다른 포맷은 출력
				byte[] b = (byte[]) t.get(exportResultKey);
				if (b != null) {
					if(fileDownType.equalsIgnoreCase("inline")){
						response.setContentLength(b.length);
	
						response.setContentType(strContentType);
						fileName = java.net.URLEncoder.encode(fileName, "UTF-8");
						if (strClient.indexOf("MSIE 5.5") > -1) { // MS IE 5.5 이하
							response.setHeader("Content-Disposition", "filename=" + fileName + ";");
						} else if (strClient.indexOf("MSIE") > -1) { // MS IE (보통은 6.x 이상 가정)
							response.setHeader("Content-Disposition", fileDownType +"; filename=" + fileName + ";");
						} else { // 모질라나 오페라
							response.setHeader("Content-Disposition", fileDownType +"; filename=" + fileName + ";");
						}
						ServletOutputStream oout = response.getOutputStream();
						oout.write(b, 0, b.length);
						oout.close();
					}else{
						isSave = writefile(b, exportResultKey);
					}
				} else {
					throw new Exception("export file key is not exist -> " + exportResultKey);
				}

			if(!fileDownType.equalsIgnoreCase("inline")){
				response.setContentType("text/html");
				out.println("Result : " + isSave);
		        if (isSave)
		        {   
		            out.println("<br>Check : " + exportResultKey);
		        } 
			}
		}
	} catch (Throwable e) {
		StringWriter sw = new StringWriter();
		PrintWriter pw = new PrintWriter(sw);
		e.printStackTrace(pw);
		response.sendError(500, sw.getBuffer().toString());
	} finally {
	}
%>
