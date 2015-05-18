function parseAllFiles( input_dir, output_dir )

d = dir([input_dir '/*_out.txt']);

for i = 1:length(d)
    dirname = d(i).name(1:6);
    dirname
    mkdir([output_dir '/' dirname]);
    parseFile([input_dir '/' d(i).name],[output_dir '/' dirname]);
end


end