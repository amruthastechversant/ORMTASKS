<cfif NOT structKeyExists(session, "adminid") OR session.adminid EQ "" OR session.adminid IS 0>
    <cflocation url="../loginasadmin.cfm" addtoken="false">
</cfif>
<cfparam name="form.id" default="0">
<cfparam name="form.int_permission_id_list" default="">
<cfset int_user_id = val(form.id)>
<cfset selectedPermissions = []>
<cfset userEntity = entityLoadByPK("user", int_user_id)>
<cfset user=entityLoad("user")>
<!-- Validate user ID -->
<cfif NOT isNumeric(int_user_id) OR int_user_id EQ 0>
    <cflocation url="InvalidUserId.cfm" addtoken="false">
</cfif>

<cfif len(form.int_permission_id_list) GT 0>
    <cfset selectedPermissions = isArray(form.int_permission_id_list) ? form.int_permission_id_list : listToArray(form.int_permission_id_list, ",")>
</cfif>
<!-- Load user entity -->
<cfif NOT isnull(userEntity)>
    <!-- Remove existing permissions -->
    <cfset existingPermissions = entityLoad("userpermissions", {user = userEntity})>
    <cfloop array="#existingPermissions#" index="perm">
        <cfset entityDelete(perm)>
    </cfloop>
    
    <!-- Add new permissions -->
    <cfif arrayLen(selectedPermissions) GT 0>
        <cfloop array="#selectedPermissions#" index="permId">
            <cfset permissionEntity = entityLoadByPK("permissions", permId)>
            <cfif NOT isNull(permissionEntity)>
                <cfset newUserPermission = entityNew("userpermissions")>
                <cfset newUserPermission.setUser(userEntity)>
                <cfset newUserPermission.setPermission(permissionEntity)>
                <cfset entitySave(newUserPermission)>
            </cfif>
        </cfloop>
    </cfif>
    
    <!-- Approve user -->
    <cfset userEntity.setCbr_status("A")>
    <cfset entitySave(userEntity)>
</cfif>

<!-- Confirmation message -->
<cfoutput>
    <p class="text-success">User approved and permissions updated successfully.</p>
</cfoutput>

<!-- Redirect to the admin dashboard -->
<cflocation url="admindashboard.cfm" addtoken="false">
