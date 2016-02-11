#!/bin/bash
set -e

# Figure out where this script is located.
SELFDIR="`dirname \"$0\"`"
APPDIR="`cd \"$SELFDIR/lib/app" && pwd`"
BINDIR="`cd \"$SELFDIR/lib/ruby" && pwd`"

cd $APPDIR
# Run the actual app using the bundled Ruby interpreter.
echo "

=> Goto: http://localhost:5000/viewer/#/url/http://localhost:5000/reports/report.json

"
exec "$APPDIR/run_http_rb.sh"
#exec "$BINDIR/bin/rake" "reports:view"
