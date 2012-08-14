# CHANGELOG
## 0.2.0
### Multiple bugs fixed and test for decent backtraces
- before and after filters no longer assume argument-less-methods
- `before` and `after` are now in method_missing so they won't
  conflict with other libraries

## 0.1.1
### :if, :unless, and tested in production!
- :if => :method and :unless => lambda { false } are now supported.
- That, or any variation of those two you can imagine.

## 0.0.1
### Basic functionality
- Hooks / callbacks are working BEFORE OR AFTER a method gets defined
- No :if or :unless options
