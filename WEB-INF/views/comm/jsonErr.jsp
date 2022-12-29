<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.net.*, com.shbank.orms.comm.util.*, java.util.Map.Entry" %>
<%@ page import="org.json.simple.*,java.net.*, org.apache.logging.log4j.*" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
	
	Logger logger = LogManager.getLogger(this.getClass().getName());
	
	JSONObject jsonObj = new JSONObject();
	jsonObj.put("rtnCode", "1");
	
	String sMessage = (String)request.getAttribute("sMessage");
	if(sMessage==null || sMessage.equals("")){
		jsonObj.put("rtnMsg", "처리중 이상이 발생했습니다.");
	}else{		
		jsonObj.put("rtnMsg", StringUtil.htmlEscape(sMessage));
	}
	
	System.out.println("json String ==== " + jsonObj.toString());
	out.println(jsonObj);
%>
