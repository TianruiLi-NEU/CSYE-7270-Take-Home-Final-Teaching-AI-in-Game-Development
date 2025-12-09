(local Stack {})
(set Stack.__index Stack)
(set Stack.__type "Stack")
(fn Stack.new []
  (local self {})
  (setmetatable self Stack)
  self)
(fn Stack.push [self x]
  (table.insert self x))
(fn Stack.peek [self]
  (. self (length self)))
(fn Stack.pop [self]
  (table.remove self))
Stack
