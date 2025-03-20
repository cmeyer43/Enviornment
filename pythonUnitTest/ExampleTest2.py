#!/usr/bin/env python3
from unittest.mock import patch
from unittest.mock import Mock
from unittest.mock import MagicMock
from unittest.mock import create_autospec
import inspect
from optparse import OptionParser
import types
import os
import sys
# import stuff from higher paths.
#sys.path.insert(0,"../../")
#sys.path.insert(0,"../")

class exampleClass:
    def __init__(self):
        self.value = None
        pass

    def set_value():
        self.value = 3
        return

# this will overide the class function.
def _my_new_value(self):
    self.value = 2
    return

class ExampleTest2:
    def __init__(self):
        self.test = 3

    def setup(self):
        self.checkValue = None
        self.correctValue = None

    def _checkAssert(self):
        asserts = 0
        try:
            assert self.checkValue == self.correctValue
        except:
            print("\tValue was ", self.checkValue, "should be ", self.correctValue)
            asserts += 1
        if asserts:
            raise AssertionError("Failed Checks")


    def overideFunctionExamplePass(self):
        self.correctValue = 2
        with patch.object(exampleClass, 'set_value', new=_my_new_value):
            ex = exampleClass()
            ex.set_value()
            self.checkValue = ex.value
            self._checkAssert()


    def overideFunctionExampleFail(self):
        self.correctValue = 3
        with patch.object(exampleClass, 'set_value', new=_my_new_value):
            ex = exampleClass()
            ex.set_value()
            self.checkValue = ex.value
            self._checkAssert()



