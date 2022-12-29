<%--
/*---------------------------------------------------------------------------
 Program ID   : downUploadFile.jsp
 Program name : DBMR upload file 다운로드
 Description  : 
 Programer    : 오정호
 Date created : 2018.06.21
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.net.*, com.shbank.orms.comm.util.*, java.util.Map.Entry" %>
<%@ page import="java.io.*,java.lang.*,java.sql.*,java.text.*, java.util.Date,java.util.*,java.net.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ page import="org.json.simple.*,java.net.*, org.apache.logging.log4j.Logger" %>
<%@ page import="java.util.Hashtable" %>
<%
	InputStream in		= null;
	OutputStream os		= null;
	File file			= null;
	boolean skip		= false;
	String client		= "";	
		
	ServletContext ctx = request.getSession(true).getServletContext();

	String file_nm = StringUtil.n2u(request.getParameter("file_nm"), "utf-8");
	System.out.println("down file_nm filename=" + file_nm);
	String sv_file_full_path = StringUtil.n2u(request.getParameter("sv_file_full_path"), "utf-8");
	System.out.println("save file full path=" + sv_file_full_path);

	try{
		String filePath = "";

		if(sv_file_full_path==null || sv_file_full_path == ""){
			String rootPath = ctx.getInitParameter("fileUploadPath");
			filePath = rootPath + File.separator + file_nm;
		}else{
			filePath = sv_file_full_path;
		}
		System.out.println("filePath=" + filePath);
		try{
			file				= new File(filePath);
			in					= new FileInputStream(file);
		}catch(FileNotFoundException fe){
			skip				= true;
		}

		//String file_nm_x = file_nm.replace(".","_") + ".dat"; 
		String file_nm_x = file_nm.replace(".","_") + ".dat"; 
		response.reset() ;
		client					= request.getHeader("User-Agent");
		//response.setContentType("application/x-msdownload;");
		response.setContentType("application/octet-stream;");
		response.setHeader("Content-Description", "JSP Generated Data");
		
		file_nm_x = URLEncoder.encode(file_nm_x,"UTF-8");

		if(!skip){
			if(client.indexOf("MSIE 5.5") != -1){
				response.setHeader("Content-Type", "doesn/matter; charset=utf-8");
				response.setHeader("Content-Disposition", "filename="+file_nm_x);
			}else{
				response.setHeader ("Content-Disposition", "attachment; filename="+file_nm_x);
			}

			response.setHeader ("Content-Length", ""+file.length() );

			//IllegalStateException
			out.clear();
			//IllegalStateException
			out=pageContext.pushBody();
			
			os					= response.getOutputStream();
			byte b[]			= new byte[(int)file.length()];
			int leng			= 0;

			while( (leng = in.read(b)) > 0 ){
				os.write(b,0,leng);
			}

		}else{
			response.setContentType("text/html;charset=utf-8");
			out.println("<script>alert('File Not Found')</script>");
			/***
			out.println("<script language='javascript'>");
			out.println("alert('선택하신 파일을 찾을 수 없습니다.\\n관리자에게 문의하세요.');");
			out.println("history.back();");
			out.println("</script>");
			****/
		}
	}catch(FileNotFoundException e) {
		System.out.println(e);
		response.setContentType("text/html;charset=utf-8");
		out.println("<script>alert('File Not Found')</script>");
	}catch(IOException e) {
		System.out.println(e);
		response.setContentType("text/html;charset=utf-8");
		out.println("<script>alert('File Not Found')</script>");
	}catch(Exception e) {
		System.out.println(e);
		response.setContentType("text/html;charset=utf-8");
		out.println("<script>alert('File Not Found')</script>");
	}finally {
		if(in!=null) in.close();
		if(os!=null) os.close();
	}

%>