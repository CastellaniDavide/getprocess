<#

.SYNOPSIS  
    Elenco processi e loro caratteristiche
.DESCRIPTION  
    Visualizza l'elenco dei processi in esecuzione 

.NOTES  
    File Name  : get_process.ps1  
    Author     : Castellai Davide - @DavideC03
    version    : v01.04
    Requires   : PowerShell V5, .NET v5

    https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/win32-process
    https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/win32-thread

#>

param (
    [String]$flussiFolder = "..\\flussi"
    ,[String]$logFile = "..\\..\\log\\trace.log"
    ,[String]$thread = ""
    ,[String]$harperLink = ""
    ,[String]$harperToken = ""
    ,[String]$harperTable = "getprocess"
    ,[Parameter(Mandatory=$false)] [ValidateSet($false,$true)][Bool]$harper = $false
    ,[Parameter(Mandatory=$false)] [ValidateSet($false,$true)][Bool]$GUI = $true
    ,[Parameter(Mandatory=$false)] [ValidateSet($false,$true)][Bool]$booldebug = $false
)

$programName = "getprocess.ps1"
$ECode = (New-TimeSpan -Start (Get-Date "01/01/1970") -End (Get-Date)).TotalSeconds
$global:line = 1

Function fnInitDB{
    # Create dev
    Invoke-WebRequest -Headers @{"Content-Type" = "application/json"; "Authorization" = "Basic $harperToken"} `
                  -Method POST `
                  -Body (@{"operation" = "create_schema"; "schema" = "dev"}|ConvertTo-Json) `
                  -Uri $harperLink `
                  -ContentType application/json

    # Create table
    Invoke-WebRequest -Headers @{"Content-Type" = "application/json"; "Authorization" = "Basic $harperToken"} `
                  -Method POST `
                  -Body (@{"operation" = "create_table"; "schema" = "dev"; "table" =  $harperTable; "hash_attribute" = "id"}|ConvertTo-Json) `
                  -Uri $harperLink `
                  -ContentType application/json

    # Add params
    foreach ($attribute in "PCName", "Handles", "processName", "processID", "processCPU", "processHandless", "ThreadState", "MessageTime", "MessageTimeForUsers") {
        Invoke-WebRequest -Headers @{"Content-Type" = "application/json"; "Authorization" = "Basic $harperToken"} `
                  -Method POST `
                  -Body (@{"operation" = "create_attribute"; "schema" = "dev"; "table" = $harperTable; "attribute" = $attribute}|ConvertTo-Json) `
                  -Uri $harperLink `
                  -ContentType application/json
    }
}

Function fnDB{
    param(
        # PCName,Handles,processName,processID,processCPU,processHandless,ThreadState,MessageTime,MessageTimeForUsers
        [String]$PCName = $env:computername,
        [String]$Handles = "",
        [String]$processName = "",
        [String]$processID = "",
        [String]$processCPU = "",
        [String]$processHandless = "",
        [String]$ThreadState = "",
        [String]$MessageTime = (New-TimeSpan -Start (Get-Date "01/01/1970") -End (Get-Date)).TotalSeconds,
        [String]$MessageTimeForUsers = (Get-Date).ToString("dd/MM/yyyy HH:mm:ss")
    )

    $record = @{
        "PCName" = $PCName;
        "Handles" = $Handles;
        "processName" = $processName;
        "processID" = $processID;
        "processCPU" = $processCPU;
        "processHandless" = $processHandless;
        "ThreadState" = $ThreadState;
        "MessageTime" = $MessageTime;
        "MessageTimeForUsers" = $MessageTimeForUsers
    }

    $Response = Invoke-WebRequest -Headers @{"Content-Type" = "application/json"; "Authorization" = "Basic $harperToken"} `
                -Method POST `
                -Body (@{"operation" = "insert"; "schema" = "dev"; "table" = $harperTable; "records" = @($record)}|ConvertTo-Json) `
                -Uri $harperLink `

    if($booldebug) {
        fnLog -msg $Response.Content
    }
}

Function fnInitFiles{
    if (!(Test-Path $logFile))
    {
        New-Item -path $logFile -type "file"
        Add-Content $logFile "Title,PCName,ExecutionCode,Message,ProcessID,ThreadID,MessageTime,MessageTimeForUsers"
    }
    
    if (!(Test-Path "$flussiFolder\\getprocess.csv"))
    {
        New-Item -path "$flussiFolder\\getprocess.csv" -type "file"
        Add-Content "$flussiFolder\\getprocess.csv" "PCName,Handles,processName,processID,processCPU,processHandless,MessageTime,MessageTimeForUsers"
    }
}

Function fnLog{
    param(
        [String]$title = $programName,
        [String]$PCName = $env:computername,
        [String]$ExecutionCode = $ECode,
        [String]$msg = "",
        [String]$ProcessID = $PID,
        [String]$ThreadID = [System.Threading.Thread]::CurrentThread.ManagedThreadId,
        [String]$MessageTime = (New-TimeSpan -Start (Get-Date "01/01/1970") -End (Get-Date)).TotalSeconds,
        [String]$MessageTimeForUsers = (Get-Date).ToString("dd/MM/yyyy HH:mm:ss")
    )

    Add-Content $logFile "$title,$PCName,$ExecutionCode,`"$msg`",$ProcessID,$ThreadID,$MessageTime,$MessageTimeForUsers"
}

Function fnCSV{
    param(
        # PCName,Handles,processName,processID,processCPU,processHandless,ThreadState,MessageTime,MessageTimeForUsers
        [String]$PCName = $env:computername,
        [String]$Handles = "",
        [String]$processName = "",
        [String]$processID = "",
        [String]$processCPU = "",
        [String]$processHandless = "",
        [String]$ThreadState = "",
        [String]$MessageTime = (New-TimeSpan -Start (Get-Date "01/01/1970") -End (Get-Date)).TotalSeconds,
        [String]$MessageTimeForUsers = (Get-Date).ToString("dd/MM/yyyy HH:mm:ss")
    )

    Add-Content "$flussiFolder\\getprocess.csv" "$PCName,$Handles,$processName,$processID,$processCPU,$processHandless,$ThreadState,$MessageTime,$MessageTimeForUsers"
}

Function fnWrite{
    param(
        [String]$msg = ""
    )
    $global:line++

    if ($GUI){
        $var_console.Content += $msg + "`n"
        $var_console.Height = $global:line * 16
    }
    else{
        Write-Output -msg $msg
    }
    
    fnLog -msg $msg
}

Function fnListProcess {   

	if ($booldebug -eq $true) { fnWrite -msg "Esecuzione fnListProcess"}
       
    if ([string]::IsNullOrEmpty($thread)){
        $processes = Get-Process
    } else {
        $processes = Get-Process -Name $thread
    }

    foreach ($process in $processes) {
        # Handles,processName,processID,processCPU,processHandless,ThreadState

        # Take infos
        $handle = $process.Handles
        $processname = $process.ProcessName
        $thread = Get-CimInstance Win32_Thread -Filter "handle = $handle"
        $processID = $process.Id
        $processCPU = $process.CPU
        $processHandless = $process.Handles
        $threadState = $thread.ThreadState

        # Print infos
        fnWrite -msg "$processname`:"
        if(-not ([string]::IsNullOrEmpty($handle))) {
            fnWrite -msg "- Handle: $handle"
        }
        if(-not ([string]::IsNullOrEmpty($processID))) {
            fnWrite -msg "- Process Id: $processID"
        }
        if(-not ([string]::IsNullOrEmpty($processCPU))) {
            fnWrite -msg "- CPU: $processCPU"
        }
        if(-not ([string]::IsNullOrEmpty($processHandless))) {
            fnWrite -msg "- Hangles: $processHandless"
        }
        if(-not ([string]::IsNullOrEmpty($threadState))) {
            fnWrite -msg "- ThreadState: $threadState"
        }
        fnWrite -msg ""

        # Save to CSV the infos
        fnCSV -Handles $handle -processName $processname -processID $processID -processCPU $processCPU -processHandless $processHandless -ThreadState $threadState
        
        if ($harper) {
            fnDB -Handles $handle -processName $processname -processID $processID -processCPU $processCPU -processHandless $processHandless -ThreadState $threadState
        }
    }
}

Function fnMain()
{
    Clear-Host

    if ($harper) {
        fnInitDB
    }
    
    fnWrite -msg "Start $programname - powershell version $ver"

    $ver = $Host.Version
    
    fnWrite -msg "${Get-Date}"

    fnInitFiles
    fnListProcess

    if ($GUI) {
        Clear-Host
    }
}

if ($GUI){

    Add-Type -AssemblyName PresentationFramework

    #where is the XAML file?
    $xamlFile = "..\\..\\GUI\\WpfApp1\\MainWindow.xaml"

    #create window
    $inputXML = Get-Content $xamlFile -Raw
    $inputXML = $inputXML -replace 'mc:Ignorable="d"', '' -replace "x:N", 'N' -replace '^<Win.*', '<Window'
    [xml]$XAML = $inputXML
    #Read XAML

    $reader = (New-Object System.Xml.XmlNodeReader $xaml)
    try {
        $window = [Windows.Markup.XamlReader]::Load( $reader )
    }
    catch {
        Write-Warning $_.Exception
        throw
    }

    $xaml.SelectNodes("//*[@Name]") | ForEach-Object {
        try {
            Set-Variable -Name "var_$($_.Name)" -Value $window.FindName($_.Name) -ErrorAction Stop
        } catch {
            throw
       }
    }

    $var_startBtn.Add_Click({
        # Set variabiles
        $booldebug = $var_verbose.IsChecked;
        $flussiFolder = $var_flussi.Text;
        $logFile = $var_log.Text;
        $thread = $var_thread.Text;
        $harper = $var_harper.IsChecked;
        $harperLink = $var_harperLink.Text;
        $harperToken = $var_harperToken.Password;
        $harperTable = $var_harperTable.Text;

        # Start main
        fnMain
    })

    $Null = $window.ShowDialog();
}

if (-Not $GUI)
{
    fnMain;
}

