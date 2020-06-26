function Save_Var_to_File(var,file_name)
  
  filename = [file_name ".txt"] ;%adds .txt to the file's name
  
  %open the file; set the mode to "w"rite
  fid = fopen( filename, "w" );
  
  %save the variable into the file. For unknown reasons the variable must be in quotes
  save (filename,"var");
  
  %close the file so that you can access the file after octave finishes running
  fclose ( fid );
  
  #tell user that the file was saved
  disp(["Results added to " filename]);
endfunction
