* ============================================================
* PROGRAM : NOSHOW
* PURPOSE : Batch - mark no-shows and release inventory
* ============================================================
DEFINE DATA LOCAL
1 BK VIEW OF BOOKING
1 FS VIEW OF FLIGHT-SCHEDULE
1 #DEPAIR          (A3)
1 #PROCESSED       (P6)
1 #RELEASED        (P6)
END-DEFINE

* Process bookings where flight departed > 30 min ago
FIND BOOKING WITH BK-BOOKING-STATUS = 'HK'
  IF BK-SEG-FLIGHT-KEY(1) <> ' '
    FIND FLIGHT-SCHEDULE WITH FS-FLIGHT-KEY = BK-SEG-FLIGHT-KEY(1)
      IF FS-FLIGHT-STATUS = 'DP'
        UPDATE BOOKING
          BK-BOOKING-STATUS := 'NO'
        ADD 1 TO #PROCESSED
        * Release seat
        COMPUTE FS-SEATS-AVAILABLE = FS-SEATS-AVAILABLE + 1
        COMPUTE FS-SEATS-SOLD = FS-SEATS-SOLD - 1
        UPDATE FLIGHT-SCHEDULE
        ADD 1 TO #RELEASED
      END-IF
    END-FIND
  END-IF
END-FIND

WRITE 'NO-SHOW BATCH COMPLETE'
      'BOOKINGS PROCESSED:' #PROCESSED
      'SEATS RELEASED:'     #RELEASED
END