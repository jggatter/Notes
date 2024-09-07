#windows #unixlike #unix
## Determining file origin

When creating files on its filesystem, Windows will use a consecutive carriage return (`\r`) and line feed (`\n`) to mark the end of a line, `\r\n` (CRLF). This mimics the two buttons pressed in analog typewriters to return to the start of the line and advance to the next line. Windows kept it to maintain backwards compatibility with devices and data that expect this character, while Unix removed the redundancy by using only the line feed character `\n`.

Comparing files encoded separately by Windows and Unix will screw up diffs, with `diff` indicating all lines are completely different. Most of the line differences beyond this encoding difference may be concealed by CRLF.

The `file` coreutil can be used to summarize basic information about files. Here we use `-e` to exclude the JSON format so that `file` can we can ignore the JSON format and evaluate the encoding information:

```sh
❯ file -e json ~/Downloads/memory?.json
/Users/jgatter/Downloads/memory1.json: ASCII text, with CRLF line terminators
/Users/jgatter/Downloads/memory2.json: ASCII text
```

## Converting from Windows to Unix

Install and use `dos2unix`