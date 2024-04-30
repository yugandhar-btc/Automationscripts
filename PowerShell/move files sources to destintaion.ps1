
#move files from subfolders within the source directory to corresponding destination folders.

# Define the source directory
$source = "C:\Users\Yugandhar\Desktop\scripts1\sources\Data"

# Define the root destination directories
$rootDestinations = @(
    "C:\Users\Yugandhar\Desktop\scripts1\Destination1\Data",
    "C:\Users\Yugandhar\Desktop\scripts1\Destination2\Data",
    "C:\Users\Yugandhar\Desktop\scripts1\Destination3\Data"
)

# Set the threshold for the number of files in the destination folder
$threshold = 3

# Maximum number of files to move from source to each destination
$maxFilesToMovePerDestination = 4

# Counter to track the total number of files moved
$totalFilesMovedCount = 0

# Check if the source folder exists
if (Test-Path -Path $source -PathType Container) {
    # Loop through each subfolder in the source directory
    Get-ChildItem -Path $source -Directory | ForEach-Object {
        $subfolder = $_.Name
        
        # Loop through each destination folder
        foreach ($destination in $rootDestinations) {
            $destinationFolder = Join-Path -Path $destination -ChildPath $subfolder

            # Check if the destination folder exists, and create it if not
            if (-not (Test-Path -Path $destinationFolder -PathType Container)) {
                New-Item -Path $destinationFolder -ItemType Directory -Force
            }

            # Check if the number of files in the destination folder exceeds the threshold
            $destinationFileCount = (Get-ChildItem -Path $destinationFolder -File).Count
            if ($destinationFileCount -ge $threshold) {
                Write-Host "Destination folder $destinationFolder has $destinationFileCount files which exceeds the threshold of $threshold. Skipping."
                continue
            }

            # Get files in the current subfolder of the source and limit the number to move
            $filesToMove = Get-ChildItem -Path $_.FullName | Select-Object -First $maxFilesToMovePerDestination

            # Counter to track the number of files moved to this destination folder
            $filesMovedCount = 0

            # Move each file to the destination folder
            foreach ($file in $filesToMove) {
                Move-Item -Path $file.FullName -Destination $destinationFolder -Force
                $filesMovedCount++
                $totalFilesMovedCount++
            }

            Write-Host "$filesMovedCount files moved to $destinationFolder successfully."
        }
    }

    Write-Host "Total $totalFilesMovedCount files moved successfully."
} else {
    Write-Host "Source folder does not exist."
}
