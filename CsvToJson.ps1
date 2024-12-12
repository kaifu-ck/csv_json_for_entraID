[CmdletBinding()]

Param(
    [Parameter(Mandatory=$true)][System.IO.FileInfo]$csvFilePath,
    [Parameter()][System.IO.FileInfo]$jsonFilePath
    )

# $csvFilePath = "csv.csv"  # Update with your CSV file path
# $jsonFilePath = "json.json" # Update with your desired JSON output file path

# Create the json file in the csv file parent directory with the same name if none passed as parameter.
if ( [string]::IsNullOrEmpty($jsonFilePath) ){
    $parentPath = Split-Path $csvFilePath -Parent
    $name = "{0}.json" -f $([IO.FileInfo]$(Split-Path $csvFilePath -Leaf)).BaseName
}

$jsonFilePath = (Join-Path $parentPath $name)

# Read the CSV file into an array of objects
$csvData = Import-Csv -Path $csvFilePath

# Initialize the JSON structure
$jsonData = @{
    "@context" = "#`$delta"

    "value" = @()
}

# Counter for contentId
$contentId = 1

# Iterate through each row of the CSV and map it to the desired JSON structure
foreach ($row in $csvData) {
    $jsonData.value += [PSCustomObject]@{
        "@contentId" = $contentId
        "serialNumber" = $row."serial number"
        "manufacturer" = $row."manufacturer"
        "model" = $row."model"
        "secretKey" = $row."secret key"
        "timeIntervalInSeconds" = [int]$row."timeinterval"
        "hashFunction" = "hmacsha1"
    }
    $contentId++
}
 

# Convert the data to JSON format with indentation
$jsonOutput = $jsonData | ConvertTo-Json -Depth 10



# Save the JSON output to a file
Set-Content -Path $jsonFilePath -Value $jsonOutput

Write-Host "JSON file generated at: $jsonFilePath"

