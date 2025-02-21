<cfcontent type="application/json; charset=UTF-8">
<cfsetting showdebugoutput="false">
<cftry>

   <cfset requestBody = toString( getHttpRequestData().content )>
    <cfset requestJson = DeserializeJSON(requestBody)>
    <cfset taskId=requestJson["taskId"]>
    <cfset getLogs = entityLoad("TaskTime", {int_task_id=taskId})>
    <cfset result = []>
    <cfloop array="#getLogs#" index="log">
        <cfset arrayAppend(result, {
            "comments": log.getStr_comments(),
            "date": dateFormat(log.getDate(), 'yyyy-MM-dd') & " " & timeFormat(log.getDate(), 'HH:mm:ss')
        })>
        
    </cfloop>
    
    <cfset response = {
        "success": true,
        "logs": result
    }>

    <cfoutput>#SerializeJSON(response)#</cfoutput>

<cfcatch>
    <cfoutput>
        <p>Error: #cfcatch.message#</p>
        <p>Detail: #cfcatch.detail#</p>
    </cfoutput>
</cfcatch>
</cftry>
<cfabort>