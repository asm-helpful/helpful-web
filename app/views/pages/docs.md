FORMAT: 1A

# Helpful API
Helpful API is a service to interact with helpful.io  It provides API access to all the resources in the app.

# Helpful API Root [/api]
NOT IMPLEMENTED - BUT LEFT FOR FUTURE REFERENCE Helpful API entry point.

This resource does not have any attributes. Instead it offers the initial API affordances in the form of the HTTP Link header and HAL links.

## Retrieve Entry Point [GET]

+ Response 200 (application/json)
    + Headers

            Link: <https://helpful.io/api/>;rel="self",<https://helpful.io/api/messages>;rel="conversations"

    + Body

            {
                "_links": {
                    "self": { "href": "/" },
                    "messages": { "href": "/messages?{since}", "templated": true }
                }
            }


# Group Messages
Messages related resources of *Helpful API*.

## Message [/message/{id}]
A single Message object. The Message resource represents a single message that is part of a conversation.

The Message resource has the following attributes:

- id
- conversation_id
- person_id
- data
- created_at
- updated_at
- description
- content

The states *id* and *created_at* are assigned by the Helpful API at the moment of creation.


+ Parameters
    + id (UUID) ... ID of the Message

+ Model (application/hal+json)

    JSON representation of Message Resource. In addition to representing its state in the JSON form it offers affordances in the form of the HTTP Link header and HAL links.

    + Headers

    + Body

            {
                "id":"d06a5c13-0981-435d-9510-67e05277191b",
                "conversation_id":"b9df99ba-ce31-4cc1-827d-a8c900a879ee",
                "person_id":"81b303ca-258e-453c-bc84-5eafba8cef87",
                "content":"Voluptatem ab. Ipsum quo.",
                "data":null,
                "created_at":"2013-12-08T13:08:14.758Z",
                "updated_at":"2013-12-08T13:08:14.758Z"
            }

### Retrieve a Single Message [GET]
+ Response 200

    [Message][]


## Messages Collection [/messages{?since}]
Collection of all Messages.

The Message Collection resource has the following attribute:

- total

In addition it **embeds** *Message Resources* in the Helpful API.


+ Model (application/json)

    JSON representation of Message Collection Resource. The Message resources in collections are embedded. Note the embedded Messages resource are incomplete representations of the Message in question. Use the respective Message link to retrieve its full representation.

    + Headers

            Link: <https://helpful.io/api/messages>;rel="self"

    + Body

            {
                "messages": [
                    {
                        "id":"d06a5c13-0981-435d-9510-67e05277191b",
                        "conversation_id":"b9df99ba-ce31-4cc1-827d-a8c900a879ee",
                        "person_id":"81b303ca-258e-453c-bc84-5eafba8cef87",
                        "content":"Voluptatem ab. Ipsum quo.",
                        "data":null,
                        "created_at":"2013-12-08T13:08:14.758Z",
                        "updated_at":"2013-12-08T13:08:14.758Z"
                    }
                ]
            }

### List All Messages [GET]
+ Parameters
    + since (optional, string) ... Timestamp in ISO 8601 format: `YYYY-MM-DDTHH:MM:SSZ` Only Messages updated at or after this time are returned.

+ Response 200

    [Messages Collection][]

### Create a Message [POST]
TODO
