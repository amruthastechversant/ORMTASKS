<!--- <cfif structKeyExists(URL, "currentPage")>
    <cfset currentPage = val(URL.currentPage)>
<cfelseif structKeyExists(form, "currentPage")>
    <cfset currentPage = val(form.currentPage)>
<cfelse>
    <cfset currentPage = 1>
</cfif>
<cfset recordsPerPage =4>
<!--- Calculate the offset for pagination --->
<cfset offset = (currentPage - 1) * recordsPerPage> --->
<!--- Fetch tasks with pagination --->
<cfparam name="form.currentPage" default="1">
<cfparam name="form.recordsPerPage" default="4">
<cfset variables.currentPage = val(structKeyExists(URL, "currentPage") ? URL.currentPage : form.currentPage)>
<cfset variables.recordsPerPage = val(form.recordsPerPage)>
<cfset variables.offset = (currentPage - 1) * recordsPerPage>

<cfif structKeyExists(form, "str_keyword") AND len(trim(form.str_keyword)) GT 0>
    <cfset keyword =  "%" & trim(form.str_keyword) & "%">
    <cfset tasks = ormExecuteQuery(
    "FROM Tasks t WHERE t.str_task_name LIKE :keyword OR t.int_task_status.status LIKE :keyword ORDER BY t.int_task_priority ASC",
    { keyword = keyword }, 
    { maxResults = recordsPerPage, offset = offset }
)>
    <cfset totalTasks =arrayLen(tasks)>
 
    <cfelse>
    <cfset tasks=entityLoad("Tasks", {}, "int_task_priority ASC", {maxresults=recordsPerPage, offset=offset})>
    <cfset totalTasks = ormExecuteQuery("select count(id) from Tasks", true)>
</cfif>
<cfset totalPages = ceiling(totalTasks / recordsPerPage)>
<cffunction  name="getworkinghours" access="public" returntype="any">

    <cfargument  name="taskID" type="integer">  
    
    <cfset taskTimes = EntityLoad("TaskTime", {"int_task_id" = taskID})>
    
    <cfset totalWorkingHours = 0>
    <cfloop array="#taskTimes#" index="timeLog">
        <cfset totalWorkingHours = totalWorkingHours+timeLog.getWorking_hours()>
    </cfloop>

   <cfreturn totalWorkingHours>
</cffunction>
<cffunction  name="getTaskLogs" access="public" returntype="any">
    <cfargument  name="taskID" type="integer"> 
    <cfset taskTimes = EntityLoad("TaskTime", {"int_task_id" = taskID})>
    <cfreturn taskTimes>
</cffunction>
<!---<cfdump  var="#Tasks[1].getInt_task_priority().getId()#">--->
<cffunction name="getTodayTask" returnType="array">
    <cfif structKeyExists(form, "str_keyword") AND len(trim(form.str_keyword)) GT 0>
        <cfset keyword = trim(form.str_keyword)>
    <cfelse>
        <cfset keyword = "">
    </cfif>
    <cfset queryFilters = structNew()>
    <cfset queryFilters["dt_task_due_date"] = Now()>
    <cfif len(keyword) GT 0>
        <cfset queryFilters["str_task_name"] = "LIKE '%#keyword#%'">
        <cfset queryFilters["s.status"] = "LIKE '%#keyword#%'">
    </cfif>
    <cfset tasks = EntityLoad("Tasks", queryFilters, "int_task_priority ASC, dt_task_due_date ASC")>
    <cfreturn tasks>
</cffunction>
<cffunction name="pendingTask" access="public" returnType="array" output="false">
    <cfset var tasks = []>
    <cfset status = entityLoad("Status", 1, true)>
    <cfset var filters = { int_task_status = 1 }>
    
    <cfset var keyword = "" />

    <cfif structKeyExists(form, "str_keyword") AND len(trim(form.str_keyword)) GT 0>
        <cfset keyword = "%" & trim(form.str_keyword) & "%">
    </cfif>
   
   <cfset tasks = entityLoad("Tasks", { int_task_status = status })>
  
    <cfif len(keyword)>
        <cfset tasks = arrayFilter(tasks, function(task) {
            return findNoCase(trim(form.str_keyword), task.getStr_task_name()) OR 
                   findNoCase(trim(form.str_keyword), task.getStr_task_description());
        })>
    </cfif>

    <cfreturn tasks>
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

    <cfset task = EntityLoadByPK("Tasks", arguments.int_task_id)>
    <cfset taskLog = EntityLoad("TaskTime", {"int_task_id" = arguments.int_task_id})>
    <cfset totalWorkingHours = 0>
    <cfloop array="#taskLog#" index="log">
        <cfset totalWorkingHours = totalWorkingHours + log.getWorking_hours()>
    </cfloop>

    <cfset totalWorkingHours = totalWorkingHours + arguments.working_hours>

    <cfif totalWorkingHours GT task.getEstimate_hours()>
        <cfset result.alertMessage = "Working hours exceeded estimated hours">
    </cfif>

    <cfset result.queryData = taskLog>

    <cfreturn result>
</cffunction>



   

<!--- <cfset getResults()> --->






