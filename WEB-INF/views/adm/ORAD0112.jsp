<%--
/*---------------------------------------------------------------------------
 Program ID   : ORAD011101.jsp
 Program name : 소관부서 추가
 Description  : 
 Programer    : 
 Date created : 2022.05.10
 ---------------------------------------------------------------------------*/
--%>
<%@page import="com.shbank.orms.comm.SysDateDao"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
response.setHeader("Pragma", "No-cache");
response.setHeader("Cache-Control", "no-cache");
response.setHeader("Expires", "0");

Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
if(vLst==null) vLst = new Vector();

HashMap hMap = null;
if(vLst.size()>0){
	hMap = (HashMap)vLst.get(0);
}else{
	hMap = new HashMap();
}

SysDateDao dao = new SysDateDao(request);
String sysdate = dao.getSysdate();
DynaForm form = (DynaForm)request.getAttribute("form");

String gubun = (String) form.get("gubun");



%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="../comm/library.jsp" %>
	<title>업무프로세스추가</title>
	
	<script>
	
	$(document).ready(function(){
		parent.removeLoadingWs(); //부모창 프로그래스바 비활성화

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
				{Header:"NO|NO",							Type:"Seq",		Width:30,	MinWidth:30,	Align:"Center",		SaveName:"num"},
				{Header:"선택|선택",							Type:"CheckBox",	Width:30,	MinWidth:10,	Align:"Center",		SaveName:"ischeck", 		Edit:true},
				{Header:"소관부서|그릅/본부",					Type:"Text",			MinWidth:60,	Align:"Center",		SaveName:"h_brnm", 		Edit:false, Wrap:true},
				{Header:"소관부서|부서",						Type:"Text",			MinWidth:60,	Align:"Center",		SaveName:"up_brnm",				Edit:false, Wrap:true},
				{Header:"소관부서|팀",							Type:"Text",			MinWidth:60,	Align:"Center",		SaveName:"brnm", 			Edit:false, Wrap:true},			
				{Header:"코드",							Type:"Text",			MinWidth:60,	Align:"Center",		SaveName:"brc", 			Hidden:true}			
					
			];
			IBS_InitSheet(mySheet,initData);
			
			
			mySheet.SetEditable(1); //수정
			
			
			mySheet.SetFocusAfterProcess(0);

			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet.SetCountPosition(0);
			mySheet.ShowFilterRow();
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			$("#shw_btn").attr("disabled",true);
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			//헤더기능 해제
			mySheet.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
			
			//doAction('search');
			doAction('Search');
		}
		function mySheet_OnSearchEnd(code, message) {
			
			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}else{
				for(var i = parent.mySheet4.GetDataFirstRow(); i<= parent.mySheet4.GetDataLastRow(); i++){
					for(var j = mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
						if(mySheet.GetCellValue(j, "brc")==parent.mySheet4.GetCellValue(i, "brc")){
							mySheet.SetCellEditable(j,"ischeck",0);
						}
					}
				}
			}
			//컬럼의 너비 조정
			mySheet.FitColWidth();
		}
		
	
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
	
	
	/*Sheet 각종 처리*/
	function doAction(sAction) {
		switch(sAction) {
			case "Search":  //부서 조회
				var opt = {};
				$("form[name=ormsForm] [name=method]").val("Main");
				$("form[name=ormsForm] [name=commkind]").val("adm");
				$("form[name=ormsForm] [name=process_id]").val("ORAD011202");
				
				mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
		
				break;
	
			case "save":      //저장할 데이터 추출
			    org_save();
				break;

			case "filter": //부서 선택
				
				mySheet2.RemoveAll();
				$("#sel_brc").val("");
			
			
				if($("#filter_txt").val()==""){
					mySheet1.ClearFilterRow()
				}else{
					mySheet1.SetFilterValue("brnm", $("#filter_txt").val(), 11);
				}
				break;
	
		}
	}

	function EnterkeySubmit(){
		if(event.keyCode == 13){
			doAction('filter');
			return true;
		}else{
			return true;
		}
	}

	function org_save(){
		$("#sch_bsn_prss_c").val(parent.$("#sch_bsn_prss_c").val());
		
		var f = document.ormsForm;
		var add_html = "";
		if(mySheet.GetDataFirstRow()>=0){
			for(var j=mySheet.GetDataFirstRow(); j<=mySheet.GetDataLastRow(); j++){
				if(mySheet.GetCellValue(j,"ischeck")==1){
					add_html += "<input type='hidden' name='sch_brc' value='" + mySheet.GetCellValue(j,"brc") + "'>";
				}
			}
		}	
		if(add_html==""){
			alert("추가할 소관부서를 선택해 주세요..");
			return;
		}

        tmp_area.innerHTML = add_html;
		
		
		var f = document.ormsForm;
		if(!confirm("선택한 소관부서를 추가하시겠습니까?")) return;
			
		WP.clearParameters();
		WP.setParameter("method", "Main");
		WP.setParameter("commkind", "adm");
		WP.setParameter("process_id", "ORAD011203"); 
		WP.setForm(f);
		
		var url = "<%=System.getProperty("contextpath")%>/comMain.do";
		var inputData = WP.getParams();
		
		//alert(inputData);
		
		showLoadingWs(); // 프로그래스바 활성화
		WP.load(url, inputData,
		    {
			  success: function(result){
				  if(result != 'undefined' && result.rtnCode== 'S'){
					  alert(result.rtnMsg);
					  parent.doAction('prss_brc_Search');
				  }
				  
			  },
			  
			  complete: function(statusText,status){
				  removeLoadingWs();
			  },
			  
			  error: function(rtnMsg){
				  alert(JSON.stringify(rtnMsg));
			  }
		    }
		);			
	}	
					
			
	
		
	</script>
</head>
<body onkeyPress="return EnterkeyPass()">
			
	<div id="" class="popup modal block">
			<div class="p_frame w800">

				<div class="p_body">
					
					<div class="p_wrap">
						<form name="ormsForm">
						<input type="hidden" id="path" name="path" />
						<input type="hidden" id="process_id" name="process_id" />
						<input type="hidden" id="commkind" name="commkind" />
						<input type="hidden" id="method" name="method" />
						<input type="hidden" id="grp_org_c_p" name="grp_org_c_p" /> <!-- 그룹기관코드 -->
						<input type="hidden" id="sch_bsn_prss_c" name="sch_bsn_prss_c" />
						<input type="hidden" id="tmp_area" name="tmp_area" />
						

						
								<div class="box">
												<div class="box-body">
													<div class="p_head">
														<h1 class="title">프로세스 소관부서 추가</h1>
													</div>
													<div class="wrap h500">
														 <script type="text/javascript"> createIBSheet("mySheet", "100%", "100%"); </script>
													</div>
												</div>
								</div>
						</form>
					</div>
					
				</div>


				<div class="p_foot">
					<div class="btn-wrap">
						<button type="button" class="btn btn-primary" onclick="doAction('save');">저장</button>
						<button type="button" class="btn btn-default btn-close">닫기</button>
					</div>
				</div>

				<button class="ico close fix btn-close"><span class="blind">닫기</span></button>

			</div>
		<div class="dim p_close"></div>
	</div>
	
	<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 -->

	<script>
	$(document).ready(function(){
		
		//닫기
		$(".btn-close").click( function(event){
			$(".popup",parent.document).hide();
			parent.$("#ifrORAD0110").attr("src","about:blank");
			event.preventDefault();
		});
		
	});
		
	function closePop(){
		$("#winNewAccAdd",parent.document).hide();
	}
	</script>
</body>
</html>