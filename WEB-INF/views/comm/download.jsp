<%--
/*---------------------------------------------------------------------------
 Program ID   : download.jsp
 Program name : 공통파일다운로드
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

	DynaForm form = (DynaForm)request.getAttribute("form");
	String stor_fil_nm = form.get("stor_fil_nm");
//	String mrk_fil_nm = StringUtil.n2u(form.get("mrk_fil_nm"), "ksc5601");
	String mrk_fil_nm = StringUtil.n2u(form.get("mrk_fil_nm"), "utf-8");
	System.out.println("down stor_fil_nm filename=" + stor_fil_nm);
	System.out.println("down mrk_fil_nm filename=" + mrk_fil_nm);
	String file_dscd = form.get("file_dscd");

	System.out.println(file_dscd);

	try{
		String rootPath = ctx.getInitParameter("fileUploadPath");
		String filePath = "";
		
		if(file_dscd.equals("99")) {
			filePath = rootPath + File.separator + "doc" + File.separator + stor_fil_nm;
		} else if(file_dscd.equals("98")) {
			String pub_dscd = form.get("pub_dscd");
			filePath = rootPath + File.separator + "pub" + File.separator + pub_dscd + File.separator + stor_fil_nm;
		} else if(file_dscd.equals("97")) {
			String pub_dscd = form.get("pub_dscd");
			filePath = rootPath + File.separator + "mmrt" + File.separator + stor_fil_nm;
		} else {
			filePath = rootPath + File.separator + "file" + File.separator + file_dscd + File.separator + stor_fil_nm;
		}
		
		System.out.println(filePath);
		try{
			file				= new File(filePath);
			in					= new FileInputStream(file);
		}catch(FileNotFoundException fe){
			skip				= true;
		}
		mrk_fil_nm = mrk_fil_nm.substring(mrk_fil_nm.lastIndexOf("/") + 1);
		mrk_fil_nm = ConvertUtil.k2E(mrk_fil_nm); 

		response.reset() ;
		client					= request.getHeader("User-Agent");
		response.setContentType("application/x-msdownload;");
		response.setHeader("Content-Description", "JSP Generated Data");

		if(!skip){
			if(client.indexOf("MSIE 5.5") != -1){
				response.setHeader("Content-Type", "doesn/matter; charset=euc-kr");
				response.setHeader("Content-Disposition", "filename="+mrk_fil_nm);
			}else{
				response.setHeader ("Content-Disposition", "attachment; filename="+mrk_fil_nm);
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
			response.setContentType("text/html;charset=euc-kr");
			out.println("<script>alert('File Not Found')</script>");
			/***
			out.println("<script language='javascript'>");
			out.println("alert('선택하신 파일을 찾을 수 없습니다.\\n관리자에게 문의하세요.');");
			out.println("history.back();");
			out.println("</script>");
			****/
		}
	}catch(NullPointerException e) {
		e.printStackTrace();
		response.setContentType("text/html;charset=euc-kr");
		out.println("<script>alert('File Not Found')</script>");
	}catch(Exception e) {
		//System.out.println(e);
		e.printStackTrace();
		response.setContentType("text/html;charset=euc-kr");
		out.println("<script>alert('File Not Found')</script>");
	}finally {
		if(in!=null) in.close();
		if(os!=null) os.close();
	}

%>