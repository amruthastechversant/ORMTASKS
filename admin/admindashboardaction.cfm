<!---pagination--->
<cfparam name="form.currentPage" default="1">
<cfparam name="form.recordsPerPage" default="5">
<cfset variables.currentPage = val(structKeyExists(URL, "variables.currentPage") ? URL.variables.currentPage : form.variables.currentPage)>
<cfset variables.recordsPerPage = val(form.recordsPerPage)>
<cfset variables.offset = (currentPage - 1) * recordsPerPage>
<cfset variables.user=entityLoad("user")>
<!---getting permission options from sqltable--->
<cfset variables.permissionOptions = getPermissionOptions()>

<cfset variables.userCount=getUserCounts()>
<cfset variables.totalPendingRecords = userCount.totalPending>
<cfset variables.totalApprovedRecords = userCount.totalApproved>
<cfset variables.totalPendingPages = Ceiling(variables.totalPendingRecords / variables.recordsPerPage)>
<cfset variables.totalApprovedPages = Ceiling(variables.totalApprovedRecords / variables.recordsPerPage)>

<cfset variables.qryPendingUsers = getPendingUsers()>
<cfset variables.qryApprovedUsers = getApprovedUsers()>

<!---Function Block ------------->
<cffunction name="getPermissionOptions" access="public" returnType="array">
    <cfset var permissionList = entityLoad("permissions")>
    <cfreturn permissionList>
</cffunction>

<cffunction  name="getUserCounts" access="public" returnType="struct">
    <cfset var result={}>
    <cfset result.totalPending=arrayLen(entityLoad("user",{cbr_status='p'}))>
    <cfset result.totalApproved=arrayLen(entityLoad("user",{cbr_status='A'}))>
    <cfreturn result>
</cffunction>

<cffunction  name="getPendingUsers" access="public" returnType="any">
    <cfset var pendingUsers = []>
    <cfif structKeyExists(form, "str_keyword") and len(trim(form.str_keyword)) GT 0>
        <cfset keyword="%" & trim(form.str_keyword) & "%">
        <cfset pendingUsers = ormExecuteQuery(
            "FROM user u WHERE u.cbr_status = 'P' AND (u.str_name LIKE :keyword OR u.str_phone LIKE :keyword) ORDER BY u.id",
            { keyword = keyword },
            { maxResults = recordsPerPage, offset = offset }
        )>

        <cfset totalPendingUsers=ormExecuteQuery(
            "FROM user u WHERE u.cbr_status = 'P' AND (u.str_name LIKE :keyword OR u.str_phone LIKE :keyword) ORDER BY u.id",
            { keyword = keyword }
        )>

    <cfelse>
        <cfset pendingUsers = entityLoad("user", {cbr_status = 'P'}, "id", { maxResults = recordsPerPage, offset = offset })>
            <cfset totalPendingUsers = ormExecuteQuery("SELECT COUNT(u.id) FROM user u WHERE u.cbr_status = 'P'", {}, true)>
    </cfif>
    <cfreturn pendingUsers>
</cffunction> 

<cffunction  name="getApprovedUsers" access="public" returnType="any">
    <cfset var approvedUsers = []>
    <cfif structKeyExists(form, "str_keyword") and len(trim(form.str_keyword)) GT 0>    
        <cfset keyword="%" & trim(form.str_keyword) & "%">
        <cfset approvedUsers=ormExecuteQuery(
            "FROM user u where u.cbr_status='A' and u.userRole.id ='2' and (u.str_name LIKE :keyword OR u.str_phone LIKE :keyword) ORDER BY u.id",
            {keyword=keyword},
            {maxResults=recordsPerPage, offset = offset}
        )>
        <cfset totalApprovedUser=ormExecuteQuery(
            "FROM user u WHERE u.cbr_status = 'A' AND (u.str_name LIKE :keyword OR u.str_phone LIKE :keyword) ORDER BY u.id",
                { keyword = keyword }
        )>
    <cfelse>
        <cfset approvedUsers=entityLoad("user",{cbr_status='A'},"id",{maxResults=recordsPerPage,offset=offset})>
        <cfset totalApprovedUsers = ormExecuteQuery("SELECT  COUNT(u.id) FROM user u WHERE u.cbr_status = 'A'",{},true)>
    </cfif>
    <cfreturn approvedUsers>
</cffunction>


<!--- <cffunction  name="getPendingUsers" access="public" returnType="query"> 
<cfquery name="qryPendingUsers" datasource="#datasource#">
    SELECT id, str_name, str_phone, str_username, cbr_status
    FROM tbl_users
    WHERE cbr_status = 'P'
    <cfif structKeyExists(form, "str_keyword") AND len(trim(form.str_keyword)) GT 0>
        AND (
            str_name LIKE <cfqueryparam value="%#trim(form.str_keyword)#%" cfsqltype="cf_sql_varchar">
            OR str_phone LIKE <cfqueryparam value="%#trim(form.str_keyword)#%" cfsqltype="cf_sql_varchar">
        )
    </cfif>
    ORDER BY id
    LIMIT <cfqueryparam value="#startRecord#" cfsqltype="cf_sql_integer">, 
          <cfqueryparam value="#recordsPerPage#" cfsqltype="cf_sql_integer">
</cfquery>
    <cfreturn qryPendingUsers>
</cffunction>--->

<!-- Query for Approved Users -->
<!--- <cffunction  name="getApprovedUsers"  access="public" returnType="query"> 
<cfquery name="qryApprovedUsers" datasource="#datasource#">
    SELECT id, str_name, str_phone, str_username, cbr_status
    FROM tbl_users
    WHERE cbr_status = 'A' AND int_user_role_id = 2
    <cfif structKeyExists(form, "str_keyword") AND len(trim(form.str_keyword)) GT 0>
        AND (
            str_name LIKE <cfqueryparam value="%#trim(form.str_keyword)#%" cfsqltype="cf_sql_varchar">
            OR str_phone LIKE <cfqueryparam value="%#trim(form.str_keyword)#%" cfsqltype="cf_sql_varchar">
        )
    </cfif>
    ORDER BY id
    LIMIT <cfqueryparam value="#startRecord#" cfsqltype="cf_sql_integer">, 
          <cfqueryparam value="#recordsPerPage#" cfsqltype="cf_sql_integer">
</cfquery>
<cfreturn qryApprovedUsers>
</cffunction>
<cfset getApprovedUsers()>--->