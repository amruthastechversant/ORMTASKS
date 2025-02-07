<!-- Handle completed tasks -->
<cfif structKeyExists(form, "completedtasks")>
    <cfset completedTasks = form.completedtasks>
    <cfif isArray(completedTasks)>
        <cfloop array="#completedTasks#" index="int_task_id">
       
            <cfif isNumeric(int_task_id)>
                <cfquery datasource="dsn_addressbook">
                    UPDATE tasks
                    SET int_task_status = 3
                    WHERE int_task_id = <cfqueryparam value="#int_task_id#" cfsqltype="cf_sql_integer">
                </cfquery>
            </cfif>
        </cfloop>
   
    <cfelseif isNumeric(completedTasks)>
        <cfquery datasource="dsn_addressbook">
            UPDATE tasks
            SET int_task_status = 3
            WHERE int_task_id = <cfqueryparam value="#completedTasks#" cfsqltype="cf_sql_integer">
        </cfquery>
    </cfif>
</cfif>

<cfif structKeyExists(form, "userpendingtask")>
    <cfset userpendingtask = form.userpendingtask>

    <cfif isArray(userpendingtask)>
        <cfloop array="#userpendingtask#" index="int_task_id">
         
            <cfif isNumeric(int_task_id)>
                <cfquery datasource="dsn_addressbook">
                    UPDATE tasks
                    SET int_task_status = 3
                    WHERE int_task_id = <cfqueryparam value="#int_task_id#" cfsqltype="cf_sql_integer">
                </cfquery>
            </cfif>
        </cfloop>
 
    <cfelseif isNumeric(userpendingtask)>
        <cfquery datasource="dsn_addressbook">
            UPDATE tasks
            SET int_task_status = 3
            WHERE int_task_id = <cfqueryparam value="#userpendingtask#" cfsqltype="cf_sql_integer">
        </cfquery>
    </cfif>
</cfif>

<cfif  (structKeyExists(form, "completedtasks") OR structKeyExists(form, "userpendingtask"))>
  
    <cflocation url="admin/homepage.cfm" addtoken="false">
    
</cfif>
