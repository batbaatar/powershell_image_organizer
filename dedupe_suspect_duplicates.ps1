# Prerequisities
# 1. WARNING! Use rename_photos_better.ps1 first to get the file name format right.
# 2. Install ImageMagick from https://imagemagick.org/. It is a well trusted tool.


$all = Get-ChildItem -Filter "*.jpg" -File 
$loc = Get-Location
$counter = 0;

foreach($a in $all)
{
    $name = $a.Name.Replace(".jpg", "").Trim()

    $suspects = Get-ChildItem -Filter ("*{0}*" -f $name)

    foreach($b in $suspects)
    {   
        # Check if not comparing it to itself.
        if($a.Fullname -eq $b.Fullname)
        {
            continue;
        }

        # Compare file size and then compare the bits.
        if($b.Length -eq $a.Length)
        {
            $d = $(magick.exe compare -metric RMSE $a.FullName $b.Fullname NULL:) 2>&1

            if($d.ToString() -eq "0 (0)")
            {
                Remove-Item -Path $b
                echo ("{0} has been deleted as duplicates." -f $b.Fullname)
            }
        }
    }

    $counter++

    echo $counter
}