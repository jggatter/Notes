Search all files recursively for pattern
```sh
grep -r "pattern" .
```

Find all python files and search them for a pattern
```shell
fd '.*\.py' | rg -f - -e "quilt3"
```
