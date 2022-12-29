function truncByte(val,max){
	var str = new String(val);
	for(var i=max/2;i<str.length;i++){
		if(getByteLength(str.substring(0,i+1))>max){
			return(str.substring(0,i));
		}
	}
	return str;
}

function EnterkeyPass(){
	var src = window.event.srcElement;
	if(event.keyCode == 13 ){
		event.returnValue = false;
		return true;
	}else{
		return true;
	}
}

function keyPass(){
	var src = window.event.srcElement;
	if((event.keyCode == 8) && !((src.tagName == "INPUT")||(src.tagName == "TEXTAREA")) ){
		event.returnValue = false;
		return true;
	}else{
		return true;
	}
}

/**
 * Function Name : isAsc()
 * Description   : ascii\uc720\ubb34 \uccb4\ud06c
 * @Parameter	 : String
 * @Return		 : Boolean
 * \uc0ac\uc6a9 Function : None
 */
function isAsc(str){
	if(str == null) return true;

	for(i=0;i<str.length;i++){
		var c = escape(str.charAt(i));
		if( c.indexOf("%u") != -1 ){
			return false;
		}
	}
	return true;
}

/**
 * Function Name : setComma()
 * Description   : 3\uc790\ub9ac \ub9c8\ub2e4 ','\ub97c \uc0bd\uc785\ud55c\ub2e4.
 * @Parameter	  : field - text input type
 *                 \uc608) "12345.12" -> "123,45.12"
 * @Return		  : String
 * \uc0ac\uc6a9 Function : initValue()
 */
function setComma( num ){
	var num2 = new String(num);
	num2 = trim(num2);
	//num = field.value;
	var len = 0;
	var vPoint = 0;
	var bFlag = false;

	// \uacc4\uc0b0\ud560 \uac12\uc774 \uc5c6\uc73c\uba74 return
	if( num2 == "" ) return "";

	// \ucd08\uae30\uce58\uac00 '-'\uba74 '-'\ub97c \ube80\ub2e4.
	if(initValue(num2) == "-"){
		num2 = num2.substring(1);
		bFlag = true;
	}
	// \uc18c\uc22b\uc810\uc758 \uc704\uce58\ub97c \ucc3e\ub294\ub2e4.
	//vPoint = num2.indexOf(".");
	// \uc18c\uc22b\uc810\uc758 \uc704\uc9c0\ub97c \ubabb\ucc3e\uc73c\uba74 \uacc4\uc0b0 \uae38\uc774\ub294 \uac12\uc758 \uae38\uc774\uac00 \ub418\uace0
	if( num2.indexOf(".") == -1 )  len=num2.length;
	// \uc18c\uc22b\uc810\uc758 \uc704\uce58\ub97c \ucc3e\uc73c\uba74 \uacc4\uc0b0 \uae38\uc774\ub294 \uc18c\uc218\uc810 \uc55e\uc790\ub9ac \uae4c\uc9c0\uac00 \ub41c\ub2e4.
	else len=num2.indexOf(".");
	// \uac12\uc5d0\uc11c \uacc4\uc0b0\ud560 \ubd80\ubd84\ub9cc \uc798\ub798\ub0b4\uace0
	newnum = num2.substring(0,len);
	// \ub4a4\uc5d0\uc11c\ubd80\ud130 3\uc790\ub9ac\uc529 \uc798\ub77c\uc11c \uc800\uc7a5\ud560 \ubc30\uc5f4\uc744 \ub9cc\ub4e0\ub2e4.
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

	// , \ub97c \uc0bd\uc785\ud55c \ubb38\uc790\uc5f4\uc744 return
	if(bFlag)	newnum = "-" + newnum;
	return newnum;
}

/**
 * Function Name : getByteLength()
 * Description   : \ubb38\uc790\uc758 \ubc14\uc774\ud2b8 \uae38\uc774\ub97c \uad6c\ud558\ub294 function
 * @Parameter	 : String
 * @Return		 : String
 * \uc0ac\uc6a9 Function : None
 */
function getByteLength(Str){// only for SHIFT_JIS
	var retValue = 0;
	if( Str == null ) return 0;
	for(var i=0;i<Str.length;i++){
		var c = escape(Str.charAt(i));
		if( navigator.appName == "Microsoft Internet Explorer" ){
		// IE
			if( c.length == 1 ){
				retValue ++;
			}else{
				if( c.indexOf("%u") != -1 ){
					if( c >= "%uFF61" && c <= "%uFF9F"){
						retValue ++;
					}else{
						retValue += 2;
					}
				}else{
					retValue ++;
				}
			}
		// Netscape
		}else{
			if(c.charAt(0) != "%")
				retValue ++;
			else
				if(c.charAt(1) == "8")
				retValue += 2;
				else if(c.charAt(1) == "9")
				retValue += 2;
				else if(c.charAt(1) == "E")
				retValue += 2;
				else if(c.charAt(1) == "F")
				retValue += 2;
				else
				retValue ++;
		}
	}
	return retValue;
}

function isNumeric(Str){
	var retValue = true;
	var count;
	var permitChar = "0123456789";

	for(var i = 0; i < Str.length; i++){
		count = 0;
		for(var j = 0; j < permitChar.length; j++){
			if(Str.charAt(i) == permitChar.charAt(j)){
				count++;
				break;
			}
		}

		if(count == 0){
			retValue = false;
			break;
		}
	}
	return retValue;
}

function isNumericMinus(Str){
	var retValue = true;
	var count;
	var permitChar = "-.0123456789";

	for(var i = 0; i < Str.length; i++){
		count = 0;
		for(var j = 0; j < permitChar.length; j++){
			if(Str.charAt(i) == permitChar.charAt(j)){
				count++;
				break;
			}
		}

		if(count == 0){
			retValue = false;
			break;
		}
	}
	return retValue;
}

/**
 * Function Name : trim()
 * Description   : \ubaa8\ub4e0 \uacf5\ubc31\uc81c\uac70 function
 * @Parameter	 : String
 * 					ex) " 111  11 "    => "11111"
 * @Return		 : String
 * \uc0ac\uc6a9 Function : None
 */
function trim(a){
	for(; a.indexOf(" ") != -1 ;){
		a = a.replace(" ","")
	}
	return a;
}

/**
 * Function Name : leftTrim()
 * Description   : \uc67c\ucabd \uacf5\ubc31\uc81c\uac70 function
 * @Parameter	 : String
 * @Return		 : String
 * \uc0ac\uc6a9 Function : None
 */
function leftTrim(a){
	for(; a.charAt(0) ==" " ;){
		a = a.replace(" ","")
	}
	return a ;
}

/**
 * Function Name : rightTrim()
 * Description   : \uc624\ub978\ucabd \uacf5\ubc31\uc81c\uac70 function
 * @Parameter	 : String
 * @Return		 : String
 * \uc0ac\uc6a9 Function : None
 */
function rightTrim(chartext){
	var search = chartext.length - 1
	while (chartext.charAt(search) ==" "){
		search = search - 1
	}
	return chartext.substring(0, search + 1)
}

/**
 * Function Name : isEmpty()
 * Description   : \uacf5\ubc31 \uccb4\ud06c
 * @Parameter	 : String
 * @Return		 : Boolean
 * \uc0ac\uc6a9 Function : None
 */
function isEmpty(str){
	var s = trim(str);

	return ((s == null) || (s.length == 0))? true : false;
}

/**
 * Function Name : isAlphanumeric()
 * Description   : \uc601\uc22b\uc790 \uccb4\ud06c
 * @Parameter	 : String
 * @Return		 : Boolean
 * \uc0ac\uc6a9 Function : isAlphabeticChar(), isDigit()
 */
function isAlphanumeric (s)
{
	if(isEmpty(s)){
		return false;
	}

	for(var i = 0; i < s.length; i++){
		var c = s.charAt(i);

		if(! (isAlphabeticChar(c) || isDigit(c) ) ){
			return false;
		}
	}
	return true;
}

/**
 * Function Name : isAlphabetic()
 * Description   : \uc601\ubb38 \uccb4\ud06c
 * @Parameter	 : String
 * @Return		 : Boolean
 * \uc0ac\uc6a9 Function : isAlphabeticChar()
 */
function isAlphabetic (s){

	if(isEmpty(s)){
		return false;
	}

	for(var i = 0; i < s.length; i++){
		var c = s.charAt(i);

		if(!isAlphabeticChar(c)){
			return false;
		}
	}

	return true;
}

/**
 * Function Name : isAlphabeticChar()
 * Description   : \uc601\ubb38 \uccb4\ud06c
 * @Parameter	 : Character
 * @Return		 : Boolean
 */
function isAlphabeticChar (c){
	return ( ((c >= "a") && (c <= "z")) || ((c >= "A") && (c <= "Z")) );
}

/**
 * Function Name : isDigit()
 * Description   : \uc22b\uc790 \uccb4\ud06c
 * @Parameter	 : Character
 * @Return		 : Boolean
 */
function isDigit (c){
	return ((c >= "0") && (c <= "9"));
}

/**
 * Function Name : replace()
 * Description   : \uac12\uc744 \uc81c\uac70\ud558\uac70\ub098,\ubcc0\uacbd\ud558\uace0\uc790 \ud560\ub54c \uc0ac\uc6a9\ud558\ub294 function
 * @Parameter	 : String(String value), String(\uc81c\uac70\ub97c \ud558\uace0\uc790\ud558\ub294\uac12), String(\ubcc0\uacbd\ud558\uace0\uc790\ud558\ub294 \uac12)
 * 				   \uc608)replace("1234-56-78", "-", ",") -> "1234,56,78"
 * @Return		 : String
 */
function replace(value, oldvalue , newvalue ){
	var result="";
	var i=0;

	do{
		i = value.indexOf(oldvalue);

		if(i != -1 ){
			result += value.substring(0,i);
			result += newvalue ;

			value = value.substring(i+oldvalue.length);
		}else{

			result += value	;

			break;
		}

	} while(i != -1);

	return result ;
}

/**
 * Function Name : MakeClear()
 * Description   : \uc9c0\uc815\ub41c \ubb38\uc790\uc5f4 \uc81c\uac70\ud558\ub294 function
 * @Parameter	 : String(String value), String(\uc81c\uac70\ud558\uace0\uc790\ud558\ub294 value)
 * 				   \uc608)MakeClear("1234-56-78", "-") -> "12345678"
 * @Return		 : String
 */
function MakeClear(value , clear ){
	var temp ="";
	var str  ="";
	str = value.split(clear);

	for(var i = 0 ; i < str.length ; i++ ){
		temp += str[i];
	}
	return temp;
}

/**
 * Function Name : setComma()
 * Description   : 3\uc790\ub9ac \ub9c8\ub2e4 ','\ub97c \uc0bd\uc785\ud55c\ub2e4.
 * @Parameter	  : field - text input type
 *                 \uc608) "12345.12" -> "123,45.12"
 * @Return		  : String
 * \uc0ac\uc6a9 Function : initValue()
 */
/*	function setComma( num ){
	var num2 = new String(num);
	num2 = trim(num2);
	//num = field.value;
	var len = 0;
	var bFlag = false;

	// \uacc4\uc0b0\ud560 \uac12\uc774 \uc5c6\uc73c\uba74 return
	if( num2 == "" ) return "";

	// \ucd08\uae30\uce58\uac00 '-'\uba74 '-'\ub97c \ube80\ub2e4.
	if(initValue(num2) == "-"){
		num2 = num2.substring(1);
		bFlag = true;
	}
	// \uc18c\uc22b\uc810\uc758 \uc704\uce58\ub97c \ucc3e\ub294\ub2e4.
	var point = num2.indexOf(".");
	// \uc18c\uc22b\uc810\uc758 \uc704\uc9c0\ub97c \ubabb\ucc3e\uc73c\uba74 \uacc4\uc0b0 \uae38\uc774\ub294 \uac12\uc758 \uae38\uc774\uac00 \ub418\uace0
	if( point == -1 ) len = num2.length
	// \uc18c\uc22b\uc810\uc758 \uc704\uce58\ub97c \ucc3e\uc73c\uba74 \uacc4\uc0b0 \uae38\uc774\ub294 \uc18c\uc218\uc810 \uc55e\uc790\ub9ac \uae4c\uc9c0\uac00 \ub41c\ub2e4.
	else len = point;
	// \uac12\uc5d0\uc11c \uacc4\uc0b0\ud560 \ubd80\ubd84\ub9cc \uc798\ub798\ub0b4\uace0
	newnum = num2.substring(0,len);
	// \ub4a4\uc5d0\uc11c\ubd80\ud130 3\uc790\ub9ac\uc529 \uc798\ub77c\uc11c \uc800\uc7a5\ud560 \ubc30\uc5f4\uc744 \ub9cc\ub4e0\ub2e4.
	numarray = new Array( len % 3 + 1 );
	index = 0;

	// \ub4a4\uc5d0\uc11c\ubd80\ud130 3\uc790\ub9ac\uc529 \uc798\ub77c\uc11c \ubc30\uc5f4\uc5d0 \uc800\uc7a5\ud558\uace0
	for( i = len ; i > 0 ; i -= 3 ){
		numarray[index] = newnum.substring(i - 3, i );
		index++;
	}
	newnum = "";

	// \ubc30\uc5f4\uc758 \ub4b7\ubd80\ubd84\ubd80\ud130 , \uc640 \ud568\uaed8 \ubd99\uc5ec \ub098\uac04\ub2e4.
	for( i = index-1; i >= 0 ;i-- ){
		if( i < (index-1) ) newnum += ","; // \ub9e8 \uc55e\uc5d0 , \uac00 \uc624\uc9c0 \uc54a\ub3c4\ub85d \ud55c\ub2e4.
		newnum += numarray[i];
	}
	// \uc18c\uc22b\uc810\uc774\ud558 \uac12\uc774 \uc788\uc73c\uba74 \ub9c8\uc9c0\ub9c9\uc5d0 \ubd99\uc5ec \uc900\ub2e4.
	if( point > -1 ) newnum += num2.substring( point, num2.length );

	// , \ub97c \uc0bd\uc785\ud55c \ubb38\uc790\uc5f4\uc744 return
	if(bFlag)	newnum = "-" + newnum;
	return newnum;
}
*/
/**
 * Function Name : isNumIndex2()
 * Description   : \uc18c\uc22b\uc810\uc774 \uc788\ub294\uacbd\uc6b0 \uc720\ud6a8\ud55c\uc9c0 \uc5ec\ubd80\uccb4\ud06c.
 * @Parameter    : String
 *                 \uc608) "12345.12" -> true
 * @Return		 : Boolean
 * \uc0ac\uc6a9 Function : isNumber()
 */
function isNumIndex2(name){
	if(name.indexOf(".") >= 0){
		var idx1;
		var name1;
		var name2;

		idx1 = name.indexOf(".");
		name1 = name.substring(0, idx1);
		name2 = name.substring(idx1+1);
		if(name2=='') name=0;

		if(!isNumber(name1) || !isNumber(name2)){
			return false;
		}
	}else{
		if(!isNumber(name)){
			return false;
		}
	}
	return true;
}

/**
 * Function Name : isNumber()
 * Description   : \uc720\ud6a8\ud55c \uc22b\uc790\uc778\uc9c0\uc9c0 \uc5ec\ubd80\uccb4\ud06c.
 * @Parameter    : String
 *                 \uc608) "12345" -> true
 * @Retrun		 : Boolean
 * \uc0ac\uc6a9 Function : None
 */
function isNumber(inputStr){
	for(var i = 0; i < inputStr.length; i++){
		 var oneChar = inputStr.charAt(i);
		 if(oneChar < "0" || oneChar > "9")
			  return false;
	}
	return true;
}

function isNumberComma(inputStr){
	for(var i = 0; i < inputStr.length; i++){
		var oneChar = inputStr.charAt(i);
		if(oneChar < "0" || oneChar > "9"){
			return false;
		}else if(oneChar != ","){
			return false;
		}
	}
	return true;
}

/**
 * Function Name : initValue()
 * Description   : \uc785\ub825 \ud30c\ub77c\ubbf8\ud130\uc758 \uccab\uae00\uc790\ub97c \uac00\uc9c0\uace0 \uc634
 * @Parameter	 : String
 * @Return		 : String
 * \uc0ac\uc6a9 Function : None
 */
function initValue(inputStr){
	var newValue = "";

	if(inputStr.length > 0){
		newValue = inputStr.substring(0, 1);
	}

	return newValue;
}

/**
 * Function Name : chgNumber()
 * Description   : \uc785\ub825 \ud30c\ub77c\ubbf8\ud130\ub97c  \uc22b\uc790\ub85c \ubcc0\ud658
 * @Parameter	 : String
 * @Return		 : integer
 * \uc0ac\uc6a9 Function : None
 */
function chgNumber(inputStr){
	var newValue = 0;

	if(inputStr != ""){
		newValue = parseInt(inputStr);
	}

	return newValue;
}

/**
 * Function Name : mkNumFormat()
 * Description   : \uc18c\uc218\uc810 \uc790\ub9ac\uc218\uc5d0 \ub9de\uc6cc\uc11c \ucd9c\ub825 (ex: 123->123.00, 123.456-> 123.47)
 * @Parameter	chVal(String, Number \uac00\ub2a5) : \ubcc0\uacbd \uac12
 * @Parameter	arrNum(integer) \uc18c\uc218\uc810 \uc790\ub9ac \uc774\ud558 \uc218
 * @Return		 : String
 * \uc0ac\uc6a9 Function : isNumIndex2
 */
function mkNumFormat(chVal, arrNum){
	var sChVal = chVal.toString();
	var ldHpn = false;
	if(sChVal.substring(0,1) == '-'){
		sChVal = sChVal.substring(1);
		ldHpn = true;
	}
	if(!isNumIndex2(sChVal))
		return;
	var pIdx = sChVal.indexOf('.');
	if(pIdx == 0){
		var rtnVal = mkNumFormat(ldHpn? "-0"+sChVal:"0"+sChVal, arrNum);
		return rtnVal;
	}
	if(pIdx == -1){		// '.'\uc774 \uc5c6\uc744 \uacbd\uc6b0
		sChVal += ".";
		for(var i=0;i<arrNum;i++)
			sChVal += "0";
		return ldHpn? "-"+sChVal:sChVal;
	} else if(sChVal.length-pIdx-1 == arrNum){	// \uc870\uac74\uacfc \uc77c\uce58\ud560 \uacbd\uc6b0 \uadf8\ub0e5 return
		return ldHpn? "-"+sChVal:sChVal;
	} else if(sChVal.length-pIdx-1 > arrNum){		// \uc774\ud558 \uc18c\uc218\uc810\uc758 \uc218\uac00 \ub9ce\uc744\uacbd\uc6b0 \ubc18\uc62c\ub9bc\ud558\uc5ec return
		var sTmp = "1";
		for(var i=0; i<arrNum; i++)
			sTmp += "0";
		var rtnVal = mkNumFormat(Math.round(parseFloat(sChVal)*parseInt(sTmp))/parseInt(sTmp), arrNum);
		return rtnVal;
	} else if(sChVal.length-pIdx-1 < arrNum){		// \uc774\ud558 \uc18c\uc218\uc810\uc774 \uc801\uc744 \uacbd\uc6b0 '0'\ucd94\uac00 \ud6c4 return
		for(var i=0; i <= arrNum-(sChVal.length-pIdx-1); i++){
			sChVal += "0";
		}
		return ldHpn? "-"+sChVal:sChVal;
	}
}

/**
 * Function Name : commaNum()
 * Description   : ���ڿ� 3�ڸ����� �޸��� ����
 * @Parameter	 : number
 * @Return		 : String
 * \uc0ac\uc6a9 Function : None
 */
function commaNum(num){

	if(num < 0){ num *= -1; var minus = true}
	else var minus = false

	var dotPos = (num+"").split(".")
	var dotU = dotPos[0]
	var dotD = dotPos[1]
	var commaFlag = dotU.length%3

	if(commaFlag){
		var out = dotU.substring(0, commaFlag)
		if(dotU.length > 3) out += ","
	}
	else var out = ""

	for(var i=commaFlag; i < dotU.length; i+=3){
		out += dotU.substring(i, i+3)
		if( i < dotU.length-3) out += ","
	}

	if(minus) out = "-" + out
	if(dotD) return out + "." + dotD
	else return out
}

/**
 * Function Name : fnRound()
 * Description   : �Ҽ��� ���� 2�ڸ����� ǥ��
 * @Parameter	 : number
 * @Return		 : number
 * \uc0ac\uc6a9 Function : None
 */
function fnRound(value){
	var a;
	a =  Math.round(value * 100)/100;

	return a;
}

/**
 * Function Name : row_color()
 * Description   : ���̺��� onclick, mouseover, mouseout �̺�Ʈ�� ���� row�� ����ó�� 1
 * @Parameter	 : object
 * @Return		 : number
 * \uc0ac\uc6a9 Function : None
 */
var oldObj = null;
function row_color(obj, flag){

	if(flag == 1){
		obj.className = 'tgrid-row-highlight';
	}else if(flag == 2 && oldObj != obj){
		obj.className = 'tgrid-row1-highlight';
	}else{
		if(oldObj != null)
			oldObj.className = 'tgrid-row1-highlight';
		oldObj = obj;
		obj.className = 'tgrid-row-select';
	}
}

/**
 * Function Name : row_color2()
 * Description   : ���̺��� onclick, mouseover, mouseout �̺�Ʈ�� ���� row�� ����ó�� 2
 * @Parameter	 : object
 * @Return		 : number
 * \uc0ac\uc6a9 Function : None
 */
var oldObj2 = null;
function row_color2(obj, flag){

	if(flag == 1){
		obj.className = 'tgrid-row-highlight';
	}else if(flag == 2 && oldObj2 != obj){
		obj.className = 'tgrid-row1-highlight';
	}else{
		if(oldObj2 != null)
			oldObj2.className = 'tgrid-row1-highlight';
		oldObj2 = obj;
		obj.className = 'tgrid-row-select';
	}
}

/**
 * Function Name : row_color3()
 * Description   : ���̺��� onclick, mouseover, mouseout �̺�Ʈ�� ���� row�� ����ó�� 3
 * @Parameter	 : object
 * @Return		 : number
 * \uc0ac\uc6a9 Function : None
 */
var oldObj3 = null;
function row_color3(obj, flag){

	if(flag == 1){
		obj.className = 'tgrid-row-highlight';
	}else if(flag == 2 && oldObj3 != obj){
		obj.className = 'tgrid-row1-highlight';
	}else{
		if(oldObj3 != null)
			oldObj3.className = 'tgrid-row1-highlight';
		oldObj3 = obj;
		obj.className = 'tgrid-row-select';
	}
}

/**
 * Function Name : fnChkNum
 * Description   : ����[0-9]�� �Է°���
*/
function fnChkNum(){
	if(!((event.keyCode>47)&(event.keyCode<58))){
		event.returnValue=false;
	}
}

/**
 * Function Name : fnChkNum2
 * Description   : ����[0-9], �Ҽ���[.], ���̳ʽ� ��ȣ[-] �� �Է°���
*/
function fnChkNum2(){
	if(!((event.keyCode>47)&(event.keyCode<58)||event.keyCode==45|| event.keyCode==46)){
		event.returnValue=false;
	}
}
/**
 * Function Name : getTransTag
 * Description   : ����[", '] �� ���� html ����[&quot;, &#39;]�� ��ȯ
 * @param val
 * @return
 */
function getTransTag(val){
	return replace(replace(val, "\"","&quot;"), "\'", "&#39;");
}

/**
 * Function Name : getYearOption
 * Description   : �⿡ ���� OPTION html ��
 * @param yyyymm
 * @return
 */
function getYearOption(yyyymm){
	var startYear = 2004;

	var curDate = new Date();
	var lastYear = curDate.getFullYear();
	var year = lastYear;

	if(yyyymm && yyyymm.length == 6){
		year = parseInt(yyyymm.substring(0,4));
		if(startYear > year)
			startYear = year;
		if(lastYear < year)
			lastYear = year;
	}

	var yearOption = "";
	for(var i=lastYear;i>=startYear;i--)
		yearOption += "<OPTION value='"+i+"' "+(i==year?"selected":"")+">"+i+"</OPTION>";

	return yearOption;
}

/**
 * Function Name : getMonthOption
 * Description   : �� ���� OPTION html ��
 * @param yyyymm
 * @return
 */
function getMonthOption(yyyymm){
	var month;
	if(yyyymm && yyyymm.length == 6){
		month = yyyymm.substring(4,6);
	}else{
		month = new Date().getMonth() + 1;
	}

	var monthOption = "";
	for(var i=1; i<13; i++){
		var disMonth = (100 + i + "").substring(1);
		monthOption += "<OPTION value='"+disMonth+"' "+(i==month?"selected":"")+">"+disMonth+"</OPTION>";
	}

	return monthOption;
}


/*
 * 날짜포맷에 맞는지 검사
*/
function isDateFormat(d) {
	 var df = /[0-9]{4}-[0-9]{2}-[0-9]{2}/;
	 return d.match(df);
}

/*
 * 윤년여부 검사
*/
function isLeaf(year) {
	 var leaf = false;

	 if(year % 4 == 0) {
	 	leaf = true;

		 if(year % 100 == 0) {
		 	leaf = false;
		 }

		 if(year % 400 == 0) {
		 	leaf = true;
		 }
	 }

	 return leaf;
}

/*
 * 날짜가 유효한지 검사
*/
function isValidDate(d) {
	 // 포맷에 안맞으면 false리턴
	if(!isDateFormat(d)) {
	 	return false;
	 }

	 var month_day = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

	 var dateToken = d.split('-');
	 var year = Number(dateToken[0]);
	 var month = Number(dateToken[1]);
	 var day = Number(dateToken[2]);

	 // 날짜가 0이면 false
	 if(day == 0) {
	 	return false;
	 }

 	var isValid = false;

	 // 윤년일때
	if(isLeaf(year)) {
		 if(month == 2) {
			 if(day <= month_day[month-1] + 1) {
				 isValid = true;
			 }
		 } else {
			 if(day <= month_day[month-1]) {
			 	isValid = true;
			 }
		 }
	 } else {
		 if(day <= month_day[month-1]) {
			 isValid = true;
		 }
 	}

 	return isValid;
}
