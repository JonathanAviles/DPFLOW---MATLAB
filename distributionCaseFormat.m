%%  Description
%   Defines the distribution case file format in a similar way to MATPOWER
%   case files.
%   
%   The file creates a structure called caseObject, that contains all the
%   relevant data for a distribution electrical network.
%   The fields of this structure are baseMVA, bus, gen, yload, dload,
%   lineBranch and transformerBranch. With the exception of baseMVA, a
%   scalar, each data variable is a matrix, where a row corresponds to a
%   single bus or branch.
%
%   The functions loadDistCase and saveDistCase are to be used to load and
%   save distribution case files.
%
%   See also busIndexer, genIndexer, yloadIndexer, dloadIndexer,
%   lineBranchIndexer and trafoBranchIndexer regarding constants which can
%   be used as named column indices for the data matrices.
%
%   objectCase.baseMVA: It refers to single-phase base power in MVA.
%
%   objectCase.bus: Bus data
%       1   bID: Identifier (Positive integer)
%       2   type
%               PQ bus          = 1
%               PV bus          = 2
%               reference bus   = 3
%               isolated bus    = 4
%       3   VmA, voltage magnitude on phase A (p.u.)
%       4   VmB, voltage magnitude on phase B (p.u.)
%       5   VmC, voltage magnitude on phase C (p.u.)
%       6   VaA, voltage angle on phase A (degrees)
%       7   VaB, voltage angle on phase B (degrees)
%       8   VaC, voltage angle on phase C (degrees)
%       9   baseKV, single-phase base voltage (kV)
%
%   objectCase.gen: Generation data
%       1   bID: Bus to which the generator/generators is/are connected
%       2   PgA, Active power injection into phase A (MW)
%       3   PgB, Active power injection into phase B (MW)
%       4   PgC, Active power injection into phase C (MW)
%       5   QgA, Rective power injection into phase A (MVAR)
%       6   QgB, Rective power injection into phase B (MVAR)
%       7   QgC, Rective power injection into phase C (MVAR)
%       8   Status, 0 is OFF, 1 is ON
%
%   objectCase.yload: Y-connected load data
%       1   bID: Bus to which the load is connected
%       2   YPd0A, Phase-A active power load. Power-constant component (MW)
%       3   YPd0B, Phase-B active power load. Power-constant component (MW)
%       4   YPd0C, Phase-C active power load. Power-constant component (MW)
%       5   YQd0A, Phase-A reactive power load. Power-constant component (MVAR)
%       6   YQd0B, Phase-B reactive power load. Power-constant component (MVAR)
%       7   YQd0C, Phase-C reactive power load. Power-constant component (MVAR)
%       8   YPd1A, Phase-A active power load. Current-constant component (MW)
%       9   YPd1B, Phase-B active power load. Current-constant component (MW)
%       10  YPd1C, Phase-C active power load. Current-constant component (MW)
%       11  YQd1A, Phase-A reactive power load. Current-constant component (MVAR)
%       12  YQd1B, Phase-B reactive power load. Current-constant component (MVAR)
%       13  YQd1C, Phase-C reactive power load. Current-constant component (MVAR)
%       14  YPd2A, Phase-A active power load. Impedance-constant component (MW)
%       15  YPd2B, Phase-B active power load. Impedance-constant component (MW)
%       16  YPd2C, Phase-C active power load. Impedance-constant component (MW)
%       17  YQd2A, Phase-A reactive power load. Impedance-constant component (MVAR)
%       18  YQd2B, Phase-B reactive power load. Impedance-constant component (MVAR)
%       19  YQd2C, Phase-C reactive power load. Impedance-constant component (MVAR)
%       20  Status, 0 is OFF, 1 is ON
%
%   objectCase.dload: Delta-connected load data
%       1   bID: Bus to which the load is connected
%       2   YPd0AB, Active power load between phases A and B. Power-constant component (MW)
%       3   YPd0BC, Active power load between phases B and C. Power-constant component (MW)
%       4   YPd0CA, Active power load between phases C and A. Power-constant component (MW)
%       5   YQd0AB, Reactive power load between phases A and B. Power-constant component (MVAR)
%       6   YQd0BC, Reactive power load between phases B and C. Power-constant component (MVAR)
%       7   YQd0CA, Reactive power load between phases C and A. Power-constant component (MVAR)
%       8   YPd1AB, Active power load between phases A and B. Current-constant component (MW)
%       9   YPd1BC, Active power load between phases B and C. Current-constant component (MW)
%       10  YPd1CA, Active power load between phases C and A. Current-constant component (MW)
%       11  YQd1AB, Reactive power load between phases A and B. Current-constant component (MVAR)
%       12  YQd1BC, Reactive power load between phases B and C. Current-constant component (MVAR)
%       13  YQd1CA, Reactive power load between phases C and A. Current-constant component (MVAR)
%       14  YPd2AB, Active power load between phases A and B. Impedance-constant component (MW)
%       15  YPd2BC, Active power load between phases B and C. Impedance-constant component (MW)
%       16  YPd2CA, Active power load between phases C and A. Impedance-constant component (MW)
%       17  YQd2AB, Reactive power load between phases A and B. Impedance-constant component (MVAR)
%       18  YQd2BC, Reactive power load between phases B and C. Impedance-constant component (MVAR)
%       19  YQd2CA, Reactive power load between phases C and A. Impedance-constant component (MVAR)
%       20  Status, 0 is OFF, 1 is ON
%
%   objectCase.lineBranch: Distribution line branch data
%       1   fbus, from bus ID
%       2   tbus, to bus ID
%       3   R11, (1,1) element from the primitive resistance matrix (p.u.)
%       4   R12, (1,2) element from the primitive resistance matrix (p.u.)
%       5   R13, (1,3) element from the primitive resistance matrix (p.u.)
%       6   R22, (2,2) element from the primitive resistance matrix (p.u.)
%       7   R23, (2,3) element from the primitive resistance matrix (p.u.)
%       8   R33, (3,3) element from the primitive resistance matrix (p.u.)
%       9   X11, (1,1) element from the primitive reactance matrix (p.u.)
%       10  X12, (1,2) element from the primitive reactance matrix (p.u.)
%       11  X13, (1,3) element from the primitive reactance matrix (p.u.)
%       12  X22, (2,2) element from the primitive reactance matrix (p.u.)
%       13  X23, (2,3) element from the primitive reactance matrix (p.u.)
%       14  X33, (3,3) element from the primitive reactance matrix (p.u.)
%       15  B11, (1,1) element from the primitive susceptance matrix (p.u.)
%       16  B12, (1,2) element from the primitive susceptance matrix (p.u.)
%       17  B13, (1,3) element from the primitive susceptance matrix (p.u.)
%       18  B22, (2,2) element from the primitive susceptance matrix (p.u.)
%       19  B23, (2,3) element from the primitive susceptance matrix (p.u.)
%       20  B33, (3,3) element from the primitive susceptance matrix (p.u.)
%       21  Status, 0 is OFF, 1 is ON
%
%   objectCase.trafoBranch: Distribution transformer branch data
%       1   fbus, from bus ID
%       2   tbus, to bus ID
%       3   RPU, resistance (p.u.)
%       4   XPU, reactance(p.u.)
%       5   TCONN, Integer number
%               = 1:       Yg-Yg connection
%               = 2:       D-Yg  connection
%               = 3:       Yg-D  connection
%               = 4:       D-D   connection
%               = 5:       Y-Y   connection
%               = 6:       Y-D   connection
%               = 7:       D-Y   connection
%               = 8:             connection
%               = 9:             connection
%               Otherwise: Y-Y connection
%               (Yg : Grounded wye winding
%                D  : Grounded delta winding
%                Y :  Ungrounded wye winding)
%       6   PrimTap, Tap variation at the primary winding
%       7   SecTap, Tap variation at the secondary winding
%       8   Status, 0 is OFF, 1 is ON
%       