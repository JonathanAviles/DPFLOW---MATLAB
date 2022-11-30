% caseObject = distCase_test11nodesGen;
% savedistcase('distCase_test11nodes',{'Distribution test feeder, 11 nodes, unbalanced conditions for testing',...
%     'Please see distributionCaseFormat.m for details on the case file format'},caseObject);

caseObject = distCase_4Dyg1Gen;
savedistcase('distCase_4Dyg1',{'IEEE distribution test feeder, 4 nodes, step-down distribution',...
    'transformer, Dyg1 connection.','Please see distributionCaseFormat.m for details on the case file format'},caseObject);

caseObject = distCase_4YGd1Gen;
savedistcase('distCase_4YGd1',{'IEEE distribution test feeder, 4 nodes, step-down distribution',...
    'transformer, 4YGd1 connection.','Please see distributionCaseFormat.m for details on the case file format'},caseObject);

caseObject = distCase_4Dyg1_ctCurGen;
savedistcase('distCase_4Dyg1_ctCur',{'IEEE distribution test feeder, 4 nodes, step-down distribution',...
    'transformer, Dyg1 connection.','Please see distributionCaseFormat.m for details on the case file format'},caseObject);

caseObject = distCase_4YGd1_ctCurGen;
savedistcase('distCase_4YGd1_ctCur',{'IEEE distribution test feeder, 4 nodes, step-down distribution',...
    'transformer, 4YGd1 connection.','Please see distributionCaseFormat.m for details on the case file format'},caseObject);

caseObject = distCase_test13nodes_modGen;
savedistcase('distCase_test13nodes_mod',{'Distribution test feeder, 12 nodes, unbalanced conditions for testing',...
    'Please see distributionCaseFormat.m for details on the case file format'},caseObject);
