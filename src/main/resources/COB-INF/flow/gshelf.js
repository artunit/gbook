/*
 *		gshelf.js - coordinate google interactions to add books to a google book shelf
 *
 *              Art Rhyno (artrhyno@uwindsor.ca), Mar. 2011
 *              (c) Copyright GNU General Public License (GPL)
 *
 *              Revised: Apr. 2011, moved to trunk version of cocoon
*/

function googleshelf() {

    //this is arbitrary, but if a book can't be added
    //after this many tries, it's time to pull the plug
    //on the process
    var tryAdds = 5;

    //number of seconds to pause, 10 minutes in this case
    var pauseAmt = 600;

	var start=Packages.java.lang.System.currentTimeMillis();

    var setNum = parseInt(cocoon.parameters["setnum"]);
    var startNum = parseInt(cocoon.parameters["startnum"]);
    var stepNum = parseInt(cocoon.parameters["stepnum"]);
    
    //we can't do anything without these
    if (setNum <0 || stepNum < 0 || startNum < 0) {
        updateSession("process parameter problem");
        return;
    }//if

    //google account information
    var gaccount = cocoon.parameters["gaccount"] + "";
    var gpass = cocoon.parameters["gpass"] + "";
    var userid = cocoon.parameters["userid"] + "";
    var libraryShelf = cocoon.parameters["libraryshelf"] + "";
    var shelfType = cocoon.parameters["shelf_type"] + "";

    if (gaccount.length == 0 || gpass.length == 0 || userid.length == 0
        || libraryShelf.length == 0 || shelfType.length == 0)
    {
        updateSession("gdata parameter problem");
        return;
    }//if

    setUpSession("gbook",shelfType, setNum, stepNum, startNum, start);
    cocoon.redirectTo("./status?pipeline=GBshelver-" + shelfType + "-" +
        setNum + "-" + startNum);

    //mail information
    var mailNotify = false;

    var smtpHost = cocoon.parameters["smtp_host"] + "";
    var smtpPort = cocoon.parameters["smtp_port"] + "";
    var smtpTo = cocoon.parameters["smtp_to"] + "";
    var smtpFrom = cocoon.parameters["smtp_from"] + "";

    if (smtpHost.length > 0 && smtpPort.length > 0 && smtpTo.length > 0
        && smtpFrom.length > 0)
    {
        mailNotify = true;
    }//if

    var identlist = null;

    var numFound = 0;
    var numProcessed = 0;
    var delayCnt = 0;
    var delayCyc = 0;
    var tryUpd = 0;

    var statusStr = "";

    while (startNum >= 0 && tryUpd < tryAdds && !sessionZapped()) {
        //get current set of numbers
        identlist = jsonify("set-" + shelfType + "-" + setNum + "-" + 
            startNum + "-" + (startNum + stepNum));

        var totalIdents = identlist.idents.length;
        if (totalIdents <= 0) {
            updateSession("ALL DONE: Processed: " + numProcessed + 
                " - Found: " + numFound +
                " - Missed: " + (numProcessed - numFound));
            return;
        }//if
                
        //we use the gdata API for interactions
        var googleData = {
            "accountType" : "GOOGLE",
            "Email"  : gaccount,
            "Passwd"  : gpass,
            "service"  : "print",
            "source" : "jamun-InsideBook-0.01"
        }//googleData

        var google = jsonify("gdata",googleData);
        var authToken = google.Auth + "";

        for (var i=0; i < totalIdents && tryUpd < tryAdds && !sessionZapped(); i++) {
            var ident = identlist.idents[i] + "";
                
            if (ident.length > 0) {
                numProcessed++;
                var result = jsonify("shelftest"); 
			  
                if (result.code != 200) {
                    if (!dealWithShelfProblem(mailNotify, smtpHost, smtpPort, smtpTo,
                            smtpFrom, pauseAmt))
                    {
                        updateSession("stopping, waiting to long to get past shelf problem");
                        return;
                    }//if
                }//if

                //check to see if the current item is already on the shelf
			    result = jsonify("check-" + shelfType + "-" + ident);
                var totResult = parseInt(result.totResults);

                if (totResult == 0) {
                    var voldata = jsonify("ident-" + shelfType + "-" + ident + "-" + ident.length);
                    var volid = voldata.volid + "";

                    if (volid.length > 0) {
                        var gbookData = {
                            	"authsub" : authToken,
                            	"userid"  : userid,
                            	"shelfid" : libraryShelf,
                            	"volid" : volid
                        }//gbookData
                        	
                        google = jsonify("shelvebook",gbookData);
                        var resultcode = google.code;
					
                        if (resultcode == 201) { 
						    tryUpd=0;
						    numFound++;
					    } else {
						    print("ROLLBACK-> " + resultcode);
						    tryUpd++;
						    sleep(pauseAmt);
						    i--;
                            numProcessed--;
					    }//if resultcode
                    	
                    }//if volif
			    } else {
				    numFound++;
			    } //if totresult
                
            }//if
                
            statusStr = " Processed: " + numProcessed + " - Found: " + numFound +
                " - Missed: " + (numProcessed - numFound);

            updateSession(statusStr);
		    
            if (++delayCnt == 100) {
			    delayCyc++;
			    if (delayCyc < 10) {
                    statusStr = "pausing " + (pauseAmt/2) + " seconds";
                    updateSession(statusStr);
				    sleep(pauseAmt/2);
			    } else {
                    statusStr = "pausing " + pauseAmt + " seconds";
                    updateSession(statusStr);
				    sleep(pauseAmt);
				    delayCyc = 0;
			    }//if
        
			    delayCnt = 0;
            }//if

        }//for
            
        startNum += stepNum; 
    }//while 

	if (tryUpd >= 5) {
		statusStr = "PROBLEM: last " + tryUpd + " attempts to add to shelf have failed, zap session";
        updateSession(statusStr);
    }
	
    var end=Packages.java.lang.System.currentTimeMillis();
    statusStr = "ALL DONE, elapsed processing time: " + (end - start) + " milliseconds";

    if (sessionZapped)
        statusStr = "ALL DONE (zapped), number checked: " + numProcessed + 
            " elapsed processing time: " + (end - start) + " milliseconds";
    
    updateSession(statusStr);
}//googleShelf

function dealWithShelfProblem(mailNotify,smtpHost,smtpPort,smtpTo,
    smtpFrom, pauseAmt)
{
                
    var notify = false;
    var waitCnt =  0;
    var shelfResult = jsonify("shelftest"); 
    var statusStr = "";

    while (shelfResult.code != 200) {
        if (!notify){
            //if (mailNotify) {
            if (mailNotify && notify) {
                cocoon.sendPageAndWait( 
                    "notifyShelf", 
                        {   "mailHost": smtpHost,
                            "mailPort": smtpPort,
                            "mailTo": smtpTo,
                            "mailFrom": smtpFrom,
                            "message" : "unable to add to shelf, probably " +
                                "need to set shelf to public"
                        }
                );//sendPageAndWait
                statusStr += " mail sent";
            }//if
            notify = true;
        }//if
                
        //wait pause interval
        sleep(pauseAmt);
                    
        if (++waitCnt >= 24) {
            print("waited " + (waitCnt * pauseAmt) + 
                " seconds, giving up...");
            return false; 
        } else {
            statusStr = "paused " + (waitCnt * pauseAmt) + " seconds, trying shelf access again" + statusStr;
            updateSession(statusStr);
        }//if
    
        shelfResult = jsonify("shelftest"); 
    }//while

    return true;
}//dealWithShelfProblem
    
function setUpSession(sessionName , shelfType, setNum, stepNum, startNum, start) {
    var sessionDate = Date(start);
    var sessionInfo = { "start" : sessionDate + "", 
        "shelfType" : shelfType, "setNum" : setNum,
        "stepNum" : stepNum, "startNum" : startNum,
        "status" : "starting"};
    cocoon.session.setAttribute("gbook", sessionInfo);
}

function updateSession(statusStr) {
    print(statusStr);
    var sessionInfo = cocoon.session.getAttribute("gbook");
    if (sessionInfo != null) { 
        var curStatus = sessionInfo.status;
        if (curStatus.indexOf("zap") == -1 || statusStr.indexOf("ALL DONE") != -1) {
            sessionInfo.status = statusStr;
            cocoon.session.setAttribute("gbook", sessionInfo);
        } 
    }
}

function sessionZapped() {
    var sessionInfo = cocoon.session.getAttribute("gbook");
    if (sessionInfo != null) {
        var statusStr = sessionInfo.status;
        if (statusStr.indexOf("zap") != -1) {
            return true;
        }
    }
    return false;
}
