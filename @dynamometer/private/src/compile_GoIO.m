function compile_GoIO ()

cFiles = dir('*.c');

for iFile = 1 : numel (cFiles)
    if isunix ()
        eval (sprintf ('mex  -L.. -lGoIO -outdir .. %s', cFiles(iFile).name));
        [~,fName]=fileparts(cFiles(iFile).name);
        % on unix machines, the shared library is not found if it's not in
        % the path or in the DYLD_LIBRARY_PATH or LD_LIBRARY_PATH. An
        % alternative solution is to link the shared library relative to the
        % caller (parent of @dynamometer). There might be a way to do this
        % while calling mex (how?)... Here, we simply correct the path
        % after compilation
        if ismac()
            system (sprintf ('install_name_tool -change libGoIO.dylib @loader_path/libGoIO.dylib ../%s.mexmaci64',fName));
        else
            system (sprintf ('patchelf --replace-needed libGoIO.so.2 @dynamometer/private/libGoIO.so ../%s.mexa64',fName));
        end
    else
        eval (sprintf ('mex  -L.. -lGoIO_DLL -outdir .. %s', cFiles(iFile).name));
    end
end