<cfif not structKeyExists(session, "userid")>
    <cflocation url="../userlogin.cfm">
</cfif>

<h2>My Contacts</h2>

<!-- Display user contacts -->
<cfquery name="qryContacts" datasource="dsn_addressbook">
    SELECT *
    FROM contacts 
    WHERE userid = <cfqueryparam value="#session.user_id#" cfsqltype="cf_sql_integer">
</cfquery>

<cfoutput>
    <table border="1">
        <tr><th>str_Firstname</th><th>str_Lastname</th><th>int_education_id</th><th>str_Profile</th><th>int_Age</th><th>str_Gender</th><th>int_phoneNo</th><th>str_Hobbies</th><th>str_Address</th></tr>
        <cfloop query="qryContacts">
            <tr>
                <td>#str_Firstname#</td>
                <td>#str_Lastname#</td>
                <td>#int_education_id#</td>
                <td>#str_Profile#</td>
                <td>#int_Age#</td>
                <td>#str_Gender#</td>
                <td>#int_phoneNo#</td>
                <td>#str_Hobbies#</td>
                <td>#str_Address#</td>
            </tr>
        </cfloop>
    </table>
</cfoutput>
