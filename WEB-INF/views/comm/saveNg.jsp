<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.net.*, com.shbank.orms.comm.util.*, java.util.Map.Entry" %>
<%@ page import="org.json.simple.*,java.net.*, org.apache.logging.log4j.*" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
	
	Logger logger = LogManager.getLogger(this.getClass().getName());
	
	JSONObject jsonObj = new JSONObject();
	jsonObj.put("rtnCode", "E");
	jsonObj.put("rtnMsg", "처리중 에러가 발생했습니다.(System Error)");
	//jsonObj.put("rtnMsg", "System Error");
	
	out.println(jsonObj);
%>
