<%--
/*---------------------------------------------------------------------------
 Program ID   : comUtil.jsp
 Program name : 공통 유틸
 Description  : 
 Programer    : N.a.N
 Date created : 2021.04.29
 ---------------------------------------------------------------------------*/
--%>
<!-- Program ID   : comUtil.jsp -->
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%
	response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");

	HashMap hs = (HashMap)request.getSession(true).getAttribute("infoH");
	String grp_org_c = "", grp_orgnm = "", userid = "", brnm = "", pzcnm = "", empnm = "", brc = "",adm_yn = "";
	String hofc_bizo_dsc="", orgz_cfc="";
	String sys_uyn = "", msr_obj_yn = "", maj_aflco_yn = "", stp_dsc = "";

	String no1_hcnt="",no2_hcnt="",no3_hcnt="",no4_hcnt="",no5_hcnt="",no6_hcnt="",no7_hcnt="",no8_hcnt="",no9_hcnt="",no10_hcnt="";
	if (hs != null) {
		grp_org_c = (String)hs.get("grp_org_c");
		grp_orgnm = (String)hs.get("grp_orgnm");
		userid = (String)hs.get("userid");
		brc = (String)hs.get("partcode");
		brnm = (String)hs.get("brnm");
		pzcnm = (String)hs.get("pzcnm");
		empnm = (String)hs.get("chrg_empnm");
		
		adm_yn = (String)hs.get("adm_yn");
		hofc_bizo_dsc = (String)hs.get("hofc_bizo_dsc");
		orgz_cfc = (String)hs.get("orgz_cfc");
		
		sys_uyn = (String)hs.get("sys_uyn");                 
		msr_obj_yn = (String)hs.get("msr_obj_yn");          
		maj_aflco_yn = (String)hs.get("maj_aflco_yn");       
		stp_dsc = (String)hs.get("stp_dsc");                

		
		no1_hcnt = (String)hs.get("no1_hcnt");
		no2_hcnt = (String)hs.get("no2_hcnt");
		no3_hcnt = (String)hs.get("no3_hcnt");
		no4_hcnt = (String)hs.get("no4_hcnt");
		no5_hcnt = (String)hs.get("no5_hcnt");
		no6_hcnt = (String)hs.get("no6_hcnt");
		no7_hcnt = (String)hs.get("no7_hcnt");
		no8_hcnt = (String)hs.get("no8_hcnt");
		no9_hcnt = (String)hs.get("no9_hcnt");
		no10_hcnt = (String)hs.get("no10_hcnt");
	}
	
	Vector vGrpList = (Vector)request.getSession(true).getAttribute( "vGrpList");			
	Vector vAllGrpList = (Vector)request.getSession(true).getAttribute( "vAllGrpList");		
	Vector vT2GrpList = (Vector)request.getSession(true).getAttribute( "vT2GrpList");		
	Vector vT2GGrpList = (Vector)request.getSession(true).getAttribute( "vT2GGrpList");		
	
	String pageName = request.getServletPath();
	int pageNameIndex = pageName.lastIndexOf("/");
	pageName = (pageName.substring(pageNameIndex+1, pageName.length())).replace(".jsp", "");
%>