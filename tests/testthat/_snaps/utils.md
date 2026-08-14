# col2hex() normalizes color names, hex values and alpha channels

    Code
      col2hex("not_a_color")
    Output
      [1] "not_a_color"

---

    Code
      col2hex(hex_alpha)
    Output
      [1] "#FF00008F"

# dark_or_light() classifies colors by brightness

    Code
      dark_or_light("not_a_color")
    Condition
      Error in `dark_or_light()`:
      ! Color "not_a_color" is not valid.

# match_arg_pretty() reports invalid choices with helpful errors

    Code
      my_fun("error here")
    Condition
      Error:
      ! `arg_one` should be one of "10", "1000", "3000" or "5000", not "error here".

---

    Code
      my_fun(c("an", "error"))
    Condition
      Error:
      ! `arg_one` should be one of "10", "1000", "3000" or "5000", not "an" or "error".

---

    Code
      my_fun("5")
    Condition
      Error:
      ! `arg_one` should be one of "10", "1000", "3000" or "5000", not "5".
      i Did you mean "5000"?

---

    Code
      my_fun("00")
    Condition
      Error:
      ! `arg_one` should be one of "10", "1000", "3000" or "5000", not "00".

---

    Code
      my_fun2(c(1, 2))
    Condition
      Error:
      ! `year` should be "20", not "1" or "2".

# match_arg_pretty() returns exact, default and custom matches

    Code
      my_fun2("3")
    Condition
      Error:
      ! `an_arg` should be one of "30" or "20", not "3".
      i Did you mean "30"?

# require_rstudio() reports non-RStudio sessions

    Code
      s <- require_rstudio("test")
    Message
      x `rstudiothemes::test()` can only run in RStudio, not in "RTerm".
      i No changes made.

# local_theme_file() resolves local paths and downloads URLs

    Code
      local_theme_file("missing.json", "json")
    Condition
      Error in `local_theme_file()`:
      ! File 'missing.json' was not found.

