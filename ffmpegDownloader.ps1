# Define URL and destination folder
$ffmpegUrl = "https://www.gyan.dev/ffmpeg/builds/ffmpeg-release-essentials.zip"
$destFolder = "$HOME\FFmpeg"

# Create the destination folder if it doesn't exist
if (-not (Test-Path $destFolder)) {
    New-Item -ItemType Directory -Force -Path $destFolder
}

# Download FFmpeg
$zipFile = "$destFolder\ffmpeg.zip"
Invoke-WebRequest -Uri $ffmpegUrl -OutFile $zipFile

# Extract the zip file
Expand-Archive -LiteralPath $zipFile -DestinationPath $destFolder -Force

# Clean up the zip file
Remove-Item -Path $zipFile

# Add FFmpeg to user PATH
$userPath = [Environment]::GetEnvironmentVariable("Path", [EnvironmentVariableTarget]::User)
$userPath += ";$destFolder\bin"
[Environment]::SetEnvironmentVariable("Path", $userPath, [EnvironmentVariableTarget]::User)
