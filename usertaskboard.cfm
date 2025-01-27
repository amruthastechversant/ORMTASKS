


<cfinclude  template="usertaskboardaction.cfm">
<cfif NOT structKeyExists(session, "user_id") OR session.user_id EQ "" OR session.user_id IS 0>
    <cflocation url="../loginasadmin.cfm" addtoken="false">
</cfif>

<cfoutput>

<head>
    
    <title>Tasks Sorted by Priority</title>
    <link rel="stylesheet" href="css/addtaskstyles.css">

</head>
<body>
<cfinclude  template="header.cfm">

<div class="d-flex justify-content-end">                      
    <a href="displayUsertaskDetails.cfm" class="btn btn-outline-info btn-lg  my-2 ms-3 me-4 text-success">USER TASK DETAILS</a>
</div>

<div class="container mt-5">
    <h2 class="text-center">Tasks Sorted by Priority</h2>
<form class="d-flex justify-content-between align-items-center" action="usertaskboard.cfm" method="post">
        <input class="form-control mr-sm-2" type="search" placeholder="Search" aria-label="Search" id="str_keyword" name="str_keyword" value="<cfif structKeyExists(form, 'str_keyword')> #form.str_keyword#</cfif>">
        <button class="btn btn-outline-success my-2 ms-3" type="submit">Search</button>
</form>



<div class="row">
    <cfif tasks.recordCount>
        <cfloop query="tasks">
            <div class="col-md-6 mb-3">
                <div class="card w-100 postion-relative">
                    <div class="card-header  col-12
                        <cfif int_task_priority EQ 1>bg-danger text-white
                            <cfelseif int_task_priority EQ 2>bg-warning text-dark
                            <cfelse>bg-success text-white
                        </cfif>">
                        <div class="d-flex justify-content-between align-items-center">
                        <strong>Priority: 
                        <cfif int_task_priority EQ 1>High   
                            <cfelseif int_task_priority EQ 2>Medium
                            <cfelse>Low
                        </cfif>
                        </strong>
                        
                         <i class="bi-three-dots-vertical text-white " style="cursor: pointer;"  data-task-id="#int_task_id#" data-user-id="#int_user_id#"  data-bs-toggle="modal" data-bs-target="##estimateModal"></i>
                         
                        </div>
                    </div>
                    
                   <div class="card-body" style="height:600px;">
                   
                        <h4 class="card-title">#int_task_id#</h4>
                           
                         <p class="card-text"><h2>#str_task_name#</h2></p>
                        <div class="alert-container position-relative  w-75 mb-2">
                           <!--- position-relative  w-75 mb-2--->
                            <cfset alertMessage = getDueDateAlert(dueDate=dt_task_due_date)>
                            <cfif alertMessage NEQ "">
                                <p class="alert alert-danger me-2" >
                                    #alertMessage#
                                </p>
                            </cfif>
                                
                            <cfset working_hours="0">
                            <cfset taskhoursResult = taskhours(working_hours = working_hours, int_task_id = int_task_id)>
                            <cfif taskhoursResult.alertMessage NEQ "">
                                <p class=" alert alert-danger me-2 ">
                                    #taskhoursResult.alertMessage#
                                </p> 
                            </cfif>
                          
                            <cfset taskId=tasks.int_task_id>
                           <cfif structKeyExists(session, "successMsg") AND structKeyExists(session.successMsg, "#tasks.int_task_id#")>
                                <p class="alert alert-success me-2" role="alert">
                                    #session.successMsg[tasks.int_task_id]#
                                </p>
               
                                <cfset structDelete(session.successMsg, "#tasks.int_task_id#")>
                            </cfif>
                            
                           
                        </div>
                        <div class="card-body">
                            
                            <p class="card-text"><strong>Task Description:</strong>#str_task_description#</p>
                            <p class="card-text">
                                <strong>Due Date:</strong> #DateFormat(dt_task_due_date, "mm/dd/yyyy")#
                            </p>
                            <p class="card-text"><strong>Status:</strong>
                                #task_status#
                            </p>
                            <p class="card-text"><strong>Created At:</strong>
                                #DateFormat(created_at, "mm/dd/yyyy")#
                            </p>
                           
                                <cfif is_recurring EQ 1>
                                 <p class="card-text"><strong>Recurring:</strong>  
                                Yes
                             
                                <cfelseif is_recurring EQ 0>

                                <cfelse>Not Set
                                </cfif>
                                
                            <button class="btn btn-link text-dark" type="button" data-bs-toggle="collapse" data-bs-target="##moreDetails-#int_task_id#" aria-expanded="false" aria-controls="moreDetails-#int_task_id#" id="toggleButton-#int_task_id#">
                                <i class="bi bi-chevron-down"></i> More Details
                            </button>
                            <div class="collapse" id="moreDetails-#int_task_id#">
                                <p class="card-text"><strong>Recurrence Type:</strong>
                                    #recurrence_type#
                                </p>
                                <p class="card-text"><strong>Recurrence End Date:</strong>
                                    #DateFormat(recurrence_end_date, "mm/dd/yyyy")#
                                </p>
                            </div>
                         
                            <p class="card-text"><strong>Estimate hours:</strong>
                                #estimate_hours#
                            </p> 
                            <p class="card-text"><strong>Working Hours:</strong>
                                #qryTaskhours.total_working_hours#
                            </p>
                         </div>
                         </div>
                    </div>
                </div>
        </cfloop>
      </cfif>
    </div>
</div>



    <div class="d-flex justify-content-end">
    <!-- Pagination controls -->
    <cfoutput>
        <nav aria-label="Page navigation">
            <ul class="pagination">
                <!-- Previous Button -->
                <cfif currentPage GT 1>
                    <li class="page-item">
                        <a class="page-link" href="usertaskboard.cfm?currentPage=#currentPage - 1#" aria-label="Previous">Previous</a>
                    </li>
                </cfif>

                <!-- Page Numbers -->
                <cfloop index="i" from="1" to="#totalPages#">
                    <li class="page-item <cfif i EQ currentPage>active</cfif>">
                        <a class="page-link" href="usertaskboard.cfm?currentPage=#i#">#i#</a>
                    </li>
                </cfloop>

                <!-- Next Button -->
                <cfif currentPage LT totalPages>
                    <li class="page-item">
                        <a class="page-link" href="usertaskboard.cfm?currentPage=#currentPage + 1#" aria-label="Next">Next</a>
                    </li>
                </cfif>
            </ul>
        </nav>
        </cfoutput>
    </div>
</div>
<cfinclude  template="footer.cfm">
<div class="modal fade" id="estimateModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      
        <form action="../admin/workedtime.cfm" method="post">
            <input type="hidden" id="modalTaskId" name="int_task_id" value="">
            <input type="hidden" id="modalUserId" name="int_user_id" value="">
            <div class="modal-header">
                <h5 class="modal-title" id="exampleModalLabel">Working Hours</h5>
            </div>

            <div class="modal-body">
                <div class="mb-3">
                <label for="hours" class="form-label">Enter Hours </label>
                <input type="decimal" id="hours" name="hours"class="form-control">
                </div>
            </div>
            <div class="modal-body">
                <div class="mb-3">
                <label for="comments">Comments</label>
                <textarea class="form-control " id="comments" name="comments" rows="2" cols="5"></textarea>
            </div>
            <div class="d-flex justify-content-end ">
                <button type="button" class="btn btn-secondary me-2 mb-2" data-bs-dismiss="modal">Close</button>
                <button type="submit" class="btn btn-primary me-2 mb-2" >Save</button>
            </div>
        </form>
       
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="../admin/workhours.js"></script>

</body>
</html>
</cfoutput>
