#!/bin/ksh
dir=/home/dfdonfei/phase1/phase4/testResults
#dir=/home/cs452/fall16/admin/project/phase4/testResults
#dir=/Users/patrick/Classes/452/project/phase4/testResults

if [ "$#" -eq 0 ] 
then
    echo "Usage: ksh testphase4.ksh <num>"
    echo "where <num> is 00, 01, 02, ... or 23"
    exit 1
fi

num=$1
if [ -f test${num} ]
then
    /bin/rm test${num}
fi

# Copy disk and terminal files
cp testcases/disk0.orig disk0
cp testcases/disk1.orig disk1
for i in 0 1 2 3; do
    cp testcases/term${i}.in.orig term${i}.in
done

if  make test${num} 
then

    ./test${num} > test${num}.txt 2> test${num}stderr.txt;

    if [ -s test${num}stderr.txt ]
    then
        cat test${num}stderr.txt >> test${num}.txt
    fi

    /bin/rm test${num}stderr.txt

    if [ "${num}" -eq 06 -o "${num}" -eq 07 -o \
         "${num}" -eq 19 -o "${num}" -eq 20 -o \
         "${num}" -eq 21 -o "${num}" -eq 22 -o \
         "${num}" -eq 23 ]; then
        echo >> test${num}.txt
        echo "term0.out" >> test${num}.txt
        cat   term0.out >> test${num}.txt
        echo "term1.out" >> test${num}.txt
        cat   term1.out >> test${num}.txt
        echo "term2.out" >> test${num}.txt
        cat   term2.out >> test${num}.txt
        echo "term3.out" >> test${num}.txt
        cat   term3.out >> test${num}.txt
    fi

    if [ "${num}" -eq 14 ]; then
        cmp disk1 testResults/disk13
        diskCompare=$?
        echo "diskCompare = "${diskCompare}
        if diff --brief test${num}.txt ${dir}
        then
            if [ ${diskCompare} -eq 0 ] ; then
                echo
                echo test${num} passed!
            else
                echo
                echo test${num} failed!
                echo incorrect contents in disk1
            fi
        else
            echo
            diff -C 1 test${num}.txt ${dir}
        fi
        exit
    fi

    if diff --brief test${num}.txt ${dir}
    then
        echo
        echo test${num} passed!
    else
        echo
        diff -C 1 test${num}.txt ${dir}
    fi
fi
echo
