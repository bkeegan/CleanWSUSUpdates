<# 
.SYNOPSIS 
	Simple wrapper around Invoke-WsusServerCleanup cmdlet
.DESCRIPTION 
	Simple wrapper around Invoke-WsusServerCleanup cmdlet. Try/Catch statement to catch for errors. Sends email report with output of command or output of $error if there was an error.
.NOTES 
    File Name  : CleanWSUSUpdates.ps1
    Author     : Brenton keegan - brenton.keegan@gmail.com 
    Licenced under GPLv3  
.LINK 
	https://github.com/bkeegan/CleanWSUSUpdates
    License: http://www.gnu.org/copyleft/gpl.html
.EXAMPLE 
	CleanWSUSUpdates -to "reports@contoso.com" -from "reports@contoso.com" -smtp "mail.contoso.com"

#> 

Function CleanWSUSUpdates
{
	[cmdletbinding()]
	Param
	(
		[parameter(Mandatory=$true)]
		[alias("To")]
		[string]$emailRecipient,
		
		[parameter(Mandatory=$true)]
		[alias("From")]
		[string]$emailSender,
		
		[parameter(Mandatory=$true)]
		[alias("smtp")]
		[string]$emailServer,
		
		[parameter(Mandatory=$false)]
		[alias("Subject")]
		[string]$emailSubject="WSUS Cleanup",
		
		[parameter(Mandatory=$false)]
		[alias("body")]
		[string]$emailBody="WSUS Cleanup Report"
	)
	
	$cleanFailed = $false
	Try
	{
		$results = Invoke-WsusServerCleanup -CleanupObsoleteUpdates
	}
	Catch
	{
		$cleanFailed = $true
		$results = $error
	}
	
	$emailBody = $results
	if($cleanFailed)
	{
		$emailSubject += " - FAILED"
	}
	else
	{
		$emailSubject += " - SUCCESS"
	}
	
	
	Send-MailMessage -To $emailRecipient -Subject $emailSubject -smtpServer $emailServer -From $emailSender -body $emailBody
	
}


CleanWSUSUpdates -to "WorkstationAlerts@limcollege.edu" -from "WSUSCleanUpReport@limcollege.edu" -smtp "excas01.limcollege.edu"
