# Klunk

## Goal

Create and setup __publishers__ (topics) and __subscribers__ (queues) for Rails applications.

## About

"Stop the pigeon! Stop the pigeon!"

Dick Dastardly and Muttley, the villains from Wacky Races, are now flying aces and members of the Vulture Squadron, a crew of aviators on a mission to stop a homing pigeon named _Yankee Doodle Pigeon_ from delivering _messages_ to the other side. Each story features variations on the same plot elements: the Vulture Squadron tries to trap _Yankee Doodle Pigeon_ using one or more planes equipped with __Klunk__'s latest contraptions, but one or more of the Squadron messes up and the planes either crash, collide or explode (or all of the above).

![The Vulture Squadron](vulture_squadron.jpg "The Vulture Squadron")

## Publish-Subscribe Messaging Pattern

In software architecture, __publish–subscribe__ is a messaging pattern where senders of messages, called _publishers_, do not program the messages to be sent directly to specific receivers, called _subscribers_, but instead characterize published messages into classes without knowledge of which _subscribers_, if any, there may be. Similarly, _subscribers_ express interest in one or more classes and only receive messages that are of interest, without knowledge of which _publishers_, if any, there are.

__Publish–Subscribe__ is a sibling of the message queue paradigm, and is typically one part of a larger message-oriented middleware system. This pattern provides greater network scalability and a more dynamic network topology, with a resulting decreased flexibility to modify the publisher and the structure of the published data. In other words, __publish-subscribe__ is a pattern used to communicate messages between different system components without these components knowing anything about each other’s identity.

This design pattern is not new, but it’s not commonly used by Rails developers. But it can bring major advantages for a Rails application.

### Advantages

* __Reduce model/controller bloat__

 It can help decomposing fat models or controllers.

* __Fewer callbacks__

 Enable models to work independently with minimum knowledge about each other, ensuring loose coupling. Expanding the behavior to additional actions is just a matter of hooking to the desired event.

* __Single Responsibility Principle (SRP)__

 _Models_ should handle persistence, associations and not much else.
 _Controllers_ should handle user requests and be a wrapper around the business logic (Service Objects).
 Service Objects should encapsulate one of the responsibilities of the business logic, provide an entry point for external services, or act as an alternative to model concerns.
 Thanks to its power to reduce coupling, the __publish-subscribe__ design pattern can be combined with single responsibility service objects (SRSOs) to help encapsulate the business logic, and forbid the business logic from creeping into either the models or the controllers. This keeps the code base clean, readable, maintainable and scalable.

* __Testing__

 By decomposing the fat models and controllers, and having a lot of SRSOs, testing of the code base becomes a much, much easier process. This is particularly the case when it comes to integration testing and inter-module communication. Testing should simply ensure that events are published and received correctly.

### Disadvantages

* _Loose coupling_

 The greatest of the __publish-subscribe__ pattern’s strength may be also it’s greatest weakness. The structure of the data published (the event payload) must be well defined, and quickly becomes rather inflexible. In order to modify data structure of the published payload, it is necessary to know about all the _subscribers_, and either modify them also, or ensure the modifications are compatible with older versions. This makes refactoring of _publisher_ code much more difficult.
 If you want to avoid this you have to be extra cautious when defining the payload of the _publishers_. Of course, if you have a great test suite, that tests the payload as well as mentioned previously, you don’t have to worry much about the system going down after you change the _publisher_’s payload or event name.

* _Messaging Bus stability_

 _Publishers_ have no knowledge of the status of the _subscriber_ and vice versa. Using simple __publish-subscribe__ tools, it might not be possible to ensure the stability of the messaging bus itself, and to ensure that all the published messages are correctly queued and delivered.

* _Visibility_

 Eventually, messages can cause receiver processes (workers) to crash. Specify maximum retry limits and message hospital (dead letter queues), where messages got sent if they failed. And, in order to avoid a catastrophic failover, having an UI to monitor those messages and retry them if needed is strongly encouraged.

* _Infinite event loops_

 When the system is completely driven by events, you should be extra cautious not to have event loops. These loops are just like the infinite loops that can happen in code. However, they are harder to detect ahead of time, and they can bring your system to a standstill. They can exist without your notice when there are many events published and subscribed across the system.

* __Setup__

 When you split the monolith and move towards fine grained systems, the setup and deployment of _publishers_ and _subscribers_ can be painful and error prone. This is why we created __Klunk__.

## Installation

Add it to your `Gemfile`:

```ruby
gem 'klunk'
```

Run the following command to install it:

```console
bundle install
```

Run the generator:

```console
rails generate klunk:install
```

## Configuration

TODO: Explain how to setup - configuration files, values and so on...

## Usage

TODO: Write usage instructions here - explain the `Rake` tasks...

## Disclaimer

 So far, __Klunk__ only works with Amazon [SNS](https://aws.amazon.com/sns/) and [SQS](https://aws.amazon.com/sqs/) services. But you shouldn't be using anything else, right?! :wink:

## Maintainers

* Marco Antonio Gonzalez Junior (https://github.com/kayaman)
* Wagner Vaz (https://github.com/0xdco)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/kayaman/klunk.

## License

  __Klunk__ is an Open Source project licensed under the terms of
the LGPLv3 license.  Please see [http://www.gnu.org/licenses/lgpl-3.0.html](http://www.gnu.org/licenses/lgpl-3.0.html)
for license text.
