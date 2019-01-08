# Demand (Ruby Gem)

**Adds a top level `demand(variable)` method to return a variable if it's present** and optionally of the right type. Otherwise, a default or nil is returned.

**`demand()` replaces long lines of repetitive code** to check for `nil?`/`present?`/`empty?`, etc., hard-to-read ternary operators (`?:`) and chunky `if` statements. Instead you can make a simple method call.

So, instead of:

```ruby
a = (x.is_a?(Array) && !x.empty?) ? x : [0]
```

You can:

```ruby
a = demand(x, [0], Array)
```

And instead of:

```ruby
if !x.nil? && !x.empty?
    a = x
end
```

You can:

```ruby
demand(x) {|x| a = x}
```

## Explanation

Think of this as "demanding" the variable. Because you have demanded so forcefully you are guaranteed to get what you want.

## Usage

```ruby
require 'demand'
```

### If variable present, return it

```ruby
x = false
y = '   '

demand(x) #=> false (that is, x)
demand(y) #=> nil
demand(y, 'Not present') #=> 'Not present'
```

By *present* here we mean that:

* The variable is not equal to `nil`
* If it is an Array or Hash, it isn't empty
* If it is a String, it isn't empty or just whitespace

(This uses the Facets gem's `blank?` method, but overrides it evaluating `false` as blank.)

If you actually want your variable to be `nil` (i.e. you want the default value when the variable is *not* nil), specify the class you're looking for as `NilClass`):

```ruby
expected_to_be_nil = nil
demand(expected_to_be_nil, 'Not nil') #=> 'Not nil'
demand(expected_to_be_nil, 'Not nil', NilClass) #=> nil (that is, expected_to_be_nil)
```

If you want an Array or Hash and don't mind if an empty one is passed, just specify an empty Array or Hash as the default value.

### If variable present and of type, return it

If you specify a Class or Module in the third parameter, the variable must be of this Class or include this Module.

```ruby
x = 'Hello world'
y = false

demand(x, 'Not a String', String) #=> 'Hello world' (that is, x)
demand(y, 'Not a String', String) #=> 'Not a String'
demand(y, nil, Boolean) #=> false (that is, y)
```

The type `Boolean` is also made available when using this gem (via the Boolean gem). This has the effect that `true` and `false` include `Boolean`, so we can check if something `is_a?(Boolean)` which will pass just for `true` and `false` values.

### If variable, yield and run block

If a block is specified, this will run only if the variable passes all the conditions. The variable is yielded to the block and also still returned by the method.

```ruby
x = 5

demand(x, nil, Integer) {|x| puts x * 2 } #=> returns: 5; puts: 10
demand(x, nil, String) {|x| puts 'Hello' } #=> nil; puts is not run
```
