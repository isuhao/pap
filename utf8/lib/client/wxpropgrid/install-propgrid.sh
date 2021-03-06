#! /bin/sh

#
# This is a simple script to copy component dirs into correct locations
# (and do some very simple build stuff)
#
# AUTOGENERATED WITH generate_files.py
#
echo "INSTALLING WXWIDGETS COMPONENT: propgrid"
if test ! -r "contrib/readme-propgrid.txt"; then
  echo ".   contrib/readme-propgrid.txt does not exist, so this script is being executed in wrong directory!"
  echo ". install aborted"
  exit 0;
fi

# try auto-running the script
if test ! "$1" = ""; then
  declare basewxdir="$1"
fi

# query base dir
if test "$1" = ""; then
  echo "Enter your wxWidgets base directory"
  read basewxdir
  if test "$basewxdir" = ""; then
    echo ". must give valid dir!"
    echo ". install aborted"
    exit 0;
  fi
fi
# it must exist
if test ! -r $basewxdir; then
  echo ". directory $basewxdir does not exist!"
  echo ". install aborted"
  exit 0;
fi
# it must be valid wxWidgets dir (check for project name in version.h)
LINE=`grep "wxWidgets" ${basewxdir}/include/wx/version.h`
if test ! "x$LINE" != "x" ; then
  # lets be sport and support wxWindows too
  LINE=`grep "wxWindows" ${basewxdir}/include/wx/version.h`
  if test ! "x$LINE" != "x" ; then
    echo ". directory $basewxdir is not wxWidgets directory!"
    echo ". install aborted"
    exit 0;
  fi
fi

echo ". selected base directory: $basewxdir"

# detect library version
echo ". detecting library version..."
declare libver=""
# test for 2.6.0
if test "$libver" = ""; then
  LINE=`grep "2.6.0" ${basewxdir}/include/wx/version.h`
  if test "x$LINE" != "x" ; then
    declare libver="2.6.0"
  fi
fi

# test for 2.5.5
if test "$libver" = ""; then
  LINE=`grep "2.5.5" ${basewxdir}/include/wx/version.h`
  if test "x$LINE" != "x" ; then
    declare libver="2.5.5"
  fi
fi

# test for 2.5.4
if test "$libver" = ""; then
  LINE=`grep "2.5.4" ${basewxdir}/include/wx/version.h`
  if test "x$LINE" != "x" ; then
    declare libver="2.5.4"
  fi
fi

# test for 2.5.3
if test "$libver" = ""; then
  LINE=`grep "2.5.3" ${basewxdir}/include/wx/version.h`
  if test "x$LINE" != "x" ; then
    declare libver="2.5.3"
  fi
fi

# test for 2.5.2
if test "$libver" = ""; then
  LINE=`grep "2.5.2" ${basewxdir}/include/wx/version.h`
  if test "x$LINE" != "x" ; then
    declare libver="2.5.2"
  fi
fi

if test "$libver" = ""; then
  echo ".   warning: Supported library version not detected!"
  echo ".     Install will continue assuming 2.6.0 as the wxWidgets version."
  echo ".     You will most likely need to regenerate or modify Makefile.in files."
  declare libver="2.6.0"
else
  echo ".   found: $libver"
fi

if test ! "$1" = ""; then
  declare subwxdir="contrib"
fi

# query sub dir
if test "$1" = ""; then
  echo "Enter sub-directory to install [contrib]"
  read subwxdir
  if test "$subwxdir" = ""; then
    declare subwxdir="contrib"
  fi
fi

echo ". selected sub-directory: $subwxdir"

# test sub dir
if test ! -r $basewxdir/$subwxdir; then
  echo "$basewxdir/$subwxdir does not exist. Create? [Y]"
  read msgres
  if test "$msgres" = "n"; then
    echo "Install aborted"
    exit 0;
  fi
  if test "$msgres" = "N"; then
    echo "Install aborted"
    exit 0;
  fi
  mkdir $basewxdir/$subwxdir
  mkdir $basewxdir/$subwxdir/build
  mkdir $basewxdir/$subwxdir/docs
  mkdir $basewxdir/$subwxdir/docs/html
  mkdir $basewxdir/$subwxdir/include
  mkdir $basewxdir/$subwxdir/include/wx
  mkdir $basewxdir/$subwxdir/lib
  mkdir $basewxdir/$subwxdir/samples
  mkdir $basewxdir/$subwxdir/src
fi

# test existing installation
if test "$1" = ""; then
  if test -r "$basewxdir/$subwxdir/build/propgrid"; then
    echo "Installation already exists. Overwrite [Y]?"
    read msgres
    if test "$msgres" = "n"; then
      echo "Install aborted"
      exit 0;
    fi
    if test "$msgres" = "N"; then
      echo "Install aborted"
      exit 0;
    fi
  fi
fi

# copy files
cp -f contrib/readme-propgrid.txt $basewxdir/$subwxdir
cp -f contrib/CHANGES-propgrid.txt $basewxdir/$subwxdir
cp -f contrib/index-propgrid.html $basewxdir/$subwxdir
cp -f -R contrib/build/propgrid $basewxdir/$subwxdir/build
cp -f -R contrib/docs/html/propgrid $basewxdir/$subwxdir/docs/html
cp -f -R contrib/include/wx/propgrid $basewxdir/$subwxdir/include/wx
cp -f -R contrib/samples/propgrid $basewxdir/$subwxdir/samples
cp -f -R contrib/src/propgrid $basewxdir/$subwxdir/src

# only need to copy makefiles if not most recent version
# (in which case they were already copied in the code above)
if test ! "$libver" = "2.6.0"; then
  cp -f contrib/src/propgrid/Makefile.$libver.in $basewxdir/$subwxdir/src/propgrid/Makefile.in
  cp -f contrib/samples/propgrid/Makefile.$libver.in $basewxdir/$subwxdir/samples/propgrid/Makefile.in
fi

echo ". install complete"

# exit now if this was auto-run
if test ! "$1" = ""; then
  exit 0;
fi

# show extra information
if test ! "$subwxdir" = "contrib"; then
    echo ""
    echo "Since you installed in another directory than contrib, running the"
    echo "configure script will not generate makefiles unless you change line"
    echo ""
    echo "    SUBDIRS="samples demos utils contrib""
    echo ""
    echo "into"
    echo ""
    echo "    SUBDIRS="samples demos utils contrib $subwxdir""
    echo ""
    echo "Inorder to build the library and sample, and then run the sample, do the following:"
    echo ""
    echo "    cd <your_wxwidgets_library_dir>"
    echo "    ./configure or ../configure depending are you in wxWidgets base dir or a subdir"
    echo "    cd $subwxdir/src/propgrid"
    echo "    make"
    echo "    cd ../../samples/propgrid"
    echo "    make"
    echo "    ./propgridsample"
    echo ""
    exit 0;
fi

# ask if user wants to build the lib
echo "Do want to build the library and sample, and then run the sample [Y]?"
echo "Note that this will re-run configure to generate makefiles, so it may take some time."
read msgres
if test "$msgres" = "n"; then
  echo ". wxPropertyGrid Makefile.in is in $basewxdir/$subwxdir/src/propgrid"
  echo ". wxPropertyGrid Sample Makefile.in is in $basewxdir/$subwxdir/samples/propgrid"
  echo ". build like any other single wxWidgets contrib (running make in contrib"
  echo "  probably doesn't work out-of-the-box. For details, see:"
  echo "      contrib/readme-propgrid.txt"
  exit 0;
fi
if test "$msgres" = "N"; then
  echo ". wxPropertyGrid Makefile.in is in $basewxdir/$subwxdir/src/propgrid"
  echo ". wxPropertyGrid Sample Makefile.in is in $basewxdir/$subwxdir/samples/propgrid"
  echo ". build like any other single wxWidgets contrib (calling make in contrib probably"
  echo "  doesn't work out-of-the-box - see contrib/readme-propgrid.txt for details)"
  exit 0;
fi

echo "Enter library directory (For example, 'buildgtk2' or 'build-debug'."
echo "If you simply have run configure in base wxWidgets dir, just enter an empty string )"
read subbuilddir

# test sub dir
if test ! -r $basewxdir/$subbuilddir; then
  echo "Directory doesn't exist, so nothing can be done!"
  exit 0;
fi

# run configure
if test "$subbuilddir" = ""; then
  cd $basewxdir
  ./configure
else
  cd $basewxdir/$subbuilddir
  ../configure
fi

# make
cd $subwxdir/src/propgrid
make
cd ../../samples/propgrid
make
./propgridsample
