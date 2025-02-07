<cfsetting enablecfoutputonly="true">
<cfcontent type="application/json">

<cftry>
    <cfparam name="url.int_task_id" type="numeric" default="0">
    
    <!-- Fetch Task Logs -->
    <cfset logs = entityLoad("TaskTime", {int_task_id = url.int_task_id})>

    <!-- Prepare JSON Response -->
    <cfset logData = []>
    <cfloop array="#logs#" index="log">
        <cfset arrayAppend(logData, {
            date: dateFormat(log.getDate(), "yyyy-mm-dd"),
            working_hours: log.getWorking_hours(),
            comments: log.getStr_comments()
        })>
    </cfloop>

    <cfoutput>#serializeJSON({success: true, logs: logData})#</cfoutput>

    <cfcatch>
        <cfoutput>#serializeJSON({success: false, message: cfcatch.message})#</cfoutput>
    </cfcatch>
</cftry>
