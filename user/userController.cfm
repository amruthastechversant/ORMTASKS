<cfinclude  template="../models/userModel.cfc">
<cfset session.error_msg="">
<cfif structKeyExists(form, "login")>
    <cfset username=trim(form.username)>
    <cfset password=trim(form.password)>

    <cfif len(username) EQ 0 OR len(password) EQ 0>
        <cfset session.error_msg="please enter username and password">
    <cfelse>
        <cfset userModel=createObject("component","models.userModel" )>
        <cfset qryUser=userModel.getUser(username=username,password=password)>
    
    <cfif qryUser.recordCount>
        <cfset session.user_id = qryUser.id>
        <cfset session.role = qryUser.str_user_role>
        <cfset session.str_username = qryUser.str_username>
       
        <cflocation url="user/fullcontacts.cfm">
    <cfelse>
 
        <cfset session.error_msg = "Invalid username and password">
    </cfif>
    </cfif>
</cfif>

