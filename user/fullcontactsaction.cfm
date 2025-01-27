
<cfif NOT structKeyExists(session, "user_id") OR session.user_id EQ "" OR session.user_id IS 0>
    <cflocation url="../userlogin.cfm" addtoken="false">
</cfif>
<!-- Function to retrieve total contact count -->
<cffunction name="qryContacts" access="public" returnType="numeric">
    <cfquery name="qryTotalContacts" datasource="#datasource#">
        SELECT COUNT(int_contact_id) AS totalCount
        FROM contacts
    </cfquery>
    <cfreturn qryTotalContacts.totalCount>
</cffunction>

<cfparam name="url.contactId" default="0">
<cfquery name="contactDetails" datasource="dsn_addressbook">
    SELECT str_firstname, str_lastname, int_education_id, str_profile, int_age, str_gender, int_phone_no, str_hobbies, str_address, int_contact_id
    FROM contacts
    WHERE int_contact_id = <cfqueryparam value="#url.contactId#" cfsqltype="cf_sql_integer">
</cfquery>


<cfquery name="getEducation" datasource="dsn_addressbook">
    SELECT education.title
    FROM contacts
    JOIN education
    ON contacts.int_education_id = education.id
    WHERE contacts.int_contact_id = <cfqueryparam value="#contactId#" cfsqltype="cf_sql_integer">
</cfquery>




<!-- Function to set default values for pagination -->
<cffunction name="setDefaultValues" access="public" returnType="void">
    <cfset datasource = "dsn_addressbook">
    <cfparam name="form.currentPage" default="1">
    <cfparam name="form.recordsPerPage" default="10">

    <!-- Determine the current page based on URL or form input -->
    <cfif structKeyExists(URL, "currentPage")>
        <cfset currentPage = val(URL.currentPage)>
    <cfelseif structKeyExists(form, "currentPage")>
        <cfset currentPage = val(form.currentPage)>
    <cfelse>
        <cfset currentPage = 1>
    </cfif>

    <!-- Set records per page and calculate starting record -->
    <cfset recordsPerPage = val(form.recordsPerPage)>
    <cfset startRecord = (currentPage - 1) * recordsPerPage>
    <cfset totalContacts = qryContacts()>
    <cfset totalPages = ceiling(totalContacts / recordsPerPage)>
</cffunction>

<!---<cfquery name="getEducation" datasource="dsn_addressbook">
    SELECT education.title as education_title
    FROM contacts
    JOIN education
    ON contacts.int_education_id = education.ID
    WHERE contacts.int_education_id = education.ID
</cfquery>--->


<!-- Function to retrieve contacts based on pagination -->
<cffunction name="getContacts" returnType="query">
    <cfset var qryResults = "">
    <cfset var datasource = "dsn_addressbook">
    <cfquery name="qryResults" datasource="#datasource#">
        SELECT c.str_firstname, c.str_lastname, c.int_education_id,c.str_profile, c.int_age, c.str_gender, c.int_phone_no, c.str_hobbies, c.str_address, c.int_contact_id,e.title
        FROM contacts AS c
        join education AS e
     ON c.int_education_id = e.ID
    WHERE c.int_education_id = e.ID
        ORDER BY int_contact_id
        LIMIT <cfqueryparam value="#startRecord#" cfsqltype="cf_sql_integer">, <cfqueryparam value="#recordsPerPage#" cfsqltype="cf_sql_integer">
    </cfquery>
    <cfreturn qryResults>

    
</cffunction>

<!-- Get the contact data based on current page -->


<!-- Function to retrieve and set user permissions -->
<cffunction name="setUserPermissions" access="public" returnType="void">
    <cfargument name="user_id" type="numeric" required="true">
    <cfquery name="qryUserPermissions" datasource="dsn_addressbook">
        SELECT int_permission_id
        FROM tbl_user_permissions
        WHERE int_user_id = <cfqueryparam value="#session.user_id#" cfsqltype="cf_sql_integer">
    </cfquery>

    <!-- Store user permissions in the session -->
    <cfset SESSION.permissions = ArrayNew(1)>
    <cfloop query="qryUserPermissions">
        <cfset ArrayAppend(SESSION.permissions, qryUserPermissions.int_permission_id)>
    </cfloop>
</cffunction>
<cfset setDefaultValues()>
<cfset contactData = getContacts()>
<cfset setUserPermissions(user_id=session.user_id)>