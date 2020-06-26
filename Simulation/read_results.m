function var = read_results(file_name)
  filename = [file_name ".mat"] ;%adds .mat to the file's name
  fid = fopen (filename, "r");%creates a file of name filename. sets file to writable
  fputs(fid, var);%put the variable into the file
  fclose (fid); %close the file for good house keeping
  var = 
endfunction
