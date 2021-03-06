# Demand (Ruby Gem)

**Return a variable if it's present** (and optionally of the right type), otherwise, a default or nil. Adds a top level `demand()` method, which replaces long lines of repetitive code to check for `nil?`/`present?`/`empty?`, etc., hard-to-read ternary operators (`?:`) and chunky `if` statements. Instead you can make a simple method call:

| So, you can...              | ...instead of stuff like                       |
| --------------------------- | ---------------------------------------------- |
| `demand(x)`                 | `(x.present? ? x : nil)`                       |
| `demand(x, y)`              | `(x.present? ? x : y)`                         |
| `a = demand(x, [0], Array)` | `a = (x.is_a?(Array) && !x.empty?) ? x : [0]`  |
| `demand(x) {\|x\| a = x}`   | `a = x if !x.nil? && x.strip.length > 0`       |

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

* The variable is not equal to `nil` nor responds truthfully to `nil?`
* If it is an Array or Hash, it isn't empty; nor does it respond truthfully to `empty?`
* If it is a String, it isn't empty or just whitespace, i.e. if it is `.strip`ed, it won't just be empty

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

demand(x, 'Not the right type', String) #=> 'Hello world' (that is, x)
demand(y, 'Not the right type', String) #=> 'Not the right type'
demand(y, 'Not the right type', Boolean) #=> false (that is, y)
```

The type `Boolean` is also made available when using this gem (via the [Boolean](https://github.com/RISCfuture/boolean) gem). This has the effect that `true` and `false` include `Boolean`, so we can check if something `is_a?(Boolean)` which will pass just for `true` and `false` values.

### If variable present, yield it to a block

If a block is specified, this will run only if the variable passes all the conditions. The variable is yielded to the block and also still returned by the method.

```ruby
x = 5

demand(x, nil, Integer) {|x| puts x * 2 } #=> returns: 5; puts: 10
demand(x, nil, String) {|x| puts 'Hello' } #=> returns nil; puts is not run
```

## Options

Not really recommended, but you can adjust how the `demand()` method works by setting `Demand::OPTIONS[:yield_default] = true` and `Demand::OPTIONS[:return_yield] = true`.

| Option         | Default | Explanation |
| -------------- | ------- | ----------- |
| :yield_default | `false` | If `true`, a passed block will still run if the presence check on your variable fails. The default value will be yielded to the block instead. |
| :return_yield  | `false` | If `true`, the return value of the passed block (if run) will be the return value for the main method itself. |

Once set, these switches change how all further calls to `demand()` behave. The switches are included for flexibility to developer preferences, but use with caution: things could get confusing quickly. Probably if you feel like you need these, `demand()` may not be the right tool.
