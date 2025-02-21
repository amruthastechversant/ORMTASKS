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


<cfset user=entityLoadByPK("user",int_user_id)>

<cfif not isObject(user)>
    <cflocation  url="InvalidUserId">
</cfif>

<cfset int_user_id=int(int_user_id)>
<cfset userentity=entityLoadByPK("user", int_user_id)>
<cfset existingPermissions = entityLoad("userpermissions", {user: userentity})>
<cfloop array="#existingPermissions#" index="perm">
    <cfset entityDelete(perm)>
</cfloop>

<cfloop array="#permissions#" index="permId">
    <cfset permission = entityLoadByPK("permissions", permId)>
    <cfif isObject(permission)>
        <cfset newPermission = entityNew("userpermissions")>
        <cfset newPermission.setUser(user)>
        <cfset newPermission.setPermission(permission)>
        <cfset entitySave(newPermission)>
    </cfif>
</cfloop>


<!-- Redirect to Admin Dashboard -->
<cflocation url="admindashboard.cfm" addtoken="false">