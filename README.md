
# CSV to JSON Converter (PowerShell)

This PowerShell script converts a CSV file containing data for OATH TOTP Hardware tokens for importing into Entra ID  into a JSON format required to be used with the new Graph API based hardware token provisioning method.
## Features

- Converts CSV data into a structured JSON format.
- Supports fields like `serialNumber`, `manufacturer`, `model`, `secretKey`, and more.
- Includes customizable parameters for file paths.
- Escapes special characters in JSON context.
- Outputs readable or compressed JSON as needed.

## Requirements

- Windows PowerShell or PowerShell Core.
- Input CSV file with headers:
  - `upn`
  - `serial number`
  - `secret key`
  - `time interval`
  - `manufacturer`
  - `model`

## Installation

1. Clone this repository or download the script file.
2. Ensure that PowerShell is installed on your system.
3. Save the script as `Convert-OathCsvToJson.ps1`.

## Usage

1. Run the script in PowerShell:

   ```powershell
   .\Convert-OathCsvToJson.ps1 -csvFilePath "path/to/your/csvfile.csv"
   ```

2. The JSON file will be generated at the specified location.

## Example Input (CSV)

```csv
upn,serial number,secret key,time interval,manufacturer,model
user@token2.onmicrosoft.com,60234567,1234567890abcdef1234567890abcdef,30,Token2,c202
```

## Example Output (JSON)

```json
{
    "@context": "#$delta",
    "value": [
        {
            "@contentId": 1,
            "serialNumber": "60234567",
            "manufacturer": "Token2",
            "model": "c202",
            "secretKey": "1234567890abcdef1234567890abcdef",
            "timeIntervalInSeconds": 30,
            "hashFunction": "hmacsha1"
        }
    ]
}
```

## Notes

- Ensure the CSV file uses proper headers matching the expected input.
- Escape special characters (e.g., `#`) to ensure valid JSON output.
- Modify the JSON structure in the script if additional fields are needed.

## Troubleshooting

- **Error: File not found**:
  Verify the file paths for `$csvFilePath` and `$jsonFilePath`.

## License

This project is licensed under the MIT License. Feel free to use and modify as needed.

## More information about the import formats
 
CSV for Azure AD / Entra ID - https://www.token2.com/site/page/classic-hardware-tokens-for-office-365-azure-cloud-multi-factor-authentication
JSON for Azure AD / Entra ID - https://www.token2.com/site/page/classic-hardware-tokens-for-entra-id-mfa-graph-api-method-with-self-service-and-sha-256-tokens-support

