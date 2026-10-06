* ============================================================
* PROGRAM : NDCADPT
* PURPOSE : Adapter to IATA NDC / One Order API
*           Demonstrates modernization patterns
* ============================================================
DEFINE DATA LOCAL
1 #XML-REQ         (A2000)
1 #XML-RESP        (A4000)
1 #PNR             (A8)
1 #OFFER-ID        (A36)
1 #TOTAL-PRICE     (P12,2)
1 #CURRENCY        (A3)
1 #STATUS          (I2)
1 #CHOICE          (A1)
END-DEFINE

INPUT 'NDC OPERATION (A=AirShopping, O=OrderCreate, R=OrderRetrieve):' #CHOICE

DECIDE ON FIRST VALUE OF #CHOICE
  VALUE 'A' OR 'a'
    * AirShopping - search for offers
    CALLNAT 'NDC-REQ' 'AirShopping' #XML-REQ
    CALLNAT 'HTTP-POST' 'https://ndc.airline.com/airshopping'
      #XML-REQ #XML-RESP #STATUS
    IF #STATUS = 200
      CALLNAT 'NDC-PARSE' #XML-RESP #OFFER-ID #TOTAL-PRICE #CURRENCY
      WRITE 'OFFER:' #OFFER-ID 'PRICE:' #TOTAL-PRICE #CURRENCY
    END-IF

  VALUE 'O' OR 'o'
    INPUT 'OFFER ID:' #OFFER-ID
            'PNR:' #PNR
    CALLNAT 'NDC-BUILD-ORDER' #OFFER-ID #PNR #XML-REQ
    CALLNAT 'HTTP-POST' 'https://ndc.airline.com/ordercreate'
      #XML-REQ #XML-RESP #STATUS
    WRITE 'ORDER CREATION STATUS:' #STATUS

  VALUE 'R' OR 'r'
    INPUT 'PNR:' #PNR
    CALLNAT 'HTTP-GET' 'https://ndc.airline.com/order/'
      #PNR #XML-RESP #STATUS
    WRITE 'RETRIEVED ORDER FOR' #PNR
END-DECIDE
END