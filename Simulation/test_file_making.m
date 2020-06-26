%test file making
filename = "my_test_file2.txt";
fid = fopen( filename, "w" );
A = [ 1 2 3 4 5 6 7 8 4 ];
save (filename,"A");
fclose ( fid );