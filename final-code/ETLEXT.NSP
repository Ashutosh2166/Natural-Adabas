* ============================================================
* PROGRAM : ETLEXT
* PURPOSE : Extract data to modern cloud platform (JSON)
*           Demonstrates legacy->strategic bridge
* ============================================================
DEFINE DATA LOCAL
1 BK VIEW OF BOOKING
1 PA VIEW OF PASSENGER
1 #JSON-BUF      (A255)
1 #JSON-LINE     (A255)
1 #EXTRACT-TYPE  (A10)
1 #REC-COUNT     (P8)
END-DEFINE

INPUT 'EXTRACT TYPE (BOOKING/PAX):' #EXTRACT-TYPE

DEFINE WORK FILE 10 '/aros/etl/export.json'

IF #EXTRACT-TYPE = 'BOOKING'
  MOVE '[' TO #JSON-BUF
  WRITE WORK FILE 10 #JSON-BUF

  RESET #REC-COUNT
  FIND BOOKING WITH BK-BOOKING-STATUS = 'HK'
    ADD 1 TO #REC-COUNT
    IF #REC-COUNT > 1
      MOVE ',' TO #JSON-BUF
      WRITE WORK FILE 10 #JSON-BUF
    END-IF
    COMPRESS '{'
      '"pnr":"'       BK-PNR-LOCATOR           '",'
      '"paxId":"'     BK-PASSENGER-ID          '",'
      '"status":"'    BK-BOOKING-STATUS        '",'
      '"channel":"'   BK-CHANNEL               '",'
      '"amount":'     BK-TOTAL-AMOUNT           ','
      '"currency":"'  BK-CURRENCY              '",'
      '"bookingDate":"' BK-BOOKING-DATE        '"'
      '}' INTO #JSON-BUF
    WRITE WORK FILE 10 #JSON-BUF
  END-FIND

  MOVE ']' TO #JSON-BUF
  WRITE WORK FILE 10 #JSON-BUF
END-IF

IF #EXTRACT-TYPE = 'PAX'
  MOVE '[' TO #JSON-BUF
  WRITE WORK FILE 10 #JSON-BUF
  RESET #REC-COUNT
  FIND PASSENGER
    ADD 1 TO #REC-COUNT
    IF #REC-COUNT > 1
      MOVE ',' TO #JSON-BUF
      WRITE WORK FILE 10 #JSON-BUF
    END-IF
    COMPRESS '{'
      '"id":"'        PA-PASSENGER-ID          '",'
      '"name":"'      PA-FIRST-NAME ' ' PA-LAST-NAME '",'
      '"email":"'     PA-EMAIL                 '",'
      '"tier":"'      PA-LOYALTY-TIER          '",'
      '"miles":'      PA-LOYALTY-MILES          ','
      '"ytdSpend":'   PA-YTD-SPEND
      '}' INTO #JSON-BUF
    WRITE WORK FILE 10 #JSON-BUF
  END-FIND
  MOVE ']' TO #JSON-BUF
  WRITE WORK FILE 10 #JSON-BUF
END-IF

CLOSE WORK FILE 10
WRITE 'ETL EXTRACT COMPLETE:' #REC-COUNT 'RECORDS'
END