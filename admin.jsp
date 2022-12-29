
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=euc-kr" />
<title></title>

<style>
body
{
margin-left: 0px;
margin-top: 0px;
margin-right: 0px;
margin-bottom: 0px;
scrollbar-face-color: #ffffff; scrollbar-shadow-color: #ccccc; scrollbar-highlight-color: #ccccc;
scrollbar-3dlight-color: #ccccc; scrollbar-darkshadow-color: #ffffff;
scrollbar-track-color: #ccccc; scrollbar-arrow-color: #1b1b1b;
}

input {border:1 solid #c4c0ba; font-family:verdana,돋움,돋움체; font-size:11px;}


td {
	font-family: Verdana, Arial, Helvetica, sans-serif;
	font-size: 11px;
}
</style>
<script type="text/javascript" src="/js/Utility.js"></script>
<script type="text/JavaScript">
<!--
function MM_swapImgRestore() { //v3.0
  var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
}

function MM_preloadImages() { //v3.0
  var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
    var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
    if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
}

function MM_findObj(n, d) { //v4.01
  var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
    d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
  if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
  for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
  if(!x && d.getElementById) x=d.getElementById(n); return x;
}

function MM_swapImage() { //v3.0
  var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
   if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
}

function isEmpty(stObj, alertMSG) {

	var rtn = true;
	var n = stObj.value;
	var cnt=0;

	if (n.length == 0 || n == null) {
		alert(alertMSG);
		rtn = false;
	} else {
		for (j=0; j<n.length; j++) {
			var vAsc = "";
			vAsc = n.charCodeAt(j);

			if (vAsc == 32) cnt++;
		}

		if (cnt == n.length) {
			alert(alertMSG);
			stObj.value="";
			rtn = false;
		} else rtn = true;
	}

	return rtn;
}

function fn_start() {
    document.frm.userID.focus();
}

function beforeLogin(frm) {
	if (!isEmpty(frm.userID, "아이디를 입력하세요!")) {
		frm.userID.focus();
		return;
//	} else if (!isEmpty(frm.userPass, "비밀번호를 입력하세요!")) {
//		frm.userPass.focus();
//		return;
	}

    idSet();
	document.frm.submit();
}

function cancelLogin(){
	frm.userID.value = "";
//	frm.userPass.value = "";
	frm.userID.focus();
}

function enterChk(frm) {
	if(event.keyCode == 13) {
		beforeLogin(frm);
	}
}

function idGet() {
	if(getCookie("ck_id_save") != "" && getCookie("ck_id_save") != null) {
		document.frm.userID.value = getCookie("ck_id_save");
		document.frm.id_save.checked = true;
	}
}


function idSet()
{
    var saveTime = new Date();
    saveTime.setTime(saveTime.getTime() + (365 *24 *60 * 60 * 1000));

    if(document.frm.id_save.checked == true) {
        setCookie("ck_id_save", document.frm.userID.value, saveTime);
    } else {
        setCookie("ck_id_save", "", saveTime);
    }
}

//-->
</script>

</head>

<body onLoad="MM_preloadImages('./image/login/btn_login_1.gif','./image/login/btn_cancel_1.gif');idGet();">
<table width="100%" height="100%" border="0" cellpadding="0" cellspacing="0">
<form name="frm" action="/jo/controller" method="post">
<input type="hidden" name="job_name" value="com.rmjo.popup.CO0010CP">
<input type="hidden" name="command" value="loginuser">
<input type="hidden" name="next_page" value="loginCheck.jsp">
<input type="hidden" name="logGubun" value="1">
  <tr>
    <td><table width="431" height="305" border="0" align="center" cellpadding="0" cellspacing="0">
      <tr>
        <td valign="top" background="./image/login/bg.gif"><table width="100%" height="87" border="0" cellpadding="0" cellspacing="0">
          <tr>
            <td>&nbsp;</td>
          </tr>
        </table>
          <table width="100%" height="90" border="0" cellpadding="0" cellspacing="0">
            <tr>
              <td style="padding:0 50 0 0 ;"><table border="0" align="right" cellpadding="0" cellspacing="3">
                <tr>
                  <td><table border="0" cellpadding="0" cellspacing="2" bgcolor="#177B2F">
                    <tr>
                      <td width="55" bgcolor="177B2F"><div align="center"><img src="./image/login/t_id.gif" /></div></td>
                      <td bgcolor="177B2F"><span class="search_title1">
                        <input type="text" name="userID" value="" class="input" style="width:120px;height:19px;background-color:#C4DF9B;" onKeydown="enterChk(document.frm)">
                      </span></td>
                    </tr>
                  </table></td>
                </tr>
<!--                <tr>
                  <td><table border="0" cellpadding="0" cellspacing="2" bgcolor="#177B2F">
                    <tr>
                      <td width="55" bgcolor="177B2F"><div align="center"><img src="image/login/t_pw.gif" width="45" height="15" /></div></td>
                      <td bgcolor="177B2F"><span class="search_title1">
                        <input type="password" name="userPass" value="" class="input" style="width:120px;height:19px;background-color:#C4DF9B;" onKeydown="enterChk(document.frm)">
                      </span></td>
                    </tr>
                  </table></td>
                </tr>
-->
                <tr>
                  <td style="padding:0 0 0 0;"><table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                      <td style="padding:0 5 0 0;"><div align="right">
                        <input type="checkbox" name="id_save" value="checkbox">
                        개인번호저장</div></td>
                    </tr>
                  </table>
                  <table border="0" align="right" cellpadding="0" cellspacing="0">
                    <tr>
                      <td><a href="javascript:beforeLogin(document.frm);" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image3','','./image/login/btn_login_1.gif',1)"><img src="./image/login/btn_login_0.gif" name="Image3" width="65" height="64" border="0"></a></td>
                      <td><a href="javascript:cancelLogin();" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Image4','','./image/login/btn_cancel_1.gif',1)"><img src="./image/login/btn_cancel_0.gif" name="Image4" width="65" height="64" border="0"></a></td>
                    </tr>
                  </table></td>
                </tr>
              </table></td>
            </tr>
          </table></td>
      </tr>
    </table></td>
  </tr>
  </form>
</table>
</body>
</html>
