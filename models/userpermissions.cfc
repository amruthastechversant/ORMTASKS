<cfcomponent persistent="true" table="tbl_user_permissions" entityname="userpermissions">
    
    <cfproperty name="int_user_permission_id" fieldtype="id" generator="native"/>
    <cfproperty name="user" fieldtype="many-to-one" cfc="User" fkcolumn="int_user_id"/>
    <cfproperty name="permission" fieldtype="many-to-one" cfc="Permissions" fkcolumn="int_permission_id"/>
    
</cfcomponent>
