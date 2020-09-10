# dockerignore-wildcard-bug

Demonstrates a bug in dockerignore wildcards (**)

## Repro steps:

Checkout this directory and run `make all`

## Expected result:

`include.txt` should be in the docker context.

`exclude.txt` should be ignored.

## Actual result:

Both are included in the docker context.

# Other notes

The underlying bug is this code:

https://github.com/moby/moby/blob/v19.03.12/pkg/fileutils/fileutils.go#L83

which assumes that the number of directory separators in the pattern can be used
to determine the "directory" length, which is not a correct assumption when
wildcards are present.

Interestingly, the exclude pattern is necessary to reproduce this problem. That's because
this code:

https://github.com/moby/moby/blob/v19.03.12/pkg/archive/archive.go#L843

skips directories purely as an optimization. Adding an exclusion pattern
(!a/b/c/include.txt) makes this code go down the "slow" codepath.
