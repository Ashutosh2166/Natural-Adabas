* ============================================================
* PROGRAM : WL-PROC
* PURPOSE : Process waitlist when seats become available
* BATCH   : Run every 15 minutes
* ============================================================
DEFINE DATA LOCAL
1 BK VIEW OF BOOKING
1 FS VIEW OF FLIGHT-SCHEDULE
1 #FLIGHT-KEY       (A20)
1 #SEATS-AVAIL      (P4)
1 #PROMOTED         (P5)
1 #WL-COUNT         (P5)
1 #PROCESSED        (L)
END-DEFINE

* Read all flights departing in next 24 hours
FIND FLIGHT-SCHEDULE WITH FS-FLIGHT-STATUS = 'SC'
  #FLIGHT-KEY := FS-FLIGHT-KEY
  #SEATS-AVAIL := FS-SEATS-AVAILABLE

  IF #SEATS-AVAIL > 0
    RESET #PROMOTED #PROCESSED
    REPEAT
      RESET #PROCESSED
      * Find oldest waitlist booking
      FIND BOOKING WITH BK-SEG-FLIGHT-KEY(1) = #FLIGHT-KEY
                    AND BK-BOOKING-STATUS = 'HL'
                    SORTED BY BK-BOOKING-DATE
        IF #SEATS-AVAIL > 0
          UPDATE BOOKING
            BK-BOOKING-STATUS := 'HK'
          ADD 1 TO #PROMOTED
          SUBTRACT 1 FROM #SEATS-AVAIL
          MOVE TRUE TO #PROCESSED
          CALLNAT 'NOTIFYPAX' BK-PNR-LOCATOR 'WL-CONFIRMED'
          ESCAPE TOP
        END-IF
      END-FIND
      * Also promote from 'UC' (unable to confirm) status
      IF #SEATS-AVAIL > 0
        FIND BOOKING WITH BK-SEG-FLIGHT-KEY(1) = #FLIGHT-KEY
                      AND BK-BOOKING-STATUS = 'UC'
                      SORTED BY BK-BOOKING-DATE
          UPDATE BOOKING
            BK-BOOKING-STATUS := 'HK'
          ADD 1 TO #PROMOTED
          SUBTRACT 1 FROM #SEATS-AVAIL
          MOVE TRUE TO #PROCESSED
        END-FIND
      END-IF
    UNTIL #PROCESSED = FALSE
    IF #PROMOTED > 0
      WRITE 'FLIGHT' #FLIGHT-KEY 'PROMOTED' #PROMOTED 'PASSENGERS'
      UPDATE FLIGHT-SCHEDULE
        FS-SEATS-AVAILABLE := #SEATS-AVAIL
        FS-SEATS-SOLD := FS-TOTAL-SEATS - #SEATS-AVAIL
    END-IF
  END-IF
END-FIND
END