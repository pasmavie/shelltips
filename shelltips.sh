############
# SHEBANGS #
############

#!/bin/sh
#!/usr/bin/env shell

########
# curl #
########
curl \
    -X POST \
    -H "Content-Type: text/csv" \
    --data-binary @/directory/file \
    http://url?param=param

curl \
    -X POST \
    -H "Content-Type: application/json" \
    --data {"key":"value"} \
    http://url?param=param

#############
# PROCESSES #
#############

#stats, list & kill processes
htop
#or
ps -A|grep ssh # to search for PIDs
kill PID
#or
pstree
pgrep programname #returns the process ID that match the process
pkill programname

#:::::::::::::::::::::::::::::::::::::::::::::
# SEARCH
#:::::::::::::::::::::::::::::::::::::::::::::

find / -iname caseinsensitivenameofmydir -type d 2>&1 | grep -v -e "Permission denied" -e "Operation not permitted"
find . -name '*dirname*' -type f -size 1033c ! -executable #searchs for file with size 1033byte and not executable
find . -name '*.zip' -exec mv {} /path/to/new/directory \;
find . -name '*.log' -exec sh -c "cat /path/to/file.log >> {}" \;

#:::::::::::::::::::::::::::::::::::::::::::::
# AWK
#:::::::::::::::::::::::::::::::::::::::::::::
# use awk to pick a single field out of an input stream like this:
ls -l | awk '{print $5}'

#:::::::::::::::::::::::::::::::::::::::::::::
		# SED
#:::::::::::::::::::::::::::::::::::::::::::::
# reuse part of match
echo "ABC 123 ABC" | sed -E 's/([0-9]) ([a-zA-Z])/\1,\2/g' # becomes "ABC 123,ABC" # () to separe groups # note [[:digit]] and [[:alpha:]] in place of [0-9] and [a-zA-Z] for unicode?
# delete any line matching 'foo'
sed '/foo/d'
# delete lines 3-to-6 and pass to stdoutput
sed 3,6d /path/to/filefoo

#::::::::::::::::::::::::::::::::::::::::::::::
# PARALLEL
#::::::::::::::::::::::::::::::::::::::::::::::
input_to_parallelize | parallel -j 8 --pipe -N 5000 'cmd_to_run'

#:::::::::::::::::::::::::::::::::::::::::::::
		# XARGS 
#:::::::::::::::::::::::::::::::::::::::::::::
#to run 1 cmd on a large number of files
#xargs reads items from  the  stdinput, delimited by blanks, newlines...
# and execute the cmd with any initial arg followed by items read from stdinput
find . -name '*.gif' -print | xargs file
# with null bytes as delimiters for stdinput - for security reason 
find . -name '*.gif' -print0 | xargs -0 file

#:::::::::::::::::::::::::::::::::::::::::::::
		# EXEC
#:::::::::::::::::::::::::::::::::::::::::::::
#replaces the current shell process with the program you name after exec, when the cmd ends, the shell is closed. Es.:
exec sleep 5

#:::::::::::::::::::::::::::::::::::::::::::::
		# MOUNT
#:::::::::::::::::::::::::::::::::::::::::::::
sudo umount /dev/sdX 

#::::::::::::::::::::::::::::::::::::::::::::::::::
		# MAKE BOOTABLE USB STICK
#:::::::::::::::::::::::::::::::::::::::::::::
sudo dd if=osimage.iso of=/dev/sdX bs=4M [&& sync]


#::::::::::::::::::::::::::::::::::::::::::::
		#ARCHIVES:
#::::::::::::::::::::::::::::::::::::::::::::::::::
# compress tar
tar -cvf name-of-archive.tar /path/to/directory-or-file
tar -czvf name-of-archive.tar.gz /path/to/directory-or-file
# uncompress tar
tar -xvf name-of-archive.tar
tar -xzvf name-of-archive.tar.gz


##########################
#        CONTROLS
##########################

		# ()
# for subshells enclose cmds in parenthesis (they do not alter shell environment)
		
		# .
# to call cmds from other scripts include:  . otherscript.sh
		
		# READ
# reads text from stdinput and stores in $var 
read var; echo $var

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# IF CONDITIONS && FOR LOOPS

# funny example: list files in folder and search for a word into them
for filename in *; do
	# check if f is a file
	if [ -f $filename ]; then
		ls -l $filename
		file $filename
		# nested
		if grep -q "$1" $filename; then
			echo '"'$1'"' " was in $filename"
		elif [ $1 = imprecazione ] || [ $1 = parolaccia ]; then
			echo 'The first argument "'$1'" was illegal'
		else
			echo '"'$1'"' "was not in $filename"
		fi
	else
		echo '$filename is not a regular file.'
	fi
done

# CASE MATCH

# match strings with case is useful because 'case' does not evaluate exit codes: -> it's less prone to errors
FLAGS=`grep ^flags /proc/cpuinfo | sed 's/.*://' | head -1` #assign a cmd output to a variable by enclosing in backquotes ``
echo Your processor supports:
for f in $FLAGS; do
case $f in
	fpu)
		MSG="floating point unit"
		;;
	*)
		MSG="unknown"
		;;
esac
echo $f: $MSG
done

#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

# super bomb
# create tmp files with extension associated with process id
TMPFILE1=`touch /tmp/im1.$$`
TMPFILE2=`touch /tmp/im2.$$`
# store interrupt logs into first file
cat /proc/interrupts > $TMPFILE1
# wait 2 seconds
sleep 2
# store interrupt logs into second file
cat /proc/interrupts > $TMPFILE2
# show differences (basically...if sth happened in the last 2 seconds we catch it)
diff $TMPFILE1 $TMPFILE2
# remove the files. THANKS TO "trap" it is INVULNERABLE TO SIGNAL THAT ABORT THE SCRIPT
# Notice that you must use exit in the handler to explicitly end script execution. 
# Otherwise, the shell continues running as usual after running the signal handler.
trap "rm -f $TMPFILE1 $TMPFILE2; exit 1" INT
