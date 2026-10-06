* ============================================================
* SUBPROGRAM: DATDIFF
* PURPOSE   : Calculate day difference (supports YYYY-MM-DD)
* ============================================================
DEFINE DATA
PARAMETER
1 P-DATE-1     (A10)
1 P-DATE-2     (A10)
1 P-DAYS-DIFF  (I4)
LOCAL
1 #Y1 (I4) 1 #M1 (I2) 1 #D1 (I2)
1 #Y2 (I4) 1 #M2 (I2) 1 #D2 (I2)
1 #JDN1 (I5) 1 #JDN2 (I5)
1 #A (I4) 1 #B (I4) 1 #C (I4)
1 #X1 (I4) 1 #X2 (I4)
END-DEFINE

MOVE SUBSTRING(P-DATE-1, 1, 4) TO #Y1
MOVE SUBSTRING(P-DATE-1, 6, 2) TO #M1
MOVE SUBSTRING(P-DATE-1, 9, 2) TO #D1
MOVE SUBSTRING(P-DATE-2, 1, 4) TO #Y2
MOVE SUBSTRING(P-DATE-2, 6, 2) TO #M2
MOVE SUBSTRING(P-DATE-2, 9, 2) TO #D2

* Julian Day Number conversion
COMPUTE #A = (#M1 - 14) / 12
COMPUTE #X1 = #D1 - 32075 + 1461 * (#Y1 + 4800 + #A) / 4
            + 367 * (#M1 - 2 - #A * 12) / 12
            - 3 * ((#Y1 + 4900 + #A) / 100) / 4

COMPUTE #A = (#M2 - 14) / 12
COMPUTE #X2 = #D2 - 32075 + 1461 * (#Y2 + 4800 + #A) / 4
            + 367 * (#M2 - 2 - #A * 12) / 12
            - 3 * ((#Y2 + 4900 + #A) / 100) / 4

COMPUTE P-DAYS-DIFF = #X2 - #X1
END