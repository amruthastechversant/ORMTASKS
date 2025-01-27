
<cfoutput>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Details</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../css/file.css">
</head>
<body>
<div class="header">
    <img src="../img/logo.png" alt="logo" class="logo">
    <a href="fullcontacts.cfm">Home</a>
    <a href="">Contacts</a>
    <a href="index.cfm">Create Contact</a>
    <a href="../userlogin.cfm" class="moveright">Log out</a>
</div>

<cfparam name="url.contactId" default="0">
<cfquery name="contactDetails" datasource="dsn_addressbook">
    SELECT str_firstname, str_lastname, int_education_id, str_profile, int_age, str_gender, int_phone_no, str_hobbies, str_address, int_contact_id
    FROM contacts
    WHERE int_contact_id = <cfqueryparam value="#url.contactId#" cfsqltype="cf_sql_integer">
</cfquery>

<cfquery name="getEducation" datasource="dsn_addressbook">
    SELECT education.title
    FROM contacts
    JOIN education
    ON contacts.int_education_id = education.id
    WHERE contacts.int_contact_id = <cfqueryparam value="#url.contactId#" cfsqltype="cf_sql_integer">
</cfquery>


<cfif contactDetails.recordCount EQ 1>
    <h1 align="center">CONTACT DETAILS</h1>
    <table class="table table-bordered" align="center" >
        <tbody>
            <tr>
                <td><strong>Firstname:</strong></td>
                <td>#contactDetails.str_firstname#</td>
            </tr>
            <tr>
                <td><strong>Lastname:</strong></td>
                <td>#contactDetails.str_lastname#</td>
            </tr>
            <tr>
                <td><strong>Education:</strong></td>
                <td>#getEducation.title#</td>
            </tr>
            <tr>
                <td><strong>Age:</strong></td>
                <td>#contactDetails.int_age#</td>
            </tr>
            <tr>
                <td><strong>Profile:</strong></td>
                <td>#contactDetails.str_profile#</td>
            </tr>
            <tr>
                <td><strong>Address:</strong></td>
                <td>#contactDetails.str_address#</td>
            </tr>
            <tr>
                <td><strong>Phone Number:</strong></td>
                <td>#contactDetails.int_phone_no#</td>
            </tr>
            <tr>
                <td><strong>Gender:</strong></td>
                <td>#contactDetails.str_gender#</td>
            </tr>
            <tr>
                <td><strong>Hobbies:</strong></td>
                <td>#contactDetails.str_hobbies#</td>
            </tr>
        </tbody>
    </table>
<cfelse>
    <h1 align="center">No Contact Found</h1>
</cfif>

<div class="footer">
    <a class="p-0 px-md-3 px-1" href="https://www.amazon.in/gp/help/customer/display.html?nodeId=200507590&ref_=footer_gw_m_b_he">Copyright Info</a>
    <a class="p-0 px-md-3 px-1" href="https://www.facebook.com/login.php">References</a>
    <a class="p-0 px-md-3 px-1" href="htmlpage.html">Contact</a>
</div>

</body>
</html>
</cfoutput>