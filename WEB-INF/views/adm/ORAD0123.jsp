<%--
/*---------------------------------------------------------------------------
 Program ID   : ORAD0123.jsp
 Program name : ADMIN > 게시판 > 공지사항, 사용자게시판 > 등록/수정(팝업)
 Description  : 
 Programer    : 권성학
 Date created : 2021.05.20
 ---------------------------------------------------------------------------*/
--%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="../comm/comUtil.jsp" %>
<%
	HashMap hMapSession = (HashMap)request.getSession(true).getAttribute("infoH");
	Vector vBoardDtlMap= CommUtil.getResultVector(request, "grp01", 0, "unit01", 0, "vList");
	if(vBoardDtlMap==null) vBoardDtlMap = new Vector();
	
	HashMap hBoardDtlMap = null;
	if(vBoardDtlMap.size()>0){
		hBoardDtlMap = (HashMap)vBoardDtlMap.get(0);
	}else{
		hBoardDtlMap = new HashMap();
		hBoardDtlMap.put("blbd_dsc","");
		hBoardDtlMap.put("blbd_sqno","");
		hBoardDtlMap.put("blbd_tinm","");
		hBoardDtlMap.put("blbd_cntn","");
		hBoardDtlMap.put("bbrd_rg_dt","");
		hBoardDtlMap.put("chrg_empnm","");
		hBoardDtlMap.put("bbrd_rgmn_eno","");
		hBoardDtlMap.put("brnm","");
	}
	
	DynaForm form = (DynaForm)request.getAttribute("form");
	//String blbd_dsc = request.getParameter("blbd_dsc");
	String blbd_dsc = form.get("blbd_dsc");
	
	String auth_ids = hs.get("auth_ids").toString();
	String[] auth_grp_id = auth_ids.replaceAll("\\[","").replaceAll("\\]","").replaceAll("\\s","").split(",");  
	
	String aadm_yn = "N";
	for(int k=0;k<auth_grp_id.length;k++){
		if("001".equals(auth_grp_id[k]) || "002".equals(auth_grp_id[k])){
			aadm_yn = "Y";
		}
	}

%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
	<%@ include file="../comm/library.jsp" %>
	<script>
		$(document).ready(function(){
			removeLoadingWs();
			
			$("#winBlbdDtl",parent.document).show();
			$("#blbd_tinm").focus();
			
			<%if("1".equals(blbd_dsc)){%>
				do_ckedit();
			<%}%>
			initIBSheet1();
		});
		
		function initIBSheet1() {
			mySheet1.Reset();
			
			var initData1 = {};
			
			initData1.Cfg = {FrozenCol:0,MergeSheet:msHeaderOnly,AutoFitColWidth:"init|search|resize|rowtransaction|colhidden",MenuFilter:0 }; //좌측에 고정 컬럼의 수
			initData1.Cols = [
				{Header:"No.",			Type:"Seq",		SaveName:"seq",					Hidden:false,	Width:20,	Align:"Center"						},
			    {Header:"파일명",			Type:"Text",	SaveName:"file_name",			Hidden:false,	Width:100,	Align:"Left"						},
			    {Header:"파일크기",			Type:"Text",	SaveName:"file_size",			Hidden:false,	Width:20,	Align:"Left"						},
			    {Header:"다운로드",			Type:"Text",	SaveName:"file_download",		Hidden:false,	Width:150,	Align:"Left"						}
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
			
		}
		
		function doAction(sAction) {
			switch(sAction) {
				case "save": //저장
					<%if("1".equals(blbd_dsc)){%>
						if(document.getElementById("chk_pup_yn1").checked){
							ormsForm.pup_yn.value = "Y";
						}else{
							ormsForm.pup_yn.value = "N";
						}
	
						ormsForm.bltn_st_dt.value = ormsForm.txt_st_dt1.value.replace(/-/gi,"");
						ormsForm.bltn_ed_dt.value = ormsForm.txt_ed_dt1.value.replace(/-/gi,"");
						$("#blbd_cntn").val(CKEDITOR.instances.blbd_cntn.getData());
					<%}%>
					
					if($("#blbd_tinm").val() == ""){
						alert("제목을 입력해주세요." );
						$("#blbd_tinm").focus();
						return;
					}
					if($("#blbd_cntn").val() == ""){
						alert("내용을 입력해주세요." );
						$("#blbd_cntn").focus();
						return;
					}
					
					<%if("1".equals(blbd_dsc)){%>
						if(CKEDITOR.instances.blbd_cntn.getData().length > 4000){
							alert("본문을 4000자이내로 작성해주세요. 현재 "+CKEDITOR.instances.blbd_cntn.getData().length+"자(태그포함) 입니다." );
							return;
						}
					<%}%>
					
					if(!confirm("저장하시겠습니까?")) return;

					var f = document.ormsForm;
					
					WP.clearParameters();
					WP.setParameter("method", "Main");
					WP.setParameter("commkind", "adm");
					WP.setParameter("process_id", "ORAD012302");
					WP.setForm(f);
					
					var url = "<%=System.getProperty("contextpath")%>/comMain.do";
					var inputData = WP.getParams();
					
					//alert(inputData);
					//showLoadingWs(); // 프로그래스바 활성화
					WP.load(url, inputData,
						{
							success: function(result){
								alert("저장되었습니다.");
								parent.doAction("search");
								doAction("cancl");
							},
						  
							complete: function(statusText,status){
							},
						  
							error: function(rtnMsg){
								alert("처리중 오류가 발생하였습니다.");
							}
					});
					break;
				case "del": //삭제
					
					if(!confirm("삭제하시겠습니까?")) return;

					var f = document.ormsForm;
					
					WP.clearParameters();
					WP.setParameter("method", "Main");
					WP.setParameter("commkind", "adm");
					WP.setParameter("process_id", "ORAD012304");
					WP.setForm(f);
					
					var url = "<%=System.getProperty("contextpath")%>/comMain.do";
					var inputData = WP.getParams();
					
					//alert(inputData);
					//showLoadingWs(); // 프로그래스바 활성화
					WP.load(url, inputData,
						{
							success: function(result){
								alert("삭제되었습니다.");
								parent.doAction("search");
								doAction("cancl");
							},
						  
							complete: function(statusText,status){
							},
						  
							error: function(rtnMsg){
								alert("처리중 오류가 발생하였습니다.");
							}
					});
					break;
				case "reg": //등록
					<%if("1".equals(blbd_dsc)){%>
						if(document.getElementById("chk_pup_yn2").checked){
							ormsForm.pup_yn.value = "Y";
						}else{
							ormsForm.pup_yn.value = "N";
						}
	
						ormsForm.bltn_st_dt.value = ormsForm.txt_st_dt2.value.replace(/-/gi,"");
						ormsForm.bltn_ed_dt.value = ormsForm.txt_ed_dt2.value.replace(/-/gi,"");
						$("#blbd_cntn").val(CKEDITOR.instances.blbd_cntn.getData());
					<%}%>
					
					if($("#blbd_tinm").val() == ""){
						alert("제목을 입력해주세요." );
						$("#blbd_tinm").focus();
						return;
					}
					if($("#blbd_cntn").val() == ""){
						alert("내용을 입력해주세요." );
						$("#blbd_cntn").focus();
						return;
					}
					
					<%if("1".equals(blbd_dsc)){%>
						if(CKEDITOR.instances.blbd_cntn.getData().length > 4000){
							alert("본문을 4000자이내로 작성해주세요. 현재 "+CKEDITOR.instances.blbd_cntn.getData().length+"자(태그포함) 입니다." );
							return;
						}
					<%}%>
					
					if(!confirm("저장하시겠습니까?")) return;
					
					var f = document.ormsForm;
					
					WP.clearParameters();
					WP.setParameter("method", "Main");
					WP.setParameter("commkind", "adm");
					WP.setParameter("process_id", "ORAD012303");
					WP.setForm(f);
					
					var url = "<%=System.getProperty("contextpath")%>/comMain.do";
					var inputData = WP.getParams();
					
					//alert(inputData);
					//showLoadingWs(); // 프로그래스바 활성화
					WP.load(url, inputData,
						{
							success: function(result){
								alert("저장되었습니다.");
								parent.doAction("search");
								doAction("cancl");
							},
						  
							complete: function(statusText,status){
							},
						  
							error: function(rtnMsg){
								alert("처리중 오류가 발생하였습니다.");
							}
					});
					break; 
				case "cancl":		//취소
					$("#winBlbdDtl",parent.document).hide();
					break; 
			}
		}	
		
		var rtnId;
		
		function showCalendar2(format, rtn_id){
			var obj = { Format:format, CallBack: "setDate2", CalButtons : "Close", CalButtonAlign : "Center" };
			
			rtnId = rtn_id;
			
			IBCalendar.Show($("#"+rtn_id+"").val(), obj) ;
		}
		
		function setDate2(date){
			// 달력 팝업 Dialog서 날짜 선택시 리턴값
			document.getElementById(rtnId).value = date;
		}

	</script>
		
</head>
<body>
	<div class="popup modal block">
		<div class="p_frame w1000">
			<form name="ormsForm">
			<input type="hidden" id="path" name="path" />
			<input type="hidden" id="process_id" name="process_id" />
			<input type="hidden" id="commkind" name="commkind" />
			<input type="hidden" id="method" name="method" />
			<input type="hidden" id="blbd_dsc" name="blbd_dsc" value="<%=blbd_dsc%>"/>
			<input type="hidden" id="blbd_sqno" name="blbd_sqno" value="<%=(String)hBoardDtlMap.get("blbd_sqno") %>"/>
			<input type="hidden" id="pup_yn" name="pup_yn" />
			<input type="hidden" id="bltn_st_dt" name="bltn_st_dt">
			<input type="hidden" id="bltn_ed_dt" name="bltn_ed_dt">
			<div class="p_head">
				<h3 class="title"><%if("1".equals(blbd_dsc)){%>공지사항<%}else{%>사용자게시판<%}%></h3>
			</div>
			<div class="p_body">
				<div class="p_wrap">
					<div class="box box-grid">
						<div class="wrap-table">
							<table>
								<colgroup>
									<col style="width: 100px;">
									<col>
									<col style="width: 100px;">
									<col>
									<col style="width: 100px;">
									<col>
								</colgroup>
								<tbody>
<%
if(!"".equals((String)hBoardDtlMap.get("blbd_sqno"))){
	if("2".equals(blbd_dsc)){
%>									
									<tr>
										<th>제목</th>
										<td colspan="5">
											<input type="text" name="blbd_tinm" id="blbd_tinm" class="form-control" value="<%=(String)hBoardDtlMap.get("blbd_tinm") %>" onkeyPress="return EnterkeyPass()" <%if(!((String)hBoardDtlMap.get("bbrd_rgmn_eno")).equals(userid)){ %>readonly<%}%>>
										</td>
									</tr>
									<tr hidden="true">
										<th>등록일자</th>
										<td><%=((String)hBoardDtlMap.get("bbrd_rg_dt")).substring(0,4) %>-<%=((String)hBoardDtlMap.get("bbrd_rg_dt")).substring(4,6) %>-<%=((String)hBoardDtlMap.get("bbrd_rg_dt")).substring(6,8) %></td>
										<th>게시자</th>
										<td><%=(String)hBoardDtlMap.get("chrg_empnm") %></td>
										<th>부서</th>
										<td><%=(String)hBoardDtlMap.get("brnm") %></td>
									</tr>
									<tr>
										<th>내용</th>
										<td colspan="5">
											<textarea name="blbd_cntn" id="blbd_cntn" class="textarea h400" <%if(!((String)hBoardDtlMap.get("bbrd_rgmn_eno")).equals(userid)){ %>readonly<%}%>><%=StringUtil.htmlEscape((String)hBoardDtlMap.get("blbd_cntn"),false,false)%></textarea>
										</td>
									</tr>
<%
	}else{
%>
									<tr>
										<th>제목</th>
										<td colspan="5">
											<input type="text" name="blbd_tinm" id="blbd_tinm" class="form-control" value="<%=(String)hBoardDtlMap.get("blbd_tinm") %>" onkeyPress="return EnterkeyPass()" <%if(!"Y".equals(aadm_yn)){ %>readonly<%}%>>
										</td>
									</tr>
									<tr hidden="true">
										<th>등록일자</th>
										<td><%=((String)hBoardDtlMap.get("bbrd_rg_dt")).substring(0,4) %>-<%=((String)hBoardDtlMap.get("bbrd_rg_dt")).substring(4,6) %>-<%=((String)hBoardDtlMap.get("bbrd_rg_dt")).substring(6,8) %></td>
										<th>게시자</th>
										<td><%=(String)hBoardDtlMap.get("chrg_empnm") %></td>
										<th>부서</th>
										<td><%=(String)hBoardDtlMap.get("brnm") %></td>
									</tr>
<%
if("Y".equals(aadm_yn)){
%>		
									<tr hidden="true">
										<th>팝업여부</th>
										<td>
											<span class="checkbox-custom">
												<input type="checkbox" class="form-control" id="chk_pup_yn1" name="chk_pup_yn1" <%if("Y".equals((String)hBoardDtlMap.get("pup_yn"))){%>checked<%}%>>
												<label for="chk_pup_yn1"><i></i><span>팝업설정</span></label>
											</span>
										</td>
										<th>팝업기간</th>
										<td colspan="3">
											<div class="input-group w300">
<%
	if("Y".equals((String)hBoardDtlMap.get("pup_yn"))){
%>
												<input type="text" class="form-control" id="txt_st_dt1" name="txt_st_dt1" readonly value="<%=((String)hBoardDtlMap.get("bltn_st_dt")).substring(0,4) %>-<%=((String)hBoardDtlMap.get("bltn_st_dt")).substring(4,6) %>-<%=((String)hBoardDtlMap.get("bltn_st_dt")).substring(6,8) %>">
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" onclick="showCalendar2('yyyy-MM-dd','txt_st_dt1');"><i class="fa fa-calendar"></i></button>
												</span><div class="input-group-addon"> ~ </div>
												<input type="text" class="form-control" id="txt_ed_dt1" name="txt_ed_dt1" readonly value="<%=((String)hBoardDtlMap.get("bltn_ed_dt")).substring(0,4) %>-<%=((String)hBoardDtlMap.get("bltn_ed_dt")).substring(4,6) %>-<%=((String)hBoardDtlMap.get("bltn_ed_dt")).substring(6,8) %>">
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" onclick="showCalendar2('yyyy-MM-dd','txt_ed_dt1');"><i class="fa fa-calendar"></i></button>
												</span>
<%													
	}else{
%>
												<input type="text" class="form-control" id="txt_st_dt1" name="txt_st_dt1" readonly value="">
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" onclick="showCalendar2('yyyy-MM-dd','txt_st_dt1');"><i class="fa fa-calendar"></i></button>
												</span><div class="input-group-addon"> ~ </div>
												<input type="text" class="form-control" id="txt_ed_dt1" name="txt_ed_dt1" readonly value="">
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" onclick="showCalendar2('yyyy-MM-dd','txt_ed_dt1');"><i class="fa fa-calendar"></i></button>
												</span>
<%			
	}
%>												
												
												
											</div>
										</td>
									</tr>
<%
}
%>
									<tr>
										<th>내용</th>
										<td colspan="5">
											<textarea name="blbd_cntn" id="blbd_cntn" class="textarea h400" <%if(!"Y".equals(aadm_yn)){ %>readonly<%}%>><%=StringUtil.htmlEscape((String)hBoardDtlMap.get("blbd_cntn"),false,false)%></textarea>
										</td>
									</tr>
		
<%			
	}
}else{
%>
									<tr>
										<th>제목</th>
										<td colspan="5">
											<input type="text" name="blbd_tinm" id="blbd_tinm" class="form-control" onkeyPress="return EnterkeyPass()">
										</td>
									</tr>
<%
	if("1".equals(blbd_dsc)){
%>
									<tr hidden="true">
										<th>팝업여부</th>
										<td>
											<span class="checkbox-custom">
												<input type="checkbox" class="form-control" id="chk_pup_yn2" name="chk_pup_yn2">
												<label for="chk_pup_yn2"><i></i><span>팝업설정</span></label>
											</span>
										</td>
										<th>팝업기간</th>
										<td colspan="3">
											<div class="input-group w300">
												<input type="text" class="form-control" id="txt_st_dt2" name="txt_st_dt2" readonly>
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" onclick="showCalendar2('yyyy-MM-dd','txt_st_dt2');"><i class="fa fa-calendar"></i></button>
												</span><div class="input-group-addon"> ~ </div>
												<input type="text" class="form-control" id="txt_ed_dt2" name="txt_ed_dt2" readonly>
												<span class="input-group-btn">
													<button type="button" class="btn btn-default ico" onclick="showCalendar2('yyyy-MM-dd','txt_ed_dt2');"><i class="fa fa-calendar"></i></button>
												</span>
											</div>
										</td>
									</tr>
<%
	}
%>
									<tr>
										<th>내용</th>
										<td colspan="5">
											<textarea name="blbd_cntn" id="blbd_cntn" class="textarea h400"></textarea>
										</td>
									</tr>
<%
}
%>										
								</tbody>
							</table>
						</div>
					</div>
				</div>
			</div>
			<div class="box box-grid">
				<div class="box-body">
					<div class="wrap-grid h50">
						<script> createIBSheet("mySheet1", "100%", "100%"); </script>
					</div>
				</div>
			</div>
			<div class="p_foot">
				<div class="btn-wrap center">
<%
if(((String)hBoardDtlMap.get("blbd_sqno")).equals("")){
%>
					<button type="button" class="btn btn-primary" onclick="doAction('reg')">저장</button>
<%
}else{
	if("2".equals(blbd_dsc)){
		if(((String)hBoardDtlMap.get("bbrd_rgmn_eno")).equals(userid)){
%>
					<button type="button" class="btn btn-primary" onclick="doAction('save')">저장</button>
					<button type="button" class="btn btn-primary" onclick="doAction('del')">삭제</button>
<%
		}
	}else{
		if("Y".equals(aadm_yn)){
%>
					<button type="button" class="btn btn-primary" onclick="doAction('save')">저장</button>
					<button type="button" class="btn btn-primary" onclick="doAction('del')">삭제</button>
<%
		}
	}
}
%>
					<button type="button" class="btn btn-default btn-close" onclick="doAction('cancl')">닫기</button>
				</div>
			</div>
			<button type="button" class="ico close fix btn-close"><span class="blind">닫기</span></button>
		</form>
		</div>
		<div class="dim p_close"></div>
	</div>
	<script>
		function do_ckedit(){
			CKEDITOR.replace('blbd_cntn',{
				height: 350,
				resize_enabled: false,
				toolbarGroups: [
	              		{ name: 'document', groups: [ 'mode', 'document', 'doctools' ] },
	              		{ name: 'clipboard', groups: [ 'clipboard', 'undo' ] },
	              		{ name: 'editing', groups: [ 'find', 'selection', 'spellchecker', 'editing' ] },
	              		{ name: 'forms', groups: [ 'forms' ] },
	              		{ name: 'basicstyles', groups: [ 'basicstyles', 'cleanup' ] },
	              		{ name: 'paragraph', groups: [ 'list', 'indent', 'blocks', 'align', 'bidi', 'paragraph' ] },
	              		{ name: 'links', groups: [ 'links' ] },
	              		{ name: 'insert', groups: [ 'insert' ] },
	              		{ name: 'styles', groups: [ 'styles' ] },
	              		{ name: 'colors', groups: [ 'colors' ] },
	              		{ name: 'tools', groups: [ 'tools' ] },
	              		{ name: 'others', groups: [ 'others' ] },
	              		{ name: 'about', groups: [ 'about' ] }
	              	],
				/*removeButtons:'Save,NewPage,Print,Preview,Templates,Cut,Copy,Paste,PasteFromWord,PasteText,Redo,Undo,Find,Replace,SelectAll,Scayt,Form,Checkbox,Radio,TextField,Textarea,Select,Button,ImageButton,HiddenField,CopyFormatting,RemoveFormat,NumberedList,BulletedList,Outdent,Indent,CreateDiv,Blockquote,BidiLtr,BidiRtl,Language,Link,Unlink,Anchor,Flash,Image,Table,HorizontalRule,Smiley,SpecialChar,PageBreak,Styles,Format,ShowBlocks,Maximize,About,Iframe'*/
				removeButtons:'Save,NewPage,Print,Preview,Templates,Cut,Copy,Paste,PasteFromWord,PasteText,Redo,Undo,Find,Replace,SelectAll,Scayt,Form,Checkbox,Radio,TextField,Textarea,Select,Button,ImageButton,HiddenField,CopyFormatting,RemoveFormat,NumberedList,BulletedList,Outdent,Indent,CreateDiv,Blockquote,BidiLtr,BidiRtl,Language,Anchor,Flash,Image,Table,HorizontalRule,Smiley,SpecialChar,PageBreak,Styles,Format,ShowBlocks,Maximize,About,Iframe'
			});
		}
		
		$(document).ready(function(){
			
			//닫기
			$(".btn-close").click( function(event){
				$("#winBlbdDtl",parent.document).hide();
				event.preventDefault();
			});
		});
		
		function closePop(){
			$("#winBlbdDtl",parent.document).hide();
		}
		//취소
		$(".btn-pclose").click( function(){
			closePop();
		});
			
	</script>
</body>
</html>