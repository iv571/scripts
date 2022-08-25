<#

Author: Iyan Velji

Date created: May 18, 2022

The following program gets an event log from the system for a certain time period and gives the option of exporting to a csv

#>

 

$running =  $TRUE;

 

#function to get logs from a certain time period

function get-logs {

$stdatestr = read-host "Enter a start date in the form mm/dd/yyyy"

$eddatestr = read-host "Enter an end date mm/dd/yyyy"

$Begin = Get-Date -Date "$stdatestr 12:00:00"

$End = Get-Date -Date "$eddatestr 23:59:00"

 

#checking dates are not entered incorrectly

if ($begin -gt $end) {

    write-host "Start date greater than end date. Let's try that again" -fore magenta

} else {

 

$eventlog = Get-EventLog -LogName System -EntryType Error, Warning -After $Begin -Before $End

Get-EventLog -LogName System -EntryType Error, Warning -After $Begin -Before $End

 

$csv = read-host "Export to CSV [y/n]?"

 

if ($csv -eq 'y') {

    $num = get-random -maximum 1000

    $eventlog | Export-csv -Path "C:\temp\log$num.csv"

    write-host "Done. Check your temp folder." -fore green

    $running = $FALSE;

} elseif ($csv -eq 'n') {

     write-host "Ok" -fore green

     $running = $FALSE;

} else {

    write-host "Input unknown" -fore yellow

}

 

}

 

 

}

 

#Try-catch block for errors

 

while ($running) {

Try{

    $option = read-host "Get logs [y/n]?"

   

    if ($option -eq "y") {

        get-logs

    } elseif ($option -eq "n") {

        break

    } else {

         write-host "Input unknown" -fore yellow

    }

    }

Catch{

                Write-Host 'Not a valid date, starting script again' -fore magenta

    start-sleep -seconds 1

    write-host '.' -fore magenta

    start-sleep -seconds 1

    write-host '.' -fore magenta

    start-sleep -seconds 1

    write-host '.' -fore magenta

    }

 

}
