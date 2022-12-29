<%@ page language="java" contentType="application/json; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*,java.net.*, com.shbank.orms.comm.util.*, java.util.Map.Entry" %>
<%@ page import="org.json.simple.*,java.net.*, org.apache.logging.log4j.*" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
	
	Logger logger = LogManager.getLogger(this.getClass().getName());
	String json = "";
	try {
		Vector vCtlTpcLst= CommUtil.getResultVector(request, "grp01", 0, "unit99", 0, "vList");
		if(vCtlTpcLst==null){
			vCtlTpcLst = new Vector();
		}
		
		String rk_ctl_tpc = "";
		String ctl_nm = "";
		String ctl_cntn = "";
		String eng_ctl_nm = "";
		String eng_ctl_cntn = "";
		String mer_ctl_nm = "";
		String mer_ctl_cntn = "";
		for(int i=0;i<vCtlTpcLst.size();i++){
			HashMap hp = (HashMap)vCtlTpcLst.get(i);
			if(rk_ctl_tpc==""){
				rk_ctl_tpc += (String)hp.get("rk_ctl_tpc");
				ctl_nm += (String)hp.get("ctl_nm");
				ctl_cntn += (String)hp.get("ctl_cntn");
				eng_ctl_nm += (String)hp.get("eng_ctl_nm");
				eng_ctl_cntn += (String)hp.get("eng_ctl_cntn");
				mer_ctl_nm += (String)hp.get("mer_ctl_nm");
				mer_ctl_cntn += (String)hp.get("mer_ctl_cntn");
			}else{
				rk_ctl_tpc += ("|" + (String)hp.get("rk_ctl_tpc"));
				ctl_nm += ("|" + (String)hp.get("ctl_nm"));
				ctl_cntn += ("|" + (String)hp.get("ctl_cntn"));
				eng_ctl_nm += ("|" + (String)hp.get("eng_ctl_nm"));
				eng_ctl_cntn += ("|" + (String)hp.get("eng_ctl_cntn"));
				mer_ctl_nm += ("|" + (String)hp.get("mer_ctl_nm"));
				mer_ctl_cntn += ("|" + (String)hp.get("mer_ctl_cntn"));
			}
		}
		json = "{\"ComboText\":\"" + ctl_nm + "\",\"ComboCode\":\"" + rk_ctl_tpc + "\",\"ComboCntn\":\"" + ctl_cntn + 
			"\",\"ComboEngCntn\":\"" + eng_ctl_cntn + "\",\"ComboEngText\":\"" + eng_ctl_nm + "\",\"ComboMerCntn\":\"" + mer_ctl_cntn + 
			"\",\"ComboMerText\":\"" + mer_ctl_nm + "\"}";
		System.out.println("json:"+json);
		
	} catch(NullPointerException e) {
		e.printStackTrace();
		json = "";
	} catch(Exception e) {
		e.printStackTrace();
		json = "";
	}
%><%= json%>	
