

<cfoutput>tech2024
<cftry>
     <cfmail 
        from="amrutha.s@techversantinfotech.com" 
        to="amrutha.s@techversantinfotech.com" 
        subject="Test Email" 
        server="smtp.gmail.com"
        port="587"
         useTLS="yes"
        >
        This is a test email.
    </cfmail>


<cfcatch type="any">
        error found:sending mail
    <cf
</cfcatch>
</cftry>
</cfoutput>