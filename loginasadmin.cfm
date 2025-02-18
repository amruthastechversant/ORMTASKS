<!---setDefaultValues()
getFormValues()
validateFormValues()
saveContacts()--->

<cffunction  name="setDefaultValues" access="public" returnType="void">
<cfset session.error_msg="">
</cffunction>


<cffunction  name="getFormValues" access="public" returnType="void">
    <cfargument  name="username" type="string" required="true">
    <cfargument  name="password" type="string" required="true">
    <cfif structKeyExists(form, "login")>
        <cfset var admin =entityLoad("user",{str_username=arguments.username,str_password=arguments.password,cbr_status='A'})>
    
        <cfif arraylen(admin)>
            <cfdump  var="#admin#">
            <cfset admin[1].getUserRole().getStr_user_role() EQ "admin">

            <cfset session.adminid=admin[1].getId()>
            <cfset session.role=admin[1].getUserRole().getStr_user_role()>
            <cfset session.str_username=admin[1].getStr_username()>
            <cflocation  url="admin/admindashboard.cfm">

        <cfelse>
            <cfset session.error_msg="invalid credentials">

        </cfif>

        <cfelse>
            <cfset session.error_msg="incorrect username and password">

    </cfif>

</cffunction>

<cfset setDefaultValues()>
<cfif structKeyExists(form, "login")>
    <cfset getFormValues(username=form.username,password=form.password)>
</cfif>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" >
    <meta name="viewport" content="width=device-width initial-scale= 1.0">
       <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" >
    <link rel="stylesheet" href="css/file.css">
</head>
<body class="loginbody">
<cfoutput>
    <div>
        <div> <h1 class="text-center">ADMINLOGIN</h1></div>
        <div class=" d-flex justify-content-end">
            <button type="button" class="btn btn-success me-2" onclick="slideAndRedirect()">USER</button>
           <button type="button" class="btn btn-info" onclick="window.location.href='loginasadmin.cfm'" >ADMIN</button>
        </div>
        
     <div class="errordiv text-danger text-center"> #session.error_msg#</div>
        <form action="loginasadmin.cfm" method="post">
            <div class="container">
                <div class="logintble col-lg-4 mx-auto"  >
                    <div class="mb-3">
                        <label for="username">USERNAME</label>
                        <input type="text" name="username" id="username" class="form-control">
                    </div>
                    <div class="mb-5">
                        <label for="password">PASSWORD</label>
                        <input type="password" name="password" id="password" class="form-control">
                    </div>
                    <div class="mb-3 col-auto">
                        <input type="submit" value="LOGIN" id="submit" class="userlogin" name="login">
                    </div>
                    
                </div>
            </div>
        </form>
    </div>
   <script src="js/file.js"></script>
</body>
</html>
</cfoutput>