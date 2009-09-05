Stackd Programming Language Guide
==========

1. Defining Words
----------

To define a new word (similar to functions or procedures in applicative languages),
there are different ways to do so.
For normal words (not generic method implementations), use the colon syntax:

	: <wordname> <stackeffect>
		<body> ;

The stackeffect declaration has no implications on the actual usage of the word. It
is simply used for documentation - and in case of generic words, to find the apropriate
generic method implementation.

A short example is the `sq` word, which squares a number:

	: sq ( x -- x*x )
		  dup * ;

Here, `sq` takes one argument from the data stack (called `x` in the stackeffect declaration),
`dup`licates it, meaning, that the value is twice on the stack, and multiplies them (`*`), putting
the square back onto the stack.
Here's a simple diagramm to illustrate this process when calling `sq`. Everything within brackets resembles the values
on the stack with the most right value being the top of stack element:

Example call: `5 sq ;`

       Literal/Word    Stackvalues     Comment
       ---------------------------------------------------
       5               [ 5 ]           (before calling sq)
       dup             [ 5 5 ]         (in sq)
       *               [ 25 ]          (in sq)

For more examples take a look at the code within the files in the core/ or examples/ directories.


2. Defining Tuples
----------

With Tuples one can define custom data types and operations on them (via generic words). They contain
so called slots, which are data fields. In contrast to most object-oriented programming languages,
the operations on these datatypes are not part of the type definition, but kept indepedently (as, for
example generic methods in CLOS - the Common Lisp Object System, are).

Syntax:
	tuple: <tuplename> <slotnames> ;

Example:
	tuple: person name age sex ;

To create a new instance of a tuple:
	person new ;

Which will create a new instance of the `person` tuple, with all the slots undefined.
A common idiom is to define a custom constructor word for a tuple, that can take some arguments
to initialize the slots, if needed. By convention, these constructor words are named like the
tuple, surrounded by `<` and `>`, e.g.: `<person>`.

When not differently stated, accessor words (getters and setters) for all slots will be defined.
Getter accessors have the following naming scheme:
       slotname>>
Whereas setter accessors are named like this:
	>>slotname

For our `person` tuple, the following accessors will be defined automatically by the Stackd runtime:
    : name>> ( person -- name ) ;
    : >>name ( person name -- person ) ;
    : age>> ( person -- age ) ;
    : >>age ( person age -- person ) ;
    : sex>> ( person -- sex ) ;
    : >>sex ( person sex -- person ) ;

Note, that all setters keep the person instance on the stack, when finished, whereas getter accessors
don't. This is meant to make instance initialization easier and makes more sense, since you usually
want to keep on doing something with the tuple instance, after altering a slot value.

Here's a complete overview of our `person` tuple example:

	tuple: person name age sex ;

	: <person> ( -- person )
		person new ;

	! example word with using a person instance:
	: say-hello ( person -- )
	      "hello, " print-
	      name>> print-
	      ", how are you today?" print ;

	! example usage:
	! this will create a new instance of person,
	! and call say-hello, which will then output:
	! "hello, Christopher Bertels, how are you today?"
	<person>
		>>name "Christopher Bertels"
		>>age 22
		>>sex "male"
		say-hello ;

# _more coming soon_ #
