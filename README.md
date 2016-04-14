# CleanWSUSUpdates

Simple wrapper around Invoke-WsusServerCleanup cmdlet. This script wrapped the cmdlet in a try/catch statement and sends an email report of the result of the cmdlet or the contents of the $error variable if an error is detected.
