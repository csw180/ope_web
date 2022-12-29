<%@page import="org.springframework.http.HttpHeaders"%>
<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.net.*, com.shbank.orms.comm.util.*, java.util.Map.Entry" %>
<%@ page import="org.json.simple.*,java.net.*, org.apache.logging.log4j.*" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
	
	Logger logger = LogManager.getLogger(this.getClass().getName());
	JSONObject jsonObj = new JSONObject();
	try {

		jsonObj.put("message", (String)request.getAttribute("message"));
//		jsonObj.put("imsi_pass_yn", (String)request.getAttribute("imsi_pass_yn"));
	} catch(NullPointerException e) {
		e.printStackTrace();
		jsonObj.put("message", e.getMessage());
	} catch(Exception e) {
		e.printStackTrace();
		jsonObj.put("message", e.getMessage());
//		jsonObj.put("imsi_pass_yn", "");
	}
	
	out.println(jsonObj);
		
		
%>
