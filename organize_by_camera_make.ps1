# Prerequisities
# 1. Get the taglib-sharp.dll library. Don't have a trusted source to recommend. If you feel unsafe downloading a dll, go to step 2.
# 2. Get the source https://github.com/mono/taglib-sharp/ and build your own dll.

$tagLibrary = "$env:UserProfile\Downloads\taglib-sharp-2.1.0.0-windows\Libraries\taglib-sharp.dll"
[System.Reflection.Assembly]::LoadFile($tagLibrary) | Out-Null

$all = Get-ChildItem -Filter "*.jpg" -File 
$loc = Get-Location

$counter = 0;

foreach($p in $all)
{
    $props = [Taglib.file]::Create($p.FullName)
    $camera = $props.ImageTag.Make

    if(![string]::IsNullOrEmpty($camera))
    {
        $camera = $camera.Replace(":", "").Trim()
        $path = Join-Path -Path $loc -ChildPath $camera

        If(!(test-path $path))
        {
              echo $path
              New-Item -ItemType Directory -Force -Path $path
        }

        Move-Item -Path $p -Destination $path
    }
    else
    {
        echo "Photo has no camera make info."
    }

    $counter++

    echo $counter
}

