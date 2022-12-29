/* 내부 팝업 */
function modalOpen(id){
	document.getElementById(id).classList.add('block');
}
function modalClose(id){
	document.getElementById(id).classList.remove('block');
}


/* 검색 - 상세검색 */
function viewSrchMore(){
	$('.search-more').toggleClass('on');
	$('.btn-search-more').toggleClass('on');
}


/* 멀티 셀렉트박스 */
function initMultiSel(){
	if( $(".dropdown.dMSC").length > 0 ){
		$(".dropdown.dMSC").each(function(index, item){
			item = $(item);
			chkMultiSel(item);
			chkMultiAll(item);
		});
		chgMultiInput();
	}
}
function chgMultiInput(){	// 체크박스 클락하면
	$('.mutliSelect input[type="checkbox"]').change(function(){
		var item = $(this).parents('.dropdown.dMSC');

		// 전체선택 checkbox 
		if( $(this).is('[data-name]') ){	// 전체 checkbox 클릭 시
			var name = $(this).attr('data-name');
			if( $(this).is(':checked') ) {
				$('input[name=' + name + ']').prop('checked', true);
			}else{
				$('input[name=' + name + ']').prop('checked', false);
			}
		}else{
			var name = $(this).attr('name');
			if( $('input[data-name=' + name + ']').length > 0 ){
				var len = $('input[name=' + name + ']').length;
				var cnt = $('input[name=' + name + ']:checked').length;
				var all = $('input[data-name=' + name + ']');
				if( len === cnt ){
					all.prop('checked', true);
				}else{
					all.prop('checked', false);
				}
			}
		}
		
		chkMultiSel(item);
	});	
}

// 전체선택 checkbox 체크or해제
function chkMultiAll(el){
	var all = el.find('input[data-name]');
	if(all.length > 0){
		var name = all.attr('data-name');
		var len = $('input[name=' + name + ']').length;
		var cnt = $('input[name=' + name + ']:checked').length;
		all.parents('li').css('display', 'block');
		if( len === cnt ){
			all.prop('checked', true);
		}else{
			all.prop('checked', false);
		}
	}
}

function chkMultiSel(el){
	var btn = el.find('a');
	var inputs = el.find('input:not([data-name])');
	var hida = el.find('.hida');
	var multiSel = el.find('.multiSel');
	var multiText = '';

	for( i=0; i<inputs.length; i++ ){
		var val = inputs.eq(i).next('label').text();
		var checked = inputs.eq(i).is(':checked');
		if( checked === true ){
			multiText += '<span title="' + val + '">' + val + '</span>';
		}
	}

	if( multiText.length > 0){
		hida.hide();
		multiSel.html(multiText);
	}else{
		hida.show();
		multiSel.html('');
	}
}

/* form - Number */
// input에 입력한 숫자에 콤마 넣기
// onfucus="focusNumber();" onblur="blurNumber();"
function blurNumber(maxlength){
	var obj = window.event.currentTarget;
	var value = obj.value;
	var max = maxlength;
	if(value == ""){	// 비어있을 경우 return
		return;
	}
	value = value.replace(/,/gi,"");
	if(max > 0){
		value = chkDigit(value, max);
	}
	var numberValue = Number(value.replace(/[^0-9]/g, ""));	// 숫자만 남기기
	if(isNaN(numberValue)) {	// 숫자가 아니면
		numberValue = parseFloat(0);	
	}
	var formatValue = numberValue.toLocaleString('ko-kr');
	obj.value = formatValue;
}
// focus 시 , 삭제
function focusNumber(){
	var obj = window.event.currentTarget;
	obj.value = replaceAll(obj.value, ",", "");
}


/* btn-file */
function btnFileCss(){
	$('.btn-file').each(function(index){
		var str = $('.btn-file').eq(index).attr("title");
		var pos = str.lastIndexOf('.');
		var file = str.slice(pos + 1);
		var className = "";
		switch(file){
			case "xls" :
			case "xlsx" :
				className = "xls";
				break;
			case "doc" :
			case "docx" :
				className = "doc";
				break;
			case "hwp" :
				className = "hwp";
				break;
			case "ppt" :
			case "pptx" :
				className = "ppt";
				break;
			case "txt" :
				className = "txt";
				break;
			case "jpg" :
			case "gif" :
			case "png" :
			case "jpeg" :
				className = "jpg";
				break;
			case "zip" :
				className = "zip";
				break;
			case "dll" :
				className = "dll";
				break;
			case "exe" :
				className = "exe";
				break;
			default :
				className = "file";
				break;
		}
		$('.btn-file').eq(index).find('.ico').addClass(className);
	});
}


/* 대시보드 */

// KRI 조회 - 탭버튼
function tabKriGrade(){
	$('.dash-tab .btn-tab').on('click', function(){
		$(this).parents('.dash-tab').find('.btn-tab').removeClass('active');
		$(this).addClass('active');
	});
}


// KRI 조회 - 전년 대비 차트 - 포인트 클릭 이벤트
function viewKriGrade(obj, Index, X){
	var target = document.getElementById(obj);
	var year = target.querySelectorAll('.kri-month');
	var month = year[Index].querySelectorAll('dd');
	
	for(var i=0; i<24; i++){
		target.querySelectorAll('dd')[i].classList.remove('on');
	}
	for(var j=0; j<year.length; j++){
		year[j].querySelector('dt').classList.remove('on');
	}		
	
	year[Index].querySelector('dt').classList.add('on');
	month[X].classList.add('on');
}


//KRI 조회 - 전행 발생 현황 차트 - 마우스오버 컬러
function kriAllChartColor(color){
	var root = document.documentElement;
	root.style.setProperty('--chart-all-color', color);
}


$(function(){

		
	/* 멀티 셀렉트박스 */
	$(".dropdown.dMSC dt a").on('click', function() {
		$(this).parents('.dMSC').find('dd ul').stop().slideToggle(200);
	});
	
	if( $(".dropdown.dMSC").length > 0 ){
		initMultiSel();
	}

	$('html').click(function(e){
		var $clicked = $(e.target);
		if (!$clicked.parents().hasClass("dropdown")){
			$(".dropdown dd ul").hide();
		}
	});



	/* 툴팁 */
	$('button[tip]').on('mouseover', function(){
		// var x = e.pageX;
		// var y = e.pageY - $(document).scrollTop();
		var x = $(this).offset().left;
		var y =$(this).offset().top - $(document).scrollTop() + 15;
		var id = $(this).attr('tip');
		$('#'+ id).show().css({'top': y, 'left': x});
	}).on('mouseout', function(){
		var id = $(this).attr('tip');
		$('#'+ id).hide();
	});





	/* 파일업로드 */
	$('.filebox input[type="file"]').on('change', function(){
		var filename = $(this)[0].files[0].name;
		$(this).siblings('input[type="text"]').val(filename);
	});
	

	
	/* btn-file */
	btnFileCss();
	
	
	/* 대시보드 : KRI 조회 탭버튼 */
	tabKriGrade();
	
})
