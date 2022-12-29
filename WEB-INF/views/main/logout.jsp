<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.net.*, com.shbank.orms.comm.util.*, java.util.Map.Entry" %>
<%@ page import="org.json.simple.*,java.net.*, org.apache.logging.log4j.Logger" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
	request.getSession(true).setAttribute("infoH", null );
	request.getSession(true).setAttribute("grp_org_c", null );
	request.getSession(true).setAttribute("login_type", null );
	request.getSession(true).setAttribute("ip_addr", null );
	request.getSession(true).setAttribute("userid", null );
	request.getSession(true).setAttribute("puser", null );
	//System.out.println("Logout:");
	JSONObject jsonObj = new JSONObject();
	try {

		jsonObj.put("rtnCode", "0");
		
	}catch(NullPointerException e) {
		e.printStackTrace();
		jsonObj.put("rtnCode", "1");
	} catch(Exception e) {
		e.printStackTrace();
		jsonObj.put("rtnCode", "1");
	}
	
	out.println(jsonObj);
%>

