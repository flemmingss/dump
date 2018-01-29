

function Set-DomoticzCredentials {
    
    Param(
    [Parameter(Mandatory=$True)][string]$Username,
    [Parameter(Mandatory=$True)][string]$Password
         )

    $Domoticz_PairUsernameAndPassword = "${Username}:${Password}"
    $Domoticz_Bytes = [System.Text.Encoding]::ASCII.GetBytes($Domoticz_PairUsernameAndPassword)
    $Domoticz_Base64 = [System.Convert]::ToBase64String($Domoticz_Bytes)
    $Domoticz_BasicAuthValue = "Basic $Domoticz_Base64"
    $global:Domoticz_Headers = @{ Authorization = $Domoticz_BasicAuthValue }
    }



    function Set-DomoticzAddress 
    {
     Param(
     [Parameter(Mandatory=$True)][string]$uri #format: http://10.0.24.2:8080/
        )
    $global:Domoticz_address = $Uri 
    }




function Set-DomoticzDevice ($idx, $value)
    {
	$Domoticz_json = "json.htm?type=command&param=udevice&idx=$idx&nvalue=0&svalue=$value"
	Invoke-RestMethod -Method Get -Uri "$Domoticz_Address$Domoticz_json" -Headers $Domoticz_Headers
    }



function Get-DomoticzUserVariable ($idx) #parameter $idx should not be mandatory
        {
        if ($idx -eq $null)
                {
                $Domoticz_json = "json.htm?type=command&param=getuservariables"
                }
                else
                {
      	        $Domoticz_json = "json.htm?type=command&param=getuservariable&idx=$idx"
                }


	    (Invoke-RestMethod -Method Get -Uri "$Domoticz_Address$Domoticz_json" -Headers $Domoticz_Headers).result
        }   


function Get-DomoticzDeviceStatus {

    Param(
    [string]$idx = $null,
    [ValidateSet("all","light","weather","temp","utility")][string]$type = "all",
    [ValidateSet("all","true","false")][string]$used = "all"
    )

    #No parameter is manatory. if no paramter is used all devices are listed
    
    if ($idx -notlike $null) #If parameter -IDX is set
        {        
        $Domoticz_json = "json.htm?type=devices&rid=$idx"
        }

    else #If parameter -IDX not set
        {           
        $Domoticz_json = "json.htm?type=devices&filter=$type&used=$used"
        }      

	(Invoke-RestMethod -Method Get -Uri "$Domoticz_Address$Domoticz_json" -Headers $Domoticz_Headers).result
    }
