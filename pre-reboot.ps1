#author: qwertyomen - 2024
# Pre-Reboot Reminder Email
# Get the server name
$hostName = hostname

# Define the email address to send notifications to
$toAddress = "alert@fqdn"

# Send the notification
Send-MailMessage -To $toAddress -From "$hostName@fqdn" -SmtpServer smtp.fqdn -Subject "$hostName - Scheduled Reboot" -Body "The server $hostName will reboot at midnight. Contact sysadmin to cancel scheduled reboot if you need services running through the night!"
