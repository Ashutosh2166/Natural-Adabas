* ============================================================
* PROGRAM : MNTLG
* PURPOSE : Record defects and maintenance actions
* ============================================================
DEFINE DATA LOCAL
1 #AC-REG         (A12)
1 #DEFECT-ID      (A10)
1 #DEFECT-DESC    (A80)
1 #ATA-CHAPTER    (A6)
1 #SEVERITY       (A2)  /* AOG/CAT-A/B/C/D
1 #MEL-REF        (A12)
1 #ACTION-TAKEN   (A80)
1 #STATUS         (A2)  /* OP=Open, IP=InProgress, CL=Closed
1 #CHOICE         (A1)
1 #LOOP           (L)
END-DEFINE

REPEAT WHILE #LOOP = FALSE
  INPUT 'MENU (R=Report,C=Close,V=View,X=Exit):' #CHOICE

  DECIDE ON FIRST VALUE OF #CHOICE
    VALUE 'R' OR 'r'
      INPUT 'AIRCRAFT:' #AC-REG
            'ATA CHAPTER:' #ATA-CHAPTER
            'SEVERITY (AOG/A/B/C/D):' #SEVERITY
            'DEFECT DESC:' #DEFECT-DESC
      MOVE 'OP' TO #STATUS
      CALLNAT 'MNTLOGCR' #AC-REG #ATA-CHAPTER #SEVERITY
        #DEFECT-DESC #STATUS #DEFECT-ID
      WRITE 'DEFECT LOGGED:' #DEFECT-ID

      * Auto-ground for AOG
      IF #SEVERITY = 'AOG'
        WRITE '*** AIRCRAFT GROUNDED ***'
        CALLNAT 'ACGROUND' #AC-REG
      END-IF

    VALUE 'C' OR 'c'
      INPUT 'DEFECT ID:' #DEFECT-ID
              'ACTION TAKEN:' #ACTION-TAKEN
      CALLNAT 'MNTLOGCL' #DEFECT-ID #ACTION-TAKEN
      WRITE 'DEFECT CLOSED'

    VALUE 'V' OR 'v'
      INPUT 'AIRCRAFT:' #AC-REG
      CALLNAT 'MNTLOGVW' #AC-REG

    VALUE 'X' OR 'x'
      MOVE TRUE TO #LOOP
  END-DECIDE
END-REPEAT
END