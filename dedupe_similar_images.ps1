# Prerequisities
# 1. Install ImageMagick from https://imagemagick.org/. It is a well trusted tool.

# Nice to have
# 1. Hash based deduping to improve performance.
# 2. User prompts with image A vs B to confirm the removal.
# 3. Using similarity score, prompt same as 2 but let the user choose the better ones.

$all = Get-ChildItem -Filter "*.jpg" -File 
$loc = Get-Location
# Safe mode creates a folder with a file name and moves the original and duplicates to it.
# If False, it deletes the duplicates
$safe_mode = $False

$counter = 0;

foreach($a in $all)
{
    $dups = 0
    $compared = 0
    $folder = $a.Name.Replace(".jpg", "").Trim()
    $path = Join-Path -Path $loc -ChildPath $folder

    foreach($b in $all)
    {   
        # Check if not comparing it to itself.
        if($a.Fullname -eq $b.Fullname)
        {
            continue;
        }

        # Compare file size and then compare the bits.
        if($b.Length -eq $a.Length)
        {
            echo ("{0} has a same size." -f $b.Fullname)
            $d = $(magick.exe compare -metric RMSE $a.FullName $b.Fullname NULL:) 2>&1

            if($d.ToString() -eq "0 (0)")
            {
                echo ("These images are identical. {0} and {1}." -f $a.Fullname, $b.Fullname)

                if($safe_mode)
                {
                    If(!(test-path $path))
                    {
                            echo $path
                            New-Item -ItemType Directory -Force -Path $path
                    }

                    Move-Item -Path $b -Destination $path
                    $dups++
                }
                else
                {
                    echo ("{0} has been deleted as duplicates." -f $b.Fullname)
                    Remove-Item -Path $b
                }
            }
        }

        $compared++
        echo $compared
    }

    if($safe_mode -and ($dups -gt 0))
    {
        Move-Item -Path $a -Destination $path
    }

    $counter++

    echo $counter
}