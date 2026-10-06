* ============================================================
* SUBPROGRAM: OVRBKCLC
* PURPOSE   : Compute optimal overbooking level
* ALGORITHM : Historical no-show rate + dynamic adjustment
* ============================================================
DEFINE DATA
PARAMETER
1 P-FLIGHT-KEY      (A20)
1 P-OVERBOOK-LEVEL  (P4)
1 P-STATUS          (I2)
LOCAL
1 FS VIEW OF FLIGHT-SCHEDULE
1 #BASE-NOSHOW     (P5,2)
1 #SEASON-FACTOR   (P3,2)
1 #DAY-FACTOR      (P3,2)
1 #DOW             (A2)
1 #MONTH           (A2)
1 #CAPACITY        (P4)
1 #RECOMMENDED     (P4)
END-DEFINE

FIND FLIGHT-SCHEDULE WITH FS-FLIGHT-KEY = P-FLIGHT-KEY
  MOVE FS-TOTAL-SEATS TO #CAPACITY
END-FIND

* Historical base no-show rate (would query stats DB)
CALLNAT 'NOSTATS' P-FLIGHT-KEY #BASE-NOSHOW

* Adjust by season
MOVE SUBSTRING(*DATX, 6, 2) TO #MONTH
IF #MONTH = '06' OR = '07' OR = '08' OR = '12'
  MOVE 1.20 TO #SEASON-FACTOR
ELSE IF #MONTH = '03' OR = '04' OR = '09' OR = '10'
  MOVE 0.90 TO #SEASON-FACTOR
ELSE
  MOVE 1.00 TO #SEASON-FACTOR
END-IF

* Adjust by day of week (Mon/Fri heavy, Sat light)
CALLNAT 'DAYSNAME' *DATX #DOW
DECIDE ON FIRST VALUE OF #DOW
  VALUE 'MO' OR 'FR'
    MOVE 1.15 TO #DAY-FACTOR
  VALUE 'SA'
    MOVE 0.80 TO #DAY-FACTOR
  VALUE 'SU'
    MOVE 0.90 TO #DAY-FACTOR
  NONE
    MOVE 1.00 TO #DAY-FACTOR
END-DECIDE

COMPUTE #RECOMMENDED = #CAPACITY * #BASE-NOSHOW / 100
                          * #SEASON-FACTOR * #DAY-FACTOR

P-OVERBOOK-LEVEL := #RECOMMENDED
MOVE 0 TO P-STATUS
END