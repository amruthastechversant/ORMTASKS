
<cfinclude  template="../admin/workedtime.cfm">
<cfoutput>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Display Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0-alpha1/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
    <link rel="stylesheet" href="css/addtaskstyles.css">
    <style>
        body{background-image:url('../img/img.jpg');}
    </style>
</head>
<body >
<cfinclude  template="header.cfm">
<cfquery name="getUserDetails" datasource="#datasource#">
    select int_task_id,int_user_id,working_hours AS int_hours,str_comments AS comments
    from task_log   
  
</cfquery>
<h1 class="text-center">USER TASK DETAILS</h1>
<table border="1" class="w-75 mt-5 table table-bordered table-striped " style="height:600px; margin:0px auto;">
    <tr>
        <th>TASK ID</th>
        <th>USER ID</th>
        <th>WORKING HOURS</th>
        <th>COMMENTS</th>
        
    </tr>
        <cfif getUserDetails.recordCount GT 0>
        <cfloop query="getUserDetails">
        <tr>
            <td>#int_task_id#</td>
            <td>#int_user_id#</td>
            <td>#int_hours#</td>
            <td>#comments#</td>
        </tr>
        </cfloop>
            <cfelse>
                <tr>
                <td colspan="3">No task details available</td>
                </tr>
        </cfif>
</table>
</body>
</html>
</cfoutput>