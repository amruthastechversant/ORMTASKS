

<cffunction name="checkPermissons" returnType="void">
    <cfif NOT structKeyExists(session, "user_id") OR session.user_id EQ "" OR session.user_id IS 0>
        <cflocation url="userlogin.cfm" addtoken="false">
    </cfif>
  
</cffunction>

<cffunction  name="setDefaultValues" access="public" returnType="void">
    <cfset variables.str_task_name="">
    <cfset variables.str_task_description="">   
    <cfset variables.dt_task_due_date="">
    <cfset variables.error_msg="">
    <cfset variables.int_task_status="">
    <cfset variables.int_task_priority="">
    <cfset variables.is_recurring="">
    <cfset variables.recurrence_type="">
    <cfset variables.recurrence_end_date="">
    <cfset variables.estimate_hours="">
    <cfset variables.datasource="dsn_addressbook">
    
    <cfset getpriority()>
    <cfset getstatus()>
</cffunction>
<cffunction  name="getpriority" access="public" returnType="void">
    <cfquery name= "variables.qryGetPriorityOptions" datasource="#variables.datasource#">
        select id,priority as priority from priority
   </cfquery>
</cffunction>

<cffunction  name="getstatus" access="public" returnType="void">
    <cfquery name="variables.qryGetStatusOptions" datasource="#variables.datasource#">
        select id,status as status from status
    </cfquery>
</cffunction>


<cffunction name="loadTaskDetails" access="public" returnType="void">
    <cfif structKeyExists(url, "userId")>
        <cfset userId = url.userId>
        <cfset datasource = "dsn_addressbook">
        <cfquery name="contactDetails" datasource="#datasource#">
            SELECT int_task_id,int_user_id,str_task_name,str_task_description,int_task_priority,dt_task_due_date,int_task_status,created_at,is_recurring,recurrence_type,recurrence_end_date,estimate_hours
            FROM tasks
            WHERE int_task_id = <cfqueryparam value="#userId#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfquery name="getstatus" datasource="#datasource#">
            SELECT status.status
            FROM tasks
            JOIN status
            ON tasks.int_task_status = status.id
            WHERE tasks.int_task_status = <cfqueryparam value="#url.userId#" cfsqltype="cf_sql_integer">
        </cfquery>

       <cfquery name="getpriority" datasource="#datasource#">
            SELECT  priority.priority
            FROM tasks
            JOIN priority ON tasks.int_task_priority = priority.id
            WHERE tasks.int_task_id = <cfqueryparam value="#url.userId#" cfsqltype="cf_sql_integer">
        </cfquery>

        <cfif contactDetails.recordCount GT 0>
            <cfset variables.str_task_name=contactDetails.str_task_name>
            <cfset variables.str_task_description=contactDetails.str_task_description>   
            <cfset variables.dt_task_due_date=contactDetails.dt_task_due_date>
            <cfset variables.int_task_status=contactDetails.int_task_status>
            <cfset variables.int_task_priority=contactDetails.int_task_priority>
            <cfset variables.is_recurring = contactDetails.is_recurring> 
            <cfset  variables.recurrence_type=contactDetails.recurrence_type>
            <cfset variables.recurrence_end_date=contactDetails.recurrence_end_date>
            <cfset variables.estimate_hours=contactDetails.estimate_hours>
        </cfif>
       
       
    </cfif>
</cffunction>


<cffunction  name="getTasks" access="public" returnType="void">
        <cfset variables.str_task_name=form.str_task_name>
        <cfset variables.str_task_description=form.str_task_description>
        <cfset variables.dt_task_due_date=form.dt_task_due_date>
  
        <cfif structKeyExists(form, "int_task_priority")>
            <cfset variables.int_task_priority=form.int_task_priority>
        <cfelse>
           
            <cfset variables.int_task_priority="">
        </cfif>

        <cfif structKeyExists(form, "int_task_status")>
            <cfset variables.int_task_status=form.int_task_status>
        <cfelse>
            <cfset variables.int_task_status="">
        </cfif>

        <cfif structKeyExists(form, "is_recurring")>
            <cfset variables.is_recurring=(form.is_recurring EQ "true")>
        <cfelse>
            <cfset variables.is_recurring=false>
        </cfif>

        <cfif structKeyExists(form, "recurrence_type")>
            <cfset variables.recurrence_type=form.recurrence_type>
        <cfelse>
            <cfset variables.recurrence_type="">
        </cfif>

        <cfif structKeyExists(form, "recurrence_end_date")>
            <cfset variables.recurrence_end_date=form.recurrence_end_date>
        <cfelse>
            <cfset variables.recurrence_end_date="">
        </cfif>

        <cfif structKeyExists(form, "estimate_hours")AND ISNUMERIC(form.estimate_hours)>
            <cfset variables.estimate_hours=javacast("int", form.estimate_hours)>
        <cfelse>
            <cfset variables.estimate_hours=0>
        </cfif>
</cffunction>


<cffunction name="validateFormValues" returnType="string">
    <cfargument name="taskname" type="string">
    <cfargument name="description" type="string">
    <cfargument name="priority" type="string">
    <cfargument  name="status" type="string">
    <cfargument name="duedate" type="string">
    <cfargument name="recurrence_type" type="string">
    <cfargument  name="recurrence_end_date" type="string">
    <cfargument name="estimate_hours" type="float">
    

    <cfset var error_msg = ''>

    <cfif len(arguments.taskname) EQ 0>
        <cfset error_msg &= "enter taskname.<br>">
    </cfif>

    <cfif len(arguments.description) EQ 0>
        <cfset error_msg &= "enter description.<br>">
    </cfif>

    <cfif len(arguments.priority) EQ 0 OR NOT isNumeric(arguments.priority)>
        <cfset error_msg &= "Select a valid priority.<br>">
    </cfif>
    
    <!-- Validate Status -->
    <cfif len(arguments.status) EQ 0 OR NOT isNumeric(arguments.status)>
        <cfset error_msg &= "Select a valid status.<br>">
    </cfif>

    <cfif len(arguments.duedate) EQ 0 OR NOT isDate(arguments.duedate)>
        <cfset error_msg &= "Select a valid due date.<br>">
    </cfif>

    <cfif NOT isNumeric(arguments.estimate_hours)  OR arguments.estimate_hours LT 0>
        <cfset error_msg &="enter valid non negetive number for estimate hours.<br>">
    </cfif>

    <cfreturn error_msg>
</cffunction>
  

<cffunction  name="addTask" access="public" returnType="struct">
    <cfargument  name="int_user_id" type="numeric">
    <cfargument  name="str_task_name" type="string">
    <cfargument  name="str_task_description" type="string">
    <cfargument  name="int_task_priority" type="string">
    <cfargument name="int_task_status" type="string"> 
    <cfargument  name="dt_task_due_date" type="string">
    <cfargument  name="is_recurring" type="boolean">
    <cfargument name="recurrence_type" type="string">
    <cfargument  name="recurrence_end_date" type="string">
    <cfargument  name="estimate_hours" type="float">
<cfset var structResponse = {"msg":'Successfully Submitted',"status":true}>

    <cfif structKeyExists(url,"userId" )>
    <cfquery datasource="#datasource#">
            UPDATE tasks
            SET str_task_name = <cfqueryparam value="#arguments.str_task_name#" cfsqltype="cf_sql_varchar">,
                str_task_description = <cfqueryparam value="#arguments.str_task_description#" cfsqltype="cf_sql_varchar">,
                int_task_priority = <cfqueryparam value="#arguments.int_task_priority#" cfsqltype="cf_sql_integer">,
                int_task_status = <cfqueryparam value="#arguments.int_task_status#" cfsqltype="cf_sql_integer">,
                dt_task_due_date = <cfqueryparam value="#arguments.dt_task_due_date#" cfsqltype="cf_sql_date">,
                is_recurring=<cfqueryparam value="#arguments.is_recurring#" cfsqltype="cf_sql_integer">,
                recurrence_type=<cfqueryparam value="#arguments.recurrence_type#" cfsqltype="cf_sql_varchar">,
                recurrence_end_date=<cfqueryparam value="#arguments.recurrence_end_date#" cfsqltype="cf_sql_date">,
                estimate_hours=<cfqueryparam value="#arguments.estimate_hours#" cfsqltype="cf_sql_float">
                
            WHERE int_task_id =#url.userId#
        </cfquery>  
      <cfset structResponse.msg = "Contact updated successfully.">
       
    <cfelse>
    <cftry>
    <cfquery name="addTask" datasource="dsn_addressbook">
        INSERT INTO tasks(int_user_id,str_task_name,str_task_description,int_task_priority,dt_task_due_date,int_task_status,is_recurring,recurrence_type,recurrence_end_date,estimate_hours,created_at)
        VALUES(
            <cfqueryparam value="#arguments.int_user_id#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#arguments.str_task_name#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#arguments.str_task_description#" cfsqltype="cf_sql_varchar">,
            <cfqueryparam value="#arguments.int_task_priority#" cfsqltype="cf_sql_integer">,
            <cfqueryparam value="#arguments.dt_task_due_date#" cfsqltype="cf_sql_date">,
             <cfqueryparam value="#arguments.int_task_status#" cfsqltype="cf_sql_integer">,
             <cfqueryparam value="#arguments.is_recurring#" cfsqltype="cf_sql_integer">,
             <cfqueryparam value="#arguments.recurrence_type#" cfsqltype="cf_sql_varchar">,
             <cfqueryparam value="#arguments.recurrence_end_date#" cfsqltype="cf_sql_date">,
             <cfqueryparam value="#arguments.estimate_hours#" cfsqltype="cf_sql_float">,
              <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">

        )
    </cfquery>
       
        <cfcatch>
        <cfoutput>
            <p>Error occurred: #cfcatch.message#</p>
            <p>Error Code: #cfcatch.errorCode#</p>
            <p>Details: #cfcatch.detail#</p>
            <p>Stack Trace: #cfcatch.stackTrace#</p>
            </cfoutput>
        </cfcatch>
    </cftry>

   
    </cfif>
   
         <cfreturn structResponse>
    
</cffunction>



<cffunction  name="generateReccuringTask" access="public" returnType="void">
    <cfset datasource="dsn_addressbook">
    <cfquery name="qryReccuringTask" datasource="#datasource#">
        select int_user_id,str_task_name,str_task_description,int_task_priority,dt_task_due_date,int_task_status,recurrence_type,recurrence_end_date,estimate_hours
        from tasks
        where is_recurring=1 AND
        dt_task_due_date<=<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date"> AND 
        (recurrence_end_date IS NULL OR recurrence_end_date >=<cfqueryparam value="#Now()#" cfsqltype="cf_sql_date"> )
    </cfquery>
 

        <cfloop query="qryReccuringTask">
            <cfset var newDueDate=""/>
            <cfif qryReccuringTask.recurrence_type EQ "daily">
                <cfset newDueDate=dateAdd("d", 1, dt_task_due_date )>
            <cfelseif qryReccuringTask.recurrence_type EQ "weekly">
                <cfset newDueDate=dateAdd("ww", 1, dt_task_due_date)>
            <cfelseif  qryReccuringTask.recurrence_type EQ "monthly">
                <cfset newDueDate=dateAdd("m",1 , dt_task_due_date)>
            </cfif>
      
        
       
         </cfloop>
      
</cffunction>

<!---taskupdate--->
<cffunction  name="updateTasks" access="public" returnType="void">
    <cfargument  name="int_task_id" type="numeric" required="true">
    <cfargument  name="int_task_status" type="string">
    <cfargument  name="str_task_description" type="string">
    <cfargument  name="int_task_priority" type="string">
    <cfargument  name="dt_task_due_date" type="string">
    

    <cfquery datasource="dsn_addressbook">
        UPDATE tasks
        SET int_task_status =<cfqueryparam value="#arguments.int_task_status#" cfsqltype="cf_sql_integer">,
            str_task_description = <cfqueryparam value="#arguments.str_task_description#" cfsqltype="cf_sql_varchar">,
            int_task_priority= <cfqueryparam value="#arguments.int_task_priority#" cfsqltype="cf_sql_integer">,
            dt_task_due_date=<cfqueryparam value="#arguments.dt_task_due_date#" cfsqltype="cf_sql_date">
        where  int_task_id=<cfqueryparam value="#arguments.int_task_id#" cfsqltype="cf_sql_integer">
    </cfquery>
</cffunction>

<cffunction  name="deleteTask" access="public" returnType="void">
    <cfargument  name="int_task_id" type="numeric" required="true">
    <cfquery datasource="dsn_addressbook">
        delete tasks
        where int_task_id=<cfqueryparam value="#arguments.int_task_id#" cfsqltype="cf_sql_integer">
    </cfquery>
</cffunction>

<cfset checkPermissons()>
<cfset generateReccuringTask()>
<cfset setDefaultValues()>
<cfset loadTaskDetails()>


<cfif structKeyExists(form, "saveTask")>
    <cfset getTasks()>
    <cfset variables.error_msg=validateFormValues( 
           
            taskname=variables.str_task_name,
            description=variables.str_task_description,
            priority=variables.int_task_priority,
            status = variables.int_task_status,
            duedate=variables.dt_task_due_date,
            estimate_hours=variables.estimate_hours
            
    )>
    <cfif len(variables.error_msg) EQ 0>
           <cfset variables.response=addTask(
            
             int_user_id = session.user_id,
            str_task_name = variables.str_task_name,
            str_task_description=variables.str_task_description,
            int_task_priority = variables.int_task_priority,
            int_task_status = variables.int_task_status,
            dt_task_due_date = variables.dt_task_due_date,
            is_recurring=variables.is_recurring,
            recurrence_type=variables.recurrence_type,
            recurrence_end_date=variables.recurrence_end_date,
            estimate_hours=variables.estimate_hours
           )>
      
           <cfset loadTaskDetails()>
    </cfif>
   
</cfif>

