# Read me under construction...

# Modular and Customizable Dropdown

A modular dropdown package that is compatible with any widget.

## Instruction

Create the dropdown widget and pass it whatever widget you want the dropdown to attach to as its target. 
By default, the dropdown will appear directly below the target widget's position. 
This can be customized further with the DropdownStyle class.

_For a thorough example, see the main.dart file in the example folder or clone this repo and run the file._

## Default Behavior

1. By default, the dropdown sizes itself to its parent. If the parent is very small, the dropdown will also be very small. This can be overridden with the DropdownWidth class.

_todo => image of squeezed dropdown and normal dropdown_
   
2. By default, the dropdown is set to wrap to the opposite side of the target widget when it finds that it will overflow
the screen when expanded. 
   
_todo => short gif of dropdown when wrapping around_


## Features

1. *Use DropdownAlignment to align it however you wish.* This should cover many common use cases already. 
It's very similar to Flutter's alignment, take a look [here](https://github.com/Khongchai/modular_customizable_dropdown/blob/main/lib/classes_and_enums/dropdown_alignment.dart).
   
_Note: if your width needs to be different from the target for the horizontal alignment to take effect (duh)._

_todo => example of horizontal alignment working_

2. The most visually prominent dropdown features support LinearGradient.

3. Comes with three factory constructors, with which you will be able to trigger the dropdown when: a tap happens, the target widget is focused, or a callback is called.

4. The expand animation adjusts automatically to the provided DropdownAlignment. For example if the target is above the dropdown, the dropdown
will expand from top, and vice versa. If DropdownAlignment == DropdownAlignment.center, the dropdown will expands in both vertical direction.
   
_todo => gif of all the expansions_

5. Max Height can be described using pixels or the number of rows to be visible before scrolling.

















