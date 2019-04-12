#!/bin/bash

if [ "$#" -ne 2 ]; 
then 
  echo "Please provide a name for the directory and the path to the zip file with all of the homework files in it relative to where you are running this script."
  echo "Also normalizes file names by removing spaces and _ since these characters cause problems when running the MOSS script"
  echo "For example $ ./InitHWDir.sh Homework1 ../Homework1.zip"
  exit 1
else 
  dirName="$1"
  zipFile="$2"
fi

cd ../Homeworks

mkdir "$dirName"

cd "$dirName"

mkdir Source CleanSource Output Pdf

mkdir Pdf/TextFiles Source/TextFiles Output/TextFiles

cd ../../Scripts

unzip -d ../Homeworks/"$dirName"/Source "$zipFile"

mv ../Homeworks/"$dirName"/Source/*.txt ../Homeworks/"$dirName"/Source/TextFiles

cd ../Homeworks/"$dirName"/Source

for filepath in ./*.{hs,lhs,txt}; do

  filepath1=${filepath//[_ ]/-}

  if [ "$filepath" != "$filepath1" ];
  then mv "$filepath" "$filepath1"
  fi

done