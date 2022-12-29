<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.net.*, com.shbank.orms.comm.util.*, java.util.Map.Entry" %>
<%@ page import="org.json.simple.*,java.net.*, org.apache.logging.log4j.*" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
	
	Logger logger = LogManager.getLogger(this.getClass().getName());
	
	String bas_ym = (String)request.getAttribute("bas_ym");
	String file_name = (String)request.getAttribute("file_name");
	String msg = (String)request.getAttribute("msg");
	String c_flag = (String)request.getAttribute("c_flag");

	JSONObject jsonObj = new JSONObject();
	
	try {
		jsonObj.put("rtnCode", c_flag);
		jsonObj.put("rtnMsg", msg);
		jsonObj.put("bas_ym", bas_ym);
		jsonObj.put("file_name", file_name);
		
	}catch(NullPointerException e) {
		e.printStackTrace();
		jsonObj.put("rtnCode", "-2");
		jsonObj.put("rtnMsg", e.getMessage());
	} catch(Exception e) {
		e.printStackTrace();
		jsonObj.put("rtnCode", "-2");
		jsonObj.put("rtnMsg", e.getMessage());
	}
	
	out.println(jsonObj);
%>
