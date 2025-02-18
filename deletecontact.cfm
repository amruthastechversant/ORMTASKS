
<cffunction  name="deleteContact" access="public" returnType="void">


<!-- Get the contactId from the URL -->
<cfset userId = val(URL.userId)>

<!-- Ensure the contactId is valid -->
<cfif userId EQ 0 OR NOT isNumeric(userId)>
    <cfset errorMessage = "Invalid contact ID.">
    <cfoutput>#errorMessage#</cfoutput>
    <cflocation url="usertaskboard.cfm" addtoken="false">
</cfif>

<!--- Perform the deletion 
<cfquery name="deleteContact" datasource="dsn_addressbook">
--     DELETE FROM tasks
--     WHERE int_task_id = <cfqueryparam value="#userId#" cfsqltype="cf_sql_integer">
-- </cfquery>--->


<cffunction  name="deleteContact" access="public" returnType="void">
<cfargument  name="int_task_id" type="numeric">
    <cfset var contact=entityLoad("Tasks",arguments.int_task_id)>
    <cfif isDefined(contact)>
        <cfset entityDelete(contact)>
    </cfif>

</cffunction>
<cfset successMessage = "Contact deleted successfully.">
<cfoutput>#successMessage#</cfoutput>
<!-- Redirect back to the contact list page -->
<cflocation url="usertaskboard.cfm" addtoken="false">
</cffunction>
<cfset deleteContact()>