<!-- Ensure the admin is logged in -->
<cfif NOT structKeyExists(session, "adminid") OR session.adminid EQ "" OR session.adminid IS 0>
    <cflocation url="../loginasadmin.cfm" addtoken="false">
</cfif>

<!-- Initialize Input -->
<cfparam name="form.id" default="">
<cfparam name="form.int_permission_id_list" default="">
<cfset datasource = "dsn_addressbook">

<!-- Validate and Set int_user_id -->
<cfif NOT isNumeric(form.id) OR val(form.id) EQ 0>
    <cflocation url="InvalidUserId" addtoken="false">
</cfif>
<cfset int_user_id = val(form.id)>


<!-- Prepare Permissions Array -->
<cfset permissions = []>
<cfif isArray(form.int_permission_id_list)>
    <cfset permissions = form.int_permission_id_list>
<cfelseif len(form.int_permission_id_list) GT 0>
    <cfset permissions = listToArray(form.int_permission_id_list)>
</cfif>



<!-- Function Definition -->
<cffunction name="updateUserPermissions" access="public" returnType="void" output="false">
    <cfargument name="int_user_id" type="numeric" required="true">
    <cfargument name="permissions" type="array" required="true">
    <cfargument name="datasource" type="string" required="true">

    <!-- Delete Existing Permissions -->
    <cfquery name="qryDeletePermission" datasource="#arguments.datasource#">
        DELETE FROM tbl_user_permissions
        WHERE int_user_id = <cfqueryparam value="#arguments.int_user_id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <!-- Insert New Permissions -->
    <cfif arrayLen(arguments.permissions) GT 0>
        <cfloop index="i" from="1" to="#arrayLen(arguments.permissions)#">
            <cfif len(arguments.permissions[i]) GT 0>
                <cfquery name="qryUserPermissions" datasource="#arguments.datasource#">
                    INSERT INTO tbl_user_permissions (int_user_id, int_permission_id)
                    VALUES (
                        <cfqueryparam value="#arguments.int_user_id#" cfsqltype="cf_sql_integer">,
                        <cfqueryparam value="#arguments.permissions[i]#" cfsqltype="cf_sql_varchar">
                    )
                </cfquery>
            </cfif>
        </cfloop>
    </cfif>
</cffunction>
<!-- Call the Function -->
<cfset updateUserPermissions(int_user_id=int_user_id, permissions=permissions, datasource=datasource)>

<!-- Redirect to Admin Dashboard -->
<cflocation url="admindashboard.cfm" addtoken="false">