String formattedText(String? text) {
  const maxLength = 20;
  const dots = "..";
  if (text != null) {
    if (text.length > maxLength) {
      return "${text.substring(0, maxLength - dots.length)}$dots";
    }
    return text;
  }
  return "<None>";
}
