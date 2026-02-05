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

# Pretty match

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

---

    Code
      my_fun3("3")
    Condition
      Error:
      ! `an_arg` should be one of "30" or "20", not "3".
      i Did you mean "30"?

---

    Code
      my_fun2(c(1, 2))
    Condition
      Error:
      ! `year` should be "20", not "1" or "2".

