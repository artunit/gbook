/*
 *      monitor.js - cron flowscript for jamun
 *
 *              Art Rhyno (http://projectconifer.ca), Apr. 2011
 *              (c) Copyright GNU General Public License (GPL) for modifications
 *
 *              Revised:
*/

function monitor() {
    var sessionObj = cocoon.session.getAttribute("gbook");

    if (sessionObj == null) {
        sessionObj = { "start" : "", "status" : ""};
        cocoon.session.setAttribute("gbook",sessionObj);
    }

    var realPath = cocoon.parameters["real_path"] + "";
    var logFile = cocoon.parameters["log_file"] + "";
    var logSnippet = parseInt(cocoon.parameters["log_snippet"]);
    var monitorFile = trim(logFile);
    realPath = trim(realPath);
    var logLines = null;

    if (monitorFile.length > 0 && logSnippet > 0) {
        if (!startsWith(monitorFile,"/")) {
            if (!endsWith(realPath,"/"))
                realPath += "/";
            if (startsWith(realPath,"file:"))
                realPath = realPath.substring(5);
            monitorFile = realPath + monitorFile;
        }
        var testFile = new Packages.java.io.File(monitorFile);
        if (testFile.exists()) 
            logLines = getLastLogEntries(logSnippet, monitorFile);
    }//if

    var pipename = "GBook Shelf";
    var pipeline = cocoon.request.getParameter( "pipeline" );
    if (pipeline == null)
        pipeline = "GBshelver-isbn-0-0"

    var done = false;
    while (!done) {
        cocoon.sendPageAndWait( "showstatus", 
            {"displayname" : pipename,
            "log" : logLines,
            "pipename" : sessionObj.status.length > 0 ? pipename:"",
            "pipeline" : pipeline,
            "session" : sessionObj} 
        );

        var action = cocoon.request.getParameter( "action" );
        if (action == "launcher") {
            //terminate
            var actiontype = cocoon.request.getParameter("immediately");
            pipeline = cocoon.request.getParameter("pipeline");
            if (actiontype != null && pipeline != null) {
                pipeline = trim(pipeline + "");
                var sessStatus = sessionObj.status;
                //we don't want to start 2 pipelines
                if (pipeline.length > 0 && 
                    (sessStatus.length == 0 || sessStatus.indexOf("ALL DONE") != -1) ) 
                {
                    //cocoon.sendPage(pipeline);
                    cocoon.session.setAttribute("gbook", null);
                    cocoon.redirectTo("./" + pipeline);
                    cocoon.exit();
                } else {
                    updateStatus(sessStatus + " - new session will not start until complete");
                }
            }
            actiontype = cocoon.request.getParameter("zapit");
            if (actiontype != null) {
                updateStatus("zap requested, check refresh");
                cocoon.redirectTo("./status");
                cocoon.exit();
            }
        } else {
            // refresh work
            sessionObj = cocoon.session.getAttribute("gbook");
        }
    }
}

function getLastLogEntries(numLines, logFile) {
    var rdr = new java.io.BufferedReader(java.io.FileReader(logFile));
    var count = 0;
        
    var logLines = new java.util.LinkedList();
    var line = rdr.readLine();
    while (line != null) {
        count++;
        logLines.addLast(line);
            
        if (count > numLines)
            logLines.removeFirst();
            
        line = rdr.readLine();
    }//while

    return logLines;
}//getLastLogEntries

function updateStatus(newStatus) {
    var currSession = cocoon.session.getAttribute("gbook");
    currSession.status = newStatus;
    cocoon.session.setAttribute("gbook",currSession);
}
