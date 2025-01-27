<cfinclude  template="task.cfm">
<cfoutput>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width initial-scale=1.0">
     <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" >
    <link rel="stylesheet" href="css/styles.css">
</head>
<body>
    <table border="1">
        <tr>
            <th>TASK NAME</th>
            <th>PRIORITY</th>
            <th>STATUS</th>
            <th>DUE DATE</th>
            <th>ACTIONS</th>

        </tr>
        <cfloop query="tasks">
        <tr>
            <td>#str_task_name#</td>
            <td>#int_task_priority#</td>
            <td>#int_task_status#</td>   
            <td>#dt_task_due_date#</td>
            <td>
                <a href="editTask.cfm?task_id=#task_id#">Edit</a>
                <a href="tasks.cfm?action=delete&task_id=#task_id#">Delete</a>
            </td>

        </tr>
        </cfloop>
    </table>
</body>
</html>
</cfoutput>