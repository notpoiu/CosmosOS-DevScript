# Check if Git is installed
try {
    $gitPath = (Get-Command git).Source
    Write-Host "`nGit is installed at $gitPath, Proceeding with cosmos dev kit installation...`n"
} catch {
    # Git is not installed, so we'll use winget to install it
    Write-Host "`nGit is not installed. Installing Git using winget...`n"
    winget install --id Git.Git -e --source winget

    # Check if the installation was successful
    if (-not (Get-Command git.exe -ErrorAction SilentlyContinue)) {
        Write-Host "`nGit installation failed. Please install Git manually and rerun the script.`n"
        exit 1
    }

    Write-Host "`nGit has been successfully installed, Proceeding with cosmos dev kit installation...`n"
}

# Define the path to the Documents folder
$documentsPath = [System.Environment]::GetFolderPath("MyDocuments")

# Define the name of the folder
$folderName = "CosmosOS"

# Combine the path and folder name
$folderPath = Join-Path -Path $documentsPath -ChildPath $folderName

# Create the folder if it doesn't exist
if (-not (Test-Path -Path $folderPath -PathType Container)) {
    New-Item -Path $folderPath -ItemType Directory
}

# Change directory to the CosmosOS folder
Set-Location -Path $folderPath

# Get Cosmos Path
$cosmosPath = Join-Path -Path $folderPath -ChildPath "Cosmos"


if (-not (Test-Path -Path $cosmosPath -PathType Container)) {
    Write-Host "`nCloning CosmosOS github...`n"

    # Clone the CosmosOS repository using Git
    git clone https://github.com/CosmosOS/Cosmos.git
    git clone https://github.com/CosmosOS/IL2CPU.git
    git clone https://github.com/CosmosOS/XSharp.git
    git clone https://github.com/CosmosOS/Common.git
} else {
    Write-Host "`nUpdating...`n"
    # Update the dependencies using Git
    Set-Location -Path "$folderPath\Cosmos"
    git pull
    Set-Location -Path "$folderPath\IL2CPU"
    git pull
    Set-Location -Path "$folderPath\XSharp"
    git pull
    Set-Location -Path "$folderPath\Common"
    git pull
}

# Change directory to the Cosmos folder
Set-Location -Path "$folderPath\Cosmos"

# Run the setup batch file
.\install-VS2022.bat

Write-Host "`nINSTALLER INFO:`nFolder Path: $folderPath`nSetup Batch Folder Location: $cosmosPath`n`n"
Write-Host "Script writen by upio, if anything breaks please contact me via discord: realpoiu"
Write-Host "Press any key to continue..."
$null = Read-Host
