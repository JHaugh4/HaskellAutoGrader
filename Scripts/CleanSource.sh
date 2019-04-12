#!/bin/bash

if [ "$#" -ne 1 ]; 
then 
  echo "Please provide 1 argument: HomeworkFolder. All paths should be relative to where you are running this script or absolute."
  echo "The HomeworkFolder should be created by InitHWDir.sh"
  echo "For example $ ./CleanSource.sh ../Homeworks/HW1"
  exit 1
else 
  dirName="$1"
fi

cd ../Homeworks/"$dirName"/Source

for filename in ./*.{hs,lhs}; do

  if [[ "$filename" =~ \.lhs$ ]] || [[ "$filename" =~ \.hs$ ]]
  then
    if [[ "$filename" != "./*.hs" ]] &&
       [[ "$filename" != "./*.lhs" ]] &&
       [[ "$filename" != "./*" ]]
    then
      cp "$filename" ../CleanSource

      cleanFile=../CleanSource/"$filename"

      sed -i "/module*/d" "$cleanFile"
      sed -i "/import*/d" "$cleanFile"
    fi
  fi

done


# if [[ ( "$filename" != "./*.lhs" ) && ( "$filename" != "./*.hs" ) ]];
# then