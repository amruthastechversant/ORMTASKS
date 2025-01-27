<component persistent="yes" table="tasks" entityname="Tasks">
  <property name="int_task_id" fieldtype="id" generator="native">
  <property name="int_user_id" fieldtype="id">
  <property name="str_task_description" fieldtype="string">
  <property name="int_task_priority" fieldtype="id">
  <property name="dt_task_due_date" fieldtype="date">
  <property name="int_task_status" fieldtype="id">
  <property name="created_at" fieldtype="timestamp">
  <property name="is_recurring" fieldtype="tinyint">
  <property name="recurrence_type" fieldtype="string">
  <property name= "recurrence_end_date" fieldtype="date">
  <property name="GetEmailSent"  type="tinyint">
  <property name="estimate_hours" fieldtype="float">
</component>                         