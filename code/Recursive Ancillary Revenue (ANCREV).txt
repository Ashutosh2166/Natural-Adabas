* ============================================================
* PROGRAM : ANCREV
* PURPOSE : Calculate total ancillary revenue on a PNR
* ============================================================
DEFINE DATA LOCAL
1 BK VIEW OF BOOKING
1 #PNR          (A8)
1 #BASE-FARE    (P11,2)
1 #SEAT-FEE     (P9,2)
1 #BAG-FEE      (P9,2)
1 #MEAL-FEE     (P9,2)
1 #LOUNGE-FEE   (P9,2)
1 #PRIORITY-FEE (P9,2)
1 #TOTAL-ANC    (P11,2)
1 #GRAND-TOTAL  (P12,2)
1 #I            (I2)
END-DEFINE

INPUT 'PNR:' #PNR
GET BOOKING #PNR

MOVE BK-TOTAL-AMOUNT TO #BASE-FARE

* Seat selection fee
IF BK-SEG-SEAT-NUMBER(1) <> ' '
  MOVE 25 TO #SEAT-FEE
END-IF

* Baggage fees (assume $35 per extra bag beyond 1)
MOVE 35 TO #BAG-FEE

* Meal pre-order
FOR #I = 1 TO 8
  IF BK-SEG-MEAL-CODE(#I) <> ' '
    ADD 15 TO #MEAL-FEE
  END-IF
END-FOR

* Lounge access
IF BK-CORP-ACCOUNT <> ' '
  MOVE 45 TO #LOUNGE-FEE
END-IF

* Priority boarding
MOVE 20 TO #PRIORITY-FEE

COMPUTE #TOTAL-ANC = #SEAT-FEE + #BAG-FEE + #MEAL-FEE
                    + #LOUNGE-FEE + #PRIORITY-FEE
COMPUTE #GRAND-TOTAL = #BASE-FARE + #TOTAL-ANC

WRITE 'PNR:' #PNR
WRITE 'BASE FARE:' #BASE-FARE
WRITE 'SEAT FEE:' #SEAT-FEE
WRITE 'BAG FEE:' #BAG-FEE
WRITE 'MEAL FEE:' #MEAL-FEE
WRITE 'LOUNGE FEE:' #LOUNGE-FEE
WRITE 'PRIORITY BOARDING:' #PRIORITY-FEE
WRITE 'TOTAL ANCILLARY:' #TOTAL-ANC
WRITE 'GRAND TOTAL:' #GRAND-TOTAL
END