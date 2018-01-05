#!/bin/sh
dir=$1
name=$2
project_dir="${dir}/${name}"

mkdir -p $project_dir
cd $project_dir

mkdir -p src test doc sample

touch README INSTALL Makefile CHANGES .gitignore
touch src/${name}.tcl
touch test/all.tcl
touch test/${name}.test

# Write package template
cat <<EOF > src/${name}.tcl
# -*- mode: Tcl -*-
# ${name}.tcl --
#
# Description:
#
# Copyright:
#
# Lisence:
#
# Revision: 0
#
# \$Id\$

package provide ${name} 0.1

namespace eval ${name} {
}
EOF

# Write Test bootstrap
cat <<EOF > test/all.tcl
# -*- mode: Tcl -*-
# all.tcl --
#
# Description:
#
# Copyright:
#
# Lisence:
#
# Revision: 0
#
# $Id$

package require tcltest
namespace import -force ::tcltest::*

::tcltest::runAllTests
EOF

# Write test file template
cat <<EOF > test/${name}.test
# -*- mode: Tcl -*-
# ${name}.test --
#
# Description:
#
# Copyright:
#
# Lisence:
#
# Revision: 0
#
# $Id$

source ../src/${name}.tcl

test ${name}_t0 {

} -setup {

} -body {

} -result {}

::tcltest::cleanupTests 1
EOF

# Write tests Makefile
cat <<EOF > test/Makefile
# ${name} Tests Makefile

TCLSH = tclsh

test:
  \$(TCLSH) all.tcl

clean:
  \rm -rf *log
  \rm -rf *logs

EOF

# Write package Makefile
cat <<EOF >Makefile
# ${name} Makefile

PREFIX=/usr/lib64/tcl

install:
  install src/${name}.tcl \${PREFIX}
  echo "pkg_mkIndex -verbose \${PREFIX}" | tclsh

test:
  cd test
  \$(MAKE) test

EOF

cat <<EOF > INSTALL
1. Installsion
In the project root dir, run the command:

    make install

2. Install Location
The default install prefix is /usr/lib64/tcl
To change the install location specify PREFIX:

    make install PREFIX=path/to/install

Make sure PREFIX is in your tcl auto_path and that
a package index was created in it after installsion.

EOF

cat <<EOF >> .gitignore
# swap files
*.swp
.#*
EOF
