# Overview

Broker contains exchanges and queues.

Publishers publish into exchanges, consumers consume queues.

Broker routes messages from exchanges to queues via bindings (a
binding binds a queue to an exchange).

The clients (publishers and consumers), not the broker administrator,
set up all these things (exchanges, queues, bindings -- collectively
called AMQP entities) via AMQP "API calls" (similar to HTTP/REST).

# Exchanges

Exchanges have a type (see below), name, durability (boolean - tells
whether the exchange survives a broker restart), autodelete (boolean
-- tells whether the exchange is deleted after the last queue is
unbound from it), arguments (broker-dependent).

## Exchange Types

type              | default pre-declared exchange names(?)
------------------|----------------------------------------
Direct exchange	  | (Empty string) and amq.direct
Fanout exchange	  | amq.fanout
Topic exchange	  | amq.topic
Headers exchange  | amq.match (and amq.headers in RabbitMQ)


## Direct Exchanges

A queue is bound to zero or more direct exchanges with a routing key
as a property ("argument") of the binding. The routing key is a string
field in all AMQP message headers that's matched against all the
bindings

There can be multiple bindings for the same direct exchange with the
same routing key. In that case, messages with that routing key will be
delivered via all these bindings, i.e. to multiple destination queues.

### Default Exchange

Predefined direct exchange that any created queues are automatically
bound to, with the routing key of the binding equal to the queue name.

For example, when you declare a queue with the name of
"search-indexing-online", the AMQP broker will bind it to the default
exchange using "search-indexing-online" as the routing key. Therefore,
a message published to the default exchange with the routing key
"search-indexing-online" will be routed to the queue
"search-indexing-online". In other words, the default exchange makes
it seem like it is possible to deliver messages directly to queues,
even though that is not technically what is happening.

## Fanout Exchanges

A fanout exchange has one or more queues bound to it (with no
properties of the bindings). All messages sent into the exchange are
delivered to all the bound queues, the routing key is ignored.

## Topic Exchanges

Like direct exchanges, but the routing key properties of the bindings
are patterns (e.g. billing.* or billing.*.* foo.*.bar or billing.#)
that are matched against the routing key.

## Headers Exchanges

Like direct exchanges, matches against message headers... (TODO)


# Queues

Properties of a queue:

- name

- durability (boolean - tells whether the queue
  survives a broker restart)
  
- autodelete (boolean -- tells whether the
  queue is deleted after the last consumer has disconnected)
  
- exclusive (boolean -- tells whether only one consumer can use this
  queue and it is autodeleted after use), arguments
  (broker-dependent).

The name is unique. Consumer must "declare" the queue when connecting
-- which means the consumer specifies the properties. If one by that
name doesn't exist, it is created, otherwise the attributes of the
existing queue must match the declaration or an error (406
PRECONDITION_FAILED) is raised.


# Consumers

Consumers fetch messages from queues (pull API) or subscribe to a
queue and have messages delivered to them (push API). When they've
fetched/received a message, they must acknowledge it explicitly
(preferably after they've successfully processed it), and only then
will the broker delete them from the queue. A message is not
acknowledged if the consumer rejects is explicitly or just dies.

There is an "automatic acknowledgement" model in which the message is
automaticaly acked right after the consumer has gotten it.

# Vhosts

Like webserver vhosts -- completely isolated environments in which
AMQP entities live. Default vhost: /
