# Nice to have
# 1. Call Bing Maps API (free as of Nov 2020) to get the city + state info and organize inside the folder yyyy-mm.

$uri = "http://dev.virtualearth.net/REST/v1/Locations/{0},{1}?o=xml&key={2}"
$bing_maps_api_key = ""

$all = Get-ChildItem -Filter "*.jpg" -File 
$loc = Get-Location

$counter = 0;

foreach($p in $all)
{
    # Could call Bing Maps API for a location classification.
    #$call_uri = $uri -f
    #Invoke-RestMethod -Uri "http://dev.virtualearth.net/REST/v1/Locations/{point}?includeEntityTypes={entityTypes}&includeNeighborhood={includeNeighborhood}&include={includeValue}&key={BingMapsKey}"
    $date = $p | Get-ItemPropertyValue -Name "LastWriteTime"

    $path = Join-Path -Path $loc -ChildPath $date.Year
    $path = Join-Path -Path $path -ChildPath $date.Month

    If(!(test-path $path))
    {
          echo $path
          New-Item -ItemType Directory -Force -Path $path
    }

    #Move-Item -Path $p -Destination $path -WhatIf

    Move-Item -Path $p -Destination $path -WhatIf
    $counter++

    echo $counter
}