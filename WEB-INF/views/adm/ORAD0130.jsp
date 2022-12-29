<%--
/*---------------------------------------------------------------------------
 Program ID   : ORAD0130.jsp
 Program name : ADMIN > 배치 > 배치작업조회
 Description  : 
 Programer    : 권성학
 Date created : 2021.05.27
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@page import="com.shbank.orms.comm.SysDateDao"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
	Vector batStscLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
	
	SysDateDao dao = new SysDateDao(request);
	String sch_inq_bas_dt = dao.getSysdate();//yyyymmdd
	SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");

	Calendar cal = Calendar.getInstance();
	cal.add(cal.DATE, -1);
	sch_inq_bas_dt = dateFormatter.format(cal.getTime());

	String txt_inq_bas_dt = sch_inq_bas_dt;
%>
<!DOCTYPE html>
<html lang="ko">
	<head>
		<%@ include file="../comm/library.jsp" %>
		
		<script>
			$(document).ready(function(){
				// ibsheet 초기화
				initIBSheet();
			});
			
			/*Sheet 기본 설정 */
			function initIBSheet() {
				//시트 초기화
				mySheet.Reset();
				
				var initData = {};
				
				initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden",MenuFilter:0 }; //좌측에 고정 컬럼의 수
				initData.Cols = [                                                                                                                                                                                            
					{Header:"상태",Type:"Status",	SaveName:"status",Hidden:true,Width:30,Align:"Center",MinWidth:10},
				 	{Header:"선택",Type:"CheckBox",SaveName:"ischeck",Hidden:false,Width:40,Align:"Center",MinWidth:15},
					{Header:"계열사",Type:"Text",Width:130,Align:"Center",SaveName:"grp_orgnm",MinWidth:60, Hidden:false, Edit:false, Wrap:true},
					{Header:"계열사코드",Type:"Text",Width:100,Align:"Center",SaveName:"grp_org_c",MinWidth:60, Hidden:true},
					{Header:"PGM ID",Type:"Text",Width:100,Align:"Center",SaveName:"btwk_id",MinWidth:60, Hidden:false, Edit:false, Wrap:true},
					{Header:"프로그램명",Type:"Text",Width:250,Align:"Left",SaveName:"btwknm",MinWidth:60, Hidden:false, Edit:false, Wrap:true},
					{Header:"주기",Type:"Combo",Width:40,Align:"Center",ComboText:"일|월|분기", ComboCode:"1|2|3",SaveName:"btwk_exe_fq_dsc",MinWidth:30, Hidden:false, Edit:false, Wrap:true},
					{Header:"기준일자",Type:"Text",Width:150,Align:"Left",SaveName:"btwk_bas_dt",MinWidth:60, Hidden:true, Edit:false, Wrap:true},
					{Header:"시작시각",Type:"Date",Format:"yyyy/MM/dd HH:mm:ss",Width:120,Align:"Center",SaveName:"btwk_st_dtm",MinWidth:60, Hidden:false, Edit:false, Wrap:true},
					{Header:"종료시각",Type:"Date",Format:"yyyy/MM/dd HH:mm:ss",Width:120,Align:"Center",SaveName:"btwk_ed_dtm",MinWidth:60, Hidden:false, Edit:false, Wrap:true},
					{Header:"관련테이블",Type:"Text",Width:250,Align:"Left",SaveName:"btwk_tblnm",MinWidth:60, Hidden:false, Edit:false, Wrap:true},
					{Header:"총건수",Type:"Int",Width:100,Align:"Right",SaveName:"btwk_all_prc_cn",MinWidth:60, Hidden:false, Edit:false, Wrap:true},
					{Header:"미처리건수",Type:"Int",Width:100,Align:"Right",SaveName:"btwk_err_cn",MinWidth:60, Hidden:false, Edit:false, Wrap:true},
					{Header:"처리건수",Type:"Int",Width:100,Align:"Right",SaveName:"btwk_nmlprc_cn",MinWidth:60, Hidden:false, Edit:false, Wrap:true},
					{Header:"상태",Type:"Text",Width:80,Align:"Center",SaveName:"btwk_stsc_nm",MinWidth:60, Hidden:false, Edit:false, Wrap:true},
					{Header:"선행작업유무",Type:"Text",Width:70,Align:"Center",SaveName:"wk_rel_btwkcn",MinWidth:60, Hidden:false, Edit:false, Wrap:true}
				];
				IBS_InitSheet(mySheet,initData);
				
				//필터표시
				//mySheet.ShowFilterRow();  
				
				//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
				mySheet.SetCountPosition(0);
				
				// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
				// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
				mySheet.SetSelectionMode(4);
				
				//마우스 우측 버튼 메뉴 설정
				//setRMouseMenu(mySheet);
				mySheet.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
				
				doAction('search');
				
			}
			
			function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
				//alert(Row);
			}
			
			function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
				$("#bat_pgid").val(mySheet.GetCellValue(Row,"btwk_id"));
				$("#btwk_st_dtm").val(mySheet.GetCellValue(Row,"btwk_st_dtm"));
				/*
				if(mySheet.GetCellProperty(Row, Col, "SaveName")=="wk_rel_btwkcn"&&mySheet.GetCellValue(Row,"wk_rel_btwkcn")=="Y"){
					if(mySheet.GetCellValue(Row,"btwk_id") == "" || mySheet.GetCellValue(Row,"btwk_st_dtm") == ""){
						alert("시작시각이 필요합니다.");
						return;
					}
					$("#batRelPrs").show();
					var f = document.ormsForm;
			        f.action="<%=System.getProperty("contextpath")%>/Jsp.do";
					f.path.value="/adm/ORAD0131";
					f.target = "ifrbatRelPrs";
					f.submit();
				}
				*/
				//alert(Row);
			}
			
			
			var row = "";
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
						
			/*Sheet 각종 처리*/
			function doAction(sAction) {
				switch(sAction) {
					case "search":  //데이터 조회
						//var opt = { CallBack : DoSearchEnd };
						var opt = {};
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("adm");
						$("form[name=ormsForm] [name=process_id]").val("ORAD013002");
						ormsForm.sch_inq_bas_dt.value = ormsForm.txt_inq_bas_dt.value.replace(/-/gi,"");
						
						mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
				
						break;
					case "down2excel":
						var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "배치작업.xlsx",  SheetName : "Sheet1"} ;
						
						mySheet.Down2Excel(params);
	
						break;
					case "execute_batch":
						/*
						for(var i=mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
							if(mySheet.GetCellValue(i,"ischeck") == "1" && mySheet.GetCellValue(i,"btwk_st_dtm") == ""){
								alert("시작시각이 필요합니다.");
								return;
							}
						} */
						mySheet.DoSave("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=adm&process_id=ORAD013003",{Quest:0});
						break;
				}
			}
	
			
			function mySheet_OnSearchEnd(code, message) {
	
				if(code != 0) {
					alert("조회 중에 오류가 발생하였습니다..");
				}else{
					/*
					for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
						if(mySheet.GetCellValue(i, "wk_rel_btwkcn")=="Y"){
							mySheet.SetCellFontColor(i, "wk_rel_btwkcn", "#2699FB");
							mySheet.SetCellCursor(i, "wk_rel_btwkcn", "Pointer");
						}
					}
					*/

				}
			}
			
			function mySheet_OnSaveEnd(code, msg) {
				
			    if(code >= 0) {
			        alert("배치재시작 등록되었습니다.");  // 저장 성공 메시지
			        //doAction("search");      
			    } else {
			        alert("배치재시작 등록실패했습니다."); // 저장 실패 메시지
			    }
			}
			
			function EnterkeySubmit(){
				if(event.keyCode == 13){
					doAction("search");
					return true;
				}else{
					return true;
				}
			}
	</script>
		
	</head>
	<body class="">
			<div class="container">
				<%@ include file="../comm/header.jsp" %>
				<div class="content">
				<form name="ormsForm">
					<input type="hidden" id="path" name="path" />
					<input type="hidden" id="process_id" name="process_id" />
					<input type="hidden" id="commkind" name="commkind" />
					<input type="hidden" id="method" name="method" />
					<input type="hidden" id="bat_pgid" name="bat_pgid" />
					<input type="hidden" id="btwk_st_dtm" name="btwk_st_dtm" />
					
					
					<!-- 조회 -->
					<div class="box box-search">
						<div class="box-body">
							<div class="wrap-search">
								<table>
									<colgroup>
										<col width="100" />
										<col width="200" />
										<col width="100" />
										<col width="210" />
										<col width="120" />
										<col />
									</colgroup>
									<tbody>
										<tr>
											<th>계열사</th>
											<td>
												<div class="input-group w150">
													<select name="sch_grp_org_c" id="sch_grp_org_c" class="form-control">
														<option value="">전체</option>
		<%
				for(int i=0;i<vAllGrpList.size();i++){
					HashMap hMap = (HashMap)vAllGrpList.get(i);
		%>
														<option value="<%=(String)hMap.get("grp_org_c")%>"><%=(String)hMap.get("grp_orgnm")%></option>
		<%
				}
		%>
													</select>										
												</div>
											</td colspan="5">
										</tr>
										<tr>
											<th scope="row">기준일</th>
											<td class=" form-inline">
												<span class="input-group">
													<input type="hidden" id="sch_inq_bas_dt" name="sch_inq_bas_dt" value="<%=sch_inq_bas_dt %>">
													<input type="text" id="txt_inq_bas_dt" name="txt_inq_bas_dt" value="<%=txt_inq_bas_dt %>" class="form-control w100" readonly/>
													<span class="input-group-btn">
														<button type="button" class="btn btn-default ico fl" onclick="showCalendar('yyyy-MM-dd','txt_inq_bas_dt');">
														<i class="fa fa-calendar"></i>
													</span>
													</button>
												</span>												
											</td>
											<th scope="row">실행주기</th>
											<td>
												<span class="select">
													<select class="form-control" id="sch_btwk_exe_fq_dsc" name="sch_btwk_exe_fq_dsc" >
														<option selected value="">전체</option>
														<option value="1">일</option>
														<option value="2">월</option>
														<option value="3">분기</option>
													</select>
												</span>
											</td>
											<th scope="row">상태</th>
											<td>
												<span class="select">
													<select class="form-control w150" id="sch_btwk_stsc" name="sch_btwk_stsc" >
													<option value="">전체</option>
	<%
			for(int i=0;i<batStscLst.size();i++){
				HashMap hMap = (HashMap)batStscLst.get(i);
	%>
														<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
	<%
			}
	%>
													</select>
												</span>
											</td>											
										</tr>
										<tr>
											<th scope="row">배치작업ID</th>
											<td><input type="text" class="form-control" id="sch_btwk_id" name="sch_btwk_id" onkeypress="EnterkeySubmit();" maxlength="20"></td>
											<th scope="row">배치작업명</th>
											<td><input type="text" class="form-control" id="sch_btwknm" name="sch_btwknm" onkeypress="EnterkeySubmit();" maxlength="50"></td>
											<th scope="row">선행작업유무</th>
											<td>
												<span class="select">
													<select class="form-control" id="sch_wk_rel_btwkcn" name="sch_wk_rel_btwkcn" >
														<option selected value="">전체</option>
														<option value="Y">Y</option>
														<option value="N">N</option>
													</select>
												</span>
											</td>
										</tr>	
									</tbody>
								</table>
							</div><!-- .box-search -->
						</div><!-- .box-body //-->
						<div class="box-footer">
							<button type="button" class="btn btn-xs btn-default" onclick="javascript:doAction('execute_batch');"><i class="fa fa-pencil"></i><span class="txt">실행</span></button>
							<button type="button" class="btn btn-xs btn-default" onclick="javascript:doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
							<div class="btn-group mt5">
							</div>
							<div>
								<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search');">조회</button>
							</div>
						</div>
					</div><!-- .box-search //-->
				</form>
					<!-- 조회 //-->
					<div class="box box-grid">
						<!-- /.box-header -->
						<div class="box-body">
							<div class="wrap-gridl h400">
								<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
							</div><!-- .wrap //-->
						</div><!-- .box-body //-->
					</div><!-- .box //-->
				</div><!-- .content //-->
			</div><!-- .container //-->		
	
	
	
	<!-- popup -->
	<div id="batRelPrs" class="popup modal"  style="background-color:transparent">
		<iframe name="ifrbatRelPrs" id="ifrbatRelPrs" src="about:blank" width="100%" height="100%" scrolling="no" frameborder="0" allowTransparency="true" ></iframe>
	</div>
	</body>
</html>