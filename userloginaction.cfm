<!--- <cfscript>
function setDefaultValues(){
    session.error_msg="";
}

function getFormValues(){
    if(arrayLen(user)){
        var user=entityLoad("user",{str_username=arguments.username,str_password=arguments.password,cbr_status = 'A'});
    } else {

    }
    for(){

    }
    while(){

    }

} 
</cfscript>--->
 <!--- Simple validation for empty fields --->
<cffunction  name="setDefaultValues" access="public" returnType="void">
    <cfset session.error_msg="">
</cffunction>

<cffunction name="getFormValues" access="public" returnType="void">
    <cfargument name="username" type="string" required="true">
    <cfargument name="password" type="string" required="true">
    
    <cfif structKeyExists(form, "login")>
            <cfset var user=entityLoad("user",{str_username=arguments.username,str_password=arguments.password,cbr_status = 'A'})>
            <!---<cfdump  var="#user[1].getUserRole().getId()#">--->
            <cfif arrayLen(user)>

                <cfif user[1].getUserRole().getStr_user_role() EQ "user">
                    <cfset session.user_id=user[1].getId()>
                    <cfset session.role=user[1].getUserRole().getStr_user_role()>
                    <cfset session.str_username=user[1].getStr_username()>
                    <cflocation url="admin/homepage.cfm">
                <cfelse>
                    <cfset session.error_msg="invalid role">
                </cfif>

                <cfelse>
                    <cfset session.error_msg = "Invalid username and password">
            </cfif>

        <cfelse>
       <cfset session.error_msg="error occured">

    </cfif>
</cffunction>
<cfset  setDefaultValues()>
<cfif structKeyExists(form, "login")>
    <cfset getFormValues(username=form.username, password=form.password)>
</cfif>
