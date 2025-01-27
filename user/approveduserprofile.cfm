<cfinclude  template="approveduserprofileaction.cfm">
<cfoutput>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../css/file.css">
    <title>profile</title>
</head>
<body>
    <div class="header">
        <img src="../img/logo.png" alt="logo" class="logo">
        <a href="fullcontacts.cfm">Home</a>
        <a href="approvedUserProfile.cfm">Contacts</a>
        <a href="addContact.cfm">Create Contact</a>
        <a href="../userlogin.cfm" class="moveright">Log out</a>
    </div>

    <div class="container d-flex justify-content-center mt-5 mb-5" style="height:200px;">
        <div class="detail-box text-center w-50 ">
            <h3>User Details</h3>
            <p><strong>Username:</strong> #session.str_username#</p>
            <p><strong>Phone:</strong> #userPhone#</p>
        </div>
    </div>
     <div class="footer">
        <a class="p-0 px-md-3 px-1" href="https://www.amazon.in/gp/help/customer/display.html?nodeId=200507590&ref_=footer_gw_m_b_he">Copyright Info</a>
        <a class="p-0 px-md-3 px-1" href="https://www.facebook.com/login.php">References</a>
        <a class="p-0 px-md-3 px-1" href="">Contact</a>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
</cfoutput>
