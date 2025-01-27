


<cfinclude  template="../taskmanagement/usertaskboardaction.cfm">
<cfif NOT structKeyExists(session, "adminid") OR session.adminid EQ "" OR session.adminid IS 0>
    <cflocation url="../loginasadmin.cfm" addtoken="false">
</cfif>

<cfoutput>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tasks Sorted by Priority</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="../taskmanagement/css/addtaskstyles.css">

</head>
<body>
<div class="header">
        <img src="../img/logo.png" alt="logo" class="logo">
        <a href="admindashboard.cfm">Home</a>
       <a href="userTaskDetails.cfm">Tasks</a>
        <a href="../user/fullcontacts.cfm">Contacts</a>
        <a href="../loginasadmin.cfm" class="moveright">Log out</a>
</div>

<div class="d-flex justify-content-end">                      
    <a href="addtask.cfm" class="btn btn-outline-info btn-lg  my-2 ms-3 me-4">Tasks</a>
</div>

<div class="container mt-5">
    <h2 class="text-center">Tasks Sorted by Priority</h2>
    <form class="d-flex justify-content-between align-items-center" action="usertaskboard.cfm" method="post">
        <input class="form-control mr-sm-2" type="search" placeholder="Search" aria-label="Search" id="str_keyword" name="str_keyword" value="<cfif structKeyExists(form, 'str_keyword')> #form.str_keyword#</cfif>">
        <button class="btn btn-outline-success my-2 ms-3" type="submit">Search</button>
    </form>

    <!-- Fetch and Display Tasks -->

    
    <!-- Cards Row -->
    <div class="row">
        <cfif tasks.recordCount>
               
        <cfloop query="tasks">
            <div class="col-md-6 mb-3">
                <div class="card w-100">
                    <div class="card-header 
                        <cfif int_task_priority EQ 1>bg-danger text-white
                        <cfelseif int_task_priority EQ 2>bg-warning text-dark
                        <cfelse>bg-success text-white</cfif>">
                        <strong>Priority: 
                            <cfif int_task_priority EQ 1>High   
                            <cfelseif int_task_priority EQ 2>Medium
                            <cfelse>Low</cfif>
                            
                        </strong>
                    </div>
                    
                   <div class="card-body">
                    <h1 class="card-title">#int_task_id#</h1>
                     <!---<i class="bi bi-info-circle text-primary" style="cursor: pointer;"   data-task-id="#int_task_id#" data-user-id="#int_user_id#"  data-bs-toggle="modal" data-bs-target="##estimateModal"></i>--->
                    
        

    <h5 class="card-title">#str_task_name#</h5>
    <p class="card-text">#str_task_description#</p>
    <p class="card-text"><strong>Due Date:</strong> #DateFormat(dt_task_due_date, "mm/dd/yyyy")#</p>
    <p class="card-text"><strong>Status:</strong> #task_status#</p>
    <p class="card-text"><strong>Created At:</strong> #DateFormat(created_at, "mm/dd/yyyy")#</p>
    <p class="card-text"><strong>Recurring:</strong> 
    <cfif is_recurring EQ 1>Yes
    <cfelseif is_recurring EQ 0>No
    <cfelse>Not Set</cfif>
</p>

    <p class="card-text"><strong>Recurrence Type:</strong> #recurrence_type#</p>
    <p class="card-text"><strong>Recurrence End Date:</strong> #DateFormat(recurrence_end_date, "mm/dd/yyyy")#</p>
    <p class="card-text"><strong>Estimate hours:</strong>#estimate_hours#</p>

   
  
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


                     
<div class="modal fade" id="estimateModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="exampleModalLabel">Add Working Hours</h5>
    </div>
        <form action="workedtime.cfm" method="post">
            <input type="hidden" id="modalTaskId" name="int_task_id" value="">
            <input type="hidden" id="modalUserId" name="int_user_id" value="">
        
            <select id="hours" name="hours" class="form-select">
                <option value="" selected disabled>Hours</option>
                <cfloop index="i" from="0" to="23">
                <option value="#i#">#NumberFormat(i, "00")#</option>
                </cfloop>
            </select>

            <select id="minutes" name="minutes" class="form-select">
                <option value="" selected disabled> Minutess</option>
                <cfloop index="i" from="0" to="55" step="5">
                <option value="#i#">#NumberFormat(i, "00")#</option>
                </cfloop>
            </select>
        <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            <button type="submit" class="btn btn-primary">Save</button>
        </div>

        
        </form>
    </div>
  </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/js/bootstrap.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="workhours.js"></script>
<cfinclude  template="../taskmanagement/footer.cfm">
</body>
</html>
</cfoutput>
