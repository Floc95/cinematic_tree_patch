$rootFolder = "Sequences"
$rootPath = -join(".\", $rootFolder, "\")
$sequenceCount = 6
$shotCount = 100
$versionCount = 2
$exrCount = 100
$trigram = "RPR"

for ($ri = 1; $ri -le $sequenceCount; $ri++)
{
    $sequenceFolderName = "{0}_{1:d3}" -f $trigram, $ri
    New-Item $rootPath -Name $sequenceFolderName -ItemType Directory

    $sequencePath = -join($rootPath, $sequenceFolderName, "\")
    for ($si = 10; $si -le $shotCount; $si += 10)
    {
        $shotFolderName = "{0:d3}_{1:d4}" -f $ri, $si
        $shotFolderPath = -join($sequencePath, "\", $shotFolderName, "\")
        New-Item $sequencePath -Name $shotFolderName -ItemType Directory

        New-Item $shotFolderPath -Name "EXR" -ItemType Directory
        for ($vi= 1; $vi -le $versionCount; $vi++)
        {
            $movName = "{0}_{1:d3}_{2:d4}_FINAL_v{3:d3}.mov" -f $trigram, $ri, $si, $vi
            New-Item $shotFolderPath -Name $movName
            
            $exrPath = -join($shotFolderPath, "EXR\")
            for ($ei = 1000; $ei -le (1000 + $exrCount); $ei++)
            {
                $exrFileName = "{0}_{1:d3}_{2:d4}_FINAL_v{3:d3}_{4:d4}.exr" -f $trigram, $ri, $si, $vi, $ei
                New-Item $exrPath -Name $exrFileName
            }
        }
    }
}