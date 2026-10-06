* ============================================================
* PROGRAM : SLOTCOORD
* PURPOSE : Manage airport slot allocations (IATA compliant)
* ============================================================
DEFINE DATA LOCAL
1 #AIRPORT        (A3)
1 #SEASON         (A2)  /* S=Summer, W=Winter
1 #SLOT-REQ-ID    (A10)
1 #CARRIER        (A3)
1 #TIME-REQ       (A5)
1 #SLOT-STATUS    (A2)  /* AL=Allocated, RE=Requested, DF=Denied
1 #SEQ            (I2)
END-DEFINE

INPUT 'AIRPORT:' #AIRPORT
      'SEASON (S/W):' #SEASON
      'CARRIER:' #CARRIER
      'REQ TIME (HHMM):' #TIME-REQ

* Check slot availability
CALLNAT 'SLOTCHK' #AIRPORT #SEASON #CARRIER #TIME-REQ
  #SLOT-STATUS #SLOT-REQ-ID

DECIDE ON FIRST VALUE OF #SLOT-STATUS
  VALUE 'AL'
    WRITE 'SLOT ALLOCATED:' #SLOT-REQ-ID
    CALLNAT 'SLOTSAVE' #SLOT-REQ-ID #AIRPORT #SEASON
      #CARRIER #TIME-REQ 'AL'
  VALUE 'RE'
    WRITE 'SLOT ADDED TO WAITLIST'
    CALLNAT 'SLOTSAVE' #SLOT-REQ-ID #AIRPORT #SEASON
      #CARRIER #TIME-REQ 'RE'
  VALUE 'DF'
    WRITE 'SLOT DENIED - CAPACITY EXCEEDED'
  NONE
    WRITE 'UNKNOWN STATUS - CONTACT SLOT COORDINATOR'
END-DECIDE
END