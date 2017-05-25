#! /bin/bash

. misc/parse_params.sh

execroot=$(getparam "execroot")
files=$(getparam "files")
threads=$(getparam "threadselect")
optimlevel=$(getparam "optimlevel")
outdir=$execroot/_ei_tmp
export HOME=/home/kiko

echo "<eiout>"
echo "<eicommands>"


# COMPILE
export LANGUAGE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_TYPE=en_US.UTF-8
filename=$(data +%s).out
$HOME/encore/release/encorec $files -o $outdir/$filename -O$optimlevel &> $outdir/err

# RUN OR PRINT ERROR IF COMPILATION FAILED
if [ $? == 0 ]; then


    echo "<printonconsole>"
    echo "<content format='text' execid='$execid' ext='out' refreshrate='$refresh' action='append'>"
    echo "The source files were successfully compiled to Encore!"
    echo "It is executed with the following number of ponythreads: $threads"
    echo "Optimisation level for the C compiler: $optimlevel"
    echo "</content>"
    echo "</printonconsole>"

    echo "<printonconsole consoleid='encexec' consoletitle='Encore output'>"
    echo "<content format='text' execid='$execid' ext='out' refreshrate='$refresh' action='append'>"
    echo ""
    echo "Here is the result of execution."
    echo ""
    newgrp lxd
    lxc file push $outdir/$filename my-ubuntu/tmp/ > $outdir/$filename.result 2>&1
    # lxc exec my-ubuntu -- /tmp/$filename
    # lxc exec my-ubuntu -- ./tmp/$filename --ponythreads $threads > $outdir/$filename.result 2>&1
    # lxc exec my-ubuntu -- rm /tmp/$filename
    cat $outdir/$filename.result
    # $outdir/$filename --ponythreads $threads

    # use lines below if we need to time the program
    # (these lines need to be tested before production)
    #
    # time -o $outdir/output.txt $outdir/a.out --ponythreads $threads
    # cat $outdir/output.txt
    #

    echo "</content>"
    echo "</printonconsole>"
    echo "</eicommands>"

else
    echo "<printonconsole>"
    echo "<content format='text'><![CDATA[ There are some errors!"
    cat $outdir/err
    echo "]]></content>"
    echo "</printonconsole>"
    echo "</eicommands>"
fi

echo "</eiout>"
