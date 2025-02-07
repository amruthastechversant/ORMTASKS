<cfinclude template="userloginaction.cfm">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" >
    <meta name="viewport" content="width=device-width initial-scale= 1.0">
       <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" >
    <link rel="stylesheet" href="./css/file.css">
</head>
<body class="loginbody">
<cfoutput>
    <div>
    <div> <h1 class="text-center">USERLOGIN</h1></div>
         <div class=" d-flex justify-content-end">
            <button type="button" class="btn btn-success me-2" onclick="slideAndRedirect()">USER</button>
           <button type="button" class="btn btn-info" onclick="window.location.href='loginasadmin.cfm'" >ADMIN</button>
        </div>
        
       
  
        <form action="userlogin.cfm" method="post">
            <div class="container">
            <cfif len(session.error_msg) GT 0>
                        <div class="text-danger text-center">
                         <cfoutput>#session.error_msg#</cfoutput>
                         </div>
                    </cfif>
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
                    <div class=" d-flex justify-content-between">
                        <a href="" class="text-start text-decoration-none" >forgot password</a>
                        <a href="register.cfm"  class="text-end text-decoration-none">Sign Up</a>
                    </div>
                </div>
            </div>
        </form>
       
    </div>
    <script src="file.js"></script>
</body>
</html>
</cfoutput>