* ============================================================
* PROGRAM : ADADIRECT
* PURPOSE : Demonstrate ADABAS direct access with L1/L3 calls
* ============================================================
DEFINE DATA LOCAL
1 #ISN           (I4)
1 #RC            (I2)
1 #SUBRC         (I2)
1 #ISN-BUFFER    (A20)
1 BK VIEW OF BOOKING
END-DEFINE

* L1: Read a specific ISN directly
#ISN := 100
FIND BOOKING WITH ISN = #ISN
  DISPLAY 'PNR:' BK-PNR-LOCATOR 'PAX:' BK-PASSENGER-ID
END-FIND

* L3: Read logical by descriptor
FIND NUMBER BOOKING WITH BK-BOOKING-STATUS = 'HK'
  WRITE 'CONFIRMED BOOKINGS:' *NUMBER
END-FIND

* Histogram of booking channels
FIND BOOKING WITH BK-CHANNEL = 'WEB'
  WRITE 'WEB BOOKINGS FOUND'
END-FIND

* Adabas direct call example (L3 open)
CALL 'ADABAS' 'L3' 'BK' 0 0 #ISN-BUFFER #RC #SUBRC
IF #RC <> 0
  WRITE 'ADABAS L3 CALL FAILED RC:' #RC
END-IF
END