#!/bin/bash

if [ "$#" -ne 1 ]; 
then dirName="AutoGrader357"
else dirName="$1"
fi

cd ..

stack new "$dirName" simple

mv Scripts ./"$dirName"

cd "$dirName"

mkdir Homeworks GradeSheets