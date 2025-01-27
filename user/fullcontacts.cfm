<cfinclude  template="fullcontactsaction.cfm">
<cfif NOT structKeyExists(session, "user_id") OR session.user_id EQ "" OR session.user_id IS 0>
    <cflocation url="../userlogin.cfm" addtoken="false">
</cfif>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact List</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../taskmanagement/css/addtaskstyles.css">
</head>
<body>
    <!-- Header with navigation links -->
    <div class="header">
        <img src="../img/logo.png" alt="logo" class="logo">
        <a href="../admin/homepage.cfm">Home</a>
       <!--- <a href="approvedUserProfile.cfm">Profile</a>--->
        <a href="../taskmanagement/addtask.cfm">Tasks</a>
        <a href="addContact.cfm">Create Contact</a>
        
        <a href="../userlogin.cfm" class="moveright">Log out</a>
    </div>

    <!-- Display welcome message for the logged-in user -->
    <cfoutput>
        <h2 class="text-left text-primary">Welcome #session.str_username#</h2>
    </cfoutput>

    <!-- Main title for the page -->
    <h1 align="center">CONTACT LIST</h1>
    <table class="table table-bordered table-sm table-responsive" align="center" style="border-color:#82a5c7;" >
        <thead>
            <tr>
                <th>Firstname</th>
                <th>Lastname</th>
                <th>Education</th>
                <th>phoneno</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
            <!-- Loop through the contact data and display each contact -->
            <cfoutput query="contactData">
                <tr>
                    <td>#str_firstname#</td>
                    <td>#str_lastname#</td>
                    <td>#title#</td>
                    <td>#int_phone_no#</td>
                    <td>
                        <!-- Conditionally display Edit and Delete buttons based on permissions -->
                   
                        <!-- Link to the contact details page with the contactId -->
                        <cfif ArrayContains(SESSION.permissions, 1)>
                            <a href="userdetails.cfm?contactId=#int_contact_id#" class="btn btn-primary btn-sm">
                                View 
                            </a>
                        </cfif>
                
                        <!-- Edit Button (Permission ID: 2) -->
                        <cfif ArrayContains(SESSION.permissions, 2)>
                            <a href="addContact.cfm?contactId=#int_contact_id#" class="btn btn-warning btn-sm">
                                Edit
                            </a>
                        </cfif>
                        
                        <!-- Delete Button (Permission ID: 3) -->
                        <cfif ArrayContains(SESSION.permissions, 3)>
                            <a href="deletecontact.cfm?contactId=#int_contact_id#" 
                               class="btn btn-danger btn-sm" 
                               onclick="return confirm('Are you sure you want to delete this contact?');">
                                Delete
                            </a>
                            
                        </cfif>
                    </td>
                </tr>
            </cfoutput>
        </tbody>
    </table>

    <!-- Pagination controls -->
    <cfoutput> 
        <nav aria-label="Page navigation">
            <ul class="pagination">
                <!-- Previous Button -->
                <cfif currentPage GT 1>
                    <li class="page-item">
                        <a class="page-link" href="fullcontacts.cfm?currentPage=#currentPage - 1#" aria-label="Previous">Previous</a>
                    </li>
                </cfif>

                <!-- Page Numbers -->
                <cfloop index="i" from="1" to="#totalPages#">
                    <li class="page-item <cfif i EQ currentPage>active</cfif>">
                        <a class="page-link" href="fullcontacts.cfm?currentPage=#i#">#i#</a>
                    </li>
                </cfloop>

                <!-- Next Button -->
                <cfif currentPage LT totalPages>
                    <li class="page-item">
                        <a class="page-link" href="fullcontacts.cfm?currentPage=#currentPage + 1#" aria-label="Next">Next</a>
                    </li>
                </cfif>
            </ul>
        </nav>

    <div class="footer">
        <a class="p-0 px-md-3 px-1" href="https://www.amazon.in/gp/help/customer/display.html?nodeId=200507590&ref_=footer_gw_m_b_he">Copyright Info</a>
        <a class="p-0 px-md-3 px-1" href="https://www.facebook.com/login.php">References</a>
        <a class="p-0 px-md-3 px-1" href="">Contact</a>
    </div>
</body>
</html>
</cfoutput>