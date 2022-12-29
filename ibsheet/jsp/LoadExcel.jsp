﻿<%@page import="com.ibleaders.ibsheet.util.Version"%>
<%@ page language="java" contentType="text/html;charset=UTF-8" pageEncoding="UTF-8"
%><%@page import="com.ibleaders.ibsheetLoader.IBSheetLoad"
%><%@page import="java.util.ArrayList"
%><%@page import="java.util.List"
%><%@page import="java.io.*" 
%><%

    out.clear();
    out = pageContext.pushBody();
    
    System.out.println(Version.getVersion());

    IBSheetLoad load = null;
    
    try {

        load = new IBSheetLoad();

        //====================================================================================================
        // [ 사용자 환경 설정 #0 ]
        //====================================================================================================
        // Html 페이지의 인코딩이 UTF-8 로 구성되어 있으면 "load.setEncoding("UTF-8");" 로 설정하십시오.
        // 한글 헤더가 있는 그리드에서 엑셀 로딩이 동작하지 않으면 이 값을 바꿔 보십시오.
        // Down2Excel.jsp 에서의 설정값과 동일하게 바꿔주십시오.
        // setService 전에 설정해야 합니다.
        //====================================================================================================
        load.setEncoding("UTF-8");

        //====================================================================================================
        // [ 사용자 환경 설정 #1 ]
        //====================================================================================================
        // 엑셀 전문의 MarkupTag Delimiter 사용자 정의 시 설정하세요.
        // 설정 값은 IBSheet7 환경설정(ibsheet.cfg)의 MarkupTagDelimiter 설정 값과 동일해야 합니다.
        //====================================================================================================      
        //load.setMarkupTagDelimiter("[s1]","[s2]","[s3]","[s4]");

				//====================================================================================================
				// [ 사용자 환경 설정 #2 ]
				//====================================================================================================
				// 시트에 포함될 문자열 중 STX(\u0002), ETX(\u0003) 이 포함된 경우에만 설정해주세요.
				// 설정을 원하지 않는 경우 주석처리해주세요.
				// 0 : 시트 구분자로 STX, ETX 문자를 사용합니다. (기본값)
				// 1 : 시트 구분자로 변형된 문자열을 사용합니다. (시트에 설정이 되어 있어야 합니다.)
				//====================================================================================================
				//load.setDelimMode(1);

				//====================================================================================================
				// [ 사용자 환경 설정 #3 ]
				//====================================================================================================
				// 엑셀의 머지된 셀의 처리를 설정합니다.
				// true인 경우 머지된 셀의 첫번째 셀 기준으로 데이터를 로드하고(기본값),  false인 경우에는 로드하지 않습니다.
				//====================================================================================================      
				//load.setMergeProcess(false);


				//====================================================================================================
				// [ 사용자 환경 설정 #4 ]
				//====================================================================================================
				// HeaderMatch 사용 시 시트에 있는 헤더가 엑셀에 하나라도 존재하지 않는 경우 오류메시지를 출력하고 데이터를 로딩하지 않을지 여부.
				//====================================================================================================
				//load.setStrictHeaderMatch(true);

				//====================================================================================================
				// [ 사용자 환경 설정 #5 ]
				//====================================================================================================
				// LoadExcel 처리를 허용할 최대 행 수를 설정한다.
				// 엑셀 데이터가 지정한 행 수보다 많은 경우 메시지를 출력하고 처리가 종료된다.
				//====================================================================================================
				//load.setMaxRows(100);

				//====================================================================================================
				// [ 사용자 환경 설정 #6 ]
				//====================================================================================================
				// LoadExcel 처리를 허용할 최대 열 수를 설정한다.
				// 엑셀 데이터가 지정한 열 수보다 많은 경우 메시지를 출력하고 처리가 종료된다.
				//====================================================================================================
				//load.setMaxColumns(20);

				//====================================================================================================
				// [ 사용자 환경 설정 #7 ]
				//====================================================================================================
				// 엑셀의 비어있는 행도 로드하도록 설정한다.
				// false로 설정하는 경우 비어있는 행을 로드하고, true인 경우에는 비어있는 행을 건너뛴다.
				// 시트의 LoadExcel({ SkipEmptyRow  : false }); 옵션과 동일하게 작동한다.
				// LoadExcel에서 StartRow를 설정한 경우, 해당 행은 검사하지 않는다.
				//====================================================================================================
				//load.setSkipEmptyRow(false);
				
				//====================================================================================================
				// [ 사용자 환경 설정 #8 ]
				//====================================================================================================
				// 업로드 가능한 최대 파일 사이즈를 설정한다.
				// kb 단위로 1024 * 5 로 설정시 5MB를 의미한다.
				//====================================================================================================
				//load.setMaxFileSize(1024 * 5);

				//====================================================================================================
				// HttpServletRequest, HttpServletResponse를 IBSheet 서버모듈에 등록합니다.
				//====================================================================================================
				load.setService(request, response);

        
		/** 서버로 전송된 파일을 가공해서 사용해야 할 경우. (예, DRM 복호화 등)
        // 서버에 저장된 파일 객체
        File uploadFile = load.getUploadFile();
		String uploadFileName = uploadFile.getName();
		String uploadFilePath = uploadFile.getAbsolutePath();

        // TODO
        // 업로드된 엑셀 파일을 가공함 (예, 엑셀문서를 DRM 처리함)
		
		// 가공된 파일을 ibSheet에서 읽을 수 있도록 처리.
		load.loadFile(uploadFile);
		**/

        //브라우저에 데이터를 전달하여 시트에 로드
        load.writeToBrowser();

    } catch (Exception e) {
        //e.printStackTrace();
        OutputStream out2 = response.getOutputStream();
        out2.write(("<script>var targetWnd = null; if(opener!=null) {targetWnd = opener;} else {targetWnd = parent;} targetWnd.Grids[0].LoadExcelError(); </script>").getBytes());
        out2.flush();
        

    } catch (Error e) {
    	OutputStream out2 = response.getOutputStream();
        out2.write(("<script>var targetWnd = null; if(opener!=null) {targetWnd = opener;} else {targetWnd = parent;} targetWnd.Grids[0].LoadExcelError(); </script>").getBytes());
        out2.flush();
        //e.printStackTrace();
    } finally {
        if (load != null) {
            load.close();
        }
        load = null;
    }
%>