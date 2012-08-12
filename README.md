# Big Spoon*
Like the big spoon in your relationship, **Big Spoon** wraps around your methods to wrap them in the warmth of callbacks.

Meaning: it adds `before` and `after` callbacks to **ANY** method in **_ANY_** Ruby class.
Basically, now you can add hooks and/or callbacks to **any** Ruby method without fear of reprisals.

*There were those who wanted to call it "sandwich," but they were killed.

## Basic Usage

Use **Big Spoon** like you would any other callbacks! Of course there's, like, at least three ways to do that. So **Big Spoon** supports all of 'em. Any
form lets you define `before`- and `after`-methods-or-blocks that any method your class could, like, ever call, should call. I just talked miles around a simple concept. But check it, code helps explain better than me! The safest is block form:

```ruby
class User
  hooks do
    before :get_your_hands_off_of_my_woman, :listen_to_the_darkness
    after :get_your_hands_off_of_my_woman { listen_to_moar_darkness! }
  end

  def get_your_hands_off_of_my_woman
    puts "Get your hands off of my woman, motherf*cker!"
  end

  protected
  def listen_to_the_darkness!
    `osascript "tell iTunes to play some awesome"`
  end

  def listen_to_moar_darkness
    `osascript "tell iTuens to continue not to suck after that last rad song"`
  end
end
```

This is designed not to conflict with Rails callbacks and their siblings. **But if'n
you're a real scofflaw (_and you f*cking should be!_), you can just do it normal-like:**

```ruby
class User
  before_believe_in_a_thing_called_love :listen_to_the_rhythm_of_my_heart

  def believe_in_a_thing_called_love
    puts "We'll be rockin til the sun goes down!"
  end

  def listen_to_the_rhythm_of_my_heart
    listen("127.0.0.1") do
      match /(lub|dub)/ do
        puts "Edgar Allan F*cking Poe?!"
      end
    end
  end
````

So. Add hooks. To any Ruby method. That's pretty damn awesome, where I come form. I SAID "FORM," son!

But, as they say, "love is only a feeling." So spoon like there's no tomorrow.

## But there's (conditionally) more!

Because ActiveModel callbacks are just so damn delightful, I've added some fun conditional sugar to match their wonderful. So g'head and add some `:if` conditions to your callbacks:

```ruby
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

```ruby
class User
  before :love_on_the_rocks, :add_ice, :unless => :not_in_tys_mazada?

  def not_in_tys_mazada?
    !((mazda = User.find_by_slug("ty").car) && mazda.has_rad_bass?)
  end

  protected
  def add_ice
    Ice.create!
  end
end
```

And to recap! Just as  with the believing-in-things-called-love example, both could be re-written as

```ruby
before_love_on_the_rocks :add_ice, :if => :no_ice?
```

and

```ruby
before_love_on_the_rocks :add_ice, :unless => :not_in_tys_mazda?
```

respectively.

HAPPY **CALLING-OF-THE-BACK**, FRIENDS!


Copyright © 2012 Delightful Widgets Inc. No warranty so don't sue me or my company THANKS!