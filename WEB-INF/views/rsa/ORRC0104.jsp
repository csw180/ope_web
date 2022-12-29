<%--
/*---------------------------------------------------------------------------
 Program ID   : ORRC0104.jsp
 Program name : 위험 등급 설정
 Description  : 화면정의서 RCSA-04
 Programer    : 박승윤
 Date created : 2022.07.14
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
//Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
%>

<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<script src="<%=System.getProperty("contextpath")%>/js/OrgInfP.js"></script>
	<script>
		
		
		
		$(document).ready(function(){
			// ibsheet 초기화
			initIBSheet1();
			createIBSheet2(document.getElementById("mydiv1"),"mySheet2", "100%", "100%");
		});
		$(document).ready(function() {
			initIBSheet2();
		});
		/*Sheet 기본 설정 */
		function initIBSheet1(finished) {
			
			//시트 초기화
			mySheet1.Reset();
			
			var initData = {};
			
			initData.Cfg = {FrozenCol:0,Sort:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; 
		    initData.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:0};
			initData.Cols = [
				{Header:"등급"					,Type:"Text"	,Width:60	,Align:"Center"	,SaveName:"rk_grd_sqno"			,Edit:"False"											},
				{Header:"수준"					,Type:"Text"	,Width:150	,Align:"Center"	,SaveName:"rk_grd_nm"			,Wrap:1,	MultiLineText:1,	Edit:"False"			},
				{Header:"손실예상 평균금액 (단위 :백만)"				,Type:"Int"		,Width:100	,Align:"right"	,SaveName:"csa_ifn_evl_st_nvl"	,Format:"NullInteger"									},
				{Header:"손실예상 평균금액 (단위 :백만)"				,Type:"Combo"	,Width:60	,Align:"Center"	,SaveName:"ifn_evl_st_bascd"	,ComboText:"이상|초과", ComboCode:"01|02"					},
				{Header:"손실예상 평균금액 (단위 :백만)"				,Type:"Int"		,Width:100	,Align:"right"	,SaveName:"csa_ifn_evl_ed_nvl"	,Format:"NullInteger"									},
				{Header:"손실예상 평균금액 (단위 :백만)"				,Type:"Combo"	,Width:60	,Align:"Center"	,SaveName:"ifn_evl_ed_bascd"	,ComboText:"이하|미만", ComboCode:"01|02"					},
				{Header:"중간값"					,Type:"Float"	,Width:100	,Align:"right"	,SaveName:"mid_nvl"			,Format:"NullFloat",	Edit:"False"					},
				{Header:"해외 손실예상 평균금액 (단위:천 USD)"	,Type:"Int"		,Width:100	,Align:"right"	,SaveName:"eng_ifn_evl_st_nvl"	,Format:"NullInteger",	Hidden:true						},
				{Header:"해외 손실예상 평균금액 (단위:천 USD)"	,Type:"Combo"	,Width:60	,Align:"Center"	,SaveName:"eng_ifn_evl_st_bascd",ComboText:"이상|초과", 	ComboCode:"01|02",Hidden:true	},
				{Header:"해외 손실예상 평균금액 (단위:천 USD)"	,Type:"Int"		,Width:100	,Align:"right"	,SaveName:"eng_ifn_evl_ed_nvl"	,Format:"NullInteger",	Hidden:true						},
				{Header:"해외 손실예상 평균금액 (단위:천 USD)"	,Type:"Combo"	,Width:60	,Align:"Center"	,SaveName:"eng_ifn_evl_ed_bascd",ComboText:"이하|미만",	ComboCode:"01|02",Hidden:true	},
				{Header:"중간값"					,Type:"Float"	,Width:100	,Align:"right"	,SaveName:"eng_mid_nvl"		,Format:"NullFloat",	Hidden:true						},
				{Header:"그룹기관코드"				,Type:"Text"	,Width:60	,Align:"Center"	,SaveName:"grp_org_c"			,Hidden:true											}
			];
			
			IBS_InitSheet(mySheet1,initData);
			
			//필터표시
			//mySheet1.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet1.SetCountPosition(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet1.SetSelectionMode(0);
			
			mySheet1.FitColWidth();

			return true;
		}
		
		/*Sheet 기본 설정 */
		function initIBSheet2() {
			
			//시트 초기화
			mySheet2.Reset();
			
			var initData = {};
			

			initData.Cfg = {FrozenCol:0,Sort:1,MergeSheet:msBaseColumnMerge + msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; 
			initData.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:0};
			initData.Cols = [
				{Header:"등급"				,Type:"Text"	,Width:20	,Align:"Center"	,SaveName:"nfna_ifn_c"	   ,Edit:false			},
				{Header:"수준"				,Type:"Text"	,Width:40	,Align:"Center"	,SaveName:"nfna_ifn_grdnm" ,Edit:false			},
				{Header:"비재무적영향기준내용코드"		,Type:"Text"	,Width:100	,Align:"Center"	,SaveName:"nfna_cntn_c"	   ,Edit:false , Hidden:true },
				{Header:"내용"				,Type:"Text"	,Width:20	,Align:"Center"	,SaveName:"code_cntn"	   ,Edit:false , ColMerge:1  },
				{Header:"내용"				,Type:"Text"	,Width:100	,Align:"Center"	,SaveName:"nfna_cntn"	   ,Edit:true  , ColMerge:0  },
				{Header:"업무 중단 영향"			,Type:"Text"	,Width:100	,Align:"Center"	,SaveName:"nfna_ibi_cntn"  ,Edit:true			},
				{Header:"PARTITION_ROW"			,Type:"Text"	,Width:100	,Align:"Center"	,SaveName:"partition_row"  , Hidden:true	}
			];

			
			IBS_InitSheet(mySheet2,initData);
			
			//필터표시
			//mySheet2.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet2.SetCountPosition(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet2.SetSelectionMode(0);
			
			mySheet2.FitColWidth();
			
			doAction('search');
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
					$("form[name=ormsForm] [name=commkind]").val("rsa");
					$("form[name=ormsForm] [name=process_id]").val("ORRC010402");
					mySheet1.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
					$("form[name=ormsForm] [name=process_id]").val("ORRC010403");
					mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);

					break;
				case "save":      //저장
					do_save();
					break;

			}
		}

		function do_save() {
			
			var Cnt = mySheet1.GetDataLastRow();
			
			for(var i=1; i<=Cnt; i++){
				
				//최소/최대값 비교
				if( i == Cnt ){
					
				}
				else if( mySheet1.GetCellValue(i,3) == "01" && mySheet1.GetCellValue(i,5) == "02" && mySheet1.GetCellValue(i,2) == mySheet1.GetCellValue(i,4)){
					mySheet1.SelectCell(i,2);
					alert("손실예상금액의 범위를 확인하세요.");
					return;
				}
				else if(mySheet1.GetCellValue(i,2) > mySheet1.GetCellValue(i,4)){
					mySheet1.SelectCell(i,2);
					alert("손실예상금액의 범위를 확인하세요.");
					return;
				}
				
				//최소값/윗등급의 최대값 일치여부 확인
				if(i > 1){
					if( mySheet1.GetCellValue(i,2) != mySheet1.GetCellValue(i-1,4) ){
						mySheet1.SelectCell(i,2);
						alert("손실예상금액의 범위를 확인하세요.");
						return;
					}
					if( mySheet1.GetCellValue(i,7) != mySheet1.GetCellValue(i-1,9) ){
						mySheet1.SelectCell(i,7);
						alert("해외손실예상금액의 범위를 확인하세요.");
						return;
					}
				}
					
				
			}

			mySheet2.DoAllSave(url + "?method=Main&commkind=rsa&process_id=ORRC010405");
			mySheet1.DoAllSave(url + "?method=Main&commkind=rsa&process_id=ORRC010404");
			
		}
		
		function mySheet1_OnRowSearchEnd(row) {
			if (mySheet1.GetCellValue(row, 4) == 0){
		    	mySheet1.SetCellValue(row, 4,"");
			}
			if (mySheet1.GetCellValue(row, 9) == 0){
		    	mySheet1.SetCellValue(row, 9,"");
			}

		}
		
		function mySheet1_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				mySheet1.FitColWidth();
			}
			

			//$("#kbr_nm").trigger("focus");
		}
		
		function mySheet1_OnSaveEnd(code, msg) {

		    if(code >= 0) {
		        alert("저장되었습니다.");  // 저장 성공 메시지
		        doAction("search");      
		    } else {
		        alert(code); // 저장 실패 메시지
		    }
		}

		function mySheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag) {
			
			//조회시 이벤트 발생 X
			if(RaiseFlag == 1) return;
			
			//마지막열 최대값은 사용X
			if( Row == mySheet1.GetDataLastRow() ){
				if(Col == 4 || Col == 5 || Col == 9 || Col == 10){
					mySheet1.SetCellValue(Row,Col,"");
					return;
				}
			}
			
			//최대값 변경시 아랫등급의 최소값 변경
 			if( Col == 4){
				mySheet1.SetCellValue(Row+1,2,Value);
			}
			
			//최대값 변경시 아랫등급의 최소값 변경
			if( Col == 9){
				mySheet1.SetCellValue(Row+1,7,Value);
			}

			//최소값코드변경시 윗등급 최대값코드도 변경
			if( Col == 3){
				
				//첫행이면 skip
				if( Row > 1 ){				
					if( Value == "01" ) mySheet1.SetCellValue(Row-1,5,"02");
					if( Value == "02" ) mySheet1.SetCellValue(Row-1,5,"01");
				}
				
			}
			//최대값코드변경시 아랫등급의 최소값코드변경
			if( Col == 5){	
				if( Value == "01" ) mySheet1.SetCellValue(Row+1,3,"02");
				if( Value == "02" ) mySheet1.SetCellValue(Row+1,3,"01");
			}
			
			//최소값코드변경시 윗등급 최대값코드도 변경
			if( Col == 8){
				
				//첫행이면 skip
				if( Row > 1 ){				
					if( Value == "01" ) mySheet1.SetCellValue(Row-1,10,"02");
					if( Value == "02" ) mySheet1.SetCellValue(Row-1,10,"01");
				}
				
			} 
			
			//최대값코드변경시 아랫등급의 최소값코드변경
			if( Col == 10){	
				if( Value == "01" ) mySheet1.SetCellValue(Row+1,8,"02");
				if( Value == "02" ) mySheet1.SetCellValue(Row+1,8,"01");
			}
			
			//중간값 재계산
			if( Col == 2 || Col == 4){
				var CalVal = (mySheet1.GetCellValue(Row,2) + mySheet1.GetCellValue(Row,4)) / 2 * 1000000;
				mySheet1.SetCellValue(Row,6,CalVal);
			}
			if( Col == 7 || Col == 9){
				var CalVal = (mySheet1.GetCellValue(Row,7) + mySheet1.GetCellValue(Row,9)) / 2 * 1000000;
				mySheet1.SetCellValue(Row,11,CalVal);
			}
			
		}
	</script>

</head>

<body>
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
			<div class="box box-grid">
			  <div class="box-header">
				<h2 class="box-title">재무적 영향 기준</h2>
			  </div>
				<div class="wrap-grid h200">
					<script type="text/javascript"> createIBSheet("mySheet1", "100%", "100%"); </script>
				</div>
			  <div class="box-header">
				<h2 class="box-title">비재무적 영향 기준</h2>
			  </div>
				<div id="mydiv1" class="wrap-grid h500">
					<!-- <script type="text/javascript"> createIBSheet("mySheet2", "100%", "100%"); </script> -->
				</div>
				<div class="box-footer">
					<div class="btn-wrap">
						<button class="btn btn-primary" type="button" onclick="javascript:doAction('save')"><span class="txt">저장</span></button>
					</div>
				</div><!-- .box-footer //-->
			</div>
			<!-- /.box -->
			</form>
		</div>
		<!-- /.content -->
	</div>
	<!-- /.container -->		
</body>
</html>