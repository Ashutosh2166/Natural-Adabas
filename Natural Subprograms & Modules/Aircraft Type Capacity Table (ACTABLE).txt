* ============================================================
* PROGRAM : ACTABLE
* PURPOSE : Display aircraft type specifications
* ============================================================
DEFINE DATA LOCAL
1 #AC-TYPES (1:10)
  2 #ACT-CODE       (A6)
  2 #ACT-NAME       (A30)
  2 #ACT-FIRST      (P3)
  2 #ACT-BUSINESS   (P3)
  2 #ACT-ECON       (P3)
  2 #ACT-CARGO-KG   (P7)
  2 #ACT-RANGE-KM   (P6)
1 #I                (I2)
END-DEFINE

* Populate reference data
MOVE 'A320'  TO #ACT-CODE(1)   MOVE 'Airbus A320-200'      TO #ACT-NAME(1)
MOVE 0  TO #ACT-FIRST(1)       MOVE 12 TO #ACT-BUSINESS(1)
MOVE 150 TO #ACT-ECON(1)       MOVE 20000 TO #ACT-CARGO-KG(1)
MOVE 6100 TO #ACT-RANGE-KM(1)

MOVE 'B738'  TO #ACT-CODE(2)   MOVE 'Boeing 737-800'      TO #ACT-NAME(2)
MOVE 0  TO #ACT-FIRST(2)       MOVE 16 TO #ACT-BUSINESS(2)
MOVE 144 TO #ACT-ECON(2)       MOVE 22000 TO #ACT-CARGO-KG(2)
MOVE 5400 TO #ACT-RANGE-KM(2)

MOVE 'B77W'  TO #ACT-CODE(3)   MOVE 'Boeing 777-300ER'    TO #ACT-NAME(3)
MOVE 8  TO #ACT-FIRST(3)       MOVE 42 TO #ACT-BUSINESS(3)
MOVE 304 TO #ACT-ECON(3)       MOVE 120000 TO #ACT-CARGO-KG(3)
MOVE 13650 TO #ACT-RANGE-KM(3)

MOVE 'A388'  TO #ACT-CODE(4)   MOVE 'Airbus A380-800'     TO #ACT-NAME(4)
MOVE 14 TO #ACT-FIRST(4)       MOVE 76 TO #ACT-BUSINESS(4)
MOVE 399 TO #ACT-ECON(4)       MOVE 150000 TO #ACT-CARGO-KG(4)
MOVE 15200 TO #ACT-RANGE-KM(4)

MOVE 'B789'  TO #ACT-CODE(5)   MOVE 'Boeing 787-9'        TO #ACT-NAME(5)
MOVE 0  TO #ACT-FIRST(5)       MOVE 48 TO #ACT-BUSINESS(5)
MOVE 240 TO #ACT-ECON(5)       MOVE 80000 TO #ACT-CARGO-KG(5)
MOVE 14140 TO #ACT-RANGE-KM(5)

WRITE 'CODE   NAME                  F  J   Y    CARGO(kg)  RANGE(km)'
WRITE '------------------------------------------------------------'
FOR #I = 1 TO 5
  WRITE #ACT-CODE(#I) #ACT-NAME(#I) #ACT-FIRST(#I)
        #ACT-BUSINESS(#I) #ACT-ECON(#I)
        #ACT-CARGO-KG(#I) #ACT-RANGE-KM(#I)
END-FOR
END