# poo

### keywords

```txt
as
break
catch
continue
do
for
if
or
pnt
prop (fn val obj def)
ref
return
switch
until
use
while
```

#### statement introducers

```txt
break
continue
do
for
if
pnt
prop
ref
return
switch
until
use
while
```

### puncts

```txt
()[]{}.:';
```

### operators

#### unary + postfix

```txt
! !! ? ?? ?!
```

#### binary

```txt
+ - * / = > < >= =<
++ --
+= -= *= ~= #=
|> ??> ?!>
   ??= ?!=
```

### expressions

```ebnf
gruppe       = ( )
optional     = [ ]
beliebig oft = { }
```

```ebnf


keyword
keyword-decl-intro ::= break | continue | do | for| if | pnt | prop | ref | return | switch | until | use | while

expr-fn-call-      ::= identifier ["("] fn-call-args [")"]
expr-fn-call-naked ::= identifier expr

expr-id         ::=  string
expr-id-const   ::= #string
expr-id-label   ::= $string
expr-id-pointer ::= &string
expr-id-ref     ::= @string

expr-lit            ::= expr-lit-str
expr-lit-str
expr-lit-str-single ::= 'string'
expr-lit-str-double ::= "string"
expr-lit-str-back   ::= `string`

op               ::= op-binary | op-unary
op-binary        ::= op-binary-assign | op-binary-decl | op-binary-pipe
op-binary-assign ::= "=" | "#=" | "+=" | "-=" | "*=" | "??=" | "?!="
op-binary-decl  ::= "=" | "#="
op-binary-pipe  ::= "|>" | "??>" | "?!>"
op-unary        ::= op-unary-prefix
op-unary-prefix ::= "?" | "??" | "!" | "!!" | "?!"

id ::= 

statement-decl-intro ::= ( keyword-decl-intro expr-id op-binary-decl )
```



grammatik  = { regel }
regel      = regel_name "::=" | "=" abfolge
abfolge    = { variante }
variante   = wort { "|" wort } 
wort       = ( "[" abfolge "]" )
           | ( "{" abfolge "}" )
           | ( "(" abfolge ")" )
           | "wort" | "regel_name"

wort ... ] bedeutet, dass ein wort (oder mehrere) optional vorkommen kann.
{ wort ... } bedeutet, dass ein wort (oder mehrere) beliebig oft vorkommen kann (inkl. keinmal)
wort1 | wort2 bedeutet, dass eine von zwei Varianten, d.h. wort1 oder wort2, vorkommen kann.
Zur Gruppierung von Worten benutzt man runde Klammern: ( wort1 wort2 ... )


