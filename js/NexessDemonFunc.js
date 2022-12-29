document.write("<script type='text/javascript' charset='utf-8' src='js/json2.js'></script>");
document.write("<script type='text/javascript' charset='utf-8' src='js/jquery/jquery-3.1.1.min.js'></script>");

//document.write("<script type='text/javascript' charset='utf-8' src='json2.js'></script>");
//document.write("<script type='text/javascript' charset='utf-8' src='jquery-3.5.1.min.js'></script>");
//document.write("<script type='text/javascript' charset='utf-8' src='jquery-3.5.1.js'></script>");

// 환경 설정
var CONST_LOCAL_DEMON_ADDRESS = "https://127.0.0.1:17489";
var CONST_TYPE_DEFAULT = "GET";
var CONST_REQUEST_INSTALL_RETRY_COUNT = 3;
var CONST_TIMEOUT_TYPE_DEFAULT = 5000;   // 가상머신에서 첫 커넥션 연결 시 설정된 시간만큼 걸림(ms).
var CONST_TIMEOUT_TYPE_000 = 10000;   // 가상머신에서 첫 커넥션 연결 시 설정된 시간만큼 걸림(ms).
var CONST_ASYNC_DEFAULT = false;

var GLOBAL_PORT_SCAN_RETRY_COUNT = 0;
var CONST_SERVER_NC_VERSION = "4.7.6.4"



// 소스 제어
var ACTIVATION_CONSOLE_LOG = true;
var ACTIVATION_ALERT = false;


// region 구조체로 사용
function requestData()
{
	var url;
	var func;
	var param;
	var callback;
	var type;
	var retrycnt;
	var timeout;
	var async;
}

function responseData()
{
	var resultCode;
	var msg;
	var status;
}
// endregion 구조체로 사용

function MakeSendData(requestData)
{
	if(requestData != null)
	{			
		var filter = new Array();

		filter[0] = "func";
		filter[1] = "param";

		if(requestData.type == "IFRAMEPOST")
		{
			requestData.param = JSON.stringify(requestData, filter);
		}
		else
		{
			requestData.param = encodeURIComponent(requestData.param);
			
			requestData.param = "data=" + JSON.stringify(requestData, filter);
		}
	}
	else
	{
		alert("MakeSendData Func error. parameter is NULL.");
	}		
}

function DM_SendRequest(reqData)
{
	if(reqData != null)
	{
		if (reqData.type == "GET")
		{
			jsonpGet(reqData);
		}
		else
		{
		    alert("DM_SendRequest Func error. 프로토콜 오류.");
		}
	}
}

function jsonpGet(reqData)
{
//	Print_ConsoleLog(">> jsonpGet reqData.url[" + reqData.url + "]");
//	Print_ConsoleLog(">> jsonpGet reqData.param[" + reqData.param + "]");
//	Print_ConsoleLog(">> jsonpGet reqData.timeout[" + reqData.timeout + "]");
//	Print_ConsoleLog(">> jsonpGet reqData.type[" + reqData.type + "]");
//	Print_ConsoleLog(">> jsonpGet reqData.async[" + reqData.async + "]");

	try 
	{
		$.ajax({
			url:reqData.url,
			data:reqData.param,
			timeout:reqData.timeout,
			dataType:"jsonp",
			cache:false,
			type:reqData.type,
			async:reqData.async,
			jsonpCallback:"nexessCallBack"+parseInt(Math.random() * 999999 % 999999),
			success: function(res)
			{
				if(reqData.callback != null)
				{
					var resData = new responseData();
					// 우리 포맷이 아니다.
					if(res === undefined)
					{
						resData.resultCode = 0;
						resData.msg = "Maybe API do not exist";
						resData.status = "Unknown";
					}
					else
					{
						resData.resultCode = res.nexessres;
						resData.msg = res.data;
					}

					reqData.callback(resData);
				}
			},
			error: function(request, status, error)
			{
				if(reqData.callback != null)
				{
					reqData.retrycnt = reqData.retrycnt -1;

					if(reqData.retrycnt <= 0)
					{
						var resData = new responseData();

						//설치되어 있지 않는 경우 0
						//그 이외의 SSL 인증서 에러 및 설치는 되어 있지만 외부 상태로 발생하는 오류는 3 메시지 표시한다.
						if(status == "parsererror")
						{
							resData.resultCode = "0";
						}
						else if(status == "timeout")
						{
							resData.resultCode = "0";
						}
						else if(status == "error")
						{
							resData.resultCode = "0";
						}
							
						resData.status = status;
						resData.msg = error;

						reqData.callback(resData);
					}
					else
					{
						DM_SendRequest(reqData);
					}
				}	
			}
		});
	}
	catch(e) 
	{
	    alert("jsonpGet Func error.");
		alert("catch\n[" + e + "]");
	}
}

function Print_ConsoleLog(log)
{
	if(ACTIVATION_CONSOLE_LOG == true)
	{
		console.log(log);
	}
}

function Print_Alert(msg)
{
	if(ACTIVATION_ALERT == true)
	{
		alert(msg);
	}
}

function Print_Log(log)
{
	Print_ConsoleLog(log);
	Print_Alert(log);
}

function Init_RequestData(requestData)
{
	requestData.url = CONST_LOCAL_DEMON_ADDRESS;
	requestData.type = CONST_TYPE_DEFAULT;
	requestData.retrycnt = CONST_REQUEST_INSTALL_RETRY_COUNT;
	requestData.timeout = CONST_TIMEOUT_TYPE_DEFAULT;
	requestData.async = CONST_ASYNC_DEFAULT;
}










// 아래로 NC 제어 함수
function Nexess_ExtendMethod(callback, name, value)
{
	Print_ConsoleLog(">> Nexess_ExtendMethod Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "ExtendMethod";
	reqData.param = name + "|" + value;
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_FinalizeLogin(callback, encIDandTOA, encSKIPandTime)
{
	Print_ConsoleLog(">> Nexess_FinalizeLogin Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "FinalizeLogin";
	reqData.param = encIDandTOA + "|" + encSKIPandTime;
	reqData.callback = callback;

	reqData.async = true;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_GetADLoginUser(callback)
{
	Print_ConsoleLog(">> Nexess_GetADLoginUser Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "GetADLoginUser";
	reqData.param = "";
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_GetAttribute(callback, attribute_name)
{
	Print_ConsoleLog(">> Nexess_GetAttribute Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "GetAttribute";
	reqData.param = attribute_name;
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_GetLoginID(callback)
{
	Print_ConsoleLog(">> Nexess_GetLoginID Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "GetLoginID";
	reqData.param = "";
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_GetMAC(callback)
{
	Print_ConsoleLog(">> Nexess_GetMAC Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "GetMAC";
	reqData.param = "";
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_GetMAC_All(callback)
{
	Print_ConsoleLog(">> Nexess_GetMAC_All Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "GetMAC_All";
	reqData.param = "";
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_GetNCVersion(callback)
{
	Print_ConsoleLog(">> Nexess_GetNCVersion Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "getNCVersion";
	reqData.param = "";
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_IsLogin(callback)
{
	Print_ConsoleLog(">> Nexess_IsLogin Func Call");
	var reqData = new requestData();
	Init_RequestData(reqData);
	
	reqData.func = "IsLogin";
	reqData.param = "";
	reqData.callback = callback;
	
	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_IsLogin3(callback)
{
	Print_ConsoleLog(">> Nexess_IsLogin3 Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "IsLogin3";
	reqData.param = "";
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_IsLoginPID(callback, pid_list)
{
	Print_ConsoleLog(">> Nexess_IsLoginPID Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "IsLoginPID";
	reqData.param = pid_list;
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_IsNDOK(callback)
{
	Print_ConsoleLog(">> Nexess_IsNDOK Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "IsNDOK";
	reqData.param = "";
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_IsNeedUpdate(callback, version)
{
	Print_ConsoleLog(">> Nexess_IsNeedUpdate Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "IsNeedUpdate";
	reqData.param = version;
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_IsNLSOK(callback)
{
	Print_ConsoleLog(">> Nexess_IsNLSOK Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "IsNLSOK";
	reqData.param = "";
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_Logout(callback)
{
	Print_ConsoleLog(">> Nexess_Logout Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "Logout";
	reqData.param = "";
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_LogoutWithOption(callback, option)
{
	Print_ConsoleLog(">> Nexess_LogoutWithOption Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "LogoutWithOption";
	reqData.param = option;
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_OpenURL(callback, url, browser)
{
	Print_ConsoleLog(">> Nexess_OpenURL Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "OpenURL";
	reqData.param = url + "|" + browser;
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_OpenURLWithChrome(callback, url)
{
	Print_ConsoleLog(">> Nexess_OpenURLWithChrome Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "OpenURLWithChrome";
	reqData.param = url;
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_OpenURLWithIE(callback, url)
{
	Print_ConsoleLog(">> Nexess_OpenURLWithIE Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "OpenURLWithIE";
	reqData.param = url;
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_PrepareResession(callback, nonce)
{
	Print_ConsoleLog(">> Nexess_PrepareResession Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "PrepareResession";
	reqData.param = nonce;
	reqData.callback = callback;

	reqData.timeout = CONST_TIMEOUT_TYPE_000;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_RefreshSessionKey(callback)
{
	Print_ConsoleLog(">> Nexess_RefreshSessionKey Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "RefreshSessionKey";
	reqData.param = "";
	reqData.callback = callback;

	reqData.timeout = CONST_TIMEOUT_TYPE_000;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_RequestLoginFrom(callback, param)
{
	Print_ConsoleLog(">> Nexess_RequestLoginFrom Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "RequestLoginFrom";
	reqData.param = param;
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_ResessionSuccess(callback, true_or_false)
{
	Print_ConsoleLog(">> Nexess_ResessionSuccess Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "ResessionSuccess";
	reqData.param = true_or_false;
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_SAPLauncher(callback, field_name, r3_name)
{
	Print_ConsoleLog(">> Nexess_SAPLauncher Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "SAPLauncher";
	reqData.param = field_name + "|" + r3_name;
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_SecureUpdateFiles(callback, url, file_name, type)
{
	Print_ConsoleLog(">> Nexess_SecureUpdateFiles Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "SecureUpdateFiles";
	reqData.param = url + "|" + file_name + "|" + type;
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_SetAccessHistory(callback, app, mac, ip, id, toa, result, desc)
{
	Print_ConsoleLog(">> Nexess_SetAccessHistory Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "SetAccessHistory";
	reqData.param = app + "|" + mac + "|" + ip + "|" + id + "|" + toa + "|" + result + "|" + desc;
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_SetAttribute(callback, name, value)
{
	Print_ConsoleLog(">> Nexess_SetAttribute Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "SetAttribute";
	reqData.param = name + "|" + value;
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_SetLoginProcessStatus(callback, status)
{
	Print_ConsoleLog(">> Nexess_SetLoginProcessStatus Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "SetLoginProcessStatus";
	reqData.param = status;
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_SetProviderID(callback, pid_list)
{
	Print_ConsoleLog(">> Nexess_SetProviderID Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "setProviderID";
	reqData.param = pid_list;
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}





function Nexess_GetAccount(callback, CSID)
{
	Print_ConsoleLog(">> Nexess_GetAccount Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "GetAccount";
	reqData.param = CSID;
	reqData.callback = callback;
	
	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_GetExtentionalFieldByND(callback, user_id, field_name, server_id)
{
	Print_ConsoleLog(">> Nexess_GetExtentionalFieldByND Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "GetExtentionalFieldByND";
	reqData.param = user_id + "|" + field_name + "|" + server_id;
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_GetLoginToa(callback)
{
	Print_ConsoleLog(">> Nexess_GetLoginToa Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "GetLoginToa";
	reqData.param = "";
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_GetPID(callback)
{
	Print_ConsoleLog(">> Nexess_GetPID Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "getPID";
	reqData.param = "";
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_GetTicket(callback)
{
	Print_ConsoleLog(">> Nexess_GetTicket Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "GetTicket";
	reqData.param = "";
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}

function Nexess_ReConfirm(callback)
{
	Print_ConsoleLog(">> Nexess_ReConfirm Func Call");

	var reqData = new requestData();
	Init_RequestData(reqData);

	reqData.func = "ReConfirm";
	reqData.param = "";
	reqData.callback = callback;

	MakeSendData(reqData);
	DM_SendRequest(reqData);
}