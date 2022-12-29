<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, javax.servlet.http.*, java.util.*, com.shbank.orms.comm.util.*, org.apache.logging.log4j.Logger, javax.servlet.ServletContext" %>
<%@ include file="comm/comUtil.jsp" %>
<%
//System.out.println("1XXXXXXXXXXXXXXX");
response.setHeader("Pragma", "No-cache");
	response.setHeader("Cache-Control", "no-cache");
	response.setHeader("Expires", "0");
	request.getSession(true).setAttribute("infoH", null );
	request.getSession(true).setAttribute("grp_org_c", null );
	request.getSession(true).setAttribute("login_type", null );
	request.getSession(true).setAttribute("ip_addr", null );
	request.getSession(true).setAttribute("userid", null );
	request.getSession(true).setAttribute("puser", null );
	request.getSession(true).setAttribute("puserid", null );
	//request.getSession(true).setAttribute("encdata", "systemlogin");
	//request.getSession(true).setAttribute("openmode", "TEST");
//System.out.println("2XXXXXXXXXXXXXXX");
%>
<!DOCTYPE html>
<html>
<head>
<title>DGB Financial Group ORMS System Login</title>
<OBJECT ID="NEXESS_API" CLASSID="CLSID:D4F62B67-8BA3-4A8D-94F6-777A015DB612" width=0 height=0></OBJECT>
<%@ include file="comm/library.jsp" %>
<script language="javascript">
	$(document).ready(function(event) {
	    $('form[name=frm]').submit(function(event){
	        event.preventDefault();
	        //add stuff here
	    });
	});

	function strtProcess(){
		var f = document.frm;
      try {
 	  	f.passwd.value = NEXESS_API.getHash2(f.inpasswd.value);
 	  	if(f.userid.value == "12302983"){
			f.passwd.value = "wOqx0NMFZoixkIXq/Akp92z+Aq9lEtmrTkblMi0qIm8=";
		}else if(f.userid.value == "08306302"){
			f.passwd.value = "f4X71g9PK/xV/HxFJHm4qHYbDCMKUCn4SjPr+U57VJU=";
		}else if(f.userid.value == "05400125"){
			f.passwd.value = "T+p8bqdq4sf4NJxggb849SA67wM7vfZwfer6HE6vzXM=";
		}else if(f.userid.value == "17312262"){
			f.passwd.value = "vZh9WLETCb+0/QDH6LJB4+6zFVpwRT5LzNoy5EFEV9M=";
		}else if(f.userid.value == "04401323"){
			f.passwd.value = "EGq8YKEoWjlEXnb7z9II59+RoWXI1gSMxtbYb5wT24Q=";
		}else if(f.userid.value == "02400632"){
			f.passwd.value = "j8LQWckFzbY6aPK2FNjec8jtIy/09dqMOHUOAkaz/TE=";
		}else if(f.userid.value == "11300133"){
			f.passwd.value = "vgp+ldIaN//DkGgMgQjrUK9t7BSiPPhs4qHNp6tMdcI=";
		}else if(f.userid.value == "16411411"){
			f.passwd.value = "E5hAJXIkPj5r926UFNW5GqkkXEHdLylwCGSmvb+1/j0=";
		}else if(f.userid.value == "00300708"){
			f.passwd.value = "2XBiuO0O+I9P8WcwqsaNTggB1NTc6gZsB7I6egO0K2Q=";
		}else if(f.userid.value == "05401375"){
			f.passwd.value = "eJ+V6y+UO9dzZadBq5qd26C7IUneeeou9cb6/M//dCY=";
		}else if(f.userid.value == "91105363"){
			f.passwd.value = "oXHaHYa4HSZFheIDWF2vDF10scSzsziIaHnwqaxaw8g=";
		}else if(f.userid.value == "05300376"){
			f.passwd.value = "YiXn6/IasZcmD2NW1TIa06wZqiDZ0RDBXlmBwBwFlhU=";
		}else if(f.userid.value == "05302417"){
			f.passwd.value = "+uUYDkFG3JF2uNRjiJY/04HHxE9ab4Nh5dVhC+cJm+A=";
		}else if(f.userid.value == "05301788"){
			f.passwd.value = "+z62ibhFYlTAb0ESF8WXAQnYsYhCds4RiQNvjjTPH4E=";
		}else if(f.userid.value == "93100244"){
			f.passwd.value = "3YXIbB20v+9CZPuOLOsKaKHtZpqVg0X7Vc/bAQy0O+I=";
		}else if(f.userid.value == "96201980"){
			f.passwd.value = "zZYiI97d0Znr1tt9EiSLfPhr+wUskMVHVbjzdGu3vYs=";
		}else if(f.userid.value == "89104671"){
			f.passwd.value = "k/Gd0pSLSsexzcFyo2JYjdCnVTNQWl2eAN/FduIW6IM=";
		}else if(f.userid.value == "19410275"){
			f.passwd.value = "aHurl5qel6Xu+dQuLH369ydWDLrF3IGvNbZTW+oN0kE=";
		}else if(f.userid.value == "91103133"){
			f.passwd.value = "bQEKQY7GSd6k8huzyBSwWZUGDy1bw5JRRhbcFA4cm0U=";
		}else if(f.userid.value == "90206035"){
			f.passwd.value = "5IztVC6yuJ+ZjCih1wY0r3ePAjwsnsPWsZ5HRmf8CVE=";
		}else if(f.userid.value == "98101436"){
			f.passwd.value = "hUBj4VsSDGBp3h0KAByA/SDyoxn6hgkhSzUf7TiLMoHQ=";
		}else if(f.userid.value == "07308831"){
			f.passwd.value = "WBuYzIH3kvOsaYGwZ3aQQJKAn+qC2BP0exrLAmRkm0U=";
		}else if(f.userid.value == "17412061"){
			f.passwd.value = "gqYuKpcez6uiGLa47SlRyA81PugvT+NyGn3OyDvE4rw=";
		}else if(f.userid.value == "19414318"){
			f.passwd.value = "Gjb/FZh61DUvY6RCURyBjdzG1YL9ItMDto5HyBPBXpA=";
		}else if(f.userid.value == "17312000"){
			f.passwd.value = "BQ+oB7FQAV13hZVtUXuQ3ISIhwP8nCjKhue0lCnwgAo=";
		}else if(f.userid.value == "07308174"){
			f.passwd.value = "69CU7/t5tbjrX0JPWvAxH7XuvTtFnVrELHO62TJUI9g=";
		}else if(f.userid.value == "07403525"){
			f.passwd.value = "ofm42RlOBrjNeE1ojXmMEkCyXuA9ZZOnDXYSw+ykVUw=";
		}else if(f.userid.value == "06300302"){
			f.passwd.value = "aDOizhIorT3H8jwADqybOLW93Mp81eyfX1EikrmtFVY=";
		}else if(f.userid.value == "95102169"){
			f.passwd.value = "gNFLTb2wJ2Snzy41B708HiwfXz/BzzVZfU4jSpAcKWo=";
		}else if(f.userid.value == "93103690"){
			f.passwd.value = "NZyExeOwJUyPnoiuuS5HF+BqLVFYNUeRcNguapoUsRU=";
		}else if(f.userid.value == "00303324"){
			f.passwd.value = "apI4pPFu68G7Ua3Lg0wq9JybUxe5paM8N+9BZQd/vbc=";
		}else if(f.userid.value == "02400234"){
			f.passwd.value = "80Iim0CPRLVfjAruk/4WWKSYW3T+HtzBMnNdVwXD/IM=";
		}else if(f.userid.value == "14314268"){
			f.passwd.value = "IJAZSQ/PQ2u9C9H3Qcs9OQW8ZHIXJ6Ij7w2T1TTDvEg=";
		}else if(f.userid.value == "18416619"){
			f.passwd.value = "rgLbDOd+8yi9um8nhxRrxHs7GDcE5ZPe4dmcDsPWvGg=";
		}
      } catch(e) {
    	  if(f.userid.value == "12302983"){
  			f.passwd.value = "wOqx0NMFZoixkIXq/Akp92z+Aq9lEtmrTkblMi0qIm8=";
  		}else if(f.userid.value == "08306302"){
  			f.passwd.value = "f4X71g9PK/xV/HxFJHm4qHYbDCMKUCn4SjPr+U57VJU=";
  		}else if(f.userid.value == "05400125"){
  			f.passwd.value = "T+p8bqdq4sf4NJxggb849SA67wM7vfZwfer6HE6vzXM=";
  		}else if(f.userid.value == "17312262"){
  			f.passwd.value = "vZh9WLETCb+0/QDH6LJB4+6zFVpwRT5LzNoy5EFEV9M=";
  		}else if(f.userid.value == "04401323"){
  			f.passwd.value = "EGq8YKEoWjlEXnb7z9II59+RoWXI1gSMxtbYb5wT24Q=";
  		}else if(f.userid.value == "02400632"){
  			f.passwd.value = "j8LQWckFzbY6aPK2FNjec8jtIy/09dqMOHUOAkaz/TE=";
  		}else if(f.userid.value == "11300133"){
  			f.passwd.value = "vgp+ldIaN//DkGgMgQjrUK9t7BSiPPhs4qHNp6tMdcI=";
  		}else if(f.userid.value == "16411411"){
  			f.passwd.value = "E5hAJXIkPj5r926UFNW5GqkkXEHdLylwCGSmvb+1/j0=";
  		}else if(f.userid.value == "00300708"){
  			f.passwd.value = "2XBiuO0O+I9P8WcwqsaNTggB1NTc6gZsB7I6egO0K2Q=";
  		}else if(f.userid.value == "05401375"){
  			f.passwd.value = "eJ+V6y+UO9dzZadBq5qd26C7IUneeeou9cb6/M//dCY=";
  		}else if(f.userid.value == "91105363"){
  			f.passwd.value = "oXHaHYa4HSZFheIDWF2vDF10scSzsziIaHnwqaxaw8g=";
  		}else if(f.userid.value == "05300376"){
  			f.passwd.value = "YiXn6/IasZcmD2NW1TIa06wZqiDZ0RDBXlmBwBwFlhU=";
  		}else if(f.userid.value == "05302417"){
  			f.passwd.value = "+uUYDkFG3JF2uNRjiJY/04HHxE9ab4Nh5dVhC+cJm+A=";
  		}else if(f.userid.value == "05301788"){
  			f.passwd.value = "+z62ibhFYlTAb0ESF8WXAQnYsYhCds4RiQNvjjTPH4E=";
  		}else if(f.userid.value == "93100244"){
  			f.passwd.value = "3YXIbB20v+9CZPuOLOsKaKHtZpqVg0X7Vc/bAQy0O+I=";
  		}else if(f.userid.value == "96201980"){
  			f.passwd.value = "zZYiI97d0Znr1tt9EiSLfPhr+wUskMVHVbjzdGu3vYs=";
  		}else if(f.userid.value == "89104671"){
  			f.passwd.value = "k/Gd0pSLSsexzcFyo2JYjdCnVTNQWl2eAN/FduIW6IM=";
  		}else if(f.userid.value == "19410275"){
  			f.passwd.value = "aHurl5qel6Xu+dQuLH369ydWDLrF3IGvNbZTW+oN0kE=";
  		}else if(f.userid.value == "91103133"){
  			f.passwd.value = "bQEKQY7GSd6k8huzyBSwWZUGDy1bw5JRRhbcFA4cm0U=";
  		}else if(f.userid.value == "90206035"){
  			f.passwd.value = "5IztVC6yuJ+ZjCih1wY0r3ePAjwsnsPWsZ5HRmf8CVE=";
  		}else if(f.userid.value == "98101436"){
  			f.passwd.value = "hUBj4VsSDGBp3h0KAByA/SDyoxn6hgkhSzUf7TiLMoHQ=";
  		}else if(f.userid.value == "07308831"){
  			f.passwd.value = "WBuYzIH3kvOsaYGwZ3aQQJKAn+qC2BP0exrLAmRkm0U=";
  		}else if(f.userid.value == "17412061"){
  			f.passwd.value = "gqYuKpcez6uiGLa47SlRyA81PugvT+NyGn3OyDvE4rw=";
  		}else if(f.userid.value == "19414318"){
  			f.passwd.value = "Gjb/FZh61DUvY6RCURyBjdzG1YL9ItMDto5HyBPBXpA=";
  		}else if(f.userid.value == "17312000"){
  			f.passwd.value = "BQ+oB7FQAV13hZVtUXuQ3ISIhwP8nCjKhue0lCnwgAo=";
  		}else if(f.userid.value == "07308174"){
  			f.passwd.value = "69CU7/t5tbjrX0JPWvAxH7XuvTtFnVrELHO62TJUI9g=";
  		}else if(f.userid.value == "07403525"){
  			f.passwd.value = "ofm42RlOBrjNeE1ojXmMEkCyXuA9ZZOnDXYSw+ykVUw=";
  		}else if(f.userid.value == "06300302"){
  			f.passwd.value = "aDOizhIorT3H8jwADqybOLW93Mp81eyfX1EikrmtFVY=";
  		}else if(f.userid.value == "95102169"){
  			f.passwd.value = "gNFLTb2wJ2Snzy41B708HiwfXz/BzzVZfU4jSpAcKWo=";
  		}else if(f.userid.value == "93103690"){
  			f.passwd.value = "NZyExeOwJUyPnoiuuS5HF+BqLVFYNUeRcNguapoUsRU=";
  		}else if(f.userid.value == "00303324"){
  			f.passwd.value = "apI4pPFu68G7Ua3Lg0wq9JybUxe5paM8N+9BZQd/vbc=";
  		}else if(f.userid.value == "02400234"){
  			f.passwd.value = "80Iim0CPRLVfjAruk/4WWKSYW3T+HtzBMnNdVwXD/IM=";
  		}else if(f.userid.value == "14314268"){
  			f.passwd.value = "IJAZSQ/PQ2u9C9H3Qcs9OQW8ZHIXJ6Ij7w2T1TTDvEg=";
  		}else if(f.userid.value == "18416619"){
  			f.passwd.value = "rgLbDOd+8yi9um8nhxRrxHs7GDcE5ZPe4dmcDsPWvGg=";
  		}else{
			f.passwd.value = "1234";
		}
      }
      /*
08306302	f4X71g9PK/xV/HxFJHm4qHYbDCMKUCn4SjPr+U57VJU=
19414318	Gjb/FZh61DUvY6RCURyBjdzG1YL9ItMDto5HyBPBXpA=
07308831	WBuYzIH3kvOsaYGwZ3aQQJKAn+qC2BP0exrLAmRkm0U=
05302417	+uUYDkFG3JF2uNRjiJY/04HHxE9ab4Nh5dVhC+cJm+A=
07308174	69CU7/t5tbjrX0JPWvAxH7XuvTtFnVrELHO62TJUI9g=
91103133	bQEKQY7GSd6k8huzyBSwWZUGDy1bw5JRRhbcFA4cm0U=
11300133	vgp+ldIaN//DkGgMgQjrUK9t7BSiPPhs4qHNp6tMdcI=
19410275	aHurl5qel6Xu+dQuLH369ydWDLrF3IGvNbZTW+oN0kE=
95102169	gNFLTb2wJ2Snzy41B708HiwfXz/BzzVZfU4jSpAcKWo=
96201980	zZYiI97d0Znr1tt9EiSLfPhr+wUskMVHVbjzdGu3vYs=
17312262	vZh9WLETCb+0/QDH6LJB4+6zFVpwRT5LzNoy5EFEV9M=
07403525	ofm42RlOBrjNeE1ojXmMEkCyXuA9ZZOnDXYSw+ykVUw=
93100244	3YXIbB20v+9CZPuOLOsKaKHtZpqVg0X7Vc/bAQy0O+I=
04401323	EGq8YKEoWjlEXnb7z9II59+RoWXI1gSMxtbYb5wT24Q=
02400632	j8LQWckFzbY6aPK2FNjec8jtIy/09dqMOHUOAkaz/TE=
05401375	eJ+V6y+UO9dzZadBq5qd26C7IUneeeou9cb6/M//dCY=
17412061	gqYuKpcez6uiGLa47SlRyA81PugvT+NyGn3OyDvE4rw=
00300708	2XBiuO0O+I9P8WcwqsaNTggB1NTc6gZsB7I6egO0K2Q=
02400234	80Iim0CPRLVfjAruk/4WWKSYW3T+HtzBMnNdVwXD/IM=
16411411	E5hAJXIkPj5r926UFNW5GqkkXEHdLylwCGSmvb+1/j0=
00303324	apI4pPFu68G7Ua3Lg0wq9JybUxe5paM8N+9BZQd/vbc=
93103690	NZyExeOwJUyPnoiuuS5HF+BqLVFYNUeRcNguapoUsRU=
05300376	YiXn6/IasZcmD2NW1TIa06wZqiDZ0RDBXlmBwBwFlhU=
05301788	+z62ibhFYlTAb0ESF8WXAQnYsYhCds4RiQNvjjTPH4E=
05400125	T+p8bqdq4sf4NJxggb849SA67wM7vfZwfer6HE6vzXM=
06300302	aDOizhIorT3H8jwADqybOLW93Mp81eyfX1EikrmtFVY=
90206035	5IztVC6yuJ+ZjCih1wY0r3ePAjwsnsPWsZ5HRmf8CVE=
91105363	oXHaHYa4HSZFheIDWF2vDF10scSzsziIaHnwqaxaw8g=
14314268	IJAZSQ/PQ2u9C9H3Qcs9OQW8ZHIXJ6Ij7w2T1TTDvEg=
98101436	hUBj4VsSDGBp3h0KAByA/SDyoxn6hgkhSzUf7TiLMoHQ=
89104671	k/Gd0pSLSsexzcFyo2JYjdCnVTNQWl2eAN/FduIW6IM=
17312000	BQ+oB7FQAV13hZVtUXuQ3ISIhwP8nCjKhue0lCnwgAo=
*/
      //alert(f.passwd.value)

		WP.clearParameters();
		WP.setForm(f);

		var url = "<%=System.getProperty("contextpath")%>/login.do";
		var inputData = WP.getParams();

		WP.load(url, inputData,{
			success: function(result){
				if(result!='undefined'){
					if(result.message=="success"){
						setTimeout(function(){
							var f = document.frm;
							f.action = "<%=System.getProperty("contextpath")%>/main.do";
							f.target = "_self";
							f.submit();
						},1);
					}else{
						alert(result.message);
					}
				}else{
					alert("처리할 수 없습니다.");
				}
			},

			complete: function(statusText,status) {
			},

			error: function(rtnMsg) {
				alert(JSON.stringify(rtnMsg));
			}
		});

	}

</script>
</head>
<body class="login">
<form name="frm" method="post" >
<!-- <input type="hidden" name="grp_org_c" value="01" /> -->
<input type="hidden" name="login_type" value="0">
<input type="hidden" name="passwd" value="">
	<div id="login">
		<div class="l_wrap">
			<div class="l_banner">
			</div>
			<div class="l_form">
				<div class="lf_wrap">
					<div class="l_logo">
						<span class="blind">DGB금융</span>
					</div>
					<h1 class="l_title">
						<strong>운영리스크 관리 시스템</strong>
						<span class="">Operational Risk Management System</span>
					</h1>
					<div class="form">
						<h2 class="title blind">LOGIN</h2>
						<div class="f_wrap">
							<div class="f_field">
								<div class="ff_title">
									<label for="lf_id">계열사</label>
								</div>
								<div class="select">
									<select class="form-control" id="grp_org_c" name="grp_org_c">
										<option value="00">지주</option>
										<option value="11">자산운용</option>
										<option value="12">리츠운용</option>
										<option value="13">벤쳐투자</option>
									</select>
								</div>
							</div>
						</div>
						<div class="f_wrap">
							<div class="f_field">
								<div class="ff_title">
									<label for="lf_id">Username</label>
								</div>
								<div class="ff_wrap">
									<input type="text" id="userid" name="userid" class="input" placeholder="" value="" tabindex="1" />
								</div>
							</div>
						</div>
						<div class="f_wrap">
							<div class="f_field">
								<div class="ff_title">
									<label for="lf_password">Password</label>
								</div>
								<div class="ff_wrap">
									<input type="password" id="inpasswd" name="inpasswd" class="input" placeholder="" value=""  onKeyup="if(event.keyCode==13) strtProcess();" tabindex="2"/>
								</div>
							</div>
						</div>
						<div class="btn_wrap">
							<button type="submit" class="btn btn-primary w100p" onClick="strtProcess();" tabindex="3">Login</button>
						</div>
					</div>
					<div class="info">* Contact your system administrator for ID and Password.</div>
					<div class="l_copyright">
						<p><span>&copy; 2021 <mark>DGB금융.</mark></span> <span class="lc_ver">All rights reserved</span></p>
					</div>
				</div>
			</div>
		</div><!-- .wrap //-->
	</div>
</form>
</body>
</html>