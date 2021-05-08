$mediaInfo = "$env:UserProfile\Downloads\MediaInfo_CLI_20.09_Windows_x64\MediaInfo.exe"

$ext = "mp4"
$all = Get-ChildItem -Filter "*.$ext" -File 
$loc = Get-Location

foreach($p in $all)
{
    echo $p.Fullname
    $props = & $mediaInfo $p.Fullname --Full --Output=JSON | ConvertFrom-Json

    $created = $props.Media.Track[0].Encoded_Date

    if($created)
    {
        if($created.StartsWith("UTC "))
        {
            $created = $created.SubString(4)
        }
        echo $created
        $date = [datetime]::Parseexact($created, 'yyyy-MM-dd HH:mm:ss', $null)
    }

    if(!$created)
    {
        $created = $props.Media.Track[0].Mastered_Date        
    }

    if($created)
    {
        if($created.StartsWith("UTC "))
        {
            $created = $created.SubString(4)
        }
        echo $created
        $date = [datetime]::Parseexact($created, 'yyyy-MM-dd HH:mm:ss', $null)
    }

    if(!$created)
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