
$files = @()
(Get-ChildItem -Path C:\horcm\ -Name) | foreach{

    $files += $_

    }
    
 
    $line += '['


    foreach ($dirCode in $files) { 

        $horcm = $dirCode | Select-String -Pattern '(horcm[\d+]+)'
        if($horcm){
            $f = $f + 1
            }
    
    }


foreach ($dirCode in $files) { 


    [string]$horcm = $dirCode | Select-String -Pattern '(horcm[\d+]+)'
    
    
    if($horcm){
        $v = $horcm.Substring(5, 3)

        $s = $s + 1 
    $string = Get-Content -Raw C:\horcm\$horcm
    

    $matchedText = $string -split '\r?\n\r?\n' -match 'HORCM_INST'
    if($matchedText){
    $Groups = $matchedText.Trim()
    #$Groups | Out-File C:\horcm\instances.txt

    
        $WordLength = $Groups | ConvertFrom-String | Get-Member | Measure-Object | Select-Object -Property "Count"| Select -ExpandProperty "Count"
        $Length = (Get-Content .\instances.txt ).Length
 
        $WordLength = $WordLength-4
 
        $newLength = $Length-2
        $totalLength = $totalLength + $newLength


        #[string]$FinalCut = Get-Content .\instances.txt | Select-Object -Last $newLength
        [string]$FinalCut = $Groups | Select-Object -Last $newLength


        for ($i = 5 ; $i -lt $WordLength ; $i++) {
                
            $g=$i-2

            if ($g%3 -eq 0){

                $LastCut = $Groups | ConvertFrom-String  | Select-Object -Property P$i | Select -ExpandProperty "P$i"
                
                #Write-Host '{"{#GROUP}":"' $LastCut '"},{"{#HORCM}":"' $v '"}'

                $line +=  '{"{#GROUP}":"'
                $line +=  $LastCut 
                $line += '","{#HORCM}":'
                $line +=  $v 
                $line +=  '}'

                
                $q = $i + 3

                    if (($s -lt $f) -or ($q -lt $WordLength)){

                        $line += ','
                            }
                }#End of First If

        }#End of for-statement


      }#End of If-Groups
           
   }#End of If

}


$line += ']'

$line | Out-File .\instances.txt

Write-Host $line.Trim()

