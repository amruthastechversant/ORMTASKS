<cfcomponent persistent="true" table="task_log" entityname="TaskTime">
        <cfproperty name= "task_log_id" fieldtype="id" generator="native">
        <cfproperty name="int_task_id" ormtype="integer" >
        <cfproperty name="int_user_id" ormtype="integer" >
        <cfproperty name="working_hours" ormtype="float">
        <cfproperty name="str_comments" ormtype="string">
        <cfproperty name="date" ormtype="timestamp">
 
</cfcomponent>
