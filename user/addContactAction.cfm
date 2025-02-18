<cfparam name="url.contactID" type="integer" default="0">
<cfset checkPermissons()>
<cfset setDefaultValues()>

<cfif url.contactID GT 0>
    <cfset contacts=entityLoadByPK("contacts", url.contactID)>
</cfif>
<!--- <cfdump  var="#url.contactId#" abort> --->
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
            hobbies=variables.str_hobbies,
            contactId=url.contactId
        )>
    </cfif>
</cfif>

<cffunction name="setDefaultValues" access="public" returntype="void">
    <cfset variables.str_firstname = ''>
    <cfset variables.str_lastname = ''>
    <cfset variables.str_profile = ''>
    <cfset variables.int_age = 0>
    <cfset variables.int_phone_no = ''>
    <cfset variables.str_address = ''>
    <cfset variables.int_education_id = ''>
    <cfset variables.str_gender = ''>             
    <cfset variables.str_hobbies = ''>
    <cfset variables.success_msg = ''>
    <cfset variables.error_msg="">
    <cfset variables.success_msg="">
    <cfset contacts=entityNew("contacts")>
    <cfset educations=entityLoad("education")>
    <cfset getQualification()>
</cffunction>

<cffunction  name="getQualification" access="public" returnType="void">

    <cfset educations=entityLoad("education")>
<!---    <cfquery name="variables.qryGetEducationOptions" datasource="#variables.datasource#">
--         select ID,TITLE as education from education
--    </cfquery>--->
</cffunction>

<cffunction name="getFormValues" access="public" returntype="void">
    <cfset variables.str_firstname = form.firstname>
    <cfset variables.str_lastname = form.lastname>
    <cfset variables.str_profile = form.profile>
    <cfset variables.int_phone_no = form.phoneno>
    <cfset variables.str_address = form.address>

    <cfif structKeyExists(form, "age") AND len(trim(form.age)) GT 0>
        <cfset variables.int_age = trim(form.age)>
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
    <cfif len(arguments.address) EQ 0><cfset error_msg &= "enter address.<br>"></cfif>
    <cfif len(arguments.phoneno) EQ 0><cfset error_msg &= "enter phoneno.<br>"></cfif>
    <cfif len(arguments.gender) EQ 0><cfset error_msg &= "enter gender.<br>"></cfif>
    <cfif len(arguments.hobbies) EQ 0><cfset error_msg &= "enter hobbies.<br>"></cfif>

    <cfreturn error_msg>
</cffunction>




<cffunction name="saveContacts" access="public" returntype="any">
    <cfargument name="firstname" type="string" required="true">
    <cfargument name="lastname" type="string" required="true">
    <cfargument name="profile" type="string">
    <cfargument name="education" type="string">
    <cfargument name="age" default="0" type="numeric">
    <cfargument name="gender" type="string">
    <cfargument name="phoneno" type="numeric">
    <cfargument name="hobbies" type="string">
    <cfargument name="address" type="string">
    <cfargument  name="contactId"  required="false">
    <cfset var structResponse = {"msg": "Successfully Submitted", "status": true}>
    <cfset var contact="">
     <cftry> 
            <cfset var existingContacts = entityLoad("Contacts", 
                {str_firstname=arguments.firstname, str_lastname=arguments.lastname, int_phone_no=arguments.phoneno})>

            <!---check if it is edit exclude current contactid--->
            <cfset filteredContacts=[]>

            <cfloop array="#existingContacts#" index="contact">
                <cfif contact.getInt_contact_id() NEQ arguments.contactId>
                    <cfset existingContacts=arrayAppend(filteredContacts, arguments.contactId)>
                </cfif>

                <cfset existingContacts=filteredContacts>
            </cfloop>

                
            <cfif arrayLen(existingContacts) >
                <cfset structResponse = {"msg": "Duplicate entry detected. The contact already exists.", "status": false}>
                <cfreturn structResponse>
            </cfif>

            <cfif (arguments.contactId) GT 0>
                <cfset contact=entityLoadByPK("contacts", arguments.contactId)>
                <cfif NOT isobject(contact)>
                    <cfset structResponse = {"msg": "Contact not found.", "status": false}>
                    <cfreturn structResponse>
                </cfif>
            <cfelse>
                <!-- New contact creation -->
                <cfset contact = entityNew("Contacts")>
            </cfif>

                <cfset education = entityLoadByPK("education", arguments.education)>
                <cfif isObject(education)>
                    <cfset contact.setInt_education_id(education)>
                </cfif>
                <cfset contact.setStr_firstname(arguments.firstname)>
                <cfset contact.setStr_lastname(arguments.lastname)>
                <cfset contact.setStr_profile(arguments.profile)>
                <cfset contact.setInt_age(arguments.age)>
                <cfset contact.setStr_gender(arguments.gender)>
                <cfset contact.setInt_phone_no(arguments.phoneno)>
                <cfset contact.setStr_hobbies(arguments.hobbies)>
                <cfset contact.setStr_address(arguments.address)>
                
                <cfset entitySave(contact)>
               <cfset structResponse.msg = "Contact " & (arguments.contactId GT 0 ? "updated" : "added") & " successfully.">
        
          <cfcatch>
                <cfset structResponse = {"msg": "Error: " & cfcatch.message, "status": false}>
           </cfcatch> 
       
       </cftry> 
    <cfreturn structResponse>
</cffunction>


<cffunction name="checkPermissons" returnType="void">
    <cfif NOT structKeyExists(session, "user_id") OR session.user_id EQ "" OR session.user_id IS 0>
        <cflocation url="../userlogin.cfm" addtoken="false">
    </cfif>
</cffunction>
