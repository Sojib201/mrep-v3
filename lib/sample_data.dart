import 'dart:convert';

dynamic body =
{
  "status": "Success",
  "area_list": [
    {
      "area_id": "A001",
      "area_name": "Central Zone",
      "clientList": [
        {
          "client_id": "C001",
          "client_name": "Client A",
          "category_name": "Retail",
          "orders": [
            {
              "order_serial": "ORD130",
              "delivery_date": "2024-09-28",
              "collection_date": "2024-09-30",
              "delivery_time": "Morning",
              "payment_mode": "CASH",
              "offer": "10% off",
              "note": "Urgent delivery",
              "latitude": "23.7805733",
              "longitude": "90.4003181",
              "location_detail": "123 Central Avenue",
              "item_list": [
                {
                  "quantity": 5,
                  "item_name": "Maxiron Capsule | 30's|Carbonyl Iron+Folic Acid+Vit.B Comp.+Vit.C+Zinc Sulfate",
                  "tp": 78.71,
                  "item_id": "13211",
                  "category_id": "PHARMA | UNIT | TK 92.41",
                  "vat": 13.7,
                  "manufacturer": "92.41"
                },
                {
                  "quantity": 2,
                  "item_name": "Meropex 1 g IV Injection | 1's|Meropenem Trihydrate",
                  "tp": 899.56,
                  "item_id": "15900",
                  "category_id": "PHARMA | UNIT | TK 1056.08",
                  "vat": 156.52,
                  "manufacturer": "1056.08"
                }
              ]
            },
            {
              "order_serial": "ORD133",
              "delivery_date": "2024-10-03",
              "collection_date": "2024-10-05",
              "delivery_time": "Evening",
              "payment_mode": "CREDIT",
              "offer": "5% discount",
              "note": "Deliver to office",
              "latitude": "23.7850000",
              "longitude": "90.4020000",
              "location_detail": "128 Central Avenue",
              "item_list": [
                {
                  "quantity": 3,
                  "item_name": "Montelon 5 Tablet | 30's|Montelukast Sodium",
                  "tp": 179.91,
                  "item_id": "13441",
                  "category_id": "PHARMA | UNIT | TK 211.21",
                  "vat": 31.3,
                  "manufacturer": "211.21"
                },
                {
                  "quantity": 4,
                  "item_name": "Montelon Kidz Tablet | 30's|Montelukast Sodium",
                  "tp": 134.94,
                  "item_id": "13462",
                  "category_id": "PHARMA | UNIT | TK 158.42",
                  "vat": 23.48,
                  "manufacturer": "158.42"
                }
              ]
            },
            {
              "order_serial": "ORD136",
              "delivery_date": "2024-10-08",
              "collection_date": "2024-10-10",
              "delivery_time": "Morning",
              "payment_mode": "CREDIT",
              "offer": "Special offer",
              "note": "Handle with care",
              "latitude": "23.7890000",
              "longitude": "90.4050000",
              "location_detail": "132 Central Avenue",
              "item_list": [
                {
                  "quantity": 2,
                  "item_name": "Mixit Tablet | 50's|Flupentixol+Melitracen",
                  "tp": 187.41,
                  "item_id": "13315",
                  "category_id": "PHARMA | UNIT | TK 220.02",
                  "vat": 32.61,
                  "manufacturer": "220.02"
                },
                {
                  "quantity": 3,
                  "item_name": "Montelon 10 Tablet | 30's|Montelukast Sodium",
                  "tp": 359.82,
                  "item_id": "13426",
                  "category_id": "PHARMA | UNIT | TK 422.43",
                  "vat": 62.61,
                  "manufacturer": "422.43"
                }
              ]
            }
          ]
        }
      ]
    },
    {
      "area_id": "A002",
      "area_name": "North Zone",
      "clientList": [
        {
          "client_id": "C002",
          "client_name": "Client B",
          "category_name": "Wholesale",
          "orders": [
            {
              "order_serial": "ORD131",
              "delivery_date": "2024-10-01",
              "collection_date": "2024-10-03",
              "delivery_time": "Evening",
              "payment_mode": "CREDIT",
              "offer": "Free shipping",
              "note": "Handle with care",
              "latitude": "23.7810000",
              "longitude": "90.4010000",
              "location_detail": "124 Central Avenue",
              "item_list": [
                {
                  "quantity": 3,
                  "item_name": "Mixit Tablet | 50's|Flupentixol+Melitracen",
                  "tp": 187.41,
                  "item_id": "13315",
                  "category_id": "PHARMA | UNIT | TK 220.02",
                  "vat": 32.61,
                  "manufacturer": "220.02"
                },
                {
                  "quantity": 6,
                  "item_name": "Montelon Kidz Tablet | 30's|Montelukast Sodium",
                  "tp": 157.42,
                  "item_id": "13463",
                  "category_id": "PHARMA | UNIT | TK 184.81",
                  "vat": 27.39,
                  "manufacturer": "184.81"
                }
              ]
            },
            {
              "order_serial": "ORD134",
              "delivery_date": "2024-10-05",
              "collection_date": "2024-10-07",
              "delivery_time": "Morning",
              "payment_mode": "CASH",
              "offer": "15% discount",
              "note": "Deliver to store",
              "latitude": "23.7820000",
              "longitude": "90.4020000",
              "location_detail": "125 North Avenue",
              "item_list": [
                {
                  "quantity": 4,
                  "item_name": "Moxigram Eye Drops | 5 ml|Moxifloxacin HCl 0.5%",
                  "tp": 97.46,
                  "item_id": "51212",
                  "category_id": "PHARMA | UNIT | TK 114.42",
                  "vat": 16.96,
                  "manufacturer": "114.42"
                },
                {
                  "quantity": 2,
                  "item_name": "Nervopex Tablet | 50's|Vit B1 + Vit B6 + Vit B12",
                  "tp": 337.33,
                  "item_id": "13526",
                  "category_id": "PHARMA | UNIT | TK 396.03",
                  "vat": 58.7,
                  "manufacturer": "396.03"
                }
              ]
            }
          ]
        }
      ]
    },
    {
      "area_id": "A003",
      "area_name": "South Zone",
      "clientList": [
        {
          "client_id": "C003",
          "client_name": "Client C",
          "category_name": "Retail",
          "orders": [
            {
              "order_serial": "ORD132",
              "delivery_date": "2024-10-05",
              "collection_date": "2024-10-07",
              "delivery_time": "Morning",
              "payment_mode": "CASH",
              "offer": "15% off",
              "note": "Deliver to store",
              "latitude": "23.7830000",
              "longitude": "90.4030000",
              "location_detail": "126 South Avenue",
              "item_list": [
                {
                  "quantity": 4,
                  "item_name": "Montelon 10 Tablet | 30's|Montelukast Sodium",
                  "tp": 359.82,
                  "item_id": "13426",
                  "category_id": "PHARMA | UNIT | TK 422.43",
                  "vat": 62.61,
                  "manufacturer": "422.43"
                }
              ]
            },
            {
              "order_serial": "ORD135",
              "delivery_date": "2024-10-10",
              "collection_date": "2024-10-12",
              "delivery_time": "Evening",
              "payment_mode": "CASH",
              "offer": "20% off",
              "note": "Leave at reception",
              "latitude": "23.7840000",
              "longitude": "90.4040000",
              "location_detail": "130 South Avenue",
              "item_list": [
                {
                  "quantity": 2,
                  "item_name": "Ocubac D Eye Drops | 5 ml|Dexamethasone",
                  "tp": 159.83,
                  "item_id": "61616",
                  "category_id": "PHARMA | UNIT | TK 187.79",
                  "vat": 27.96,
                  "manufacturer": "187.79"
                },
                {
                  "quantity": 3,
                  "item_name": "Xorimax 500 mg Tablet | 6's|Cefuroxime",
                  "tp": 239.74,
                  "item_id": "13216",
                  "category_id": "PHARMA | UNIT | TK 281.70",
                  "vat": 41.96,
                  "manufacturer": "281.70"
                }
              ]
            }
          ]
        }
      ]
    }
  ]
};

dynamic jsonBody = jsonEncode(body);