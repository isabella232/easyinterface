#! /bin/bash

. misc/parse_params.sh

execroot=$(getparam "execroot")
files=$(getparam "files")
others=$(getparam "others")
outdir=$execroot/_ei_tmp
export HOME=/Users/kikofernandez

echo "<eiout>"
echo "<eicommands>"

# COMPILE
# /Users/einar/git/encore/release/encorec $files -o $outdir/a.out --verbose > $outdir/stdout
# /Users/einar/git/encore/release/encorec $files -tc

# RUN OR PRINT ERROR IF COMPILATION FAILED
if [ $? == 0 ]; then

    echo "<printonconsole>"
    echo "<content format='text' execid='$execid' ext='out' refreshrate='$refresh' action='append'>"
    echo "Compiling into Encore."
    echo ""
if [ $others == verbose ]; then
    encorec $files -tc --verbose
else
    encorec $files -tc
fi
    echo "</content>"
    echo "</printonconsole>"
fi
    echo "</eicommands>"
    echo "</eiout>"
