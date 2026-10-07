* ============================================================
* PROGRAM : ACROTATE
* PURPOSE : Assign aircraft to flight legs (tail assignment)
* ============================================================
DEFINE DATA LOCAL
1 FS VIEW OF FLIGHT-SCHEDULE
1 #AC-REG          (A12)
1 #AC-TYPE         (A6)
1 #AC-BASE         (A3)
1 #MIN-TURN-MIN    (P4)
1 #LEG-INDEX       (I4)
1 #CANDIDATE-CNT   (P4)
1 #ASSIGNED-CNT    (P4)
1 #CONFLICT-MSG    (A79)
1 #LEGS (1:200)
  2 #LG-KEY        (A20)
  2 #LG-ORIG       (A3)
  2 #LG-DEST       (A3)
  2 #LG-DEP-TIME   (A5)
  2 #LG-ARR-TIME   (A5)
  2 #LG-AC-TYPE    (A6)
  2 #LG-ASSIGNED   (L)
END-DEFINE

* Load unassigned flights for next 7 days
MOVE 0 TO #LEG-INDEX
FIND FLIGHT-SCHEDULE WITH FS-FLIGHT-STATUS = 'SC'
                    AND FS-AIRCRAFT-REG = ' '
  ADD 1 TO #LEG-INDEX
  #LG-KEY(#LEG-INDEX)      := FS-FLIGHT-KEY
  #LG-ORIG(#LEG-INDEX)     := FS-ORIGIN-AIRPORT
  #LG-DEST(#LEG-INDEX)     := FS-DEST-AIRPORT
  #LG-DEP-TIME(#LEG-INDEX) := FS-SCHEDULED-DEP-TIME
  #LG-ARR-TIME(#LEG-INDEX) := FS-SCHEDULED-ARR-TIME
  #LG-AC-TYPE(#LEG-INDEX)  := FS-AIRCRAFT-TYPE
  RESET #LG-ASSIGNED(#LEG-INDEX)
END-FIND

* Greedy assignment: match legs to tails with correct base & type
FOR #I = 1 TO #LEG-INDEX
  IF #LG-ASSIGNED(#I) = FALSE
    CALLNAT 'TAILFIND' #LG-AC-TYPE(#I) #LG-ORIG(#I)
      #LG-DEP-TIME(#I) #AC-REG #AC-BASE
    IF #AC-REG <> ' '
      UPDATE FLIGHT-SCHEDULE
        FS-AIRCRAFT-REG := #AC-REG
      ADD 1 TO #ASSIGNED-CNT
      MOVE TRUE TO #LG-ASSIGNED(#I)
    END-IF
  END-IF
END-FOR

WRITE 'TAIL ASSIGNMENT COMPLETE'
      'LEGS ASSIGNED:' #ASSIGNED-CNT '/' #LEG-INDEX
END