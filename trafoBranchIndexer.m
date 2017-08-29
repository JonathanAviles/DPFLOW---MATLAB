function [FBUS, TBUS, RPU, XPU, TCONN, PTAP, STAP, TSTAT] = trafoBranchIndexer
%%  Description:
%   Defines constants for named column indices to transformer branch matrix.

%%  Notes:
%   See also distCaseFormat for meaning of tags.

%%  Transformer branch matrix columns
FBUS       = 1;
TBUS       = 2;
RPU        = 3;
XPU        = 4;
TCONN      = 5;
PTAP       = 6;
STAP       = 7;
TSTAT      = 8;
