# SampleApp

<image src="/assets/images/home.png"/>

This app has been developped by following the book "Phoenix Tutorial (Phoenix 1.6): Learn Web Development with Phoenix".  
This book teaches you how to develop custom web applications with the Phoenix web framework.
In addition, the Phoenix Tutorial teaches the broader skill of technical sophistication (Box 1.1),
which is a principal theme developed by the Learn Enough series of tutorials.
The Learn Enough tutorials are suitable as prerequisites to the Phoenix Tutorial.  
  
A small precision, I am using Phoenix 1.7 which has several differencies with the previous version used by the book.
  
This part of the tutorial focuses on developing a single large real sample application (called sample_app), writing all the code from scratch.
I developed the sample app using a combination of mockups, test-driven development (TDD), and integration tests. 
I started by creating static pages and then added a little dynamic content. 
Then I completed the foundation for the sample application by making a site layout, a user data model, 
and a full registration and authentication system (including account activation and password resets).
Finally, I’ll add microblogging and social features to make a working example site.

## Phoenix
Phoenix is a web development framework written in the Elixir programming language.
Since its debut in 2014, Phoenix has become one of the most powerful tools for building reliably fast dynamic web applications.
Phoenix is used by companies as varied as Pinterest, Bleacher Report, Lonely Planet, and USwitch.  
  
What makes Phoenix so great? First, Phoenix is 100% open-source under the generous MIT License.
As a result, it costs nothing to download or use.
Second, Phoenix is fast and concurrent because it is written with the Elixir programming language.
Elixir is a language that runs on the Erlang virtual machine.
Erlang is an old battle-tested language that is fast, concurrent, and reliable.
In this day and age, we all have computers with multicore architectures.
Elixir allows you to write software that uses all of the cores on a multicore architecture.

## Usage

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
