#! /bin/bash

. misc/parse_params.sh

execroot=$(getparam "execroot")
files=$(getparam "files")
threads=$(getparam "threadselect")
optimlevel=$(getparam "optimlevel")
outdir=$execroot/_ei_tmp
export HOME=/Users/kikofernandezreyes

echo "<eiout>"
echo "<eicommands>"


# COMPILE
# /Users/einar/git/encore/release/encorec $files -o $outdir/a.out --verbose > $outdir/stdout
$HOME/Code/encore/release/encorec $files -o $outdir/a.out -O$optimlevel &> $outdir/err

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
    $outdir/a.out --ponythreads $threads

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
