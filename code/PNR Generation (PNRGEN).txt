* ============================================================
* SUBPROGRAM: PNRGEN
* PURPOSE   : Generate unique PNR locator (6 chars alnum)
* ============================================================
DEFINE DATA
PARAMETER
1 P-PNR             (A8)
LOCAL
1 #CHARSET          (A36) INIT <'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'>
1 #I                (I2)
1 #IDX              (I2)
1 #EXISTS           (L)
1 #SEED             (I4)
1 BK VIEW OF BOOKING
END-DEFINE

MOVE *TIMX TO #SEED
REPEAT
  RESET P-PNR
  FOR #I = 1 TO 6
    COMPUTE #IDX = (#SEED * #I * 37) MOD 36 + 1
    MOVE SUBSTRING(#CHARSET, #IDX, 1) TO
         SUBSTRING(P-PNR, #I, 1)
  END-FOR
  * Check uniqueness
  RESET #EXISTS
  FIND BOOKING WITH BK-PNR-LOCATOR = P-PNR
    MOVE TRUE TO #EXISTS
  END-FIND
  ADD 7 TO #SEED
UNTIL #EXISTS = FALSE
END-REPEAT
END