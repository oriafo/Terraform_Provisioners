## Observations as regarding using file/remote-exec provisioners and user data script in carrying out resource configuration. ##

* **Because of the complex nature of using the file and remote-exec provisioner over user data script and for the fact that debugging when using file and remote-exec provisioner will be much more dificult because it usually does not provide a clear feedback as to the processes it does go through, the use of user data or any other configuration management tool with be adviced.**

* **Looking at the time complexity for file and remote-exec provisioner to carry out their operations of transfering files(s) to the server, trying establish connection to the server**