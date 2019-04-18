# pawn-const-correctness-fixer
When you have [Perl](https://www.perl.org/) installed (Linux has this installed by default), execute the following command in a command prompt to fix all occurrences of warning 214 in your script. Replace `SOURCE` with the name of the file you want to fix and `DESTINATION` with the name of the file that will store the fixed version.
```Bash
perl ./warning_214_fixer.pl SOURCE DESTINATION
```

An example script `test_input.pwn` has been provided, which produces the output shown in `test_output.pwn` and produces the following message:
```
perl ./warning_214_fixer.pl ./test_input.pwn ./test_output.pwn
Fixed warning 214 a total of 6 times.
```