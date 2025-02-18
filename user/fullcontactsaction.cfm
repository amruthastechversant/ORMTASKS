
<cfif NOT structKeyExists(session, "user_id") OR session.user_id EQ "" OR session.user_id IS 0>
    <cflocation url="../userlogin.cfm" addtoken="false">
</cfif>

<cfset contacts=entityLoad("contacts")>
<cffunction name="qryContacts" access="public" returnType="numeric">
<cfset  var totalCount=0>
<cfset totalCount =ormExecuteQuery("select count(int_contact_id) from contacts", true)>
    <cfreturn totalCount>
</cffunction>

<!--- <cfparam name="url.contactId" default="0"> 
<cfquery name="contactDetails" datasource="dsn_addressbook">
    SELECT str_firstname, str_lastname, int_education_id, str_profile, int_age, str_gender, int_phone_no, str_hobbies, str_address, int_contact_id
    FROM contacts
    WHERE int_contact_id = <cfqueryparam value="#url.contactId#" cfsqltype="cf_sql_integer">
</cfquery>--->
<!---  
<cffunction  name="contactDetails" access="public" returntype="any">

</cffunction>--->
                                                 



<!-- Function to set default values for pagination -->
<cffunction name="setDefaultValues" access="public" returnType="void">
    <cfset datasource = "dsn_addressbook">
    <cfparam name="form.currentPage" default="1">
    <cfparam name="form.recordsPerPage" default="10" type="numeric">

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
<cffunction name="getContacts" returnType="array">
    <cfargument  name="startRecord" type="numeric" required="true">
    <cfargument  name="recordsPerPage" type="numeric" required="true">
  
   <cfset contactList = entityLoad("contacts", {}, {
        orderby = "int_contact_id ASC",
        offset = arguments.startRecord,
        maxResults = arguments.recordsPerPage
    })>
   <cfreturn contactList>
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
<cfset contactData = getContacts(startRecord=startRecord,recordsPerPage=recordsPerPage)>
<cfset setUserPermissions(user_id=session.user_id)>