function file_details = Save_Var_to_File(var,file_name)
  full_name = [file_name ".mat"] ;%adds .mat to the file's name
  f = fopen(full_name,"w");
  save f var
  fclose(f)
  disp(["Results added to "  full_name])
  file_details = ["Results added to "  full_name]
endfunction
