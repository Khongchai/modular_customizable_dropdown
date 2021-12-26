Move to from top when about to overflow.

Check if dropdown values can still update when values are given later.

Check if with the custom on tap event, everything is still working as expected.

On dropdown visible listener

Add a title to each of the input to annotate whether they are tap-based or focus based

Problem:
Possible solutions: 
    add a listener whose value gets updated everytime the dropdown is built and then use its value
widget retains reference to old widget state

    Same as above, but use a listenerbuilder, or whatever it's called to rebuild the object after the value has been updated.

Dropdown should wrap around not when maxheight exceeds screen hegiht, but when the height of the dropdown itself does

basically just calculate if offscreen in the child widget itself.
https://coderedirect.com/questions/608320/how-to-know-the-size-of-a-widget-before-painting-it

