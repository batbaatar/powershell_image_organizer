$all = Get-ChildItem -Filter "*.jpg" -File 
$loc = Get-Location

$counter = 0;

foreach($p in $all)
{
    $date = $p | Get-ItemPropertyValue -Name "LastWriteTime"
    $new_name = ("{0:yyyy-MM-dd-HH-mm-ss}_{1}.jpg" -f $date, $p.Length)

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
        $new_name = ("{0:yyyy-MM-dd-HH-mm-ss}_{1}_{2}.jpg" -f $date, $length, $copy_num)
        $new_fullname = Join-Path $directory $new_name

        while(Test-Path -Path $new_fullname)
        {
            $copy_num++
            $new_name = ("{0:yyyy-MM-dd-HH-mm-ss}_{1}_{2}.jpg" -f $date, $length, $copy_num)
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