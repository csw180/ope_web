<%--
/*---------------------------------------------------------------------------
 Program ID   : excelfile.jsp
 Program name : 엑셀파일다운로드
 Description  : 
 Programer    : 이상봉
 Date created : 2021.04.29
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.net.*, com.shbank.orms.comm.util.*, java.util.Map.Entry" %>
<%@ page import="java.io.*,java.lang.*, javax.servlet.*, javax.servlet.http.*, org.apache.logging.log4j.*" %>
<%
	InputStream in		= null;
	OutputStream os		= null;
	try{
		File file			= null;
		boolean skip		= false;
		String client		= "";	
		Logger logger = LogManager.getLogger(this.getClass().getName());
		ServletContext ctx = request.getSession(true).getServletContext();
		String servergubun = ctx.getInitParameter("servergubun");
	
		DynaForm form = (DynaForm)request.getAttribute("form");
		String filename = form.get("filename");
		String kor_filename = form.get("kor_filename");
		kor_filename =URLEncoder.encode(kor_filename, "UTF-8");
		System.out.println("down filename=" + filename);
		logger.info("down filename2=" + kor_filename);
		
		logger.info("test");
		String rootPath = ctx.getInitParameter("fileUploadPath");
		String filePath = "";
		
		//filePath = rootPath + File.separator + "help" + File.separator + filename + ".xlsx";
		filePath = rootPath + File.separator + filename + ".xlsx";

		System.out.println(filePath);
		try{
			file				= new File(filePath);
			in					= new FileInputStream(file);
		}catch(FileNotFoundException fe){
			skip				= true;
		}
		response.reset() ;
		client					= request.getHeader("User-Agent");
		response.setContentType("application/x-msdownload;");
		response.setHeader("Content-Description", "JSP Generated Data");
		if(!skip){
			if(client.indexOf("MSIE 5.5") != -1){
				response.setHeader("Content-Type", "doesn/matter; charset=euc-kr");
				response.setHeader("Content-Disposition", "filename="+kor_filename + ".xlsx");
			}else{
				if("2".equals(servergubun)){
					response.setHeader("Content-Disposition", "filename="+kor_filename + ".xlsx");
				}else{
					
					response.setHeader ("Content-Disposition", "attachment; filename="+new String(kor_filename.getBytes("euc-kr"),"ISO-8859-1") + ".xlsx");
				}
				
			}

			response.setHeader ("Content-Length", ""+file.length() );

			out.clear();
			out=pageContext.pushBody();
			
			os					= response.getOutputStream();
			byte b[]			= new byte[(int)file.length()];
			int leng			= 0;

			while( (leng = in.read(b)) > 0 ){
				os.write(b,0,leng);
			}

		}else{
			response.setContentType("text/html;charset=euc-kr");
			out.println("<script>alert('File Not Found')</script>");
		}
	}catch(NullPointerException e) {
		e.printStackTrace();
		response.setContentType("text/html;charset=euc-kr");
		out.println("<script>alert('File Not Found')</script>");
	}catch(Exception e) {
		e.printStackTrace();
		response.setContentType("text/html;charset=euc-kr");
		out.println("<script>alert('File Not Found')</script>");
	}finally {
		try{
			if(in!=null) in.close();
			if(os!=null) os.close();
		}catch(IOException e){
			e.printStackTrace();
		}catch(Exception e){
			e.printStackTrace();
		}
	}

%>