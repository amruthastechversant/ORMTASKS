<cfcomponent persistent="true" table="status" entityname="status">
    <cfproperty  name="id" fieldtype="id" generator="native">
    <cfproperty  name="status" ormtype="string">
</cfcomponent>