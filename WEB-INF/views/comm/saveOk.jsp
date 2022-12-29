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
		
		Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit99", 0, "result");
		if(vLst==null){
			int count= CommUtil.getCount(request, "grp01", 0, "unit99", 0, "count");
			System.out.println("count:" + count);
			if( count == -1){
				count = ConvertUtil.s2I((String)request.getAttribute("count"));
			}else{
				rtnCode = "S";
			}
			str_count = ""+count;
		}else{
			if(vLst.size()>0){
				HashMap hp = (HashMap)vLst.get(0);
				String res_flag = (String)hp.get("res_flag");
				hpn_tpc = (String)hp.get("hpn_tpc");
				res_msg = (String)hp.get("msg");
				str_count = (String)hp.get("count");
				if(res_flag!=null) rtnCode = res_flag;
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
			jsonObj.put("rtnMsg", "중복 데이터 입니다.");
			jsonObj1.put("Code", "-7");
			jsonObj1.put("Message", "중복 데이터 입니다.");
		}
		else if(rtnCode.equals("N")){
			jsonObj.put("rtnMsg", "데이터가 없습니다.");
			jsonObj1.put("Code", "-8");
			jsonObj1.put("Message", "데이터가 없습니다.");
		}
		else if(rtnCode.equals("F")){
			System.out.println("msg:" + res_msg);
			jsonObj.put("rtnMsg", "저장 처리중 에러가 발생했습니다.(Database Error)");
			jsonObj1.put("Code", "-9");
			jsonObj1.put("Message", "저장 처리중 에러가 발생했습니다.(Database Error)");
		}else if(rtnCode.equals("X")){
			jsonObj.put("rtnMsg", res_msg);
			jsonObj1.put("Code", "-11");
			jsonObj1.put("Message", res_msg);
		}else{
			jsonObj.put("rtnMsg", "처리중 에러가 발생했습니다.(System Error)");
			jsonObj1.put("Code", "-10");
			jsonObj1.put("Message", "처리중 에러가 발생했습니다.(System Error)");
		}
		jsonObj.put("count", str_count);
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
