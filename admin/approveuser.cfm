<cfif NOT structKeyExists(session, "adminid") OR session.adminid EQ "" OR session.adminid IS 0>
    <cflocation url="../loginasadmin.cfm" addtoken="false">
</cfif>

<cfparam name="form.id" default="0">
<cfset int_user_id = val(form.id)>

<!-- Validate user ID -->
<cfif NOT isNumeric(int_user_id) OR int_user_id EQ 0>
    <cflocation url="InvalidUserId.cfm" addtoken="false">
</cfif>

<cfparam name="form.int_permission_id_list" default="">
<cfset selectedPermissions = []>

<!-- Convert selected permissions to an array -->
<cfif len(form.int_permission_id_list) GT 0>
    <cfset selectedPermissions = isArray(form.int_permission_id_list) ? form.int_permission_id_list : listToArray(form.int_permission_id_list, ",")>
</cfif>

<!-- Check if permissions are valid -->
<cfif arrayLen(selectedPermissions) GT 0>
    <!-- Ensure permissions exist in the database -->
    <cfquery name="qryPermissions" datasource="dsn_addressbook">
        SELECT int_permission_id
        FROM tbl_permissions
        WHERE int_permission_id IN (<cfqueryparam value="#arrayToList(selectedPermissions)#" cfsqltype="cf_sql_integer">)
    </cfquery>

    <!-- Loop through valid permissions and update user permissions -->
    <cfif qryPermissions.recordCount GT 0>
        <!-- Remove existing permissions for the user -->
        <cfquery datasource="dsn_addressbook">
            DELETE FROM tbl_user_permissions
            WHERE int_user_id = <cfqueryparam value="#int_user_id#" cfsqltype="cf_sql_integer">
        </cfquery>

        <!-- Insert new permissions -->
        <cfloop query="qryPermissions">
            <cfquery datasource="dsn_addressbook">
                INSERT INTO tbl_user_permissions (int_user_id, int_permission_id)
                VALUES (
                    <cfqueryparam value="#int_user_id#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#qryPermissions.int_permission_id#" cfsqltype="cf_sql_integer">
                )
            </cfquery>
        </cfloop>
    </cfif>
</cfif>

<!-- Approve the user -->
<cfquery datasource="dsn_addressbook">
    UPDATE tbl_users
    SET cbr_status = 'A'
    WHERE Id = <cfqueryparam value="#int_user_id#" cfsqltype="cf_sql_integer">
</cfquery>

<!-- Confirmation message -->
<cfoutput>
    <p class="text-success">User approved and permissions updated successfully.</p>
</cfoutput>

<!-- Redirect to the admin dashboard -->
<cflocation url="admindashboard.cfm" addtoken="false">
