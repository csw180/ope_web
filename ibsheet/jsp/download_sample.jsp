<%@ page contentType="text/html; charset=utf-8" pageEncoding="utf-8"
%><%@ page import="java.io.*,java.util.*,java.net.URLEncoder, 
								javax.servlet.*,
								org.apache.tools.zip.ZipEntry, 
								org.apache.tools.zip.ZipOutputStream, 
								org.apache.commons.fileupload.*,
								org.apache.commons.fileupload.disk.*,
								org.apache.commons.fileupload.servlet.*,
								org.apache.commons.io.IOUtils,
								java.nio.channels.Channels,
								java.nio.channels.WritableByteChannel,
								java.nio.channels.FileChannel"
%><%
	// ====================================================================================================
	// ※ 처음 설치시 주의사항 - 아래 항목들을 검토하고 필수변경요소는 반드시 설정 또는 변경해야 합니다.
	//  - 이 파일은 다운로드 작업에 대한 템플릿으로 사용자 권한에 따른 다운로드 가능/불가능 여부에 대한 설정은 직접 작업해 주셔야 합니다.
	// ====================================================================================================
	// ① [필수변경요소] 업로드 루트 경로 지정 - 실제로 파일이 업로드 되어 저장되는 경로
	// ② [옵션][기본값:utf-8] 업로드 엔코딩 - 첨부 파일에 한글이 포함되어 있는 경우 엔코딩 방식
	// ※ [참고사항] JDK 1.6 에서 설계 및 테스트 되었습니다.
	// ====================================================================================================

	
	out.clear();
    out = pageContext.pushBody();
    
	try{
		Thread.sleep(500);
		//파일 다운로드
		DownloadFiles(request,response);
	} catch(Exception ex) {
	    
	    setDownloadToken(response, "fail");
	    
		ex.printStackTrace();
		//response.reset();
		response.setCharacterEncoding("utf-8");
		out.print("<script>alert('오류가 발생하였습니다.');</script>");
		//오류에 대한 자세한 내역이 필요하다면 다음과 같이 사용하세요.
		//String msg = ((ex.getMessage()).replaceAll("\n", "\\\\n")).replaceAll("\r", "\\\\r");
		//out.print("<script>alert('오류가 발생하였습니다.\n오류 상세내역: " + msg.replaceAll("<","&lt;").replaceAll(">","&gt;") + "');</script>");
	}

	
%><%!

public void setDownloadToken(HttpServletResponse response, String downloadToken) {
    Cookie cookie = new Cookie("token", downloadToken);
	
	/** ##################################################### **/
	/** 중요! **/
	/** SSL 적용이 되지 않은 서버에서는 다음 구문을 삭제하고 사용하세요. **/
	//cookie.setSecure(true);
	/** ##################################################### **/
	cookie.setPath("/");
	cookie.setMaxAge(1*60*60);
	response.addCookie(cookie);
}
public void removeToken(HttpServletRequest request,HttpServletResponse response) {
    Cookie cookie = new Cookie("token", "");
	
	/** ##################################################### **/
	/** 중요! **/
	/** SSL 적용이 되지 않은 서버에서는 다음 구문을 삭제하고 사용하세요. **/
	//cookie.setSecure(true);
	/** ##################################################### **/
	cookie.setPath("/");
	cookie.setMaxAge(-1);
	response.addCookie(cookie);
}

public void DownloadFiles(HttpServletRequest request,HttpServletResponse response) throws Exception{
	String DownloadRootDir = "C:/file_uploaded/";	
	DownloadFiles( request, response,  DownloadRootDir);
}
public void DownloadFiles(HttpServletRequest request,HttpServletResponse response, String DownloadRootDir) throws IllegalArgumentException,NullPointerException,IOException,FileNotFoundException,Exception{
	//====================================================================================================
	// ③ [추후 추가 개발 요소] IBUpload 설치가 성공적으로 완료된 이후에 현업 업무 로직을 추가할 수 있습니다.
	//====================================================================================================
	// ♣ 가 표시된 부분은 개발자가 직접 현업의 파일관리 정책과 DB 처리 등에 따라 소스 코드를 수정 / 변경 / 응용해야 할 부분입니다.
	//
	// ♣1 : GetRealFilePathFromURLKey 함수의 수정
	//	※ 업로드 폴더에서 직접 다운로드 할 경우에는 변경할 필요가 없습니다. (☞ 소스코드 맨 아래 함수 참조.)
	//
	//	- DB 에 파일을 저장하는 경우 : DB 로부터 파일을 얻어서 임시 폴더에 저장하고 해당 파일의 전체 경로를 리턴해주면 됩니다.
	//	- 별도의 디스크 경로로 관리하는 경우 : 요청된 UrlKey 에 해당되는 실제 존재하는 파일 경로를 리턴해주면 됩니다.
	//====================================================================================================

	//System.out.println("DownloadFiles");
	//====================================================================================================
	// 아래의 코드는 수정하지 마십시오.
	//====================================================================================================
	String ContentType = "" + request.getContentType();
	String DownloadFiles = ""; // 다운로드 할 파일들
	String ParentID = "";
	String FileDownloadNo = "";
	//========================================================================================================================
    // 파일 다운로드 시 구분자 설정(ibuploadinfo.js 파일에서 fileSeparator 옵션에서 설정했던 구분자를 넣는다.)
    // 1. 1개의 문자만 사용가능.
    // 2. /,\는 사용 불가.
    // 3. fileSeparator를 지정하지 않았을 경우 " "로 적용된다.
    //========================================================================================================================
	String fileSeparator = "|";
	
	//--------------------------------------------------------------------------------
	// [요청자 검증]
	//--------------------------------------------------------------------------------
	if (ContentType != null && !"".equals(ContentType) && ContentType.indexOf("multipart/form-data") == -1) {

		request.setCharacterEncoding("utf-8");

		String DownloadFileName = "";
		String DownloadFileURL = "";
		String UserAgent = request.getHeader("User-Agent");
		String DownloadToken = "";

		if (request.getParameter("token") != null) {
			DownloadToken = request.getParameter("token");
		}
		if (request.getParameter("file") != null) {
			DownloadFiles = "" + request.getParameter("file");
		}
		ParentID = request.getParameter("parentid");
		FileDownloadNo = request.getParameter("filedownloadno");

		if (request.getParameter(ParentID + "_downloadFileName" + FileDownloadNo) != null) {
			DownloadFileName = "" + request.getParameter(ParentID + "_downloadFileName" + FileDownloadNo)
					+ ".zip";
		} else {
			DownloadFileName = "download.zip";
		}

		response.setHeader("Content-Transfer-Encoding", "binary;");
		response.setHeader("Pragma", "no-cache;");
		response.setHeader("Expires", "-1;");

		response.setContentType("application/octet-stream");

		//System.out.println("DownloadToken="+DownloadToken);
		
		//쿠키 검증
		if (DownloadToken.indexOf("\r\n") >= 0) {
			return;
		}
		
		setDownloadToken(response, DownloadToken);
		
		//Array -> List 변경
			
		int idx = DownloadFiles.indexOf("\n");
		int itemLen = 0;
		
		List<String> downItem = null;
		
		if (idx > -1) {
			downItem = Arrays.asList(DownloadFiles.split("\n"));
			itemLen = downItem.size();
		}

		if (itemLen == 0) {
			
		    //요청 파일이 없음.
		    return;
		    
		} else if (itemLen == 1) {
			DownloadFileURL = DownloadFiles.substring(0, DownloadFiles.indexOf(fileSeparator));
			DownloadFileName = DownloadFiles.substring(DownloadFiles.indexOf(fileSeparator) + 1, DownloadFiles.length());
			DownloadFileName = DownloadFileName.trim();
			if(!new File(DownloadRootDir+ DownloadFileURL).exists()){
				//System.out.println("요청한 파일이 서버에 존재하지 않습니다.");
				//파일명에 대한 자세한 안내가 필요하다면 다음과 같이 사용하세요.
				//System.out.println(DownloadFileName+":[실제 파일] "+DownloadFileURL+"\n 파일이 존재하지 않습니다.");
				throw new FileNotFoundException(DownloadFileName+"\n파일이 존재하지 않습니다.");
			}
		}

		int bytesRead;
		byte bytes[] = new byte[8192];

		if (itemLen == 1) {
			response.setContentType("application/octet-stream");

			String item = DownloadFileURL;
			item = item.trim();
			item = item.replaceFirst("(http|https|ftp)://", "");
//			item = item.substring(item.indexOf("/") + 1, item.length());

			try {

				if (new File(GetRealFilePathFromURLKey(DownloadRootDir, item)).isFile()) {
					if (UserAgent.contains("MSIE") || UserAgent.contains("Trident")
							|| UserAgent.contains("Edge")) {
						DownloadFileName = URLEncoder.encode(DownloadFileName, "utf-8").replaceAll("\\+",
								"%20");
						response.setHeader("Content-Disposition",
								"attachment;filename=" + DownloadFileName + ";");
					} else {
						DownloadFileName = new String(DownloadFileName.getBytes("utf-8"), "ISO-8859-1");
						response.setHeader("Content-Disposition",
								"attachment;filename=\"" + DownloadFileName + "\"");
					}
					
					ServletOutputStream outFile1 = response.getOutputStream();
					File file = new File(DownloadRootDir + item);
					FileInputStream fis = new FileInputStream(file);
					
					/*
                    // 방법 1.
                    // Response의 OutputStream에 파일 순차적으로 기록 - 무난한 방법입니다.
					BufferedInputStream bis = new BufferedInputStream(fis);
					while ((bytesRead = fis.read(bytes, 0, 8192)) != -1) {
						outFile1.write(bytes, 0, bytesRead);
					}
					
					bis.close();
					fis.close();
					
					outFile1.flush();
					outFile1.close();
					// 방법 1.
                    */
                    
					/*
                    // 방법 2.
                    // IOUtils 라이브러리를 사용해서 파일을 쓰는 방식 - common-io 라이브러리가 필요합니다.
                    
                    IOUtils.copy(fis, outFile1);
                    fis.close();
                    response.flushBuffer();
                    
                    // 방법 2.
                    */
                    
                    // 방법3. 
                    // fileChannel을 사용한 빠른 복사. 속도가 빠르고 메모리 사용량이 더 많습니다.
                    // 방법 1이나 2를 사용한 경우에
                    // 사용자가 다운로드 취소시 IOException이나 ClientAbortException이 발생한다면
                    // 방법 3을 사용하고 다운로드 전 후로 session 클리어하는 작업이 필요합니다.
                    // 서버에 따라서 사용자에 의한 파일전송 중단을 Exception으로 발생시켜 경고하는 기능이 들어있습니다.
                    // 서버에 장애가 발생하는 부분은 아니지만 오류로 판단해서 처리하면 서버에 부하가 가중됩니다.
                    
                    FileChannel inputChannel = null;
                    WritableByteChannel outputChannel = null;

                    inputChannel = fis.getChannel();
                    outputChannel = Channels.newChannel(outFile1);
                    inputChannel.transferTo(0, fis.available(), outputChannel);
                    
                    try {
                        fis.close();
                        inputChannel.close();
                        outputChannel.close();
                    } catch(Exception e) {
                        fis = null;
                        inputChannel = null;
                        outputChannel = null;
                    }
                    
                    outFile1.close();
                    // 방법3.

				}
				
			} catch (IllegalArgumentException ex){
				throw new IllegalArgumentException("DownloadFiles:"+ex.getMessage());
			} catch (NullPointerException ex){
				throw new NullPointerException("DownloadFiles:"+ex.getMessage());
			} catch (FileNotFoundException ex){
				throw new FileNotFoundException("DownloadFiles:"+ex.getMessage());
			} catch (IOException ex){
			  	//System.out.println("사용자에 의한 다운로드 취소 또는 파일 다운로드 대기중 동일 요청");
			  	// 이 경우는 사용자에 의한 다운로드 중단.
                // 서버 오류는 아니나 경고의 의미로 Exception이 발생함.
				//throw new IOException("DownloadFiles:"+ex.getMessage());
			} catch (Exception ex) {
			    throw new Exception("DownloadFiles:"+ex.getMessage());
			}

		} else if (itemLen > 1) {
			response.setContentType("application/zip");

			try {

				if (UserAgent.contains("MSIE") || UserAgent.contains("Trident") || UserAgent.contains("Edge")) {
					DownloadFileName = URLEncoder.encode(DownloadFileName, "utf-8").replaceAll("\\+", "%20");
					response.setHeader("Content-Disposition", "attachment;filename=" + DownloadFileName + ";");
				} else {
					DownloadFileName = new String(DownloadFileName.getBytes("utf-8"), "ISO-8859-1");
					response.setHeader("Content-Disposition",
							"attachment;filename=\"" + DownloadFileName + "\"");
				}

				ServletOutputStream sos = response.getOutputStream();
				ZipOutputStream zos = new ZipOutputStream(sos);
				zos.setEncoding("euc-kr");
				for (String item : downItem) {
					item = item.trim();
					item = item.replaceFirst("(http|https|ftp)://", "");
//					item = item.substring(item.indexOf("/") + 1, item.length());

					DownloadFileURL = item.substring(0, item.indexOf(fileSeparator));
					DownloadFileName = item.substring(item.indexOf(fileSeparator) + 1, item.length());
					if(!new File(DownloadRootDir + DownloadFileURL).exists()){
						//System.out.println("요청한 파일이 서버에 존재하지 않습니다.");
						//파일명에 대한 자세한 안내가 필요하다면 다음과 같이 사용하세요.
						//System.out.println(DownloadFileName+":[실제 파일] "+DownloadFileURL+"\n 파일이 존재하지 않습니다.");
						throw new FileNotFoundException(DownloadFileName+"\n파일이 존재하지 않습니다.");
					}
					//====================================================================================================
					// 실제 다운로드 받을 파일이 존재하는 경우에만 압축 파일에 넣어준다.
					//====================================================================================================
					if (new File(GetRealFilePathFromURLKey(DownloadRootDir, DownloadFileURL)).isFile()) {
						
						FileInputStream fis = new FileInputStream(DownloadRootDir + DownloadFileURL);
						BufferedInputStream bis = new BufferedInputStream(fis);

						ZipEntry zipEntry = new ZipEntry(DownloadFileName);
						zos.putNextEntry(zipEntry);
						while ((bytesRead = bis.read(bytes)) != -1) {
							zos.write(bytes, 0, bytesRead);
						}
						bis.close();
						fis.close();
						zos.flush();
						zos.closeEntry();
					}
				}

				zos.close();
				sos.close();
				
			} catch (IllegalArgumentException ex){
				throw new IllegalArgumentException("DownloadFiles:"+ex.getMessage());
			} catch (NullPointerException ex){
				throw new NullPointerException("DownloadFiles:"+ex.getMessage());
			} catch (FileNotFoundException ex){
				throw new FileNotFoundException("DownloadFiles:"+ex.getMessage());
			} catch (IOException ex){
				throw new IOException("DownloadFiles:"+ex.getMessage());
			} catch (Exception ex) {
				ex.printStackTrace();
				throw ex;
			}
		}
	}
}
	//====================================================================================================
	// ♣1 : client 에서 요청하는 URL KEY 값을 실제로 저장된 디스크의 물리적 전체경로를 리턴함
	//====================================================================================================
	// ㆍ입력값(UrlKey)의 예 : 20161231_235959_000001
	// ㆍ리턴값의 예 : C:/file_uploaded/20161231_235959_000001
	//
	// ※ 업로드 폴더에 실제로 고유 파일을 저장하는 경우에는 변경할 필요가 없습니다.
	// ※ DB 에 저장하거나 별도의 디스크에 저장되어 관리되는 경우 실제 저장된 파일 경로를 리턴해 주시면 됩니다.
	//
	//====================================================================================================
	String GetRealFilePathFromURLKey(String UploadRootDir, String UrlKey) {
		return UploadRootDir + UrlKey;
	}%>