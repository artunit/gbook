/*
 *		util.js - generic flowscriptfunctions
 *
 *              Art Rhyno (arhyno@uwindsor.ca), August 2006
 *              (c) Copyright GNU General Public License (GPL)
 *
 *              Revised:
*/

/*
	sleep() - the rhino implementation of javascript doesn't have a 
        setTimeout function, but this is a better approach anyway since
		javascript still consumes CPU. Java has a true sleep
		function and that is what we use here.
*/
function sleep (millisecs)
{
	//bump up to seconds
	var theSecs = millisecs * 1000;
	java.lang.Thread.sleep(theSecs);
}//sleep

function trim(theStr) {
	return theStr.replace(/^\s*/, "").replace(/\s*$/, "");
}//trim

function startsWith(theStr, theStart) {
	var theStrStart = theStr.substring(0,theStart.length);
	//print("comparing " + theStrStart + " to " + theStart);
	if (theStrStart == theStart)
		return true;

	return false;
}//startsWith

function endsWith(theStr, theEnd) {
	var theStrEnd = theStr.substring(theStr.length - theEnd.length);
	//print("comparing " + theStrEnd + " to " + theEnd);
	if (theStrEnd == theEnd)
		return true;

	return false;
}//endsWith
                
function extractAttribute(attribute, attrStr) {
	var attrVal = attrStr.replace(/\s+=/,'=') + "";
	attrVal = attrVal.replace(/=\s+/,'=');
	var attrLoc = attribute + "=";
	var attrPos = attrVal.indexOf(attrLoc);
                        
	if (attrPos != -1) {
		attrVal = attrVal.substring(attrPos +
			attrLoc.length);
		attrPos = attrVal.indexOf(",");
                                
		if (attrPos != -1) {
			attrVal = attrVal.substring(0,
				attrPos);
                                
		}//if attrPos
                        
	}//if
                        
	return attrVal;
}//extractAttribute

//used for file paths
function figureOutPath(theBase, theApp, theFile) {
    var fullFile = theFile;
    var fullBase = theBase;
	  
    if (!endsWith(fullBase,'/'))
		fullBase = fullBase + "/";
        
    if (theFile.indexOf("/") != 0)
        fullFile = fullBase + theApp + "/" + fullFile;

    return fullFile;
}//figureOutPath

//quotes can be nasty 
function fixQuote(theVal) {
	var retVal = theVal.replace(/\'/g,"\\\'");

	return retVal;
}

function countInstances(theVal, theChar) {
  var substrings = theVal.split(theChar);
  return substrings.length - 1;
}

function sortOutDate(dateStr, dashed) {
	var theDate = new Date();
	if (dashed)
		dateStr.match(/(\d{4})\-(\d{2})\-(\d{2})/);
	else
		dateStr.match(/(\d{4})\.(\d{2})\.(\d{2})/);

	theDate.setYear(RegExp.$1);
	theDate.setMonth(RegExp.$2);
	theDate.setDate(RegExp.$3);

	return theDate;
}//sortOutDate

function jsonEval(inStr) {
	var theStr = inStr;
	if (countInstances(theStr,"}") < countInstances(theStr,"{")) {
		theStr += "}";
	}//if
		
	var evalObj = null;
	try {
        evalObj = eval('(' + theStr + ')');
	} catch (evalProb) {
		print("jsonify can't convert: " + evalObj);
		print("jsonify can't convert - " + evalProb);
	}
        
    return evalObj; 
}//jsonEval

//jsonify - put results of pipeline into JSON format
function jsonify(pipeline, pipeinfo) {
        
    var stream = new java.io.ByteArrayOutputStream();
    cocoon.processPipelineTo( pipeline, pipeinfo, stream );
    var theVal = stream.toString() + "";
		
    var theEval = jsonEval(theVal);
 
	return theEval;

}//jsonify

//jsonify - get json results but leave in string format
function dejsonify(pipeline, pipeinfo) {
        var stream = new java.io.ByteArrayOutputStream();
        cocoon.processPipelineTo( pipeline, pipeinfo, stream );
        return stream.toString() + "";
}//dejsonify

//for inspecting javascript objects
function listProperties(obj) {
   var propList = "";
   for(var propName in obj) {
      if(typeof(obj[propName]) != "undefined") {
         propList += (propName + ", " + typeof(obj[propName]));
      }
   }
   print("--> " + propList);
}
