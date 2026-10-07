* ============================================================
* PROGRAM : FLTUPD
* PURPOSE : Auto-update flight statuses based on time
* ============================================================
DEFINE DATA LOCAL
1 FS VIEW OF FLIGHT-SCHEDULE
1 #NOW-DATE   (A10)
1 #NOW-TIME   (A5)
1 #DEP-TIME   (A5)
1 #DIFF-MIN   (I4)
END-DEFINE

MOVE *DATX TO #NOW-DATE
MOVE *TIMX TO #NOW-TIME

FIND FLIGHT-SCHEDULE WITH FS-DEPARTURE-DATE = #NOW-DATE
  #DEP-TIME := FS-SCHEDULED-DEP-TIME

  * Calculate minutes until scheduled departure
  COMPUTE #DIFF-MIN = (VAL(#DEP-TIME) / 100 * 60 +
                       VAL(#DEP-TIME) MOD 100) -
                      (VAL(#NOW-TIME) / 100 * 60 +
                       VAL(#NOW-TIME) MOD 100)

  DECIDE FOR FIRST CONDITION
    WHEN #DIFF-MIN <= -30 AND FS-FLIGHT-STATUS = 'SC'
      UPDATE FLIGHT-SCHEDULE
        FS-FLIGHT-STATUS := 'DP'
        FS-ACTUAL-DEP-TIME := #NOW-TIME
    WHEN #DIFF-MIN <= 45 AND FS-FLIGHT-STATUS = 'SC'
      UPDATE FLIGHT-SCHEDULE
        FS-FLIGHT-STATUS := 'BD'
    WHEN NONE
      /* no change
  END-DECIDE
END-FIND

WRITE 'FLIGHT STATUS UPDATE COMPLETE AT' #NOW-TIME
END