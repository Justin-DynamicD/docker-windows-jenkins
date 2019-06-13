$results = (invoke-webrequest https://mcr.microsoft.com/v2/windows/nanoserver/tags/list).Content | ConvertFrom-Json
$versionnano = ($results.tags | Where-Object { $_.length -eq 4 } | Sort-object -Descending)[0]
Write-Output "ServerNano: $versionnano"
Write-Output ("##vso[task.setvariable variable=versionNano;]$versionnano")