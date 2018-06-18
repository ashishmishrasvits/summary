Below are the Api's created for this project - 


1 - Create User - 

POST  - /api/users
Header - Content-Type : application/json
body - {"user" : {"email" : "someemail@email.com"}}

response - 
{
    "message": "user successfully created",
    "user_id": 1
}

2 - Create wallet for User
Post - /api/wallets
Header - Content-Type : application/json
body - {"wallet" : {"email" : "myemail@example.com", "currency" : "usd", "balance" : "100"}}

response - 
{
    "message": "Wallet successfully created",
    "wallet_id": 1
}

3 - Display all wallets for a user
Get - /api/wallets/myemail@example.com
Header - Content-Type : application/json

{
    "email": "myemail@example.com",
    "wallets": [
        {
            "id": 1,
            "balance": 100,
            "currency": "USD"
        },
        {
            "id": 2,
            "balance": 100,
            "currency": "USD"
        }
    ]
}

4 - Create a transaction for given wallet
 Post - /api/transactions
 Header - Content-Type : application/json
 body - {"transaction" : {"email" : "myemail@example.com", "wallet_id" : "1", "currency" : "usd", "amount": "100", "category": "deposit"}}

 response - 
 {
    "transaction_id": 1,
    "new_wallet_amount": "$200.00",
    "old_wallet_amount": "$100.00"
}

5 - Get Financial Summary by category
  Get - /api/financial_summary/display?email=myemail@example.com&currency=usd&category=deposit&report_range=lifetime
  Header - Content-Type : application/json


response - 
{
    "category": "deposit",
    "report_range": "lifetime",
    "count": 1,
    "currency": "USD",
    "amount": "100.00"
}


