## Operators

- create temp & set temp from Args `name ⤶ name`
- set own from constant `answer ⇐ No`
- inject from temp `Inject 〔scroll through atoms〕«name» name`
- set own from message data `found ⇐ ?data`
- Conclude
- Return own variables `Return found answer`
- child self/external-function `〔self〕 λlookup`
- child component `〔scroll through atoms〕 〔scroll through atoms〕`
- Self connection sender->net->receiver `〔self〕«name» ⇒₁  〔scroll through atoms〕«name»`
- child connection sender->net->receiver `〔 ... 〕«name» ⇒₁  〔scroll through atoms〕«name»`
- child connection to self `〔 ... 〕«name» ⇒₁  〔self〕«name»`
- call predicate of temp `atom-memory.eof? ()`
- send constant `Send «EOF» No`  ; `Yes` | `No` |  `Trigger` | `None`
- conditional `[ | Yes : <statement> ... ]`
- set temp from Args lookup (same as Create and Set Temp from Args, above)
- call external predicate `@⟨match string⟩()`
- compound id `⟨match string⟩`
- send message data `Send «answer» ?data`

## Operator Syntax Patterns

Using Ohm-JS:

```
Operation
 = ident "⤶" ident                                 -- CreateAndSetTempFromArgs
 | ident "⇐ Constant                                -- SetOwnFromConstant
 | "Inject" ComponentName PortName ident            -- InjectFromTemp
 | ident "⇐" "?data"`                               -- SetOwnFromMessageData
 | "Conclude"                                       -- Conclude
 | "Return" ident+                                  -- ReturnOwnVariables
 | "〔self〕" PortName NetName ComponentName PortName -- SelfConnection
 | ComponentName PortName NetName ComponentName PortName -- ChildConnection
 | ComponentName PortName NetName "〔self〕" PortName -- ChildToSelfConnection
 | ident "." ident "(" ")"                          -- CallPredicateOfTempWithNoArgs
 | "Send" PortName Constant                         -- SendConstant
 | "[" CondClause+ "]"                              -- Conditional
 | "@" ident "(" ")"                                -- CallExternalPredicateNoArgs
 | "Send" PortName "?data"                          -- SendMessageData
 
ChildSelfExternalFunction = "〔self〕" "λ" ident
ChildComponent = ComponentName ComponentName



Handler = Operation? "[" HandlerClause+ "]" Operation?


CondClause = "|" Constant ":" Operation
HandlerClause = "•" PortName ":" Operation
Constant = "Yes" | "No" | "Trigger" | "None"
ident = CompoundID | SingleID
CompountID = "⟨" SingleID+ "⟩""

```


  
