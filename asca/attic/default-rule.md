```
basictoken {
Item = any
}

linenumbers <: basictoken {
  Main = Item+
}
```

The above "linenumbers" grammar fails to parse input "ab".
