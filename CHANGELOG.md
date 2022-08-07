## 1.0.0

Initial release

## 1.0.1

Better documentation + can now control the animation curve.

## 2.0.0

**Breaking Change and Deprecation**:

- allDropdownValues now accept a list of DropdownValue objects instead of a list of strings.
  
- Deprecated display on focus (might come back and take a look at this again in the future).

**New**:

- You can now specify how many rows you want the dropdown to display with a decimal value using the same
  byRows property of the DropdownMaxHeight class. For example, byRows: 3.5 means 4 rows with the fourth one
  having only half its height.
  
- Now the dropdown will never overflow the top and the bottom section of the screen. Its top and bottom 
  are clamped to be between 0 and screen height.
  
- Now, with the new DropdownValue class, we can also pass in a description and metadata. The metadata 
  property is basically whatever  value you want the dropdown to pass back with everything else in 
  the callback.
  

**Fixed Bugs**:

- When barrierDismissible is false and ReactMode is CallbackReact, if you call the dropdown toggle 
  callback repeatedly, it'll just keep spawning new dropdowns (not dismissing the previous one).
  With this new version, if you call the callback more than once, each time passing in true, nothing
  will happen as we limit the number of dropdown present on screen to 1 per target.
  
- byRows property from the DropdownMaxHeight class didn't really work as expected for long texts as 
  the previous calculation did not take into account the height of each individual row. 
  The calculation assumed that each row will have always have the same height.
  
- If the length of the dropdown was 0, the framework would throw an error. Now, a warning will be 
  printed out and nothing else will happen.
  



