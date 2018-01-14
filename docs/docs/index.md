# Triggers Service

For full Bark documentation visit [http://localhost/docs](http://localhost/docs).

## Authorization

To perform any requests you need to send user token via `Authorization` header. Example:
`Authorization: Bearer <token>`.

## Show Trigger

GET `/houses/:house_id/devices/:device_id/triggers/:id`

*PATH parameters*

Name         | Validation
------------ | -------------
id           | required 
house_id     | required
device_id    | required

*Response [200]*

```json
{
  "id": 1,
  "device_id": 1,
  "title": "MyTrigger",
  "key": "my_trigger",
  "output": "[{\"key\":\"temp\",\"type\":\"int\"}]",
  "type": 1,
  "created_at": "2017-11-11 11:04:44 UTC",
  "updated_at": "2017-1-11 11:04:44 UTC"
}
```

`output` is json encoded field listing data keys and types sent with trigger.
`type` 0 is system trigger, 1 is device trigger.


*Error Response [401]*

Wrong user token

*Error Response [404]*

Trigger not found

## Validate trigger 

Validates trigger belongs to house and returns it.

GET `/houses/:house_id/triggers/:id`

*PATH parameters*

Name         | Validation
------------ | -------------
id           | required 
house_id     | required

*Response [200]*

```json
{
  "id": 1,
  "device_id": 1,
  "title": "MyTrigger",
  "key": "my_trigger",
  "output": "[{\"key\":\"temp\",\"type\":\"int\"}]",
  "type": 1,
  "created_at": "2017-11-11 11:04:44 UTC",
  "updated_at": "2017-1-11 11:04:44 UTC"
}
```

`output` is json encoded field listing data keys and types sent with trigger.
`type` 0 is system trigger, 1 is device trigger.


*Error Response [401]*

Wrong user token

*Error Response [404]*

Trigger for this house not found

## Create Trigger

POST `/houses/:house_id/devices/:device_id/triggers`

*PATH parameters*

Name         | Validation
------------ | ------------- 
house_id     | required
device_id    | required


*POST parameters*

Name          | Validation
------------  | -------------
output        | optional 
title         | required
key           | required

*Response [200]*

```json
{
  "id": 1,
  "device_id": 1,
  "title": "MyTrigger",
  "key": "my_trigger",
  "output": "[{\"key\":\"temp\",\"type\":\"int\"}]",
  "type": 1,
  "created_at": "2017-11-11 11:04:44 UTC",
  "updated_at": "2017-1-11 11:04:44 UTC"
}
```

`output` is json encoded field listing data keys and types sent with trigger.
`type` 0 is system trigger, 1 is device trigger.

*Error Response [422]*

```json
[
  ["title", ["must be filled"]],
  ["key", ["must be filled"]],
  ["key", ["already taken"]]
]
```

*Error Response [401]*

Wrong user token

## Update Trigger

PUT `/houses/:house_id/devices/:device_id/triggers/:id`

*PATH parameters*

Name         | Validation
------------ | ------------- 
house_id     | required
device_id    | required
id           | required


*POST parameters*

Name          | Validation
------------  | -------------
output        | optional 
title         | required

*Response [200]*

```json
{
  "id": 1,
  "device_id": 1,
  "title": "MyTrigger",
  "key": "my_trigger",
  "output": "[{\"key\":\"temp\",\"type\":\"int\"}]",
  "type": 1,
  "created_at": "2017-11-11 11:04:44 UTC",
  "updated_at": "2017-1-11 11:04:44 UTC"
}
```

`type` 0 is system trigger, 1 is device trigger.

*Error Response [422]*

```json
[
  ["title", ["must be filled"]]
]
```

*Error Response [401]*

Wrong user token

## List Triggers

GET `/houses/:house_id/devices/:device_id/triggers`

*PATH parameters*

Name         | Validation
------------ | ------------- 
house_id     | required
device_id    | required

*Response [200]*

```json
[
    {
      "id": 1,
      "device_id": 1,
      "title": "MyTrigger",
      "key": "my_trigger",
      "output": "[{\"key\":\"temp\",\"type\":\"int\"}]",
      "type": 1,
      "created_at": "2017-11-11 11:04:44 UTC",
      "updated_at": "2017-1-11 11:04:44 UTC"
    }
]
```

`type` 0 is system trigger, 1 is device trigger.

*Error Response [401]*

No token provided

## List System Triggers

GET `/triggers/system`

*Response [200]*

```json
[
    {
      "id": 1,
      "device_id": 1,
      "title": "MyTrigger",
      "key": "my_trigger",
      "output": "[{\"key\":\"temp\",\"type\":\"int\"}]",
      "type": 0,
      "created_at": "2017-11-11 11:04:44 UTC",
      "updated_at": "2017-1-11 11:04:44 UTC"
    }
]
```

`type` 0 is system trigger, 1 is device trigger.

*Error Response [401]*

No token provided

## Delete Trigger

DELETE `/houses/:house_id/devices/:device_id/triggers/:id`


*PATH parameters*

Name         | Validation
------------ | ------------- 
house_id     | required
device_id    | required
id           | required

*Response [200]*

Deleted.

*Error Response [401]*

No token provided