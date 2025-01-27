


<cfinclude template="taskAction.cfm">
<cfoutput>
<cfinclude  template="header.cfm">


   <div class="d-flex flex-row-reverse bd-highlight gap-2 py-3">
    <a href="../admin/homepage.cfm" class="btn btn-primary">Dashboard</a>
    <a href="usertaskboard.cfm" class="btn btn-success">TaskStatus</a>
    </div>

</div>
    <!-- Main Content -->
    <div class="content">
        <h3 class="mb-4">Add New Task</h3>
        <div class="text-center">
            <cfif structKeyExists(variables, "response")>
                <cfif NOT variables.response.status>
                    <div class="errordiv text-danger">
                    <p>#variables.response.msg#</p>
                    </div>
                <cfelse>
                    <div class="errordiv text-success">
                    <p>#variables.response.msg#</p>
                    </div>
                </cfif>
            </cfif>
            </div>
        <div class="errordiv text-danger text-center">
            #variables.error_msg#
        </div>
        <form action="" method="post" class="form-group">
            
            <label for="str_task_name">Task Name:</label>
            <input type="text" name="str_task_name" id="str_task_name" value="#variables.str_task_name#" class="form-control" >
            

           
            <label for="str_task_description">Task Description:</label>
            <textarea name="str_task_description" id="str_task_description" class="form-control" rows="4" >#variables.str_task_description#</textarea>
         
            <label for="int_task_priority">Task Priority:</label>
                <cfif NOT structKeyExists(url, "userId")>
            <!-- Add Case -->
                        <select name="int_task_priority" id="int_task_priority" class="selectBox">
                          <option value="" disabled selected>Select Priority</option>
                            <cfloop query="variables.qryGetPriorityOptions">
                                <option value="#variables.qryGetPriorityOptions.id#">
                                    #variables.qryGetPriorityOptions.priority#
                                </option>
                             </cfloop>
                        </select>
                        <cfelse>
                        <select name="int_task_priority" id="int_task_priority" class="selectBox">
                            <cfloop query="qryGetPriorityOptions">
                                <cfset selected = "">
                                <!-- Determine selected option -->
                                <cfloop query="getpriority">
                                    <cfif qryGetPriorityOptions.priority EQ getpriority.priority>
                                        <cfset selected = "selected">
                                    </cfif>
                                </cfloop>
                                <option value="#qryGetPriorityOptions.id#" #selected#>
                                    #qryGetPriorityOptions.priority#
                                </option>
                            </cfloop>
                        </select>
                        
                    </cfif>
                


            <label for="int_task_status">Task status:</label>
                <cfif NOT structKeyExists(url, "userId")>
            <!-- Add Case -->
                        <select name="int_task_status" id="int_task_status" class="selectBox">
                          <option value="" disabled selected>Select status</option>
                            <cfloop query="variables.qryGetStatusOptions">
                                <option value="#variables.qryGetStatusOptions.id#">
                                    #variables.qryGetStatusOptions.status#
                                </option>
                             </cfloop>
                        </select>
                        <cfelse>

                        <select name="int_task_status" id="int_task_status" class="selectBox">
                            <cfloop query="qryGetStatusOptions">
                                <cfset selected = "">
                                <!-- Determine selected option -->
                                <cfloop query="getstatus">
                                    <cfif qryGetStatusOptions.status EQ getstatus.status>
                                        <cfset selected = "selected">
                                    </cfif>
                                </cfloop>
                                <option value="#qryGetStatusOptions.id#" #selected#>
                                    #qryGetStatusOptions.status#
                                </option>
                            </cfloop>
                        </select>
                     </cfif>
                    
                
            <label for="dt_task_due_date">Task Due Date:</label>
                <input type="date" name="dt_task_due_date" id="dt_task_due_date" class="form-control">
                
            <div class="form-check mt-3">
        <input type="checkbox" class="form-check-input" name="is_recurring" id="is_recurring" value="1" 
               <cfif variables.is_recurring EQ 1>checked</cfif>>
        <label class="form-check-label" for="is_recurring">Is Recurring?</label>
    </div>

    <label for="recurrence_type" class="mt-3">Recurrence Type:</label>
    <select name="recurrence_type" id="recurrence_type" class="form-control">
        <option value="" disabled selected>Select Recurrence Type</option>
        <option value="daily" <cfif variables.recurrence_type EQ "daily">selected</cfif>>Daily</option>
        <option value="weekly" <cfif variables.recurrence_type EQ "weekly">selected</cfif>>Weekly</option>
        <option value="monthly" <cfif variables.recurrence_type EQ "monthly">selected</cfif>>Monthly</option>
    </select>

    <label for="recurrence_end_date" class="mt-3">Recurrence End Date:</label>
    <input type="date" name="recurrence_end_date" id="recurrence_end_date" class="form-control" 
           value="#variables.recurrence_end_date#">
    <label for="estimate_hours" class="mt-3">Estimate Hours:</label>
        <input type="number" name="estimate_hours" id="estimate_hours" class="form-control" value="#variables.estimate_hours#" step="0.01" min="0">
            <button type="submit" value="submit" name="saveTask" class="btn btn-primary mt-3">Add Task</button>
        </form>
       
    </div>
</div>
<cfinclude  template="footer.cfm">
</body>
</html>
</cfoutput>
