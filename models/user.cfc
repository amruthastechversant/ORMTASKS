

<cfcomponent persistent="true" table="tbl_users" entityname="user">
    <cfproperty name="id" fieldtype="id" generator="native">
    <cfproperty name="str_name" type="string">
    <cfproperty name="str_phone" type="string">
    <cfproperty name="str_username" type="string">
    <cfproperty name="str_password" type="string">
    <cfproperty name="cbr_status" type="string">
    <cfproperty name="userRole" cfc="userRole" fieldtype="many-to-one" fkcolumn="int_user_role_id">
</cfcomponent>
