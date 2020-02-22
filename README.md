# BIN2BAS64
This is a GUI adaptation of the code made by Dav for QB64 (http://www.qbasicnews.com/dav/files/basfile.bas) (originally in QBasic (http://www.qbasicnews.com/dav/files/bin2bas.bas)) that would turn any file into a .bas file that could then be included in QB64 code to be compiled and create the original file once again.
This program can accept a drag and drop onto the program icon as well as a file drop into the program window itself.

QB64, in which this program was written, can handle files up to 9 gigabytes. While my program can handle files up to this size, it is the output file that is the issue. Base64 makes files 30-33% larger. If you try to compile the output file, your compilation WILL FAIL due to running out of memory, even with an 8 megabyte output file. I'm not sure what size file is the limit, but try sticking to icons, text files, small pictures, etc. This is not a viable option for making your own "zipped" installer or program as this makes all the files larger, actually.

# SOLUTION TO MEMORY ISSUE:
You can compile the code that this program creates by putting this at the top of the output file: (#lang "qb") without parentheses and removing the line with the IF FILEEXISTS and the corresponding line with the END IF. You can then compile the code in FreeBasic and it can handle larger files than QB64.
