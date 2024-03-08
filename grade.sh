CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission 2> grading-area/clone-log.txt
# echo 'Finished cloning'

FOUND=$(find student-submission/ -name "ListExamples.java")

lines=$(echo $FOUND | wc -l)
if [ $lines -eq 0 ]; then
  echo "ListExamples.java not found"
  exit 1
fi

cp TestListExamples.java grading-area
cp $FOUND grading-area
cp -r lib grading-area

cd grading-area
javac -cp $CPATH *.java 2> compile-log.txt

if [[ $? -ne 0 ]]
then
  echo "Compilation error:"
  cat compile-log.txt
  exit 1
fi

java -cp $CPATH org.junit.runner.JUnitCore TestListExamples 1> test-log.txt

LASTLINE=$(tail -n 3 test-log.txt)

if [[ $LASTLINE == *"OK "* ]]
then
  SCORE=$(echo $LASTLINE | grep -o '[0-9]\+')
  TESTS_RUN=$SCORE
else
  TESTS_RUN=$(echo $LASTLINE | grep -oP 'Tests run: \K\d+')
  FAILURES=$(echo $LASTLINE | grep -oP 'Failures: \K\d+')

  SCORE=$((TESTS_RUN - FAILURES))
fi

  echo "Grade: $SCORE/$TESTS_RUN"

# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests
