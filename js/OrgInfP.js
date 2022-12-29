//========================= OrgInf : public  =========================//
function OrgInf(dscd, partkind, inputCodeName, inputValueName, isSearchPopup){
	this.dscd = dscd;
	this.partkind = partkind;
	this.codeName = inputCodeName;
	this.valueName = inputValueName;
	this.isSearchPopup = !(isSearchPopup == false || isSearchPopup == "false");
	
	this.func = null;	// function callback(code, name, args)
	this.args = null;
}

OrgInf.prototype.setResultFunc = function(func, args) {
	this.func = func;
	this.args = args;
};


function enterkeyOrgInf(defaultValue, orgInf){
	return enterkey_OrgInf(defaultValue, orgInf);
}

function openOrgInfPopup(defaultValue, orgInf){
	return openPoput_OrgInf(defaultValue, orgInf);
}


//========================= OrgInf : module  =========================//
var CONTENTS_ROOT_PATH = top.CONTENTS_ROOT_PATH;
var orgInfDialog;
var orgInfDialog2;
function enterkey_OrgInf(defaultValue, orgInf){
	var src = window.event.srcElement;
	if(event.keyCode != 13 ){
		return true;
	}
	
	if(defaultValue == ""){
	//	buseo(args[0], args[1]);
	}else{
		orgInfDialog = openProgressDialog(enterkey_OrgInf_dialog, "조회중입니다.", [defaultValue, orgInf]);
	}
	
	event.returnValue = false;
	return true;
}
function enterkey_OrgInf_dialog(args){
	var defaultValue = args[0];
	var orgInf = args[1];

	var dialogForm = new DialogForm();
	dialogForm.setParameter("dscd", orgInf.dscd);
	dialogForm.setParameter("partkind", orgInf.partkind);
	dialogForm.setParameter("part", defaultValue);
	dialogForm.setAction(CONTENTS_ROOT_PATH + "admOrgLstC_new.do?method=search_All");
	
	openModalSubDialogForm(dialogForm, args, "");
}


function openPoput_OrgInf(defaultValue, orgInf) {
	orgInfDialog2 = openProgressDialog(openPoput_OrgInf_dialog, "조회중입니다.", [defaultValue, orgInf]);
	
}
function openPoput_OrgInf_dialog(args) {
	var defaultValue = args[0];
	var orgInf = args[1];
	
	var dialogForm = new DialogForm();
	dialogForm.setParameter("dscd", orgInf.dscd);
	dialogForm.setParameter("partkind", orgInf.partkind);
	dialogForm.setParameter("part", defaultValue);
	dialogForm.setAction(CONTENTS_ROOT_PATH + "admOrgLstP_new.do");
	openModalSubDialogForm(dialogForm, args, "dialogHeight:380px;dialogWidth:700px;");
}


//========================= OrgLstCh : interface  =========================//
function result_enterkey_OrgInf(values, args){
	var orgInf = args[1];
	if(values) {
		if(orgInf.codeName) {
			document.getElementsByName(orgInf.codeName)[0].value = values[0];
		}
		if(orgInf.valueName) {
			document.getElementsByName(orgInf.valueName)[0].value = values[1];
		}
		
		if(orgInf.func) {
			orgInf.func(values[0], values[1], orgInf.args);
		}
	} else {
		if(orgInf.codeName) {
			document.getElementsByName(orgInf.codeName)[0].value = "";
		}
		//if(orgInf.valueName) {
		//	document.getElementsByName(orgInf.valueName)[0].value = "";
		//}
		
		if(orgInf.func) {
			orgInf.func("", "", orgInf.args);
		}

		if(orgInf.isSearchPopup) {
			openPoput_OrgInf(args[0], orgInf);
		}
	}
	
	closeProgressDialog(orgInfDialog);
}

//========================= OrgLstP : interface  =========================//
function onloaded_openPopup_OrgInf() {
	closeProgressDialog(orgInfDialog2);
}

function result_openPopup_OrgInf(values, args) {
	var orgInf = args[1];
	if(values) {
		if(orgInf.codeName) {
			document.getElementsByName(orgInf.codeName)[0].value = values[0];
		}
		if(orgInf.codeName) {
			document.getElementsByName(orgInf.valueName)[0].value = values[1];
		}
		
		if(orgInf.func) {
			orgInf.func(values[0], values[1], orgInf.args);
		}
	} 
}





//========================= 하위 호환을 위해 개발기간 남겨둠  =========================//
function org_info(code,name,ev){
	this.mode=1;	//1:part+branch,2:part,3.branch
	this.code=code;
	this.oldcode="";
	this.dscd="";
	this.name=name;
	this.returnValue=false;
	this.event_handler=ev;

	//Define functions
	this.getMode = ORG_getMode; 
	this.setMode = ORG_setMode; 
	this.getCode = ORG_getCode; 
	this.setCode = ORG_setCode; 
	this.getOldcode = ORG_getOldcode; 
	this.setOldcode = ORG_setOldcode; 
	this.getName = ORG_getName; 
	this.setName = ORG_setName; 
	this.getDscd = ORG_getDscd; 
	this.setDscd = ORG_setDscd; 
	this.getReturnValue = ORG_getReturnValue; 
	this.setReturnValue = ORG_setReturnValue; 
}

function ORG_getMode(){
	return this.mode;
}

function ORG_setMode(value){
	this.mode = value;
}

function ORG_getCode(){
	return this.code;
}

function ORG_setCode(value){
	this.code = value;
}

function ORG_getOldcode(){
	return this.oldcode;
}

function ORG_setOldcode(value){
	this.oldcode = value;
}

function ORG_getName(){
	return this.name;
}

function ORG_setName(value){
	this.name = value;
}

function ORG_getDscd(){
	return this.dscd;
}

function ORG_setDscd(value){
	this.dscd = value;
}

function ORG_getReturnValue(){
	return this.returnValue;
}

function ORG_setReturnValue(value){
	this.returnValue = value;
}

function OrgPopup(mode,ev,w,h){
	top.ORG_INFP_OBJ = new org_info("","",ev);
	top.ORG_INFP_OBJ.setMode(mode);
	top.div_org_inf1.style.display="block";
	if(w==null || w==0){
		top.div_org_inf1.style.width=top.ORG_POPUP_WIDTH;
		top.div_org_inf1.style.height=top.ORG_POPUP_HEIGHT;
	}else{
		top.div_org_inf1.style.width=w;
		top.div_org_inf1.style.height=h;
	}
	top.div_org_inf1.style.left=(top.document.body.offsetWidth-top.div_org_inf1.offsetWidth)/2+top.document.body.scrollLeft;
	top.div_org_inf1.style.top=(top.document.body.offsetHeight-top.div_org_inf1.offsetHeight)/2+top.document.body.scrollTop;
	top.div_org_inf1.style.display="none";

	if(top.POPUP_COUNT<=0) top.DisplayObj(true);
	top.POPUP_COUNT++;

	var f = top.document.orginfoform;
	f.action="/admOrgLstP.do"; 
	f.target = "ifrOrg";
	f.submit();
	
	return;
}

function OrgPopupKbrnm(mode,kbrnm,ev,w,h){
	top.ORG_INFP_OBJ = new org_info("",kbrnm,ev);
	top.ORG_INFP_OBJ.setMode(mode);

	top.div_org_inf1.style.display="block";
	if(w==null || w==0){
		top.div_org_inf1.style.width=top.ORG_POPUP_WIDTH;
		top.div_org_inf1.style.height=top.ORG_POPUP_HEIGHT;
	}else{
		top.div_org_inf1.style.width=w;
		top.div_org_inf1.style.height=h;
	}

	top.div_org_inf1.style.left=(top.document.body.offsetWidth-top.div_org_inf1.offsetWidth)/2+top.document.body.scrollLeft;
	top.div_org_inf1.style.top=(top.document.body.offsetHeight-top.div_org_inf1.offsetHeight)/2+top.document.body.scrollTop;
	top.div_org_inf1.style.display="none";
	
	if(top.POPUP_COUNT<=0) top.DisplayObj(true);
	top.POPUP_COUNT++;

	var f = top.document.orginfoform;
	f.action="/admOrgLstP.do"; 
	f.target = "ifrOrg";
	f.submit();
	return;
}

// add by ybpark 2013.04.05
function OrgPopupDeptList(mode,kbrnm,ev,w,h){
	top.ORG_INFP_OBJ = new org_info("",kbrnm,ev);
	top.ORG_INFP_OBJ.setMode(mode);

	top.div_org_inf1.style.display="block";
	if(w==null || w==0){
		top.div_org_inf1.style.width=top.ORG_POPUP_WIDTH;
		top.div_org_inf1.style.height=top.ORG_POPUP_HEIGHT;
	}else{
		top.div_org_inf1.style.width=w;
		top.div_org_inf1.style.height=h;
	}

	top.div_org_inf1.style.left=(top.document.body.offsetWidth-top.div_org_inf1.offsetWidth)/2+top.document.body.scrollLeft;
	top.div_org_inf1.style.top=(top.document.body.offsetHeight-top.div_org_inf1.offsetHeight)/2+top.document.body.scrollTop;
	top.div_org_inf1.style.display="none";
	
	if(top.POPUP_COUNT<=0) top.DisplayObj(true);
	top.POPUP_COUNT++;

	var f = top.document.orginfoform;
	f.action="/OrgPopupDeptList.do"; 
	f.target = "ifrOrg";
	f.submit();
	return;
}

var v_obj_cd = null;
var v_obj_nm = null;
var v_func = null;
var v_row = -1;
var v_col = -1;
function buseo(obj_nm, obj_cd, func, preFunc){
	if (preFunc) {if (! preFunc()) return;}
	v_obj_nm = eval(obj_nm);
	v_obj_cd = eval(obj_cd);
	var objinfo = OrgPopupKbrnm(1,v_obj_nm.value,function(objinfo){
		if(objinfo.returnValue){
			v_obj_cd.value=trim(objinfo.getCode());
			v_obj_nm.value=objinfo.getName();
		}
		if (func) func();
	});
}

function buseo2(obj_nm, obj_cd, func){
	v_obj_nm = eval(obj_nm);
	v_obj_cd = eval(obj_cd);	
	var objinfo = OrgPopupKbrnm(1,v_obj_nm.value,function(objinfo){
		if(objinfo.returnValue){
			v_obj_cd.value=trim(objinfo.getCode());
			v_obj_nm.value=objinfo.getName();
		}
		func();
	});
}

function buseo3(default_nm, func, args){
	v_row = args[0];
	v_col = args[1];
	var objinfo = OrgPopupKbrnm(1,default_nm,function(objinfo){
		if(objinfo.returnValue){
			func(objinfo.getCode(), objinfo.getName(), [v_row, v_col]);
		}
	});
}

function buseoNameDialog(){
	var f = top.document.orginfoform;
	f.action="/admOrgLstC.do?method=search_All";
	var html = makeHiddenHtml("part", v_obj_nm.value);
	top.document.getElementById('orginfoparam').innerHTML = html;
	f.target = "ifrHid";
	f.submit();
	return;
}

function setPartcode(obj_cd, obj_nm, br_cd) {
	v_obj_cd.value = obj_cd;
	v_obj_nm.value = obj_nm;
	if (v_func) v_func();
}

function callPopup() {
	//buseo(v_obj_nm, v_obj_cd);
	if (v_func) 
		buseo2(v_obj_nm, v_obj_cd, v_func);
	else
		buseo(v_obj_nm, v_obj_cd);		
}

function EnterkeySubmit(obj_nm, obj_cd, func, preFunc) {
	if (preFunc) {if (! preFunc()) return true;}
	v_obj_cd = eval(obj_cd);
	v_obj_nm = eval(obj_nm);
	v_func = func;
	if(event.keyCode == 13 ) {
		if (obj_nm == "")
			buseo(obj_nm, obj_cd);
		else
			progress_dialog(buseoNameDialog, "요청리스트를 검색하고 있습니다.");
		event.returnValue = false;
		return true;
	} else {
		return true;
	}
}	

function EnterSubmit(func) {
	if(event.keyCode == 13 ){
		func();
		event.returnValue = false;
		return true;
	}else{
		return true;
	}
}

function deltxt(obj1,obj2){
	obj_nm = eval(obj1);
	obj_cd= eval(obj2);

	if(obj_nm.value==""){
		obj_cd.value="";
	}
}