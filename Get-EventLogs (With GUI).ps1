$msg = " "
Add-Type -AssemblyName System.Windows.Forms
$form = New-Object System.Windows.Forms.Form
$form.ClientSize = '500,400'
$form.MinimumSize = '500,400'
$form.MaximumSize = '500,400'
$form.text = "Get Event Logs"
$form.BackColor = "#ffffff"

$bcalendar = New-Object Windows.Forms.MonthCalendar -Property @{ 
  ShowTodayCircle   = $false
  MaxSelectionCount = 1
}

$ecalendar = New-Object Windows.Forms.MonthCalendar -Property @{ 
  ShowTodayCircle   = $false
  MaxSelectionCount = 1
}

function selectBDate {
   
    $form.Controls.Add($bcalendar)
    $bcalendar.BringToFront()

    $bcalendar.Add_DateSelected({
         $bdate = $bcalendar.SelectionStart.toString('MM-dd-yyyy') -replace "-", "/"
            
        $sBox.text  = $bdate
        
        $form.Controls.Remove($bcalendar)
    })

}

function selectEDate {
   
    $form.Controls.Add($ecalendar)
    $ecalendar.BringToFront()

    $ecalendar.Add_DateSelected({
         $edisp = $ecalendar.SelectionStart.toString('MM-dd-yyyy') -replace "-", "/"
         $edate = $ecalendar.SelectionStart
        
        $eBox.text  = $edisp

        
        $form.Controls.Remove($ecalendar)
    })

    
 

}


$sLabel = New-Object System.Windows.Forms.Label
$sLabel.Location = New-Object System.Drawing.Point(10,20)
$sLabel.Size = New-Object System.Drawing.Size(280,20)
$sLabel.Text = 'Enter a start date in the form mm/dd/yyyy:'
$form.Controls.Add($sLabel)

$sBox = New-Object System.Windows.Forms.Button
$sBox.Location = New-Object System.Drawing.Point(10,50)
$sBox.Size = New-Object System.Drawing.Size(260,20)
$sbox.Add_Click({selectBDate})
$form.Controls.Add($sBox)


$eLabel = New-Object System.Windows.Forms.Label
$eLabel.Location = New-Object System.Drawing.Point(10,80)
$eLabel.Size = New-Object System.Drawing.Size(280,20)
$eLabel.Text = 'Enter an end date mm/dd/yyyy: '
$form.Controls.Add($eLabel)

$lLabel = New-Object System.Windows.Forms.Label
$lLabel.Location = New-Object System.Drawing.Point(10,180)
$lLabel.Size = New-Object System.Drawing.Size(400,20)

$lLabel.Text = 'Output: '
$form.Controls.Add($lLabel)



$logs = New-Object System.Windows.Forms.TextBox
$logs.Location = New-Object System.Drawing.Point(10,200)
$logs.Size = New-Object System.Drawing.Size(450,140)
$logs.WordWrap = $false;
$logs.Scrollbars = "Vertical", "Horizontal"
$logs.Multiline = $True;
$logs.Text = " "
$form.Controls.Add($logs)


$eBox = New-Object System.Windows.Forms.Button
$eBox.Location = New-Object System.Drawing.Point(10,100)
$eBox.Size = New-Object System.Drawing.Size(260,20)
$ebox.Add_Click({selectEDate})
$form.Controls.Add($eBox)

$select = New-Object System.Windows.Forms.ComboBox
$select.Location = New-Object System.Drawing.Point(200,135)
$select.Items.add("All")
$select.Items.add("Warning")
$select.Items.add("Error")
$select.Size = New-Object System.Drawing.Size(90,30)
$select.SelectedItem = "All"
$form.Controls.Add($select)

$save = New-Object System.Windows.Forms.SaveFileDialog
$save.DefaultExt = ".csv"
 
function run ($select)
{
    $logs.Text = "Loading ..."
    try {
    $beginDate = $sBox.Text + " 12:00:00"
    $endDate = $eBox.Text + " 23:59:00"
    $Begin = Get-Date -Date $beginDate
    $End = Get-Date -Date "$endDate"

    #checking dates are not entered incorrectly
    if ($begin -gt $end) {
        $logs.Text = "Start date greater than end date. Let's try that again"
    } else {
        if ($select -eq "All") {
        $logs.Text = Get-EventLog -LogName System -EntryType Error, Warning -After $Begin -Before $End | Out-String
        } elseif ($select -eq "Warning") {
        $logs.Text = Get-EventLog -LogName System -EntryType Warning -After $Begin -Before $End | Out-String
        } else {
        $logs.Text = Get-EventLog -LogName System -EntryType Error -After $Begin -Before $End | Out-String
        }
        
       
   }
    } catch {
        $logs.Text = "There was an error"
    }
   
   }


function exc {
    $logs.Text = "Loading ..."
    $Begin = $sBox.Text + " 12:00:00"
    $End = $eBox.Text + " 23:59:00"
    

     $beginpath = $sBox.Text -replace "/", "_"
     $endpath = $eBox.Text -replace "/", "_"

   
    
    $save.FileName = "log_$beginpath-$endpath"
    $path = $save.ShowDialog()
    $finalPath = $save.FileName

    if ($path) {
        Get-EventLog -LogName System -EntryType Error, Warning -After $Begin -Before $End | Export-csv -Path $save.FileName
        $logs.Text = "Logs Exported to $finalPath"
    }
    
    
    

}

$run = New-Object System.Windows.Forms.Button
$run.BackColor  = "#0B758F"
$run.text  = "Get logs"
$run.width = 90
$run.height = 30
$run.location = New-Object System.Drawing.Point(10,130)
$run.Add_Click({run($select.SelectedItem.ToString())})
$run.Font = 'Microsoft Sans Serif,10'
$run.ForeColor = "#ffffff"
$form.Controls.Add($run)

$exc = New-Object System.Windows.Forms.Button
$exc.BackColor  = "#008500"
$exc.text  = "Export"
$exc.width = 90
$exc.height = 30
$exc.location = New-Object System.Drawing.Point(100,130)
$exc.Add_Click({exc})
$exc.Font = 'Microsoft Sans Serif,10'
$exc.ForeColor = "#ffffff"
$form.Controls.Add($exc)


$form.Topmost = $true

$result = $form.ShowDialog()
