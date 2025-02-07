


<cfinclude template="../usertaskboardaction.cfm">
<cfif NOT structKeyExists(session, "user_id") OR session.user_id EQ "" OR session.user_id IS 0>
    <cflocation url="../userlogin.cfm" addtoken="false">
</cfif>

<cfif structKeyExists(form, "hours")>
     
    <cfset int_task_id = form.int_task_id>
    
    <cfset int_hours=form.hours>
    <cfset int_user_id = form.int_user_id> 
    <cfset comments=form.comments>
   
  
    
    <cfif Not isNumeric(int_task_id)>
        <cfset int_task_id=0>
    </cfif>

    <cfif not isNumeric(int_user_id)>
        <cfset int_user_id=0>
    </cfif>
    
   <cfif NOT isNumeric(int_hours)>
        <cfset int_hours = 0.0>
    <cfelse>
    
        <cfset int_hours = NumberFormat(int_hours,"0.00" )>
    </cfif>

    
     
    
     
<cftry>

        <cfset task_log= entityNew("TaskTime")>
        <cfset task_log.setInt_task_id(int_task_id)>
        <cfset task_log.setInt_user_id(int_user_id)>
        <cfset task_log.setWorking_hours(int_hours)>
        <cfset task_log.setStr_comments(comments)>
        <cfset task_log.setDate(now())> 
       
        <cfset entitySave(task_log)>
       
              
            <cfif NOT structKeyExists(session, "successMsg")>
                <cfset session.successMsg = structNew()>
            </cfif>
            
          <cfif len(comments) GT 0 and len(int_hours) GT 0> 
               <cfset session.successMsg["#int_task_id#"]="Hours Submitted & comments added">
                 <cfelseif len(int_hours) GT 0> 
                <cfset session.successMsg["#int_task_id#"]="Hours Submitted">
                <cfelseif len(comments) GT 0 OR len(int_hours) EQ 0 >
                    <cfset session.successMsg["#int_task_id#"]="comments added">
             </cfif> 
           
        <cflocation  url="../usertaskboard.cfm" addToken="false">
        <cfcatch>
        
        <cfoutput><p class="text-danger">Task ID: #int_task_id# not found or user mismatch.#cfcatch#</p></cfoutput>
        </cfcatch>
</cftry>

</cfif>


