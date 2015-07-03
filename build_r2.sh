#!/bin/bash

################################################################################
# Fred's Spark build script


export MAVEN_OPTS="-Xmx3g -Xms256m -XX:ReservedCodeCacheSize=512m"

# Maven build options
# The options here are taken from the Spark Jenkins server's test builds.
#export MVN_BUILD_Pd/ARAMS="-Pyarn -Phadoop-2.3 -Dhadoop.version=2.3.0 -Pkinesis-asl -Phive -Phive-thriftserver"
#export MVN_TEST_PARAMS="-Pyarn -Phadoop-2.3 -Dhadoop.version=2.3.0 -Pkinesis-asl"

# JN MAYBE HADOOP IS INSTALLED WITH MAVEN (CHECK WITH DERON)
# JN 28may2015 Hadoop Installation
# in case you need homebrew
#ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
# installing hadoop from homebrew gives us hadoop2.7
# brew install hadoop

# Options used in IBM builds
# export MVN_BUILD_PARAMS="-Pyarn -Phadoop-2.6 -Dhadoop.version=2.6.0 -Pkinesis-asl -Phive -Phive-thriftserver -Psparkr"
# export MVN_TEST_PARAMS="-Pyarn -Phadoop-2.6 -Dhadoop.version=2.6.0 -Pkinesis-asl"

# JN 28may2015 using hadoop2.7 defaults
export MVN_BUILD_PARAMS="-Pyarn -Phadoop-2.7 -Dhadoop.version=2.7.0 -Pkinesis-asl -Phive -Phive-thriftserver -Psparkr"
export MVN_TEST_PARAMS="-Pyarn -Phadoop-2.7 -Dhadoop.version=2.7.0 -Pkinesis-asl"


#JN 28may2015 using jdks from from w3:
#http://w3.hursley.ibm.com/java/jim/oraclejdks/latest/oraclemacoslatest/index.html

# Java 7 for now
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.7.0_80.jdk/Contents/Home
# or not.
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_45.jdk/Contents/Home 

# STEP 1: Clean out old artifacts
#./build/mvn -DskipTests clean 


# JN 28may2015 using brew installed maven
mvn -DskipTests clean 

# STEP 2: Build and package
# Replace the first call to mvn below with this to get a tarball out of the
# build.
# Need "yes" here because make-distribution.sh asks you if you really want to
# compile with a version of Java other than Java 6.
#./build/mvn install ${MVN_BUILD_PARAMS} -DskipTests 2>&1 | tee build.out

# JN 28may2015 using brew installed maven
mvn install ${MVN_BUILD_PARAMS} -DskipTests 2>&1 | tee build.out

# # STEP 2.5 (OPTIONAL): Uncomment to build a tarball
# yes | ./make-distribution.sh --tgz ${MVN_BUILD_PARAMS} -DskipTests 2>&1 | tee build.out
# 
# # STEP 3: Test
# # The Spark tests are flaky, and they short-circuit the build when one of them
# # fails; so we run each module separately.`:
# MODULE_DIRS="\
#     core \
#     bagel \
#     graphx \
#     mllib \
#     tools \
#     network/common \
#     network/shuffle \
#     streaming \
#     sql/catalyst \
#     sql/core \
#     sql/hive \
#     unsafe \
#     assembly \
#     external/twitter \
#     external/flume \
#     external/flume-sink \
#     external/mqtt \
#     external/zeromq \
#     examples \
#     repl \
#     launcher\
# "
# 
#  
# # Run the tests
# rm -rf test_outputs
# mkdir test_outputs
# for dirname in ${MODULE_DIRS}
# do
#     echo "************************************************************"
#     echo "***** Running tests for $dirname"
#     dirname_noslash=`echo $dirname | sed -e "s/\\//\\_/g"` 
# 
#     ./build/mvn ${MVN_TEST_PARAMS} -pl ${dirname} test \
#         2>&1 \
#         | tee test_outputs/${dirname_noslash}.out
# done
# 
# # Print a summary of what failed.
# for dirname in ${MODULE_DIRS}
# do
#     dirname_noslash=`echo $dirname | sed -e "s/\\//\\_/g"` 
#     report_file=test_outputs/${dirname_noslash}.out 
#     if tail ${report_file} | grep --quiet Failed
#     then 
#         echo "Module ${dirname} has failed tests; see ${report_file}"
#         echo "Module ${dirname} has failed tests; see ${report_file}" >> test_outputs/summary.txt
#     fi
# done
# 
# echo "List of modules with failures written to test_outputs/summary.txt"
# 
# # OLD TEST CODE:
# # The command is spread across two lines so that specifications of what tests
# # to run can be
# #./build/mvn ${MVN_TEST_PARAMS} test \
# #    2>&1 | tee test.out
# 
# # Options to run a single test:
# #    -DwildcardSuites=org.apache.spark.sql.* -Dtest=none \
# 
# # Options to run a single component's tests:
# # Note that this only works if you've run ./build/mvn install above to put all the 
# # latest Spark binaries into your local Mavan repository
# #    -pl sql/hive
# 
