#pending adjustments:
#checking for dependencies
#error handling
#work in created sub-folder
#make sensible variable names
$name = read-host "enter video file name with extension(ensure no '.'s
in name except before extension)"
$n=$name -split '.',0,"SimpleMatch"
$no1=$n[0]+".mp3"
ffmpeg -i $name $no1
$no=$n[0]+"-no-audio.mp4"
ffmpeg -i $name -an -vcodec copy $no
$no1=$n[0]+".mp3"
$a = mediainfo --inform='Audio;%Duration%' $no1
$a=$a/60/1000
$b = [math]::ceiling($a/10)
$names=new-object collections.generic.list[string];
for($i=0;$i -lt $b;$i++){
$names.add($n[0]+"-$i.mp3");
}
ffmpeg -i $no1 -f segment -segment_time 600 -c copy ($n[0]+"-%d.mp3")
foreach($na in $names){
spleeter separate -p spleeter:2stems -c mp3 -o ./ -f "{instrument}-{filename}.{codec}" "$na"
}
$nm = "ffmpeg "
for($i=0;$i -lt $b;$i++){ $nm += "-i vocals-"+'"'+$n[0]+'"'+"-$i.mp3 " }
$nm += "-filter_complex '"
for($i=0;$i -lt $b;$i++){ $nm += "[$i"+':0]' }
$nm += "concat=n=$b"+':v=0:a=1[out]'' -map ''[out]''' + '"' +$n[0]+"-out.mp3" + '"'
Invoke-Expression $nm
$nmo="ffmpeg -i "+ '"'+$n[0]+"-no-audio.mp4"+'"' +' -i ' + '"'+$n[0]+"-out.mp3"+'"' +' -vcodec copy '+'"'+$n[0]+"-filtered.mp4"+'"'
Invoke-Expression $nmo
read-host "press any key to exit"