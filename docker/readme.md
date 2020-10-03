#### NOT WORKING ATM, UNABLE TO CONNECT LABKEY TO A NON localhost MSSQL server on local network. 

1. Ensure SSH keys working by testing download of a protected repo.
1. In labkey folder run `pull_labkey_code.sh`
1. In docker folder run `docker-compose up`
1. Wait until done (an extreme while).
1. Labkey should be running at `127.0.0.1:8080/labkey`