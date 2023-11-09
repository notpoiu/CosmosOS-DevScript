# Define URL and destination folder
$ffmpegUrl = "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip"
$destFolder = "$HOME\FFmpeg"

# Check if FFmpeg is already installed
if (Test-Path $destFolder) {
    $userResponse = Read-Host "FFmpeg is already installed. Do you want to download a newer version? (Y/N)"
    if ($userResponse -notmatch "^[Yy]") {
        Write-Host "Skipping download. Setting PATH only."

        # Get the first directory inside the FFmpeg folder
        $firstDirectory = Get-ChildItem -Path $destFolder -Directory | Select-Object -First 1

        # Construct the path to the bin directory
        $ffmpegBinPath = Join-Path $firstDirectory.FullName "bin"

        # Add FFmpeg to user PATH
        $userPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)
        if (-not $userPath.Contains($ffmpegBinPath)) {
            $userPath += ";$ffmpegBinPath"
            [Environment]::SetEnvironmentVariable("Path", $userPath, [EnvironmentVariableTarget]::User)
        }
        exit
    }
    else {
        Remove-Item -Recurse -Force $destFolder
    }
}

# If the user opts to download or FFmpeg was not previously installed

# Create the destination folder
New-Item -ItemType Directory -Force -Path $destFolder

# Download FFmpeg
$zipFile = "$destFolder\ffmpeg.zip"
Invoke-WebRequest -Uri $ffmpegUrl -OutFile $zipFile

# Extract the zip file
Expand-Archive -LiteralPath $zipFile -DestinationPath $destFolder -Force

# Clean up the zip file
Remove-Item -Path $zipFile

# Get the first directory inside the FFmpeg folder
$firstDirectory = Get-ChildItem -Path $destFolder -Directory | Select-Object -First 1

# Construct the path to the bin directory
$ffmpegBinPath = Join-Path $firstDirectory.FullName "bin"

# Add FFmpeg to user PATH
$userPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)
if (-not $userPath.Contains($ffmpegBinPath)) {
    $userPath += ";$ffmpegBinPath"
    [Environment]::SetEnvironmentVariable("Path", $userPath, [EnvironmentVariableTarget]::User)
}
