* ============================================================
* SUBPROGRAM: PAYPROC
* PURPOSE   : Process payment with retry logic
* ============================================================
DEFINE DATA
PARAMETER
1 P-PNR             (A8)
1 P-AMOUNT          (P12,2)
1 P-CURRENCY        (A3)
1 P-METHOD          (A4)
1 P-AUTH-CODE       (A15)
1 P-STATUS          (I2)
LOCAL
1 #RETRY-COUNT      (I1)
1 #MAX-RETRY        (I1) INIT <3>
1 #RESPONSE         (A20)
1 #TXN-ID           (A20)
END-DEFINE

RESET P-STATUS P-AUTH-CODE
MOVE 0 TO #RETRY-COUNT

REPEAT
  ADD 1 TO #RETRY-COUNT
  CALLNAT 'GW-CALL' P-METHOD P-AMOUNT P-CURRENCY
    #RESPONSE #AUTH-CODE-TEMP #TXN-ID

  DECIDE ON FIRST VALUE OF #RESPONSE
    VALUE 'APPROVED'
      MOVE #AUTH-CODE-TEMP TO P-AUTH-CODE
      MOVE 0 TO P-STATUS
      ESCAPE BOTTOM
    VALUE 'DECLINED'
      MOVE 40 TO P-STATUS
      ESCAPE BOTTOM
    VALUE 'TIMEOUT' OR 'ERROR'
      IF #RETRY-COUNT >= #MAX-RETRY
        MOVE 41 TO P-STATUS
        ESCAPE BOTTOM
      END-IF
      * exponential backoff: 1s, 2s, 4s
      CALLNAT 'SLEEP' (#RETRY-COUNT * 1000)
    VALUE 'DUPLICATE'
      MOVE 42 TO P-STATUS
      ESCAPE BOTTOM
  END-DECIDE
END-REPEAT
END