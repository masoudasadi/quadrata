#$arg1 = "GAD_CED_G1000"
param(
    $arg1,
    $arg2
    )
$regex = "\bPAIR\b"

$string = Get-Content -Raw C:\horcm\pairdisplay.txt
    

$matchedText = $string -split '\r?\n\r?\n' -match 'Group'
if($matchedText){
$Groups = $matchedText.Trim()


        $WordLength = $Groups | ConvertFrom-String | Get-Member | Measure-Object | Select-Object -Property "Count"| Select -ExpandProperty "Count"
        $Length = (Get-Content .\pairdisplay.txt ).Length
 
        $WordLength = $WordLength-4
 
        $newLength = $Length-1
        $totalLength = $totalLength + $newLength

        [string]$FinalCut = $Groups | Select-Object -Last $newLength


}

$textLine = Select-String -Path .\pairdisplay.txt -Pattern $arg1

foreach($line in $textLine) {

    if($line){
        $lineFull += 1
        $checkPair = $line | ConvertFrom-String  | Select-Object -Property P10 | Select -ExpandProperty "P10"

        Write-Host "Line " $lineFull " = " $checkPair 

            if($line -match $regex){
                $pairCount += 1
            }

        }


    



}


#Write-Host " lineFull is " $lineFull

if($lineFull -eq $pairCount){
    Write-Host "Result = All Paired"
}else{
    Write-Host "Result = Not Paired"
    }


Write-Host "Paired lines = " $pairCount
#Select-String -Pattern "\bPAIR\b"