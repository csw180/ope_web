<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.net.*, com.shbank.orms.comm.util.*, java.util.Map.Entry" %>
<%@ page import="org.json.simple.*,java.net.*, org.apache.logging.log4j.*" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
	
	Logger logger = LogManager.getLogger(this.getClass().getName());
	
	String get_date = (String)request.getAttribute("get_date");
	String file_nm = (String)request.getAttribute("file_nm");
	String sv_file_full_path = (String)request.getAttribute("sv_file_full_path");

	JSONObject jsonObj = new JSONObject();
	
	try {
		jsonObj.put("rtnCode", "0");
		jsonObj.put("rtnMsg", "");
		jsonObj.put("get_date", get_date);
		jsonObj.put("file_nm", file_nm);
		jsonObj.put("sv_file_full_path", sv_file_full_path);
		
	} catch(Exception e) {
		jsonObj.put("rtnCode", "-2");
		jsonObj.put("rtnMsg", e.getMessage());
	} catch(Error e) {
		jsonObj.put("rtnCode", "-2");
		jsonObj.put("rtnMsg", e.getMessage());
	}
	
	out.println(jsonObj);
%>
