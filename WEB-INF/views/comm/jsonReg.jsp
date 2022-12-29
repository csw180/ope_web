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
		String rtnCode = (String)request.getAttribute("rtnCode");	
		String msg = (String)request.getAttribute("msg");
		
		jsonObj.put("rtnCode", rtnCode);
		jsonObj.put("rtnMsg", msg);
		
	}catch(NullPointerException e) {
		e.printStackTrace();
		jsonObj.put("rtnCode", "2");
		jsonObj.put("rtnMsg", e);
	} catch(Exception e) {
		e.printStackTrace();
		jsonObj.put("rtnCode", "2");
		jsonObj.put("rtnMsg", e);
	}
	
	out.println(jsonObj);
%>
