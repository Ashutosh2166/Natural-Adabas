* ============================================================
* SUBPROGRAM: GDSADPT
* PURPOSE   : Transform between AROS and GDS (Amadeus) format
* ============================================================
DEFINE DATA
PARAMETER
1 P-DIRECTION       (A1)  /* I=Inbound, O=Outbound
1 P-DATA-IN         (A256)
1 P-DATA-OUT        (A256)
1 P-STATUS          (I2)
LOCAL
1 #PNR              (A8)
1 #PAX-NAME         (A40)
1 #SEG-COUNT        (I2)
1 #SEG-FLIGHT       (A20)
1 #SEG-CLASS        (A2)
1 #FARE             (P9,2)
1 #I                (I2)
END-DEFINE

RESET P-STATUS
MOVE P-DATA-IN TO P-DATA-OUT

DECIDE FOR FIRST CONDITION
  WHEN P-DIRECTION = 'I'
    * Parse Amadeus-format inbound message
    CALLNAT 'GDS-PARSE' P-DATA-IN #PNR #PAX-NAME
      #SEG-COUNT #SEG-FLIGHT(*) #SEG-CLASS(*) #FARE
    IF #PNR = ' '
      MOVE 30 TO P-STATUS
    ELSE
      MOVE 0 TO P-STATUS
    END-IF

  WHEN P-DIRECTION = 'O'
    * Build Amadeus-format outbound message
    CALLNAT 'GDS-BUILD' #PNR #PAX-NAME #SEG-COUNT
      #SEG-FLIGHT(*) #SEG-CLASS(*) #FARE P-DATA-OUT
    MOVE 0 TO P-STATUS

  WHEN NONE
    MOVE 31 TO P-STATUS
END-DECIDE
END