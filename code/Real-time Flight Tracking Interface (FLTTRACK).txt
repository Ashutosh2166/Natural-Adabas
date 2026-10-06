* ============================================================
* PROGRAM : FLTTRACK
* PURPOSE : Consume real-time flight position from ADS-B feed
* ============================================================
DEFINE DATA LOCAL
1 #FLIGHT-KEY      (A20)
1 #LATITUDE        (P9,6)
1 #LONGITUDE       (P9,6)
1 #ALTITUDE-FT     (P7)
1 #GROUND-SPEED    (P5)
1 #HEADING         (P3)
1 #ETA             (A5)
1 #STATUS          (I2)
1 #POLL-SECONDS    (I2) INIT <30>
END-DEFINE

INPUT 'FLIGHT KEY:' #FLIGHT-KEY

REPEAT
  CALLNAT 'ADSB-FETCH' #FLIGHT-KEY #LATITUDE #LONGITUDE
    #ALTITUDE-FT #GROUND-SPEED #HEADING #ETA #STATUS

  IF #STATUS = 0
    DISPLAY 'LAT:' #LATITUDE 'LON:' #LONGITUDE
            'ALT(ft):' #ALTITUDE-FT
            'SPD(kts):' #GROUND-SPEED
            'HDG:' #HEADING 'ETA:' #ETA
    CALLNAT 'FLTPOSUPD' #FLIGHT-KEY #LATITUDE #LONGITUDE
      #ALTITUDE-FT #ETA
  ELSE
    WRITE 'TRACK LOST FOR' #FLIGHT-KEY
    ESCAPE ROUTINE
  END-IF

  CALLNAT 'SLEEP' (#POLL-SECONDS * 1000)
END-REPEAT
END