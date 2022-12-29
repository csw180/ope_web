<!-- **************************************************************************************************
Operational Risk Management System : Copyright ⓒ A&Z Soft Corp. All Rights Reserved.
***************************************************************************************************	-->
<%@ page language = "java" contentType = "text/html; charset=utf-8" %>
<%@ page import="java.util.*,java.net.*, com.shbank.orms.comm.util.*, java.util.Map.Entry" %>
<%@ page import="org.json.simple.*,java.net.*, org.apache.logging.log4j.*" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");

	Logger logger = LogManager.getLogger(this.getClass().getName());
	
	logger.info("anzLstH vLst ==== start");
	Vector vLst= CommUtil.getFirstResultVector(request);
	if(vLst==null){
		vLst=(Vector)request.getAttribute("vList");
	}

	if(vLst==null){
		vLst = (Vector)request.getAttribute("vList");
		if(vLst == null) vLst = new Vector();
	}
	
%>
	
	<lists>
<%
	String value = "";
	String key = "";

	String chg_key = "_rt_nv";
	int chg_key_len = chg_key.length();
	int key_len = 0;

	for(int i=0;i<vLst.size();i++){
		HashMap hMap = (HashMap)vLst.get(i);
%>
		<list>
		<%
			Set set = hMap.entrySet();
			Iterator iterator = set.iterator();

			while (iterator.hasNext()){
				Entry entry = (Entry)iterator.next();

				value = (entry.getValue()).toString();
				key = entry.getKey().toString();
				
				key_len = key.length();
				
				if(chg_key_len<key_len){
					if(chg_key.equals(key.substring(key_len-chg_key_len))){
						value = ConvertUtil.toD2(value);
					}
				}
				

				value = StringUtil.replace(value,">","&gt;");
				value = StringUtil.replace(value,"<","&lt;");
				value = StringUtil.replace(value,"&","&amp;");
		%>
			<<%=key%>><%=value.trim()%></<%=key%>>

		<%
			} %>
		</list>
<%
	}
	System.out.println("anzLstH vLst ==== end" );
%>
	</lists>