<cffunction  name="greetuser">
    <cfargument  name="username" type="string" required="true">
    <cfoutput>
        #arguments.username#
    </cfoutput>
</cffunction>
<cfset greetuser("amrutha")>