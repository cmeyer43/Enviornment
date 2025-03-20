To run the tests all you need to do is `./test.py`
To add tests create a new python file make a class that contains the word `test` in it somewhere.
Add tests to the previously created class, they should assert on failure. Run `./test.py` and your tests should automatically be included.

Functions preceded by `_` will not be run.
if a `setup(self)` function exists it will be ran before each test is ran.
