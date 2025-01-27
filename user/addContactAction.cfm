<!---
setDefaultValues()
getFormValues()
validateFormValues()
saveContacts()
--->
<!--- Variable declaration --->

<cffunction name="setDefaultValues" access="public" returntype="void">
    <cfset variables.error_msg = ''>
    <cfset variables.str_firstname = ''>
    <cfset variables.str_lastname = ''>
    <cfset variables.str_profile = ''>
    <cfset variables.int_age = ''>
    <cfset variables.int_phone_no = ''>
    <cfset variables.str_address = ''>
    <cfset variables.int_education_id = ''>
    <cfset variables.str_gender = ''>             
    <cfset variables.str_hobbies = ''>
    <cfset variables.success_msg = ''>
    <cfset variables.datasource="dsn_addressbook">
<cfset getQualification()>
   

</cffunction>
<cffunction  name="getQualification" access="public" returnType="void">
    <cfquery name="variables.qryGetEducationOptions" datasource="#variables.datasource#">
        select ID,TITLE as education from education
   </cfquery>
</cffunction>



<cffunction  name="loadContactDetails" access="public" returntype="void">
<!---edit action--->
<cfif structKeyExists(url, "contactId")>
    <cfset contactId = url.contactId>
    <cfset datasource = "dsn_addressbook">
    <cfquery name="contactDetails" datasource="#datasource#">
        SELECT str_firstname, str_lastname, int_education_id, str_profile, int_age, str_gender, int_phone_no, str_hobbies, str_address, int_contact_id
        FROM contacts
        WHERE int_contact_id = <cfqueryparam value="#contactId#" cfsqltype="cf_sql_integer">
    </cfquery>

        <cfquery name="getEducation" datasource="#datasource#">
            SELECT education.title
            FROM contacts
            JOIN education
            ON contacts.int_education_id = education.id
            WHERE contacts.int_contact_id = <cfqueryparam value="#url.contactId#" cfsqltype="cf_sql_integer">
        </cfquery>

    <cfif contactDetails.recordCount GT 0>
            <cfset variables.str_firstname = contactDetails.str_firstname>
            <cfset variables.str_lastname = contactDetails.str_lastname>
            <cfset variables.str_profile = contactDetails.str_profile>
            <cfset variables.int_age = contactDetails.int_age>
            <cfset variables.int_phone_no = contactDetails.int_phone_no>
            <cfset variables.str_address = contactDetails.str_address>
            <cfset variables.int_education_id = contactDetails.int_education_id>
            <cfset variables.str_gender = contactDetails.str_gender>
         
            <cfset variables.str_hobbies = contactDetails.str_hobbies>
             
        </cfif>
    
</cfif>
</cffunction>  

<cffunction name="getFormValues" access="public" returntype="void">
    
    <cfset variables.str_firstname = form.firstname>
    <cfset variables.str_lastname = form.lastname>
    <cfset variables.str_profile = form.profile>
    <cfset variables.int_phone_no = form.phoneno>
    <cfset variables.str_address = form.address>


    <cfif structKeyExists(form, "age") AND len(trim(form.age)) GT 0>
        <cfset variables.int_age = trim(form.age)>
    <cfelse>
        <cfset variables.int_age = 0>
    </cfif>

    <cfif structKeyExists(form, "gender")>
        <cfset variables.str_gender = form.gender>
    </cfif>

    <cfif structKeyExists(form, "hobbies")>
        <cfset variables.str_hobbies = form.hobbies>
    </cfif>
    <cfif structKeyExists(form, "education")>
        <cfset variables.int_education_id = form.education>
    </cfif>

</cffunction>

<cffunction name="validateFormValues" returnType="string">
    <cfargument name="firstname" type="string">
    <cfargument name="lastname" type="string">
    <cfargument name="profile" type="string">
    <cfargument name="education" type="string">
    <cfargument name="age" type="numeric" required="true">
    <cfargument name="address" type="string">
    <cfargument name="phoneno" type="string">
    <cfargument name="gender" type="string">
    <cfargument name="hobbies" type="string">

    <cfset var error_msg = ''>
    
   <cfif len(arguments.age) EQ 0>
        <cfset error_msg &= "Age is required.<br>">
    <cfelseif NOT isNumeric(arguments.age)>
        <cfset error_msg &= "Age must be a numeric value.<br>">
    <cfelseif arguments.age LT 1 OR arguments.age GT 120>
        <cfset error_msg &= "Age must be between 1 and 120.<br>">
    </cfif>
    
    <cfif len(arguments.age) EQ 0>
        <cfset error_msg &="enter age . <br>">
    </cfif>
    
    <cfif len(arguments.firstname) EQ 0>
        <cfset error_msg &= "enter firstname.<br>">
    </cfif>

    <cfif len(arguments.lastname) EQ 0>
        <cfset error_msg &= "enter lastname.<br>">
    </cfif>

    <cfif len(arguments.profile) EQ 0>
        <cfset error_msg &= "enter profile.<br>">
    </cfif>
    
    <cfif len(arguments.education) EQ 0>
        <cfset error_msg &= "Select any education.<br>">
    </cfif>


    <cfif len(arguments.address) EQ 0>
        <cfset error_msg &= "enter address.<br>">
    </cfif>

    <cfif len(arguments.phoneno) EQ 0>
        <cfset error_msg &= "enter phoneno.<br>">
    </cfif>

    <cfif len(arguments.gender) EQ 0>
        <cfset error_msg &= "enter gender.<br>">
    </cfif>

    <cfif len(arguments.hobbies) EQ 0>
        <cfset error_msg &= "enter hobbies.<br>">
    </cfif>

    <cfreturn error_msg>
</cffunction>

<cffunction name="saveContacts" returnType="struct">
    <cfargument name="firstname">
    <cfargument name="lastname">
    <cfargument name="profile">
    <cfargument name="education">
    <cfargument name="age">
    <cfargument name="gender">
    <cfargument name="phoneno">
    <cfargument name="hobbies">
    <cfargument name="address">


    <cfif NOT isNumeric(arguments.age) OR arguments.age IS 0>
        <cfset arguments.age = 0>
    </cfif>
    <cfset datasource = "dsn_addressbook">
    <cfset var qryCheckDuplicate = QueryNew('')>
    <cfset var structResponse = {"msg":'Successfully Submitted',"status":true}>



<cfif structKeyExists(url, "contactId")>

        <!--- Update Contact --->
        <cfquery datasource="#datasource#">
            UPDATE contacts
            SET str_firstname = <cfqueryparam value="#arguments.firstname#" cfsqltype="cf_sql_varchar">,
                str_lastname = <cfqueryparam value="#arguments.lastname#" cfsqltype="cf_sql_varchar">,
                int_education_id = <cfqueryparam value="#arguments.education#" cfsqltype="cf_sql_varchar">,
                str_profile = <cfqueryparam value="#arguments.profile#" cfsqltype="cf_sql_varchar">,
                int_age = <cfqueryparam value="#arguments.age#" cfsqltype="cf_sql_integer">,
                str_gender = <cfqueryparam value="#arguments.gender#" cfsqltype="cf_sql_varchar">,
                int_phone_no = <cfqueryparam value="#arguments.phoneno#" cfsqltype="cf_sql_varchar">,
                str_hobbies = <cfqueryparam value="#arguments.hobbies#" cfsqltype="cf_sql_varchar">,
                str_address = <cfqueryparam value="#arguments.address#" cfsqltype="cf_sql_varchar">
            WHERE int_contact_id =#url.contactId#
        </cfquery>  
      <cfset structResponse.msg = "Contact updated successfully.">
       
    <cfelse>
    <cfquery name="qryCheckDuplicate" datasource="#datasource#" result="checkresult">
        SELECT COUNT(int_contact_id) AS fldCount
        FROM contacts
        WHERE str_firstname = <cfqueryparam value="#arguments.firstname#" cfsqltype="cf_sql_varchar">
        AND str_lastname = <cfqueryparam value="#arguments.lastname#" cfsqltype="cf_sql_varchar">
        AND int_phone_no = <cfqueryparam value="#arguments.phoneno#" cfsqltype="cf_sql_varchar">
    </cfquery>

    <cfif qryCheckDuplicate.fldCount>
        <cfset structResponse = {"msg":'Duplicate entry detected. The contact already exists.',"status":false}>
    
        <cfreturn structResponse>
    <cfelse>
        <cfquery name="saveContacts" datasource="#datasource#">
            INSERT INTO contacts(
                str_firstname, str_lastname, int_education_id, str_profile, int_age,
                str_gender, int_phone_no, str_hobbies, str_address
            )
            VALUES (
                <cfqueryparam value="#arguments.firstname#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.lastname#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.education#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.profile#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.age#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.gender#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.phoneno#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.hobbies#" cfsqltype="cf_sql_varchar">,
                <cfqueryparam value="#arguments.address#" cfsqltype="cf_sql_varchar">
            )
        </cfquery>
        </cfif>

        </cfif>
        <cfreturn structResponse>
</cffunction>


<cffunction name="checkPermissons" returnType="void">
    <cfif NOT structKeyExists(session, "user_id") OR session.user_id EQ "" OR session.user_id IS 0>
        <cflocation url="../userlogin.cfm" addtoken="false">
    </cfif>
</cffunction>

<cfset checkPermissons()>

<cfset setDefaultValues()>
<cfset loadContactDetails()>


<cfif structKeyExists(form, "btnSave")>

    <cfset getFormValues()>

    <cfset variables.error_msg = validateFormValues(
        firstname=variables.str_firstname,
        lastname=variables.str_lastname,
        education=variables.int_education_id,
        profile=variables.str_profile,
        age=variables.int_age,
        gender=variables.str_gender,
        phoneno=variables.int_phone_no,
        hobbies=variables.str_hobbies,
        address=variables.str_address 
    )>

    <cfif len(variables.error_msg) EQ 0>
        <cfset variables.response = saveContacts(
            firstname=variables.str_firstname,
            lastname=variables.str_lastname,
            education=variables.int_education_id,
            profile=variables.str_profile,
            age=variables.int_age,
            phoneno=variables.int_phone_no,
            address=variables.str_address,
            gender=variables.str_gender,
            hobbies=variables.str_hobbies
        )>
         
        <cfset loadContactDetails()>
    </cfif>
        
</cfif>
