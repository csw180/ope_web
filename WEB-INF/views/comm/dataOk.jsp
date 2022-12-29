<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.net.*, com.shbank.orms.comm.util.*, java.util.Map.Entry" %>
<%@ page import="org.json.simple.*,java.net.*, org.apache.logging.log4j.*" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
	
	System.out.println("OK----->save");
	Logger logger = LogManager.getLogger(this.getClass().getName());
	JSONObject jsonObj = new JSONObject();
	try {

		jsonObj.put("rtnCode", "0");
		
	}catch(NullPointerException e) {
		e.printStackTrace();
		jsonObj.put("rtnCode", "1");
		jsonObj.put("rtnMsg", e);
	} catch(Exception e) {
		e.printStackTrace();
		jsonObj.put("rtnCode", "1");
		jsonObj.put("rtnMsg", e);
	}
	
	out.println(jsonObj);
%>
