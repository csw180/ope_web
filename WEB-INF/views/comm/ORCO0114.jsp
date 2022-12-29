<%--
/*---------------------------------------------------------------------------
 Program ID   : ORCO0114.jsp
 Program name : 공통 > 확인(팝업)
 Description  : 화면정의서 ADM-13
 Programmer   : 박승윤
 Date created : 2022.09.14
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
/* mode 
 1: 확인요청
 2: 확인
 3: 현황
*/
DynaForm form = (DynaForm)request.getAttribute("form");
String mode = form.get("rtn_func");

HashMap hMapSession = (HashMap) request.getSession(true).getAttribute("infoH");
String user_id = new String((String)hMapSession.get("userid"));

%>
<!DOCTYPE html>
<html lang="ko">
<head>

	<%@ include file="../comm/library.jsp" %>
	<script>
		$(document).ready(function(){
			getParent(); //parent 값 가져오기
			$("#winDcz",parent.document).show();
		});
		$(document).ready(function(){
			initIBSheet();
		});
		function initIBSheet() {
			mySheet.Reset();
			var initdata = {};
			initdata.Cfg = { MergeSheet:msHeaderOnly, AutoFitColWidth:"init|search|resize|rowtransaction|colhidden",ComboSettingMode:0};
			initdata.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:0};
			initdata.Cols = [
				{ Header: "확인자|권한",		Type: "Text",	SaveName: "auth_grpnm",				Align: "Center",		Width: 10,	MinWidth: 100 ,Edit:0},
				{ Header: "확인자|소속부점",	Type: "Text",	SaveName: "brnm",					Align: "Center",		Width: 10,	MinWidth: 100 ,Edit:0},
				{ Header: "확인자|팀/지점",	Type: "Text",	SaveName: "team_nm",					Align: "Center",		Width: 10,	MinWidth: 130 ,Edit:0},
				{ Header: "콤보체인지|확인자",	Type: "Text",	SaveName: "empnm", 					Align: "Center",Width: 10,	MinWidth: 80 ,Edit:0 ,Hidden:true},
				{ Header: "콤보체인지|개인번호",Type: "Text",	SaveName: "eno",						Align: "Center",Width: 10,	MinWidth: 80 ,Edit:0 ,Hidden:true},
				{ Header: "결재요청자개인번호|회수용",Type: "Text",	SaveName: "dcz_req_eno",		Align: "Center",Width: 10,	MinWidth: 80 ,Edit:0 ,Hidden:true},
				{ Header: "확인자|성명",		Type: "Combo",	SaveName: "dcz_eno", "ComboText":"", "ComboCode":"",Align: "Center",Width: 10,	MinWidth: 80 ,Edit:1},
				{ Header: "확인자|직위",		Type: "Text",	SaveName: "oftnm",			Align: "Center",		Width: 10,	MinWidth: 80 ,Edit:0},
				{ Header: "확인상태|확인상태",	Type: "Text",	SaveName: "status",			Align: "Center",		Width: 10,	MinWidth: 100 ,Edit:0},
				{ Header: "확인일|확인일",	Type: "Text",	SaveName: "dcz_dt",			Align: "Center",		Width: 10,	MinWidth: 60 ,Edit:0},
				{ Header: "확인의견|확인의견",	Type: "Text",	SaveName: "rtn_cntn",		Align: "Left",			Width: 10,	MinWidth: 200 ,Edit:0}
			];
			IBS_InitSheet(mySheet, initdata);
			mySheet.SetSelectionMode(4);
			doAction('search');
		}
		
		var row = "";
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		
	function getInfoAuth(){
		
		var f = document.ormsForm;
		
		WP.clearParameters();
		WP.setParameter("method", "Main");
		WP.setParameter("commkind", "com");
		WP.setParameter("process_id", "ORCO011403");
		WP.setForm(f);
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		var inputData = WP.getParams();
		showLoadingWs(); // 프로그래스바 활성화
		
		WP.load(url, inputData,{
			success: function(result){
				
			  if(result!='undefined' && result.rtnCode=="0") 
			  {
					var rList = result.DATA;
					var combo_text="";
					var combo_value="";
					for(i=0;i<rList.length;i++)
					{	
						if(i>0){
						combo_text += "|";
						combo_value += "|";
						}
						combo_text += rList[i].combo_empnm+"\t"+rList[i].combo_team_nm;
						combo_value += rList[i].eno;
					}

					mySheet.DataInsert(1); 
					
					var info = {"ComboCode":combo_value,"ComboText":combo_text}
		 			mySheet.CellComboItem(2,"dcz_eno",info)
		 			
					mySheet.SetCellValue(2,"auth_grpnm",rList[0].auth_grpnm);
					mySheet.SetCellValue(2,"brnm",rList[0].combo_brnm);
					mySheet.SetCellValue(2,"team_nm",rList[0].combo_team_nm);
					mySheet.SetCellValue(2,"eno",rList[0].eno);
					mySheet.SetCellValue(2,"status","확인요청");
					mySheet.SetCellValue(2,"dcz_eno",rList[0].combo_eno);
					mySheet.SetCellValue(2,"oftnm",rList[0].combo_oftnm);
					
			  } else if(result!='undefined' && result.rtnCode!="0"){
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
			removeLoadingWs();
			
			

		} 
		
		function mySheet_OnChange(Row, Col, Value, OldValue, RaiseFlag) { 
		  		var TeamNm = checkSelEno();
		  		if(TeamNm != undefined)
		  		{ 
		  			if(TeamNm.indexOf('\t'))
		  			{
		  				var arrTeamNm = TeamNm.split('\t');
		  				mySheet.SetCellValue(Row,"team_nm",arrTeamNm[1]);
		  			}
		  		}
		}

		function checkSelEno(){
				//콤보코드와 텍스트를 가져온다.
				var sText = mySheet.GetComboInfo(2,"dcz_eno", "Text");
				var sCode = mySheet.GetComboInfo(2,"dcz_eno", "Code") ;
				//각각 배열로 구성한다.
				var arrText = sText.split("|");
				var arrCode = sCode.split("|");
				var Index = mySheet.GetComboInfo(2,"dcz_eno","SelectedIndex");
				parent.$("#dcz_objr_eno").val(arrCode[Index]);		//확인확인자 사번
				return arrText[Index];
		}
		
		function doAction(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회
					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("com");
					$("form[name=ormsForm] [name=process_id]").val("ORCO011402");
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					break;
				case "sub": 
 					parent.DczSearchEndSub(
						parent.$("#sch_rtn_cntn").val($("#sch_rtn_cntn").val())
					); 
					break;
				case "cmp": 
					parent.DczSearchEndCmp(
						parent.$("#sch_rtn_cntn").val($("#sch_rtn_cntn").val())
					);
					break;	
				case "rtn": 
					parent.DczSearchEndRtn(
						parent.$("#sch_rtn_cntn").val($("#sch_rtn_cntn").val())
					);
					break;
				case "cncl": 
					if($("#cncl_yn").val()=="N"){ 
						alert("가장 최근의 확인자만 취소가 가능합니다.");
						return;
					}
					parent.DczSearchEndCncl(
					);
					break;
			}
		}
		function getParent() {
			$("#table_name").val(parent.$("#table_name").val());  				//테이블명
			$("#dcz_code").val(parent.$("#dcz_code").val());  	 				//코드명
			$("#rpst_id_column").val(parent.$("#rpst_id_column").val());		//컬럼명 
			$("#rpst_id").val(parent.$("#rpst_id").val());   					//컬럼데이터 
			$("#bas_pd_column").val(parent.$("#bas_pd_column").val());			//년월or회차컬럼명 
			$("#bas_pd").val(parent.$("#bas_pd").val());   						//년월or회차컬럼데이터 
			$("#dcz_objr_emp_auth").val(parent.$("#dcz_objr_emp_auth").val());  //조회권한 
			$("#sch_rtn_cntn").val(parent.$("#sch_rtn_cntn").val());  			//확인의견 
			$("#dcz_eno").val(parent.$("#dcz_eno").val());  					//dcz_eno컬럼 
			$("#brc_yn").val(parent.$("#brc_yn").val());  					//dcz_eno컬럼 
			$("#dcz_brc").val(parent.$("#dcz_brc").val());  					//dcz_eno컬럼 
     	}
		 
		function mySheet_OnRowSearchEnd(Row) {
		 var info = {"ComboCode":mySheet.GetCellValue(Row,"eno"),"ComboText":mySheet.GetCellValue(Row,"empnm")}
		 mySheet.CellComboItem(Row,"dcz_eno",info)
		 mySheet.SetRowEditable(Row,0);
		} 
		function mySheet_OnSearchEnd(code, message) {
		
			    if(code == 0) {
			    	mySheet.FitColWidth();
			    	<%if(mode.equals("1")){%>
			    	getInfoAuth();
			    	<%}%>
			        //조회 후 작업 수행
			        $("#cncl_yn").val("N");
			        if(mySheet.GetCellValue(2,"dcz_req_eno")=='<%=user_id%>') {
			        	$("#cncl").show();
					}
				} else {
					
				        alert("조회 중에 오류가 발생하였습니다..");
				}
			}
	</script>
</head>
<body>
<form name="ormsForm" method="post">
<input type="hidden" id="path" name="path" />             
<input type="hidden" id="process_id" name="process_id" />  
<input type="hidden" id="commkind" name="commkind" />       
<input type="hidden" id="method" name="method" />     
<input type="hidden" id="mode" name="mode" value="<%=mode%>" /> <!-- 확인 모드 상단에 설명 -->    
<input type="hidden" id="table_name" name="table_name" />     
<input type="hidden" id="dcz_code" name="dcz_code" />     
<input type="hidden" id="rpst_id_column" name="rpst_id_column" />     
<input type="hidden" id="rpst_id" name="rpst_id" />       
<input type="hidden" id="bas_pd_column" name="bas_pd_column" />       
<input type="hidden" id="bas_pd" name="bas_pd" />       
<input type="hidden" id="dcz_objr_emp_auth" name="dcz_objr_emp_auth" />           
<input type="hidden" id="dcz_eno" name="dcz_eno" />           
<input type="hidden" id="cncl_yn" name="cncl_yn" />           
<input type="hidden" id="brc_yn" name="brc_yn" />           
<input type="hidden" id="dcz_brc" name="dcz_brc" />           
	<article class="popup modal block">
		<div class="p_frame w1000">	
			<div class="p_head">
				<h1 class="title">확인</h1>
			</div>
			<div class="p_body">						
				<div class="p_wrap">
					<section class="box-grid">
						<div class="box-header">
							<h2 class="box-title">현황</h2>
						</div>
						<div class="wrap-grid h300">
							<script> createIBSheet("mySheet", "100%", "100%"); </script>
						</div>
					</section>
					<%if(!mode.equals("3")){%>
					<p>다중 확인요청 및 확인시 위 내용은 대표 한건만 출력 됩니다.개별 상세 내용은 화면에서 확인현황 버튼을 클릭해 주세요.</p>
					<section class="box box-grid">
						<div class="box-header">
							<h2 class="box-title">의견</h2>
						</div>
						<div class="wrap-table">
							<table>
								<colgroup>
									<col style="width: 150px;">
									<col>
								</colgroup>
								<tbody>
									<tr>
										<th scope="row">의견</th>
										<td>
											<textarea id="sch_rtn_cntn" class="form-control" placeholder="의견(반려 시, 반려의견)을 투입하세요."></textarea>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</section>
					<%} %>
				</div>						
			</div>
			<div class="p_foot">
				<div class="btn-wrap">
					<%if(mode.equals("1")){%>
					<button type="button" class="btn btn-primary" onclick="javascript:doAction('sub');">확인요청</button>
					<%}else if(mode.equals("2")){ %>
					<!-- 팀장, ORM전담, ORM 팀장 -->
 					<button type="button" class="btn btn-primary" onclick="javascript:doAction('cmp');">승인</button>
					<button type="button" class="btn btn-normal" onclick="javascript:doAction('rtn');">반려</button> 
					<!-- 팀장, ORM전담, ORM 팀장 //-->
					<%}else if(mode.equals("3")){ %>
		<!-- 팀장, ORM전담, ORM 팀장 -->
 					<button type="button" id="cncl" class="btn btn-primary" onclick="javascript:doAction('cncl');" style="display:none">확인요청 취소</button>
					<!-- 팀장, ORM전담, ORM 팀장 //-->
					<%}else{ %>
					<p>확인 모드 설정 필요 운영리스크 관리자에게 문의하세요</p>
					<%} %>
					<button type="button" class="btn btn-default btn-close">닫기</button>
				</div>
			</div>
			<button type="button" class="ico close fix btn-close"><span class="blind">닫기</span></button>	
		</div>
		<div class="dim p_close"></div>
	</article>
	</form>
	<!-- popup //-->
	<script>
		$(document).ready(function(){
			//닫기
			$(".btn-close").click( function(event){
				parent.$("#dcz_objr_eno").val("");		//확인자 사번 클리어
				parent.$("#sch_rtn_cntn").val($("#sch_rtn_cntn").val())
				//$("#winBuseo",parent.document).hide();
				$("#winDcz",parent.document).hide();
				event.preventDefault();
			});
		});
			
		function closePop(){
		    
			$("#winDcz",parent.document).hide();
		}
		//취소
		$(".btn-pclose").click( function(){
			closePop();
		});
		
		
	</script>	
</body>
</html>