# Copy recursively all PDF files from the source directory to the destination directory. Do not overwrite existing files.

$source = "C:\tmp\source"
$destination = "C:\tmp\destination"

# Get all PDF files recursively from the source directory
$files = Get-ChildItem -Path $source -Filter *.pdf -Recurse
# Get the total number of files to copy
$totalFiles = $files.Count

$counter = 0

# Copy each file from the subdirectories to the destination directory. Do not overwrite existing files.
# After each copied file, increment the counter, calculate the percentage of progress. Display information about the copied file, counter, and percentage of progress.
# If an error occurs during copying, display information about the error and continue copying the next files.
# After copying all files, display information about the completion of the copying process and the number of copied files.
foreach ($file in $files) {
    try {
        $destinationPath = Join-Path -Path $destination -ChildPath $file.Name
        if (-not (Test-Path -Path $destinationPath)) {
            Copy-Item -Path $file.FullName -Destination $destinationPath
            $counter++
            $progress = [math]::Round(($counter / $totalFiles) * 100, 2)
            Write-Progress -Activity "Copying PDF files" -Status "Copied: $($file.Name) $counter z $totalFiles $progress%" -PercentComplete $progress
        }
    } catch {
        Write-Host "Error while copying file: $($file.FullName) | Error: $_"
    }
}

Write-Progress -Activity "Copying PDF files" -Status "Copying completed. Copied $counter z $totalFiles files." -Complete
