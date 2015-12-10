#!/bin/bash
set -e

# Figure out where this script is located.
SELFDIR="`dirname \"$0\"`"
APPDIR="`cd \"$SELFDIR/lib/app" && pwd`"
BINDIR="`cd \"$SELFDIR/lib/ruby" && pwd`"

cd $APPDIR
# Run the actual app using the bundled Ruby interpreter.
exec "$BINDIR/bin/rake" "reports:view"
