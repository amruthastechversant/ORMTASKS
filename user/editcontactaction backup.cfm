
    <cfquery name="qryGetEducationOptions" datasource="dsn_addressbook">
     select ID,TITLE as education from education
    </cfquery>

<cfquery name="getEducation" datasource="dsn_addressbook">
    SELECT education.title
    FROM contacts
    JOIN education
    ON contacts.int_education_id = education.id
    WHERE contacts.int_contact_id = <cfqueryparam value="#url.contactId#" cfsqltype="cf_sql_integer">
</cfquery>

<cffunction  name="getFormValues" access="public" returnType="void">
<cfset session.success_msg=""> 
<cfif IsDefined("url.contactId")>
    <cfset contactId = url.contactId>
    <cfset datasource = "dsn_addressbook">
    <cfquery name="contactDetails" datasource="#datasource#">
        SELECT str_firstname, str_lastname, int_education_id, str_profile, int_age, str_gender, int_phone_no, str_hobbies, str_address, int_contact_id
        FROM contacts
        WHERE int_contact_id = <cfqueryparam value="#contactId#" cfsqltype="cf_sql_integer">
    </cfquery>
</cfif>

    
</cffunction>
<cfset getFormValues()>

<cffunction  name="saveContacts" access="public" returnType="void">
<cfif structKeyExists(form, "btnSave")>
 <cfdump  var="#form.hobbies#" abort>
        
       
    <cfset datasource = "dsn_addressbook">
    <cfif NOT structKeyExists(form, "hobbies")>
        <cfset form.hobbies="">
        
        <cfelse>
        <cfset form.hobbies=arrayToList(form.hobbies,",")>
       
        
    </cfif>
     
    <cfif NOT structKeyExists(form, "education") OR form.education EQ "">
            <cfset form.education = ""> 
        </cfif>
       
    <cfquery datasource="#datasource#">
        UPDATE contacts
        SET str_firstname = <cfqueryparam value="#form.firstname#" cfsqltype="cf_sql_varchar">,
            str_lastname = <cfqueryparam value="#form.lastname#" cfsqltype="cf_sql_varchar">,
            int_education_id = <cfqueryparam value="#form.education#" cfsqltype="cf_sql_varchar">,
            str_profile = <cfqueryparam value="#form.profile#" cfsqltype="cf_sql_varchar">,
            int_age = <cfqueryparam value="#form.age#" cfsqltype="cf_sql_varchar">,
            str_gender = <cfqueryparam value="#form.gender#" cfsqltype="cf_sql_varchar">,
            int_phone_no = <cfqueryparam value="#form.phoneno#" cfsqltype="cf_sql_varchar">,
            str_hobbies = <cfqueryparam value="#form.hobbies#" cfsqltype="cf_sql_varchar">,
          
            str_address = <cfqueryparam value="#form.address#" cfsqltype="cf_sql_varchar">
        WHERE int_contact_id =<cfqueryparam value="#url.contactId#" cfsqltype="cf_sql_varchar">
    </cfquery>
   
       <cfset session.success_msg="updated successfully"> 

</cfif>

</cffunction>

<cfset getFormValues()>
<cfif structKeyExists(form, "btnSave")>
    
    <cfset saveContacts()>
</cfif>