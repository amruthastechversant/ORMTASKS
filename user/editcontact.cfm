<cfinclude  template="editcontactaction.cfm">
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add contact Form</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="../css/file.css">
</head>  

<body>
    <cfoutput>
        <div class="header">
            <img src="../img/logo.png" alt="logo" class="logo">
            <a href="">Home</a>
            <a href="fullcontacts.cfm">Contacts</a>
            <a href="addContact.cfm">Create Contact</a>
            <a href="../userlogout.cfm" class="moveright">Log out</a>
        </div>

        <div class="headdiv">
            <h1>EDIT CONTACT FORM</h1>
        </div>
    <div class="errordiv text-success">#session.success_msg#</div>
        <form action="editcontact.cfm?contactId=#url.contactId#" method="post" name="form">
            <table class="indextable mx-auto">
                <tr>
                    <td class="alignRight"><label for="firstname">First Name</label></td>
                    <td><input type="text" id="firstname" name="firstname" value="#contactDetails.str_firstname#"></td>
                    <td class="alignRight"><label for="lastname">Last Name</label></td>
                    <td><input type="text" id="lastname" name="lastname" value="#contactDetails.str_lastname#"></td>
                </tr>
                
                <tr>
                    <td class="alignRight"><label for="Education">Education</label></td>
                        <td>
                        <select name="education" id="Education"  class="selectBox">
                        <cfloop query="qryGetEducationOptions">
                            <cfset selected = "">
                        <cfloop query="getEducation">
                            <cfif qryGetEducationOptions.education EQ getEducation.title>
                                <cfset selected = "selected">
                             </cfif>
                        </cfloop>
                            <option value="#qryGetEducationOptions.ID#" #selected#>#qryGetEducationOptions.education#</option>
                         </cfloop>
                        </select>
                    </td>
                </tr>



                <tr>
                    <td class="alignRight"><label for="age">Age</label></td>
                    <td colspan="3"><input type="number" id="age" name="age" value="#contactDetails.int_age#"></td>
                </tr>

                <tr>
                    <td class="alignRight"><label for="profile">Profile</label></td>
                    <td colspan="3"><textarea rows="4" cols="40" id="profile" name="profile" wrap="soft">#contactDetails.str_profile#</textarea></td>
                </tr>

                <tr>
                    <td class="alignRight"><label for="address">Address</label></td>
                    <td colspan="3"><textarea rows="4" cols="40" id="address" name="address" wrap="soft">#contactDetails.str_address#</textarea></td>
                </tr>

                <tr>
                    <td class="alignRight"><label for="phoneno">Phone Number</label></td>
                    <td colspan="3"><input type="text" id="phoneno" name="phoneno" maxlength="10" title="only numbers allowed" value="#contactDetails.int_phone_no#"></td>
                </tr>

                <tr>
                    <td class="alignRight"><label>Gender</label></td>
                    <td colspan="3">
                        <input type="radio" id="genderM" name="gender" value="Male" <cfif contactDetails.str_gender EQ "Male">checked</cfif>><label for="genderM">Male</label>
                        <input type="radio" id="genderF" name="gender" value="Female" <cfif contactDetails.str_gender EQ "Female">checked</cfif>><label for="genderF">Female</label>
                    </td>
                </tr>

                <tr>
                    <td class="alignRight"><label>Hobbies</label></td>
                    <td colspan="3">
                        <input type="checkbox" id="reading" name="hobbies[]" value="Reading" 
                        <cfif ListFind(contactDetails.str_hobbies, "Reading", ",")>checked</cfif>>
                        <label for="reading">Reading</label>
        
                        <input type="checkbox" id="travel" name="hobbies[]" value="Travelling" 
                         <cfif ListFind(contactDetails.str_hobbies, "Travelling", ",")>checked</cfif>>
                         <label for="travel">Travelling</label>
        
                        <input type="checkbox" id="music" name="hobbies[]" value="Music" 
                        <cfif ListFind(contactDetails.str_hobbies, "Music", ",")>checked</cfif>>
                         <label for="music">Music</label>
                    </td>
                </tr>

                
                <tr>
                    <td class="alignRight" colspan="4">
                        <input type="reset" name="btnReset" value="Reset">
                        <button type="submit" value="submit" name="btnSave" class="btnreg">Save</button>
                        
                    </td>
                </tr>
            </table>
        </form>

        <br><br>
        <div class="footer">
            <a class="p-0 px-md-3 px-1" href="https://www.amazon.in/gp/help/customer/display.html?nodeId=200507590&ref_=footer_gw_m_b_he">Copyright Info</a>
            <a class="p-0 px-md-3 px-1" href="https://www.facebook.com/login.php">References</a>
            <a class="p-0 px-md-3 px-1" href="htmlpage.html">Contact</a>
        </div>
    </body>
</html>
</cfoutput>
