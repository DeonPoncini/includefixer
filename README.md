---
Title: Include Fixer for Vim
Description: Categorize and Alphabetize C and C++ #include directives
Author: Deon Poncini
Created:  2013 Dec 14
Modified: 2013 Dec 14

---

Include Fixer for Vim
=============================

Developed by Deon Poncini <dex1337@gmail.com>

Downloads
---------

[github]: https://github.com/DeonPoncini/includefixer

Installation
------------

### Option 1: Manual installation

1.  Move `includefixer.vim` to your `.vim/plugin` directory.

        $ cd includefixer/plugin
        $ mv includfixer.vim ~/.vim/plugin/

### Option 2: Pathogen installation ***(recommended)***

1.  Download and install Tim Pope's [Pathogen].

2.  Next, move or clone the `includefixer` directory so that it is
    a subdirectory of the `.vim/bundle` directory.

    a. **Clone:**

	$ cd ~/.vim/bundle
	$ git clone https://github.com/DeonPoncini/includefixer.git

    b. **Move:**

        In the parent directory of includefixer:

            $ mv includefixer ~/.vim/bundle/

Usage
---------
:FixIncludes

For more extensive information, please see the documentation inside
doc/includefixer.txt

License
---------
Copyright (c) 2013 Deon Poncini

Permission is hereby granted, free of charge, to any person or organization
obtaining a copy of the software and accompanying documentation covered by
this license (the "Software") to use, reproduce, display, distribute,
execute, and transmit the Software, and to prepare derivative works of the
Software, and to permit third-parties to whom the Software is furnished to
do so, all subject to the following:

The copyright notices in the Software and this entire statement, including
the above license grant, this restriction and the following disclaimer,
must be included in all copies of the Software, in whole or in part, and
all derivative works of the Software, unless such copies or derivative
works are solely in the form of machine-executable object code generated by
a source language processor.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE, TITLE AND NON-INFRINGEMENT. IN NO EVENT
SHALL THE COPYRIGHT HOLDERS OR ANYONE DISTRIBUTING THE SOFTWARE BE LIABLE
FOR ANY DAMAGES OR OTHER LIABILITY, WHETHER IN CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
DEALINGS IN THE SOFTWARE.
