///Choose which mode the dropdown should react to.
///
/// For most widgets, it's the tap mode, while for some, like the text widget, the dropdown should react to the focus event.
enum ReactMode {
  ///React to tap
  tapReact,

  ///React to tap and focus
  @Deprecated("Might come back to this later, but deprecated for now")
  focusReact,

  ///React to callback obtained through targetBuilder
  callbackReact,
}
