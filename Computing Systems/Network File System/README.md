This is an implementation of a simple client-server Network File System (NFS) over a simulated virtual disk containing 1,024 disk blocks; each 128 bytes in size.
The server is not a multi-client program meaning the server serves only one client over a TCP session's lifetime. 

Shell.cpp is the client side of the file system that processes commands by creating a TCP socket, connecting to the server when mounted, sending commands to the server, and waiting for a response. 

FileSys.cpp is the server side interface that receives commands from the client and sends back a response through the TCP socket. 

client.cpp and server.cpp are the Network File System's main program for client and server respectfully. 


Disk and BasicFileSys are the virtual disk file and a low-level interface interacting with it fully provided by the instructor and utilized to run the file system. 


To run the filesystem, we start by providing the port on the server side: 

./nfsserver <port>

And run the client by providing server name and port:

./nfsclient <server_name:port>

 ### Commands Supported:
      mkdir, ls, cd, home, rmdir, create, append, stat, cat, head, rm
      
      
