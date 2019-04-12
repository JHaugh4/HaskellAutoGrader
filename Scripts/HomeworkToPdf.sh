#!/bin/bash

if [ "$#" -ne 1 ]; 
then 
  echo "Please provide 1 argument: HomeworkFolder. All paths should be relative to where you are running this script."
  echo "The HomeworkFolder should be created by the InitHWDir.sh script"
  echo "For example $ ./HomeworkToPdf.sh ../Homeworks/HW1"
  exit 1
else 
  sourceFolder="$1"
fi

cd "$sourceFolder"

for filepath in ./Source/*.{hs,lhs} ; do

  if [[ "$filepath" =~ \.hs$ ]]
  then
    filename=$(basename "$filepath" ".hs")
  elif [[ "$filepath" =~ \.lhs$ ]]
  then
    filename=$(basename "$filepath" ".lhs")
  fi

  if [[ "$filename" != "*.hs" ]] &&
     [[ "$filename" != "*.lhs" ]] &&
     [[ "$filename" != "*" ]]
  then
    cat "$filepath" > ./Pdf/TextFiles/"$filename.txt"

    enscript -p temp.ps ./Pdf/TextFiles/"$filename.txt"

    ps2pdf temp.ps ./Pdf/"$filename.pdf"

    rm temp.ps
  fi

done