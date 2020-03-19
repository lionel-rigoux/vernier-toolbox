function compile_GoIO ()

cFiles = dir('*.c');

for iFile = 1 : numel (cFiles)
    if ismac()
        eval (sprintf ('mex  -L.. -lGoIO -outdir .. %s', cFiles(iFile).name));
        [~,fName]=fileparts(cFiles(iFile).name);
        system (sprintf ('install_name_tool -change libGoIO.dylib @dynamometer/libGoIO.dylib ../%s.mexmaci64',fName));
    elseif isunix ()
    else
        eval (sprintf ('mex  -L.. -lGoIO_DLL -outdir .. %s', cFiles(iFile).name));
    end
end