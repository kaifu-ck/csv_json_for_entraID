$csvFilePath = "csv.csv"  # Update with your CSV file path
$jsonFilePath = "json.json"        # Update with your desired JSON output file path

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
