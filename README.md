# Big Spoon
Like the big spoon, **Big Spoon** wraps around your own methods.
It adds before and after callbacks to ANY method in any Ruby class.
Basically, now you can hook into **any** Ruby method without fear of reprisals.

There were those who wanted to call it "sandwich," but they were killed.

## Usage

Use **Big Spoon** like you would any other callback method! There's, like, at
least three ways to use it. The safest is block form:

```
class User
  hook do
    before :get_your_hands_off_of_my_woman, :listen_to_the_darkness
  end

  def get_your_hands_off_of_my_woman
    puts "Get your hands off of my woman, motherf*cker!"
  end

  protected
  def listen_to_the_darkness
    `osascript "tell iTunes to play some awesome"`
  end
end
```

This is designed not to conflict with Rails callbacks and their siblings. **But if'n
you're a real scofflaw (_and you f*cking should be!_), you can just do it normal-like:**

```
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

So. Add hooks. To any Ruby method. That's pretty damn awesome, where I come from. But, as they say, "love is only a feeling." So spoon like there's no tomorrow.


Copyright © 2012 Delightful Widgets Inc. No warranty so don't sue me or my company THANKS!