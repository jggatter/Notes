#linux #unixlike

[Article](https://linuxize.com/post/how-to-create-symbolic-links-in-linux-using-the-ln-command/)

## Hard versus soft links

inode aka index node: 
* a data structure in Unix-like file systems that describes objects such as files or directories.
* store attributes and disk block locations of the object's data 
* as well as metadata such as time of last change, access, modifcation, owner, and permission data.

Hard link: 
* Associate two or more file names with the same inode
* Like having an additional name for an existing file
* You can create one or more hardlinks for a single file
* Cannot be created for directories nor files on different file systems or partitions

Soft link aka symbolic link:
* An indirect pointer to a file or directory
* Like a shortcut in Windows
* Unlike hard link, symbolic links can point to a file or directory on different file systems or partitions

## Using the `ln` command

`ln` is a command-line utility for creating links between files. By default `ln` creates _hard_ links. 

### Creating symlinks

To create symbolic links we use `ln -s`

```sh
ln -s [OPTIONS] FILE LINK

# OR you can think of it as
ln -s source_file symbolic_link
# e.g.
ln -s my_file.txt my_link.txt
```

* When both `FILE` and `LINK` are specified, `ln` creates a link `LINK` to file `FILE`  
* If only `FILE` is specified or the second argument `LINK` is the present working directory ( `.` ), a link will be created in the present working directory to that file  

When using `ls -l` on the link file, the file type flag should show a `->` symbol denoting where the symlink points to

### Overwiting symlinks

Use the `-f` flag to force creation of the symlink
`ln -s my_file.txt my_link.txt`

## Removing symlinks

When removing a symbolic link not append the `/` trailing slash at the end of its name.

If you delete or move the source file to a different location, the symbolic file will be left dangling (broken) and should be removed.

`unlink` command
`unlink symlink_to_remove`

__Warning__: The `rm` command will remove the linked file as well!
`rm symlink_to_remove`
`
