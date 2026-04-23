<%@page contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@page import="java.nio.charset.StandardCharsets" %>

<%
  request.setCharacterEncoding("UTF-8");

  String ozServerUrl = request.getParameter("ozServerUrl").replace("\"", "\\\"");

  java.net.URL url = new java.net.URL(ozServerUrl);
  String domain = url.getHost();

  String oz_file = java.net.URLDecoder.decode(request.getParameter("oz_file"), StandardCharsets.UTF_8).replace("\"", "\\\"");
  String odi =request.getParameter("odi").replace("\"", "\\\"");
  String oz_unit = "som";
  String strParam = request.getParameter("param");
  //String ozdata = java.net.URLDecoder.decode(request.getParameter("ozdata"), StandardCharsets.UTF_8);
  String ozdata = java.net.URLDecoder.decode(request.getParameter("ozdata"), StandardCharsets.UTF_8).replace("\"", "\\\"");
  System.out.println("ozdata -=================>"+ozdata);
  String view_zoom = request.getParameter("view_zoom");
  if ("".equals(view_zoom) || view_zoom == null) {
    view_zoom = "120";
  }
  String oz_server = java.net.URLDecoder.decode(request.getParameter("oz_server"), StandardCharsets.UTF_8).replace("\"", "\\\"");
  String ozViewer = "viewer";

  String[] args = null;
  if (strParam != null && !strParam.isEmpty()) {
    strParam = java.net.URLDecoder.decode(strParam, StandardCharsets.UTF_8).replace("\"", "\\\"");
    args = strParam.split("▩");
  } else {
    args = new String[0];
  }

  // Finance - 지급예정용 pdf 파일이름
  String fileName = request.getParameter("file_nm").replace("\"", "\\\"");

  System.out.println("view_zoom =====> " + view_zoom);
%>
<!DOCTYPE html>
<html style="height: 100%">
  <head>
    <title>오즈 리포트</title>
    <style>
      body {
        overflow: hidden;
        margin: 0;
        border: 0;
      }
    </style>
    <meta http-equiv="X-UA-Compatible" content="IE=edge" />
    <meta charset="UTF-8" />

    <script>
      document.domain = "<%=domain%>";
    </script>

    <script src="./<%=ozViewer%>/jquery-2.0.3.min.js"></script>
    <script src="./<%=ozViewer%>/jquery-ui.min.js"></script>
    <script
      type="text/javascript"
      src="./<%=ozViewer%>/jquery.dynatree.js"
      charset="utf-8"
    ></script>
    <script
      type="text/javascript"
      src="./<%=ozViewer%>/OZJSViewer.js"
      charset="utf-8"
    ></script>
    <link
      rel="stylesheet"
      href="./<%=ozViewer%>/jquery-ui.css"
      type="text/css"
    />
    <link
      rel="stylesheet"
      href="./<%=ozViewer%>/ui.dynatree.css"
      type="text/css"
    />
  </head>
  <body style="width: 100%; height: 100%">
    <div id="OZViewer" style="width: 100%; height: 100%"></div>
    <script type="text/javascript">
      let oz;
      function SetOZParamters_OZViewer() {
      	oz = document.getElementById("OZViewer");

        <%
        if (fileName != null) {
        %>
          oz.sendToActionScript("export.mode", "silent");
          oz.sendToActionScript("export.format", "pdf");
          oz.sendToActionScript("export.filename", "<%=fileName%>");
          
          oz.sendToActionScript("viewer.progresscommand", "true");
        <%
        }
        %>

        oz.sendToActionScript("connection.servlet","https://<%=oz_server%>/oz/server");
        oz.sendToActionScript("global.timezone", "Asia/Seoul");
        oz.sendToActionScript("viewer.zoom","<%=view_zoom%>");
        oz.sendToActionScript("connection.datafromserver", "false");
        oz.sendToActionScript("connection.formfromserver", "true");
        oz.sendToActionScript("viewer.isframe", "false");
        //oz.sendToActionScript("viewer.viewmode", "fittowidth");
        oz.sendToActionScript("information.debug", "true");
        oz.sendToActionScript("print.adjust", "true");
        oz.sendToActionScript("global.inheritparameter", "true");
        oz.sendToActionScript("toolbar.first", "true");
        oz.sendToActionScript("toolbar.last", "true");
        oz.sendToActionScript("export.applyformat", "pdf, xls, xlsx, doc, ppt, hwp, html, hml, txt, csv, tif, jpg, png, gif");
        oz.sendToActionScript("connection.reportname", "/<%=oz_unit%>/<%=oz_file%>.ozr");
        oz.sendToActionScript("odi.odinames", "<%=odi%>");
        oz.sendToActionScript("odi.<%=odi%>.usescheduleddata", "<%=ozServerUrl%>/oz/viewer/OzSdmMaker.js");
        oz.sendToActionScript("odi.<%=odi%>.usebareserver", "false");
        oz.sendToActionScript("odi.<%=odi%>.pcount"	,"6");
        oz.sendToActionScript("odi.<%=odi%>.args1", "ozdata=<%=ozdata%>");
        oz.sendToActionScript("odi.<%=odi%>.args2", "D_dataset=//DSEOR//");
        oz.sendToActionScript("odi.<%=odi%>.args3", "D_row=//OZRecord//");
        oz.sendToActionScript("odi.<%=odi%>.args4", "D_column=￠");
        oz.sendToActionScript("odi.<%=odi%>.args5", "D_Master=//EOR//");
        oz.sendToActionScript("odi.<%=odi%>.args6", "odiname=ozp:///<%=oz_unit%>/<%=oz_file%>.odi");
        oz.sendToActionScript("odi.<%=odi%>.clientdmtype", "FILE");
        oz.sendToActionScript("odi.<%=odi%>.fetchtype", "concurrent");
        oz.sendToActionScript("connection.pcount", "<%=args.length%>");

        <%
        int i = 0;
        while (i < args.length) {
        %>
        oz.sendToActionScript("connection.args<%=i+1%>", "<%=args[i]%>");
        <%
          i++;
        }
        %>

      	return true;
      }

      start_ozjs("OZViewer","./<%=ozViewer%>/");
    </script>
  </body>
</html>