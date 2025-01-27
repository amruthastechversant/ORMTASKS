<cfscript>
    // Invalidate the session
    sessionInvalidate();

    // Optionally, clear session cookies if used
    cookie.sessionID = "";
    cookie.sessionID = false;

    // Redirect to login page after logout

</cfscript>
<cflocation url="../userlogin.cfm" addtoken="false">