let UnitTest = require("unit-test")
let Math = require("math")

let TestCase = UnitTest("Charly")
let testResult = TestCase.begin(func(describe) {

  describe("Including external files", func(it) {

    it("requires a file", func(assert) {
      assert(require("./external.ch").num, 25)
      assert(require("./external.ch").num, 25)

      let external = require("./external.ch")
      external.num = 50

      assert(require("./external.ch").num, 50)

      # Reset for further tests
      external.num = 25
    })

    it("includes a file that's already required", func(assert) {
      let external = require("./external.ch")
      external.num = 50

      assert(require("./external.ch") == external, true)
      assert(require("./external.ch").num, 50)

      # Reset for further tests
      external.num = 25
    })

  })

  describe("Variables", func(it) {

    it("assigns a value to a variable", func(assert) {
      let my_string = "Hello World"
      let my_number = 25
      let my_bool = false
      let my_array = [1, "Whatsup", false]
      let my_null = null

      assert(my_string, "Hello World")
      assert(my_number, 25)
      assert(my_bool, false)
      assert(my_array[1], "Whatsup")
      assert(my_null, null)
    })

    it("resolves variables in calculations", func(assert) {
      let first_number = 25
      let second_number = 5

      assert(first_number + second_number, 30)
    })

    it("primitives are always passed by value", func(assert) {
      let a = 5
      let b = a
      a = 30

      assert(a, 30)
      assert(b, 5)
    })

    it("creates constants", func(assert) {
      const name = "charly"
      const age = 16
      const weather = "sunny"

      assert(name, "charly")
      assert(age, 16)
      assert(weather, "sunny")
    })

  })

  describe("Arithmetic operations", func(it) {

    it("adds numbers", func(assert) {
      assert(2 + 2, 4)
      assert(10 + -50, -40)
      assert(2.5 + 9.7, 12.2)
      assert(-20.5 + 20.5, 0)
      assert(999.999 + 999.999, 1999.998)
    })

    it("subtracts numbers", func(assert) {
      assert(20 - 5, 15)
      assert(3 - 3, 0)
      assert(-5 - 9, -14)
      assert(-0 - -0, 0)
      assert(-20 - -90, 70)
    })

    it("multiplies numbers", func(assert) {
      assert(2 * 0, 0)
      assert(2 * 5, 10)
      assert(3 * 25, 75)
      assert(9 * -50, -450)
      assert(0.5 * 5, 2.5)
    })

    it("divides numbers", func(assert) {
      assert(5 / 0, NAN)
      assert(5 / -2, -2.5)
      assert(10 / 4, 2.5)
      assert(100 / 8, 12.5)
      assert(1 / 2, 0.5)
    })

    it("modulus operator", func(assert) {
      assert(6 % 3, 0)
      assert(0 % 0, NAN)
      assert(177 % 34, 7)
      assert(700 % 200, 100)
      assert(20 % 3, 2)
    })

    it("pow operator", func(assert) {
      assert(2**8, 256)
      assert(50**3, 125000)
      assert(2**4, 16)
      assert(50**1, 50)
      assert(50**0, 1)
    })

    it("does AND assignments", func(assert) {
      let a = 20

      a += 1
      assert(a, 21)

      a -= 1
      assert(a, 20)

      a *= 20
      assert(a, 400)

      a /= 20
      assert(a, 20)

      a %= 6
      assert(a, 2)

      a **= 3
      assert(a, 8)
    })

  })

  describe("Comparisons", func(it) {

    it("compares numerics", func(assert) {
      assert(2 == 2, true)
      assert(20 == 20, true)
      assert(-200 == -200, true)
      assert(2.2323 == 2.2323, true)
      assert(9.666 == 9.666, true)
      assert(-0 == -0, true)
      assert(-0 == 0, true)
    })

    it("compares booleans", func(assert) {
      assert(false == false, true)
      assert(false == true, false)
      assert(true == false, false)
      assert(true == true, true)

      assert(0 == false, false)
      assert(1 == true, true)
      assert(-1 == true, true)
      assert("" == true, true)
      assert("test" == true, true)
      assert([] == true, true)
      assert([1, 2] == true, true)
      assert(null == false, true)
      assert({ let name = "charly" } == true, true)
      assert(func() {} == true, true)
      assert(class Test {} == true, true)
    })

    it("compares strings", func(assert) {
      assert("test" == "test", true)
      assert("" == "", true)
      assert("leeöäüp" == "leeöäüp", true)
      assert("2002" == "2002", true)
      assert("asdlkasd" == "asdlkasd", true)
    })

    it("compares objects", func(assert) {
      assert({} == {}, false)
      assert({ let a = 1 } == {}, false)
      assert({} == { let a = 1 }, false)
      assert({ let a = 1 } == { let a = 1 }, false)

      let me = {
        let name = "charly"
      }

      assert(me == me, true)
      assert(me.name == me.name, true)
    })

    it("compares functions", func(assert) {
      assert(func() {} == func() {}, false)
      assert(func(arg) {} == func(arg) {}, false)
      assert(func(arg) { arg + 1 } == func(arg) { arg + 1 }, false)
      assert(func() { 2 } == func(){ 2 }, false)
    })

    it("compares arrays", func(assert) {
      assert([1, 2, 3] == [1, 2, 3], true)
      assert([] == [], true)
      assert([false] == [false], true)
      assert([[1, 2], "test"] == [[1, 2], "test"], true)

      assert([1] == [1, 2], false)
      assert(["", "a"] == ["a"], false)
      assert([1, 2, 3] == [1, [2], 3], false)
      assert([""] == [""], true)
    })

    it("does misc. comparisons", func(assert) {
      assert(null == null, true)
      assert(null ! null, false)
    })

    it("compares non equals", func(assert) {
      assert(2 == 4, false)
      assert(10 == 20, false)
      assert(2.5 == 2.499999, false)
      assert(-20 == 20, false)
      assert(2 == 20, false)

      assert(2 ! 4, true)
      assert(10 ! 20, true)
      assert(2.5 ! 2.499999, true)
      assert(-20 ! 20, true)
      assert(2 ! 20, true)
    })

    it("compares using >", func(assert) {
      assert(2 > 5, false)
      assert(10 > 10, false)
      assert(20 > -20, true)
      assert(4 > 3, true)
      assert(0 > -1, true)

      assert("test" > "test", false)
      assert("whatsup" > "whatsu", true)
      assert("test" > 2, false)
      assert("test" > "tes", true)
      assert(2 > "asdadasd", false)
      assert("" > "", false)
      assert(false > true, false)
      assert(25000 > false, false)
      assert(000.222 > "000.222", false)
      assert(null > "lol", false)
    })

    it("compares using <", func(assert) {
      assert(2 < 5, true)
      assert(10 < 10, false)
      assert(20 < -20, false)
      assert(4 < 3, false)
      assert(0 < -1, false)

      assert("test" < "test", false)
      assert("whatsup" < "whatsu", false)
      assert("test" < 2, false)
      assert("test" < "tes", false)
      assert(2 < "asdadasd", false)
      assert("" < "", false)
      assert(false < true, false)
      assert(25000 < false, false)
      assert(000.222 < "000.222", false)
      assert(null < "lol", false)
    })

    it("compares using >=", func(assert) {
      assert(5 >= 2, true)
      assert(10 >= 10, true)
      assert(20 >= 20, true)
      assert(4 >= 3, true)
      assert(0 >= -1, true)

      assert("test" >= "test", true)
      assert("whaaatsup" >= "whatsup", true)
      assert("lol" >= "lol", true)
      assert("abc" >= "def", true)
      assert("small" >= "reaaalllybiiig", false)
    })

    it("compares using <=", func(assert) {
      assert(2 <= 5, true)
      assert(10 <= 10, true)
      assert(20 <= -20, false)
      assert(4 <= 3, false)
      assert(200 <= 200, true)

      assert("test" <= "test", true)
      assert("whaaatsup" <= "whatsup", false)
      assert("lol" <= "lol", true)
      assert("abc" <= "def", true)
      assert("small" <= "reaaalllybiiig", true)
    })

    it("not operator inverts a value", func(assert) {
      assert(!false, true)
      assert(!true, false)
      assert(!0, false)
      assert(!25, false)
      assert(!"test", false)
    })

    it("does AND comparison", func(assert) {
      assert(true && true, true)
      assert(true && false, false)
      assert(false && true, false)
      assert(false && false, false)
    })

    it("does OR comparison", func(assert) {
      assert(true || true, true)
      assert(true || false, true)
      assert(false || true, true)
      assert(false || false, false)
    })

    it("does conditional assignment", func(assert) {
      let a = 25
      let b = null
      let c = false

      let d

      d = a || b
      assert(d.typeof(), "Numeric")

      d = b || c
      assert(d.typeof(), "Boolean")

      d = b || a
      assert(d.typeof(), "Numeric")

      d = c || b
      assert(d.typeof(), "Null")
    })

  })

  describe("Arrays", func(it) {

    it("does member expressions", func(assert) {
      let nums = [1, 2, 3, 4]

      assert(nums[0], 1)
      assert(nums[3], 4)
      assert(nums[10], null)
      assert(nums[-10], null)
    })

    it("does multilevel member expressions", func(assert) {
      let nums = [[1, 2], [3, 4, "test"], [5, 6]]

      assert(nums[0][1], 2)
      assert(nums[2][0], 5)
      assert(nums[1][2], "test")
      assert(nums[1][-2], null)
    })

    it("write to an index", func(assert) {
      let nums = [1, 2, 3, 4]

      nums[0] = 2
      nums[1] = 3
      nums[2] = 4

      assert(nums == [2, 3, 4, 4], true)
    })

    it("writes to a nested index", func(assert) {
      let nums = [1, 2, [3, 4]]

      nums[0] = 2
      nums[1] = 3
      nums[2][0] = 4
      nums[2][1] = 5

      assert(nums == [2, 3, [4, 5]], true)
    })

    it("gives back the length", func(assert) {
      assert([].length(), 0)
      assert([1, 2].length(), 2)
      assert([1, 2, [3, 4]].length(), 3)
      assert([1, 2, 3, [4, 5]][3].length(), 2)
      assert(["test"].length(), 1)
    })

    it("iterates via each", func(assert) {
      let got = []
      let nums = [1, 2, 3, 4]

      nums.each(func(v) {
        got.push(v)
      })

      assert(got == nums, true)
    })

    it("receives the size of the original array", func(assert) {
      let _size = 0
      let nums = [1, 2, 3, 4]

      nums.each(->(item, index, size) {
        _size = size
      })

      assert(_size, 4)
    })

    it("maps over an array", func(assert) {
      let nums = [1, 2, 3, 4]

      nums = nums.map(func(n) {
        n**2
      })

      assert(nums == [1, 4, 9, 16], true)
    })

    it("converts all items to strings", func(assert) {
      let nums = [1, 2, 3, 4]

      nums = nums.all_to_s()

      assert(nums == ["1", "2", "3", "4"], true)
    })

    it("creates a new array using Array.of_size", func(assert) {
      let new_array = Array.of_size(100, "whaaaaaaaaaaaaaaaaaat")
      assert(new_array.length(), 100)
    })

    it("appends to the end", func(assert) {
      let nums = [1, 2]

      nums.push(3)
      nums.push(4)
      nums.push(5)
      nums.push(6)

      assert(nums.length(), 6)
      assert(nums == [1, 2, 3, 4, 5, 6], true)
    })

    it("append to the beginning", func(assert) {
      let nums = [1, 2]

      nums.unshift(3)
      nums.unshift(4)
      nums.unshift(5)
      nums.unshift(6)

      assert(nums.length(), 6)
      assert(nums == [6, 5, 4, 3, 1, 2], true)
    })

    it("inserts at a given index", func(assert) {
      let nums = [1, 2]

      nums.insert(0, 3)
      nums.insert(1, 4)
      nums.insert(-200, 5)
      nums.insert(1000, 6)
      nums.insert(4, 7)

      assert(nums.length(), 7)
      assert(nums == [5, 3, 4, 1, 7, 2, 6], true)
    })

    it("deletes a given index", func(assert) {
      let nums = [1, 2, 3, 4, 5]

      nums.delete(0)
      nums.delete(3)
      nums.delete(1)

      assert(nums.length(), 2)
      assert(nums == [2, 4], true)
    })

    it("returns the first element", func(assert) {
      assert([].first(), null)
      assert([1, 2].first(), 1)
      assert([[1]].first()[0], 1)
    })

    it("returns the last element", func(assert) {
      assert([].last(), null)
      assert([1, 2, 3].last(), 3)
      assert([1].last(), 1)
      assert([[1, 2]].last()[1], 2)
    })

    it("concatenates two arrays", func(assert) {
      let num1 = [1, 2]
      let num2 = [3, 4]
      let num3 = num1 + num2

      assert(num3 == [1, 2, 3, 4], true)
    })

    it("flattens an array", func(assert) {
      let num = [1, [2, [3], 4], 5, [[6], 7], 8]

      num = num.flatten()

      assert(num.length(), 8)
      assert(num == [1, 2, 3, 4, 5, 6, 7, 8], true)
    })

    it("filters an array", func(assert) {
      let nums = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]

      nums = nums.filter(func(e, i) {
        if (e <= 5) {
          (i % 2) == 0
        } else {
          false
        }
      })

      assert(nums.length(), 3)
      assert(nums == [1, 3, 5], true)
    })

    it("reverses an array", func(assert) {
      let nums = [1, 2, 3, 4]

      nums = nums.reverse()

      assert(nums == [4, 3, 2, 1], true)
    })

    it("returns the index of an element", func(assert) {
      let nums = [1, "test", "hello", false]

      assert(nums.index_of(2), -1)
      assert(nums.index_of(1), 0)
      assert(nums.index_of("test"), 1)
      assert(nums.index_of("hellö"), -1)
      assert(nums.index_of("hello"), 2)
      assert(nums.index_of(false), 3)
      assert(nums.index_of(true), -1)
    })

    it("checks if the array is empty", func(assert) {
      assert([].empty(), true)
      assert([1].empty(), false)
      assert([1, 2].empty(), false)
      assert(["test"].empty(), false)
      assert([null].empty(), false)
    })

    it("joins an array", func(assert) {
      assert([1, 2, 3, 4].join("-"), "1-2-3-4")
      assert(["hello", "world", "whats", "up"].join("\n"), "hello\nworld\nwhats\nup")
      assert(["hello", -25.9, "test", [1, 2]].join(""), "hello-25.9test[1, 2]")
    })

    it("gives back a range from an array", func(assert) {
      assert([1, 2, 3, 4].range(0, 2), [1, 2])
      assert([1, 2, 3, 4].range(2, 4), [3, 4])
      assert([1, 2, 3, 4].range(4, 0), [1, 2, 3, 4])
      assert([1, 2, 3, 4].range(0, 0), [])
      assert([1, 2, 3, 4].range(0, 500), [1, 2, 3, 4])
      assert([].range(0, 1), [])
    })

    it("sorts numbers", func(assert) {
      const nums = [900, 20, -29, -100]
      const sorted = nums.sort(func(left, right) {
        left < right
      })

      assert(sorted, [-100, -29, 20, 900])
    })

  })

  describe("Numerics", func(it) {

    it("implicitly casts integers to floats", func(assert) {
      assert(2 == 2.0, true)
      assert(2000.0000 == 2000, true)
      assert(-289 == -289.0, true)
      assert(0 == 0.0, true)
      assert(0000000000.000000000 == 0, true)
    })

    it("calls times", func(assert) {
      let sum = 0
      500.times(func(i) {
        sum += i
      })

      assert(sum, 124750)
    })

    it("calls downto", func(assert) {
      let sum = 0
      10.downto(1, func(n) {
        sum += n
      })

      assert(sum, 54)
    })

    it("calls upto", func(assert) {
      let sum = 0
      5.upto(10, func(n) {
        sum += n
      })

      assert(sum, 35)
    })

  })

  describe("Strings", func(it) {

    it("returns the length of a string", func(assert) {
      assert("hello world".length(), 11)
      assert("hello".length(), 5)
      assert("ääöü".length(), 4)
      assert("".length(), 0)
    })

    it("concatenates strings", func(assert) {
      assert("hello" + "world", "helloworld")
      assert("hello" + " wonderful " + "world", "hello wonderful world")
      assert("öö" + "üä", "ööüä")
      assert("" + "", "")
    })

    it("concatenates strings and numerics", func(assert) {
      assert("test" + 16, "test16")
      assert("test" + 16.263723762, "test16.263723762")
      assert("test" + 0.001, "test0.001")
      assert("test" + 2.5, "test2.5")
      assert("test" + 2.0, "test2")

      assert(2 + "test", "2test")
      assert(2.5 + "test", "2.5test")
      assert(0.010 + "test", "0.01test")
      assert(28.2 + "test", "28.2test")
      assert(50 + "test" + 25, "50test25")
    })

    it("multiplies strings", func(assert) {
      assert("test" * 3, "testtesttest")
      assert(" " * 3, "   ")
      assert("a" * 10, "aaaaaaaaaa")
      assert("a" * 1.5, "a")
      assert("a" * 1.999, "a")
    })

    it("trims whitespace off the beginning and end", func(assert) {
      assert("   hello  ".trim(), "hello")
      assert("         adad   ".trim(), "adad")
      assert("    asdadasd\n\nasdasd   ".trim(), "asdadasd\n\nasdasd")
      assert("äääüö\n\n\nlol".trim(), "äääüö\n\n\nlol")
    })

    it("inverts a string", func(assert) {
      assert("hello world".reverse(), "dlrow olleh")
      assert("test".reverse(), "tset")
      assert("reviver".reverse(), "reviver")
      assert("rotator".reverse(), "rotator")
      assert("          \ntest\t\t\n".reverse(), "\n\t\ttset\n          ")
    })

    it("filters a string", func(assert) {
      assert("hello beautiful world".filter(func(c) { c ! " " }), "hellobeautifulworld")
      assert("this-is-a-slug".filter(func(c) { c ! "-" }), "thisisaslug")
      assert("hello\nworld".filter(func(c) { c ! "\n" }), "helloworld")
    })

    it("returns each char in a string", func(assert) {
      let chars = []

      "charly".each(func(c) {
        chars.push(c)
      })

      assert(chars == ["c", "h", "a", "r", "l", "y"], true)
    })

    it("returns a char at a given index", func(assert) {
      assert(""[0], null)
      assert("test"[0], "t")
      assert("\ntest"[0], "\n")
    })

    it("returns a substring", func(assert) {
      assert("".substring(0, 5), "")
      assert("hello world".substring(0, 5), "hello")
      assert("hello".substring(0, 10), "hello")
      assert("hello world".substring(6, 5), "world")
      assert("what is going on here".substring(8, 5), "going")
      assert("".substring(10, 0), "")
    })

    it("maps over a string", func(assert) {
      let string = "lorem ipsum dolor sit amet"
      let mapped = string.map(func(c) {
        if (c == "e") {
          "$"
        } else if (c == "o") {
          "$"
        } else if (c == "i") {
          ""
        } else {
          c
        }
      })

      assert(mapped, "l$r$m psum d$l$r st am$t")
    })

    it("checks if a string is empty", func(assert) {
      assert("".empty(), true)
      assert("     ".empty(), false)
      assert("test".empty(), false)
      assert("ä".empty(), false)
      assert("\n".empty(), false)
    })

    it("splits a string into parts", func(assert) {
      assert("hello beautiful world".split(" ")[0], "hello")
      assert("we are seven".split("e")[1], " ar")
      assert("hello\nworld\n:D!".split("\n")[2], ":D!")
      assert("whatsup".split("") == ["w", "h", "a", "t", "s", "u", "p"], true)
    })

    it("returns the index of a substring", func(assert) {
      assert("hello beautiful world".index_of("hello", 0), 0)
      assert("hello beautiful world".index_of("beautiful", 0), 6)
      assert("hello beautiful world".index_of("world", 0), 16)
      assert("I'm not here".index_of("test", 0), -1)
      assert("hello beautiful world".index_of(" ", 0), 5)
    })

    it("lstrip", func(assert) {
      assert("hello world".lstrip(5), " world")
      assert("- myname".lstrip(2), "myname")
      assert("".lstrip(5), "")
      assert("what is going on".lstrip(999), "")
      assert("hello world".lstrip(0), "hello world")
      assert("hello world".lstrip(-5), "hello world")
    })

    it("rstrip", func(assert) {
      assert("hello world".rstrip(5), "hello ")
      assert("- myname".rstrip(2), "- myna")
      assert("".rstrip(5), "")
      assert("what is going on".rstrip(999), "")
      assert("hello world".rstrip(0), "hello world")
      assert("hello world".rstrip(-5), "hello world")
    })

    it("indents a string", func(assert) {
      let string = ""
      string += "okay"
      string += "\n"
      string += "what"
      string += "\n"
      string += "test"

      string = string.indent(2, "-")

      assert(string, "--okay\n--what\n--test")
    })

  })

  describe("Functions", func(it) {

    it("calls a function", func(assert) {
      let called = false
      func call_me() {
        called = true
      }
      call_me()

      assert(called, true)
    })

    it("passes arguments to a function", func(assert) {
      let arg1
      let arg2
      func call_me(_arg1, _arg2) {
        arg1 = _arg1
        arg2 = _arg2
      }
      call_me("hello", 25)

      assert(arg1, "hello")
      assert(arg2, 25)
    })

    it("creates the __argument variable", func(assert) {
      let args_received
      func call_me() {
        args_received = arguments
      }
      call_me("hello", "world", "this", "should", "work")

      assert(args_received == ["hello", "world", "this", "should", "work"], true)
    })

    it("can access the parent scope", func(assert) {
      let change_me = false
      func call_me() {
        change_me = true
      }
      call_me()

      assert(change_me, true)
    })

    it("writes to arguments instead of parent scope", func(assert) {
      let dont_change_me = false
      func call_me(dont_change_me) {
        dont_change_me = true
      }
      call_me(true)

      assert(dont_change_me, false)
    })

    it("runs callbacks in the right scope", func(assert) {
      let change_me = false

      func call_me(callback) {
        let change_me = 25
        callback()
      }

      call_me(func() {
        change_me = true
      })

      assert(change_me, true)
    })

    it("consecutive call expressions", func(assert) {
      func call_me() {
        func() {
          func() {
            25
          }
        }
      }

      assert(call_me()()(), 25)
    })

    it("passes arguments in the right order", func(assert) {
      let f1
      let f2
      let f3

      func(a1) {
        func(a2) {
          func(a3) {
            f1 = a1
            f2 = a2
            f3 = a3
          }
        }
      }(1)(2)(3)

      assert(f1, 1)
      assert(f2, 2)
      assert(f3, 3)
    })

    it("gives functions the correct self pointer", func(assert) {
      let box = {
        let val = "in box"

        func foo() {
          got = @val
        }
      }

      let got = null
      box.foo()

      assert(got, "in box")
    })

    it("gives direct function calls the correct self pointer", func(assert) {
      let box = {
        let val = "in box"

        func foo() {
          func bar() {
            got = @val
          }

          bar()
        }
      }

      let got = null
      box.foo()

      assert(got, "in box")
    })

    it("callbacks receive the correct self pointer", func(assert) {
      func foo(callback) {
        callback()
      }

      let box = {
        let val = "in box"

        func bar() {
          foo(func() {
            got = @val
          })
        }
      }

      let got = null
      box.bar()

      assert(got, "in box")
    })

    it("assigned functions receive the correct self pointer", func(assert) {
      let box = {
        let val = "in box"
      }

      box.foo = func() {
        got = @val
      }

      let got = null
      box.foo()

      assert(got, "in box")
    })

    it("functions in nested objects get the correct self pointer", func(assert) {
      let box = {
        let val = "upper box"

        let foo = {
          let val = "inner box"

          func bar() {
            got = @val
          }
        }
      }

      let got = null
      box.foo.bar()

      assert(got, "inner box")
    })

    it("assigned functions in nested objects get the correct self pointer", func(assert) {
      let box = {
        let val = "upper box"

        let foo = {
          let val = "inner box"
        }
      }

      let got = null

      box.foo.bar = func bar() {
        got = @val
      }

      box.foo.bar()

      assert(got, "inner box")
    })

    it("does explicit returns with an argument", func(assert) {
      func foo() {
        return 25
      }

      assert(foo(), 25)
    })

    it("does explicit returns without argument", func(assert) {
      func foo() {
        return 25
      }

      assert(foo(), 25)
    })

    it("does explicit returns from an object", func(assert) {
      let Box = {
        func foo() {
          return 25
        }
      }

      assert(Box.foo(), 25)
    })

    it("does explicit returns from nested ifs", func(assert) {
      func foo(arg) {
        if arg <= 10 {
          return false
        }

        return true
      }

      assert(foo(0), false)
      assert(foo(5), false)
      assert(foo(10), false)

      assert(foo(15), true)
      assert(foo(20), true)
      assert(foo(25), true)
    })

    it("runs lambda functions", func(assert) {
      let nums = [1, 2, 3, 4]
      nums = nums.map(->(num) num ** 2)

      assert(nums, [1, 4, 9, 16])
    })

    it("assigns lambda functions to variables", func(assert) {
      let myFunc = ->(arg, arg2) {
        arg + arg2
      }

      const result = myFunc(25, 100)

      assert(result, 125)
    })

    it("gives lambda functions the correct self pointer", func(assert) {
      let Box = {
        const name = "charly"
      }
      Box.foo = ->@name

      assert(Box.foo(), "charly")
    })

    it("correctly parses nested lambda functions", func(assert) {
      const myFunc = ->->{
        25
      }

      assert(myFunc().typeof(), "Function")
      assert(myFunc()(), 25)
    })

    it("sets props on function literals", func(assert) {
      func foo() {}
      func bar(a, b, c) {}
      const a = func() {}

      assert(foo.name, "foo")
      assert(bar.name, "bar")
      assert(a.name, "")
    })

  })

  describe("Classes", func(it) {

    it("creates a new class", func(assert) {
      class Person {
        property name
        property age

        func constructor(name, age) {
          @name = name
          @age = age
        }
      }

      let charly = Person("charly", 16)
      let peter = Person("Peter", 20)

      assert(charly.name, "charly")
      assert(charly.age, 16)
      assert(peter.name, "Peter")
      assert(peter.age, 20)
    })

    it("calls functions inside classes", func(assert) {
      class Box {
        property value
        func set(value) {
          @value = value
        }
      }

      let myBox = Box()
      assert(myBox.value, null)
      myBox.set("this works")
      assert(myBox.value, "this works")
    })

    it("doesn't read from the parent stack", func(assert) {
      class Box {}
      let myBox = Box()

      let changed = false
      assert(myBox.changed, null)
    })

    it("doesn't write into the parent stack", func(assert) {
      class Box {}
      let myBox = Box()

      let changed = false
      myBox.changed = true

      assert(changed, false)
    })

    it("calls methods from parent classes", func(assert) {
      class Box {
        func foo() {
          "it works"
        }
      }

      class SpecialBox extends Box {}

      const myBox = SpecialBox()
      assert(myBox.foo(), "it works")
    })

    it("calls methods from parent classes inside child methods", func(assert) {
      class Box {
        func foo() {
          "it works"
        }
      }

      class SpecialBox extends Box {
        func bar() {
          @foo()
        }
      }

      const myBox = SpecialBox()
      assert(myBox.bar(), "it works")
    })

    it("sets props on classes", func(assert) {
      class A {
        property name
        property age

        func constructor(name, age) {
          @name = name
          @age = age
        }

        func foo() {}
        func bar() {}
      }

      assert(A.name, "A")
    })

    it("sets props on child classes", func(assert) {
      class A {
        property name

        func bar() {}
      }

      class B extends A {
        property age

        func constructor(name, age) {
          @name = name
          @age = age
        }

        func foo() {}
      }

      assert(B.name, "B")
    })

    it("gives back the class of an object", func(assert) {
      class Box {}

      const mybox = Box()

      assert(mybox.instanceof(), Box)
    })

    it("creates static properties on classes", func(assert) {
      class Box {
        static property count

        func constructor() {
          Box.count += 1
        }
      }
      Box.count = 0

      Box()
      Box()
      Box()
      Box()

      assert(Box.count, 4)
    })

    it("creates static methods on classes", func(assert) {
      class Box {
        static func do_something() {
          "static do_something"
        }

        func do_something() {
          "instance do_something"
        }
      }

      const myBox = Box()
      assert(myBox.do_something(), "instance do_something")
      assert(Box.do_something(), "static do_something")
    })

    it("inherits static methods to child classes", func(assert) {
      class Box {
        static func foo() {
          "static foo"
        }
      }

      class SubBox extends Box {}

      assert(SubBox.foo(), "static foo")
    })

    it("inherits static properties to child classes", func(assert) {
      class Box {
        static property foo
      }
      Box.foo = 0

      class SubBox extends Box {}

      assert(SubBox.foo, 0)

      Box.foo += 100

      assert(Box.foo, 100)
      assert(SubBox.foo, 0)
    })

    it("passes the class via the self identifier on static methods", func(assert) {
      class Box {
        static func foo() {
          assert(self, Box)
        }
      }

      Box.foo()
    })

  })

  describe("Objects", func(it) {

    it("can override native methods", func(assert) {
      let charly = {
        let name
        let age

        func to_s() {
          name + " is " + age + " years old!"
        }
      }
      charly.name = "charly"
      charly.age = 16

      let text = charly.to_s()
      assert(text, "charly is 16 years old!")
    })

    it("adds properties to objects", func(assert) {
      class Box {}
      let myBox = Box()
      myBox.name = "charly"
      myBox.age = 16

      assert(myBox.name, "charly")
      assert(myBox.age, 16)
    })

    it("adds functions to objects", func(assert) {
      class Box {}
      let myBox = Box()
      myBox.name = "charly"
      myBox.age = 16
      myBox.to_s = func() {
        assert(self == myBox, true)
        myBox.do_stuff = func() {
          "it works!"
        }

        myBox.name + " - " + myBox.age
      }

      assert(myBox.name, "charly")
      assert(myBox.age, 16)
      assert(myBox.do_stuff, null)
      assert(myBox.to_s(), "charly - 16")
      assert(myBox.do_stuff(), "it works!")
    })

    it("anonymous functions's self is sourced from the stack ", func(assert) {
      let val = 0

      let box1 = {
        let val = 1

        func callback(callback) {
          callback()
        }
      }

      let box2 = {
        let val = 2

        func call() {
          box1.callback(func() {
            @val = 200
          })
        }
      }

      box2.call()
      assert(val, 0)
      assert(box1.val, 1)
      assert(box2.val, 200)
    })

    it("redirects arithmetic operators", func(assert) {
      let myBox = {
        func __plus(element) { "plus" }
        func __minus(element) { "minus" }
        func __mult(element) { "mult" }
        func __divd(element) { "divd" }
        func __mod(element) { "mod" }
        func __pow(element) { "pow" }
      }

      assert(myBox + 1, "plus")
      assert(myBox - 1, "minus")
      assert(myBox * 1, "mult")
      assert(myBox / 1, "divd")
      assert(myBox % 1, "mod")
      assert(myBox ** 1, "pow")
    })

    it("redirects comparison operators", func(assert) {
      let myBox = {
        func __less(element) { "less" }
        func __greater(element) { "greater" }
        func __lessequal(element) { "lessequal" }
        func __greaterequal(element) { "greaterequal" }
        func __equal(element) { "equal" }
        func __not(element) { "notequal" }
      }

      assert(myBox < 1, "less")
      assert(myBox > 1, "greater")
      assert(myBox <= 1, "lessequal")
      assert(myBox >= 1, "greaterequal")
      assert(myBox == 1, "equal")
      assert(myBox ! 1, "notequal")
    })

    it("redirects unary operators", func(assert) {
      let myBox = {
        func __uplus() { "uplus" }
        func __uminus() { "uminus" }
        func __unot() { "unot" }
      }

      assert(+myBox, "uplus")
      assert(-myBox, "uminus")
      assert(!myBox, "unot")
    })

    it("assigns the correct scope to functions that are added from the outside", func(assert) {
      let Box = {
        let val = 0

        func do(callback) {
          callback(self)
        }
      }

      let val = 0

      Box.do(func(Box) {
        val = 30
        Box.val = 60
      })

      assert(val, 30)
      assert(Box.val, 60)

      Box.do2 = func() {
        val = 120
        @val = 90
      }
      Box.do2()

      assert(val, 120)
      assert(Box.val, 90)
    })

    it("assigns via index expressions", func(assert) {
      let Box = {
        let name = "test"
      }

      Box["name"] = "it works"

      assert(Box["name"], "it works")
    })

    it("gives back null on container literals", func(assert) {
      let Box = {}

      assert(Box.instanceof(), null)
    })

    it("displays objects as a string", func(assert) {
      let Box = {
        let name = "charly"
        let data = {
          let foo = "okay"
          let hello = "world"
        }
      }

      let render = Box.to_s()

      assert(render, "{\n  name: charly\n  data: {\n    foo: okay\n    hello: world\n  }\n}")
    })

    it("returns all keys of an object", func(assert) {
      let Box = {
        let name = "charly"
        let data = {
          let foo = "okay"
          let hello = "world"
        }
      }

      const keys = Object.keys(Box)
      assert(keys, ["name", "data"])
    })

  })

  describe("While loops", func(it) {

    it("runs for the specified count", func(assert) {
      let sum = 0
      let index = 0
      while (index < 500) {
        sum += index
        index += 1
      }

      assert(sum, 124750)
    })

    it("breaks a loop", func(assert) {
      let i = 0
      while (true) {
        if i > 99 {
          break
        }

        i += 1
      }
      assert(i, 100)
    })

  })

  describe("Misc. standard library functions", func(it) {

    it("returns the type() of a variable", func(assert) {
      assert(false.typeof(), "Boolean")
      assert(true.typeof(), "Boolean")
      assert("test".typeof(), "String")
      assert(25.typeof(), "Numeric")
      assert(25.5.typeof(), "Numeric")
      assert([1, 2, 3].typeof(), "Array")
      assert((class Test {}).typeof(), "Class")
      assert((func() {}).typeof(), "Function")
      assert({}.typeof(), "Object")
      assert(null.typeof(), "Null")
    })

    it("casts string to numeric", func(assert) {
      assert("25".to_n(), 25)
      assert("25.5".to_n(), 25.5)
      assert("0".to_n(), 0)
      assert("100029".to_n(), 100029)
      assert("-89.2".to_n(), -89.2)

      assert("hello".to_n(), NAN)
      assert("25test".to_n(), 25)
      assert("ermokay30".to_n(), NAN)
      assert("-2.25this".to_n(), -2.25)

      assert("123.45e2".to_n(), 12345)
      assert("2e5".to_n(), 200_000)
      assert("25e-5".to_n(), 0.00025)
      assert("9e-2".to_n(), 0.09)
    })

    it("pipes an array to different functions", func(assert) {
      let res1
      let res2
      let res3

      func setRes1(v) {
        res1 = v
      }

      func setRes2(v) {
        res2 = v
      }

      func setRes3(v) {
        res3 = v
      }

      5.pipe(setRes1, setRes2, setRes3)

      assert(res1, 5)
      assert(res2, 5)
      assert(res3, 5)
    })

    it("transforms an array", func(assert) {
      func reverse(array) {
        array.reverse()
      }

      func addOne(array) {
        array.map(func(e) { e + 1 })
      }

      func multiplyByTwo(array) {
        array.map(func(e) { e * 2 })
      }

      const nums = [1, 2, 3, 4, 5]
      const result = nums.transform(multiplyByTwo, reverse, addOne)
      assert(result, [11, 9, 7, 5, 3])
    })

  })

  describe("CLI", func(it) {

    it("receives an argument called ARGV", func(assert) {
      assert(ARGV.typeof(), "Array")
      assert(ARGV.length(), 0)
    })

    it("receives an argument called IFLAGS", func(assert) {
      assert(IFLAGS.typeof(), "Array")
      assert(IFLAGS.length(), 0)
    })

    it("receives an argument called ENV", func(assert) {
      assert(ENV.typeof(), "Object")
      assert(ENV.CHARLYDIR.typeof(), "String")
    })

  })

  describe("Math", func(it) {

    it("has mathematical constants", func(assert) {
      assert(Math.PI, 3.14159265358979323846)
      assert(Math.E, 2.7182818284590451)
      assert(Math.LOG2, 0.69314718055994529)
      assert(Math.LOG10, 2.3025850929940459)
    })

    it("calculates roots via cbrt", func(assert) {
      assert(Math.cbrt(2).close_to(1.2599210499, 0.0000001), true)
      assert(Math.cbrt(20).close_to(2.7144176166, 0.0000001), true)
      assert(Math.cbrt(500).close_to(7.9370052598, 0.0000001), true)
      assert(Math.cbrt(9).close_to(2.0800838231, 0.0000001), true)
      assert(Math.cbrt(-90).close_to(-4.4814047466, 0.0000001), true)
    })

    it("calculates roots via sqrt", func(assert) {
      assert(Math.sqrt(2).close_to(1.4142135624, 0.0000001), true)
      assert(Math.sqrt(20).close_to(4.472135955, 0.0000001), true)
      assert(Math.sqrt(500).close_to(22.360679775, 0.0000001), true)
      assert(Math.sqrt(9).close_to(3, 0.0000001), true)
      assert(Math.sqrt(-90).to_s(), "NAN")
    })

    it("gets the log", func(assert) {
      assert(Math.log(10).close_to(2.3025850929940459, 0.0000001), true)
      assert(Math.log(100).close_to(4.6051701859880918, 0.0000001), true)
      assert(Math.log(500).close_to(6.2146080984221914, 0.0000001), true)
      assert(Math.log(892.5).close_to(6.7940265136537938, 0.0000001), true)
      assert(Math.log(-90).to_s(), "NAN")
    })

    it("trigonometric functions", func(assert) {
      assert(Math.cos(2).close_to(-0.4161468365, 0.0000001), true)
      assert(Math.cos(20).close_to(0.4080820618, 0.0000001), true)
      assert(Math.cos(-90).close_to(-0.4480736161, 0.0000001), true)

      assert(Math.sin(2).close_to(0.9092974268, 0.0000001), true)
      assert(Math.sin(20).close_to(0.9129452507, 0.0000001), true)
      assert(Math.sin(-90).close_to(-0.8939966636, 0.0000001), true)

      assert(Math.tan(2).close_to(-2.1850398633, 0.0000001), true)
      assert(Math.tan(20).close_to(2.2371609442, 0.0000001), true)
      assert(Math.tan(-90).close_to(1.9952004122, 0.0000001), true)
    })

    it("inverse trigonometric functions", func(assert) {
      assert(Math.acos(-0.5).close_to(2.0943951023931957, 0.0000001), true)
      assert(Math.acos(0.2).close_to(1.3694384060045657, 0.0000001), true)
      assert(Math.acos(0.892).close_to(0.4690458582650856, 0.0000001), true)

      assert(Math.asin(-0.5).close_to(-0.52359877559829882, 0.0000001), true)
      assert(Math.asin(0.2).close_to(0.2013579207903308, 0.0000001), true)
      assert(Math.asin(0.892).close_to(1.101750468529811, 0.0000001), true)

      assert(Math.atan(-0.5).close_to(-0.46364760900080615, 0.0000001), true)
      assert(Math.atan(0.2).close_to(0.19739555984988078, 0.0000001), true)
      assert(Math.atan(0.892).close_to(0.72837758931190089, 0.0000001), true)
    })

    it("hyperbolic functions", func(assert) {
      assert(Math.cosh(-0.5).close_to(1.1276259652063807, 0.0000001), true)
      assert(Math.cosh(0.2).close_to(1.0200667556190759, 0.0000001), true)
      assert(Math.cosh(0.892).close_to(1.4249200230556498, 0.0000001), true)

      assert(Math.sinh(-0.5).close_to(-0.52109530549374738, 0.0000001), true)
      assert(Math.sinh(0.2).close_to(0.20133600254109399, 0.0000001), true)
      assert(Math.sinh(0.892).close_to(1.0150847610445708, 0.0000001), true)

      assert(Math.tanh(-0.5).close_to(-0.46211715726000974, 0.0000001), true)
      assert(Math.tanh(0.2).close_to(0.19737532022490401, 0.0000001), true)
      assert(Math.tanh(0.892).close_to(0.71238016493570389, 0.0000001), true)
    })

    it("inverse hyperbolic functions", func(assert) {
      assert(Math.acosh(5).close_to(2.2924316695611777, 0.0000001), true)
      assert(Math.acosh(28).close_to(4.0250326605516182, 0.0000001), true)
      assert(Math.acosh(500).close_to(6.9077542789806374, 0.0000001), true)

      assert(Math.asinh(-0.5).close_to(-0.48121182505960342, 0.0000001), true)
      assert(Math.asinh(0.2).close_to(0.19869011034924142, 0.0000001), true)
      assert(Math.asinh(0.892).close_to(0.80290874355870534, 0.0000001), true)

      assert(Math.atanh(-0.5).close_to(-0.54930614433405489, 0.0000001), true)
      assert(Math.atanh(0.2).close_to(0.20273255405408219, 0.0000001), true)
      assert(Math.atanh(0.892).close_to(1.431629261243802, 0.0000001), true)
    })


    it("ceil & floor", func(assert) {
      assert(Math.ceil(2.5).close_to(3, 0), true)
      assert(Math.ceil(20).close_to(20, 0), true)
      assert(Math.ceil(0.000000001).close_to(1, 0), true)
      assert(Math.ceil(9.01).close_to(10, 0), true)
      assert(Math.ceil(-90).close_to(-90, 0), true)

      assert(Math.floor(2.5).close_to(2, 0), true)
      assert(Math.floor(20).close_to(20, 0), true)
      assert(Math.floor(0.00000001).close_to(0, 0), true)
      assert(Math.floor(9.01).close_to(9, 0), true)
      assert(Math.floor(-90).close_to(-90, 0), true)
    })

  })

  describe("try & catch", func(it) {

    it("throws an exception", func(assert) {
      try {
        throw Exception("Something failed")
      } catch (e) {
        assert(e.message, "Something failed")
      }
    })

    it("throws primitive values", func(assert) {
      try {
        throw 2
      } catch (e) {
        assert(e, 2)
        assert(e.typeof(), "Numeric")
      }
    })

    it("stops execution of the block", func(assert) {
      try {
        throw 2
        assert(true, false)
      } catch (e) {
        assert(e, 2)
      }
    })

    it("throws exceptions beyond functions", func(assert) {
      func foo() {
        throw Exception("lol")
      }

      try {
        foo()
      } catch (e) {
        assert(e.message, "lol")
      }
    })

    it("throws exceptions inside object constructors", func(assert) {
      class Foo {
        func constructor() {
          throw 2
        }
      }

      try {
        let a = Foo()
      } catch (e) {
        assert(e, 2)
      }
    })

    it("assigns RunTimeErrors a message property", func(assert) {
      try {
        const a = 2
        a = 3
      } catch(e) {
        assert(e.message.typeof(), "String")
        return
      }

      assert(true, false)
    })

    it("assigns RunTimeErrors a trace property", func(assert) {
      try {
        const a = 2
        a = 3
      } catch(e) {
        assert(e.trace.typeof(), "Array")
        assert(e.trace.length() > 0, true)
        return
      }

      assert(true, false)
    })

  })

})

exit(testResult)
