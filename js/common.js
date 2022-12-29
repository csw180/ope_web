//엑셀 정의
var excel_filename = "";
var excel_worksheetname = "";
var excel_merge = 1; 
var excel_design = 1; 
var excel_title = "";
var excel_userMG = "";

var excel_params = { 
		FileName :excel_filename,  
		SheetName :excel_worksheetname,
		Merge:excel_merge,SheetDesign:excel_design,
		TitleText:excel_title,
		UserMerge:excel_userMG,
		DownSum:0,
		ComboValidation:1,
		CheckBoxOnValue :"Y",
		CheckBoxOffValue :"N",
		DownCols :""
	} ;


var initUploadConfig = {
	    viewType: "icon",
	    iconMode: "detail",
	    theme: "Main",
	    autoUpload: false,
	    limitFileCount: 5,
	    limitFileSize: -1,
	    limitFileTotalSize: 20971520,
	    limitFileExt: "",
	    limitFileExtMode: "deny",
		headerText: {
			"icon16": "",
			"name": "파일명",
			"size": "파일 용량",
			"date": "날짜",
			"state": "상태",
		},

	    /* 팝업메뉴 항목 구성 */
	    contextMenuItems: {
	        "download": {
	            name: "다운로드 (D)",
	            icon: "",
	            accesskey: "d"
	        },
	        "sep1": "---------",
	        "sep2": "---------",
	        "add": {
	            name: "파일추가 (A)",
	            icon: "",
	            accesskey: "a"
	        },
	        /*
	        "upload": {
	            name: "업로드 (U)",
	            icon: "",
	            accesskey: "u"
	        },
	        */
	        "delete": {
	            name: "삭제 (R)",
	            icon: "delete",
	            accesskey: "r"
	        }
	    },
	    /* 팝업메뉴 이벤트 발생 */
	 /*   onContextMenu: function(key) {
	        switch (key) {
	            case "icon":
	            case "list":
	            case "detail":
	                $("#myUpload").IBUpload("iconMode", key);
	                break;
	            default:
	            	doUploadAction(key);
	        }
	    },*/

		onMessage: function(msgID, msgDesc) {
			if (msgID == "INFO-041") {
				alert(msgDesc);
			}
			return false;
		}
	};


var initUploadReadOnlyConfig = {
	    "viewType": "icon",
	    "iconMode": "icon",
	    "theme": "Main",
	    "autoUpload": false,
	    /* 팝업메뉴 항목 구성 */
	    contextMenuItems: {
	        "download": {
	            name: "다운로드 (D)",
	            icon: "",
	            accesskey: "d"
	        }
	    },
	    /* 팝업메뉴 이벤트 발생 */
	    onContextMenu: function(key) {
	        switch (key) {
	            case "icon":
	            case "list":
	            case "detail":
	                $("#myUpload").IBUpload("iconMode", key);
	                break;
	            default:
	            	doUploadAction(key);
	        }
	    },

	    "onMessage": "function (msgID, msgDesc){ if(msgID==\"INFO-041\"){ alert(msgDesc); } return false;}"
	};

function setRMouseMenu(obj){
	obj.SetActionMenu("엑셀 다운로드");
}
function setExcelFileName(file_nm){
	excel_params.FileName = file_nm;
}
function setExcelTitle(title){
	excel_params.TitleText = title;
}
function setExcelDownCols(cols){
	excel_params.DownCols = cols;
	
}

//조회중입니다. 메시지
var showLoadingDiv = "<div id=\"div_loading\" class='loading-wrap'>";
showLoadingDiv += "<div class=\"loadingBox\">";
showLoadingDiv += "  <span class='blind'>로딩중입니다</span>";
showLoadingDiv += "</div>";
showLoadingDiv += "</div>";

document.write(showLoadingDiv);

function goMenuUrl(page_ad, help_ad, full_name, full_mnu_txt) {
	var frm = document.headform;
	//alert("go page="+page_ad);
	//location.href=page_ad+"?full_mnu_nm="+full_name;
	frm.action = page_ad;
	frm.full_mnu_nm.value = full_name;
	frm.full_mnu_txt.value = full_mnu_txt;
	frm.submit();
}

var vTreeIdx = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
var preTreelvl = 0;

/*******************************************
 * JUI tree index 구하기
 *******************************************/
function treeIdx(lvl, mnu_nm) {
	var key="";
	
	if(preTreelvl>lvl) {
		for(var i=0; i<(preTreelvl-lvl); i++) {
			vTreeIdx[preTreelvl-(i+1)] = 0;
		}
	}
	vTreeIdx[lvl-1] += 1;
	for(var i=0; i<lvl; i++) {
		if(i==0)	key = vTreeIdx[i]-1;
		else	key += "." +(vTreeIdx[i]-1);
	}
	//alert(lvl+":"+mnu_nm+", key="+key);
	preTreelvl=lvl;
	return key;
}

/*******************************************
 * 조회중입니다. 메시지 보이기
 *******************************************/
function showLoadingWs() {
	$(".loadingBox .imgBox").css( "left", ( $(window).width()/2 - $(".loadingBox .imgBox").width()/2 ) + 'px' );
	$(".loadingBox .imgBox").css( "top" , ( $( window ).height()/2 - $(".loadingBox .imgBox").height()/2 ) + 'px' );
	
	var objectName = "div_loading";
    var dObj = eval(objectName);   
    dObj.style.display = "block";
}


/*******************************************
 * 조회중입니다. 메시지 숨기기
 *******************************************/
function removeLoadingWs() {
	var objectName = "div_loading";
	
	var dObj = eval(objectName);
	dObj.style.display='none';
    try{
        document.all.layerIframe.style.display='none';
    }catch(Exception){
    }
}

function onlynum() {
	var code = window.event.keyCode;
    if ((code > 34 && code < 41) || (code > 47 && code < 58) || (code > 95 && code < 106) || code == 8 || code == 9 || code == 13 || code == 46) {
		 window.event.returnValue = true;
		 return;
	}
	window.event.returnValue = false;
}

//숫자만 입력 받도록 한다
function numberChk(objt){
    var code = window.event.keyCode;
    if ((code > 34 && code < 41) || (code > 47 && code < 58) 
            || (code > 95 && code < 106) || code == 8 || code == 9 
            || code == 13 || code == 46) {
     window.event.returnValue = true;
     return;
    }

    alert('숫자만 입력할 수 있습니다.');
    //document.getElementById(args).value = "";
    //document.getElementById(args).focus();
    objt.value = "";
    objt.focus();
    return;
}

//숫자만 입력 받도록 한다
function intChk(objt){
    var code = window.event.keyCode;
    if ((code > 47 && code < 58) || code == 8 || code == 9 
            || code == 13 || code == 46) {
     window.event.returnValue = true;
     return;
    }

    alert('숫자만 입력할 수 있습니다.');
    window.event.preventDefault();
    objt.focus();
    return;
}

function dateFormat(dateStr, sep) {
	if(sep == null || sep == undefined){
        sep = ".";
	}
	if (dateStr)  return dateStr.length >= 8 ? (dateStr.substr(0, 4)+sep+dateStr.substr(4, 2)+sep+dateStr.substr(6, 2)):dateStr;
	else return "";
}

//숫자만 남기고 다 지움
function unformat(obj) {
    var temp = "";
    var n = String(obj.value);
    var len = n.length;
    var pos = 0;
    var ch = '';

    while (pos < len) {
        ch = n.charAt(pos);
        if ( ((ch >= '0') && (ch <= '9')) || (ch == '.') ) temp = temp + ch;
        pos = pos + 1;
    }
    obj.value = temp;
    return obj.value;
}

//숫자만 남기고 다 지움
function unformatval(val) {
    var temp = "";
    var n = String(val);
    if( n.length == 0 ) return "";
    var len = n.length;
    var pos = 0;
    var ch = '';

    while (pos < len) {
        ch = n.charAt(pos);
        //if ( ((ch >= '0') && (ch <= '9')) || (ch == '.') ) temp = temp + ch;
        if ( ((ch >= '0') && (ch <= '9')) ) temp = temp + ch;
        pos = pos + 1;
    }
    val = temp;
    return val;
}

function numformat(val) {
	if(Number(val)>0)	val=Number(val)+ "";
	return val;
}

//kind == 0이면 무조건 맞추기
//kind == 1이면 모자라면 채우고, 남으면 놔두기
//kind == -1이면 모자라면 놔두고, 남으면 자르기
//direction은 채울 때 혹은 자를 때 방향(1이면 뒷쪽을 채우거나 자름)
//fitStr은 kind가 -1일경우에는 불필요
function fitStr(srcStr, size, kind, direction, fitStr) {
	var retStr = "";
	retStr = srcStr.replace(/\n|\r/g,"");
	
	if(fitStr.length != 1){
		fitStr = " ";
	}
	
	var len = retStr.length;

	if(kind != -1){
		for(var i = 0; i < size - len; i++){
			if(direction == 1){
				retStr = retStr + fitStr;
			}
			else{
				retStr = fitStr + retStr;
			}
		}
	}
	if(kind != 1){
		if(retStr != null && retStr.length > size){
			if(direction == 1){
				retStr = retStr.substring(0, size)+ "...";
			}
			else{
				retStr = retStr.substring(retStr.length - size, retStr.length) + "...";
			}
		}
	}
	
	return retStr;
}

function conCatDate(sval, val) {
	sval = dateFormat(sval, '.');
	val = dateFormat(val, '.');
	if(sval.length>0) sval+="~";
	sval+=val;
	return sval;
}

/*
Description     :   ReplaceAll
Parameter       :   str : 변환대상
                    	 orgStr  : 대상문자
                    	 repStr  : 변환문자
Return          :   
*/ 
function replaceAll(str, orgStr, repStr){
	return str.split(orgStr).join(repStr);
}

/*
Description     :   ReplaceAll
Parameter       :   str : 변환대상
                    	 orgStr  : 대상문자
                    	 repStr  : 변환문자
Return          :   
*/ 
function savArt_itrd(f, vArtId) {
	var f=document.editform;
	if(confirm("해당 내용을 저장 하시겠습니까?")) {
		f.art_id.value=vArtId;
	    f.itrd.value=replaceAll(myeditor.outputBodyHTML(), "'", "\"");
	    //f.itrd.value=myeditor.outputBodyHTML();
	    //alert(f.art_id.value+"\n\r"+f.itrd.value);
	    f.target="ifrHid";
	    f.method="post";
	    f.action="/admin/comRslt.jsp";
	    f.submit();
	}	
	
}

function EnterkeyPass(){
	var src = window.event.srcElement;
	if(src.localName == "textarea"){
		return true;
	}
	if(event.keyCode == 13 ){
		event.returnValue = false;
		event.pre = false;
		return false;
	}else{
		return true;
	}
}

/**
 * 숫자만 남기고 모두 제거한다.
 *
 * @param value	문자열
 * @return 변환된 값
 */
function numberParse(value) {
	var sTemp="", strTail="";
	if(value.indexOf("-") == 0) {
		value=value.substring(1);
		sTemp = "-";
	}
	
	// 소숫점을 포함하는 경우
	if( value.indexOf(".") != -1 ) {
		strTail = value.substring(value.indexOf("."));
		value = value.substring(0, value.indexOf("."));
	}
		
	return sTemp + String(value).replace(/\D/g,"") + strTail;
}

/**
 * str을 금액형태로 변경
 * ex) 1234567890 => 1,234,567,890
 *
 * 특수문자 처리는 따로 해야합니다.
 *
 * @param val	문자열
 * @param sep	구분자
 * @return 변환된 값
 */
function setFormatCurrency( val, sep ) {
	var sTemp="";
	var str = numberParse(val);
	
	//if(str.indexOf("-") == 0)	sTemp = "-";
    
	var size    = 3;
	var strMain = "";
	var strTail = "";
	var strTemp = "";
	var strSep  = sep;

	var signFlag = false;

	if(str.indexOf("-") != -1) {
	
		str = str.replace( /\-/g, "" );
		signFlag = true;
    }

	// 소숫점을 포함하는 경우
	if( str.indexOf(".") != -1 ) {

		strMain = str.substring(0, str.indexOf("."));
		strTail = str.substring(str.indexOf("."));

		var strMainLength  = strMain.length;

		if( strMainLength > size ) {

			var divLength = parseInt( (strMainLength) / size );
			var remLength = parseInt( (strMainLength) % size );

			if(remLength > 0) {
				strTemp = strMain.substring(0, remLength) + strSep;
			}

			for( var i = 0; i < divLength; i++ ) {

				if(i == 0) {                    
					strTemp = strTemp + strMain.substring(remLength, remLength + size);                    
				} else {                    
					strTemp = strTemp + strSep + strMain.substring(remLength + (size * i), remLength + (size * i) + size);                    
				}
			}            
		} else {            
			strTemp = strMain;            
		}

		val = ( signFlag ? "-" : "" ) + strTemp + strTail;        
    }
    // 포함하지 않는경우
    else {
        
		//앞에 0인경우 변환 2011-02-15
    	if(str.length > 1){
			for ( var i = 0; i < str.length; i++ ) {			
				if(str.substring(0,1)== "0" || str.substring(0,1)== 0){
					str = str.substring(1,str.length);
				}else{
					break;
				}
			}
    	}
		strMain = str;
		var strMainLength = strMain.length;

		// 3자리를 초과하지 않을경우 -> 그대로 복사
		if(strMainLength <= size) {
			strTemp = strMain;
        }
		// 3자리를 초과할 경우 -> ,(Comma)로 분할한다.
		else {

			var divLength = parseInt((strMainLength)/ size);
			var remLength = parseInt((strMainLength)% size);

			if (remLength > 0) {
				strTemp = strMain.substring(0, remLength) + strSep;
			}

			for ( var i = 0; i < divLength; i++ ) {

				if (i == 0) {
					strTemp = strTemp + strMain.substring(remLength, remLength + size);                    
				} else {                    
					strTemp = strTemp + strSep + strMain.substring(remLength + (size * i), remLength + (size * i) + size);                    
				}
			}
		}

		val = ( signFlag ? "-" : "" ) + strTemp + strTail;
        
	}

	return sTemp + val;
    
}

/**
 * 해당 데이타를 숫자로 변경한다. 01000 -> 1,000
 * @param obj
 */
function setNumber(obj){
	var frm = document.form;
	obj.value =  setFormatCurrency(obj.value, ",");
}


/**
 * 문자열 n자리이상 ...
 *
 * @param value	문자열
 * @return 변환된 값
 */
function kstrcut(value,n,xx) {
	if(value.length > n)
		return value.substring(0,n)+xx;
	else return value;
}


function setDayOption(obj, year, month){
	
	for(var i=obj.options.length-1; i>=0; i--){
		obj.options.remove(i);
	}
	if (month=="01" || month=="03" || month=="05" || month=="07" || month=="08" || month=="10" || month=="12") {
		end_day = 31;
	}
	else if (month=="04" || month=="06" || month=="09" || month=="11") {
		end_day = 30;
	}
	else if (month=="02" && year%4 == 0) {
		end_day = 29;
	}
	else if (month=="02" && year%4 != 0) {
		end_day = 28;
	}

	var option = new Option();
	option.value = "";
	option.text = "선택";	
	
	obj.options.add(option);
	
	//접수기간(일)
	for(var i=1; i<=end_day; i++){
		option = new Option();
		if(i<10) option.value = "0" + i;
		else option.value = i;
		option.text = i + "일";	
		obj.options.add(option);
	}
	
	return end_day;
}


//년 선택박스 내용 작성
function setYearOption(obj, nowYr, sidx, eidx){
	
	for(var i=obj.options.length-1; i>=0; i--){
		obj.options.remove(i);
	}
	
	var option = new Option();
	option.value = "";
	option.text = "선택";	
	
	obj.options.add(option);
	
	if(sidx < eidx){
		for(var i=sidx; i<=eidx; i++){
			option = new Option();
			option.value = nowYr + i;
			option.text = (nowYr + i) + "년";	
			
			obj.options.add(option);
			
		}
	}else{
		for(var i=sidx; i>=eidx; i--){
			option = new Option();
			option.value = nowYr + i;
			option.text = (nowYr + i) + "년";	
			
			obj.options.add(option);
			
		}
	}
}

//월 선택박스 내용 작성
function setMonthOption(obj){
	
	for(var i=obj.options.length-1; i>=0; i--){
		obj.options.remove(i);
	}
	
	var option = new Option();
	option.value = "";
	option.text = "선택";	
	
	obj.options.add(option);
	
	for(var i=1; i<=12; i++){
		option = new Option();
		if(i<10) option.value = "0" + i;
		else option.value = i;
		option.text = i + "월";	
		
		obj.options.add(option);
		
	}
}


//숫자의 자리수 를 0으로 채우기
function leadingZeros(n, digits) {
	var zero = "";
	n = n.toString();
	
	if (n.length < digits) {
		for (var i = 0; i < digits - n.length; i++)
			zero += "0";
	}
	return zero + n;
}


/*
 * 부서검색 팝업 호출 후, 조회
 */
/*
function schOrgSetMode(mode){
	
	$("#ifrOrg").contents().find("#mode").val(mode);
	alert($("#ifrOrg").contents().find("#mode").val());
	
}

function schOrgPopup(brnm, func){
	
	$("#winBuseo").addClass("block");
	
	$("#ifrOrg").contents().find("#search_txt").val($("#"+brnm).val());
	$("#ifrOrg").contents().find("#rtn_func").val(func);
	
	if($("#"+brnm).val() != ""){
		$("#ifrOrg").get(0).contentWindow.doAction("search");
	}
	
}

function schOrgMPopup(brc_arr, bizo_tpcs, func){
	
	$("#winBuseo").addClass("block");
	
	$("#ifrOrg").get(0).contentWindow.setCheck(brc_arr, bizo_tpcs);
	$("#ifrOrg").contents().find("#rtn_func").val(func);
	
}
*/
/*
 * 부서검색
 * 검색결과 1건 일 경우, 검색완료
 * 2건 이상 또는 없을 경우 부서검색 팝업 표시 함수(schOrgPopup) 호출 
 */
function getSchOrgList(brnm, func) {
	//var f = document.ormsForm;
	WP.clearParameters();
	WP.setParameter("method", "Main");
	WP.setParameter("commkind", "com1");
	WP.setParameter("process_id", "FGORC11203");
	WP.setParameter("search_txt", $("#"+brnm).val());
	
	//WP.setForm(f);
	
	var url = "/comMain.do";
	var inputData = WP.getParams();
	
	showLoadingWs();
	
	WP.load(url, inputData,
	  {
		  success: function(result) 
		  {
			  
			  if(result!='undefined' && result.rtnCode=="0") 
			  {
				  var rList = result.DATA;
				  
				  removeLoadingWs();
				  
				  
				  if(rList.length == 1){ //결과가 1건인 경우 해당 조직 바로 조회
					  
					  func = eval(func);
					  
					  func(rList[0].brc, rList[0].brnm);
					  
					  //closePop();
					  
				  } else { //결과가 없거나 2건 이상인 경우 조직 검색 팝업
					  schOrgPopup(brnm, func);
				  }
				  
			  }
		  },
		  
		  complete: function(statusText,status) {
			  removeLoadingWs();
		  },
		  
		  error: function(rtnMsg) 
		  {
			  removeLoadingWs();
			  //alert(JSON.stringify(rtnMsg));
		  }
	});
}

/*
 * 부서정보 검색 시작
 * 검색어 없으면 부서 팝업
 * 있으면 검색어로 검색
 */
function getOrgcode(brnm, func){
	if($("#"+brnm).val() == ""){
		schOrgPopup(brnm, func);
	}else{
		getSchOrgList(brnm, func);
	}
}

/*
 * 부서검색 input box에서 Enter key 눌러 부서 검색
 */

function EnterkeySubmitOrg(brnm, func){
	var src = window.event.srcElement;
	if(event.keyCode == 13){
		getOrgcode(brnm, func);
		event.returnValue = false; 
		event.preventDefault();
		return false;
	}else{
		return true;
	}
}

/*
 * 직원정보 검색 시작
 * 검색어 없으면 직원 팝업
 * 있으면 검색어로 검색
 */
function getEmpcode(empnm, func){
	if($("#"+empnm).val() == ""){
		schEmpPopup(empnm, func);
	}else{
		getSchEmpList(empnm, func);
	}
}

/*
 * 직원검색 input box에서 Enter key 눌러 부서 검색
 */

function EnterkeySubmitEmp(empnm, func){
	var src = window.event.srcElement;
	
	if(event.keyCode == 13){
		getEmpcode(empnm, func);
		event.returnValue = false; 
		event.preventDefault();
		return false;
	}else{
		return true;
	}
}

/*
 * 직원검색
 * 검색결과 1건 일 경우, 검색완료
 * 2건 이상 또는 없을 경우 직원검색 팝업 표시 함수(schEmpPopup) 호출 
 */
function getSchEmpList(empnm, func) {
	//var f = document.ormsForm;
	WP.clearParameters();
	WP.setParameter("method", "Main");
	WP.setParameter("commkind", "com1");
	WP.setParameter("process_id", "FGORC11502");
	WP.setParameter("search_txt", $("#"+empnm).val());
	
	//WP.setForm(f);
	
	var url = "/comMain.do";
	var inputData = WP.getParams();
	
	showLoadingWs();
	
	WP.load(url, inputData,
	  {
		  success: function(result) 
		  {
			  if(result!='undefined' && result.rtnCode=="0") 
			  {
				  var rList = result.DATA;
				  
				  removeLoadingWs();
				  
				  if(rList.length == 1){ //결과가 1건인 경우 해당 직원 바로 조회
					  
					  func = eval(func);
					  
					  func(rList[0].eno, rList[0].empnm);
					  
					  closePop();
					  
				  } else { //결과가 없거나 2건 이상인 경우 직원 검색 팝업
					  schEmpPopup(empnm, func);
				  }
				  
			  }
		  },
		  
		  complete: function(statusText,status) {
			  removeLoadingWs();
		  },
		  
		  error: function(rtnMsg) 
		  {
			  removeLoadingWs();
			  //alert(JSON.stringify(rtnMsg));
		  }
	});
}




/*
 * input box에서 Enter key 눌러 조회
 */
function EnterkeySubmit(func, param1){
	var src = window.event.srcElement;
	if(event.keyCode == 13){
		func(param1);
		event.returnValue = false; 
		event.preventDefault();
		return false;
	}else{
		return true;
	}
}

function schEmpPopup(empnm, func){
	
	$("#winEmp").addClass("block");
	
	$("#ifrEmp").contents().find("#search_txt").val($("#"+empnm).val());
	$("#ifrEmp").contents().find("#rtn_func").val(func);
	
	if($("#"+empnm).val() != ""){
		$("#ifrEmp").get(0).contentWindow.doAction("search");
	}
}
/*
function schPrssPopup(){
	
	$("#winPrss").addClass("block");
}

function schHpnPopup(){
	
	$("#winHpn").addClass("block");
}

function schCasPopup(){
	
	$("#winCas").addClass("block");
}

function schIfnPopup(){
	
	$("#winIfn").addClass("block");
	
}

function closePop(){
	//alert("closPpo");
	$("#winRskAdd").removeClass("block");
	$("#winRskMod").removeClass("block");
	$("#winBuseo").removeClass("block");
	$("#winEmp").removeClass("block");
	$("#winPrss").removeClass("block");
	$("#winHpn").removeClass("block");
	$("#winCas").removeClass("block");
	$("#winIfn").removeClass("block");
	$("#winRskEvl").removeClass("block");
	$("#popRtn").removeClass("block");
	$("#winLosAcc").removeClass("block");
	$("#winBoard").removeClass("block");
}
*/


/*try{
	IBCalendar.SetTheme("LGY", "LightGray");
}catch(e){
	
}*/
var rtnId;

function setDate(date){
	// 달력 팝업 Dialog서 날짜 선택시 리턴값
	document.getElementById(rtnId).value = date;
}

function showCalendar(format, rtn_id){
	var obj = { Format:format, CallBack: "setDate", CalButtons : "Close", CalButtonAlign : "Center" };
	
	rtnId = rtn_id;
	
	IBCalendar.Show($("#"+rtn_id+"").val(), obj) ;
}

function setGridComma( num ){
	var num2 = new String(num);
	num2 = trim(num2);
	//num = field.value;
	var len = 0;
	var vPoint = 0;
	var bFlag = false;

	if( num2 == "" ) return "";

	if(initValue(num2) == "-"){
		num2 = num2.substring(1);
		bFlag = true;
	}

	if( num2.indexOf(".") == -1 )  len=num2.length;

	else len=num2.indexOf(".");

	newnum = num2.substring(0,len);

	numarray = new Array( len % 3 + 1 );
	index = 0;

	for( i = len ; i > 0 ; i -= 3 ){
		numarray[index] = newnum.substring(i - 3, i );
		index++;
	}

	newnum = "";

	for( i = index-1; i >= 0 ;i-- ){
		if( i < (index-1) ) newnum += ",";
		newnum += numarray[i];
	}

	if( num2.indexOf(".") > -1 ) newnum += num2.substring( num2.indexOf("."), num2.length );

	if(bFlag)	newnum = "-" + newnum;
	return newnum;
}

function parseWon(val){
	if(val=="" || isNaN(val)) return "";
	if(parseFloat(val)>=0)
		return parseInt(parseFloat(val)+0.5);
	else
		return parseInt(parseFloat(val)-0.5);
}

function parseP1(val){
	if(val=="" || isNaN(val)) return "";
	if(parseFloat(val)>=0)
		return parseInt(parseFloat(val)*10+0.5)/10;
	else
		return parseInt(parseFloat(val)*10-0.5)/10;
}

function parseP2(val){
	if(val=="" || isNaN(val)) return "";
	if(parseFloat(val)>=0)
		return parseInt(parseFloat(val)*100+0.5)/100;
	else
		return parseInt(parseFloat(val)*100-0.5)/100;
}

function parseP3(val){
	if(val=="" || isNaN(val)) return "";
	if(parseFloat(val)>=0)
		return parseInt(parseFloat(val)*1000+0.5)/1000;
	else
		return parseInt(parseFloat(val)*1000-0.5)/1000;
}

function parseP4(val){
	if(val=="" || isNaN(val)) return "";
	if(parseFloat(val)>=0)
		return parseInt(parseFloat(val)*10000+0.5)/10000;
	else
		return parseInt(parseFloat(val)*10000-0.5)/10000;
	
}

function parsePercent1(val){
	if(val=="" || isNaN(val)) return "";
	if(parseFloat(val)>=0)
		return parseInt(parseFloat(val)*1000+0.5)/10;
	else
		return parseInt(parseFloat(val)*1000-0.5)/10;
}

function parsePercent2(val){
	if(val=="" || isNaN(val)) return "";
	if(parseFloat(val)>=0)
		return parseInt(parseFloat(val)*10000+0.5)/100;
	else
		return parseInt(parseFloat(val)*10000-0.5)/100;
}

function parsePercent2Zero(val){
	if(val=="" || isNaN(val)) return "";
	if(parseFloat(val)>=0)
		return (parseInt(parseFloat(val)*10000+0.5)/100).toFixed(2);
	else
		return (parseInt(parseFloat(val)*10000-0.5)/100).toFixed(2);
}

function HTMLEscape(str){
	var value = str;
	value = replaceAll(value,">","&gt;");
	value = replaceAll(value,"<","&lt;");
	//value = replaceAll(value,"&","&amp;");
	return value;
}

function inNumber(){
	if(event.keyCode < 48 || event.keyCode > 57){
		alert("숫자만 입력 가능합니다.");
		event.returnValue=false;
	}
}

//뒤로가기 금지
history.pushState(null, null, location.href);
window.onpopstate = function(event){
	history.go(1);
}