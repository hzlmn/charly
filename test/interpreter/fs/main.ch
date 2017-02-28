const fs = require("fs")

const FILE_TEST = "test/interpreter/fs/data/test.txt"
const FILE_TEST_LINK = "test/interpreter/fs/data/test-link.txt"
const FILE_TMP = "test/interpreter/fs/data/tmp.txt"

export = ->(describe, it, assert) {

  describe("File", ->{

    describe("stat", ->{

      describe("regular files", ->{

        it("returns an object containing specific keys", ->{
          const stat = fs.stat(FILE_TEST)

          assert(typeof stat, "Object")
          assert(typeof stat.dev, "Numeric")
          assert(typeof stat.mode, "Numeric")
          assert(typeof stat.nlink, "Numeric")
          assert(typeof stat.uid, "Numeric")
          assert(typeof stat.gid, "Numeric")
          assert(typeof stat.rdev, "Numeric")
          assert(typeof stat.blksize, "Numeric")
          assert(typeof stat.ino, "Numeric")
          assert(typeof stat.size, "Numeric")
          assert(typeof stat.blocks, "Numeric")
          assert(typeof stat.atime, "Numeric")
          assert(typeof stat.mtime, "Numeric")
          assert(typeof stat.ctime, "Numeric")
        })

      })

      describe("symbolic links", ->{

        it("returns an object containing specific keys", ->{
          const stat = fs.lstat(FILE_TEST_LINK)

          assert(typeof stat, "Object")
          assert(typeof stat.dev, "Numeric")
          assert(typeof stat.mode, "Numeric")
          assert(typeof stat.nlink, "Numeric")
          assert(typeof stat.uid, "Numeric")
          assert(typeof stat.gid, "Numeric")
          assert(typeof stat.rdev, "Numeric")
          assert(typeof stat.blksize, "Numeric")
          assert(typeof stat.ino, "Numeric")
          assert(typeof stat.size, "Numeric")
          assert(typeof stat.blocks, "Numeric")
          assert(typeof stat.atime, "Numeric")
          assert(typeof stat.mtime, "Numeric")
          assert(typeof stat.ctime, "Numeric")
        })

      })

    })

    describe("read", ->{

      it("returns the contents of a file", ->{
        const file = fs.read(FILE_TEST, "utf8")

        assert(file, [
          "Hello World",
          "My name is Charly",
          "What is yours?",
          ""
        ].join("\n"))
      })

    })

    describe("open", ->{

      it("returns a File object", ->{
        const file = fs.open(FILE_TEST, "r", "utf8")
        assert(file.__class.name, "File")

        file.close()
      })

    })

    describe("instance", ->{

      describe("properties", ->{

        it("has the correct properties", ->{
          const file = fs.open(FILE_TEST, "r", "utf8")

          assert(typeof file.fd, "Numeric")
          assert(typeof file.filename, "String")
          assert(typeof file.mode, "String")
          assert(typeof file.encoding, "String")

          file.close()
        })

        it("puts the absolute path into the filename property", ->{
          const file = fs.open(FILE_TEST, "r", "utf8")

          assert(file.filename.first(), "/")

          file.close()
        })

        it("puts encoding and mode into the File object", ->{
          const file = fs.open(FILE_TEST, "r", "utf8")

          assert(file.mode, "r")
          assert(file.encoding, "utf8")

          file.close()
        })

      })

      describe("methods", ->{

        describe("close", ->{

          it("closes a file", ->{
            const file = fs.open(FILE_TEST, "r", "utf8")
            file.close()

            try {
              file.puts("this should throw")
            } catch(e) {
              assert(true, true)
              return
            }

            assert(false, "Expected an exception")
          })

        })

        describe("print", ->{

          it("prints into a file", ->{
            const file = fs.open(FILE_TMP, "w+", "utf8")

            file.print("hello")
            file.print("hello")
            file.print("hello")
            file.print("hello")

            file.close()

            const content = fs.read(FILE_TMP, "utf8")

            assert(content, "hellohellohellohello")
          })

        })

        describe("puts", ->{

          it("puts into a file", ->{
            const file = fs.open(FILE_TMP, "w+", "utf8")

            file.puts("hello")
            file.puts("hello")
            file.puts("hello")
            file.puts("hello")

            file.close()

            const content = fs.read(FILE_TMP, "utf8")

            assert(content, "hello\nhello\nhello\nhello\n")
          })

        })

        describe("gets", ->{

          it("reads a single line from a file", ->{
            const file = fs.open(FILE_TEST, "r", "utf8")

            assert(file.gets(), "Hello World")
            assert(file.gets(), "My name is Charly")
            assert(file.gets(), "What is yours?")
            assert(file.gets(), null)

            file.close()
          })

        })

        describe("read_char", ->{

          it("reads a single char from a file", ->{
            const file = fs.open(FILE_TEST, "r", "utf8")

            assert(file.read_char(), "H")
            assert(file.read_char(), "e")
            assert(file.read_char(), "l")
            assert(file.read_char(), "l")
            assert(file.read_char(), "o")
            assert(file.read_char(), " ")

            file.close()
          })

        })

        describe("read_bytes", ->{

          it("reads a couple bytes from a file", ->{
            const file = fs.open(FILE_TEST, "r", "utf8")

            assert(file.read_bytes(12), [72, 101, 108, 108, 111, 32, 87, 111, 114, 108, 100, 10])

            file.close()
          })

        })

        describe("write_bytes", ->{

          it("writes bytes to a file", ->{
            let file = fs.open(FILE_TMP, "w+", "utf8")

            const data = [10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20];

            file.write_bytes(data)

            file.close()

            file = fs.open(FILE_TMP, "r", "utf8")

            assert(file.read_bytes(11), data)

            file.close()
          })

        })

      })

    })

  })

}