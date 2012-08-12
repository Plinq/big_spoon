# Big Spoon
**Big Spoon** adds ActiveRecord::Base-style `before_*` and `after_*` callbacks around ANY Ruby method.

It's like a sandwich, where your method is the meat and your callbacks are the bread.

## Basic Usage

Out-of-the box, **Big Spoon** adds callbacks that are similar to ActiveRecord::Base. Of course there's, like, at least three ways to do that. So **Big
Spoon** supports all of 'em. Whatever form you choose, it'll swaddle your methods in the warm of `before` and `after` hooks.

### ActiveRecord::Base-style

The most straightforward way is to do it ActiveRecord::Base style, which is to define a callback in the top of your class like so:

```
class User
  before_believe_in_a_thing_called_love :listen_to_the_rhythm_of_my_heart

  def believe_in_a_thing_called_love
    puts "We'll be rockin til the sun goes down!"
  end

  def listen_to_the_rhythm_of_my_heart
    listen("127.0.0.1") do
      match /(lub|dub)/ do
        puts "Edgar Allan Poe!"
      end
    end
  end
````

### DataMapper-style

DataMapper has what I consider a slightly better API for doing this, specifically:

```
class User
  after :save, :get_your_hands_off_of_my_woman
 end
```

So **Big Spoon** supports that notation, too! This is in order to avoid conflicts with Rails callbacks and their siblings. But if'n you're a real scofflaw, you can just do it normal-like.


### Block-style

If you're STILL interested in avoiding any potential conflicts, you can isolate your hooks
completely by wrapping them in a block:

```
class User
  hooks do
    before :get_your_hands_off_of_my_woman, :listen_to_the_darkness
  end

  protected
  def listen_to_the_darkness!
    `osascript "tell iTunes to play some awesome"`
  end
end
```

So. Add hooks. To any Ruby method. That's pretty damn awesome, where I come form. I SAID "FORM," son!

But, as they say, "love is only a feeling." So spoon like there's no tomorrow.

## But there's (conditionally) more!

Because ActiveModel callbacks are just so damn delightful, I've added some fun conditional sugar to match their wonderful. So g'head and add some `:if` conditions to your callbacks:

```
class User
  before :love_on_the_rocks, :add_ice, :if => :no_ice?

  def love_on_the_rocks
    puts "Loo-OOOVE ON THE ROCKS! YOU'D DO ANYTHING FOR A QUIET LIFE!"
  end

  def no_ice?
    Ice.empty?
  end

  protected
  def add_ice
    Ice.create!
  end
end
```

Conditional callbacks also support `:unless`, just like their ActiveModel ancestors. Or should I say "inspiritors?" Is that word? Shut up, of course it is. Anyway:

```
class User
  before :love_on_the_rocks, :add_ice, :unless => :in_tys_mazada?

  def not_in_tys_mazada?
    (mazda = User.find_by_name("Ty").car) && mazda.has_rad_bass?
  end
end
```

And to recap! Just as  with the believing-in-things-called-love example, both could be re-written along these lines:

```
before_love_on_the_rocks :add_ice, :if => :no_ice?
# or
hooks do
  before :love_on_the_rocks, :add_if, :if => :no_ice?
end
```

HAPPY **CALLING-OF-THE-BACK**, FRIENDS!

Copyright © 2012 Delightful Widgets Inc. No warranty so don't sue me or my company THANKS!