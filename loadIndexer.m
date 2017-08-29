function [BID, PD01, PD02, PD03, QD01, QD02, QD03, PD11, PD12, PD13, QD11, ...
    QD12, QD13, PD21, PD22, PD23, QD21, QD22, QD23, LSTAT] = loadIndexer
%%  Description:
%   Defines constants for named column indices to yload and dload matrices.

%%  Notes:
%   See also distCaseFormat for meaning of tags.
%    This indexer may be utilized to assign column number to both yload a
%    deltaload bus matrices, as follows:
%     
%    [BID, YPD0A, YPD0B, YPD0C, YQD0A, YQD0B, YQD0C, YPD1A, YPD1B, YPD1C,
%    YQD1A, YQD1B, YQD1C, YPD2A, YPD2B, YPD2C, YQD2A, YQD2B, YQD2C, YLSTAT]
%    = loadIndexer
%    [BID, DPD0AB, DPD0BC, DPD0CA, DQD0AB, DQD0BC, DQD0CA, DPD1AB, DPD1BC,
%    DPD1CA, DQD1AB, DQD1BC, DQD1CA, DPD2AB, DPD2BC, DPD2CA, DQD2AB,
%    DQD2BC, DQD2CA, DLSTAT] = loadIndexer

%%  yload or dload matrix columns
BID     = 1;
PD01    = 2;
PD02    = 3;
PD03    = 4;
QD01    = 5;
QD02    = 6;
QD03    = 7;
PD11    = 8;
PD12    = 9;
PD13    = 10;
QD11    = 11;
QD12    = 12;
QD13    = 13;
PD21    = 14;
PD22    = 15;
PD23    = 16;
QD21    = 17;
QD22    = 18;
QD23    = 19;
LSTAT   = 20;
