#### Argument select if INST for instances output and REPL for Replication output

 	
$param1=$args[0] # Get One argument to check if it's INST or REPL otherwise returns "Wrong Param"
if ($param1 -contains "INST") {
    #Write-Host "INST"
}
elseif ($param1 -contains "REPL") {
    #Write-Host "REPL"
} else {
    Write-Host "No Parameter Selected, Enter INST or REPL as argument"
}

####################################################### Get files from Windows Directory and puts in an array

$files = @()
(Get-ChildItem -Path C:\Windows\ -Name) | foreach{

    $files += $_

    }

###################################################### Get All files containing horcm700 till horcm 999

    foreach ($dirCode in $files) { 

        $horcm = $dirCode | Select-String -Pattern '(horcm)([7-9][0-5][0-9])'
        if($horcm){
            $horcmLogs = $horcmLogs + 1
            }
    }
######### End of Loop




############## Start of Output
$output += '['
############################




####################################### Loop over files in Directory (dirCode)

foreach ($dirCode in $files) {  


    [string]$horcm = $dirCode | Select-String -Pattern '(horcm)([7-9][0-5][0-9])'



        ############################ Start of the Json Loop

        if($horcm){ #If horcm does exist follow the commands
            
            $horcmNo = $horcm.Substring(5, 3)

            $horcmIndex = $horcmIndex + 1 

            # Take the Paragraph including the instances
            $Groups = (Get-Content -Raw C:\Windows\$horcm) -split '\r?\n\r?\n' -match 'HORCM_INST'

            # Take the Serial number from each file
            [string]$CMD = (Get-Content C:\Windows\$horcm) -split "`n`r" -match '(CMD-)([0-9]{1,6})'


            # clean the output from newlines
            $matchP = $Groups -split ('\n')
            $match = $matchP -replace '^\r'

            # Reset the counters
            $counter = 1
            $lineCount = 1

            # Get each line of the instance and count them - put in linecount variable
            foreach ($line in $match){
                if($lineCount){
                    $lineCount += 1
                    }
                }
            


            # Loop over CMD match



                        
            


            
            # Loop over lines in instance and process them 
            foreach ($line in $match){

                     if($line){


                        if($param1 -contains "INST"){
                            
                            $groupName = $line -split '\s+|\t+'


                            $matched = $CMD -match 'CMD-([0-9]{6})-'
                            if ($matched) {
                                $SerialNo=$matches[1]
                                }
                            

                            if($counter -ge 3){ 
                                                
                                $output +=  '{"{#GROUP}":"'
                                $output +=  $groupName[0]
                                $output += '","{#HORCM}":'
                                $output +=  $horcmNo
                                $output += ',"{#SERIAL}":'
                                $output +=  $SerialNo 
                                $output += '}'
                                
                                }   # End of Main json if($counter -ge 3)
                                
                                $counter += 1 #Loop over elements counter


                              if (($horcmIndex -lt $horcmLogs) -or ($counter -lt $lineCount)){

                                    if($counter -gt 3){

                                        $output += ','
                                        }
                        
                                }#End of First If   
                                                         
                            } # End of Param1 if of INST

                        if($param1 -contains "REPL"){
                            
                            $groupName = $line -split '\s+|\t+'

                            

                            if($counter -ge 3){ 
                                                
                                $output +=  '{"{#HORCM}":'
                                $output +=  $horcmNo
                                $output += '}'
                                
                                }   # End of Main json if($counter -ge 3)
                                
                                $counter += 1 #Loop over elements counter


                              if (($horcmIndex -lt $horcmLogs) -or ($counter -lt $lineCount)){

                                    if($counter -gt 3){

                                        $output += ','
                                        }
                        
                                }#End of First If   
                                                         
                            } # End of Param1 if of REPL
                      


                     } # End of if($line)

                } # End of foreach ($line in $match) Loop



            } #End of if(horcm) loop


        ############################ Stop of the Json Loop

}####################################### End of Loop over files in Directory


$output += ']'
Write-Host $output