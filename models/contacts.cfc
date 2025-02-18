<cfcomponent persistent="true" table="contacts" entityname="contacts">
 <cfproperty name="int_contact_id" fieldtype="id" generator="native">
 <cfproperty  name="str_firstname" ormtype="string">
 <cfproperty  name="str_lastname" ormtype="string">
 <cfproperty  name="str_profile" ormtype="string">
 <cfproperty  name="int_age" ormtype="string">
 <cfproperty  name="str_gender" ormtype="string">
 <cfproperty  name="int_phone_no" ormtype="string">
 <cfproperty  name="str_hobbies" ormtype="string">
 <cfproperty  name="str_address" ormtype="string">


 <cfproperty name="int_education_id" fieldtype="many-to-one" cfc="education" fkcolumn="int_education_id">
 
</cfcomponent>