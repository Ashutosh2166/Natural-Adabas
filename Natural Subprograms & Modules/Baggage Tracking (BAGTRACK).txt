* ============================================================
* PROGRAM : BAGTRACK
* PURPOSE : Track checked baggage through sorting system
* ============================================================
DEFINE DATA LOCAL
1 #BAG-TAG         (A10)
1 #PNR             (A8)
1 #ORIGIN          (A3)
1 #DEST            (A3)
1 #WEIGHT-KG       (P5,2)
1 #STATUS          (A2)  /* CK=Checked, LD=Loaded, ON=Onboard,
                         /* AR=Arrived, DL=Delayed, LS=Lost
1 #SCAN-LOC        (A3)
1 #SCAN-TIME       (A5)
1 #LOOP-FLAG       (L)
1 #CHOICE          (A1)
1 BK VIEW OF BOOKING
END-DEFINE

REPEAT WHILE #LOOP-FLAG = FALSE
  INPUT 'BAG MENU (C=Check,L=Load,T=Track,X=Exit):' #CHOICE

  DECIDE ON FIRST VALUE OF #CHOICE
    VALUE 'C' OR 'c'
      INPUT 'PNR:' #PNR
             'BAG TAG:' #BAG-TAG
             'WEIGHT KG:' #WEIGHT-KG
      FIND BOOKING WITH BK-PNR-LOCATOR = #PNR
        #ORIGIN := SUBSTRING(BK-SEG-FLIGHT-KEY(1), 4, 3)
        #DEST   := SUBSTRING(BK-SEG-FLIGHT-KEY(1), 7, 3)
      END-FIND
      MOVE 'CK' TO #STATUS
      CALLNAT 'BAGSAVE' #BAG-TAG #PNR #ORIGIN #DEST
        #WEIGHT-KG #STATUS
      WRITE 'BAG CHECKED:' #BAG-TAG

    VALUE 'L' OR 'l'
      INPUT 'BAG TAG:' #BAG-TAG
              'FLIGHT:' #SCAN-LOC
      MOVE 'LD' TO #STATUS
      MOVE *TIMX TO #SCAN-TIME
      CALLNAT 'BAGUPDT' #BAG-TAG #STATUS #SCAN-LOC #SCAN-TIME
      WRITE 'BAG LOADED'

    VALUE 'T' OR 't'
      INPUT 'BAG TAG:' #BAG-TAG
      CALLNAT 'BAGFIND' #BAG-TAG #PNR #STATUS #SCAN-LOC
      DISPLAY 'TAG:' #BAG-TAG
              'PNR:' #PNR
              'STATUS:' #STATUS
              'LOCATION:' #SCAN-LOC

    VALUE 'X' OR 'x'
      MOVE TRUE TO #LOOP-FLAG

    NONE
      WRITE 'INVALID CHOICE'
  END-DECIDE
END-REPEAT
END