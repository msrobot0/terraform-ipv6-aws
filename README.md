# terraform-ipv6-aws
Generate free ipv6 gateway on aws 

## HOW TO USE

1. First either generate a new ssh key or get the public key of an existing ssh key. Use this for the ssh variable. Also set the keyname for this key, and a shortcut name your remote ipv6-machine.
2. Fill in your AWS variables and other variables (ssh key etc) in your.env. Then rename this to .env. Run source .env. (this is for unix based machines - on windows just make sure these variables are loaded)
3. The username and ipv6-machine variables refer to the ipv6 machine you are going to tunnel into. 
4. This was originally developed to tunnel into a gpu running jupyter notebook and then open up ports to run the jupyter notebook locally. If you are not doing this then delete the first command in local-exec
5. After the terraform runs successfully run This was originally developed to tunnel into a gpu running jupyter notebook and then open up ports to run the jupyter notebook locally. If you are not doing this then delete the first command in local-exec run ssh -N -f -L localhost:8898:localhost:8889 {ipv6-machine-name}.
