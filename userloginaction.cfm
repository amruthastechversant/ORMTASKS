
    <!--- Simple validation for empty fields --->
<cffunction  name="setDefaultValues" access="public" returnType="void">
    <cfset session.error_msg="">
</cffunction>

<cffunction name="getFormValues" access="public" returnType="void">
    <cfargument name="username" type="string" required="true">
    <cfargument name="password" type="string" required="true">
    
    <cfif structKeyExists(form, "login")>
        <cfset datasource = "dsn_addressbook">
        <cfquery name="qryUser" datasource="#datasource#">
            SELECT u.id, u.str_name, u.str_phone, u.str_username, r.str_user_role
            FROM tbl_users AS u
            INNER JOIN tbl_user_roles AS r
            ON u.int_user_role_id = r.id
            WHERE u.str_username = <cfqueryparam value="#arguments.username#" cfsqltype="cf_sql_varchar">
              AND u.str_password = <cfqueryparam value="#arguments.password#" cfsqltype="cf_sql_varchar">
              AND u.cbr_status = 'A'
              AND r.str_user_role = 'user'
        </cfquery>

        <cfif qryUser.recordCount>
            <cfset session.user_id = qryUser.id>
            <cfset session.role = qryUser.str_user_role>
            <cfset session.str_username = qryUser.str_username>
            <cflocation url="addtask.cfm">
        <cfelse>
            <cfset session.error_msg = "Invalid username and password">
        </cfif>
    </cfif>
</cffunction>
<cfset  setDefaultValues()>
<cfif structKeyExists(form, "login")>
    <cfset getFormValues(username=form.username, password=form.password)>
</cfif>
