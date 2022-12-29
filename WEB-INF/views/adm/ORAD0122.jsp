<%--
/*---------------------------------------------------------------------------
 Program ID   : ORAD0122.jsp
 Program name : ADMIN > 게시판 > 공지사항, 사용자게시판
 Description  : 
 Programer    : 권성학
 Date created : 2021.05.18
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ page import="com.shbank.orms.comm.SysDateDao"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
	String auth_ids = hs.get("auth_ids").toString();
	String[] auth_grp_id = auth_ids.replaceAll("\\[","").replaceAll("\\]","").replaceAll("\\s","").split(",");  
	
	String aadm_yn = "N";
	for(int k=0;k<auth_grp_id.length;k++){
		if("001".equals(auth_grp_id[k]) || "002".equals(auth_grp_id[k])){
			aadm_yn = "Y";
		}
	}
	
	DynaForm form = (DynaForm)request.getAttribute("form");
	String blbd_dsc = (String)form.get("blbd_dsc");
	
	SysDateDao dao = new SysDateDao(request);
	String today = dao.getSysdate(); //오늘날짜(yyyymmdd)
	String ed_dt = today.substring(0,4)+"-"+today.substring(4,6)+"-"+today.substring(6,8);
	
	Calendar cal = Calendar.getInstance();
	cal.add(cal.YEAR, -1);
	cal.add(cal.DATE, 1);
	
	SimpleDateFormat dateFormatter = new SimpleDateFormat("yyyy-MM-dd");
	String st_dt = dateFormatter.format(cal.getTime());
	
	System.out.println("aadm_yn = "+aadm_yn);
	System.out.println("blbd_dsc = "+blbd_dsc);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script>
		
		$(document).ready(function(){
			if("<%=blbd_dsc%>" == "1"){
				if("<%=aadm_yn%>" == "Y"){
					document.getElementById('add_btn').style.display = 'block';
				}
			}else{
				document.getElementById('add_btn').style.display = 'block';
			}
			// ibsheet 초기화
			initIBSheet1();
		});
		/*Sheet1 기본 설정 */
		function initIBSheet1() {
			mySheet1.Reset();
			
			var initData1 = {};
			
			initData1.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden",MenuFilter:0 }; //좌측에 고정 컬럼의 수
			initData1.Cols = [
				{Header:"번호",			Type:"Seq",		SaveName:"seq",				Hidden:false,	Width:20,	Align:"Center"						},
			    {Header:"게시판구분코드",	Type:"Text",	SaveName:"blbd_dsc",		Hidden:true,	Width:0,	Align:"Left"						},
			    {Header:"게시판일련번호",	Type:"Text",	SaveName:"blbd_sqno",		Hidden:true,	Width:0,	Align:"Left"						},
			    {Header:"제목",			Type:"Text",	SaveName:"blbd_tinm",		Hidden:false,	Width:150,	Align:"Left"						},
			    {Header:"등록부서코드",		Type:"Text",	SaveName:"blbd_rg_brc",		Hidden:true,	Width:0,	Align:"Left"						},
			    {Header:"부서명",			Type:"Text",	SaveName:"blbd_rg_brnm",	Hidden:true,	Width:0,	Align:"Left"						},
			    {Header:"등록자번호",		Type:"Text",	SaveName:"bbrd_rgmn_eno",	Hidden:true,	Width:0,	Align:"Left"						},
			    {Header:"등록일",			Type:"Date",	SaveName:"bbrd_rg_dt",		Hidden:false,	Width:30,	Align:"Center",	Format:"yyyy-MM-dd"	},
			    {Header:"게시자",			Type:"Text",	SaveName:"bbrd_rgmn_enm",	Hidden:false,	Width:40,	Align:"Center"						}
 			];
			
			IBS_InitSheet(mySheet1,initData1);
			
			//필터표시
			//mySheet1.ShowFilterRow();  
			
			mySheet1.SetEditable(0); //수정불가
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet1.SetCountPosition(3);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet1.SetSelectionMode(4);
			
			//최초 조회시 포커스를 감춘다.
			mySheet1.SetFocusAfterProcess(0);

			doAction('search');
			
		}
		function mySheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) { 
			if(Row >= mySheet1.GetDataFirstRow()){
				$("#blbd_sqno").val(mySheet1.GetCellValue(Row, "blbd_sqno"));
			}
			if(mySheet1.GetCellProperty(Row, Col, "SaveName")=="blbd_tinm"){
				var f = document.ormsForm;
				f.method.value="Main";
		        f.commkind.value="adm";
		        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
		        f.process_id.value="ORAD012301";
				f.target = "ifrDtl";
				f.submit();
			}
		}
		
		function mySheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
		}
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";

		function doAction(sAction) {
			switch(sAction) {
				case "search":  //데이터 조회
					//var opt = { CallBack : DoSearchEnd };
					ormsForm.sch_st_dt.value = ormsForm.txt_st_dt.value.replace(/-/gi,"");
					ormsForm.sch_ed_dt.value = ormsForm.txt_ed_dt.value.replace(/-/gi,"");

					if(ormsForm.sch_st_dt.value > ormsForm.sch_ed_dt.value){
						alert("조회 시작일시가 조회 종료일시보다 크게 설정되었습니다.\n날짜를 다시 설정해주세요.");
						return;
					}

					var opt = {};
					$("form[name=ormsForm] [name=method]").val("Main");
					$("form[name=ormsForm] [name=commkind]").val("adm");
					$("form[name=ormsForm] [name=process_id]").val("ORAD012202");
					mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					break;
				case "add":		//신규등록 팝업
					$("#ifrDtl").attr("src","about:blank");
					//$("#winBlbdDtl").show();
					$("#blbd_sqno").val("");
					setTimeout(addBbrd,1);
					break; 
				case "del":		//삭제 처리
					if(!confirm("선택한 게시물을 삭제 하시겠습니까?")) return;
					mySheet1.DoSave("<%=System.getProperty("contextpath")%>/comMain.do?method=Main&commkind=adm&process_id=ORAD012203",{Quest:0});
				break; 
			}
		}
		
		function addBbrd(){
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="adm";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORAD012301";
			f.target = "ifrDtl";
			f.submit();
		}
		
		function mySheet1_OnSearchEnd(code, message) {
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
			}
		}
		function mySheet1_OnSaveEnd(code, msg) {
		    if(code >= 0) {
		        //alert("완료.");  // 저장 성공 메시지
		        doAction("search");      
		    } else {
		        alert("처리 중 오류가 발행했습니다."); // 저장 실패 메시지
		    }
		}
		function EnterkeySubmit(){
			if(event.keyCode == 13){
				doAction('search');
				return true;
			}else{
				return true;
			}
		}

	</script>
</head>
<body onkeyPress="return EnterkeyPass()">
	<div class="container">
		<%@ include file="../comm/header.jsp" %>

		<!-- content -->
		<div class="content">
			<form name="ormsForm" method="post">
            <input type="hidden" id="path" name="path" />
            <input type="hidden" id="process_id" name="process_id" />
            <input type="hidden" id="commkind" name="commkind" />
            <input type="hidden" id="method" name="method" />
            <input type="hidden" id="blbd_dsc" name="blbd_dsc" value="<%=blbd_dsc%>"/>
            <input type="hidden" id="blbd_sqno" name="blbd_sqno" />

			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tbody>
								<tr>
									<th>등록일시</th>
									<td>
										<div class="form-inline">
											<div class="input-group">
												<input type="hidden" id="sch_st_dt" name="sch_st_dt">
												<input type="text" id="txt_st_dt" name="txt_st_dt" class="form-control w100" value="<%=st_dt%>" readonly/>
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" onclick="showCalendar('yyyy-MM-dd','txt_st_dt');">
														<i class="fa fa-calendar"></i>
													</button>
												</span>
											</div>
											<div class="input-group">
												<div class="input-group-addon"> ~ </div>
												<input type="hidden" id="sch_ed_dt" name="sch_ed_dt">
												<input type="text" id="txt_ed_dt" name="txt_ed_dt" class="form-control w100" value="<%=ed_dt%>" readonly/>
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" onclick="showCalendar('yyyy-MM-dd','txt_ed_dt');">
														<i class="fa fa-calendar"></i>
													</button>
												</span>
											</div>
										</div>
									</td>
									<th scope="row"><label for="input01" class="control-label">문서제목</label></th>
										<td colspan="3">
											<input type="text" class="form-control w300 fl" id="sch_tinm" name="sch_tinm" value="" placeholder="" onkeypress="EnterkeySubmit();">
										</td>
									<th scope="row"><label for="input01" class="control-label">게시자명</label></th>
										<td colspan="3">
											<input type="text" class="form-control w300 fl" id="sch_enm" name="sch_enm" value="" placeholder="" onkeypress="EnterkeySubmit();">
										</td>
								</tr>
							</tbody>
						</table>
					</div>
				</div>
				<div class="box-footer">
					<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search');">조회</button>
				</div>
			</div>
			<div class="box box-grid">
				<div class="box-header">
					<div class="area-tool">
						<button type="button" class="btn btn-default btn-xs" id="add_btn" name="add_btn" style="display:none" onClick="javascript:doAction('add')">
							<i class="fa fa-plus"></i>
							<span class="txt">신규등록</span>
						</button>
					</div>
				</div>
				<div class="box-body">
					<div class="wrap-grid h450">
						<script> createIBSheet("mySheet1", "100%", "100%"); </script>
					</div>
				</div>
			</div>
			</form>
		</div>
		<!-- content //-->
	</div>
	<!-- popup -->
	<div id="winBlbdDtl" class="popup modal">
		<iframe name="ifrDtl" id="ifrDtl" src="about:blank"></iframe>
	</div>
</body>
</html>