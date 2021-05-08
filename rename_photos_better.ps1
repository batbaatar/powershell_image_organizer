# Prerequisities
# 1. Get the taglib-sharp.dll library. Don't have a trusted source to recommend. If you feel unsafe downloading a dll, go to step 2.
# 2. Get the source https://github.com/mono/taglib-sharp/ and build your own dll.

$ext = "jpg"
$all = Get-ChildItem -Filter ("*.{0}" -f $ext) -File 
$tagLibrary = "$env:UserProfile\Downloads\taglib-sharp-2.1.0.0-windows\Libraries\taglib-sharp.dll"
[System.Reflection.Assembly]::LoadFile($tagLibrary) | Out-Null
$loc = Get-Location

$counter = 0;

foreach($p in $all)
{
    $props = [Taglib.file]::Create($p.FullName)
    # Try to use DateTaken property as the truth.
    $date = $props.ImageTag.DateTime
    if(!$date)
    {
        $date = $p | Get-ItemPropertyValue -Name "LastWriteTime"
    }

    $new_name = ("{0:yyyy-MM-dd-HH-mm-ss}_{1}.{2}" -f $date, $p.Length, $ext)

    $directory = [System.IO.Path]::GetDirectoryName($p.Fullname)
    $new_fullname = Join-Path $directory $new_name

    if($new_fullname -eq $p.Fullname)
    {
        echo ("{0} already in same format" -f $p.Fullname)        
    }
    elseif(!(Test-Path -Path $new_fullname))
    {
        # File not in same format. Rename it.
        Rename-Item -Path $p.Fullname -NewName $new_name
        echo ("Renamed {0} to {1}" -f $p.Fullname, $new_fullname)
    }
    else
    {
        # Same file exists. Keep copies to help with the deduping later.
        $copy_num = 0
        $new_name = ("{0:yyyy-MM-dd-HH-mm-ss}_{1}_{2}.{3}" -f $date, $p.Length, $copy_num, $ext)
        $new_fullname = Join-Path $directory $new_name

        while(Test-Path -Path $new_fullname)
        {
            $copy_num++
            $new_name = ("{0:yyyy-MM-dd-HH-mm-ss}_{1}_{2}.{3}" -f $date, $p.Length, $copy_num, $ext)
            $new_fullname = Join-Path $directory $new_name               
        }

        Rename-Item -Path $p.Fullname -NewName $new_name
        echo ("Renamed {0} to {1}.    <------ Possible duplicate detected." -f $p.Fullname, $new_fullname)
    }

    $counter++

    if($counter % 100 -eq 0)
    {
        echo $counter
    }
}
