+ MochaFS

++ Disk Paritioning
| Block	| Description                                   |
|-------|-----------------------------------------------|
| 0	    | Boot Sector                                   |
| 1-16	| Reserved(Stage2)                              |
| X-X	  | File Table(Cause Simple FAT) 16 Blocks Per MB |
| X-end	| Data                                          |

The File Table is dynamically allocated, the rule is 16 blocks per 1MB of disk space, 1GB = 4MB file table.

As of now, the flags isn’t used.

++ Disk Information

Disk Information is stored in the boot Sector the information is as follows

| Description	           | Data Type	| Data Size |
|------------------------|------------|-----------|
| Magic (4D, 46, 53, 31) | Char	      | 4         |
| Flags                  | Byte       |	1         |
| Version                | Byte       |	1         |
| Bytes Per Block        | Word       |	2         |
| Block Total            | Qword      |	8         |
| Table Size             | Dword      |	4         |
| Volume Label           | Char       |	16        |

++ Files

Files are stored in two places, the file table and the data space. The file table has a series of entries listing all files and directories on the disk. The data section stored files contiguously(linear data), this means files are easily read but cannot grow in size, you must find a new place to store all the data.

File Entries are a data structure 32 bytes in size, they look like:
| Description	           | Data Type	| Data Size |
|------------------------|------------|-----------|
| File Name              | Char       | 15        |
| Flags                  | Byte       | 1         |   
| Address                | Qword      | 8         |
| Size                   | Dword      | 4         |
| Dir Parent ID          | Dword      | 4         |

The Flags tell the entry whether it is a deleted file, file, directory or empty entry

```
0x00  > empty
0x01  > file
0x02  > directory
0xDE  > deleted file
```

For a directory the entry table has to be remapped to work with a directory

```
File Name       > File Name
Flags           > Flags
Address         > Unused
Size            > Dir ID
Dir Parent ID   > Dir Parent ID
```
