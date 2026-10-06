* ============================================================
* SUBPROGRAM: REVYIELD
* PURPOSE   : Calculate flight yield and load factor
* ============================================================
DEFINE DATA
PARAMETER
1 P-FLIGHT-KEY      (A20)
1 P-LOAD-FACTOR     (P5,2)
1 P-YIELD-RPK       (P9,4)
1 P-RASM            (P9,4)
1 P-STATUS          (I2)
LOCAL
1 FS VIEW OF FLIGHT-SCHEDULE
1 BK VIEW OF BOOKING
1 #REVENUE          (P13,2)
1 #PAX-COUNT        (P5)
1 #RPK              (P12)   /* Revenue Passenger Kilometers
1 #ASK              (P12)   /* Available Seat Kilometers
1 #SEG-REVENUE      (P11,2)
END-DEFINE

RESET #REVENUE #PAX-COUNT #RPK #ASK P-STATUS

FIND FLIGHT-SCHEDULE WITH FS-FLIGHT-KEY = P-FLIGHT-KEY
  COMPUTE #ASK = FS-TOTAL-SEATS * FS-DISTANCE-KM
END-FIND

* Scan all confirmed bookings on this flight
FIND BOOKING WITH BK-SEG-FLIGHT-KEY(1) = P-FLIGHT-KEY
                AND BK-BOOKING-STATUS = 'HK' OR 'TK'
  ADD 1 TO #PAX-COUNT
  ADD BK-TOTAL-AMOUNT TO #REVENUE
END-FIND

COMPUTE #RPK = #PAX-COUNT * FS-DISTANCE-KM

IF #ASK > 0
  COMPUTE P-LOAD-FACTOR = #PAX-COUNT / FS-TOTAL-SEATS * 100
  COMPUTE P-YIELD-RPK   = #REVENUE / #RPK
END-IF

IF #REVENUE > 0
  COMPUTE P-RASM = #REVENUE / #ASK
END-IF

MOVE 0 TO P-STATUS
END