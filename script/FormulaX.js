/**
 * JS Formula Parser
 * -------------------
 * (c) 2012 Alexander Schenkel, alex@alexi.ch
 *
 * JS Formula Parser takes a string, parses its mathmatical formula
 * and creates a evaluatable Formula object of it.
 *
 * Example input:
 *
 * var fObj = new Formula('sin(PI*x)/(2*PI)');
 * var result = fObj.evaluate({x: 2});
 *
 * 
 *
 * LICENSE:
 * -------------
 * Copyright 2012 Alexander Schenkel, alex@alexi.ch
 * You can use this library for and within whatever you want,
 * but please put a reference to me in your project and drop me a message, thanks. 
 *
 * SVN-ID: $Id: FormulaX.js,v 1.1 2015/01/30 02:34:08 cvs Exp $
 */
var Formula = function(fStr) {
	var formulaExpression = null;
	
	// Splits the given string by ',', makes sure the ',' is not within
	// a sub-expression
	// e.g.: str = "x,pow(3,4)" returns 2 elements: x and pow(3,4).
	var splitFunctionParams = function(toSplit) {
		// do not split on ',' within matching brackets.
		var pCount = 0;
		var paramStr = '';
		var params = [];
		for (var i = 0; i < toSplit.length; i++) {
			if (toSplit[i] === ',' && pCount === 0) {
				// Found function param, save 'em
				params.push(paramStr);
				paramStr = '';
			} else if (toSplit[i] === '(') {
				pCount++;
				paramStr += toSplit[i];
			} else if (toSplit[i] === ')') {
				pCount--;
				paramStr += toSplit[i];
				if (pCount < 0) {
					throw "ERROR: Too many closing parentheses!";
				}
			} else {
				paramStr += toSplit[i];
			}
		}
		if (pCount !== 0) {
			throw "ERROR: Too many opening parentheses!";
		}
		if (paramStr.length > 0) {
			params.push(paramStr);
		}
		return params;
	};
	
	var parse = function(str) {
		/*
		So... How do we parse a formula?
		first, we have to split the items into 'expressions': An expression can be:
		  - a number, e.g. '3.45'
		  - an unknown variable, e.g. 'x'
		  - a single char operator, such as '*','+' etc...
		  - a function, such as sin(x)
		  - a parenthessed expression, containing other expressions
	   
		So where do we begin....? at the beginning, I would say: Parse the string from
		left to right, using a state machine: each time a char is read, decide which
		state we are in or into which state we have to change.   
		*/
	   
		// First of all: Away with all we don't have a need for:
		// Additionally, replace some constants:
		/*
		str = function(s){
			s = s.replace(/[\s]+/,'');
			s = s.replace(/([^A-Za-z0-9_]+|^)PI([^A-Za-z]+|$)/,'$1'+Math.PI+'$2');
			s = s.replace(/([^A-Za-z0-9_]+|^)E([^A-Za-z]+|$)/,'$1'+Math.E+'$2');
			s = s.replace(/([^A-Za-z0-9_]+|^)LN2([^A-Za-z]+|$)/,'$1'+Math.LN2+'$2');
			s = s.replace(/([^A-Za-z0-9_]+|^)LN10([^A-Za-z]+|$)/,'$1'+Math.LN10+'$2');
			s = s.replace(/([^A-Za-z0-9_]+|^)LOG2E([^A-Za-z]+|$)/,'$1'+Math.LOG2E+'$2');
			s = s.replace(/([^A-Za-z0-9_]+|^)LOG10E([^A-Za-z]+|$)/,'$1'+Math.LOG10E+'$2');
			s = s.replace(/([^A-Za-z0-9_]+|^)SQRT1_2([^A-Za-z]+|$)/,'$1'+Math.SQRT1_2+'$2');
			s = s.replace(/([^A-Za-z0-9_]+|^)SQRT2([^A-Za-z]+|$)/,'$1'+Math.SQRT2+'$2');
			return s;
			
		}(str);
	   */
		var lastChar = str.length - 1;
		var act = 0;
		var state = 0;
		var expressions = [];
		var char = '';
		var tmp = '';
		var funcName = null;
		var pCount = 0;
		while (act <= lastChar) {
			switch(state) {
				case 0:
					// None state, the beginning. Read a char and see what happens.
					char = str.charAt(act);
					if (char.match(/[0-9.]/)) {
						// found the beginning of a number, change state to "within-number"
						state = 'within-nr';
						tmp = '';
						act--;
					} else if(char.match(/[\+\-\*\/]/)) {
						// Simple operators. Note: '-' must be treaten specially,
						// it could be part of a number.
						// it MUST be part of a number if the last found expression
						// was an operator (or the beginning):
						if (char === '-') {
							if (expressions.length === 0 || (expressions[expressions.length-1] && typeof expressions[expressions.length-1] === 'string')) {
								state = 'within-nr';
								tmp = '-';
								break;
							}
						}
						
						// Found a simple operator, store as expression:
						expressions.push(char);
						state = 0;
					} else if (char ==='(') {
						// left parenthes found, seems to be the beginning of a new sub-expression:
						state = 'within-parentheses';
						tmp = '';
						pCount = 0;
					} else if (char.match(/[a-zA-Z]/)) {
						// multiple chars means it may be a function, else its a var which counts as own expression:
						if (act < lastChar && str.charAt(act+1).match(/[a-zA-Z]/)) {
							tmp = char;
							state = 'within-func';
						} else {
							// Single variable found:
							expressions.push(function(varname){
								return function(valObj) {
									// valObj contains a variable / value pair: If the variable matches
									// the varname found as expression, return the value.
									// eg: valObj = {x: 5,y:3}, varname = x, return 5
									if (valObj[varname] !== undefined) {
										return valObj[varname];
									}
								};
							}(char));
							state = 0;
							tmp = '';
						}
					}
					break;
				case 'within-nr':
					char = str.charAt(act);
					if (char.match(/[0-9.]/)) {
						//Still within number, store and continue
						tmp += char;
						if (act === lastChar) {
							expressions.push(Number(tmp));
						}
					} else {
						// Number finished on last round, so add as expression:
						expressions.push(Number(tmp));
						tmp = '';
						state = 0;
						act--;
					}
					break;
					
					
				case 'within-func':
					char = str.charAt(act);
					if (char.match(/[a-zA-Z]/)) {
						tmp += char;
					} else if (char === '(') {
						funcName = tmp;
						tmp = '';
						pCount = 0;
						state = 'within-func-parentheses';
					} else {
						throw 'ERROR: Wrong character for function at position '+act;
					}
					
					break;
				   
				   
				case 'within-parentheses':
				case 'within-func-parentheses':
					char = str.charAt(act);
					if (char === ')') {
						//Check if this is the matching closing parenthesis.If not, just read ahead.
						if (pCount <= 0) {
							// Yes, we found the closing parenthesis, create new sub-expression:
							if (state === 'within-parentheses') {
								
								expressions.push(function(arg){
									var f = new Formula(arg);
									return f;
								}(tmp));
							} else if (state === 'within-func-parentheses') {
								// Function found: return a function that,
								// when evaluated, evaluates first the sub-expression
								// then returns the function value of the sub-expression.
								// Access to the function is private within the closure:
								expressions.push(function(arg,fname){
									// Functions can have multiple params, comma separated.
									// Split them:
									var args = splitFunctionParams(arg);
									for (var i = 0; i < args.length; i++) {
										args[i] = new Formula(args[i]);
									}
									// Args now is an array of function expressions:
									return function(valueObj) {
										var innerValues = [];
										for (var i = 0; i < args.length; i++) {
											innerValues.push(args[i].evaluate(valueObj));
										}
										// If the valueObj itself has a function definition with
										// the function name, call this one:
										if (valueObj && typeof valueObj[fname] === 'function') {
											return valueObj[fname].apply(this,innerValues);
										} else if (typeof Math[fname] === 'function') {
											// Has the JS Math object a function as requested? Call it:
											return Math[fname].apply(this,innerValues);
										} else {
											throw ("Function not found: "+fname);
										}
										
									};
								}(tmp,funcName));
								funcName = null;
							}
							state = 0;
						} else {
							pCount--;
							tmp += char;
						}
					   
					} else if (char === '(') {
						// begin of a new sub-parenthesis, increase counter:
						pCount++;
						tmp += char;
					} else {
						// all other things are just added to the sub-expression:
						tmp += char;
					}
					break;
			}
			act++;
		}
		return expressions;
	};
	
	var evaluate = function(valueObj) {
		/**
		 * here we do 3 steps:
		 * 1) evaluate (recursively) each element of the given array so that
		 *    each expression is broken up to a simple number.
		 * 2) now that we have only numbers and simple operators left,
		 *    calculate the high value operator sides (*,/)
		 * 3) last step, calculate the low value operators (+,-), so
		 *    that in the end, the array contains one single number.
		 * Return that number, aka the result.
		 */
		 var i = 0;
		 var item = 0;
		 var leftItem = null;
		 var rightItem = null;
		 var runAgain = true;
		 
		 // Step 0: do a working copy of the array:
		 var workArr = [];
		 for (i = 0; i < formulaExpression.length; i++) {
			 workArr.push(formulaExpression[i]); 
		 }
		 // Step 1, evaluate
		 for (i = 0; i < workArr.length; i++) {
			/**
			 * An element can be:
			 *  - a number, so just let it alone for now
			 *  - a string, which is a simple operator, so just let it alone for now
			 *  - a function, which must return a number: execute it with valueObj
			 *    and replace the item with the result.
			 *  - another Formula object: resolve it recursively using this function and
			 *    replace the item with the result
			 */
			 item = workArr[i];
			 if (typeof item === 'function') {
				 workArr[i] = item(valueObj);
			 } else if (item instanceof Formula) {
				 workArr[i] = item.evaluate(valueObj);
			 } else if (typeof item !== 'number' && typeof item !== 'string') {
				console.error('UNKNOWN OBJECT IN EXPRESSIONS ARRAY!',item);
				throw new Exception('Unknown object in Expressions array');
			 }
		 }
		 // Now we should have a number-only array, let's evaulate the '*','/' operators:
		 while (runAgain) {
			 runAgain = false;
			 for (i = 0; i < workArr.length; i++) {
				 item = workArr[i];
				 if (typeof item === 'string' && (item === '*' || item === '/')) {
					 if (i === 0 || i === workArr.length-1) {
						throw 'Wrong operator position!'; 
					 }
					 left = Number(workArr[i-1]);
					 right = Number(workArr[i+1]);
					 workArr[i-1] = (item === '*'?left*right:left/right);
					 workArr.splice(i,2);
					 runAgain = true;
					 break;
				 }
			 }
		 }
		 
		 // Now we should have a number-only array, let's evaulate the '*','/' operators:
		 runAgain = true;
		 while (runAgain) {
			 runAgain = false;
			 for (i = 0; i < workArr.length; i++) {
				 item = workArr[i];
				 if (typeof item === 'string' && (item === '+' || item === '-')) {
					 if (i === 0 || i === workArr.length-1) {
						throw new Exception('Wrong operator position!'); 
					 }
					 left = Number(workArr[i-1]);
					 right = Number(workArr[i+1]);
					 workArr[i-1] = (item === '+'?left+right:left-right);
					 workArr.splice(i,2);
					 runAgain = true;
					 break;
				 }
			 }
		 }
		 
		 
		 
		 // In the end the original array should be reduced to a single item,
		 // containing the result:
		 return workArr[0];
	};
	
	
	this.formulaStr = fStr;
	formulaExpression = parse(fStr);
	
	
	this.getExpression = function() {
		return formulaExpression;
	};
	this.evaluate = function(valueObj) {
		return evaluate(valueObj);
	};
	
	return this;
};


Formula.calc = function(formula,valueObj) {
	valueObj = valueObj || {};
	var F = new Formula(formula);
	return F.evaluate(valueObj);
};

