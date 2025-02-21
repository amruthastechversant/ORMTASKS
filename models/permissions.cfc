<cfcomponent persistent="true" table="tbl_permissions" entityname="permissions">
<cfproperty  name="int_permission_id" fieldtype="id" generator="native">
<cfproperty  name="str_permissions"  ormtype="string">
</cfcomponent>