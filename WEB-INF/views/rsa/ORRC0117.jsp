<%--
/*---------------------------------------------------------------------------
 Program ID   : ORRC0117.jsp
 Program name : 동일평가비율확인및재평가요청
 Description  : 화면정의서 RCSA-11
 Programer    : 박승윤
 Date created : 2022.10.06
 ---------------------------------------------------------------------------*/
--%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="com.shbank.orms.comm.SysDateDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
String bas_ym = CommUtil.getResultString(request, "grp01", "unit00", "bas_ym");
String bas_ym_nm = CommUtil.getResultString(request, "grp01", "unit01", "bas_ym_nm");
DynaForm form = (DynaForm)request.getAttribute("form");

/*
	rcsa_menu_dsc 
  1 : 부서
  2 : ORM
*/

String init_brc = "";
String init_brnm = "";

if( form.get("rcsa_menu_dsc").equals("1") ){
	init_brc = brc;
	init_brnm = brnm;
}

%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="../comm/library.jsp" %>
	<script src="<%=System.getProperty("contextpath")%>/js/OrgInfP.js"></script>
	<script language="javascript">
	
	$(document).ready(function(){
		// ibsheet 초기화
		initIBSheet();
	});
	
	/*Sheet 기본 설정 */
	function initIBSheet() {
		//시트 초기화
		mySheet.Reset();
		
		var initData = {};
		
		initData.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; 
		initData.Cols = [
		     			{Header:"선택",Type:"CheckBox",Width:50,Align:"Left",SaveName:"ischeck",MinWidth:50,Edit:1},
		    			{Header:"사무소코드",Type:"Text",Width:0,Align:"Center",SaveName:"brc",MinWidth:60, Hidden:true},
		    			{Header:"리스크평가기준년월",Type:"Text",Width:0,Align:"Center",SaveName:"bas_ym",MinWidth:60, Hidden:true},
		    			{Header:"평가부서",Type:"Text",Width:100,Align:"Center",SaveName:"dept_brnm",MinWidth:100,Edit:0},
						{Header:"팀",Type:"Text",Width:100,Align:"Center",SaveName:"brnm",MinWidth:100,Edit:0},
						{Header:"개인번호",Type:"Text",Width:100,Align:"Center",SaveName:"vlr_eno",MinWidth:60,Edit:0},
		    			{Header:"성명",Type:"Text",Width:100,Align:"Center",SaveName:"vlr_nm",MinWidth:60,Edit:0},
		    			{Header:"총 평가 항목수",Type:"Text",Width:100,Align:"Center",SaveName:"tot_evl_cnt",MinWidth:60,Edit:0},
		    			{Header:"동일 평가 건 수",Type:"Text",Width:100,Align:"Center",SaveName:"eq_evl_cnt",MinWidth:60,Edit:0},
		    			{Header:"동일 평가 비율",Type:"Text",Width:100,Align:"Center",SaveName:"eq_evl_rat",MinWidth:60,Edit:0},
		    			{Header:"동일 평가 리스크ID",Type:"Text",Width:100,Align:"Center",SaveName:"rkp_group",MinWidth:60,Edit:0}
		];

		IBS_InitSheet(mySheet,initData);
		
		//필터표시
		//mySheet.ShowFilterRow();  
		
		//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
		//mySheet.SetCountPosition(0);
		
		// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
		// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
		mySheet.SetSelectionMode(4);
		
		mySheet.FitColWidth();
		//마우스 우측 버튼 메뉴 설정
		//setRMouseMenu(mySheet);
		
//		doAction('search');

		
	}
	
	var row = "";
	var url = "<%=System.getProperty("contextpath")%>/comMain.do";
	
	/*Sheet 각종 처리*/
	function doAction(sAction) {

		switch(sAction) {
			case "search":  //데이터 조회

				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("rsa");
				$("form[name=ormsForm] [name=process_id]").val("ORRC011702");

				mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
				break;
				
			case "toevl":  //재평가요청
				
				
				var ckcnt = "";
		  
				 for(var i = mySheet.GetDataFirstRow(); i<=mySheet.GetDataLastRow(); i++){
						if(mySheet.GetCellValue(i, "ischeck")=="1"){				
							ckcnt++;
						}
					} 
			     if(ckcnt==0){
			     	alert("재평가 대상을 선택해 주세요.");
			     	return false;
	    		}	
				doEvlSend();
				break;

			case "down2excel":
				setExcelFileName("RCSA동일평가비율확인.xlsx");
				setExcelDownCols("4|5|6|7|8|9");
				mySheet.Down2Excel(excel_params);

				break;

		}
	}
	
	//재평가요청
	function doEvlSend() {
		mySheet.DoSave(url, { Param : "method=Main&commkind=rsa&process_id=ORRC011703&dcz_dc="+$("#dcz_dc").val()+"&dcz_rmk_c="+$("#dcz_rmk_c").val()+"&reevl_yn_chk="+$("#reevl_yn_chk").val(), Col : 0 });
	}
	


	function mySheet_OnSearchEnd(code, message) {

	    if(code == 0) {
	    	mySheet.FitColWidth();
	        //조회 후 작업 수행
	
		} else {
	
		        alert("조회 중에 오류가 발생하였습니다..");
		        
	
		}

	}
	
	function mySheet_OnSaveEnd(code, msg) {
	    if(code >= 0) {
	    	
	    	
	    	alert("저장 하였습니다.");   
	    	doAction('search');   

	    } else {

	        alert(msg); // 저장 실패 메시지

	    }
	}
	
	var init_flag = false;
	function org_popup(){
		schOrgPopup("brnm", "orgSearchEnd");
		if($("#brnm").val() == "" && init_flag){
			$("#ifrOrg").get(0).contentWindow.doAction("search");
		}
		init_flag = false;
	}
	
	// 부서검색 완료
	function orgSearchEnd(brc, brnm){
		if(brc=="") init_flag = true;
		$("#brc").val(brc);
		$("#brnm").val(brnm);
		//$("#winBuseo").removeClass("block");
		$("#winBuseo").hide();
		//doAction('search');
	}
	
	
	</script>
	</head>
	<body class="">
		<!-- iframe 영역 -->
		<div class="container">
			<%@ include file="../comm/header.jsp" %>
			
			<div class="content">
				<!-- .search-area 검색영역 -->
				<form name="ormsForm">
					<input type="hidden" id="path" name="path" />
					<input type="hidden" id="process_id" name="process_id" />
					<input type="hidden" id="commkind" name="commkind" />
					<input type="hidden" id="method" name="method" />				
					<input type="hidden" id="dcz_rmk_c" name="dcz_rmk_c" value="03"/>
					<input type="hidden" id="reevl_yn_chk" name="reevl_yn_chk" value="Y"/>
					<input type="hidden" id="dcz_dc" name="dcz_dc" value="02"/>
				<!-- .search-area 검색영역 -->
				<div class="box box-search">
					<div class="box-body">
						<div class="wrap-search">
							<table>

								<tbody>
									<tr>
										<th scope="row">평가기준년월</th>
										<td>
											<div class="input-group w150">
											<input type="hidden" id="bas_ym" name="bas_ym" value="<%=bas_ym%>">
											<input type="text" id="info_bas_ym" name="info_bas_ym" class="form-control" value="<%=bas_ym_nm%>" readonly>
											</div>
										</td>
										<th scope="row"><label for="input03" class="control-label">검증대상조직</label></th>
										<td>
											<div class="input-group w150">
												<input type="hidden" id="brc" name="brc" value="<%=init_brc%>">
												<input type="text" class="form-control" id="brnm" name="brnm" placeholder="전체" value="<%=init_brnm%>" readonly/>
												<span class="input-group-btn">
												<%
if( form.get("rcsa_menu_dsc").equals("2") ){
 %>		
												<button class="btn btn-default ico search" type="button"  onclick="org_popup();"><i class="fa fa-search"></i><span class="blind">검색</span>	</button>
				<%} %>
											  </span>
												</div>
										</td>
									<th scope="row"><label for="input03" class="control-label">동일평가비율</label></th>
										<td>
											<span class="select fl">
												<select class="form-control" id="eq_evl_rat" name="eq_evl_rat" >
													<option value="60">60%이상</option>
													<option value="70">70%이상</option>
													<option value="80">80%이상</option>
													<option value="90">90%이상</option>
													<option value="00">100%</option>
												</select>
											</span>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div><!-- .box-body //-->
					
					<div class="box-footer">
						<button type="button" class="btn btn-primary search" onclick="javascript:doAction('search');">조회</button>
					</div>
				</div><!-- .search-area //-->


				<div class="box box-grid mt20">
					<div class="box-header">
						<div class="area-tool">
							<button type="button" class="btn btn-xs btn-default" onclick="javascript:doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
						</div>
					</div>
					<div class="box-body">
						<div class="wrap-grid scroll h500">
								<script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
						</div>
					</div>
					<div class="box-footer">
						<div class="btn-wrap">
							<button type="button" class="btn btn-primary" onclick="javascript:doAction('toevl');">재평가요청</button>
						</div>
					</div>

				</div><!-- .box //-->
				</form>
			</div><!-- .content //-->
		</div><!-- .container //-->
			<!-- popup //-->
<%@ include file="../comm/OrgInfP.jsp" %> 

		<!-- popup //-->
	<script>
	$(document).ready(function(){
		//열기
		$(".btn-open").click( function(){
			$(".popup").addClass("block");
		});
		//닫기
		$(".btn-close").click( function(event){
			$(".popup").removeClass("block");
			 doAction("search");
		});
		// dim (반투명 ) 영역 클릭시 팝업 닫기 
		$('.popup >.dim').click(function () {  
			//$(".popup").removeClass("block");
			event.preventDefault();
		});
	});
		
	function closePop(){
		$("#winNonEvl").removeClass("block");
		$("#winRskEvl").removeClass("block");
		$("#winBuseo").removeClass("block");
	}
	// 부점검색 완료
	function buseoSearchEnd(kbr_nm, new_br_cd){
		$("#kbr_nm").val(kbr_nm);
		$("#sch_new_br_cd").val(new_br_cd);
		closeBuseo();
		//doAction('search');
	}
		</script>
	</body>
</html>