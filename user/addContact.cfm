<cfinclude  template="addContactAction.cfm">
<cfif NOT structKeyExists(session, "user_id") OR session.user_id EQ "" OR session.user_id IS 0>
    <cflocation url="../userlogin.cfm" addtoken="false">
</cfif>
<cfoutput>
<!--- Display block --->
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
        <div class="header">
            <img src="../img/logo.png" alt="logo" class="logo">
            <a href="../admin/homepage.cfm">Home</a>
            <a href="fullcontacts.cfm">Contacts</a>
            <a href="addContact.cfm">Create Contact</a>
            <a href="userlogout.cfm" class="moveright">Log out</a>
        </div>
        <div class="headdiv">
            <h1>ADD CONTACT FORM</h1>
        </div>
            <div class="text-center">
            <cfif structKeyExists(variables, "response")>
                <cfif NOT variables.response.status>
                    <div class="errordiv text-danger">
                    <p>#variables.response.msg#</p>
                    </div>
                <cfelse>
                    <div class="errordiv text-success">
                    <p>#variables.response.msg#</p>
                    </div>
                </cfif>
            </cfif>
            </div>
        <div class="errordiv text-danger text-center">
            #variables.error_msg#
        </div>

        <form action="" method="post" name="form">
            <table class="indextable mx-auto">
                <tr>
                    <td class="alignRight"><label for="firstname">First Name</label></td>
                    <td><input type="text" id="firstname" name="firstname" value="#variables.str_firstname#"></td>
                    <td class="alignRight"><label for="lastname">Last Name</label></td>
                    <td><input type="text" id="lastname" name="lastname" value="#variables.str_lastname#"></td>
                </tr>

                <tr>
                    <td class="alignRight"> <label for="Education">Education</label></td>
                     <td>
                        <cfif NOT structKeyExists(url, "contactId")>
            <!-- Add Case -->
                        <select name="education" id="Education" class="selectBox">
                            <cfloop query="variables.qryGetEducationOptions">
                                <option value="#variables.qryGetEducationOptions.ID#">
                                    #variables.qryGetEducationOptions.education#
                                </option>
                             </cfloop>
                        </select>
                        <cfelse>
            <!-- Edit Case -->
                        <select name="education" id="Education" class="selectBox">
                            <cfloop query="qryGetEducationOptions">
                                <cfset selected = "">
                                <!-- Determine selected option -->
                                <cfloop query="getEducation">
                                    <cfif qryGetEducationOptions.education EQ getEducation.title>
                                        <cfset selected = "selected">
                                    </cfif>
                                </cfloop>
                                <option value="#qryGetEducationOptions.ID#" #selected#>
                                    #qryGetEducationOptions.education#
                                </option>
                            </cfloop>
                        </select>
                         </cfif>

                     </td>
                </tr>
                <tr>
                    <td class="alignRight"><label for="age">Age</label></td>
                    <td colspan="3"><input type="number" id="age" name="age" value="#variables.int_age#"></td>
                </tr>
                <tr>
                    <td class="alignRight"><label for="profile">Profile</label></td>
                    <td colspan="3"><textarea rows="4" cols="40" id="profile" name="profile" wrap="soft">#variables.str_profile#</textarea></td>
                </tr>

                <tr>
                    <td class="alignRight"><label for="address">Address</label></td>
                    <td colspan="3"><textarea rows="4" cols="40" id="address" name="address" wrap="soft">#variables.str_address#</textarea></td>
                </tr>

                <tr>
                    <td class="alignRight"><label for="phoneno">Phone Number</label></td>
                    <td colspan="3"><input type="text" id="phoneno" name="phoneno" maxlength="10" title="only numbers allowed" value="#variables.int_phone_no#"></td>
                </tr>

                <tr>
                    <td class="alignRight"><label>Gender</label></td>
                    <td colspan="3">
                        <input type="radio" id="genderM" name="gender" value="male" <cfif variables.str_gender is "male">checked="true"</cfif>><label for="genderM">Male</label>
                        <input type="radio" id="genderF" name="gender" value="female" <cfif variables.str_gender is "female">checked="true"</cfif>><label for="genderF">Female</label>
                    </td>
                </tr>

                <tr>
                    <td class="alignRight"><label>Hobbies</label></td>
                    <td colspan="3">
                    <cfif NOT structKeyExists(url, "contactId")>
                            <!-- Add Case -->
                            <input type="checkbox" id="reading" name="hobbies" value="Reading" 
                                <cfif variables.str_hobbies EQ "Reading">checked</cfif>>
                            <label for="reading">Reading</label>

                            <input type="checkbox" id="travel" name="hobbies" value="Travelling" 
                                <cfif variables.str_hobbies EQ "Travelling">checked</cfif>>
                            <label for="travel">Travelling</label>

                            <input type="checkbox" id="music" name="hobbies" value="Music" 
                                <cfif variables.str_hobbies EQ "Music">checked</cfif>>
                            <label for="music">Music</label>
                        <cfelse>
                            <!-- Edit Case -->
                            <input type="checkbox" id="reading" name="hobbies" value="Reading" 
                                <cfif ListFind(contactDetails.str_hobbies, "Reading", ",")>checked</cfif>>
                            <label for="reading">Reading</label>

                            <input type="checkbox" id="travel" name="hobbies" value="Travelling" 
                                <cfif ListFind(contactDetails.str_hobbies, "Travelling", ",")>checked</cfif>>
                            <label for="travel">Travelling</label>

                            <input type="checkbox" id="music" name="hobbies" value="Music" 
                                <cfif ListFind(contactDetails.str_hobbies, "Music", ",")>checked</cfif>>
                            <label for="music">Music</label>
                        </cfif>
                    </td>
                </tr>
                <tr>
                    <td class="alignRight" colspan="4">
                        <input type="reset" name="btnReset" value="Reset">
                        <button type="submit" value="submit" name="btnSave" class="btnreg" <cfif len(variables.success_msg) GT 0>disabled</cfif>>Save</button>
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