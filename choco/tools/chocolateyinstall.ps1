# Variabiles
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$ppath = "C:\Progra~1\getprocess"
$path = "$ppath\__init__"
echo "My personal path is: $ppath"
echo "My exe path id $exepath"

# Set folder and rename exe file
New-Item -ItemType Directory -Force -Path $ppath
Copy-Item -Path "$toolsDir\dist\__init__\*" -Destination "$ppath\" -Recurse
Rename-Item -Path "$ppath\__init__.exe" -NewName "$ppath\getprocess.exe"

# Add Path
$new_path = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
if ($new_path -notlike "*$ppath*")
{
	$new_path += ";$ppath"
	$new_path = $new_path.Replace(";;", ";")
	Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $new_path
}
