# brightness separates light, dark and invalid colors

    Code
      dark_or_light("not_a_color")
    Condition
      Error in `dark_or_light()`:
      ! Color "not_a_color" is not valid.

# invalid argument choices produce contextual errors and hints

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

# valid argument choices resolve exact and default matches

    Code
      my_fun2("3")
    Condition
      Error:
      ! `an_arg` should be one of "30" or "20", not "3".
      i Did you mean "30"?

# RStudio-only actions explain why other sessions are rejected

    Code
      s <- require_rstudio("test")
    Message
      x `rstudiothemes::test()` can only run in RStudio, not in "RTerm".
      i No changes made.

# missing local theme files produce a contextual error

    Code
      local_theme_file("missing.json", "json")
    Condition
      Error in `local_theme_file()`:
      ! File 'missing.json' was not found.

