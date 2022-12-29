<%--
/*---------------------------------------------------------------------------
 Program ID   : ORKR0201.jsp
 Program name : KRI > RI풀 관리 > RI조회(지주)
 Description  : 
 Programer    : 권성학
 Date created : 2021.06.23
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
	Vector vRkiAttrLst = CommUtil.getCommonCode(request, "RKI_ATTR_C");
	if(vRkiAttrLst==null) vRkiAttrLst = new Vector();
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
			initData.Cfg = {"SearchMode":smLazyLoad, "SizeMode": 0, "MouseHoverMode": 0, "DragMode":0, HeaderCheck:0, ChildPage:5,DeferredVScroll:1};
			initData.Cols = [
				{Header:"상태",			Type:"Status",		SaveName:"status",			Hidden:true							},
 				{Header:"선택",			Type:"CheckBox",	SaveName:"sel_check",		Width:60,	Align:"Center",	Edit:1	},
			    {Header:"RI ID",		Type:"Text",		SaveName:"comn_rki_id",		Width:100,	Align:"Center",	Edit:0	},
			    {Header:"지표명",			Type:"Text",		SaveName:"comn_rkinm",		Width:350,	Align:"Left",	Edit:0	},
			    {Header:"지표목적",		Type:"Text",		SaveName:"rki_obv_cntn",	Width:400,	Align:"Left",	Edit:0,	Wrap:1,	MultiLineText:1	},
			    {Header:"지표정의",		Type:"Text",		SaveName:"rki_def_cntn",	Width:400,	Align:"Left",	Edit:0,	Wrap:1,	MultiLineText:1	},
			    {Header:"지표산식",		Type:"Text",		SaveName:"idx_fml_cntn",	Width:400,	Align:"Left",	Edit:0,	Wrap:1,	MultiLineText:1	},
			    {Header:"단위코드",		Type:"Text",		SaveName:"rki_unt_c",		Hidden:true							},
			    {Header:"단위",			Type:"Text",		SaveName:"rki_unt_nm",		Width:80,	Align:"Center",	Edit:0	},
			    {Header:"수집주기코드",		Type:"Text",		SaveName:"col_fq",			Hidden:true							},
			    {Header:"수집주기",		Type:"Text",		SaveName:"col_fq_nm",		Width:80,	Align:"Center",	Edit:0	},
			    {Header:"보고주기코드",		Type:"Text",		SaveName:"rpt_fq_dsc",		Hidden:true							},
			    {Header:"보고주기",		Type:"Text",		SaveName:"rpt_fq_dsnm",		Hidden:true							},
			    {Header:"KRI여부",		Type:"Text",		SaveName:"kri_yn",			Width:70,	Align:"Center",	Edit:0	},
			    {Header:"KRI속성코드",		Type:"Text",		SaveName:"rki_attr_c",		Hidden:true							},
			    {Header:"KRI속성",		Type:"Text",		SaveName:"rki_attr_nm",		Width:130,	Align:"Center",	Edit:0	}
			];
			IBS_InitSheet(mySheet,initData);
			
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet.SetCountPosition(3);
			
			mySheet.SetFocusAfterProcess(0);
			
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet.SetSelectionMode(4);
			
			//mySheet.SetEditable(0);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			
			//헤더기능 해제
			//mySheet.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:0});
			
			doAction("search");
			
		}
		
		function mySheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
			if(Row >= mySheet.GetDataFirstRow()){
				$("#comn_rki_id").val(mySheet.GetCellValue(Row,"comn_rki_id"));
				doAction('mod');
			}

		}
		
		function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH, rowType) { 
			if(Row >= mySheet.GetDataFirstRow()){
			}
		}
		
		function mySheet_OnRowSearchEnd (Row) {
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
					$("form[name=ormsForm] [name=commkind]").val("kri");
					$("form[name=ormsForm] [name=process_id]").val("ORKR020102");
					
					mySheet.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
			
					break;

				case "down2excel":
					var params = {ExcelHeaderRowHeight:25, ExcelRowHeight:17, ExcelFontSize:10, FileName : "RI(지주).xlsx", SheetName : "Sheet1", DownCols:"2|3|4|5|6|8|10|12|13|15"} ;

					mySheet.Down2Excel(params);

					break;
				case "add":		//신규등록 팝업
					$("#ifrRkiAdd").attr("src","about:blank");
					$("#winRkiAdd").show();
					showLoadingWs(); // 프로그래스바 활성화
					setTimeout(addRki,100);
					
					break; 
				case "mod":		//수정 팝업
					if($("#comn_rki_id").val() == ""){
						alert("RI를 선택하세요.");
						return;
					}else{
						$("#ifrRkiMod").attr("src","about:blank");
						$("#winRkiMod").show();
						showLoadingWs(); // 프로그래스바 활성화
						setTimeout(modRki,1);
					}
					break;
				case "del":		//삭제
					if(mySheet.CheckedRows("sel_check") < 1){
						alert("삭제할 항목을 선택해주세요.");
						return;
					}else{
						if(!confirm("선택한 RI를 삭제 하시겠습니까?")) return;
						mySheet.DoSave("<%=System.getProperty("contextpath")%>comMain.do?method=Main&commkind=kri&process_id=ORKR020103",{Quest:0});
					}
					break; 
			}
		}

		function mySheet_OnSearchEnd(code, message) {

			if(code != 0) {
				alert("조회 중에 오류가 발생하였습니다..");
			}
		}
		
		function mySheet_OnSaveEnd(code, msg) {
		    if(code >= 0) {
		    	alert(msg);
		    	doAction("search");
		    } else {
		    	alert(msg);
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
		
		function addRki(){
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="kri";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORKR020201";
			f.target = "ifrRkiAdd";
			f.submit();
		}
		
		function modRki(){
			var f = document.ormsForm;
			f.method.value="Main";
	        f.commkind.value="kri";
	        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
	        f.process_id.value="ORKR020301";
			f.target = "ifrRkiMod";
			f.submit();
		}

	</script>
</head>
<body>
	<div class="container">
		<%@ include file="../comm/header.jsp" %>
		<!-- content -->
		<div class="content">
			<form name="ormsForm">
			<input type="hidden" id="path" name="path" />
			<input type="hidden" id="process_id" name="process_id" />
			<input type="hidden" id="commkind" name="commkind" />
			<input type="hidden" id="method" name="method" />
			<input type="hidden" id="comn_rki_id" name="comn_rki_id" />
			<!-- 조회 -->
			<div class="box box-search">
				<div class="box-body">
					<div class="wrap-search">
						<table>
							<tr>
								<th>RI ID</th>
								<td><input type="text" class="form-control w120" id="sch_comn_rki_id" name="sch_comn_rki_id" maxlength="5" onkeypress="EnterkeySubmit();"></td>
								<th>KRI 여부</th>
								<td>
									<div class="select w120">
										<select class="form-control" id="sch_kri_yn" name="sch_kri_yn">
											<option value="">전체</option>
											<option value="Y">Y</option>
											<option value="N">N</option>
										</select>
									</div>
								</td>
								<th>KRI 속성</th>
								<td>
									<div class="select w120">
										<select class="form-control" id="sch_rki_attr_c" name="sch_rki_attr_c">
											<option value="">전체</option>
	<%
			for(int i=0;i<vRkiAttrLst.size();i++){
				HashMap hMap = (HashMap)vRkiAttrLst.get(i);
	%>
													<option value="<%=(String)hMap.get("intgc")%>"><%=(String)hMap.get("intg_cnm")%></option>
	<%
			}
	%>										
										</select>
									</div>
								</td>
							</tr>
							<tr>
								<th>RI 명</th>
								<td colspan="3"><input type="text" class="form-control" id="sch_comn_rkinm" name="sch_comn_rkinm" style="width:308px" maxlength="100" onkeypress="EnterkeySubmit();"></td>
							</tr>
						</table>
					</div><!-- .wrap-search -->
				</div><!-- .box-body //-->
				<div class="box-footer">
					<button type="button" class="btn btn-primary search" onclick="doAction('search');">조회</button>
				</div>
			</div>
			<!-- 조회 //-->
			</form>
			<div class="box box-grid">
				<div class="box-header">
					<div class="area-tool">
						<div class="btn-group">
							<button type="button" class="btn btn-default btn-xs" onClick="javascript:doAction('add');">
								<i class="fa fa-plus"></i>
								<span class="txt">신규등록</span>
							</button>
							<button type="button" class="btn btn-default btn-xs" onclick="javascript:doAction('del');">
								<i class="fa fa-minus"></i>
								<span class="txt">삭제</span>
							</button>
						</div>
						<button class="btn btn-xs btn-default" type="button" onclick="doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
					</div>
				</div>

				<div class="box-body">
					<div class="wrap-grid h500">
						<script>createIBSheet("mySheet", "100%", "100%"); </script>
					</div>
				</div>
			</div>

		</div>
		<!-- content //-->
	</div>	
	<div id="winRkiAdd" class="popup modal">
		<iframe name="ifrRkiAdd" id="ifrRkiAdd" src="about:blank"></iframe>
	</div>
	<div id="winRkiMod" class="popup modal">
		<iframe name="ifrRkiMod" id="ifrRkiMod" src="about:blank"></iframe>
	</div>
	<iframe name="ifrDummy" id="ifrDummy" src="about:blank"></iframe>
	
</body>
</html>