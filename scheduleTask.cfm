
<cffunction  name="schedulejob" access="public" ReturnType="void">
    
    <cfargument name="runDate" type="date">
    <cfset var result={}>
    <cfquery name="schedule" datasource="dsn_addressbook">
        insert into tbl_jobs(runDate) values(
           
            <cfqueryparam value="#arguments.runDate#" cfsqltype="cf_sql_date">
        )
    </cfquery>
      
      

</cffunction>
<cfset scheduleJob(runDate=now())>


