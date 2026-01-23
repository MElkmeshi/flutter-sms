## Nazaka APIs Docs

### Server Info

| Server             | URL                      |
|--------------------|--------------------------|
| Development Server | https://nazaka.ethaq.ly/ |
| Production Server  |                          |

## API

### # OTP

##### + Send OTP SMS

> This endpoint is used to send otp
>
> sms to the customer.

```http
POST /api/v1/otp/requests
```

| Body         | Validation | Type      | Example |
|--------------|------------|-----------|---------|
| phone_number | `required` | `numeric` |         |

##### + Verify OTP

> This endpoint is used to verify the OTP sent to the customer.

```http
POST /api/v1/otp/requests/{OtpUuid}/verify
```

| Body         | Validation | Type     | Example                  |
|--------------|------------|----------|--------------------------|
| device_token | `required` | `string` | device_token = "123ABC"  |
| device_name  | `required` | `string` | device_name = "iPhone 7" |
| code         | `required` | `string` | code= 11111              |

##### + Logout

```http
POST /api/v1/logout
```

### + Products

#### List Products

> This endpoint will all products in random order.

```http
GET /api/v1/products HTTP/1.1
```

| Param                          | Type      | Example                                            | Notes |
|--------------------------------|-----------|----------------------------------------------------|-------|
| `category`                     | `uuid`    | ``` api/v1/products/?filter[cateogry]='123qwe' ``` |       |
| `occasion`                     | `uuid`    | ``` api/v1/products/?filter[occasion]='123qwe' ``` |       |
| `color`                        | `uuid`    | ``` api/v1/products/?filter[color]='123qwe' ```    |       |
| `brand`                        | `uuid`    | ``` api/v1/products/?filter[brand]='123qwe' ```    |       |
| `price_from`                   | `string`  | ``` api/v1/products/?filter[price_from]=30 ```     |       |
| `price_to`                     | `string`  | ``` api/v1/products/?filter[price_to]=50 ```       |       |
| `trending`                     | `boolean` | ``` api/v1/products?filter[trending]=true ```      |       |
| `discounted`                   | `boolean` | ``` api/v1/products?filter[discounted]=true ```    |       |
| `most_liked`                   | `boolean` | ``` api/v1/products?filter[most_liked]=true ```    |       |
| `sort from old to recent`      | `boolean` | ``` api/v1/products?sort=date ```                  |       |
| `sort from recent to old`      | `boolean` | ``` api/v1/products?sort=-date ```                 |       |
| `sort from cheap to expensive` | `boolean` | ``` api/v1/products?sort=price ```                 |       |
| `sort from expensive to cheap` | `boolean` | ``` api/v1/products?sort=-price ```                |       |
| `sort of most discounted`      | `boolean` | ``` api/v1/products?sort=discount ```              |       |

#### Show Product

> This endpoint will show product details

```http
GET /api/v1/products/{productUuid} HTTP/1.1
```

### + Reactions

#### List Products reacted on (DELETED)

> This endpoint will list all products which have been reacted on.

```http
GET /api/v1/reacted-products HTTP/1.1
Authorization: Bearer <token>
```

#### Toggle Product Reaction

> This endpoint to react on a product and reverse reaction.

```http
POST /api/v1/reacted-products/{productUuid} HTTP/1.1
Authorization: Bearer <token>
```

| Body          | Validation | Type     | Example          |
|---------------|------------|----------|------------------|
| reaction_type | `required` | `string` | love, like, fire |

### + Plans

#### List Avaliable Plans

> This endpoint to list app available plans

```http
GET /api/v1/plans HTTP/1.1
Authorization: Bearer <token>
```

### + Seller Store Operations

#### Create A Store

> This endpoint will create a store for the customer.

```http
POST /api/v1/seller/store HTTP/1.1
Authorization: Bearer <token>
```

| Body          | Validation | Type     | Example |
|---------------|------------|----------|---------|
| name          | `required` | `string` |         |
| location      | `required` | `string` |         |
| city          | `required` | `uuid`   |         |
| plan          | `required` | `uuid`   |         |
| facebook_url  | `required` | `url`    |         |
| instagram_url | `required` | `url`    |         |
| whatsapp_url  | `required` | `url`    |         |

#### View Store Details

> This endpoint will return store details.

```http
GET /api/v1/seller/store HTTP/1.1
Authorization: Bearer <token>
```

#### Update Store Details

> This endpoint will return store details.

```http
PATCH /api/v1/seller/store HTTP/1.1
Authorization: Bearer <token>
```

| Body          | Validation | Type     | Example |
|---------------|------------|----------|---------|
| name          | `required` | `string` |         |
| location      | `required` | `string` |         |
| city          | `required` | `uuid`   |         |
| facebook_url  | `required` | `url`    |         |
| instagram_url | `required` | `url`    |         |
| whatsapp_url  | `required` | `url`    |         |

#### List store products

> This endpoint will list all store products.

```http
GET /api/v1/seller/products HTTP/1.1
Authorization: Bearer <token>
```

#### Show Product

> This endpoint will show product details.

```http
GET /api/v1/seller/products/{productUuid} HTTP/1.1
Authorization: Bearer <token>
```

#### Delete Product

> This endpoint will delete product.

```http
DELETE /api/v1/seller/products/{productUuid} HTTP/1.1
Authorization: Bearer <token>
```

#### Create A Product

> This endpoint to create a product for the seller store.

```http
POST /api/v1/sller/products HTTP/1.1
Authorization: Bearer <token>
```

| Body                            | Validation                        | Type                         | Example                           |
|---------------------------------|-----------------------------------|------------------------------|-----------------------------------|
| product[offer_type]             | `required`                        | `string`                     | Avaliable options: `sale`, `rent` |
| product[renting_status]         | `required` if `offer_type = rent` | `string`                     | check renting statuses API        |
| product[color]                  | `required`                        | `uuid`                       | check colors API                  |
| product[quality_status]         | `required`                        | `string`                     | check quality statuses API        |
| product[delivery_type]          | `required`                        | `string`                     | check delivery types API          |
| product[country_of_manufacture] | `required`                        | `uuid`                       | check countries API               |
| product[price]                  | `required`                        | `number`                     |                                   |
| product[description]            | `required`                        | `string`                     |                                   |
| product[category]               | `required`                        | `uuid`                       | Check categories API              |
| product[brand]                  | `required`                        | `uuid`                       | Check brands API                  |
| sizes[eu]                       | `nullable`                        | `string`                     | Check sizes API                   |
| sizes[uk]                       | `required`                        | `string`                     | Check sizes API                   |
| sizes[letter]                   | `required`                        | `string`                     | Check sizes API                   |
| media[front_picture]            | `required`                        | `file`, `png or jpg or jpeg` |                                   |
| media[back_picture]             | `nullable`                        | `file`, `png or jpg or jpeg` |                                   |
| media[tag_picture]              | `nullable`                        | `file`, `png or jpg or jpeg` |                                   |
| media[video]                    | `nullable`                        | `file`, `png or jpg or jpeg` |                                   |

#### Update A Product

> This endpoint to update a product on the seller store.

```http
PATCH /api/v1/sller/products/{productUuid} HTTP/1.1
Authorization: Bearer <token>
```

| Body                            | Validation                        | Type     | Example                           |
|---------------------------------|-----------------------------------|----------|-----------------------------------|
| product[offer_type]             | `required`                        | `string` | Avaliable options: `sale`, `rent` |
| product[renting_status]         | `required` if `offer_type = rent` | `string` | check renting statuses API        |
| product[color]                  | `required`                        | `uuid`   | check colors API                  |
| product[quality_status]         | `required`                        | `string` | check quality statuses API        |
| product[delivery_type]          | `required`                        | `string` | check delivery types API          |
| product[country_of_manufacture] | `required`                        | `uuid`   | check countries API               |
| product[price]                  | `required`                        | `number` |                                   |
| product[price_after_discount]   | `nullable`                        | `number` |                                   |
| product[description]            | `required`                        | `string` |                                   |
| product[category]               | `required`                        | `uuid`   | Check categories API              |
| product[brand]                  | `required`                        | `uuid`   | Check brands API                  |
| sizes[eu]                       | `nullable`                        | `string` | Check sizes API                   |
| sizes[uk]                       | `required`                        | `string` | Check sizes API                   |
| sizes[letter]                   | `required`                        | `string` | Check sizes API                   |

#### Add Media to Product

```http
POST /api/v1/sller/products/{productUuid}/media HTTP/1.1
Authorization: Bearer <token>
```

| Body | Validation | Type     | Example                                      |
|------|------------|----------|----------------------------------------------|
| type | `required` | `string` | front_picture,back_picture,tag_picture,video |
| file | `required` | `string` | image of video depending on type             |

#### Delete Media

```http
DELETE /api/v1/sller/products/{productUuid}/media/{mediaUuid} HTTP/1.1
Authorization: Bearer <token>
```

#### Change Subscription

creates or updates a subscription for the seller store.

```http
POST /api/v1/seller/subscriptions HTTP/1.1
Authorization: Bearer <token>
```

| Body | Validation | Type   | Example |
|------|------------|--------|---------|
| plan | `required` | `uuid` |         |

### # Profile

##### + Update Profile

> This endpoint is used update user profile details.

```http
POST /api/profile
```

| Body            | Validation | Type     | Example                       |
|-----------------|------------|----------|-------------------------------|
| name            | `required` | `string` |                               |
| city            | `nullable` | `uuid`   |                               |
| sizes[]         | `required` | `array`  | at least one size is required |
| sizes[eu]       | `nullable` | `string` | Check sizes API               |
| sizes[uk]       | `nullable` | `string` | Check sizes API               |
| sizes[letter]   | `nullable` | `string` | Check sizes API               |
| profile_picture | `nullable` | `image`  |                               |

#### Show Profile

> This endpoint will view profile details

```http
GET /api/profile HTTP/1.1
Authorization: Bearer <token>
```

#### Delete Profile Account

> This endpoint will delete profile account and its related data.

```http
DELETE /api/profile HTTP/1.1
Authorization: Bearer <token>
```

#### Check Delete Profile Account Request

> This endpoint will return if a deletion request has been sent of not.

```http
GET /api/profile/delete-request HTTP/1.1
Authorization: Bearer <token>
```

#### Delete Profile Account

> This endpoint will send a delete profile account request.

```http
POST /api/profile/delete-request HTTP/1.1
Authorization: Bearer <token>
```

### + Helpers

#### List countries

> This endpoint will list countries

```http
GET /api/v1/countries HTTP/1.1
```

#### List cities

> This endpoint will list cities

```http
GET /api/v1/cities HTTP/1.1
```

#### List categories

> This endpoint will list categories

```http
GET /api/v1/categories HTTP/1.1
```

#### List brands

> This endpoint will list brands

```http
GET /api/v1/brands HTTP/1.1
```

#### List occasions

> This endpoint will list occasions

```http
GET /api/v1/occasions HTTP/1.1
```

#### List colors

> This endpoint will list colors

```http
GET /api/v1/colors HTTP/1.1
```

#### List sizes

> This endpoint will list sizes

```http
GET /api/v1/sizes HTTP/1.1
```

| Param  | Type   | Example                                    | Notes                |
|--------|--------|--------------------------------------------|----------------------|
| `type` | `uuid` | ``` api/v1/products/?filter[type]='eu' ``` | `eu`, `uk`, `letter` |

#### List renting statuses

> This endpoint will list renting statuses

```http
GET /api/v1/renting-statuses HTTP/1.1
```

#### List quality statuses

> This endpoint will list quality statuses

```http
GET /api/v1/quality-statuses HTTP/1.1
```

#### List delivery types

> This endpoint will list delivery types

```http
GET /api/v1/delivery-types HTTP/1.1
```

#### List reaction types

> This endpoint will list reaction types

```http
GET /api/v1/reaction-types HTTP/1.1
```
