

<cfif structKeyExists(url, "action")>

    <cfif url.action EQ "add">
        <cfquery datasource="dsn_addressbook">
        INSERT INTO tasks(task_name,str_task_description,int_task_priority,dt_task_due_date)
        VALUES(
            <cfqueryparam value="#form.task_name#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.int_task_priority#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.int_task_status#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#form.dt_task_due_date#" cfsqltype="cf_sql_date">

        )
    </cfquery>
        <cflocation  url="userdashboard.cfm">

    <elseif url.action EQ "update">
        <cfquery datasource="dsn_addressbook">
            UPDATE tasks
            SET int_task_status =<cfqueryparam value="#form.int_task_status#" cfsqltype="cf_sql_varchar">,
            str_task_description = <cfqueryparam value="#form.str_task_description#" cfsqltype="cf_sql_varchar">
             where  task_id=<cfqueryparam value="#form.task_id#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cflocation  url="userdashboard.cfm">

    <elseif url.action EQ "delete">
        <cfquery datasource="dsn_addressbook">
             delete tasks
                where task_id=<cfqueryparam value="#url.task_id#" cfsqltype="cf_sql_integer">
        </cfquery>
        <cflocation  url="dashboard.cfm">

    </cfif>
</cfif>

<cfquery name="tasks" datasource="dsn_addressbook">
    SELECT int_task_id, str_task_name, int_task_priority, int_task_status, dt_task_due_date, created_at
    FROM tasks
    ORDER BY dt_task_due_date ASC, int_task_priority DESC
</cfquery>