<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.net.*, com.shbank.orms.comm.util.*, java.util.Map.Entry" %>
<%@ page import="org.json.simple.*,java.net.*, org.apache.logging.log4j.*" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
	
	Logger logger = LogManager.getLogger(this.getClass().getName());
	
	JSONObject jsonObj = new JSONObject();
	JSONArray jsonlist = new JSONArray();
	
	HashMap<String, String> hMap = new HashMap<String, String>();
	
	try {
		String sRtnMsg = "";
		Vector vLst= (Vector)request.getAttribute("grpList");
		
		if(vLst == null) vLst = new Vector();
		System.out.println("orggrpLst vLst size ==== " + vLst.size());
		//System.out.println("jsonLst return msg ==== " + sRtnMsg);
		
		for(int i=0; i<vLst.size(); i++){
			hMap = (HashMap)vLst.get(i);
			jsonlist.add(hMap);
		}
		
		jsonObj.put("DATA", jsonlist);
		jsonObj.put("rtnCode", "0");
		jsonObj.put("rtnMsg", sRtnMsg);
		
		
	}catch(NullPointerException e) {
		e.printStackTrace();
		jsonObj.put("rtnCode", "1");
		jsonObj.put("rtnMsg", e);
	} catch(Exception e) {
		e.printStackTrace();
		jsonObj.put("rtnCode", "1");
		jsonObj.put("rtnMsg", e);
	}
	
	//System.out.println("json String ==== " + jsonObj.toString());
	out.println(jsonObj);
%>
