# Getting Connected with BancBox APIs using Ruby

[BancBox](http://bancbox.com) is a complete payments services platform that lets
you collect money in a variety of ways.

This sample web application shows you how to connect BancBox APIs via Ruby and
[Sinatra](http://www.sinatrarb.com/).

### Installation

Make sure you have Ruby installed in your system. (This app is tested with ruby
1.9.3 but it should be ok on other versions as well).

1. [Sign up](http://www.bancbox.com/signup) for BancBox to get your developer
credentials.

2. Install Bundler.

    $ gem install bunder

3. Install required gems.

    $ bundle install

4. Copy .env.sample file and edit it to match your credentials received from
Bancbox.

    $ mv .env.sample .env

5. Run the application

    $ foreman run shotgun -s thin


6. Visit http://localhost:9393/ on your browser to make sure it is running.

### Notes
BancBox currently is using SOAP for its API. Thanks to
[Savon](http://savonrb.com/), an awesome Ruby SOAP library, it
is not hard to connect to these services. Check _client.rb_ for a
starting point on how to setup properly to access BancBox APIs and how to
create an API client.

The web app, which is a single file (_app.rb_), uses this client to access 3
services on BancBox: CreateClient, SearchClients and GetClient. Savon
automatically handles naming to match Ruby naming conventions. Check Savon's
documentation for more info on this.

### BancBox Documentation
You can find more info at BancBox site for full documentation of available
services.

http://www.bancbox.com/api/index
