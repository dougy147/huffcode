Playing around with [Huffman coding](https://en.wikipedia.org/wiki/Huffman_coding) in Perl.

```console
$ perl ./main "hello world"
        +-------------+
        | "l" => 10   |
        | "h" => 000  |
        | "e" => 011  |
        | "o" => 111  |
        | "r" => 010  |
        | " " => 001  |
        | "w" => 1100 |
        | "d" => 1101 |
        +-------------+
00001110101110011100111010101101
```

This is made for [another toy project](https://github.com/dougy147/pppdf) to parse PDFs [Deflate](https://en.wikipedia.org/wiki/Deflate) encoded streams.

# References

- [https://en.wikipedia.org/wiki/Huffman_coding](https://en.wikipedia.org/wiki/Huffman_coding)
- [https://en.wikipedia.org/wiki/Deflate](https://en.wikipedia.org/wiki/Deflate)
- [https://www.rfc-editor.org/info/rfc1951](https://www.rfc-editor.org/info/rfc1951)
