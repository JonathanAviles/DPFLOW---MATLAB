function [FBUS, TBUS, R11, R12, R13, R22, R23, R33, X11, X12, X13, X22, ...
    X23, X33, B11, B12, B13, B22, B23, B33, LBSTAT] = lineBranchIndexer
%%  Description:
%   Defines constants for named column indices to line branch matrix.

%%  Notes:
%   See also distCaseFormat for meaning of tags.

%%  Line branch matrix columns
FBUS       = 1;
TBUS       = 2;
R11        = 3;
R12        = 4;
R13        = 5;
R22        = 6;
R23        = 7;
R33        = 8;
X11        = 9;
X12        = 10;
X13        = 11;
X22        = 12;
X23        = 13;
X33        = 14;
B11        = 15;
B12        = 16;
B13        = 17;
B22        = 18;
B23        = 19;
B33        = 20;
LBSTAT     = 21;


