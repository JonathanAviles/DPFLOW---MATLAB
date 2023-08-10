

# the output results
In general the data saved in the results file called "distCaseResults.m" and the output matrices in the dpflow are as the following





## voltage results
are in p.u. 
```
% Bus information
%{
Bus Va(pu)    <Va   Vb(pu)     <Vb      Vc(pu)    <Vc  
%}
busInfo = [
1   1.0000  0.0000  1.0000  -120.0000   1.0000  120.0000
2   0.9950  -0.1399 0.9876  -120.1847   0.9837  119.2648
3   0.9599  -2.2580 0.9387  -123.6249   0.9171  114.7880
4   0.9055  -4.1238 0.8035  -126.7982   0.7630  102.8434
];
```

## currents results
the current in amps 

the output currents in amps.

```
% Branch information
%{
From To |IA|    <IA |IB|    <IB |IC|    <IC |PA(kW) PB(kW)  PC(kW)  QA(kVAR)    QB(kVAR)    QC(kVAR)
%}
branchInfo = [
1   2   230.0821    -35.9129    345.7275    -152.6407   455.0979    84.6491 4.3236       21.6650     19.9246     8.1020      23.2887     64.8352
3   4   689.6933    -35.9129    1036.3513   -152.6407   1364.1997   84.6491 48.5629      243.3409    223.7927    91.0018     261.5786    728.2279
2   -1  230.0821    -35.9129    345.7275    -152.6407   455.0979    84.6491 1337.2827    2074.3186   2652.4701   963.5205    1319.2449   1830.8922
-1  3   689.6933    -35.9129    1036.3513   -152.6407   1364.1997   84.6491 -1323.5629  -2043.3409  -2598.7927  -881.2018   -1133.3786  -1508.8279
];
```
