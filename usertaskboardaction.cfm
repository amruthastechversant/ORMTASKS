


<cfset datasource="dsn_addressbook">
<!-- Function to retrieve total contact count -->
<cffunction name="qryContacts" access="public" returnType="numeric">
   
    <cfset totalCount=entityLoad("Task").count()>
    <cfreturn totalcount>
</cffunction>


<cffunction  name="getContacts" returnType="query">
    <cfargument  name="keyword" type="string">
    <cfargument  name="limit" type="numeric">
    <cfargument  name="offset" type="numeric">

    <cfset criteria=entityNew("Task").initcriteria()>
    <cfif len(trim(arguments.keyword))>
        <cfset criteria=criteria.orlike("str_keyword",% argument.keyword %)>
        <cfset criteria=criteria.orlike("atr_description",% argument.keyword %)>
    </cfif>
    <cfset tasks=criteria
                .sort("int_task_priority,dt_task_due_date") 
                .limit(arguments.limit)
                .offset(arguments.offset)
                .list()>
            <cfreturn tasks>

</cffunction>



<cffunction  name="workinghours" returnType="query">

        <cfargument  name="int_task_id" type="numeric">
        <cfargument  name="int_user_id" type="numeric">
        <cfargument  name="str_task_name" type="string">
        <cfargument  name="int_task_status" type="string">
        <cfargument  name="allotted_time" type="float">
    <cfset var datasource="dsn_addressbook">
    <cfquery name="workinghours" datasource="#datasource#">
        insert into task_time(int_task_id,int_user_id,str_task_name,int_task_status,allotted_time)
        values(
                <cfqueryparam value="#arguments.int_task_id#" cfsqltype="cf_sql_integer">,
                <cfqueryparam value="#arguments.int_user_id#" cfsqltype="cf_sql_integer">,
                 <cfqueryparam value="#arguments.str_task_name#" cfsqltype="cf_sql_varchar">,
                  <cfqueryparam value="#arguments.int_task_status#" cfsqltype="cf_sql_integer">,
                  <cfqueryparam value="#arguments.allotted_time#" cfsqltype="cf_sql_float">
        )
    </cfquery>
        <cfreturn workinghours>
</cffunction>


<cffunction name="getTodayTask" returnType="query">
    <cfset var qryResults = "">
    <cfset var datasource = "dsn_addressbook">
    <cfquery name="qryResults" datasource="#datasource#">
        SELECT 
            c.int_task_id,
            c.int_user_id,
            c.str_task_name, 
            c.str_task_description, 
            c.int_task_priority,
            c.dt_task_due_date, 
            c.int_task_status,
            s.status as task_status,
            c.created_at,
             c.is_recurring, 
        c.recurrence_type, 
        c.recurrence_end_date,
        c.estimate_hours,
            e.priority
        FROM 
            tasks AS c 
             JOIN  priority AS e 
             ON c.int_task_priority = e.id
       
            JOIN 
            status AS s ON c.int_task_status = s.status 
            where  CAST(c.dt_task_due_date AS DATE) = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_date">
          <cfif structKeyExists(form, "str_keyword") AND len(trim(form.str_keyword)) GT 0>
            AND (
                
                str_task_name LIKE <cfqueryparam value="%#trim(form.str_keyword)#%" cfsqltype="cf_sql_varchar">
                OR s.status LIKE <cfqueryparam value="%#trim(form.str_keyword)#%" cfsqltype="cf_sql_varchar">
            )
        </cfif> 
        ORDER BY 
            c.int_task_priority, c.dt_task_due_date
        LIMIT <cfqueryparam value="#recordsPerPage#" cfsqltype="cf_sql_integer"> 
        OFFSET <cfqueryparam value="#startRecord#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfreturn qryResults>
</cffunction>


<cffunction  name="pendingTask" access="public" returnType="query">
        <cfset var qryResult="">
        <cfset var datasource="dsn_addressbook">

        <cfquery name="qryResult" datasource="#datasource#">
                select int_task_id,int_user_id,str_task_name,str_task_description,int_task_priority,dt_task_due_date,int_task_status,created_at
                from tasks
                where int_task_status=1

                <cfif structKeyExists(form, "str_keyword") AND len(form.str_keyword) GT 0>
                    AND (
                        str_task_name LIKE <cfqueryparam value="%#trim(form.str_keyword)#%" cfsqltype="cf_sql_varchar">
                        OR str_task_description LIKE <cfqueryparam value="%#trim(form.str_keyword)#%" cfsqltype="cf_sql_varchar">
                    )

                    ORDER BY int_task_priority,dt_task_due_date

                </cfif>
        </cfquery>
            <cfreturn qryResult> 
</cffunction>




<cfparam name="url.userId" default="0">
<cfquery name="contactDetails" datasource="dsn_addressbook">
    SELECT int_task_id,int_user_id,str_task_name,str_task_description,int_task_priority,dt_task_due_date,int_task_status,is_recurring,recurrence_type,recurrence_end_date,created_at
    FROM tasks
    WHERE int_task_id  = <cfqueryparam value="#url.userId#" cfsqltype="cf_sql_integer">
</cfquery>


<cffunction name="setDefaultValues" access="public" returnType="void">
    <cfset datasource = "dsn_addressbook">
    <cfparam name="form.currentPage" default="1">
    <cfparam name="form.recordsPerPage" default="4">

    <!-- Determine the current page based on URL or form input -->
    <cfif structKeyExists(URL, "currentPage")>
        <cfset currentPage = val(URL.currentPage)>
    <cfelseif structKeyExists(form, "currentPage")>
        <cfset currentPage = val(form.currentPage)>
    <cfelse>
        <cfset currentPage = 1>
    </cfif>

    <!-- Set records per page and calculate starting record -->
    <cfset recordsPerPage = val(form.recordsPerPage)>
    <cfset startRecord = (currentPage - 1) * recordsPerPage>
    <cfset totalContacts = qryContacts()>
    <cfset totalPages = ceiling(totalContacts / recordsPerPage)>
</cffunction>


<cffunction  name="getResults" access="public" returnType="query">
<cfquery name="qryPendingStatus" datasource="#datasource#">
    SELECT int_task_id,str_task_name,str_task_description,dt_task_due_date,int_task_status
    FROM tasks
    WHERE  1=1
       
    <cfif structKeyExists(form, "str_keyword") AND len(trim(form.str_keyword)) GT 0>
        AND (
            
             str_task_name LIKE <cfqueryparam value="%#trim(form.str_keyword)#%" cfsqltype="cf_sql_varchar">
            OR CAST(int_task_status AS CHAR) LIKE <cfqueryparam value="%#trim(form.str_keyword)#%" cfsqltype="cf_sql_varchar">
        )
    </cfif>
    ORDER BY int_task_id
    LIMIT <cfqueryparam value="#startRecord#" cfsqltype="cf_sql_integer">, 
          <cfqueryparam value="#recordsPerPage#" cfsqltype="cf_sql_integer">
</cfquery>
    <cfreturn qryPendingStatus>
</cffunction>


<cffunction name="getDueDateAlert" output="false" returnType="string">
    <cfargument name="dueDate" type="date" required="true">
   



    <cfset var today = CreateDateTime(Year(Now()), Month(Now()), Day(Now()), 0, 0, 0)>
    <cfset var tomorrow = DateAdd("d", 1, today)>
    <cfset var alertMessage = "">


    <cfset var dueDateNormalized = CreateDateTime(Year(arguments.dueDate), Month(arguments.dueDate), Day(arguments.dueDate), 0, 0, 0)>

    <cfif DateCompare(dueDateNormalized, today) EQ 0>
        <cfset alertMessage = "Task Due Date is today">
    <cfelseif DateCompare(dueDateNormalized, tomorrow) EQ 0>
        <cfset alertMessage = "Task Due Date is tomorrow">
    </cfif>

    <cfreturn alertMessage>

    
   
</cffunction>
<cffunction name="taskhours" returnType="struct" access="public">
    <cfargument name="working_hours" type="float" required="true">
    <cfargument name="int_task_id" type="numeric" required="true">
    
  
    <cfset var result = {alertMessage = "", queryData = ""}>

    <cfquery name="qryTaskhours" datasource="#datasource#">
        SELECT 
            t.int_task_id,
            t.estimate_hours,
            COALESCE(SUM(TL.working_hours), 0) AS total_working_hours
        FROM tasks t
        LEFT JOIN task_log tl ON t.int_task_id = tl.int_task_id
        WHERE t.int_task_id = <cfqueryparam value="#arguments.int_task_id#" cfsqltype="cf_sql_integer">
        GROUP BY t.estimate_hours, t.int_task_id
    </cfquery>
    
    
    <cfif qryTaskhours.recordCount>
        <cfset var estimate_hours = qryTaskhours.estimate_hours>
        <cfset var total_working_hours = qryTaskhours.total_working_hours + arguments.working_hours>
        
        <cfif total_working_hours GT estimate_hours>
            <cfset result.alertMessage = "Working hours exceeded estimated hours">
        </cfif>
    </cfif>
    

    <cfset result.queryData = qryTaskhours>
    
    <cfreturn result>
</cffunction>


<cfset setDefaultValues()>
<cfset getResults()>
<cfset tasks=getContacts()>


