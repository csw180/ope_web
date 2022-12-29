<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.net.*, com.shbank.orms.comm.util.*, java.util.Map.Entry" %>
<%@ page import="org.json.simple.*,java.net.*, org.apache.logging.log4j.*" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
	
	Logger logger = LogManager.getLogger(this.getClass().getName());
	
	String msg = (String)request.getAttribute("sMessage");
	System.out.println("Data NG : message="+msg);

	JSONObject jsonObj = new JSONObject();
	jsonObj.put("rtnCode", "-1");
	jsonObj.put("rtnMsg", msg);
	
	out.println(jsonObj);
%>
