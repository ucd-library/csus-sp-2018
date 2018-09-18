# JWT

This is an example test for some proposed functionality for fin cli.
Originally, the idea for this was specifically for testing, but these
functions are necessary for lots of applications.  The idea is that you can
query your jwt token, and create new ones if you have the server secret.

fin_jwt.bash is the shim for the commands
jwt.bats is the bash testing framework showing how this works


## USAGE
     fin jwt [options]

## OPTIONS

- --SECRET=*serversecret* This allows for server testing when you have a
    secret. If passed, this will create a local jwt token with the passed
    parameters. This should be a good indicator that it's important to keep
    your secrets secret.

- --user=*username* This is the user logging logging into the server.

- --admin If the user has admin privledges, they can specify a token with
    admin privledges as well.

- --decode This will decode your token. Note that even if you don't know
    your SECRET, this will show you your payload, as per JWT tokens.

- --save This saves your token to your ~/.fccli file.
