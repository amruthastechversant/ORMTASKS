<cfcomponent persistent="true" table="tasks" entityname="Tasks">
    <cfproperty name="int_task_id" fieldtype="id" generator="native">
    <cfproperty name="int_user_id" ormtype="">
    <cfproperty name="str_task_name" ormtype="string">
    <cfproperty name="str_task_description" ormtype="string">
    <cfproperty name="dt_task_due_date" ormtype="timestamp">
    <cfproperty name="is_recurring" ormtype="boolean">
    <cfproperty name="recurrence_type">
    <cfproperty name="recurrence_end_date" ormtype="date">
    <cfproperty name="estimate_hours" ormtype="integer">
    <cfproperty name="created_at" ormtype="timestamp">

    <cfproperty name="int_task_priority" fieldtype="many-to-one" cfc="priority" fkcolumn="int_task_priority">
    <cfproperty name="int_task_status" fieldtype="many-to-one" cfc="status" fkcolumn="int_task_status">

</cfcomponent>
