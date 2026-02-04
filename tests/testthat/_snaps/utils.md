# Test color generator

    Code
      col2hex("not_a_color")
    Output
      [1] "not_a_color"

---

    Code
      col2hex(hex_alpha)
    Output
      [1] "#FF00008F"

# Theme type

    Code
      dark_or_light("not_a_color")
    Condition
      Error in `dark_or_light()`:
      ! Invalid color name "not_a_color".

