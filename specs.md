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


keyword
keyword-decl-intro ::= break | continue | do | for| if | pnt | prop | ref | return | switch | until | use | while

expr-fn-call-      ::= identifier ["("] fn-call-args [")"]
expr-fn-call-naked ::= identifier expr

expr-id         ::=  string
expr-id-const   ::= #string
expr-id-label   ::= $string
expr-id-pointer ::= &string
expr-id-ref     ::= @string

expr-lit-str
expr-lit-str-single ::= 'string'
expr-lit-str-double ::= "string"
expr-lit-str-back   ::= `string`

operator-binary       ::= + | -
operator-unary        ::=
operator-unary-prefix ::= ? | ?? | ! | !! | ?!
```



