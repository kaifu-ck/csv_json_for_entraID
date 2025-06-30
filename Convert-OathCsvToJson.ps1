<#
.SYNOPSIS
    This PowerShell script converts a CSV file containing data for OATH TOTP Hardware tokens for importing into Entra ID into a JSON format required to be used with the new Graph API based hardware token provisioning method.
.LINK
    https://github.com/token2/csv_json_for_entraID/blob/main/README.md
.EXAMPLE
    .\Convert-OathCsvToJson.ps1 -csvFilePath "path/to/your/csvfile.csv"
#>
[CmdletBinding()]

Param(
    [Parameter(Mandatory=$true,HelpMessage="Path of your legacy CSV file.")]
    [ValidateScript({
        Test-Path -Path "$_";
    }, ErrorMessage="`"{0}`" does not seem to be a valid path to your CSV file.")]
    # Path to your legacy Entra ID CSV for OATH TOTP Hardware tokens import.
    [System.IO.FileInfo]$csvFilePath,
    [Parameter(HelpMessage="Desired JSON output file path.")]
    # Output destination for the generated Graph API JSON file.
    # Placed next to the input file if no JSON path is given.
    [string]$jsonFilePath = (Join-Path -Path $csvFilePath.Directory -ChildPath "$($csvFilePath.BaseName).json"),
    [Parameter(HelpMessage="Hash function of your seeds.")]
    [ValidateSet("hmacsha1","hmacsha256")]
    # Pass "hmacsha256" if your seeds are SHA256-hashed.
    [string]$hashFunction="hmacsha1"
)

Write-Verbose ("Converting data from `"{0}`" to destination `"{1}`"." -f $csvFilePath,$jsonFilePath);

# Read the CSV file into an array of objects
$intervalTypes = @{
    $true = "time interval";
    $false = "timeinterval";
};
$csvData = Import-Csv -Path $csvFilePath
if(($null -ne $csvData) -and ($csvData.Length -gt 0)) {
    Write-Verbose "$($csvData.Length) input rows";
    $spacedTime = [bool]$csvData[0].PSObject.Properties["time interval"];
    Write-Debug ("Input file is using `"{0}`" column name for time intervals." -f $intervalTypes[$spacedTime]);

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
            "timeIntervalInSeconds" = [int]$row.($intervalTypes[$spacedTime])
            "hashFunction" = $hashFunction
        }
        $contentId++
    }
    

    # Convert the data to JSON format with indentation
    $jsonOutput = $jsonData | ConvertTo-Json -Depth 10



    # Save the JSON output to a file
    Set-Content -Path $jsonFilePath -Value $jsonOutput

    Write-Output "JSON file generated at: $jsonFilePath"
} else {
    Write-Error "Could not parse input CSV or no rows in CSV."
}
