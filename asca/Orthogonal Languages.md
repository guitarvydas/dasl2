## Orthogonal Programming Languages
## Synopsis
Our current programming language syntaxes avoid certain concepts, concentrating only on describing data and very simple, synchronous control flow.

We currently invent only textual syntaxes for programming languages.

With PEG parsing, backtracking and newer hardware, we can do better.

We can build programming tools using a wide variety of representations.

## Categories of Programming Language Elements
Items and syntax in programming languages fall into two (2) broad categories
1. data
2. control flow

Traditionally, (1) has been solved using *identifiers* and a wad of ad-hoc logic that decides where the data is allocated.

Traditionally, (2) has been sugared with syntax, e.g. *for loops*.

## Compilation, Transpilation, Interpreters
Programming language translators - compilers, interpreters, transpilers - convert data data allocation syntax and control flow syntax into code that can be executed.

Traditionally, compilers are built as big, mostly ad-hoc, applications that perform the conversion and deal with overloaded syntax that combines data syntax and control flow syntax.

Ideally, we would prefer to build compilers in pieces and pipeline the pieces together.

## External Languages - Wrappers

We want to add a 3rd kind of entity - the wrapper.

A wrapper allows *anything* inside of it and is unscathed by a given compiler pass.

PEG parsing technology allows us to create syntax for these kinds of wrappers.  

We can choose any bracketing "characters" to wrap the external code, even if the external code contains the same characters.  PEG can parse "balanced parentheses".

I suggest using the unicode characters  `⎨`  and `⎬`  for starters (%E2%8e%A8 and %E2%8E%AC, resp.).  

The choice is arbitrary.

Unicode allows us to use many characters.

ASCII gives a more limited choice - 0-127.  Becase of this, we have grown accustomed to languages that overload syntax.

## Wrapping Strings - The Escape Problem

Traditionally, every language defines its own syntax for the contents of strings, including epicycles for escaping special characters.

Browser technology solved the same problem by encoding strings, using functions like JavaScript's `encodeURIComponent ()`.

We can use the same trick to encode strings without having to worry, further, about character-escape nuance.

Again, PEG can match balanced patterns, e.g. `" ... "`.  Mixed with uriEncoding schemes, we can stick just about anything inside of strings.

### Example Encoding
```
var s = `a b 
c`;

console.log (encodeURIComponent (s));
```
prints the string `s` as:
```a%20b%20%0Ac```

## Orthogonal Transpilation
Given a syntax for wrapping code (and wrapping strings), we can build compilers / transpilers as pipelines of components, each component doing a little bit of work before passing the modified stream further along in the pipeline.

### Example Transpiler Component
For example, the JS code:

```
function f (x) {
  var y;
  y = x;
}
```

might be filtered into:

```
function ⟪1,languageFunctionJS,0,"f"⟫ {
  ⟪1,temp,0,"y"⟫ = ⟪1,parameter,0,"x"⟫
}
```
where I've arbitrarily chosen to bracket data descriptors with `⟪` and `⟫`.

In the above example, I used the base name "languageFunctionJS" to mean the name of a base which will be resolved later[^fjs].  

[^fjs]: In this case, I intend for the function "f" to be a JS function name.

The base name "languageFunctionJS" - I just invented it - is arbitrary as long as the downstream pass(es) agree on what to do with it.

In fact, language-specific base names will be deprecated in the future and I'm using them only as a bridge between what we've got now and this proposed pipeline compiling strategies.

## What Else Is There?

Our current programming language syntaxes avoid certain concepts, concentrating only on describing data and very simple, synchronous control flow.

We currently invent only textual syntaxes for programming languages.

With PEG parsing, backtracking and newer hardware, we can do better.

For example, we might devise a diagrammatic language for the description of networked computers.  The obvious use for this kind of language would be to describe systems of internet-connected clients and servers, or, blockchain.

I believe that robotics and IoT are struggling with the current form of synchronous languages, and might benefit from a language like the above, i.e. a language for describing networks of distributed Components-in-the-small.

## New Assembler
- create operations, don't check operands (checking done by upstream pipeline, validity checking)
- use PEG to lay syntactic skin over operations

old-style assembler = machine-readable syntax (triples), no type checking
mid-style assembler = machine-readable syntax (PEG), no type checking
new-style assembler = machine-readable syntax (OCG), no type checking

## Readability
There are two (2) kinds of readability
1. Human readability, language designed as UX for human programmers
2. Machine readability, language designed with normalization in mind, data normalized, control-flow normalized, easy to automate

## Type Checking
### Syntax Checking
Traditionally, simple checking is done by the parser - 
- syntax checking
- declaration before use (to avoid typos)
### Type Checking Preprocessor
Type Checking is "just another" kind of checking for programmer mistakes.

Type Checking is more involved than syntax checking, but, syntax checking used to be "difficult", then became common-place.

To do type-checking as a form of validity checking, we need:
- a simple, machine-readable syntax to peel off type definition info
- a simple, machine-readable syntax to annotate every "variable" with a reference to type info
- e.g. the Haskell programming language already differentiates between type *definition* and type *use* (reference)
	- we want a special syntax for type definition
	- we want a special syntax for type use
## Lisp Macros
Note that Lisp Macros are of the form of New Assembler, where *all* syntax looks like function calls.

Lisp syntax is very regular: 
1. operator
2. operands.

E.g. `b + c` is written in Lisp as `(+ b c)`
E.g. `a = b + c` is written in Lisp as `(setf a (+ b c))`

Lisp Macro syntax and PEG syntax are macros.

Lisp Macro syntax only works on Lisp lists `( ... )`.

PEG Macro syntax works with characters and allows infix, among other syntactic variations, e.g. infix notation can be parsed to prefix-syntax, `b + c` -> `(+ b c)`

Furthermore, PEG allows matching of *structured* text (unlike REGEX)[^sm].

[^sm]: This is because PEG allows using rules as subroutines.  Subroutines can be called and can be called recursively.