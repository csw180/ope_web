window.WP = window.WP || (function(myApp,$,undefined)
{
	myApp.parameternames=new Array();
	myApp.parametervalues=new Array();
	
	myApp.setParameter=function(name,value){
		//alert(this.parameternames.length+ "="+name+ " : "+value);
		this.parameternames[this.parameternames.length]=name;
		this.parametervalues[this.parametervalues.length]=value;
	};
	
	myApp.setForm=function(f){
		var fe = f.elements;
		for(var i=0; i<fe.length; i++){
			//alert(fe[i].type+","+fe[i].name+","+fe[i].value);
			if( fe[i].type == "radio"){
				if(fe[i].checked){
					this.setParameter(fe[i].name,  fe[i].value);
				}
			//} else if( fe[i].type == "file"){
				//this.setParameter(fe[i].name,  fe[i].files[0]);
				//this.setParameter(fe[i].name+"_fileNm",  fe[i].value);
			} else{
				this.setParameter(fe[i].name,  fe[i].value);
			}
		}
	};
	
	myApp.clearParameters=function(){
		this.parameternames=new Array();
		this.parametervalues=new Array();
	};
	
	myApp.getParams=function(){
		var i,j,name,value,data="",params=this.parameternames;
		for(i=0;i<params.length;i++){
			name=params[i];
			value=this.parametervalues[i];
			
			if(typeof value=="function"){
				value=value();
			}
			//if(typeof value=="object" && value.constructor==Array){
			if(typeof value=="object"){
				if(value==null) value="";
				for(j=0;j<value.length;j++){
					data+=encodeURIComponent(name)+"="+encodeURIComponent(value[j])+"&";
					//data+=name+"="+value[j]+"&";
				}
			}else{
				data+=encodeURIComponent(name)+"="+encodeURIComponent(value)+"&";
				//data+=name+"="+value+"&";
			}
		}
		return data;
		
	};
	
	myApp.getMutipartData=function() {
		 var formData = new FormData();  
	 var i,j,name,value,params=this.parameternames;
		for(i=0;i<params.length;i++){
			name=params[i];
			value=this.parametervalues[i];
			
			if(typeof value=="function"){
				value=value();
			}
			//if(typeof value=="object" && value.constructor==Array){
			if(typeof value=="object"){
				for(j=0;j<value.length;j++){
					formData.append(name, value[j]);
				}
			}else{
				formData.append(name, value);
			}
		}
		return formData;
	}
	
	// ajax 호출. setting은 before,complete,error,success callback 필요시 등록.
	myApp.formdataload = function(url,data,setting,timeoutInterval)
	{
		//if(timeoutInterval) timeoutInterval = 1000;
		$.ajax(url,{
			data : data,
			type : "POST",
			mimeType : "multipart/form-data",
			contentType : false,
			cache : false,
			processData : false,
			timeout : timeoutInterval,
			
			success:function(data,textStatus,jqXHR ){
				if(setting.success) setting.success(JSON.parse(data));
			},
			complete:function(jqXHR,textStatus){
				if(setting.complete) setting.complete(jqXHR.statusText, jqXHR.status);
			}
		});
	};
	// ajax 호출. setting은 before,complete,error,success callback 필요시 등록.
	myApp.load = function(url,data,setting,timeoutInterval)
	{
		//if(timeoutInterval) timeoutInterval = 1000;
		$.ajax(url,{
			data : data,
			type : "POST",
			timeout : timeoutInterval,
			
			success:function(data,textStatus,jqXHR ){
				if(setting.success) setting.success(data);
			},
			complete:function(jqXHR,textStatus){
				if(setting.complete) setting.complete(jqXHR.statusText, jqXHR.status);
			}
		});
	};
	// ajax 비동기 호출. setting은 before,complete,error,success callback 필요시 등록.
	myApp.sync_load = function(url,data,setting,timeoutInterval)
	{
		//if(timeoutInterval) timeoutInterval = 60000;
		$.ajax(url,{
			data : data,
			type : "POST",
			async : false,
			timeout : timeoutInterval,
			beforeSend:function() {
				if(setting.before) setting.before();
			},
			complete:function(jqXHR,textStatus){
				if(setting.complete) setting.complete(jqXHR.statusText, jqXHR.status);
			},
			error : function(jqXHR,textStatus,errorThrown){
				if(setting.fail) setting.fail(textStatus);
			},
			success:function(data,textStatus,jqXHR ){
				if(setting.success) setting.success(data);
			}
		});
	};
	//
	
	//이차원 배열에 대한 jQuery.trim()
	myApp.arrayTrim = function(_arrayData) {
		for(var i=0 ; i < _arrayData.length ; i++ ) {
			for(var j=0 ; j < _arrayData[i].length ; j++ ) {
				_arrayData[i][j] = $.trim(_arrayData[i][j]);
			}
		}
		return myApp;
	};
	
	
	//엑셀로 아이디 내의 테이블을 저장
	//TargetID 읽어올 태그의 아이디
	//SaveFileName .xls를 제외한 이름
	myApp.saveExcel = function (TargetID,SaveFileName){ 	
		//if(document.all) { 
		  if(!document.all.excelExportFrame) { 
			  var excelFrame=document.createElement("iframe"); 
			  excelFrame.id="excelExportFrame"; 
			  excelFrame.position="absolute"; 
			  excelFrame.style.zIndex=-1; 
			  excelFrame.style.top="-10px"; 
			  excelFrame.style.left="-10px"; 
			  excelFrame.style.height="0px"; 
			  excelFrame.style.width="0px"; 
			  document.body.appendChild(excelFrame); 
		  } 
		  $("#excelExportFrame").attr("name","excelExportFrame");
		  var frmTarget = document.all.excelExportFrame.contentWindow.document;		  
		  if(!SaveFileName) { 
			  SaveFileName='test.xls'; 
		  } else{
			  SaveFileName += '.xls';
		  }		  
		  frmTarget.charset="euc-kr";
		  frmTarget.open("application/vnd.ms-excel","replace"); 
		  frmTarget.write('<html>'); 
		  frmTarget.write('<meta http-equiv=\"Content-Type\" content=\"application/vnd.ms-excel; charset=euc-kr\">\r\n'); 
		  frmTarget.write('<body>');		  
		  frmTarget.write(document.getElementById(TargetID).outerHTML);
		  //frmTarget.write($(TargetID).find("img").remove().html());
		  frmTarget.write('<script>');
		  frmTarget.write("document.execCommand('SaveAs','false','"+SaveFileName+"')");
		  frmTarget.write('</script>');
		  
		  frmTarget.write('</body>'); 
		  frmTarget.write('</html>'); 
		  frmTarget.close(); 
 
		/*} else { 
			alert('인터넷 익스플로어에서만 사용가능합니다.'); 
		} */
	} ;
	
	return myApp;
	
})(window.WP = window.WP || {},jQuery);