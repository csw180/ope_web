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
		String str_count = "";
		String rtnCode = "X";
		String res_msg = "";
		String hpn_tpc = "";
		
		Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "result");
		if(vLst==null){
			
			int count1= CommUtil.getCount(request, "grp01", 0, "unit01", 0, "schd_cnt");
			int count2= CommUtil.getCount(request, "grp01", 0, "unit02", 0, "count");
			
			System.out.println("count:" + count1);
			if( count1 > 0){
				rtnCode = "D";
			}else{
				if(count2 < 1){
					rtnCode = "F";
				}else{
					rtnCode = "S";
				}
			}
		}
		
		System.out.println("rtnCode:" + rtnCode);
		//System.out.println("hpn_tpc:" + hpn_tpc);
		jsonObj.put("rtnCode", rtnCode);
		JSONObject jsonObj1 = new JSONObject();
		if(rtnCode.equals("S")){
			jsonObj.put("rtnMsg", "처리되었습니다.");
			jsonObj1.put("Code", "1");
			jsonObj1.put("Message", "처리되었습니다.");
		}
		else if(rtnCode.equals("D")){
			jsonObj.put("rtnMsg", "이미 등록된 평가년월 입니다.");
			jsonObj1.put("Code", "-7");
			jsonObj1.put("Message", "이미 등록된 평가년월 입니다.");
		}
		else if(rtnCode.equals("F")){
			System.out.println("msg:" + res_msg);
			jsonObj.put("rtnMsg", "처리중 에러가 발생했습니다.(Database Error)");
			jsonObj1.put("Code", "-9");
			jsonObj1.put("Message", "처리중 에러가 발생했습니다.(Database Error)");
		}else{
			jsonObj.put("rtnMsg", "처리중 에러가 발생했습니다.(System Error)");
			jsonObj1.put("Code", "-10");
			jsonObj1.put("Message", "처리중 에러가 발생했습니다.(System Error)");
		}
		jsonObj.put("Result", jsonObj1);
		
	}catch(NullPointerException e) {
		e.printStackTrace();
		jsonObj.put("rtnCode", "2");
		jsonObj.put("rtnMsg", "처리중 에러가 발생했습니다.(System Error)");
	} catch(Exception e) {
		e.printStackTrace();
		jsonObj.put("rtnCode", "2");
		jsonObj.put("rtnMsg", "처리중 에러가 발생했습니다.(System Error)");
	}
	
	out.println(jsonObj);
%>
