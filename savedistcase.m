function fname_out = savedistcase(fname, varargin)
%%  Description:
%   SAVEDISTCASE(FNAME, CASESTRUCT)
%   SAVEDISTCASE(FNAME, COMMENT, CASESTRUCT)
%   FNAME = SAVEDISTCASE(FNAME, ...)
%
%   Saves a distribution case file, given a filename and the data.
%   The FNAME parameter is the name of the file to be created or overwritten. 
%   Optionally returns the filename, with extension added if necessary. The
%   optional COMMENT argument is either string (single line comment) or a
%   cell array of strings which are inserted as comments.

%%  Labels
[PQ, PV, REF, NONE, BID, TYPE, VMA, VMB, VMC, VAA, VAB, VAC, BASEKV] = busIndexer;
[~, PGA, PGB, PGC, QGA, QGB, QGC, GSTAT] = genIndexer;
[~, YPD0A, YPD0B, YPD0C, YQD0A, YQD0B, YQD0C, YPD1A, YPD1B, YPD1C, YQD1A, ...
    YQD1B, YQD1C, YPD2A, YPD2B, YPD2C, YQD2A, YQD2B, YQD2C, YLSTAT]= loadIndexer;
[~, DPD0AB, DPD0BC, DPD0CA, DQD0AB, DQD0BC, DQD0CA, DPD1AB, DPD1BC, DPD1CA, ...
    DQD1AB, DQD1BC, DQD1CA, DPD2AB, DPD2BC, DPD2CA, DQD2AB, DQD2BC, DQD2CA, DLSTAT] = loadIndexer;
[FBUS, TBUS, R11, R12, R13, R22, R23, R33, X11, X12, X13, X22, X23, X33, ...
    B11, B12, B13, B22, B23, B33, LBSTAT] = lineBranchIndexer;
[~, ~, RPU, XPU, TCONN, PTAP, STAP, TSTAT] = trafoBranchIndexer;

%%  Comments
if ischar(varargin{1}) || iscell(varargin{1})
    if ischar(varargin{1})
        comment = {varargin{1}};    % Convert char to single element cell array
    else
        comment = varargin{1};
    end
    [args{1:(length(varargin)-1)}] = deal(varargin{2:end});
else
    comment = {''};
    args = varargin;
end

%% Case data  
caseObject = args{1};
[baseMVA, bus, gen, yload, dload, lineBranch, trafoBranch] = deal(...
    caseObject.baseMVA, caseObject.bus, caseObject.gen, caseObject.yload, ...
    caseObject.dload, caseObject.lineBranch, caseObject.trafoBranch);

%% Verify valid filename
[pathstr, fcn_name, extension] = fileparts(fname);
if isempty(extension)
    extension = '.m';
end
if regexp(fcn_name, '\W')
    old_fcn_name = fcn_name;
    fcn_name = regexprep(fcn_name, '\W', '_');
    fprintf('WARNING: ''%s'' is not a valid function name, changed to ''%s''\n', old_fcn_name, fcn_name);
end
fname = fullfile(pathstr, [fcn_name extension]);

%% Open and write the file
if strcmpi(extension, '.MAT')     % MAT-file
    save(fname, 'baseMVA', 'mpc', vflag);
else                              % M-file
    %%  Open file
    [fd, msg] = fopen(fname, 'wt');     % print it to an M-file
    
    %%  Print error message if not valid
    if fd == -1
        error(['savecase: ', msg]);
    end
    
    %%  Function header and comments
    fprintf(fd, 'function caseObject = %s\n\n', fcn_name);
    prefix = 'caseObject.';    
    if ~isempty(comment{1})
        fprintf(fd, '%%%%  Comments:\n');
        for k = 1:length(comment)
            fprintf(fd, '%%   %s\n', comment{k});
        end
        fprintf(fd, '\n');
    end
    fprintf(fd, '%%%%  Single phase base power\n');
    fprintf(fd, '%sbaseMVA = %.10f;\n\n', prefix, baseMVA);
    
    %%  Bus data
    fprintf(fd, '%%%%  Bus data:\n');
    fprintf(fd, '%%{\n');
    fprintf(fd, 'bID\ttype\tVmA\tVmB\tVmC\tVaA\tVaB\tVaC\tbaseKV\n');
    fprintf(fd, '%%}\n');
    fprintf(fd, '%sbus = [\n', prefix);
    fprintf(fd, '%d\t%d\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f;\n', bus.');
    fprintf(fd, '];\n\n');
    
    %%  Generator data
    fprintf(fd, '%%%%  Generator data:\n');
    fprintf(fd, '%%{\n');
    fprintf(fd, 'bID\tPgA\tPgB\tPgC\tQgA\tQgB\tQgC\tStatus\n');
    fprintf(fd, '%%}\n');
    fprintf(fd, '%sgen = [\n', prefix);
    fprintf(fd, '%d\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%d;\n', gen.');
    fprintf(fd, '];\n\n');
    
    %%  Wye-load data
    fprintf(fd, '%%%%  Wye-load:\n');
    fprintf(fd, '%%{\n');
    fprintf(fd, 'bID\tYPd0A\tYPd0B\tYPd0C\tYQd0A\tYQd0B\tYQd0C\tYPd1A\tYPd1B\tYPd1C\tYQd1A\tYQd1B\tYQd1C\tYPd2A\tYPd2B\tYPd2C\tYQd2A\tYQd2B\tYQd2C\tStatus\n');
    fprintf(fd, '%%}\n');
    fprintf(fd, '%syload = [\n', prefix);
    if ~isempty(yload)
        fprintf(fd, '%d\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%d;\n', yload.');
    end
    fprintf(fd, '];\n\n');
    
    %%  Delta-load data
    fprintf(fd, '%%%%  Delta-load:\n');
    fprintf(fd, '%%{\n');
    fprintf(fd, 'bID\tDPd0AB\tDPd0BC\tDPd0CA\tDQd0AB\tDQd0BC\tDQd0CA\tDPd1AB\tDPd1BC\tDPd1CA\tDQd1AB\tDQd1BC\tDQd1CA\tDPd2AB\tDPd2BC\tDPd2CA\tDQd2AB\tDQd2BC\tDQd2CA\tStatus\n');
    fprintf(fd, '%%}\n');
    fprintf(fd, '%sdload = [\n', prefix);
    if ~isempty(dload)
        fprintf(fd, '%d\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%d;\n', dload.');
    end
    fprintf(fd, '];\n\n');
    
    %%  Line branch data
    fprintf(fd, '%%%%  Line branch data:\n');
    fprintf(fd, '%%{\n');
    fprintf(fd, 'fbus\ttbus\tR11\tR12\tR13\tR22\tR23\tR33\tX11\tX12\tX13\tX22\tX23\tX33\tB11\tB12\tB13\tB22\tB23\tB33\tStatus\n');
    fprintf(fd, '%%}\n');
    fprintf(fd, '%slineBranch = [\n', prefix);
    if ~isempty(lineBranch)
        fprintf(fd, '%d\t%d\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%.10f\t%d;\n', lineBranch.');
    end
    fprintf(fd, '];\n\n');
    
    %%  Transformer branch data
    fprintf(fd, '%%%%  Transformer branch data:\n');
    fprintf(fd, '%%{\n');
    fprintf(fd, 'fbus\ttbus\tRpu\tXpu\tTConn\tPrimTap\tSecTap\tStatus\n');
    fprintf(fd, '%%}\n');
    fprintf(fd, '%strafoBranch = [\n', prefix);
    if ~isempty(trafoBranch)
        fprintf(fd, '%d\t%d\t%.10f\t%.10f\t%d\t%.10f\t%.10f\t%d;\n', trafoBranch.');
    end
    fprintf(fd, '];\n\n');
    
    %%  End functions
    fprintf(fd, 'end');

    %% close file
    if fd ~= 1
        fclose(fd);
    end
end

if nargout > 0
    fname_out = fname;
end

end
