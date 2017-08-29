function [PQ, PV, REF, NONE, BID, TYPE, VMA, VMB, VMC, VAA, VAB, VAC, BASEKV] = busIndexer

%%  Description:
%   Defines constants for bus types and named column indices to bus matrix.

%%  Notes:
%   See also distCaseFormat for meaning of tags.

%%  Bus types
PQ      = 1;
PV      = 2;
REF     = 3;
NONE    = 4;

%%  Bus matrix columns
BID     = 1;
TYPE    = 2;
VMA     = 3;
VMB     = 4;
VMC     = 5;
VAA     = 6;
VAB     = 7;
VAC     = 8;
BASEKV  = 9;

end