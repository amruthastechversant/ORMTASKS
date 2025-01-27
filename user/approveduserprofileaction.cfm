<cffunction  name="getUserProfile" access="public" returnType="string">
    <cfargument  name="username" type="string" required="true">

<cfset datasource="dsn_addressbook">
    <cfquery name="qryGetUserDetails" datasource="#datasource#">
        SELECT id, str_phone, str_name, str_username
        FROM tbl_users
        WHERE str_username = <cfqueryparam value="#session.str_username#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfif qryGetUserDetails.recordCount>
        <cfreturn  qryGetUserDetails.str_phone>
    <cfelse>
        <cfreturn  "Phone not found">
    </cfif>
 </cffunction> 
 <cfset userPhone=getUserProfile(session.str_username)>