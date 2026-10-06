* ============================================================
* SUBPROGRAM: AUDITLOG
* PURPOSE   : Centralized audit logging
* ============================================================
DEFINE DATA
PARAMETER
1 P-FILE-CODE       (A2)
1 P-ACTION          (A12)
1 P-KEY-VALUE       (A30)
LOCAL
1 #TERMINAL-ID      (A8)
1 #USER-ID          (A8)
1 #PROGRAM          (A8)
1 #TIMESTAMP        (A26)
1 #LOG-RECORD       (A132)
END-DEFINE

MOVE *INIT-USER    TO #USER-ID
MOVE *INIT-ID      TO #TERMINAL-ID
MOVE *PROGRAM      TO #PROGRAM
MOVE *TIMX         TO #TIMESTAMP

COMPRESS #TIMESTAMP '|' #USER-ID '|' #TERMINAL-ID '|'
         #PROGRAM  '|' P-FILE-CODE '|' P-ACTION '|'
         P-KEY-VALUE INTO #LOG-RECORD

* Write to SMF / log file
DEFINE WORK FILE 1 '/arOS/logs/audit.log' TYPE 'UNFORMATTED'
WRITE WORK FILE 1 #LOG-RECORD
CLOSE WORK FILE 1
END