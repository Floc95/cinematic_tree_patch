# Parameters
$rootPath = ".\Sequences"
$exrName = "EXR"
$newTrigram = "DND"

$sequences = Get-ChildItem -Directory -path $rootPath

foreach ($sequence in $sequences)
{
    $shots = Get-ChildItem -Directory -path $sequence.FullName
    
    foreach ($shot in $shots)
    {
        $movs = Get-ChildItem -Path $shot.FullName -Filter *.mov
        $exrFolderPath = -join($shot.FullName, "\", $exrName)
        $exrFiles = Get-ChildItem -Path $exrFolderPath -Filter *.exr

        foreach ($mov in $movs)
        {
            $movSplit = $mov.Name -split "[_.]"
            $version = $movSplit[$movSplit.Count - 2]
    
            # Create version folder
            New-Item $shot.FullName -Name $version -ItemType Directory
            $versionFolderPath = -join($shot.FullName, "\", $version)
            
            # Move mov file and rename trigram
            $movSplit[0] = $newTrigram
            # Add h264 in mov file name
            $movSplit[3] += "_h264"
            $movNewName = ($movSplit | select -SkipLast 1) -join "_"
            $movNewName += ".mov"
            $movNewPath = -join($versionFolderPath, "\", $movNewName)
            Move-Item -Path $mov.FullName -Destination $movNewPath
    
            # Create EXR folder
            New-Item $versionFolderPath -Name $exrName -ItemType Directory
        }

        # Move EXR files to new folders
        foreach ($exrFile in $exrFiles)
        {
            $exrSplit = $exrFile.Name -split "_"
            $version = $exrSplit[$exrSplit.Count - 2]
            $versionFolderPath = -join($shot.FullName, "\", $version)
            $newExrFolderPath = -join($versionFolderPath, "\", $exrName)
            # Rename trigram
            $exrSplit[0] = $newTrigram
            $exrNewName = $exrSplit -join "_"
            $exrNewPath = -join($newExrFolderPath, "\", $exrNewName)
            Move-Item -Path $exrFile.FullName -Destination $exrNewPath
        }

        # Delete old EXR folder
        Remove-Item $exrFolderPath
    }

    # Rename sequence folder for new trigram
    $sequenceSplit = $sequence.Name -split "_"
    $sequenceSplit[0] = $newTrigram
    $newSequenceName = $sequenceSplit -join "_"
    Rename-Item $sequence.FullName $newSequenceName
}