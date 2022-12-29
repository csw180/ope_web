﻿if (window["ibleaders"] == undefined) {
    window["ibleaders"] = {};
}
ibleaders.ibupload = {

    //========================================================================================================================
    /* (주의) 7.3.0.1 ~ 7.3.0.18 버전을 업그레이드 할 경우 바로 아래 userInputName 을 주석처리 해야 됩니다.!! */
    //========================================================================================================================
    userInputName: "myUpFile#", // 업로드 파일의 <input name='file'> → <input name='myUpFile0_0_0'>  과 같이 변경 가능함.
    //========================================================================================================================

    /* 파일 추가시 자동 업로드 여부 */
    autoUpload: true,
    explicitJson: false, // true 설정시 onAddFile 의 files 는 문자열이 아닌 json 객체로 리턴된다.
    locale: "Korean", // 아래쪽에 선언된 한국어 / 영문 메세지중 적용할 언어를 설정한다.

    /* 파일 제한 설정 */
    limitFileCount: 10,
    limitFileCountOnce: 5, // 이 숫자가 limitFileCount보다 크면 자동으로 limitFileCount 사이즈로 설정됩니다.
    limitFileSize: 2.0 * 1024 * 1024 * 1024,
    limitFileTotalSize: 2.0 * 1024 * 1024 * 1024,
    limitFileExt: "jsp",
    limitFileExtMode: "deny",
    
    //========================================================================================================================
    /* 파일 다운로드 시 구분자 설정
     * 1. 1개의 문자만 사용가능.
     * 2. /,\는 사용 불가.
     * 3. fileSeparator를 지정하지 않았을 경우 " "로 적용된다.
    */
    //========================================================================================================================
    fileSeparator : "|",

    //userAgent
    //userAgent: [{"AjaxComponent": "IBUpload"}, {"AjaxComponentVersion": "7.3"}], // CORS 적용시 undefined 로 설정해야 됨.
    /* 서버 경로 설정 */

    // 서버페이지는 샘플 형태로 제공되니, 사용자별 파일 권한 및 보안 부분은 추가 개발하시기 바랍니다.
    uploadServerUrl: "/js/jsp/upload_sample.jsp",
    downloadServerUrl: "/js/jsp/download_sample.jsp",

    // icon / name / size / date / state / type 의 순서를 바꿀 수 있으며 선언을 생략시 해당 컬럼은 보이지 않음. message 보다 우선순위 높음.
    //headerText : {"icon32":"","icon16":"","size":"file size","date":"file date","name" :"file name","state" :"status","type" :"file description"},
    //headerText : {"icon32":"","icon16":"","name" :"파일명","size":"파일 용량","date":"날짜","state" :"상태","type" :"파일 유형"},
    //progressText: {"wait": "waiting..", "download":"downloading.."},
    //progressText: {"wait": "대기중..", "download":"다운로드 가능"},

    /* 초기 컨트롤 설정 */
    viewType: "icon", //icon, ibsheet
    iconMode: "icon", //icon, list, detail
    theme: "Main", // 테마 폴더 명

    /* 업로드 엔코딩 설정(utf-8 또는 euc-kr) */
    uploadEncoding: "utf-8",

    //--------------------------------------------------------------------------------
    // 다운로드 동작때 쿠키 사용
    // 1인 경우 파일 다운로드 후 서버에서 완료여부를 쿠키로 사용자 PC에 전송합니다.
    // 쿠키가 검증되지 않은 경우 다음 다운로드 시도시 진행하지 않습니다.
    //--------------------------------------------------------------------------------
    useDownloadCookie : 0,

    //--------------------------------------------------------------------------------
    // 지원되는 아이콘 확장자를 나열합니다.
    // icon 폴더안에 실제로 제공되는 아이콘 확장자만 기입합니다.
    //--------------------------------------------------------------------------------
    supportIcon: "pdf doc docx xls xlsx ppt pptx zip txt jpg exe dll",

    //--------------------------------------------------------------------------------
    // 서버 업로드를 불허하는 확장자
    // 서버에서도 동일하게 다시 한번 관련 파일들의 수신을 제한해야 Client 통하지 않는 직접적인 해킹을 완벽하게 막을 수 있음
    //--------------------------------------------------------------------------------
    limitFileExtServer: "html htm php php2 php3 php4 php5 phtml pwml inc asp aspx ascx jsp cfm cfc pl bat exe com dll vbs js reg cgi htaccess asis sh shtml shtm phtm",

    //--------------------------------------------------------------------------------
    // 중복파일 업로드 방지
    // 0으로 설정한 경우, 중복 파일 업로드가 가능합니다.
    // exceptDuplicated = 0, overWriteFile = 0인 경우 동일한 파일을 업로드해도 서버에 별도로 저장됩니다.
    //--------------------------------------------------------------------------------
    exceptDuplicated : 1,

    //--------------------------------------------------------------------------------
    // IE9 파일 추가 버튼 이벤트 트리거 설정
    // IE9 브라우저일 경우 파일 추가(add)할 때 Iframe을 사용하지 않으면서 파일 선택 창을 띄웁니다(IE9일 때 반드시 설정해야합니다).
    // 파일 추가 버튼의 DOM ID를 값으로 설정하면 됩니다. 
    //--------------------------------------------------------------------------------  
    addTrigger: "addItem",

    //--------------------------------------------------------------------------------
    // 중복파일 덮어쓰기
    // overWriteFile을 1로 설정한 경우, 기존 파일을 삭제하고 업로드합니다.
    // 이 경우, exceptDuplicated = 0이어야 합니다.
    // overWriteFile을 1로 설정하고 overWriteFileYN을 1로 설정하면 기존 파일 삭제 전에 사용자 확인과정을 거칩니다.
    //--------------------------------------------------------------------------------
    overWriteFile : 0,
    overWriteFileYN : 0,

    //--------------------------------------------------------------------------------
    // 파일 밀어내기
    // pushNewFiles을 1로 설정한 경우, 총 파일 수가 limitFileCount 설정보다 많은 경우 기존 파일을 삭제해서 limitFileCount를 맞춥니다.
    // pushNewFiles을 1로 설정하고 pushNewFilesYN을 1로 설정하면 기존 파일 삭제 전에 사용자 확인과정을 거칩니다.
    //--------------------------------------------------------------------------------
    pushNewFiles : 0,
    pushNewFilesYN : 0,

    //--------------------------------------------------------------------------------
    // 0byte인 파일 추가 방지 여부
    // 0으로 설정하면 파일 크기가 0인 경우에 파일 목록에 추가되지 않습니다..
    //--------------------------------------------------------------------------------
    exceptZeroFile : 0,

    //--------------------------------------------------------------------------------
    // 업로드할 파일이 없는 경우 서버 전송여부
    // 0으로 설정하면 업로드 또는 삭제할 파일이 없는 경우 "upload" 명령을 무시합니다.
    //--------------------------------------------------------------------------------
    submitNoData : 1,

    //--------------------------------------------------------------------------------
    // 오류메시지 출력 레벨
    // "ERR" 인 경우에는 오류 메시지만 Alert으로 출력하고, "INFO"인 경우에는 INFO 수준의 메시지도 출력합니다.
    // onMessage 콜백 함수를 등록했다면 해당 함수에 정해진 레벨 이상의 오류코드와 메시지를 전달합니다.
    //--------------------------------------------------------------------------------
    msgLevel : "ERR",

    onContextMenu: undefined,
    onUploadFinish: undefined,
    onAddFile: undefined,

    onIBSheet: function (mySheet) {
        IBSheetLoadPage_Main(mySheet);
    },
    
    // IBUpload 더블 클릭 이벤트 OPEN.
    onDblClick: function (uploadid) {
    	// 더블클릭하여 파일을 다운로드 할 경우.
    	// $("#"+uploadid).IBUpload('download');
    },

    //--------------------------------------------------------------------------------
    // 정보,오류 발생 이벤트(업로드에서 이루어지는 다양한 내용에 대해 이벤트 출력
    //--------------------------------------------------------------------------------
    onMessage: function (messageID, Msg) {
        alert(Msg);
    },

    /* onUploading 이벤트  공통 설정
     업로드시 프로그래스바 (jquery block ui 사용)
     */
    onUploading: function (percent) {
//        var upID = this.opts.id;
//        if(percent<100){
//            if($("#"+upID).data()["blockUI.isBlocked"]==1){
//                document.getElementById("upPercent").value = percent;
//                document.getElementById("progressBAR").style.width = percent+"%";
//            }else{
//                $("#"+upID).block({ message: "<h4>Now File Uploading....<input id='upPercent' style='text-align:right;width:40px;border:0'>%</h4><ul style='width:100%;float:left;height:20px'><li id='progressBAR' style='height:100%;background-color:#ADADAD '></li></ul>" });
//            }
//        }else{
//            $("#"+upID).unblock();
//        }
    },

    onUploadData: undefined,
    /*onUploadData: function(serverResponeObject, serverResponeText){
     // 사용자 로직
     //리턴값 필수
     return serverResponeObject;
     },*/

    /* 팝업메뉴 항목 구성 */
    //contextMenuItems: getContextMenu(),

    //--------------------------------------------------------------------------------
    // IBUpload 메세지
    //--------------------------------------------------------------------------------
    message: {
        "Korean": {
            "INFO-001": "업로드를 시도하였습니다.\n\nㆍ파일  : {0}",
            "INFO-002": "업로드가 완료되었습니다.\n\n",

            "INFO-011": "다운로드를 시도하였습니다.\n\nㆍ다운로드 시도 URL : {0}",
            "INFO-012": "다운로드가 완료되었습니다.\n\n",

            "INFO-021": "현재 업로드중 오류가 발생하여 대기중인 파일이 있습니다. 오류가 발생한 파일들을 지우고 새롭게 추가 하시겠습니까?\n\n[확인] : 대기중인 파일들 제거 + 파일 추가 하기\n[취소] : 파일 추가 취소",

            "INFO-031": "IE 8이상 사용가능합니다.",

            "INFO-041": "선택된 파일이 없습니다.",
            "INFO-042": "업로드 또는 삭제할 파일이 없습니다.",

            "INFO-050": "중복된 파일이 있습니다. \n해당 파일들을 삭제하고 새롭게 추가 하시겠습니까?\n\n[확인] : 기존 파일들 제거 + 파일 추가 하기\n[취소] : 파일 추가 취소",
            "INFO-051": "업로드할 파일의 개수가 너무 많습니다. \n이전 파일들을 삭제하고 새롭게 추가 하시겠습니까?\n\n[확인] : 기존 파일들 제거 + 파일 추가 하기\n[취소] : 파일 추가 취소",

            "ERR-000": "전송이 진행중입니다.\n\n잠시 기다려 주세요.\n\nㆍ서버 작업 내역 : {0}",

            // 파일 추가 오류
            "ERR-001": "업로드할 파일의 개수가 너무 많습니다. \n\nㆍ현재 업로드 시도 개수 : {0}개(또는 그 이상)\nㆍ최대 가능 파일 개수 : {1}개",
            "ERR-002": "업로드할 파일의 용량이 너무 큽니다. \n\nㆍ현재 용량 : {0}\nㆍ최대 용량 : {1}",
            "ERR-003": "업로드할 파일들의 전체 용량이 너무 큽니다. \n\nㆍ현재 용량 : {0}\nㆍ최대 용량 : {1}",
            "ERR-004": "업로드가 허용되지 않는 파일 형식 입니다.\n\nㆍ업로드 파일 : {0}\nㆍ업로드 허용 파일의 확장자 : {1}",
            "ERR-005": "업로드가 제한된 파일 형식 입니다.\n\nㆍ업로드 파일 : {0}\nㆍ업로드 불가 파일의 확장자 : {1}",

            "ERR-006": "다운로드할 파일이 없습니다.",
            "ERR-007": "대기중인 파일은 다운로드 할 수 없습니다.",
            "ERR-008": "업로드할 파일의 개수가 너무 많습니다. \n\nㆍ현재 업로드 시도 개수 : {0}개(또는 그 이상)\nㆍ 한번에 업로드 할 수 있는 최대 가능 파일 개수 : {1}개",
            "ERR-009": "중복된 파일이 있습니다. \n\n업로드 파일 : {0}",
            "ERR-010": "0Byte인 파일이 있습니다. \n\n업로드 파일 : {0}",

            // 파일 업로드 응답 오류
            "ERR-011": "업로드 중에 오류가 발생하였습니다.\n\nㆍ서버 응답 코드 : {0}\nㆍ서버 오류 내용 : {1}",
            "ERR-012": "업로드 후에 서버가 보낸 응답문에 문법 오류가 있습니다.\n\nㆍ서버 응답 코드 : {0}\nㆍ서버 응답 내용 : {1}",
            "ERR-013": "실행 파일은 서버보안상 업로드가 제한된 파일 형식 입니다.\n\nㆍ업로드 파일 : {0}\nㆍ업로드 불가 파일의 확장자 : {1}",

            "ERR-998": "Exception 오류가 발생하였습니다.\n\nㆍ서버 응답 코드 : {0}\nㆍ서버 응답 내용 : {1}",
            "ERR-999": "올바른 API 사용이 아닙니다. 매뉴얼을 확인하시고 바르게 사용하여 주십시오.\n\nㆍAPI : {0}\nㆍData : {1}",

            // 화면 리소스 - 헤더명
            "TEXT-FileName": "파일명",
            "TEXT-FileSize": "파일용량",
            "TEXT-FileDate": "업로드날짜",
            "TEXT-FileDesc": "파일종류",
            "TEXT-FileState": "업로드상태",
            "TEXT-FileWait": "대기중",    // 파일을 추가하고 서버로 전송할때까지의 대기 상태
            "TEXT-FileProgress": "전송중",    // 파일을 추가하고 서버로 전송할때까지의 대기 상태
            "TEXT-FileAvail": "다운로드 가능", // 서버에 업로드 된 상태이므로 다운로드 가능 상태

            // 화면 리소스 - 날짜 시간
            "TEXT-DateAm": "오전",
            "TEXT-DatePm": "오후",

            // 확장자로는 정체가 불분명한 기타 파일명칭
            "TEXT-EtcFile": "기타 파일"
        },
        "English": {

            "INFO-001": "You tried uploading\n\nㆍFile : {0}",
            "INFO-002": "You have successfully uploaded.\n\n",
            "INFO-011": "You tried downloading\n\nㆍURL : {0}",
            "INFO-012": "You have successfully downloaded.\n\n",
            "INFO-021": "There is a pending file because an error occurred during the upload process. Are you sure you want to delete the files that were in error before adding them? \n\n[OK] : After you remove the file on hold, you can add items \n[cancel] : cancel",
            "INFO-031": "IE 8 or later is available.",
            "INFO-041": "No files selected.",
            "INFO-042": "No files to upload or delete",

            "INFO-050": "There is duplicated file. \nAre you sure you want to delete the files?\n\n[OK] : After you remove the files, you can add items \n[cancel] : cancel",
            "INFO-051": "There are too many files. \nAre you sure you want to delete the old files?\n\n[OK] : After you remove the files, you can add items \n[cancel] : cancel",

            "ERR-000": "Progress is pending.\n\nPlease wait a moment.\n\nㆍdoing : {0}",
            
            // 파일 추가 오류
            "ERR-001": "There are too many files to upload. \n\nㆍnumber of files currently being attempted : {0}\nㆍmaximum number : {1}",
            "ERR-002": "The file to upload is too large. \n\nㆍcurrent file size : {0}\nㆍmax file size : {1}",
            "ERR-003": "The total capacity of uploaded files is too large.\n\nㆍcurrent file size : {0}\nㆍmax file size : {1}",
            "ERR-004": "A file type that is not allowed to upload.\n\nㆍattempted files : {0}\nㆍallowed files : {1}",
            "ERR-005": "A file type with limited uploads.\n\nㆍattempted files : {0}\nㆍrestricted files : {1}",

            "ERR-006": "No files to download.",
            "ERR-007": "Pending files can not be downloaded.",
            "ERR-008": "There are too many files to upload. \n\nㆍnumber of files currently being attempted : {0}\nㆍ maximum number : {1}",
            "ERR-009": "There is duplicated file. \n\nFile Name : {0}",
            "ERR-010": "There is a 0Byte file. \n\nFile Name : {0}",

            // 파일 업로드 응답 오류
            "ERR-011": "There was an error uploading.\n\nㆍServer response code : {0}\nㆍServer error : {1}",
            "ERR-012": "There is a syntax error in the response sent by the server after uploading.\n\nㆍServer response code : {0}\nㆍServer response : {1}",
            "ERR-013": "The executable file is a file type that is restricted for uploading due to server security.\n\nㆍattempted files : {0}\nㆍrestricted files : {1}",

            "ERR-998": "Exception error occurred.\n\nㆍServer response code : {0}\nㆍServer response : {1}",
            "ERR-999": "Not using the correct API. Please check the manual and use it correctly.\n\nㆍAPI : {0}\nㆍData : {1}",

            // 화면 리소스 - 헤더명
            "TEXT-FileName": "File name",
            "TEXT-FileSize": "File size",
            "TEXT-FileDate": "File date",
            "TEXT-FileDesc": "File type",
            "TEXT-FileState": "File status",
            "TEXT-FileWait": "pending",    // 파일을 추가하고 서버로 전송할때까지의 대기 상태
            "TEXT-FileAvail": "download", // 서버에 업로드 된 상태이므로 다운로드 가능 상태

            // 화면 리소스 - 날짜 시간
            "TEXT-DateAm": "AM",
            "TEXT-DatePm": "PM",

            // 확장자로는 정체가 불분명한 기타 파일명칭
            "TEXT-EtcFile": "a file"
        }
    },

    //====================================================================================================
    // 파일 확장자별 설명
    //====================================================================================================
    fileType: {
        "English": {
            "$$$": "Temporary file",
            "aif": "Audio exchange file",
            "aiff": "Audio exchange file",
            "alz": "EastSoft-Allison, compressed file",
            "arj": "ARJ compressed archive",
            "asf": "Microsoft Advanced Streaming Format File",
            "asm": "assembler file, uncompiled assembly file",
            "asp": "Active Server Page File",
            "asv": "Auto save file (auto save file)",
            "asx": "video file",
            "au": "Sound file",
            "avi": "Microsoft audio and video files",
            "bas": "Visual Basic module file",
            "bat": "MS-DOS Batch File",
            "bin": "binary file",
            "c": "C language source code",
            "cfg": "Configuration file",
            "cgi": "CGI script",
            "chm": "Compile HTML file",
            "com": "Executable for MS-DOS",
            "cpl": "Window play file",
            "cpp": "Visual C / C ++ source file",
            "css": "Cascading Style Sheet File (MIME)",
            "csv": "comma separated values",
            "cur": "cursor icon file",
            "cxx": "C ++ source file",
            "dat": "data file",
            "dbf": "dBase file",
            "dll": "dynamic link library",
            "doc": "Microsoft Word file",
            "docx": "Microsoft Word file",
            "drv": "Windows driver file",
            "exe": "Executable file",
            "fla": "Flash movie file",
            "gdb": "compressed lecture file",
            "gif": "graphic file",
            "gz": "unix gzip archive",
            "hlp": "help file",
            "hml": "Hangul Word Processor Markup Language (HWPML) file",
            "htm": "hypertext document",
            "html": "hypertext document",
            "hwp": "hangul word file",
            "hwt": "hangul word file template",
            "ico": "icon file",
            "img": "image file",
            "inf": "installation information file",
            "ini": "initialization file, configuration file",
            "iso": "list of files on CD-ROM, based on ISO 9660 CD-ROM file system standard",
            "jar": "java archive (compressed file for applet or related files)",
            "java": "java source code",
            "jpe": "JPEG image",
            "jpeg": "JPEG bitmap graphic file",
            "jpg": "JPEG bitmap graphic file",
            "js": "JavaScript source file",
            "log": "Log file",
            "mdb": "Microsoft Access Database",
            "mdf": "Microsoft, MS-SQL Master database file",
            "mdi": "Microsoft Office document image file",
            "mht": "Microsoft, MHTML Document",
            "mp3": "Music file compressed with MPEG Audio Layer 3",
            "mp4": "MPEG-4 video file",
            "mpeg": "MPEG movie file",
            "nrg": "Nero, ISO 9660 image",
            "ocx": "Microsoft OLE custom control",
            "ost": "Microsoft Outlook, Offline Files",
            "pas": "Borland Pascal, source code file",
            "pcx": "PC paint brush bitmap file",
            "pdf": "Adobe Acrobat Document Format (Portable Document Format)",
            "php": "HTML page containing PHP script",
            "php3": "HTML page containing PHP script",
            "phtml": "HTML page containing PHP script",
            "pl": "Perl program",
            "png": "Portable Network Graphics image file",
            "ppt": "Microsoft PowerPoint file",
            "pptx": "Microsoft PowerPoint file",
            "prl": "perl script",
            "prn": "print file",
            "psd": "Adobe Photoshop bitmap file",
            "pst": "Microsoft Outlook, Personal Folders File",
            "qtx": "QuickTime, image file",
            "ra": "Real Audio sound file",
            "ram": "Real Audio metafile",
            "rar": "rar archive",
            "raw": "raw File Format",
            "reg": "Windows registry file",
            "rm": "Real Audio video file",
            "rtf": "Rich Text Format Document",
            "sav": "Saved game file (generic name)",
            "scr": "Screen saver file",
            "sgml": "Standard Generalized Markup Language file",
            "shtml": "HTML file with Server Side Includes (SSI)",
            "swa": "Audio file",
            "swf": "Flash file",
            "sys": "System file",
            "tar": "compressed file",
            "tga": "Targa bitmap",
            "tif": "Tag Image File Format bitmap file",
            "tiff": "Tag Image File Format Bitmap File",
            "tmp": "Windows temporary file",
            "trm": "Windows Terminal File",
            "ttf": "TrueType Fonts",
            "txt": "Text file",
            "url": "Internet shortcut file",
            "vbg": "Visual Basic, Group Project",
            "vbp": "Visual Basic, Project",
            "vbr": "Visual Basic, Remote automated registration file",
            "vbs": "Visual Basic, Script File",
            "vbw": "Visual Basic, Workspace file",
            "vbx": "Visual Basic, custom control file",
            "vcd": "Virtual CD-ROM",
            "vrml": "VRML file",
            "wab": "Outlook Address Book",
            "war": "Web application Archieve file",
            "wav": "Windows wave file",
            "wcm": "WordPerfect Macro",
            "wej": "Namo web editor, project file",
            "wfx": "Windows Fax File",
            "wks": "Microsoft Works, Document,",
            "wma": "Microsoft Windows Media Audio File",
            "wmf": "Windows Metafile",
            "wmv": "Microsoft, Windows Media files",
            "wp4": "WordPerfect 4 Document",
            "wp5": "WordPerfect 5 Document",
            "wp6": "WordPerfect 6 Document",
            "wpd": "WordPerfect Document",
            "wpg": "WordPerfect graphics",
            "wps": "Microsoft Works, Text Document",
            "wpt": "WordPerfect template",
            "wq1": "Quattro Pro / DOS Spreadsheet",
            "wq2": "Quattro Pro / Version 5 Spreadsheet",
            "wsd": "WordStar, Document File",
            "wsf": "Windows Script File",
            "xcf": "GIMP, image file",
            "xdw": "Xerox DocuWorks Documentation",
            "xlc": "Microsoft Excel chart",
            "xlm": "Microsoft Macro File",
            "xls": "Microsoft Excel file",
            "xlsx": "Microsoft Excel file",
            "xlt": "Microsoft Excel Template",
            "xml": "eXtensible Markup Language file",
            "z": "compressed file",
            "zip": "compressed file"
        },
        "Korean": {
            "$$$": "임시 파일",
            "aif": "Audio Interchange File",
            "aiff": "Audio Interchange File",
            "alz": "이스트소프트 - 알집, 압축 파일",
            "arj": "ARJ 압축 아카이브",
            "asf": "마이크로소프트 Advanced Streaming Format 파일",
            "asm": "어셈블러 파일, 컴파일되지 않은 어셈블리어 파일",
            "asp": "Active Server Page 스크립트 파일",
            "asv": "자동저장 파일 (Auto Save File)",
            "asx": "비디오 파일",
            "au": "사운드 파일",
            "avi": "마이크로소프트 오디오 및 비디오 파일",
            "bak": "백업파일",
            "bas": "비주얼 베이직 모듈 파일",
            "bat": "MS-DOS 일괄처리 파일",
            "bin": "바이너리 파일",
            "c": "C 언어 소스 코드",
            "cfg": "구성 파일",
            "cgi": "CGI 스크립트 파일",
            "chm": "Compiled HTML 파일",
            "com": "MS-DOS용 실행 파일",
            "cpl": "윈도우 제어판 파일",
            "cpp": "비주얼 C/C++ 소스 파일",
            "css": "Cascading Style Sheet file (MIME)",
            "csv": "Comma-separated values file",
            "cur": "윈도우 커서",
            "cxx": "C++ 소스코드 파일",
            "dat": "데이터 파일",
            "dbf": "dBase 파일",
            "dll": "Dynamic Link Library",
            "doc": "마이크로소프트 워드 파일",
            "docx": "마이크로소프트 워드 파일",
            "drv": "드라이버 파일",
            "exe": "실행 파일",
            "fla": "플래시 무비 파일",
            "gdb": "영산정보통신 GVA 및 GVA2000, 압축된 강의 파일",
            "gif": "컴퓨서브 그래픽 파일",
            "gz": "유닉스 gzip 압축 파일",
            "hlp": "도움말 파일",
            "hml": "HWPML(Hangul Word Processor Markup Language) 파일",
            "htm": "하이퍼텍스트 문서",
            "html": "하이퍼텍스트 문서",
            "hwp": "아래아한글 파일",
            "hwt": "아래아한글 서식 파일",
            "ico": "아이콘 파일",
            "img": "이미지 파일",
            "inf": "설치정보 파일",
            "ini": "초기화 파일, 환경설정 파일",
            "iso": "ISO 9660 CD-ROM 파일시스템 표준에 기반을 둔, CD-ROM 상의 파일 목록",
            "jar": "자바 아카이브 (애플릿이나 관련 파일들을 위한 압축 파일)",
            "java": "자바 소스코드",
            "jpe": "JPEG 이미지",
            "jpeg": "JPEG 비트맵 그래픽 파일",
            "jpg": "JPEG 비트맵 그래픽 파일",
            "js": "자바스크립트 소스 파일",
            "log": "로그 파일",
            "mdb": "마이크로소프트 액세스 데이터베이스",
            "mdf": "마이크로소프트, MS-SQL Master 데이터베이스 파일",
            "mdi": "마이크로소프트, 오피스 문서 이미지 파일",
            "mht": "마이크로소프트, MHTML 문서",
            "mp3": "MPEG Audio Layer 3 로 압축된 음악 파일",
            "mp4": "MPEG-4 비디오 파일",
            "mpeg": "MPEG 동영상 파일",
            "nrg": "Nero, ISO 9660 이미지",
            "ocx": "마이크로소프트 OLE custom control",
            "ost": "마이크로소프트 아웃룩, 오프라인 파일",
            "pas": "볼랜드 파스칼, 소스코드 파일",
            "pcx": "PC 페인트브로쉬 비트맵 파일",
            "pdf": "어도비 애크로뱃 문서 형식 (Portable Document Format)",
            "php": "PHP 스크립트가 들어있는 HTML 페이지",
            "php3": "PHP 스크립트가 들어있는 HTML 페이지",
            "phtml": "PHP 스크립트가 들어있는 HTML 페이지",
            "pl": "Perl 프로그램",
            "png": "Portable Network Graphics 이미지 파일",
            "ppt": "마이크로소프트 파워포인트 파일",
            "pptx": "마이크로소프트 파워포인트 파일",
            "prl": "Perl 스크립트",
            "prn": "프린트 파일",
            "psd": "어도비 포토샵 비트맵 파일",
            "pst": "마이크로소프트 아웃룩, 개인 폴더 파일",
            "qtx": "QuickTime, 이미지 파일",
            "ra": "리얼오디오 소리 파일",
            "ram": "리얼오디오 메타 파일",
            "rar": "RAR 압축 파일",
            "raw": "Raw File Format (비트맵)",
            "reg": "윈도우 레지스트리 파일",
            "rm": "리얼오디오 비디오 파일",
            "rtf": "Rich Text Format 문서",
            "sav": "저장된 게임 파일 (일반 명칭)",
            "scr": "화면보호기 파일",
            "sgml": "Standard Generalized Markup Language 파일",
            "shtml": "Server Side Includes (SSI)가 포함되어 있는 HTML 파일",
            "swa": "오디오 파일",
            "swf": "플래시 파일",
            "sys": "시스템 파일",
            "tar": "압축 파일",
            "tga": "Targa 비트맵",
            "tif": "Tag Image File Format 비트맵 파일",
            "tiff": "Tag Image File Format 비트맵 파일",
            "tmp": "윈도우 임시 파일",
            "trm": "윈도우 터미널 파일",
            "ttf": "트루타입 글꼴",
            "txt": "텍스트 파일",
            "url": "인터넷 바로가기 파일",
            "vbg": "비주얼베이직, 그룹 프로젝트",
            "vbp": "비주얼베이직, 프로젝트",
            "vbr": "비주얼베이직, Remote automated registration 파일",
            "vbs": "비주얼베이직, 스크립트 파일",
            "vbw": "비주얼베이직, Workspace 파일",
            "vbx": "비주얼베이직, custom control 파일",
            "vcd": "Virtual CD-ROM",
            "vrml": "VRML 파일",
            "wab": "Outlook 주소록",
            "war": "Web application Archieve 파일",
            "wav": "윈도우 웨이브 파일",
            "wcm": "WordPerfect 매크로",
            "wej": "나모 웹에디터, 프로젝트 파일",
            "wfx": "윈도우 팩스 파일",
            "wks": "Microsoft Works, 문서",
            "wma": "마이크로소프트 Windows Media 오디오 파일",
            "wmf": "윈도우 메타 파일",
            "wmv": "마이크로소프트, 윈도우 미디어 파일",
            "wp4": "WordPerfect 4 문서",
            "wp5": "WordPerfect 5 문서",
            "wp6": "WordPerfect 6 문서",
            "wpd": "WordPerfect 문서",
            "wpg": "WordPerfect 그래픽",
            "wps": "Microsoft Works, 텍스트 문서",
            "wpt": "WordPerfect 템플릿",
            "wq1": "쿼트로프로/DOS용 스프레드시트",
            "wq2": "쿼트로프로/버전5 스프레드시트",
            "wsd": "WordStar, 문서파일",
            "wsf": "Windows 스크립트 파일",
            "xcf": "GIMP, 이미지 파일",
            "xdw": "제록스 DocuWorks 문서",
            "xlc": "마이크로소프트 엑셀 차트",
            "xlm": "마이크로소프트 매크로 파일",
            "xls": "마이크로소프트 엑셀 파일",
            "xlsx": "마이크로소프트 엑셀 파일",
            "xlt": "마이크로소프트 엑셀 서식 파일",
            "xml": "eXtensible Markup Language 파일",
            "z": "압축 파일",
            "zip": "압축 파일"
        }
    }

};

// 언어별로 팝업메뉴를 구성합니다.
function IBUpload_GetContextMenu(){

    if(ibleaders.ibupload.locale=="Korean"){
        return {
            "download": {name: "다운로드 (D)", icon: "", accesskey: "d"},
            "sep1": "---------",
            "viewtype": {
                "name": "보기",
                "items": {
                    "icon": {"name": "아이콘 (C)", accesskey: "c"},
                    "list": {"name": "간단히 (L)", accesskey: "l"},
                    "detail": {"name": "자세히 (D)", accesskey: "d"}
                }
            },
            "sep2": "---------",
            "add": {name: "추가 (A)", icon: "", accesskey: "a"},
            "delete": {name: "제거 (R)", accesskey: "r"}
        };
    }
    if(ibleaders.ibupload.locale=="English"){
        return {
            "download": {name: "download (D)", icon: "", accesskey: "d"},
            "sep1": "---------",
            "viewtype": {
                "name": "view",
                "items": {
                    "icon": {"name": "icon (C)", accesskey: "c"},
                    "list": {"name": "simple (L)", accesskey: "l"},
                    "detail": {"name": "list (T)", accesskey: "d"}
                }
            },
            "sep2": "---------",
            "add": {name: "add file (A)", icon: "", accesskey: "a"},
            "delete": {name: "remove file (R)", accesskey: "r"}
        };
    }
}
//====================================================================================================
// IBSheet 생성
//====================================================================================================
function IBUpload_IBSheetCreate(name, width, height) {
    createIBSheet2($("#" + name)[0], name + "_ibsheet", "100%", "100%");
}
//====================================================================================================
// IBSheet 의 초기화
// 테마별로 이용시 추가 및 변경
//====================================================================================================

function IBSheetLoadPage_Main(sheetObject) {

    var cfg = {ToolTip: 1, DragMode: -1, AutoFitColWidth: "init|resize"};
    sheetObject.SetConfig(cfg);

    var headers;
    if(ibleaders.ibupload.locale=="Korean"){
        headers = [{Text: "||파일명|크기|유형|날짜|상태|URL KEY ", Align: "Center"}];
    }
    if(ibleaders.ibupload.locale=="English"){
        headers = [{Text: "||File name|File size|File type|File date|File status|File Info", Align: "Center"}];
    }
    var info = {Sort: 1, ColMove: 1, ColResize: 1, HeaderCheck: 1};

    sheetObject.InitHeaders(headers, info);

    var cols = [

        //====================================================================================================
        // 업로드 2개의 필수 항목 (체크박스, 파일 다운로드 경로)
        //====================================================================================================
        {Type: "CheckBox", Width: 50, SaveName: "FileSelect", Align: "Center", FitColWidth: 0},
        {Type: "Text", Width: 0, SaveName: "FileKey", Align: "Left", Edit: "0", Hidden: true},

        //====================================================================================================
        // 업로드 선택 항목 ( 이하의 항목은 마음대로 고치셔도 됩니다 )
        //====================================================================================================
        {Type: "Text", Width: 60, SaveName: "FileName", Align: "Left", Edit: "0"},
        {Type: "Int", Width: 48, SaveName: "FileSize", Format: "#,###,##0 KB", Align: "Right", Edit: "0"},
        {Type: "Text", Width: 80, SaveName: "FileType", Align: "Left", Edit: "0"},
        {Type: "Text", Width: 80, SaveName: "FileDate", Align: "Left", Edit: "0"},
        {Type: "Text", Width: 100, SaveName: "FileProgress", Align: "Center", Edit: "0"},
        {Type: "Text", SaveName: "FileUrl", Align: "Left", Edit: "0", Hidden: true}

    ];
    sheetObject.InitColumns(cols);

    sheetObject.SetExtendLastCol(false);
    sheetObject.SetFocusEditMode(0);
    sheetObject.SetSelectionMode(4);
    sheetObject.SetEditable(1);
    sheetObject.SetColEditable(0, true);
    sheetObject.SetEditableColorDiff(0);
    sheetObject.SetEllipsis(1);
    sheetObject.FitColWidth();

}


//====================================================================================================
// ***** 이하 소스코드는 변경하지 마십시오.
//====================================================================================================


/*
 FormQueryString 관련 함수 정의
 */
/* FormQueryString과 FormQueryStringEnc함수에서 필수입력 체크시 메시지로 사용한다.-3.4.0.50 */
var IBS_MSG_REQUIRED = "은(는) 필수입력 항목입니다.";

/**
 * 에러메시지를 표시한다. IBS_ShowErrMsg 대신 이 함수를 사용해야 한다.
 * @param   : sMsg      - 메시지
 * @return  : 없음
 * @version : 3.4.0.50
 * @sample
 *  IBS_ShowErrMsg("에러가 발생했습니다.");
 */
function IBS_ShowErrMsg(sMsg) {
    return alert("[IBSheetInfo.js]\n" + sMsg);
}

function IBS_getName(obj) {
    if (obj.name != "") {
        return obj.name;
    } else if (obj.id != "") {
        return obj.id;
    } else {
        return "";
    }
}

function IBS_RequiredChk(obj) {
    return (obj.getAttribute("required") != null);
}

/**
 * Form오브젝트 안에 있는 컨트롤을 QueryString으로 구성한다. 이때, 한글은 인코딩하지 않는다.
 * @param   : form          - 필수,html의 Form 오브젝트 Name
 * @param   : checkRequired - 선택,필수입력 체크 여부(true,false)
 * @return  : String        - Form오브젝트 안에 Control을 QueryString으로 구성한 문자열
 *            undefined     - checkRequired인자가 true이고, 필수입력에 걸린경우 return 값
 * @version : 1.0.0.0,
 *            3.4.0.50(checkRequired 인자 추가)
 * @sample1
 *  var sCondParam=FormQueryString(document.frmSearch); //결과:"txtname=이경희&rdoYn=1&sltMoney=원화";
 * @sample2
 *  <input type="text" name="txtName" required="이름">        //필수 입력 항목이면 required="이름" 를 설정한다.
 *  var sCondParam = FormQueryString(document.mainForm, true);//필수입력까지 체크하며, 필수입력에 걸리면 리턴값은 null
 *  if (sCondParam==null) return;
 */
function FormQueryString(form, checkRequired) {
    if (typeof form != "object" || form.tagName != "FORM") {
        IBS_ShowErrMsg("FormQueryString 함수의 인자는 FORM 태그가 아닙니다.");
        return "";
    }

    if (checkRequired == null) checkRequired = false;

    var name = new Array(form.elements.length);
    var value = new Array(form.elements.length);
    var j = 0;
    var plain_text = "";

    //사용가능한 컨트롤을 배열로 생성한다.
    len = form.elements.length;
    for (i = 0; i < len; i++) {
        var prev_j = j;
        switch (form.elements[i].type) {
            case undefined:
            case "button":
            case "reset":
            case "submit":
                break;
            case "radio":
            case "checkbox":
                if (form.elements[i].checked == true) {
                    name[j] = IBS_getName(form.elements[i]);
                    value[j] = form.elements[i].value;
                    j++;
                }
                break;
            case "select-one":
                name[j] = IBS_getName(form.elements[i]);
                var ind = form.elements[i].selectedIndex;
                if (ind >= 0) {

                    value[j] = form.elements[i].options[ind].value;

                } else {
                    value[j] = "";
                }
                j++;
                break;
            case "select-multiple":
                name[j] = IBS_getName(form.elements[i]);
                var llen = form.elements[i].length;
                var increased = 0;
                for (k = 0; k < llen; k++) {
                    if (form.elements[i].options[k].selected) {
                        name[j] = IBS_getName(form.elements[i]);
                        value[j] = form.elements[i].options[k].value;

                        j++;
                        increased++;
                    }
                }
                if (increased > 0) {
                    j--;
                } else {
                    value[j] = "";
                }
                j++;
                break;
            default:
                name[j] = IBS_getName(form.elements[i]);
                value[j] = form.elements[i].value;
                j++;
        }

        if (checkRequired) {
            //html 컨트롤 태그에 required속성을 설정하면 필수입력을 확인할 수 있다.
            //<input type="text" name="txtName" required="이름">

            if (IBS_RequiredChk(form.elements[i]) && prev_j != j && value[prev_j] == "") {

                if (form.elements[i].getAttribute("required") == null ||
                    form.elements[i].getAttribute("required") == ""
                ) {
                    alert('"' + IBS_getName(form.elements[i]) + '"' + IBS_MSG_REQUIRED);
                } else {
                    alert('"' + form.elements[i].getAttribute("required") + '"' + IBS_MSG_REQUIRED);
                }
                //컨트롤이 숨겨져 있을수도 있으므로 에러 감싼다.
                try {
                    form.elements[i].focus();
                } catch (e) {
                }

                return;
            }
        }
    }
    //QueryString을 조합한다.
    for (i = 0; i < j; i++) {
        if (name[i] != '') plain_text += name[i] + "=" + value[i] + "&";
    }

    //마지막에 &를 없애기 위함
    if (plain_text != "") plain_text = plain_text.substr(0, plain_text.length - 1);

    return plain_text;
}

/**
 * Form오브젝트 안에 있는 컨트롤을 QueryString으로 구성한다. 이때, 한글은 인코딩한다.
 * @param   : form          - 필수,html의 Form 오브젝트 Name
 * @param   : Sheet         - 필수,IBheet의 Object id
 * @param   : checkRequired - 선택,필수입력 체크 여부(true,false)
 * @return  : String        - Form오브젝트 안에 Control을 QueryString으로 구성한 문자열
 *            undefined     - checkRequired인자가 true이고, 필수입력에 걸린경우 return 값
 * @version : 1.0.0.0,
 *            3.4.0.50(checkRequired 인자 추가)
 * @sample1
 *  var sCondParam=FormQueryStringEnc(document.frmSearch, mySheet1);
 *  원본:"txtname=이경희&rdoYn=1&sltMoney=원화";
 *  결과:"txtname=%C0%CC%B0%E6%C8%F1&rdoYn=1&sltMoney=%BF%F8%C8%AD";                //UTF16인 경우
 *  결과:"txtname=%EC%9D%B4%EA%B2%BD%ED%9D%AC&rdoYn=1&sltMoney=%EC%9B%90%ED%99%94"; //UTF8인 경우
 * @sample2
 *  <input type="text" name="txtName" required="이름">                    //필수 입력 항목이면 required="이름" 를 설정한다.
 *  var sCondParam = FormQueryStringEnc(document.mainForm, mySheet, true);//필수입력까지 체크하며, 필수입력에 걸리면 리턴값은 null
 *  if (sCondParam==null) return;
 */
function FormQueryStringEnc(form, checkRequired) {
    if (typeof form != "object" || form.tagName != "FORM") {
        IBS_ShowErrMsg("FormQueryStringEnc 함수의 form 인자는 FORM 태그가 아닙니다.");
        return "";
    }


    if (checkRequired == null) checkRequired = false;

    var name = new Array(form.elements.length);
    var value = new Array(form.elements.length);
    var j = 0;
    var plain_text = "";

    //사용가능한 컨트롤을 배열로 생성한다.
    len = form.elements.length;
    for (i = 0; i < len; i++) {
        var prev_j = j;
        switch (form.elements[i].type) {
            case "button":
            case "reset":
            case "submit":
                break;
            case "radio":
            case "checkbox":
                if (form.elements[i].checked == true) {
                    name[j] = IBS_getName(form.elements[i]);
                    value[j] = form.elements[i].value;
                    j++;
                }
                break;
            case "select-one":
                name[j] = IBS_getName(form.elements[i]);
                var ind = form.elements[i].selectedIndex;
                if (ind >= 0) {

                    value[j] = form.elements[i].options[ind].value;

                } else {
                    value[j] = "";
                }
                j++;
                break;
            case "select-multiple":
                name[j] = IBS_getName(form.elements[i]);
                var llen = form.elements[i].length;
                var increased = 0;
                for (k = 0; k < llen; k++) {
                    if (form.elements[i].options[k].selected) {
                        name[j] = IBS_getName(form.elements[i]);

                        value[j] = form.elements[i].options[k].value;

                        j++;
                        increased++;
                    }
                }
                if (increased > 0) {
                    j--;
                } else {
                    value[j] = "";
                }
                j++;
                break;
            default:

                name[j] = IBS_getName(form.elements[i]);
                value[j] = form.elements[i].value;
                j++;
        }

        if (checkRequired) {
            //html 컨트롤 태그에 required속성을 설정하면 필수입력을 확인할 수 있다.
            //<input type="text" name="txtName" required="이름">
            if (IBS_RequiredChk(form.elements[i]) && prev_j != j && value[prev_j] == "") {
                if (form.elements[i].getAttribute("required") == "") {
                    alert('"' + IBS_getName(form.elements[i]) + '"' + IBS_MSG_REQUIRED);
                } else {
                    alert('"' + form.elements[i].getAttribute("required") + '"' + IBS_MSG_REQUIRED);
                }
                //컨트롤이 숨겨져 있을수도 있으므로 에러 감싼다.
                try {
                    form.elements[i].focus();
                } catch (e) {
                }
                return;
            }
        }
    }

    //QueryString을 조합한다.
    for (i = 0; i < j; i++) {
        if (name[i] != '') plain_text += encodeURIComponent(name[i]) + "=" + encodeURIComponent(value[i]) + "&";
    }

    //마지막에 &를 없애기 위함
    if (plain_text != "") plain_text = plain_text.substr(0, plain_text.length - 1);

    return plain_text;
}


//====================================================================================================
// 파일 확장자별로 지원가능한 아이콘 이미지 명 얻기
//====================================================================================================
function _IBUpload_mFileType2ImageName(FileName) {

    if (FileName == undefined) {
        return "file";
    }

    var part;
    part = FileName.split(".");
    var sFileExt = part[part.length - 1];
    if (sFileExt) sFileExt = (sFileExt + "").toLowerCase();

    if (ibleaders.ibupload.supportIcon && ibleaders.ibupload.supportIcon.match(/[A-Z]/)) {
        ibleaders.ibupload.supportIcon = (ibleaders.ibupload.supportIcon+"").toLowerCase();
    }

    if ((" " + ibleaders.ibupload.supportIcon + " ").indexOf(sFileExt) > -1) {
        return sFileExt;
    } else {
        return "file";
    }
}



//--------------------------------------------------------------------------------
// 업로드 컨트롤에 들어가는 용량 크기 ( 콤마구분자와 KB 가 들어간 Text 형태)
//--------------------------------------------------------------------------------
function _IBUpload_mNumberToKByte(size) {
    return (-(Math.floor(-(size / 1024)))).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",") + " KB";
}

//--------------------------------------------------------------------------------
// 업로드 컨트롤에 들어가는 용량 크기 ( 순수한 숫자 값 - ibsheet 모드에서 SetCellValue 로 들어감 )
//--------------------------------------------------------------------------------
function _IBUpload_mNumberToKByteValue(size) {
    return (-(Math.floor(-(size / 1024))));
}


//--------------------------------------------------------------------------------
// 확장자를 보고 유형 설명글 을 얻음
//--------------------------------------------------------------------------------
function _IBUpload_mFileType2Desc(FileName) {
    if (FileName == null) {
        return ibleaders.ibupload.message[ibleaders.ibupload.locale]["TEXT-EtcFile"];
    }

    var part;
    part = FileName.split(".");
    var sFileExt = part[part.length - 1];

    var result = "";

    if (ibleaders.ibupload.fileType[ibleaders.ibupload.locale][sFileExt] !== undefined) {
        result = ibleaders.ibupload.fileType[ibleaders.ibupload.locale][sFileExt];
    } else {
        result = ibleaders.ibupload.message[ibleaders.ibupload.locale]["TEXT-EtcFile"];
    }
    return result;
}

//--------------------------------------------------------------------------------
// getFiles 로 얻은 File 자료로 부터 아이콘 + 파일명 을 얻음
//--------------------------------------------------------------------------------
function _IBUpload_GetIcon_FileName(FileData, i) {

    var result = "";

    var OneFile = (FileData + "\n\n").split("\n")[i];
    var FileInfo = OneFile.split("|");  // 파일명 / 날짜 / 크기 / FileUrl KeyWord
    // trim
    FileInfo[0] = FileInfo[0].replace(/^\s+|\s+$/g, "");

    if (FileInfo[0] != "") {
        result += "&nbsp;";
        result += "<img  align=absmiddle src=\"icon_image/icon16/";
        result += _IBUpload_mFileType2ImageName(FileInfo[0]) + ".gif\">";
        result += " ";
        result += FileInfo[0];
    }

    return result;
}

//--------------------------------------------------------------------------------
// files 문자열로부터 간단한 파일명 리스트만 얻음
//--------------------------------------------------------------------------------
// (예)
//--------------------------------------------------------------------------------
function _IBUpload_GetFileNamesFromFiles(FileData) {

    var items = FileData.split("\"name\":\"");

    items[0] = "";
    for (var i = 1; i < items.length; i++) {
        items[i] = items[i].substring(0, items[i].indexOf("\"")) + " ";
    }

    return items.join("");
}


//--------------------------------------------------------------------------------
// 시간 태그를 보고 날짜 시각을 얻음
//--------------------------------------------------------------------------------
function _IBUpload_mFileName2Date(FileUrl) {
    if (FileUrl == "") return;
    var result = FileUrl.substring(FileUrl.lastIndexOf("/") + 1, FileUrl.length);
    var AmPm = (result.substring(8, 10) * 1 < 12) ? ibleaders.ibupload.message[ibleaders.ibupload.locale]["TEXT-DateAm"] : ibleaders.ibupload.message[ibleaders.ibupload.locale]["TEXT-DatePm"];
    return result.substring(0, 4) + "-" + result.substring(4, 6) + "-" + result.substring(6, 8) + " " + AmPm + " " + result.substring(8, 10) * 1 % 12 + ":" + result.substring(10, 12);
}

//--------------------------------------------------------------------------------
// 진행율 표시
//--------------------------------------------------------------------------------
function _IBUpload_mFileProgress(iProgress, iURL) {
    if (iProgress == 0) { // 업로드 대기 상태
        return ibleaders.ibupload.message[ibleaders.ibupload.locale]["TEXT-FileWait"];
    } else if (iProgress == 100) { // 업로드 완료 상태
        return ibleaders.ibupload.message[ibleaders.ibupload.locale]["TEXT-FileAvail"];
    } else {
        return iProgress + "%";
    }
}

//--------------------------------------------------------------------------------
// IE11 버그 용 내부 함수
//--------------------------------------------------------------------------------
function _IBUpload_Korea_Char() {
    return "가";
}
