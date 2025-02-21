
<cfinclude  template="../usertaskboardaction.cfm">
<cfoutput>
<!DOCTYPE html>
<html lang="en">
	<head>
	<meta charset="UTF-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>USERHOMEPAGE</title>
		<link rel="stylesheet" href="../css/file.css">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" >
		
	</head>	
	<body class="homediv">
	
		<div class="header">
			<img src="../img/logo.png" alt="logo" class="logo">
			<a href="../user/approveduserprofile.cfm">Home</a>
			<a href="../addtask.cfm">Add Task</a>
			<a href="../user/fullcontacts.cfm">Contacts</a>
			<a href="../userlogin.cfm" class="moveright">Log out</a>
   		 </div>
	
		<div class="container h1  col-lg-auto mt-3 mb-3">
			<h1 class="text-center">OVERVIEW</h1>
		</div>
		<div class="container mt-3 " style="margin-bottom:80px;">
			<div class="row">
				<div class="col-12">
				<p lang='la'>"At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat.""Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum"</p>
				</div>
			</div>
		</div>
		<div class="todaystasktable container col-lg-auto mt-3 mb-5">
		<cfset TodaysTasks=getTodayTask()>
			
			<cfif arrayLen(TodaysTasks)>
				<form action="../updateTask.cfm" method="post">
					<table class="table table-bordered">
					<button type="button" class="btn btn-info mb-3">Today's Tasks</button>
						<tr>
							<th>Task Name</th>
							<th>Task Description</th>
							<th>Status</th>
							<th style="width:20%">Mark as completed</th>
						</tr>

					<tbody>
					<cfloop array="TodaysTasks" index="TodaysTasks">
					<tr>
						<td>#TodaysTasks.getStr_task_name()#</td>
						<td>#TodaysTasks.getStr_task_description()#</td>
						<td>#TodaysTasks.getTask_status()#</td>
						<td>
						<input type="checkbox" name="completedtasks" value="#TodaysTasks.getInt_task_id()#">
						
					
						</td>
					</tr>
					</cfloop>
					
					</tbody>
					</table>
					<button type="submit" class="btn btn-success my-2 ms-3">UPDATE</button>
				
				</form>
				<cfelse>
			</cfif>
		</div>

		<div class= "pendingtasktable container col-lg-auto mt-3 mb-5" >
			<cfset pendingTask=pendingTask()>
			<cfif arrayLen(pendingTask)>
				<form action="../updateTask.cfm" method="POST">
				<table class="table table-bordered">
					<tr>
						<th>Task Name</th>
						<th>Task Decription</th>
						
						<th>Task Due Date</th>
						<th style="width:50%">Mark As Completed</th>
					</tr>

					<tbody>					
						<cfloop array="#pendingTask#" index="pTask">
							<tr>
								<td>#pTask.getStr_task_name()#</td>
								<td>#pTask.getStr_task_description()#</td>
								<td>#pTask.getDt_task_due_date()#</td>
								<td>
									<input type="checkbox" name="userpendingtask"value="#pTask.getInt_task_id()#">
								</td>
							</tr>
						</cfloop>
					</tbody>
				</table>
					<button type="submit" class="btn btn-primary">UPDATE TASK</button>
				</form>
			</cfif>
		</div>
<cfinclude  template="../footer.cfm">
</body>
</html>
</cfoutput>