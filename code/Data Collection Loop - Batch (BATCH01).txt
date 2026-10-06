* ============================================================
* PROGRAM : BATCH01
* PURPOSE : Nightly batch - comprehensive data maintenance
* SCHEDULE: Daily 02:00 local
* ============================================================
DEFINE DATA LOCAL
1 #JOB-STEP      (A30)
1 #START-TS      (A26)
1 #END-TS        (A26)
1 #REC-COUNT     (P8)
1 #ERR-COUNT     (P8)
END-DEFINE

MOVE *TIMX TO #START-TS
WRITE '=== AROS NIGHTLY BATCH STARTED ==='

* Step 1: Process no-shows
MOVE 'PROCESS NO-SHOWS' TO #JOB-STEP
FETCH 'NOSHOW'

* Step 2: Release expired waitlists
MOVE 'PROCESS WAITLIST' TO #JOB-STEP
FETCH 'WL-PROC'

* Step 3: Update flight statuses
MOVE 'UPDATE FLIGHT STATUS' TO #JOB-STEP
FETCH 'FLTUPD'

* Step 4: Accrue loyalty for completed flights
MOVE 'ACCRUE LOYALTY' TO #JOB-STEP
FETCH 'LOYACCR'

* Step 5: Refresh revenue statistics
MOVE 'REFRESH STATS' TO #JOB-STEP
FETCH 'REVSTAT'

* Step 6: Purge expired PNRs (>13 months old)
MOVE 'PURGE EXPIRED PNR' TO #JOB-STEP
FETCH 'PNRPURGE'

* Step 7: Generate daily reports
MOVE 'GEN REPORTS' TO #JOB-STEP
FETCH 'REVRPT01'

MOVE *TIMX TO #END-TS
WRITE '=== BATCH COMPLETED ==='
WRITE 'START:' #START-TS 'END:' #END-TS
END