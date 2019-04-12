# AutoGrader357

Steps to successfully using this auto grader:

1. Initiliaze the directory by coping the Scripts folder into the directory that you want to use the auto grader in. Then from within the Scripts directory run the Init.sh script with an optional argument if you want to name the directory something other than AutoGrader357. This will create all the necessary folders and move the Scripts folder into the newly created directory.

2. Next run the InitHWDir.sh from within the scripts folder the first argument is the name of the directory and the second is the path to the zip file containing all of the homeworks. An example of how to call this script is as follows: $ ./InitHWDir.sh Homework1 ../Homework1.zip.

3. Next you need to setup a Haskell source file that will run the unit tests against students code. There is a provided an example of how to do this. If this is not present the script assumes that you are using HSpec, the project is using the "simple" template from stack, and that you use one "describe" call for each problem. For example the following setup is valid:

describe "1.1" $ do
  <unit tests for 1.1 here>
describe "1.2" $ do
  <unit tests for 1.2 here>

This is NOT valid:

describe "1.1" $ do
  <unit tests for 1.1 here>
describe "1.1" $ do
  <unit tests for 1.1 here>
describe "1.2" $ do
  <unit tests for 1.2 here>
describe "1.2" $ do
  <unit tests for 1.2 here>

You must obey this convention since the output parser assumes this format. If you really want to use a different format or if HSpec changes in the future change the OutputScorer file to reflect the changes you desire.

4. After you have tested your unit tests on your code now you need to remove/comment out your source code, not the unit tests, just the solutions to the problems. Then add the following delimeters to the bottom of your code: 

--i<@@>i

--j<@@>j

These delimeters are used to insert the students code between.

Note: One issue that I never solved was that if the students used imports that I did not import then the code will fail this is because I simple erase their imports instead of putting them at the top of the file. 

5. Now you need to write a config file for this homework that you wish to test. The config file is written in json and provides information about the number of tests you have for each section and how much each is worth. An example config file can be found in Scripts/ConfigFiles/SampleConfig.json. If this is file is not present reference the following example:

[
    {
        "testName": "5.1",
        "numTests": 3,
        "ptsPerTest": 15,
        "specialCases":
            {
                "1":10
            }
    },
    {
        "testName": "5.2",
        "numTests": 3,
        "ptsPerTest": 10,
        "specialCases": {}
    },
    {
        "testName": "5.3",
        "numTests": 3,
        "ptsPerTest": 10,
        "specialCases": 
        {
            "2": 5,
            "3": 15
        }
    }
]

The order of these json objects needs to match the order of unit tests in your source file. The "testName" field is their for readability it is not used in the parsing of the output file. For example if you wrote 5 tests for problem 1.1 and you wanted each to be worth 4 pts except for number 3 which you want to be worth 2 pts you would use the following json object:

{
    "testName": "1.1",
    "numTests": 5,
    "ptsPerTest": 4,
    "specialCases":
        {
            "3":2
        }
}

This must reflect the structure of your unit tests exactly or else the parsing will fail.

5. Now you can run the RunGrader.sh script with two arguments which is the homework directory that you want to grade and the configFile. For example: $ ./RunGrader.sh ../Homeworks/Homework1 ./ConfigFiles/SamplyConfig.json. This will first clean the source files ie removing imports and converting lhs into hs. Then it will grade each students homework and write the raw output and graded output to the Output directory.

6. Now you need to check for problems with the auto grading process for example if a students code doesn't compile then their will be no ouput for them. Another common problem is running out of stack space. I currently have the stack limited to ?? You change it by ??

7. All that is left to do is to go through the graded output files and enter the students grades directly to learn or into an excel sheet that you later upload to learn. 

Future Goals: Implement functionality to directly insert into an excel sheet.


