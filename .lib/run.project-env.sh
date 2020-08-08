#!/bin/bash
# ---------------------------------------------------------------------------------------------
# MIT License
#
# Copyright (c) 2020, Solace Corporation, Ricardo Gomez-Ulmke (ricardo.gomez-ulmke@solace.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# ---------------------------------------------------------------------------------------------

###############################################################################################
# sets the env for the project
#
# call: source ./run.project-env.sh
#

export AS_SAMPLES_SCRIPT_NAME=$(basename $(test -L "$0" && readlink "$0" || echo "$0"));
export AS_SAMPLES_SCRIPT_PATH=$(cd $(dirname "$0") && pwd);

export AS_SAMPLES_PROJECT_HOME="$AS_SAMPLES_SCRIPT_PATH"

# test for python interpreter
if [ -z "${ANSIBLE_PYTHON_INTERPRETER-unset}" ]; then
    echo ">>> ERR: env var: ANSIBLE_PYTHON_INTERPRETER is set to the empty string. Either unset or set properly."; echo
    exit 1
fi
if [ -z "$ANSIBLE_PYTHON_INTERPRETER" ]; then
    DEFAULT="/usr/bin/python"
    echo ">>> WARN: env var: ANSIBLE_PYTHON_INTERPRETER is not set. Default: $DEFAULT."
    echo ">>> Ensure this is the correct version:"
    export AS_SAMPLES_PYTHON_VERSION=$($DEFAULT --version)
else
  export AS_SAMPLES_PYTHON_VERSION=$($ANSIBLE_PYTHON_INTERPRETER --version)
fi

source $AS_SAMPLES_PROJECT_HOME/.lib/functions.sh

###
# The End.
