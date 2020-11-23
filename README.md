# powershellimageorganizer
a set of tools to help you organize your images using powershell.

my portable drive was accidently formatted and all the images lost their directory structure and names. these set of scripts helped me a bit to organize.

1. rename_photos_better.ps1

this script can help you to rename the photos to yyyy-MM-dd-HH-mm-ss_bytes format. The last bytes could help you to manually deduplicate.
 - use dedupe_suspect_duplicates.ps1 to remove duplicates automatically.

2. organize_by_non_camera_source.ps1

if you had tons of images from non-camera source like downloaded, saved images from internet, then you could use this to move them to a separate folder. some old photos doesn't even have correct dates when the photo was taken, this can help you with identifying those as well.

3. dedupe_similar_images.ps1

this is a bit hardcore but could save you tons of time, use it with caution. useful when near identical images have same size but the dates differ. start with a safe mode to verify if the tool is detecting duplicates correctly. the comparison is based on imagemagick's "compare" option.

4. organize_photos_to_yyyy_mm.ps1

move your photos to year-month folders based on when the images were created.

5. organize_by_camera_make.ps1

if there are images came from different sources within a same folder and you want them classify, you could try to organize by the camera makes. this creates a folder named by the camera make and moves the images accordingly.


Use at your own risk!!!

Feel free to send a pull requests and file issues.

Nice to have
1. test
2. all delete operation moves to a temporary folder or recycle bin
3. combine rename_photos_better.ps1 and dedupe_suspect_duplicates.ps1 to one script
4. or a one goliath script that combines all of the above
5. a way to give users a confidence that the script will not do harms
