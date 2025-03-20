#!/usr/bin/env python3
import inspect
import traceback
import sys
import os
import glob
import subprocess
import timeit
for f in glob.glob(os.path.dirname(__file__)+"/*.py"):
    if os.path.isfile(f) and not os.path.basename(f).startswith('_') and os.path.basename(f) != "testController.py":
        import_str = "from {0} import *".format(os.path.basename(f)[:-3])
        exec(import_str)

def getClasses(myModule):
    return [
            clazz[1] for clazz in inspect.getmembers(sys.modules[myModule], inspect.isclass)
            if "test" in (clazz[0]).lower()
            ]

def getNumTests(clazzs):
    numTests = 0
    for clazz in clazzs:
        functions = inspect.getmembers(clazz, predicate=inspect.isfunction)
        numTests += len([func for func in functions
            if ((not func[1].__name__.lower().startswith("_")) and (not func[1].__name__.lower() == "setup"))
        ])
    return numTests 


def runFunctions(clazz):
    functions = inspect.getmembers(clazz, predicate=inspect.isfunction)
    clz = clazz()
    failed = list()
    setup = [func for func in functions
            if func[1].__name__.lower() == "setup"
        ]
    testFunctions = [func for func in functions
            if ((not func[1].__name__.lower().startswith("_")) and (not func[1].__name__.lower() == "setup"))
        ]
    if len(testFunctions) > 1:
        print("\033[32m[----------]\033[37m ", end='')
        print(len(testFunctions), " tests from ", clz.__class__.__name__, " test suite.", sep ='')
    else:
        print("\033[32m[----------]\033[37m ", end='')
        print(len(testFunctions), " test from ", clz.__class__.__name__, " test suite.", sep ='')
    startTotal = timeit.timeit()
    for func in testFunctions:
        print("\033[32m[ RUN      ]\033[37m ", end='')
        print(clz.__class__.__name__, ".", func[1].__name__, sep='')
        try:
            start=timeit.timeit()
            if setup:
                setup[0][1](clz)
            func[1](clz)
            print("\033[32m[       OK ]\033[37m ", sep='', end='')
        except Exception as ex:
            if (type(ex).__name__ != "AssertionError"):
                print(traceback.format_exc())
            else:
                print("\t", ex, sep='')
            print("\033[31m[  FAILED  ]\033[37m ", sep='', end='')
            failed.append("{0}.{1}".format(clz.__class__.__name__, func[1].__name__))
        end = timeit.timeit()
        time = (int)((end - start) * 1000)
        print(clz.__class__.__name__, ".", func[1].__name__, " (", time, " ms)", sep='')

    endTotal = timeit.timeit()
    time = (int)((endTotal - startTotal) * 1000)
    if len(testFunctions) > 1:
        print("\033[32m[----------]\033[37m ", end='')
        print(len(testFunctions), " tests from ", clz.__class__.__name__, " test suite (", time, " ms total)", sep = '')
    else:
        print("\033[32m[----------]\033[37m ", end='')
        print(len(testFunctions), " test from ", clz.__class__.__name__, " test suite (", time, " ms total)", sep = '')
    return failed



def runTests(myModule):
    clazzs = getClasses(myModule)
    numTests = getNumTests(clazzs)
    failed = list()
    print("\033[32m[==========]\033[37m ", end='')
    if ((numTests > 1) and (len(clazzs) == 1)):
        print("Runining ", numTests, " tests from ", len(clazzs), " test suite.", sep='')
    elif (numTests == 1) and (len(clazzs) == 1):
        print("Runining ", numTests, " test from ", len(clazzs), " test suite.", sep='')
    elif (numTests > 1) and (len(clazzs) > 1):
        print("Runining ", numTests, " tests from ", len(clazzs), " test suites.", sep='')
    elif (numTests == 1) and (len(clazzs) > 1):
        print("Runining ", numTests, " test from ", len(clazzs), " test suites.", sep='')
    start = timeit.timeit()
    for clazz in clazzs:
        failedTest = runFunctions(clazz)
        if len(failedTest):
            for fail in failedTest:
                failed.append(fail)
        clz = clazz()
        print()
    end = timeit.timeit()
    time = (int)((end - start) * 1000)
    print("\033[32m[==========]\033[37m ", end='')
    if ((numTests > 1) and (len(clazzs) == 1)):
        print("Runining ", numTests, " tests from ", len(clazzs), " test suite.", " (", time, " ms total)", sep='')
    elif (numTests == 1) and (len(clazzs) == 1):
        print("Runining ", numTests, " test from ", len(clazzs), " test suite.", " (", time, " ms total)", sep='')
    elif (numTests > 1) and (len(clazzs) > 1):
        print("Runining ", numTests, " tests from ", len(clazzs), " test suites.", " (", time, " ms total)", sep='')
    elif (numTests == 1) and (len(clazzs) > 1):
        print("Runining ", numTests, " test from ", len(clazzs), " test suites.", " (", time, " ms total)" ,sep='')
    print("\033[32m[  PASSED  ]\033[37m ", end ='')
    if (numTests - len(failed)) == 1:
        print(numTests - len(failed), " test.", sep='')
    else:
        print(numTests - len(failed), " tests.", sep='')
    if (len(failed) == 1):
        print("\033[31m[  FAILED  ]\033[37m ", sep='', end='')
        print(len(failed), " test, listed below:", sep='')
        for fail in failed:
            print("\033[31m[  FAILED  ]\033[37m ", sep='', end='')
            print(fail, sep='')
        print("\n ",len(failed), " FAILED TEST", sep='')
    elif (len(failed) > 1):
        print("\033[31m[  FAILED  ]\033[37m ", sep='', end='')
        print(len(failed), " tests, listed below:", sep='')
        for fail in failed:
            print("\033[31m[  FAILED  ]\033[37m ", sep='', end='')
            print(fail, sep='')
        print("\n ",len(failed), " FAILED TESTS", sep='')
    return

if __name__ == '__main__':
    runTests(__name__)
