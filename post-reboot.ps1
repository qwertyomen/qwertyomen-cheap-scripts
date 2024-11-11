#author: qwertyomen - 2024
# Get the server name
$hostName = hostname

# Define the email address to send notifications to
$toAddress = "alert@fqdn"

# Send the notification
Send-MailMessage -To $toAddress -From "$hostName@fqdn" -SmtpServer smtp.fqdn -Subject "$hostName - Server Reboot" -Body "The server $hostName has successfully rebooted."
