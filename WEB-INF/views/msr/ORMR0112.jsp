<%--
/*---------------------------------------------------------------------------
 Program ID   : ORMR0112.jsp
 Program name : 내부자본한도설정
 Description  : MSR-15
 Programer    : 이규탁
 Date created : 2022.08.05
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
//Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
		/*Sheet1(권한) 기본 설정 */
		$(document).ready(function(){
			$("#sch_bas_yy").change(function() {
				var f = document.ormsForm;
				WP.clearParameters();
				WP.setParameter("method", "Main");
				WP.setParameter("commkind", "msr");
				WP.setParameter("process_id", "ORMR011212");
				WP.setForm(f);
				
				var inputData = WP.getParams();
				showLoadingWs(); // 프로그래스바 활성화
				
				WP.load(url, inputData,{
					success: function(result){
						var rList = result.DATA;
						var saveyn="";
						var rzt_yn="";
						if(result!='undefined' && result.rtnCode=="0") {
							for(var i=0;i<rList.length;i++){
								if($("#sch_bas_yy").val() == rList[i].bas_yy){
									saveyn=rList[i].save_yn;
									rzt_yn=rList[i].rzt_yn;
								}
							}
							if(saveyn == 'Y'){
								$("#new_load_yn").prop("checked",false);
								$("#new_load_yn").attr("disabled",false);
							}else{
								$("#new_load_yn").prop("checked",true);
								$("#new_load_yn").attr("disabled",true);
							}
							if(rzt_yn =='Y'){
								$("#conf_btn").css("display","none");
								$("#save_btn").css("display","none");
								$("#buffer_btn").css("display","none");
								$("bic_buffer_sh").attr('disabled',true);
								$("bic_buffer_shm").attr('disabled',true);
							}else{
								$("#conf_btn").css("display","inline");
								$("#save_btn").css("display","inline");
								$("#buffer_btn").css("display","inline");
							}
							/* $("#sch_bas_yy").html(html);
							$("#sch_bas_yy").trigger("change"); */
						}else if(result!='undefined' && result.rtnCode!="0"){
							alert(result.rtnMsg);
						}
					},
					  
					complete: function(statusText,status) {
						removeLoadingWs();
					},
					  
					error: function(rtnMsg){
						alert(JSON.stringify(rtnMsg));
					}
				});
				if($("#sch_bas_yy option:selected").data("saveyn")=="Y"){
					$("#new_load_yn").prop("checked",false);
					$("#new_load_yn").attr("disabled",false);
				}else{
					$("#new_load_yn").prop("checked",true);
					$("#new_load_yn").attr("disabled",true);
				}
				if($("#sch_bas_yy").val()!="") $("#search_btn").trigger("click");
			});
		});
		
		$(function () {
			initIBSheet1();
			initIBSheet2();
			initIBSheet3();
			initIBSheet4();
			initIBSheet5();
		});

		// mySheet1
		function initIBSheet1() {
			var initdata = {};
			initdata.Cfg = { MergeSheet: msAll };
			initdata.Cols = [
				{ Header: "기준|기준|기준",						Type: "Text",	SaveName: "base",	Align: "Center",	Width: 10,	MinWidth: 60, Edit:false, ColMerge:0},
				{ Header: "구분|구분|구분",						Type: "Text",	SaveName: "gubun",	Align: "Center",	Width: 10,	MinWidth: 60, Edit:false, ColMerge:0 },
				{ Header: "CASE|CASE|CASE",						Type: "Text",	SaveName: "coic_case_dsc",	Align: "Center",	Width: 10,	MinWidth: 60, Edit:false, ColMerge:0 ,Hidden:1},
				{ Header: "은행|4Q 추정 값|BIC",				Type: "Int",	SaveName: "bic_est",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false, ColMerge:1 },
				{ Header: "은행|4Q 추정 값|LC",					Type: "Int",	SaveName: "lc_est",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false , ColMerge:1},
				{ Header: "은행|한도 적용 값|BIC",				Type: "Int",	SaveName: "bic",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false , ColMerge:0},
				{ Header: "은행|한도 적용 값|LC",				Type: "Int",	SaveName: "lc",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false , ColMerge:0},
				{ Header: "은행|한도 적용 값|ILM",				Type: "Float",	SaveName: "ilm",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false , ColMerge:0},
				{ Header: "은행|한도 적용 값|ORC 한도",			Type: "Int",	SaveName: "orc",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false , ColMerge:0},
				{ Header: "미얀마|4Q 추정 값|BIC",				Type: "Int",	SaveName: "m_bic_est",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false , ColMerge:1},
				{ Header: "미얀마|4Q 추정 값|LC",				Type: "Int",	SaveName: "m_lc_est",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false , ColMerge:1},
				{ Header: "미얀마|한도 적용 값|BIC",			Type: "Int",	SaveName: "m_bic",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false , ColMerge:0},
				{ Header: "미얀마|한도 적용 값|LC",				Type: "Int",	SaveName: "m_lc",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false , ColMerge:0},
				{ Header: "미얀마|한도 적용 값|ILM",			Type: "Float",	SaveName: "m_ilm",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false , ColMerge:0},
				{ Header: "미얀마|한도 적용 값|ORC 한도",		Type: "Int",	SaveName: "m_orc",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false , ColMerge:0},
				{ Header: "그룹|그룹/nORC 한도|그룹/nORC 한도",	Type: "Int",	SaveName: "g_orc",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false , ColMerge:0},
				{ Header: "한도 채택|한도 채택|한도 채택",		Type: "CheckBox",	SaveName: "ischeck",	Align: "Center",	Width: 10,	MinWidth: 60 , ColMerge:0},
			];
			IBS_InitSheet(mySheet1, initdata);
			mySheet1.SetSelectionMode(4);
			mySheet1.SetCountPosition(0);
		}

		// mySheet2
		function initIBSheet2() {
			var initdata = {};
			initdata.Cfg = { MergeSheet: msHeaderOnly };
			initdata.Cols = [
				{ Header: "산출구성요소",		Type: "Text",	SaveName: "gubun",	Align: "Center",	Width: 10,	MinWidth: 60, Edit:false, Edit:false },
				{ Header: "구분",				Type: "Text",	SaveName: "c1",	Align: "Center",	Width: 10,	MinWidth: 60, Edit:false, Edit:false },
				{ Header: "기간(X)",			Type: "Text",	SaveName: "c2",	Align: "Center",	Width: 10,	MinWidth: 50, Edit:false, Edit:false },
				{ Header: "은행 별도 BIC",		Type: "Int",	SaveName: "bic",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false, Edit:false },
				{ Header: "은행 별도 LC",		Type: "Int",	SaveName: "lc",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false, Edit:false },
				{ Header: "기간(X)",			Type: "Float",	SaveName: "m_c2",	Align: "Center",	Width: 10,	MinWidth: 50, Edit:false, Edit:false },
				{ Header: "미얀마 별도 BIC",	Type: "Int",	SaveName: "m_bic",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false, Edit:false },
				{ Header: "미얀마 별도 LC",		Type: "Int",	SaveName: "m_lc",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false, Edit:false },
			];
			IBS_InitSheet(mySheet2, initdata);
			mySheet2.SetSelectionMode(4);
			mySheet2.SetCountPosition(0);
		}

		// mySheet3
		function initIBSheet3() {
			var initdata = {};
			initdata.Cfg = { MergeSheet: msHeaderOnly };
			initdata.Cols = [
				{ Header: "구분",				Type: "Text",	SaveName: "gubun",	Align: "Center",	Width: 10,	MinWidth: 60, Edit:false },
				{ Header: "시점",				Type: "Text",	SaveName: "t1",	Align: "Center",	Width: 10,	MinWidth: 60, Edit:false },
				{ Header: "시점",				Type: "Text",	SaveName: "bas_ym",	Align: "Center",	Width: 10,	MinWidth: 80, Edit:false },
				{ Header: "기간(X)",			Type: "Int",	SaveName: "x",	Align: "Center",	Width: 10,	MinWidth: 50, Edit:false },
				{ Header: "은행 별도 BIC",		Type: "Int",	SaveName: "b_bic",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false },
				{ Header: "은행 별도 LC",		Type: "Int",	SaveName: "b_lc",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false },
				{ Header: "기간(X)",			Type: "Int",	SaveName: "m_x",	Align: "Center",	Width: 10,	MinWidth: 50, Edit:false },
				{ Header: "미얀마 별도 BIC",	Type: "Int",	SaveName: "m_bic",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false },
				{ Header: "미얀마 별도 LC",		Type: "Int",	SaveName: "m_lc",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false },
			];
			IBS_InitSheet(mySheet3, initdata);
			mySheet3.SetSelectionMode(4);
			mySheet3.SetCountPosition(0);
		}

		// mySheet4
		function initIBSheet4() {
			var initdata = {};
			initdata.Cfg = { MergeSheet: msHeaderOnly };
			initdata.Cols = [
				{ Header: "산출구성요소",		Type: "Text",	SaveName: "gubun",	Align: "Center",	Width: 10,	MinWidth: 60, Edit:false },
				{ Header: "구분",				Type: "Text",	SaveName: "c1",	Align: "Center",	Width: 10,	MinWidth: 60, Edit:false },
				{ Header: "기간(X)",			Type: "Text",	SaveName: "c2",	Align: "Center",	Width: 10,	MinWidth: 50, Edit:false },
				{ Header: "은행 별도 BIC",		Type: "Int",	SaveName: "bic",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false },
				{ Header: "은행 별도 LC",		Type: "Int",	SaveName: "lc",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false },
				{ Header: "기간(X)",			Type: "Float",	SaveName: "c3",	Align: "Center",	Width: 10,	MinWidth: 50, Edit:false },
				{ Header: "미얀마 별도 BIC",	Type: "Int",	SaveName: "m_bic",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false },
				{ Header: "미얀마 별도 LC",		Type: "Int",	SaveName: "m_lc",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false },
			];
			IBS_InitSheet(mySheet4, initdata);
			mySheet4.SetSelectionMode(4);
			mySheet4.SetCountPosition(0);
		}

		// mySheet5
		function initIBSheet5() {
			var initdata = {};
			initdata.Cfg = { MergeSheet: msHeaderOnly };
			initdata.Cols = [
				{ Header: "",					Type: "Text",	SaveName: "gubun2",	Align: "Center",	Width: 10,	MinWidth: 60, Edit:false },
				{ Header: "시점",				Type: "Text",	SaveName: "bas_ym",	Align: "Center",	Width: 10,	MinWidth: 60, Edit:false },
				{ Header: "시점",				Type: "Text",	SaveName: "t1",	Align: "Center",	Width: 10,	MinWidth: 80, Edit:false },
				{ Header: "기간(X)",			Type: "Int",	SaveName: "x",	Align: "Center",	Width: 10,	MinWidth: 50, Edit:false },
				{ Header: "은행 별도 BIC",		Type: "Int",	SaveName: "b_bic",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false },
				{ Header: "은행 별도 LC",		Type: "Int",	SaveName: "b_lc",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false },
				{ Header: "기간(X)",			Type: "Int",	SaveName: "m_x",	Align: "Center",	Width: 10,	MinWidth: 50, Edit:false },
				{ Header: "미얀마 별도 BIC",	Type: "Int",	SaveName: "m_bic",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false },
				{ Header: "미얀마 별도 LC",		Type: "Int",	SaveName: "m_lc",	Align: "Right",		Width: 10,	MinWidth: 100, Edit:false },
			];
			IBS_InitSheet(mySheet5, initdata);
			mySheet5.SetSelectionMode(4);
			mySheet5.SetCountPosition(0);
		}
		
		function cblmtChange(obj) {
			if ($(obj).is(':checked')) {
				var id = $(obj).attr("id");
				if(id!="lmt_case1"){
					$("#lmt_case1").prop("checked",false);
					$("#simu_case1").prop("checked",false);
				}else{
					$("#simu_case1").prop("checked",true);
					myChartDraw(1);
				}
				if(id!="lmt_case2"){
					$("#lmt_case2").prop("checked",false);
					$("#simu_case2").prop("checked",false);
				}else{
					$("#simu_case2").prop("checked",true);
					myChartDraw(2);
				}
				if(id!="lmt_case3"){
					$("#lmt_case3").prop("checked",false);
					$("#simu_case3").prop("checked",false);
				}else{
					$("#simu_case3").prop("checked",true);
					myChartDraw(3);
				}
				if(id!="lmt_case4"){
					$("#lmt_case4").prop("checked",false);
					$("#simu_case4").prop("checked",false);
				}else{
					$("#simu_case4").prop("checked",true);
					myChartDraw(4);
				}
			}
		}
		
		function mySheet1_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
				return;
			}else{
				if(mySheet1.GetDataFirstRow()>=0){
					for(var j=mySheet1.GetDataFirstRow(); j<=mySheet1.GetDataLastRow(); j++){
						if(mySheet1.GetCellValue(j,"gubun") == "04"){
							var info = {Type:"Float",	Format : "#,##0.00" };

							mySheet1.InitCellProperty(j, "case1", info);
							mySheet1.InitCellProperty(j, "case2", info);
							mySheet1.InitCellProperty(j, "case3", info);
							mySheet1.InitCellProperty(j, "case4", info);
						}
					}
				}
				if($("#new_load_yn").prop("checked")){
					mySheet1.SetColEditable("ischeck", 1);
					$("#sv_bas_yy").val($("#sch_bas_yy").val());
					$("#upload_sqno").val($("#sch_bas_yy option:selected").data("uploadsqno"));
					$("#sv_mng_pln_rto_bnk").val($("#bic_buffer_sh").val());
					$("#sv_mng_pln_rto_myn").val($("#bic_buffer_shm").val());
					$("#sv_lss_am_bnk").val($("#lc_buffer_sh").val());
					$("#sv_lss_am_myn").val($("#lc_buffer_shm").val());
					
					
					//doAction('simuSearch');
				}else{
					mySheet1.SetCellValue(parseInt(mySheet1.GetCellValue(3,"coic_case_dsc"))+2,"ischeck",1);
					//doAction('svsimuSearch');
				}
			}
		}
		
		function mySheet1_OnEditValidation(Row, Col, Value) {
			for(var i = mySheet1.GetDataFirstRow(); i<= mySheet1.GetDataLastRow(); i++){
				if(mySheet1.GetCellValue(i,"ischeck") == 1){
					mySheet1.SetCellValue(i,"ischeck",0);
				}
			}
		}

		function mySheet1_OnSaveEnd(code, msg) {
		    if(code >= 0) {
		    	search();
		        
		    } else {
		    }
		}
		
		function mySheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) {
			
			
		}
		
		function mySheet2_OnSearchEnd(code, message) {
			var opt = {};
			
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("msr");
				$("form[name=ormsForm] [name=process_id]").val("ORMR011205");
				mySheet3.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			}
			
			
		}
		
		function mySheet3_OnSearchEnd(code, message) {
			var bic = 0;
			var lc = 0;
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				bic = mySheet2.GetCellValue(5,"bic") + (mySheet2.GetCellValue(4,"bic")*mySheet3.GetCellValue(mySheet3.GetDataLastRow(),"x"));
				mySheet3.SetCellValue(mySheet3.GetDataLastRow(),"b_bic",bic);
				lc = mySheet2.GetCellValue(5,"lc") + (mySheet2.GetCellValue(4,"lc")*mySheet3.GetCellValue(mySheet3.GetDataLastRow(),"x"));
				mySheet3.SetCellValue(mySheet3.GetDataLastRow(),"b_lc",lc);
				
				bic = mySheet2.GetCellValue(5,"m_bic") + (mySheet2.GetCellValue(4,"m_bic")*mySheet3.GetCellValue(mySheet3.GetDataLastRow(),"m_x"));
				mySheet3.SetCellValue(mySheet3.GetDataLastRow(),"m_bic",bic);
				lc = mySheet2.GetCellValue(5,"m_lc") + (mySheet2.GetCellValue(4,"m_lc")*mySheet3.GetCellValue(mySheet3.GetDataLastRow(),"m_x"));
				mySheet3.SetCellValue(mySheet3.GetDataLastRow(),"m_lc",lc);
			}
		}
	
		function mySheet2_OnSaveEnd(code, msg) {
		    if(code >= 0) {
		    	alert("저장되었습니다");
		    } else {
		    }
		}
		function mySheet4_OnSearchEnd(code, message) {
			var opt = {};
			
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("msr");
				$("form[name=ormsForm] [name=process_id]").val("ORMR011207");
				mySheet5.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			}
		}
		
		function mySheet5_OnSearchEnd(code, message) {
			var bic = 0;
			var lc = 0;
			var m_bic = 0;
			var m_lc = 0;
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				
				//예측치
				bic = mySheet4.GetCellValue(5,"bic") + (mySheet4.GetCellValue(4,"bic")*mySheet5.GetCellValue(mySheet5.GetDataLastRow(),"x"));
				mySheet5.SetCellValue(mySheet5.GetDataLastRow(),"b_bic",bic);
				lc = mySheet4.GetCellValue(5,"lc") + (mySheet4.GetCellValue(4,"lc")*mySheet5.GetCellValue(mySheet5.GetDataLastRow(),"x"));
				mySheet5.SetCellValue(mySheet5.GetDataLastRow(),"b_lc",lc);
				m_bic = mySheet4.GetCellValue(5,"m_bic") + (mySheet4.GetCellValue(4,"m_bic")*mySheet5.GetCellValue(mySheet5.GetDataLastRow(),"m_x"));
				mySheet5.SetCellValue(mySheet5.GetDataLastRow(),"m_bic",m_bic);
				m_lc = mySheet4.GetCellValue(5,"m_lc") + (mySheet4.GetCellValue(4,"m_lc")*mySheet5.GetCellValue(mySheet5.GetDataLastRow(),"m_x"));
				mySheet5.SetCellValue(mySheet5.GetDataLastRow(),"m_lc",m_lc);
				var bic_af = 0;
				var lc_af = 0;
				//신뢰수준 95%
				bic_af = mySheet4.GetCellValue(7,"bic") + bic;
				mySheet5.SetCellValue(mySheet5.GetDataLastRow()-2,"b_bic",bic_af);
				lc_af = mySheet4.GetCellValue(7,"lc") + lc;
				mySheet5.SetCellValue(mySheet5.GetDataLastRow()-2,"b_lc",lc_af);
				bic_af = mySheet4.GetCellValue(7,"m_bic") + m_bic;
				mySheet5.SetCellValue(mySheet5.GetDataLastRow()-2,"m_bic",bic_af);
				lc_af = mySheet4.GetCellValue(7,"m_lc") + m_lc;
				mySheet5.SetCellValue(mySheet5.GetDataLastRow()-2,"m_lc",lc_af);
				
				//신뢰수준 99%
				bic_af = mySheet4.GetCellValue(8,"bic") + bic;
				mySheet5.SetCellValue(mySheet5.GetDataLastRow()-1,"b_bic",bic_af);
				lc_af = mySheet4.GetCellValue(8,"lc") + lc;
				mySheet5.SetCellValue(mySheet5.GetDataLastRow()-1,"b_lc",lc_af);
				bic_af = mySheet4.GetCellValue(8,"m_bic") + m_bic;
				mySheet5.SetCellValue(mySheet5.GetDataLastRow()-1,"m_bic",bic_af);
				lc_af = mySheet4.GetCellValue(8,"m_lc") + m_lc;
				mySheet5.SetCellValue(mySheet5.GetDataLastRow()-1,"m_lc",lc_af);
			}
		}
		
		function search() {
		
			/* $("#bic_buffer_sh").val("");
			$("#bic_buffer_shm").val("");
			$("#lc_buffer_sh").val("");
			$("#lc_buffer_shm").val("");
			if($("#new_load_yn").prop("checked")){
				$("#bic_buffer_sh").prop("readonly",false);
				$("#bic_buffer_shm").prop("readonly",false);
				$("#lc_buffer_sh").prop("readonly",false);
				$("#lc_buffer_shm").prop("readonly",false);
				$("#save_btn").attr("disabled",false);
				$("#lmt_search_btn").attr("disabled",false);
				//doAction('lmtSearch');
			}else{
				$("#bic_buffer_sh").prop("readonly",true);
				$("#bic_buffer_shm").prop("readonly",true);
				$("#lc_buffer_sh").prop("readonly",true);
				$("#lc_buffer_shm").prop("readonly",true);
				$("#save_btn").attr("disabled",true);
				$("#lmt_search_btn").attr("disabled",true);
				//doAction('svSearch1');
			} */						
		}
		
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		var lc_buffer_sh = 0;
		/*Sheet 각종 처리*/
		function doAction(sAction) {
			switch(sAction) {
				case "search_buffer" :
					if($("#sch_bas_yy").val() == null || $("#sch_bas_yy").val() == ""){
						alert("조회 대상 년도가 없습니다.");
						return;
					}
					var opt = {};
					var f = document.ormsForm;
					if($("#new_load_yn").prop("checked")){
						WP.clearParameters();
						WP.setParameter("method", "Main");
						WP.setParameter("commkind", "msr");
						WP.setParameter("process_id", "ORMR011202");
						WP.setForm(f);
						
						var inputData = WP.getParams();
						showLoadingWs(); // 프로그래스바 활성화
						
						WP.load(url, inputData,{
							success: function(result){
								if(result!='undefined' && result.rtnCode=="0") {
									var rList = result.DATA;
									if(rList.length>0){
										$("#lc_buffer_sh").val(rList[0].lc_buffer_sh);
									}
								}else if(result!='undefined' && result.rtnCode!="0"){
									alert(result.rtnMsg);
								}
							},
							  
							complete: function(statusText,status) {
								removeLoadingWs();
							},
							  
							error: function(rtnMsg){
								alert(JSON.stringify(rtnMsg));
							}
						});
						
						
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("msr");
						$("form[name=ormsForm] [name=process_id]").val("ORMR011204");
						mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
						
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("msr");
						$("form[name=ormsForm] [name=process_id]").val("ORMR011206");
						mySheet4.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
						break;
					}else {
						WP.clearParameters();
						WP.setParameter("method", "Main");
						WP.setParameter("commkind", "msr");
						WP.setParameter("process_id", "ORMR011210");
						WP.setForm(f);
						
						var inputData = WP.getParams();
						showLoadingWs(); // 프로그래스바 활성화
						
						WP.load(url, inputData,{
							success: function(result){
								if(result!='undefined' && result.rtnCode=="0") {
									var rList = result.DATA;
									if(rList.length>0){
										$("#bic_buffer_sh").val(rList[0].mng_pln_rto);
										$("#bic_buffer_shm").val(rList[1].mng_pln_rto);
										$("#lc_buffer_sh").val(rList[0].lss_am);
										$("#lc_buffer_shm").val(rList[1].lss_am);
									}
								}else if(result!='undefined' && result.rtnCode!="0"){
									alert(result.rtnMsg);
									
								}
							},
							  
							complete: function(statusText,status) {
								removeLoadingWs();
							},
							  
							error: function(rtnMsg){
								alert(JSON.stringify(rtnMsg));
							}
						});
						
						
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("msr");
						$("form[name=ormsForm] [name=process_id]").val("ORMR011211");
						mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
						
						
						
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("msr");
						$("form[name=ormsForm] [name=process_id]").val("ORMR011204");
						mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
						
						
						
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("msr");
						$("form[name=ormsForm] [name=process_id]").val("ORMR011206");
						mySheet4.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
						break;
					}
					
				case "search" : 
					
					var opt = {};
					
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR011203");
					mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);

					break;
				/* case "lmtSearch":  //내부자본한도설정 조회

					
				
					if($("#mng_pln_rto").val() != "" && isNaN($("#mng_pln_rto").val())){
						alert("경영계획은 숫자로 입력해야 합니다.");
						return;
					}
				
					if($("#mng_pln_rto").val() != "" && parseFloat($("#mng_pln_rto").val())< 0){
						alert("경영계획은 plus값으로 입력해야 합니다.");
						return;
					}
				
					if($("#lss_am").val() != "" && isNaN($("#lss_am").val())){
						alert("손실금액은 숫자로 입력해야 합니다.");
						return;
					}
					
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR011204");
					
					mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "svSearch1":  //내부자본한도설정 조회

					if($("#sch_bas_yy").val() == null || $("#sch_bas_yy").val() == ""){
						alert("조회 대상 년도가 없습니다.");
						return;
					}
				
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("msr");
					$("form[name=ormsForm] [name=process_id]").val("ORMR011208");

					mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;
				case "svSearch2":  //내부자본한도설정 조회

					if($("#sch_bas_yy").val() == null || $("#sch_bas_yy").val() == ""){
						alert("조회 대상 년도가 없습니다.");
						return;
					}
				
					var f = document.ormsForm;
					WP.clearParameters();
					WP.setParameter("method", "Main");
					WP.setParameter("commkind", "msr");
					WP.setParameter("process_id", "ORMR011207");
					WP.setForm(f);
					
					var inputData = WP.getParams();
					showLoadingWs(); // 프로그래스바 활성화
					
					WP.load(url, inputData,{
						success: function(result){
							if(result!='undefined' && result.rtnCode=="0") {
								var rList = result.DATA;
								if(rList.length>0){
									$("#mng_pln_rto").val(rList[0].mng_pln_rto);
									$("#lss_am").val(rList[0].lss_am);
									$("#lmt_case1").prop("checked",false);
									$("#lmt_case2").prop("checked",false);
									$("#lmt_case3").prop("checked",false);
									$("#lmt_case4").prop("checked",false);

									if(rList[0].coic_case_dsc=="01"){
										$("#lmt_case1").prop("checked",true);
										cblmtChange($("#lmt_case1"));
									}else if(rList[0].coic_case_dsc=="02"){
										$("#lmt_case2").prop("checked",true);
										cblmtChange($("#lmt_case2"));
									}else if(rList[0].coic_case_dsc=="03"){
										$("#lmt_case3").prop("checked",true);
										cblmtChange($("#lmt_case3"));
									}else if(rList[0].coic_case_dsc=="04"){
										$("#lmt_case4").prop("checked",true);
										cblmtChange($("#lmt_case4"));
									}
									
								}
	
							}else if(result!='undefined' && result.rtnCode!="0"){
								alert(result.rtnMsg);
							}
						},
						  
						complete: function(statusText,status) {
							removeLoadingWs();
						},
						  
						error: function(rtnMsg){
							alert(JSON.stringify(rtnMsg));
						}
					});
			
					break;*/
					
				case "save":      //저장처리		
					if(mySheet1.GetCellValue(3,"ischeck")== 1){
						$("#coic_case_dsc").val("1");
					}else if(mySheet1.GetCellValue(4,"ischeck")== 1){
						$("#coic_case_dsc").val("2");
					}else if(mySheet1.GetCellValue(5,"ischeck")== 1){
						$("#coic_case_dsc").val("3");
					}else if(mySheet1.GetCellValue(6,"ischeck")== 1){
						$("#coic_case_dsc").val("4");
					}else{
						alert("케이스를 선택하세요.");
						return;
					}
					
					
					

					if(!confirm("저장하시겠습니까?")) return;
						
					html = "";
					for(var i=0;i<4;i++){
						//내부은행자본 한도 설정
						html += "<input type='hidden' id='case_dsc' name='case_dsc' value='" +(i+1) + "' />";	//케이스구분코드
						html += "<input type='hidden' id='est_buix_am' name='est_buix_am' value='" + mySheet1.GetCellValue(i+3,"bic_est") +"' />";	//추정bic
						html += "<input type='hidden' id='est_lss_am' name='est_lss_am' value='" + mySheet1.GetCellValue(i+3,"lc_est") +"' />";	//추정손실금액
						html += "<input type='hidden' id='buix_lmt_am' name='buix_lmt_am' value='" + mySheet1.GetCellValue(i+3,"bic") + "' />";	//bic한도금액
						html += "<input type='hidden' id='lsx_lmt_am' name='lsx_lmt_am' value='" + mySheet1.GetCellValue(i+3,"lc") + "' />";	//lc한도금액
						html += "<input type='hidden' id='in_lss_mltplr_val' name='in_lss_mltplr_val' value='" + mySheet1.GetCellValue(i+3,"ilm") + "' />";	//ilm
						html += "<input type='hidden' id='tot_ned_ownfds_lmt_am' name='tot_ned_ownfds_lmt_am' value='" + mySheet1.GetCellValue(i+3,"orc" ) + "'/>";	//orc 한도

						//미얀마 한도 설정
						html += "<input type='hidden' id='m_case_dsc' name='m_case_dsc' value='" +(i+1) + "' />";	//케이스구분코드
						html += "<input type='hidden' id='m_est_buix_am' name='m_est_buix_am' value='" + mySheet1.GetCellValue(i+3,"m_bic_est") +"' />";	//추정bic
						html += "<input type='hidden' id='m_est_lss_am' name='m_est_lss_am' value='" + mySheet1.GetCellValue(i+3,"m_lc_est") +"' />";	//추정손실금액
						html += "<input type='hidden' id='m_buix_lmt_am' name='m_buix_lmt_am' value='" + mySheet1.GetCellValue(i+3,"m_bic") + "' />";	//bic한도금액
						html += "<input type='hidden' id='m_lsx_lmt_am' name='m_lsx_lmt_am' value='" + mySheet1.GetCellValue(i+3,"m_lc") + "' />";	//lc한도금액
						html += "<input type='hidden' id='m_in_lss_mltplr_val' name='m_in_lss_mltplr_val' value='" + mySheet1.GetCellValue(i+3,"m_ilm") + "' />";	//ilm
						html += "<input type='hidden' id='m_tot_ned_ownfds_lmt_am' name='m_tot_ned_ownfds_lmt_am' value='" + mySheet1.GetCellValue(i+3,"m_orc" ) + "'/>";	//총소요자기자본한도금액
						//내부자본 한도 소진율
						/* for(var j=0;j<4;j++){
							html += "<input type='hidden' id='rt_case_dsc' name='rt_case_dsc' value='" + "0" + (i+1) + "' />";	//소진율케이스구분코드
							html += "<input type='hidden' id='bas_mm' name='bas_mm' value='" + (((j+1)*3 >9)?(j+1)*3:"0"+(j+1)*3) + "' />";	//기준월
							html += "<input type='hidden' id='tot_ned_ownfds' name='tot_ned_ownfds' value='" + mySheet2.GetCellValue(j*2+2,"case" + (i+1)) + "' />";	//총소요자기자본
							html += "<input type='hidden' id='lmt_rto' name='lmt_rto' value='" + mySheet2.GetCellValue(j*2+3,"case" + (i+1)) + "' />";	//소진율
						} */
					}
					
					//alert(html)
					$("#sv_area").html(html);
					
					var f = document.ormsForm;
					WP.clearParameters();
					WP.setParameter("method", "Main");
					WP.setParameter("commkind", "msr");
					WP.setParameter("process_id", "ORMR011209");
					WP.setForm(f);
					
					var inputData = WP.getParams();
					
					showLoadingWs(); // 프로그래스바 활성화
					WP.load(url, inputData,
					{
						success: function(result){
							if(result!='undefined' && result.rtnCode=="X") {
								alert("저장되었습니다.");
								$("#sch_bas_yy option:selected").data("saveyn","N")
								search();
							}else if(result!='undefined'){
								alert(result.rtnMsg);
							}else if(result=='undefined'){
								alert("처리할 수 없습니다.");
							}  
						},
					  
						complete: function(statusText,status){
							removeLoadingWs();
						},
					  
						error: function(rtnMsg){
							alert(JSON.stringify(rtnMsg));
						}
					});
					break;
				case "confrimation":
					var f = document.ormsForm;
					WP.clearParameters();
					WP.setParameter("method", "Main");
					WP.setParameter("commkind", "msr");
					WP.setParameter("process_id", "ORMR011213");
					WP.setForm(f);
					
					var inputData = WP.getParams();
					
					showLoadingWs(); // 프로그래스바 활성화
					WP.load(url, inputData,
					{
						success: function(result){
							if(result!='undefined' && result.rtnCode=="X") {
								alert("확정되었습니다.");
								$("#conf_btn").css("display","none");
								$("#save_btn").css("display","none");
								$("#buffer_btn").css("display","none");
								
							}else if(result!='undefined'){
								alert(result.rtnMsg);
							}else if(result=='undefined'){
								alert("처리할 수 없습니다.");
							}  
						},
					  
						complete: function(statusText,status){
							removeLoadingWs();
						},
					  
						error: function(rtnMsg){
							alert(JSON.stringify(rtnMsg));
						}
					});
					break;
			}
		}
		function new_load_yn(){
			alert("@@@@@@@@@@@");
			if(box.checked==true){
				$("#conf_btn").css("display","none");
				$("#save_btn").css("display","block");
				$("#buffer_btn").css("display","block");
			}else {
				$("#conf_btn").css("display","block");
				$("#save_btn").css("display","none");
				$("#buffer_btn").css("display","none");
			}
		}
		
	</script>
</head>
<body>
	<div class="container">
		<%@ include file="../comm/header.jsp" %>
		<!-- content -->
		<div class="content">
			<div class="box">
				<form name="ormsForm" method="post">
                <input type="hidden" id="path" name="path" />
                <input type="hidden" id="process_id" name="process_id" />
                <input type="hidden" id="commkind" name="commkind" />
                <input type="hidden" id="method" name="method" />
                <input type="hidden" id="sv_bas_yy" name="sv_bas_yy" />
                <input type="hidden" id="upload_sqno" name="upload_sqno" />
                <input type="hidden" id="sv_rgo_in_dsc" name="sv_rgo_in_dsc" />
                <input type="hidden" id="sv_sbdr_c" name="sv_sbdr_c" />
                
                <input type="hidden" id="sv_mng_pln_rto_bnk" name="sv_mng_pln_rto_bnk" />
                <input type="hidden" id="sv_mng_pln_rto_myn" name="sv_mng_pln_rto_myn" />
                
                <input type="hidden" id="sv_lss_am_bnk" name="sv_lss_am_bnk" />
                <input type="hidden" id="sv_lss_am_myn" name="sv_lss_am_myn" />
                <input type="hidden" id="coic_case_dsc" name="coic_case_dsc" />

                <input type="hidden" id="rzt_yn" name="rzt_yn" />
                <input type="hidden" id="save_yn" name="save_yn" />
                
                <div id="sv_area"></div>
				<!-- 조회 -->
				<div class="box box-search">
					<div class="box-body">
						<div class="wrap-search">
							<table>
								<tbody>
									<tr>
										<th>기준 연도</th>
										<td>
											<td>
												<div class="select w100">
													<select name="sch_bas_yy" id="sch_bas_yy" class="form-control">
<%
	for(int i=0;i<vLst.size();i++){
		HashMap hMap = (HashMap)vLst.get(i);
%>
													<option value="<%=(String)hMap.get("bas_yy")%>"><%=(String)hMap.get("bas_yy")%></option>
<%
	}
%>
													</select>
												</div>
												<span class="checkbox-custom">
													<input type="checkbox" class="form-control" id="new_load_yn" name="new_load_yn" onchange="new_load_yn()" checked >
													<label for="new_load_yn"><i></i><span>새로 가져오기</span></label>
												</span>
											</td>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div><!-- .box-body //-->
					<div class="box-footer">
						<button type="button" class="btn btn-default btn-xs" onclick="modalOpen('modalGuide');"><i class="fa fa-question-circle"></i><span class="txt">Help</span></button>			
						<button type="button" class="btn btn-primary search" onclick="doAction('search_buffer');">조회</button>
					</div>
				</div>
				<!-- 조회 //-->

				<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">Case 別  내부자본 BIC 및LC 한도 설정</h2>
					<!-- <div class="area-term">
						<span class="tit">진행상황 :</span>
						<strong class="em">승인요청</strong>
					</div> -->
					<div class="area-tool">
						<button type="button" class="btn btn-xs btn-default" onclick="doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
						<button type="button" class="btn btn-primary" id="save_btn" name="save_btn" onclick="javascript:doAction('save')" style="display:inline"><span class="txt">저장</span></button>
						<button type="button" class="btn btn-normal" id="conf_btn" name="conf_btn" onclick="javascript:doAction('confrimation')" style="display:inline"><span class="txt">최종 확정</span></button>
						
					</div>
				</div>
				<div class="box-header">
					<h3 class="title">BIC 및 LC Buffer 적용</h3>
				</div>
				<div class="wrap-table">
					<table class="w800">
						<tbody class="center"> 
							<tr>
								<th rowspan="4">수기입력</th>
								<th scope="col" colspan="2">BIC Buffer (%)</th>
								<th rowspan="4">자동산출</th>
								<th scope="col" colspan="2">LC Buffer<button type="button" class="btn btn-default btn-xs ml10"><span class="txt">상세보기</span></button></th>
								<th rowspan="4">
									<button type="button" class="btn btn-primary btn-sm" id="buffer_btn" name="buffer_btn" onclick="doAction('search')" style="display:block;"><span class="txt">Buffer 적용</span></button>
								</th>
							</tr>
							<tr>
								<th scope="col" colspan="2">차기년도 목표 영업이익률</th>
								<th scope="col" colspan="2">Top 10 평균 내부손실사건 순손실금액<br>(최고/최저 제외)</th>
							</tr>
							<tr>
								<th scope="col">은행</th>
								<th scope="col">미얀마</th>
								<th scope="col">은행</th>
								<th scope="col">미얀마</th>
							</tr>
							<tr>
								<td class="right"><input type="text" class = "form-control w50" id="bic_buffer_sh" name="bic_buffer_sh"/>%</td>
								<td class="right"><input type="text" class = "form-control w50" id="bic_buffer_shm" name="bic_buffer_shm"/>%</td>
								<td class="right"><input type="text" class = "form-control w100" id="lc_buffer_sh" name="lc_buffer_sh" readonly/></td>
								<td class="right"><input type="text" class = "form-control w100" id="lc_buffer_shm" name="lc_buffer_shm" value="0" readonly/></td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="wrap-grid h250">
					<script> createIBSheet("mySheet1", "100%", "100%"); </script>
				</div>
			</section>
			
			<section class="box box-grid">
				<div class="box-header">
					<h2 class="box-title">산출 상세 과정</h2>
				</div>
				<article class="box-grid">
					<div class="box-header">
						<h3 class="title">당해년도 4Q 예측치 산출 <span class="small">(2021 4Q 기준)</span></h3>
					</div>
					<div class="wrap-grid h250">
						<script> createIBSheet("mySheet2", "100%", "100%"); </script>
					</div>
					<div class="wrap-grid h400">
						<script> createIBSheet("mySheet3", "100%", "100%"); </script>
					</div>
				</article>
				<article class="box box-grid">
					<div class="box-header">
						<h3 class="title">차기년도 신뢰수준 別 4Q 예측치 산출 <span class="small">(2022 4Q 예측치)</span></h3>
					</div>
					<div class="wrap-grid h250">
						<script> createIBSheet("mySheet4", "100%", "100%"); </script>
					</div>
					<div class="wrap-grid h400">
						<script> createIBSheet("mySheet5", "100%", "100%"); </script>
					</div>
				</article>
			</section>
				</form>
			</div>
		</div>
		<!-- content //-->
	</div>
	<!-- popup -->
	<article id="modalGuide" class="popup modal">
		<div class="p_frame w1000">	
			<div class="p_head">
				<h1 class="title">운영리스크 개별 위기상황분석 가이드라인</h1>
			</div>
			<div class="p_body">						
				<div class="p_wrap">
				
				
					<section class="box box-grid">	
						<div class="box-header">
							<h2 class="box-title">1. 과거 BIC 및 LC 데이터 활용 당해년도 4Q BIC 및 LC 분기별 예측치 산출</h2>
						</div>
						<div class="msr-guide-foreimg">
							<img src="<%=System.getProperty("contextpath")%>/imgs/contents/msr_guide_fore.svg" alt="한도 산출 시점">
						</div>
						<div class="alert alert-warning">
							<p>내부자본한도 산출 시점은 4Q재무제포 작성 이전으로 以前 <strong>19개 분기</strong>(5년치)의 BIC 및 LC 데이터를 기반으로 각각의 당해년도 4Q 시점 예측치 산출</p>
							<p>ex) 2022년 한도 산출 시, 2017-1Q ~ 2021.3Q까지 19개 분기 데이터 사용</p>
						</div>			
						<div class="wrap-table">
							<table>
								<colgroup>
									<col style="width: 120px;">
									<col style="width: 100px;">
									<col style="width: 80px;">
									<col>
								</colgroup>
								<thead>
									<tr>
										<th scope="col" colspan="2">시점</th>
										<th scope="col">기간(X)</th>
										<th scope="col">BIC</th>
										<th scope="col">LC</th>
									</tr>
								</thead>
								<tbody class="center">
									<tr>
										<td>2017 1Q</td>
										<td>t-19</td>
										<td>1</td>
										<td class="right">73,097,469,762</td>
										<td class="right">7,358,334,893</td>
									</tr>
									<tr>
										<td>2017 2Q</td>
										<td>t-18</td>
										<td>2</td>
										<td class="right">75,913,852,200</td>
										<td class="right">6,949,538,510</td>
									</tr>
									<tr>
										<td colspan="5"><span class="msr-guide-skip">…</span></td>
									</tr>
									<tr>
										<td>2021 2Q</td>
										<td>t-2</td>
										<td>18</td>
										<td class="right">92,0005,808,397</td>
										<td class="right">15,507,328,158</td>
									</tr>
									<tr>
										<td>2021 3Q</td>
										<td>t-1</td>
										<td>19</td>
										<td class="right">93,479,605,177</td>
										<td class="right">20,715,224,187</td>
									</tr>
									<tr>
										<td>2021 4Q</td>
										<td>t</td>
										<td>20</td>
										<td colspan="2">단순회귀분석 기반 산출</td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="alert alert-warning">
							<ul class="ullist">
								<li>1. 독립변수(기간)와 종속변수(BIC 및 LC)의 각 평균, 분산, 공분산 산출</li>
								<li>2. 회귀선 산식 산출(y=βx+k)
									<ul class="ullist">
										<li>
											<div class="msr-guide-reg">
												<div>1) 회귀선 기울기 - 회귀계수(β 산출)</div>
												<div class="math pl20">
													<span>β</span>
													<span class="code">=</span>
													<span class="frac">
														<span class="num">cov(X,Y)</span>
														<span class="num">var(X)</span>
													</span>
													<span class="code">=</span>
													<span class="frac">
														<span class="num">S<em class="math-down">xy</em></span>
														<span class="num">S<em class="math-down">2x</em></span>
													</span>
													<span class="code">=</span>
													<span>r<em class="math-down">xy</em></span>
													<span class="frac">
														<span class="num">S<em class="math-down">y</em></span>
														<span class="num">S<em class="math-down">x</em></span>
													</span>
												</div>
											</div>
										</li>
										<li>&rarr; 독립변수와 종속변수의 평균, 분산, 공분산 산출 필요</li>
										<li>2) 회귀선 y절편 산출</li>
									</ul>
								</li>
							</ul>
						</div>	
					</section>
				
					<section class="box box-grid">	
						<div class="box-header">
							<h2 class="box-title">2. 차기년도 신뢰수준 99% 4Q BIC 및 LC 연도별 예측치 산출</h2>
						</div>		
						<div class="msr-guide-foreimg">
							<img src="<%=System.getProperty("contextpath")%>/imgs/contents/msr_guide_forechart.svg" alt="신뢰수준 99% 4Q 연도별 예측치">
						</div>		
						<div class="alert alert-warning">
							<ul class="ullist">
								<li>1에서 산출한 <strong>4Q 예측치</strong>와 과거 4개년 연말 데이터 총 5개년을 확용하여 차기년도 末의 <strong>연도별</strong>예측치를 산출함 (단순회귀분석 사용)</li>
								<li>
									&rarr; 추정치의 한도는 <strong>신뢰수준 99% 값</strong>을 보정하여 반영함<br>
									회귀산식 y=βx+k+<span class="cr">α<em class="math-down">99</em></span>
									<span class="ml30">α<em class="math-down">99</em> : 99% 신뢰수준의 종속변수(BIC 및 LC)의 표준편차</span>
								</li>
							</ul>
						</div>		
					</section>
				
					<section class="box box-grid">	
						<div class="box-header">
							<h2 class="box-title">3. Buffer 적용 내부자본 한도 설정</h2>
						</div>	
						<div class="alert alert-warning">
							<ul class="ullist">
								<li>BIC 및 LC 한도 값은 Buffer를 적용함
									<ul class="ullist">
										<li>- BIC : 차기 경영계획 (목표 영업이익률)</li>
										<li>- LC : 당행 Top 10 내부 손실사건 순손실금액 평균 (최고, 최저 제외)</li>
									</ul>
								</li>
							</ul>
						</div>			
					</section>


				</div>						
			</div>
			<div class="p_foot">
				<div class="btn-wrap">
					<button type="button" class="btn btn-default btn-close" onclick="modalClose('modalGuide');">닫기</button>
				</div>
			</div>
			<button type="button" class="ico close fix btn-close" onclick="modalClose('modalGuide');"><span class="blind">닫기</span></button>	
		</div>
		<div class="dim p_close"></div>
	</article>
	<!-- popup //-->
</body>
</html>