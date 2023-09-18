# Check if Git is installed
try {
    $gitPath = (Get-Command git).Source
    Write-Host "Git is installed at $gitPath, continuing..."
} catch {
    # Git is not installed, so we'll use winget to install it
    Write-Host "Git is not installed. Installing Git using winget..."
    winget install --id Git.Git -e --source winget

    # Check if the installation was successful
    if (-not (Get-Command git.exe -ErrorAction SilentlyContinue)) {
        Write-Host "Git installation failed. Please install Git manually and rerun the script."
        exit 1
    }

    Write-Host "Git has been successfully installed."
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

# Clone the CosmosOS repository using Git
if (-not (Test-Path -Path $cosmosPath -PathType Container)) {
    Write-Host "Cloning CosmosOS github..."
    git clone https://github.com/CosmosOS/Cosmos.git
    git clone https://github.com/CosmosOS/IL2CPU.git
    git clone https://github.com/CosmosOS/XSharp.git
    git clone https://github.com/CosmosOS/Common.git
} else {
    Write-Host "Updating..."
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

Write-Host "Script writen by upio, if anything breaks please contact me via discord: realpoiu"
Write-Host "Press any key to continue..."
$null = Read-Host
