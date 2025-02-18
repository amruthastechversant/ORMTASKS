

<cffunction name="checkPermissons" returnType="void">
    <cfif NOT structKeyExists(session, "user_id") OR session.user_id EQ "" OR session.user_id IS 0>
        <cflocation url="userlogin.cfm" addtoken="false">
    </cfif>
  
</cffunction>

<cfset variables.userId = 0>
<cfif structKeyExists(url, "userId") AND isNumeric(url.userId)>
    <cfset userId = url.userId>
<cfelse>
    <cfset userId = 0> 
</cfif>
 <cfset tasks=entityLoad("Tasks")>

<cffunction  name="setDefaultValues" access="public" returnType="void">
    <cfset variables.str_task_name="">
    <cfset variables.str_task_description="">   
    <cfset variables.dt_task_due_date="">
    <cfset variables.error_msg=[]>
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
<cffunction  name="getpriority" access="public" returnType="any">
   <cfset priorityList=entityLoad("priority")>
</cffunction>

<cffunction  name="getstatus" access="public" returnType="void">
    <cfset statusList=entityLoad("status")>
</cffunction>

<cffunction  name="contactDetails" access="public" returntype="any">
    <cfargument  name="userId" type="numeric">
    <cfset var task=entityLoad("Tasks",{"int_task_id":userId})>
    <cfreturn task>
</cffunction>
<!---  
<cffunction  name="getstatus" access="public" returntype="any">
<cfquery name="getstatus" datasource="#datasource#">
            SELECT status.status
            FROM tasks
            JOIN status
            ON tasks.int_task_status = status.id
            WHERE tasks.int_task_status = <cfqueryparam value="#url.userId#" cfsqltype="cf_sql_integer">
</cfquery>
</cffunction>
<cffunction  name="joinstatus"  access="public" returntype="any">

<cfquery name="joinstatus" datasource="#datasource#">
            SELECT s.status
            FROM tasks t
            JOIN status
            ON tasks.int_task_status = status.id
            WHERE tasks.int_task_status = <cfqueryparam value="#userId#" cfsqltype="cf_sql_integer">
</cfquery>
</cffunction>

<cffunction  name="joinpriority" access="public" returntype="any">
<cfquery name="joinpriority" datasource="#datasource#">
            SELECT  priority.priority
            FROM tasks
            JOIN priority ON tasks.int_task_priority = priority.id
            WHERE tasks.int_task_id = <cfqueryparam value="#userId#" cfsqltype="cf_sql_integer">
</cfquery>
</cffunction>
--->
<cffunction  name="getFormValues" access="public" returnType="void">
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
<cffunction name="validateFormValues" returnType="any">
    <cfargument name="taskname" type="string">
    <cfargument name="description" type="string">
    <cfargument name="priority" type="string">
    <cfargument  name="status" type="string">
    <cfargument name="duedate" type="string">
    <cfargument name="recurrence_type" type="string">
    <cfargument  name="recurrence_end_date" type="string">
    <cfargument name="estimate_hours" type="float">
    

    <cfset var error_msg = []>


    
    <cfif len(arguments.taskname) EQ 0>
    <cfset arrayAppend(error_msg, "Enter task name.")>
    </cfif>

    <cfif len(arguments.description) EQ 0>
        <cfset arrayAppend(error_msg, "enter description.")>
    </cfif>

    <cfif len(arguments.priority) EQ 0 OR NOT isNumeric(arguments.priority)>
        <cfset  arrayAppend(error_msg,"Select a valid priority.")>
    </cfif>
    
    <!-- Validate Status -->
    <cfif len(arguments.status) EQ 0 OR NOT isNumeric(arguments.status)>
        <cfset  arrayAppend(error_msg,"Select a valid status.")>
    </cfif>

    <cfif len(arguments.duedate) EQ 0 OR NOT isDate(arguments.duedate)>
        <cfset  arrayAppend(error_msg,"Select a valid due date.")>
    </cfif>

    <cfif NOT isNumeric(arguments.estimate_hours)  OR arguments.estimate_hours LT 0>
        <cfset  arrayAppend(error_msg,"enter valid non negetive number for estimate hours.")>
    </cfif>

    <cfreturn error_msg>

</cffunction>
  
  

<cffunction name="loadTaskDetails" access="public" returnType="void">
        <cfif variables.userId GT 0>
            <cfset variables.task = entityLoadByPK("Tasks", variables.userId)>
            <cfif isDefined("variables.task")>
                <cfset variables.str_task_name = variables.task.getStr_task_name()>
                <cfset variables.str_task_description = variables.task.getStr_task_description()>   
                <cfset variables.dt_task_due_date = variables.task.getDt_task_due_date()>
                <cfset variables.int_task_status = variables.task.getInt_task_status().getId()> 
                <cfset variables.int_task_priority = variables.task.getInt_task_priority().getId()> 
                <cfset variables.is_recurring = variables.task.getIs_recurring()> 
                <cfset variables.recurrence_type = variables.task.getRecurrence_type()> 
                <cfset variables.recurrence_end_date = variables.task.getRecurrence_end_date()> 
                <cfset variables.estimate_hours = variables.task.getEstimate_hours()> 
            </cfif>
        </cfif>
    </cffunction>

    <cffunction name="addOrUpdateTask" access="public" returnType="any">
        <cfargument name="taskData"   type="struct" required="true">
        <cfset var response = {"msg": "Successfully Submitted", "status": true}>
        <cfdump  var="#arguments.taskData#" abort>
        <cfif structKeyExists(taskData, "int_task_id") AND taskData.int_task_id GT 0>
            <cfset var task = entityLoadByPK("Tasks", taskData.int_task_id)>
        <cfelse>
            <cfset var task = entityNew("Tasks")>
            <cfset task.setCreated_at(now())>
        </cfif>

        <cfset task.setInt_user_id(session.user_id)>
        <cfset task.setStr_task_name(taskData.str_task_name)>
        <cfset task.setStr_task_description(taskData.str_task_description)>
        <cfset task.setDt_task_due_date(taskData.dt_task_due_date)>
        <cfset task.setIs_recurring(taskData.is_recurring)>
        <cfset task.setRecurrence_type(taskData.recurrence_type)>
        <cfset task.setRecurrence_end_date(taskData.recurrence_end_date)>
        <cfset task.setEstimate_hours(taskData.estimate_hours)>
        
        <cfset task.setInt_task_priority(entityLoadByPK("Priority", taskData.int_task_priority))>
        <cfset task.setInt_task_status(entityLoadByPK("Status", taskData.int_task_status))>
        
        <cftransaction>
            <cftry>
                <cfset entitySave(task)>
                <cfcatch>
                    <cfset response.msg = "Error: " & cfcatch.message>
                    <cfset response.status = false>
                </cfcatch>
            </cftry>
        </cftransaction>
        
        <cfreturn response>
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

<!---taskupdate
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
</cffunction>--->

<cffunction  name="deleteTask" access="public" returnType="void">
    <cfargument  name="int_task_id" type="numeric" required="true">
    <cfset var task=entityLoadByPK("Tasks", arguments.int_task_id)>
    <cfif isDefined(task)>
        <cfset entityDelete(task)>
    </cfif>
</cffunction>

<cfset checkPermissons()>
<cfset generateReccuringTask()>
<cfset setDefaultValues()>
<cfset loadTaskDetails()>
<cfset contactDetails()>



<cfif structKeyExists(form, "saveTask")>
    <cfset getFormValues()>
    <cfset variables.error_msg= validateFormValues(

        int_task_id=variables.userId,
        taskname=variables.str_task_name,
        description=variables.str_task_description,
        priority=variables.int_task_priority,
        status=variables.int_task_status,
        duedate=variables.dt_task_due_date,
        estimate_hours=variables.estimate_hours
   
    )>
   <cfif arrayLen(variables.error_msg) EQ  0> 
    <cfset variables.response= saveTask(
        
        int_task_id=variables.userId,
        taskname=variables.str_task_name,
        description=variables.str_task_description,
        priority=variables.int_task_priority,
        status=variables.int_task_status,
        duedate=variables.dt_task_due_date,
        estimate_hours=variables.estimate_hours  
    )>

  
    <cfset loadTaskDetails()>
    </cfif>
</cfif>

           
            


   
   


