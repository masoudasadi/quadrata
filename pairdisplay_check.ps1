#$arg1 = "GAD_CED_G1000"

  param(
    [string]$group, # Uncommnet this line when inserted inside the maintenance machine
    [string]$horcm  # Uncommnet this line when inserted inside the maintenance machine
  )
    $horcm = $horcm.Trim()
	$raidcom += "raidcom"
	$args +=  " -login maintenance raid-mainte -I"
    $args = $args.replace('\n','')
    [string]$raidcomCommand = $raidcom+$args+$horcm
    $raidcomCommand
iex $raidcomCommand 

  $pairdisplay = "pairdisplay"  # Uncommnet this line when inserted inside the maintenance machine
  $pairArgs += " -g "   # Uncommnet this line when inserted inside the maintenance machine
  $pairArgs += $group   # Uncommnet this line when inserted inside the maintenance machine
  $pairArgs += " -fxce -CLI -I"  # Uncommnet this line when inserted inside the maintenance machine
  $pairArgs = $pairArgs.replace('\n','')   # Uncommnet this line when inserted inside the maintenance machine
  $pairArgs = $pairdisplay+$pairArgs+$horcm
  $pairArgs
 $string = (iex $pairArgs 2>&1) #out-file C:\Users\zabbix\pairdisplay_source.txt # Uncommnet this line when inserted inside the maintenance machine


#param( # Remove or comment this line when inserted inside the maintenance machine
#    $arg1, # Remove or comment this line when inserted inside the maintenance machine
#    $arg2 # Remove or comment this line when inserted inside the maintenance machine
#    ) # Remove or comment this line when inserted inside the maintenance machine
$regex = "PAIR" 

#$string = Get-Content -Raw C:\Users\zabbix\pairdisplay.txt # Remove or comment this line when inserted inside the maintenance machine




##############################################################################################

#& horcmstart.exe $horcm
#& raidcom -login maintenance raid-mainte -I$horcm

$matchedText = $string -split '\r?\n\r?\n' -match 'Group'
if($matchedText){
$Groups = $matchedText.Trim()

$match = $Groups.Trim() -split ('\n')

        $counter = 0
        $pairCount = 0
        $itemCount = 0

         foreach ($line in $match){
        	$counter += 1
            $item = $line -split '\s+|\t+'
            $pairItem = $item[9]

            if($pairItem){ 
                if($counter -gt 1){
                    
                    $pairItem
                    $itemCount += 1

                        if($pairItem -eq $regex){
                            $pairCount += 1
                            }
                    }
                }
          }


          if($pairCount -eq $itemCount){
                    #Write-Host "All paired"
                    
                    return 0 #| Out-File .\pairdisplay_out.txt
                    }else{

                    #Write-Host "Not Paired"
                    return 1 #| out-file .\pairdisplay_out.txt
                    }


}          

   