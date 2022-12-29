<%--
/*---------------------------------------------------------------------------
 Program ID   : ORFM0110.jsp
 Program name : 평판지수 결과 조회
 Description  : 
 Programmer   : 김병현
 Date created : 2022.05.31
 ---------------------------------------------------------------------------*/
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ page import="com.shbank.orms.comm.SysDateDao"%>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
Vector vLst= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
Vector vLst2= CommUtil.getResultVector(request, "grp01", 0, "unit02", 0, "vList");
Vector vLst3= CommUtil.getResultVector(request, "grp01", 0, "unit03", 0, "vList");
Vector vLst4= CommUtil.getResultVector(request, "grp01", 0, "unit04", 0, "vList");
if(vLst==null) vLst = new Vector();
HashMap hLst = null; 
for(int i=0; i<vLst.size(); i++) {
	if(vLst.size()>0){
		hLst = (HashMap)vLst.get(i);
	}
}
if(vLst2==null) vLst2 = new Vector();
HashMap hLst2 = null;
if(vLst3==null) vLst3 = new Vector();
HashMap hMap3 = null; 
if(vLst4==null) vLst4 = new Vector();
HashMap hMap4 = null; 
if(vLst3.size()>0){
	hMap3 = (HashMap)vLst3.get(0);
}else{
	hMap3 = new HashMap();
}
if(vLst4.size()>0){
	hMap4 = (HashMap)vLst4.get(0);
}else{
	hMap4 = new HashMap();
}
String[] ym = new String[999];
String[] ym_a = new String[999];
String f_ym = "";
for(int i=0; i<vLst.size(); i++) { /* bas_ym 오름차순 */
	HashMap hMap = (HashMap)vLst.get(i);
	if((String)hMap.get("bas_ym") != null) {
		ym_a[i] = (String)hMap.get("bas_ym");
	}else{
		ym_a[i] = "null";
	}
}
for(int i=0; i<vLst2.size(); i++) { /* bas_ym 내림차순 */
	HashMap hMap = (HashMap)vLst2.get(i);
	if((String)hMap.get("bas_ym_d") != null) {
		ym[i] = (String)hMap.get("bas_ym_d");
	}else{
		ym[i] = "null";
	}
	f_ym = (String)hMap.get("bas_ym_d");
}
int temp_color;
System.out.println(ym[3]);


%>
<!DOCTYPE html>
<html lang="ko">
	<head>
	    <%@ include file="../comm/library.jsp" %>
		<title>평판 대응방안</title>
		<script>
			$(document).ready(function(){
				// ibsheet 초기화
				//alert(parent.window.BAS_YM_0008555);
				var bas_yy = "";
				var bas_mm = "";
				if(parent.window.BAS_YM_0008555 != null){
					bas_yy = parent.window.BAS_YM_0008555.substr(0,4);
					bas_mm = parent.window.BAS_YM_0008555.substr(4,2);
					$("#sch_bas_y").val(bas_yy);
					monthChange();
					$("#sch_bas_m").val(bas_mm);
				}
				parent.window.BAS_YM_0008555 = null;
				initIBSheet2();
			});
			function initIBSheet2() {
				//시트 초기화
				mySheet2.Reset();
			
			var initData = {};
			
			initData.Cfg = {FrozenCol:0,MergeSheet:msAll,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden" }; //좌측에 고정 컬럼의 수
			initData.Cols = [
				{Header:"id",													Type:"Text",Width:100,Align:"Center",SaveName:"rki_id",Wrap:1,MinWidth:60,Edit:0, Hidden:true,ColMerge:0},
				{Header:"지표명|지표명",										Type:"Text",Width:100,Align:"Left",SaveName:"rkinm",Wrap:1,MinWidth:60,Edit:0,ColMerge:0},
				{Header:"유형구분|유형구분",									Type:"Text",Width:50,Align:"Center",SaveName:"typnm",Wrap:1,MinWidth:30,Edit:0,ColMerge:0},
				{Header:"당분기 평판지표 값 (%)|당분기 평판지표 값 (%)",		Type:"Float",Width:50,Align:"Center",SaveName:"rep_rki_nvl_0",Wrap:1,MinWidth:30,Edit:0 ,Format:"##0.##",ColMerge:0},
				{Header:"전분기 평판지표 값 (%)|전분기 평판지표 값 (%)",		Type:"Float",Width:50,Align:"Center",SaveName:"rep_rki_nvl_1",Wrap:1,MinWidth:30,Edit:0 ,Format:"##0.##",ColMerge:0},
				{Header:"증감율 (%)|증감율 (%)",								Type:"Float",Width:50,Align:"Center",SaveName:"per",Wrap:1,MinWidth:30,Edit:0 ,Format:"##0.##",ColMerge:0},
				{Header:"당분기 변환값|당분기 변환값",							Type:"Float",Width:50,Align:"Center",SaveName:"rep_rki_nvl_00",Wrap:1,MinWidth:30,Edit:0 ,Format:"##0.##",ColMerge:0},
				{Header:"최초시점(<%=f_ym%>) 누적 결과 값|변환값 평균",			Type:"Float",Width:50,Align:"Center",SaveName:"rep_rki_nvl_00_avg",Wrap:1,MinWidth:30,Edit:0 ,Format:"##0.##",ColMerge:0},
				{Header:"최초시점(<%=f_ym%>) 누적 결과 값|변환값 표준편차",		Type:"Float",Width:50,Align:"Center",SaveName:"rep_rki_nvl_00_std",Wrap:1,MinWidth:30,Edit:0 ,Format:"##0.##",ColMerge:0},
				{Header:"지표별 상세결과|지표별 상세결과",						Type:"Html",Width:50,Align:"Center",SaveName:"detail",Wrap:1,MinWidth:30,Edit:0,ColMerge:0},		
				{Header:"개별지수 표준화|개별지수 표준화",							Type:"Float",Width:50,Align:"Center",SaveName:"std0",Wrap:1,MinWidth:30,Edit:0,Format:"##0.##",Hidden:true,ColMerge:0},
				{Header:"개별지수 표준화 유형별 평균값|개별지수 표준화 유형별 평균값",			Type:"Float",Width:50,Align:"Center",SaveName:"std0_sum_d",Wrap:1,MinWidth:30,Edit:0,Format:"##0.###",Hidden:true,ColMertge:1},
				{Header:"개별지수 표준화 합계|개별지수 표준화 합계",					Type:"Float",Width:50,Align:"Center",SaveName:"std0_sum_e",Wrap:1,MinWidth:30,Edit:0,Format:"##0.##",Hidden:true,ColMerge:1},
				{Header:"평판지수 누적 결과 값|표준화 평균",						Type:"Float",Width:50,Align:"Center",SaveName:"avg0_e",Wrap:1,MinWidth:30,Edit:0,Format:"##0.##",Hidden:true,ColMerge:1},
				{Header:"평판지수 누적 결과 값|표준화 표준편차",						Type:"Float",Width:50,Align:"Center",SaveName:"std0_e",Wrap:1,MinWidth:30,Edit:0,Format:"##0.##",Hidden:true,ColMerge:1},
				{Header:"평판지수(index)|평판지수(index)",						Type:"Float",Width:50,Align:"Center",SaveName:"index0_e",Wrap:1,MinWidth:30,Edit:0,Format:"##0.##",Hidden:true,ColMerge:1}			
			];/*mySheet end*/		
				
			IBS_InitSheet(mySheet2,initData);
			//필터표시
			//mySheet.ShowFilterRow();  
			
			//건수 표시줄  표시위치(0: 표시하지 않음, 1: 좌측상단, 2: 우측상단, 3: 좌측하단, 4: 우측하단)
			mySheet2.SetCountPosition(0);
			mySheet2.SetHeaderMode({ColResize:0,ColMode:0,HeaderCheck:0,Sort:1});
			// 0:셀 단위 선택,1:행 단위 선택,3:Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			// 4:행 전체 선택/행 전체에 대한 동일한 색상을 지정할 때 사용/Focus 및 Hover 행에 대해 대해 모두 적용
			// 5:단위데이터행, 앞컬럼 머지(머지가능 컬럼중 첫번째 기준)행의 영역 선택/Ctrl 키를 이용하여 연결되지 않은 다중의 행을 선택/선택된 행번은 GetSelectionRows() 함수 이용 확인
			mySheet2.SetSelectionMode(4);
			
			//마우스 우측 버튼 메뉴 설정
			//setRMouseMenu(mySheet);
			doAction('search');
			doAction('search2');
			//javascript:buffer();
			}
			
			
			var row = "";
			var url = "<%=System.getProperty("contextpath")%>/comMain.do";
			
			//시트 ContextMenu선택에 대한 이벤트
			function mySheet2_OnSelectMenu(text,code){
				//alert('onselectmenu!');
				if(text=="엑셀다운로드"){
					doAction("down2excel");	
				}else if(text=="엑셀업로드"){
					doAction("loadexcel");
				}
			}
			/*Sheet 각종 처리*/
			function doAction(sAction) {
				switch(sAction) {
					case "search":  //데이터 조회	
						//당분기 평판지표 연도값
						
						var f = document.ormsForm;
						WP.clearParameters();
						WP.setParameter("method", "Main");
						WP.setParameter("commkind", "fam");
						WP.setParameter("process_id", "ORFM011002");
						WP.setForm(f);
						
						var inputData = WP.getParams();
						showLoadingWs(); // 프로그래스바 활성화
						
						WP.load(url, inputData,{
							success: function(result){
								if(result!='undefined' && result.rtnCode=="0") {
									var rList = result.DATA;
									if(rList.length>0){
										$("#index0").text(rList[0].index0);
										$("#index1").text(rList[0].index1);
										$("#index_rate").html('<strong>'+(rList[0].index_rate)+'%</strong>');
										$("#index00").text(rList[0].index00);
										$("#index11").text(rList[0].index11);
										$("#index2").text(rList[0].index2);
										$("#index3").text(rList[0].index3);
										$("#bas_ym_0").text(rList[0].bas_ym_0);
										$("#bas_ym_1").text(rList[0].bas_ym_1);
										$("#bas_ym_2").text(rList[0].bas_ym_2);
										$("#bas_ym_3").text(rList[0].bas_ym_3);
										$("#sch_bas_ym").val(rList[0].bas_ym_0);
										if(rList[0].index_rate <-20) {
											<%temp_color = 1;%> //RED
										}
										else if(rList[0].index_rate <-5 && rList[0].index_rate>=-20 ){
											<%temp_color = 2;%> //YELLOW
										}
										else{
											<%temp_color = 3;%> //GREEN
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
						break;
					case "search2":  //데이터 조회	
						var html = "";
						var ym_val = $("#sch_bas_y").val()+$("#sch_bas_m").val();
						html = ym_val;
						$("#c_bas_ym").html(html);
						
						var opt = {};
						$("form[name=ormsForm] [name=method]").val("Main");
						$("form[name=ormsForm] [name=commkind]").val("fam");
						$("form[name=ormsForm] [name=process_id]").val("ORFM011003");
						mySheet2.DoSearch(url, FormQueryStringEnc(document.ormsForm),opt);
						break;
					case "reload":  //조회데이터 리로드
						mySheet.RemoveAll();
						initIBSheet();
						break;
					case "down2excel":
						setExcelFileName("평판지표 결과");
						setExcelDownCols("1|2|3|4|5|6|7|8|10|11|12|13|14|15");
						mySheet2.Down2Excel(excel_params);
						break;
					case "mod1":
						$("#ifrFamMod1").attr("src","about:blank");
						$("#winFamMod1").show();
						showLoadingWs(); // 프로그래스바 활성화
						setTimeout(modFam1,1);
						//modRisk();
					break; 
				}
			}
			function modFam1(){ 
				var f = document.ormsForm;
				f.method.value="Main";
		        f.commkind.value="fam";
		        f.action="<%=System.getProperty("contextpath")%>/comMain.do";
		        f.process_id.value="ORFM010901";
				f.target = "ifrFamMod1";
				f.submit();
			}
			
			function mySheet2_OnSearchEnd(code, message) {
				if(code != 0) {
					alert("조회 중에 오류가 발생하였습니다..");
				}else{
				}
				//컬럼의 너비 조정
				mySheet2.FitColWidth();
			}
			function mySheet2_OnRowSearchEnd (Row) {
				mySheet2.SetCellText(Row,"detail",'<button class="btn btn-xs btn-default" type="button" onclick="detail('+Row+')"><span class="txt">상세</span><i class="fa fa-angle-right"></i></button>')

			}
			function detail(Row){
				if(Row >= mySheet2.GetDataFirstRow()){
					$("#rki_id").val(mySheet2.GetCellValue(Row,"rki_id"));
					doAction('mod1');
				}
			}
			
			function monthChange() {
				var selectYear = $("#sch_bas_y").val();
				var change=[];
<%
				for(int i=0; i<vLst.size(); i++) {
					HashMap hMap2 = (HashMap)vLst.get(i);
					String bas_ym2 = new String((String)hMap2.get("bas_ym"));
					String bas_y2 = bas_ym2.substring(0,4);
					String bas_m2 = bas_ym2.substring(4,6);
					%>
					if(selectYear==<%=bas_y2%>){
						if(<%=bas_m2%> < 10) change.push('0'+<%=bas_m2%>);
						else change.push(<%=bas_m2%>);
					}
					<%
				}
%>
				//alert(change.length);
				$('#sch_bas_m').empty();
				for(var count=0; count<change.length; count++){
					var option = $("<option>"+change[count]+"</option>");
					$('#sch_bas_m').append(option);
				}    
			}
		
		</script>
	</head>
	
	<body>
		<div class="container">
			<!-- page-header -->
			<%@ include file="../comm/header.jsp" %>
			<!--.page header //-->
			<!-- content -->
			<div class="content">
			<form name="ormsForm">
				<input type="hidden" id="path" name="path" />
				<input type="hidden" id="process_id" name="process_id" />
				<input type="hidden" id="commkind" name="commkind" />
				<input type="hidden" id="method" name="method" />
				<input type="hidden" id="rki_id" name="rki_id"/>
				<input type="hidden" id="sch_bas_ym" name="sch_bas_ym"/>
				<input type="hidden" id="temp_color" name="temp_color"/>
				
				<div class="box box-search">
					<div class="box-body">
						<div class="wrap-search">
							<table>
								<tbody>
									<tr>
										<th>기준년월</th>
										<td>
											<select name="sch_bas_y" id="sch_bas_y" class="form-control w80" onchange="monthChange()">
<%		String temp="";
		for(int i=0;i<vLst.size();i++){
			HashMap hMap = (HashMap)vLst.get(i);
			String bas_ym = new String((String)hMap.get("bas_ym"));
			String bas_y = bas_ym.substring(0,4);
			if(bas_y.equals(temp)) continue; 
			else{
%>
												<option value="<%=bas_y%>" selected><%=bas_y%></option>
<%
			}
			temp = bas_y;
		}
%>


											</select>
											<select name="sch_bas_m" id="sch_bas_m" class="form-control w60">
<%
		for(int i=0;i<vLst.size();i++){
			HashMap hMap = (HashMap)vLst.get(i);
			String bas_ym = new String((String)hMap.get("bas_ym"));
			String bas_y = bas_ym.substring(0,4);
			String bas_m = bas_ym.substring(4,6);
			if(temp.equals(bas_y)){
%>
												<option value="<%=bas_m%>" selected><%=bas_m%></option>
<% 
			}
		}
%>
													
											</select>
										</td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
					<div class="box-footer">
						<button type="button" class="btn btn-primary search" onclick="doAction('search'); doAction('search2');javascript:buffer();">조회</button>
					</div>
				</div>
				
				<section class="box box-grid">
					<div class="box-header">
						<h2 class="box-title">최근 1년간 평판지수(Index)결과</h2>
					</div>
<!-- 					<div class="wrap-grid" style="height: 104px;"> 
						<script> createIBSheet("mySheet", "100%", "100%"); </script>
					</div> -->
					<div class="wrap-table"> 
						<table>
							<thead>
								<tr>
									<th scope="col" colspan="4">평판리스크 지수(Reputational Risk Index) 결과</th>
									<th scope="col" colspan="4">최근 1년간 평판지수 변화 추이</th>
								</tr>
								<tr>
									<th scope="col">당분기</th>
									<th scope="col">전분기</th>
									<th scope="col">증감율</th>
									<th scope="col">등급</th>
									<th id="bas_ym_0" scope="col"></th>
									<th id="bas_ym_1" scope="col"></th>
									<th id="bas_ym_2" scope="col"></th>
									<th id="bas_ym_3" scope="col"></th>
								</tr>
							</thead>
							<tbody class="center">
								<tr>
									<td id="index0"></td>
									<td id="index1"></td>
									<td id="index_rate" class="cm"><strong></strong></td>
<%if(temp_color==3) { %>
									<td class="tb-grade-green">GREEN</td>
<%}else if(temp_color==1) { %>
									<td class="tb-grade-red">RED</td>
<%}else if(temp_color==2) { %>
									<td class="tb-grade-yellow">YELLOW</td>
<% } %>
									<td id="index00"></td>
									<td id="index11"></td>
									<td id="index2"></td>
									<td id="index3"></td>
								</tr>
							</tbody>
						</table>
					</div>
				</section>
				<section class="box box-grid">
					<div class="box-header">
						<h2 class="box-title">당분기(<strong id="c_bas_ym" class="cm"></strong>) 기준 평판지표 결과</h2>
						<div class="area-tool">
							<button class="btn btn-xs btn-default" type="button" onclick="doAction('down2excel');"><i class="ico xls"></i>엑셀 다운로드</button>
						</div>
					</div>
					<div class="wrap-grid h430" id="mydiv2">
						<script> createIBSheet("mySheet2", "100%", "100%"); </script> 
					</div>
				</section>
			</form>
			</div>
			<!-- content //-->
			
		</div>
		<!-- popup -->
		<div id="winFamMod1" class="popup modal"> <!-- 평판상세 종합INDEX -->
			<iframe name="ifrFamMod1" id="ifrFamMod1" src="about:blank"></iframe>
		</div>
		<%@ include file="../comm/OrgInfP.jsp" %>
		<%@ include file="../comm/PrssInfP.jsp" %> <!-- 업무프로세스 공통 팝업 --> 
		
	</body>
</html>