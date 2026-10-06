* ============================================================
* PROGRAM : CSRSETTLE
* PURPOSE : Monthly codeshare revenue proration & settlement
* ============================================================
DEFINE DATA LOCAL
1 BK VIEW OF BOOKING
1 #PARTNER         (A3)
1 #PRORATION-PCT   (P5,2)
1 #PARTNER-SHARE   (P11,2)
1 #OWN-SHARE       (P11,2)
1 #TOTAL-POOL      (P13,2)
1 #TXN-COUNT       (P6)
1 #SETTLE-FILE     (A40)
1 #SETTLE-REC      (A132)
END-DEFINE

* Aggregate revenue by marketing carrier
FIND BOOKING WITH BK-BOOKING-STATUS = 'HK' OR 'TK'
  IF BK-SEG-FLIGHT-KEY(1) <> ' '
    MOVE SUBSTRING(BK-SEG-FLIGHT-KEY(1), 1, 3) TO #PARTNER
    * Proration based on mileage
    CALLNAT 'PRORATE' BK-SEG-FLIGHT-KEY(1) BK-TOTAL-AMOUNT
      #PRORATION-PCT
    COMPUTE #PARTNER-SHARE = BK-TOTAL-AMOUNT * #PRORATION-PCT / 100
    COMPUTE #OWN-SHARE = BK-TOTAL-AMOUNT - #PARTNER-SHARE
    ADD BK-TOTAL-AMOUNT TO #TOTAL-POOL
    ADD 1 TO #TXN-COUNT

    * Write settlement record
    COMPRESS BK-PNR-LOCATOR '|' #PARTNER '|'
             BK-TOTAL-AMOUNT '|' #PARTNER-SHARE '|'
             #OWN-SHARE INTO #SETTLE-REC
    DEFINE WORK FILE 2 '/aros/settlement/' #PARTNER '.dat'
    WRITE WORK FILE 2 #SETTLE-REC
  END-IF
END-FIND

WRITE 'CODESHARE SETTLEMENT COMPLETE'
      'TRANSACTIONS:' #TXN-COUNT
      'TOTAL POOL:' #TOTAL-POOL
END