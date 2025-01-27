<cfset datasource="dsn_addressbook">
<!---pagination--->
<cfparam name="form.currentPage" default="1">
<cfparam name="form.recordsPerPage" default="5">
<cfset currentPage = val(structKeyExists(URL, "currentPage") ? URL.currentPage : form.currentPage)>
<cfset recordsPerPage = val(form.recordsPerPage)>
<cfset startRecord = (currentPage - 1) * recordsPerPage>

<!---getting permission options from sqltable--->
<cffunction  name="getPermissionOptions" access="public" returnType="query">
<cfquery name="qryGetPermissionOptions" datasource="#datasource#">
    SELECT int_permission_id AS permissionid, str_permissions AS permission
    FROM tbl_permissions
</cfquery>
<cfreturn qryGetPermissionOptions>
</cffunction>

<cfset getPermissionOptions()>

<cffunction  name="getUserCounts" access="public" returnType="query">
<cfquery name="qryUserCounts" datasource="#datasource#">
    SELECT 
        (SELECT COUNT(id) FROM tbl_users WHERE cbr_status = 'P') AS totalPending,
        (SELECT COUNT(id) FROM tbl_users WHERE cbr_status = 'A') AS totalApproved
</cfquery>
    <cfreturn qryUserCounts> 
</cffunction>
<cfset getUserCounts()>
<cfset totalPendingRecords = qryUserCounts.totalPending>
<cfset totalApprovedRecords = qryUserCounts.totalApproved>
<cfset totalPendingPages = Ceiling(totalPendingRecords / recordsPerPage)>
<cfset totalApprovedPages = Ceiling(totalApprovedRecords / recordsPerPage)>

<!-- Query for Pending Users -->
<cffunction  name="getPendingUsers" access="public" returnType="query">
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
</cffunction>
<cfset getPendingUsers()>
<!-- Query for Approved Users -->
<cffunction  name="getApprovedUsers"  access="public" returnType="query">
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
<cfset getApprovedUsers()>