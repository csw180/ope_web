<%--
/*---------------------------------------------------------------------------
 Program ID   : ORLS0112.jsp
 Program name : 전체사건이관(인수부서)
 Description  : 
 Programer    : 김남원
 Date created : 2022.04.15
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%

//CommUtil.getCommonCode() -> 공통코드조회 메소드
Vector bfBrcLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(bfBrcLst==null) bfBrcLst = new Vector();
Vector trfPrgStsCLst = CommUtil.getCommonCode(request, "TRF_PRG_STSC");
if(trfPrgStsCLst==null) trfPrgStsCLst = new Vector();

HashMap hMapSession = (HashMap)request.getSession(true).getAttribute("infoH");

String auth_ids = hs.get("auth_ids").toString();
String[] auth_grp_id = auth_ids.replaceAll("\\[","").replaceAll("\\]","").replaceAll("\\s","").split(",");  

String orm_yn = "N";
for(int k=0;k<auth_grp_id.length;k++){
	if(auth_grp_id[k].equals("004")){
		orm_yn = "Y";
	}
}


%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	
	<script>
		$(document).ready(function(){
			$(function() {	
				
			});//ready end	
			

			// ibsheet 초기화
			initIBSheet();
			});
			
			/*Sheet 기본 설정 */
			function initIBSheet() {
				//시트 초기화
				mySheet.Reset();
				
				var initData = {};
				
				initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly }; //좌측에 고정 컬럼의 수
				initData.Cols = [
					{Header:"상태",					Type:"Status",	MinWidth:30,	Align:"center",SaveName:"status",Hidden:true	},
				 	{Header:"",						Type:"CheckBox",MinWidth:15,	Align:"Left",SaveName:"ischeck"},
					{Header:"그룹코드|그룹코드",				Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"grp_org_c", Hidden:true, Edit:false, Wrap:true},
					{Header:"관리번호|관리번호",			Type:"Text",	MinWidth:80,	Align:"Center",SaveName:"lshp_amnno", Edit:false, Wrap:true},
					{Header:"일련번호|일련번호",			Type:"Text",	MinWidth:80,	Align:"Center",	SaveName:"trf_brk_sqno", 		Edit:false, Wrap:true},
					{Header:"발생부서코드",			Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"ocu_brc", Hidden:true, Edit:false, Wrap:true},
					{Header:"발생부서|발생부서",		Type:"Text",	MinWidth:150,	Align:"Center",SaveName:"ocu_brnm", Edit:false, Wrap:true},
					{Header:"사건관리부서코드",			Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"amn_brc", Hidden:true, Edit:false, Wrap:true},
					{Header:"사건관리부서|사건관리부서",	Type:"Text",	MinWidth:150,	Align:"Center",SaveName:"amn_brnm", Hidden:true, Edit:false, Wrap:true},
					{Header:"이전사건보고부서코드",			Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"bf_brc", Hidden:true, Edit:false, Wrap:true},
					{Header:"이전사건보고부서|이전사건보고부서",Type:"Text",	MinWidth:150,	Align:"Center",SaveName:"bf_brnm", Edit:false, Wrap:true},
					{Header:"일자|발생",				Type:"Text",	MinWidth:80,	Align:"Center",SaveName:"ocu_dt", Edit:false, Wrap:true,Format:"yyyy-MM-dd"},
					{Header:"일자|발견",				Type:"Text",	MinWidth:80,	Align:"Center",SaveName:"dcv_dt", Edit:false, Wrap:true,Format:"yyyy-MM-dd"},
					{Header:"일자|입력",				Type:"Text",	MinWidth:80,	Align:"Center",SaveName:"rgs_dt", Edit:false, Wrap:true,Format:"yyyy-MM-dd"},
					{Header:"일자|이관요청",			Type:"Text",	MinWidth:100,	Align:"Center",SaveName:"trfrg_dt", Edit:false, Wrap:true,Format:"yyyy-MM-dd"},
					{Header:"사건제목|사건제목",			Type:"Text",	MinWidth:350,	Align:"Left",SaveName:"lshp_tinm", Edit:false, Wrap:true, EditLen:200},
					{Header:"사건상세내용|사건상세내용",				Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"lshp_dtl_cntn", Hidden:true, Edit:false, Wrap:true},
					{Header:"업무프로세스코드LV1",		Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"bsn_prss_c_lv1", Hidden:true, Edit:false, Wrap:true},
					{Header:"업무프로세스명|LV1",		Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"bsn_prsnm_lv1", Hidden:false, Edit:false, Wrap:true},
					{Header:"업무프로세스코드LV2",		Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"bsn_prss_c_lv2", Hidden:true, Edit:false, Wrap:true},
					{Header:"업무프로세스명|LV2",		Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"bsn_prsnm_lv2", Hidden:false, Edit:false, Wrap:true},
					{Header:"업무프로세스코드LV3",		Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"bsn_prss_c_lv3", Hidden:true, Edit:false, Wrap:true},
					{Header:"업무프로세스명|LV3",		Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"bsn_prsnm_lv3", Hidden:false, Edit:false, Wrap:true},
					{Header:"업무프로세스코드LV4",		Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"bsn_prss_c_lv4", Hidden:true, Edit:false, Wrap:true},
					{Header:"업무프로세스명|LV4",		Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"bsn_prsnm_lv4", Hidden:false, Edit:false, Wrap:true},
					{Header:"원인유형코드LV1",			Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"cas_tpc_lv1", Hidden:true, Edit:false, Wrap:true},
					{Header:"원인유형|LV1",			Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"cas_tpnm_lv1", Hidden:false, Edit:false, Wrap:true},
					{Header:"원인유형코드LV2",			Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"cas_tpc_lv2", Hidden:true, Edit:false, Wrap:true},
					{Header:"원인유형|LV2",			Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"cas_tpnm_lv2", Hidden:false, Edit:false, Wrap:true},
					{Header:"원인유형코드LV3",			Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"cas_tpc_lv3", Hidden:true, Edit:false, Wrap:true},
					{Header:"원인유형|LV3",			Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"cas_tpnm_lv3", Hidden:false, Edit:false, Wrap:true},
					{Header:"사건유형코드LV1",			Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"hpn_tpc_lv1", Hidden:true, Edit:false, Wrap:true},
					{Header:"사건유형|LV1",			Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"hpn_tpnm_lv1", Hidden:false, Edit:false, Wrap:true},
					{Header:"사건유형코드LV2",			Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"hpn_tpc_lv2", Hidden:true, Edit:false, Wrap:true},
					{Header:"사건유형|LV2",			Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"hpn_tpnm_lv2", Hidden:false, Edit:false, Wrap:true},
					{Header:"사건유형코드LV3",			Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"hpn_tpc_lv3", Hidden:true, Edit:false, Wrap:true},
					{Header:"사건유형|LV3",			Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"hpn_tpnm_lv3", Hidden:false, Edit:false, Wrap:true},
					{Header:"영향유형코드LV1",			Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"ifn_tpc_lv1", Hidden:true, Edit:false, Wrap:true},
					{Header:"영향유형LV1",				Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"ifn_tpnm_lv1", Hidden:true, Edit:false, Wrap:true},
					{Header:"영향유형코드LV2",			Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"ifn_tpc_lv2", Hidden:true, Edit:false, Wrap:true},
					{Header:"영향유형LV2",				Type:"Text",	MinWidth:150,	Align:"Left",SaveName:"ifn_tpnm_lv2", Hidden:true, Edit:false, Wrap:true},
					{Header:"소송여부|소송여부",			Type:"Text",	MinWidth:80,	Align:"Center",SaveName:"lss_yn", Hidden:false, Edit:false, Wrap:true},
					{Header:"진행상태|진행상태코드",		Type:"Text",	MinWidth:100,	Align:"Left",SaveName:"trf_prg_stsc", Hidden:true, Edit:false, Wrap:true},
					{Header:"진행상태|진행상태",			Type:"Text",	MinWidth:100,	Align:"Center",SaveName:"trf_prg_stscnm", Hidden:false, Edit:false, Wrap:true},
				];
				
				IBS_InitSheet(mySheet,initData);
				
				//필터표시
				//mySheet.ShowFilterRow();  
				
				//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
				mySheet.SetCountPosition(3);
				
				// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
				// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결\되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				mySheet.SetSelectionMode(4);
				
				//마우스 우측 버튼 메뉴 설정
				//setRMouseMenu(mySheet);
				
				doAction('search');
				
			}
			
			function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
				//alert(Row);
				if(Row >= mySheet.GetDataFirstRow()){
					$("#lshp_amnno").val(mySheet.GetCellValue(Row,"lshp_amnno"));
					doAction('mod');
					
				}
			}
			
			function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
				//alert(Row);
				if(Row >= mySheet.GetDataFirstRow()){
					$("#lshp_amnno").val(mySheet.GetCellValue(Row,"lshp_amnno"));
				}
			}
			
			
			var row = "";
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
						
			/*Sheet 각종 처리*/
			function doAction(sAction) {
				switch(sAction) {
					case "search":  //데이터 조회
						//var opt = { CallBack : DoSearchEnd };
						var length = <%=bfBrcLst.size() %>;
						var bf_brc = [];
						var html = "";
						var opt = {};
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("los");
						$("form[name=ormsForm] [name=process_id]").val("ORLS011202");
						ormsForm.st_dt.value = ormsForm.txt_st_dt.value.replace(/-/gi,"");
						ormsForm.ed_dt.value = ormsForm.txt_ed_dt.value.replace(/-/gi,"");

						for(var i=0; i<length; i++){
							if($("input:checkbox[id='bf_brc"+(i+1)+"']").is(":checked")==true){
								bf_brc.push($("input:checkbox[id='bf_brc"+(i+1)+"']:checked").val());
							}
						}
						html += "<input type='hidden' id='bf_brc' name='bf_brc' value='"+bf_brc+"' >"
						
						$("form[name=ormsForm] [id=hd_bf_brc]").html(html);
						
						mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm));
						break;
					case "confimr":		//이관 확인처리
						var cnt = 0;
						var com = true;
						for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
							if(mySheet.GetCellValue(i, "ischeck")=="1"){				
								cnt++;
							}
						}
						for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
							if(mySheet.GetCellValue(i, "ischeck")=="1"&&mySheet.GetCellValue(i, "trf_prg_stsc")!="02"){				//이미요청된 사건 선택시 경고
								alert("이관 요청중이 아닌 사건이 있습니다.");
								com = false;
								return;
							}
						}
						if(cnt==0){
							alert("이관확인할 사건을 선택해주세요.");
							return;
						}else{
							if(com){
								mySheet.DoSave("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=los&process_id=ORLS011203&amn_brc="+$("#amn_brc").val());
							}
						}
						
						break; 
					case "rjct":		//이관 거절처리
						var cnt = 0;
						var com = true;
						for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
							if(mySheet.GetCellValue(i, "ischeck")=="1"){				
								cnt++;
							}
						}
						for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
							if(mySheet.GetCellValue(i, "ischeck")=="1"&&mySheet.GetCellValue(i, "trf_prg_stsc")!="02"){				//이미요청된 사건 선택시 경고
								alert("이관 요청중이 아닌 사건이 있습니다.");
								com = false;
								return;
							}
						}
						if(cnt==0){
							alert("이관거절할 사건을 선택해주세요.");
							return;
						}else{
							if(com){
								mySheet.DoSave("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=los&process_id=ORLS011204&amn_brc="+$("#amn_brc").val());
							}
						}
						
						break; 
					case "mod":		//수정 팝업
						if($("#lshp_amnno").val() == ""){
							alert("대상 손실사건을 선택하세요.");
							return;
						}else{
							showLoadingWs();
							//$("#ifrLossMod").attr("src","about:blank");
							//$("#winLossMod").show();
							var f = document.ormsForm;
							f.method.value="Main";
					        f.commkind.value="los";
					        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
					        f.process_id.value="ORLS010201";
							f.target = "ifrLossMod";
							f.submit();
						}
						break; 
					case "down2excel":
						var downCols = "3|5|7|9|10|11|12|13|14|15|17|19|21|23|25|27|29|31|33|35|37|39|42";
						
						mySheet.Down2Excel({FileName:"사건이관(인수부서).xlsx", Merge:1, DownCols:downCols});
						
						break;
				}
			}
	
			
			function mySheet_OnSearchEnd(code, message) {
	
				if(code != 0) {
					alert("조회 중에 오류가 발생하였습니다..");
				}else{
				}
			}
			
			function mySheet_OnSaveEnd(code, msg) {
	
			    if(code >= 0) {
			        alert("완료 되었습니다.");  // 저장 성공 메시지
			        doAction("search");      
			    } else {
			        alert("실패했습니다."); // 저장 실패 메시지
			    }
			}
			function multiChk(){
				var length = <%=bfBrcLst.size() %>;
				for(var i=0; i<length; i++){
					if($("input:checkbox[id='mulChk"+(i+1)+"']").is(":checked")==true){
						$("input:checkbox[id='bf_brc"+(i+1)+"']").prop('checked', true);
					}
					if($("input:checkbox[id='mulChk"+(i+1)+"']").is(":checked")==false){
						$("input:checkbox[id='bf_brc"+(i+1)+"']").prop('checked', false);
					}
				}
			}
			

			
	</script>
		
</head>
<body>
	<div class="container">
		<%@ include file="../comm/header.jsp" %>
		<div class="content">
		<form name="ormsForm">
			<input type="hidden" id="path" name="path" />
			<input type="hidden" id="process_id" name="process_id" />
			<input type="hidden" id="commkind" name="commkind" />
			<input type="hidden" id="method" name="method" />
			<input type="hidden" id="role_id" name="role_id" value="nml  " />
			<input type="hidden" id="lshp_amnno" name="lshp_amnno" value="" />
			
			<!-- 조회 -->
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th>사건발생법인</th>
									<td>
										<select class="form-control w220" id="grp_org_c" name="grp_org_c" disabled>
											<option value="">전체</option>
<%
		for(int i=0;i<vGrpList.size();i++){
			HashMap hMap = (HashMap)vGrpList.get(i);
			if(((String)hMap.get("grp_org_c")).equals(grp_org_c)){
%>
											<option value="<%=(String)hMap.get("grp_org_c")%>" selected><%=(String)hMap.get("grp_orgnm")%></option>
<%					
			}else{
%>
											<option value="<%=(String)hMap.get("grp_org_c")%>"><%=(String)hMap.get("grp_orgnm")%></option>
<%					
			}
%>
<%
		}
%>
										</select>
									</td>	
									<th>기간</th>
									<td>
										<div class="form-inline">
											<span class="select">
												<select class="form-control w150" id="dt_knd" name="dt_knd">
													<option value="">선택</option>
													<option value="oc">발생일자</option>
													<option value="dc">발견일자</option>
													<option value="rg">입력일자</option>
												</select>
											</span>
											<span class="input-group">
												<input type="hidden" id="st_dt" name="st_dt">
												<input type="text" id="txt_st_dt" name="txt_st_dt" class="form-control w100" disabled/>
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico fl" onclick="showCalendar('yyyy-MM-dd','txt_st_dt');">
														<i class="fa fa-calendar"></i>
													</button>
												</span>
											</span>
											<span> ~ </span>
											<span class="input-group">
												<input type="hidden" id="ed_dt" name="ed_dt">
												<input type="text" id="txt_ed_dt" name="txt_ed_dt" class="form-control w100" disabled/>
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico fl" onclick="showCalendar('yyyy-MM-dd','txt_ed_dt');">
														<i class="fa fa-calendar"></i>
													</button>
												</span>
											</span>
										</div>
									</td>
								</tr>
								<tr>
									<th>보고부서</th>
									<td>
										<input type="hidden" id="rpt_brc" name="rpt_brc" class="form-control w70p fl" value="<%=brc %>" disabled/>
										<input type="text" id="rpt_brnm" name="rpt_brnm" class="form-control w70p fl" value="<%=brnm %>" disabled/>
									</td>
									<th>이관진행상태</th>
									<td>
										<div class="form-inline">
											<span class="select">
												<select class="form-control w220" id="trf_prg_stsc" name="trf_prg_stsc" >
												<option value="">전체</option>
<%
	for(int i=0;i<trfPrgStsCLst.size();i++){
		HashMap hMap = (HashMap)trfPrgStsCLst.get(i);
		if("02".equals((String)hMap.get("intgc"))){
%>
												<option value="<%=(String)hMap.get("intgc")%>" selected><%=(String)hMap.get("intg_cnm")%></option>
<%
		}else{
%>
												<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
<%				
		}
	}
%>
												</select>
											</span>
											<button class="btn-tip tipOpen" type="button" tip="tip"><span class="blind">Help</span></button>
										</div>	
									</td>
								</tr>
								<tr>	
									<th>이전사건보고부서</th>
									<td colspan="7">
										<dl class="dropdown dMSC w100p"> 
											<dt class="select"><a href="#"> <span class="hida">선택</span> <p class="multiSel"></p></a></dt>
											<dd>
												<div class="mutliSelect" onchange="multiChk()">
													<ul>
<%
for(int i=0; i<bfBrcLst.size(); i++){
	HashMap hMap = (HashMap)bfBrcLst.get(i);
%>
														<li>
															<input type="checkbox" id="mulChk<%=i+1%>" name="mulChk" value="<%=(String)hMap.get("bf_brnm") %>"><label for="mulChk<%=i+1%>"></label><%=(String)hMap.get("bf_brnm") %>
														</li>
<%
}
%>															
														
													</ul>
												</div>
											</dd>
										</dl>
										<dl class="dropdown dMSC w200" style="display:none"> 
											<dt class="select"><a href="#"> <span class="hida">선택</span> <p class="multiSel"></p></a></dt>
											<dd>
												<div class="mutliSelect">
													<ul>
<%
for(int i=0; i<bfBrcLst.size(); i++){
	HashMap hMap = (HashMap)bfBrcLst.get(i);
%>
														<li>
															<input type="checkbox" id="bf_brc<%=i+1%>" name="hd_bf_brc" value="<%=(String)hMap.get("bf_brc") %>"><label for="bf_brc<%=i+1%>"></label><%=(String)hMap.get("bf_brc") %>
														</li>
<%
}
%>															
														
													</ul>
												</div>
											</dd>
										</dl>
									  <input type="hidden" id="amn_brc" name="amn_brc" value="<%=(String)hMapSession.get("brc") %>"/>
									</td>
								</tr>
							</tbody>
						</table>
					</div><!-- .box-search -->
				</div><!-- .box-body //-->
				<div class="box-footer">
					<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search');">조회</button>
				</div>
			</div><!-- .box-search //-->
		</form>
			<!-- 조회 //-->
			<div class="box box-grid">
				<div class="box-header">
					<div class="area-tool">
						<button type="button" class="btn btn-xs btn-default" onclick="javascript:doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
					</div>
				</div>
				<!-- /.box-header -->
				<div class="box-body">
					<div class="wrap-grid h400">
						<script> createIBSheet("mySheet", "100%", "100%"); </script>
					</div><!-- .wrap //-->
				</div><!-- .box-body //-->
				<div class="box-footer">
					<div class="btn-wrap">
						<button type="button" class="btn btn-primary" onclick="doAction('confimr')">이관확인</button>
						<button type="button" class="btn btn-default" onclick="doAction('rjct')">이관거절</button>
					</div>
				</div><!-- .box-footer //-->
			</div><!-- .box //-->
		</div><!-- .content //-->
	</div><!-- .container //-->		
	
	
	
	<!-- popup -->
	<div id="tip" class="tip-wrap">
		<article class="tip-inner">
			
			<table class="table-tip">
				<colgroup>
					<col style="width: 150px;">
					<col>
				</colgroup>
				<thead>
					<tr>
						<th scope="col">이관진행상태</th>
						<th scope="col">설명</th>
					</tr>
				</thead>
				<tbody>
					<tr>
						<td>-</td>
						<td>사건 이관 관련 아무런 action이 없는 default상태(기요청한 건에 대한 이관요청취소 시 해당 상태로 표시)</td>
					</tr>
					<tr>
						<td>이관요청중</td>
						<td>인계부서에서 인수부서로 특정 손실사건에 대한 이관을 요청한 상태</td>
					</tr>
					<tr>
						<td>이관거절</td>
						<td>인계부서가 이관요청한 손실사건을 인수부서에서 '이관거절'한 상태</td>
					</tr>
				</tbody>
			</table>
		</article>
	</div>
	<div id="winLossMod" class="popup modal">
		<iframe name="ifrLossMod" id="ifrLossMod" src="about:blank"></iframe>
	</div>
	<%@ include file="../comm/OrgInfP.jsp" %> <!-- 부서 공통 팝업 -->
	
	<script>
		// 발생부서검색 완료
		function ocuOrgSearchEnd(brc, brnm){
			$("#ocu_brc").val(brc);
			$("#ocu_brnm").val(brnm);
			$("#winBuseo").hide();
		}
		// 발생부서검색 완료
		function bfOrgSearchEnd(brc, brnm){
			$("#bf_brc").val(brc);
			$("#bf_brnm").val(brnm);
			$("#winBuseo").hide();
		}
		// 관리부서검색 완료
		function amnOrgSearchEnd(brc, brnm){
			$("#amn_brc").val(brc);
			$("#amn_brnm").val(brnm);
			$("#winBuseo").hide();
		}
		// 이관부서검색 완료
		function trfOrgSearchEnd(brc, brnm){
			$("#trf_brc").val(brc);
			$("#trf_brnm").val(brnm);
			$("#winBuseo").hide();
		}
			
		$(document).ready(function(){
			
			//열기
			$(".btn-open").click( function(){
				$(".popup").show();
			});
			//닫기
			$(".btn-close").click( function(event){
				$(".popup",parent.document).hide();
				event.preventDefault();
			});
			// dim (반투명 ) 영역 클릭시 팝업 닫기 
			$('.popup >.dim').click(function () {  
				$(".popup",parent.document).hide();
			});
		});
			
	</script>
</body>
</html>