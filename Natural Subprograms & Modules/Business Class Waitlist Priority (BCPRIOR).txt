* ============================================================
* PROGRAM : BCPRIOR
* PURPOSE : Rank waitlist passengers by priority score
* ============================================================
DEFINE DATA LOCAL
1 BK VIEW OF BOOKING
1 PA VIEW OF PASSENGER
1 #FLIGHT-KEY       (A20)
1 #PRIORITY-SCORE   (P6)
1 #RANK             (P4)
1 #TEMP-PNR        (A8)
1 #TEMP-SCORE      (P6)
1 #WL (1:50)
  2 #WL-PNR         (A8)
  2 #WL-SCORE       (P6)
  2 #WL-TIER        (A2)
  2 #WL-FARE        (P9,2)
1 #I                (I2)
1 #J                (I2)
1 #COUNT            (I2)
END-DEFINE

INPUT 'FLIGHT KEY:' #FLIGHT-KEY

MOVE 0 TO #COUNT

* Score all waitlisted passengers
FIND BOOKING WITH BK-SEG-FLIGHT-KEY(1) = #FLIGHT-KEY
                AND BK-BOOKING-STATUS = 'HL'
  GET PASSENGER BK-PASSENGER-ID
  RESET #PRIORITY-SCORE

  * Tier points
  DECIDE ON FIRST VALUE OF PA-LOYALTY-TIER
    VALUE 'DI' ADD 1000 TO #PRIORITY-SCORE
    VALUE 'PL' ADD 700  TO #PRIORITY-SCORE
    VALUE 'GL' ADD 400  TO #PRIORITY-SCORE
    VALUE 'SV' ADD 200  TO #PRIORITY-SCORE
    VALUE 'BL' ADD 50   TO #PRIORITY-SCORE
  END-DECIDE

  * Fare value points
  ADD (BK-TOTAL-AMOUNT / 10) TO #PRIORITY-SCORE

  * Corporate account bonus
  IF BK-CORP-ACCOUNT <> ' '
    ADD 150 TO #PRIORITY-SCORE
  END-IF

  * Booking time (earlier = higher)
  ADD 100 TO #PRIORITY-SCORE

  ADD 1 TO #COUNT
  MOVE BK-PNR-LOCATOR TO #WL-PNR(#COUNT)
  MOVE #PRIORITY-SCORE TO #WL-SCORE(#COUNT)
  MOVE PA-LOYALTY-TIER TO #WL-TIER(#COUNT)
  MOVE BK-TOTAL-AMOUNT TO #WL-FARE(#COUNT)
END-FIND

* Sort descending by score (bubble sort for simplicity)
FOR #I = 1 TO #COUNT - 1
  FOR #J = 1 TO #COUNT - #I
    IF #WL-SCORE(#J) < #WL-SCORE(#J + 1)
      MOVE #WL-PNR(#J)   TO #TEMP-PNR
      MOVE #WL-SCORE(#J) TO #TEMP-SCORE
      MOVE #WL-PNR(#J + 1)   TO #WL-PNR(#J)
      MOVE #WL-SCORE(#J + 1) TO #WL-SCORE(#J)
      MOVE #TEMP-PNR   TO #WL-PNR(#J + 1)
      MOVE #TEMP-SCORE TO #WL-SCORE(#J + 1)
    END-IF
  END-FOR
END-FOR

* Display ranked waitlist
WRITE '=== PRIORITY WAITLIST ==='
FOR #I = 1 TO #COUNT
  WRITE #I #WL-PNR(#I) #WL-TIER(#I)
        #WL-SCORE(#I) #WL-FARE(#I)
END-FOR
END