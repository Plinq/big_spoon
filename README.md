# Big Spoon
Like the big spoon, **Big Spoon** wraps around your own methods.
It adds before and after callbacks to ANY method in any Ruby class.

There were those who wanted to call it "sandwich," but they were killed.

**Big Spoon** adds _hooks_ around ANY method. It can do this before
or after the methods are defined, making it awesome for fun stuff like adding extra hooks around events at the top of
a class definition without having to worry about when the method gets defined.

I think I'm going to import it into all of my libraries to avoid alias\_method_chaining anything ever again.

Anyway, here's how it works for now, DON'T use it cause I haven't tested it with shit:

## Usage

Let's say, for example, you want to reset an instance variable in a model when it gets reloaded.

For shits and giggles and real-world-clarity, I'll use an ActiveRecord model but this could be
anything that knows about `reload`.

```
class User < ActiveRecord::Base
  def name
    @name ||= "#{first_name} #{last_name}"
  end
end
```

So now, when you do something like this:

```
user = User.new(:first_name => "Flip", :last_name => "Sasser")
user.name #=> "Flip Sasser"
user.first_name = "Elizabeth"
user.name #=> "Flip Sasser"
# OH NOE MY INSTANCE VARIABLE GOT CACHED LIKE IT SHOULD
user.reload.name #=> "Flip Sasser"
# OH NOE RELOAD DOESN'T RESET INSTANCE VARIABLES
```

But what if you could hook into `ActiveRecord::Base#reload`?

```
class User < ActiveRecord::Base
  hooks do
    before_reload { @name = nil }
  end

  def name
    @name ||= "#{first_name} #{last_name}"
  end
end
```

Now you can reset the instance variable. Neat, right? Obviously this is way more awesome way more places but that's the long and short of it.

Copyright © 2012 Delightful Widgets Inc. No warranty so don't sue me or my company THANKS!