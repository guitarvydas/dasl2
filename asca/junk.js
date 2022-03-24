var s = `a b 
c`;

console.log (encodeURIComponent (s));

```
function f (x) {
  var y;
  y = x;
}
```

might be filtered into:

```
function ⟪1,language/JS,0,"f"⟫ {
  ⟪1,temp,0,"y"⟫ = ⟪1,parameter,0,"x"⟫
}
```
