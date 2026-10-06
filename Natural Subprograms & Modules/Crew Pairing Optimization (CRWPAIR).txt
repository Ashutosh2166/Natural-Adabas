* ============================================================
* PROGRAM : CRWPAIR
* PURPOSE : Generate legal crew pairings for schedule period
* ============================================================
DEFINE DATA LOCAL
1 FS VIEW OF FLIGHT-SCHEDULE
1 #PAIRING-NO       (A6)
1 #LEGS-IN-PAIR    (I2)
1 #TOTAL-BLOCK     (P5,2)
1 #PAIRS-GEN       (P6)
1 #PAIR (1:4)
  2 #PR-FLIGHT-KEY  (A20)
1 #I                (I2)
1 #VALID            (L)
END-DEFINE

WRITE '=== CREW PAIRING GENERATOR ==='

* Generate 2-leg and 3-leg pairings
FIND FLIGHT-SCHEDULE WITH FS-FLIGHT-STATUS = 'SC'
  IF FS-CREW-ASSIGNED-FLAG = 'N'
    RESET #PAIRING-NO #LEGS-IN-PAIR #TOTAL-BLOCK
    MOVE FS-FLIGHT-KEY TO #PR-FLIGHT-KEY(1)
    MOVE 1 TO #LEGS-IN-PAIR

    * Look for return or onward leg
    FIND FLIGHT-SCHEDULE WITH FS-ORIGIN-AIRPORT = FS-DEST-AIRPORT
                       AND FS-FLIGHT-KEY <> FS-FLIGHT-KEY
      IF FS-SCHEDULED-DEP-TIME > FS-SCHEDULED-ARR-TIME
        MOVE FS-FLIGHT-KEY TO #PR-FLIGHT-KEY(2)
        MOVE 2 TO #LEGS-IN-PAIR

        * Attempt third leg
        FIND FLIGHT-SCHEDULE WITH FS-ORIGIN-AIRPORT = FS-DEST-AIRPORT
          IF FS-SCHEDULED-DEP-TIME >
             #PR-FLIGHT-KEY(2)
            MOVE FS-FLIGHT-KEY TO #PR-FLIGHT-KEY(3)
            MOVE 3 TO #LEGS-IN-PAIR
          END-IF
        END-FIND

        * Validate legality (duty time, rest, etc)
        CALLNAT 'CRWLEGAL' #PAIR(*) #LEGS-IN-PAIR #VALID
        IF #VALID = TRUE
          ADD 1 TO #PAIRS-GEN
          ADD 1 TO #PAIRING-NO
          WRITE 'PAIRING' #PAIRING-NO ':'
                #PR-FLIGHT-KEY(1) #PR-FLIGHT-KEY(2)
                #PR-FLIGHT-KEY(3)
        END-IF
      END-IF
    END-FIND
  END-IF
END-FIND

WRITE 'TOTAL PAIRINGS GENERATED:' #PAIRS-GEN
END