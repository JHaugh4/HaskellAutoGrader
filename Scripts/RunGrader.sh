#!/bin/bash

if [ "$#" -ne 2 ]; 
then 
  echo "Please provide 2 arguments: HomeworkFolder and ConfigFile. All paths should be relative to where you are running this script or absolute."
  echo "The HomeworkFolder should be created by InitHWDir.sh"
  echo "For example $ ./RunGrader.sh ../Homeworks/Homework1 ./ConfigFiles/SamplyConfig.json"
  exit 1
else 
  sourceFolder="$1"
fi

config="$2"
mainFile=../src/UnitTester/Main.hs
outputDir="$sourceFolder"/Output
textOutputDir="$outputDir"/TextFiles


./CleanSource.sh "$sourceFolder"

for filepath in "$sourceFolder"/CleanSource/*; do

  if [[ "$filepath" =~ \.lhs$ ]];
  then
    filename=$(basename "$filepath" ".lhs") 
    hsFile="$(stack exec LhsToHs "$filepath")"
    tempFile="./temp.hs"
    echo "$hsFile" > "$tempFile"
    sed -i "/--i<@@>i/r $tempFile" "$mainFile"
    rm "$tempFile"
  else
    filename=$(basename "$filepath" ".hs")
    sed -i "/--i<@@>i/r $filepath" "$mainFile"
  fi

  outputFile="$textOutputDir/$filename.txt"

  #This gets the absolute path of the file
  outputFile1="$(echo "$(cd "$(dirname "$outputFile")"; pwd)/$(basename "$outputFile")")"

  failFile="$textOutputDir/""$filename""Fail.txt"
  failFile1="$(echo "$(cd "$(dirname "$failFile")"; pwd)/$(basename "$failFile")")"

  stack test --ta "--out="$outputFile1" --format=specdoc"

  sed -i "/--i<@@>i/,/--j<@@>j/d" $mainFile
  echo -e "--i<@@>i\n\n--j<@@>j" >> $mainFile

  #Truncates first line of the file
  echo -e "$(sed '1d' $outputFile1)\n" > "$outputFile1"

  gradeFile="$outputDir/$filename.txt"
  gradeFile1="$(echo "$(cd "$(dirname "$gradeFile")"; pwd)/$(basename "$gradeFile")")"

  #test="$(find . -name '*Homework 5_aaleix*')"
  #find . -name '*$var*' Returns $var.txt thus it isn't referencing the variable

  absLearnPath="$(echo "$(cd "$(dirname "$sourceFolder/Source/TextFiles")"; pwd)/$(basename "$sourceFolder/Source/TextFiles")")"

  partialFileName="${filename:0:30}"
  learnFile="$(find $absLearnPath -iname "*$partialFileName*")"

  head -3 "$learnFile" > "$gradeFile1"
  echo -n "Grade: " >> "$gradeFile1"

  stack exec AutoGrader357 "$config" "$outputFile1" >> "$gradeFile1"

done