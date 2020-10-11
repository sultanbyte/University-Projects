// server.cpp
#include <iostream>
#include <string>
#include <cstdlib>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <unistd.h>
#include <vector>
#include "FileSys.h"
using namespace std;

bool receive(string &response, int sock);

int main(int argc, char* argv[]) {
	if (argc < 2) {
		cout << "Usage: ./nfsserver port#\n";
        return -1;
    }
    int port = atoi(argv[1]);

    //networking part: create the socket and accept the client connection


    int sock = socket(AF_INET, SOCK_STREAM, 0); //change this line when necessary! 

    if (sock == -1)
    {
        cerr <<" Socket failure. " << endl;
        return -1;
    }

    sockaddr_in servaddr;
    servaddr.sin_family = AF_INET;
    servaddr.sin_port = htons(port);
    servaddr.sin_addr.s_addr = htonl(INADDR_ANY); 

    if (bind (sock,(sockaddr*) &servaddr, sizeof(servaddr)) == -1)
    {
        cerr << "Binding failed..." << endl;
        return -1;
    }

    cout << "port: " << port << endl;



    listen(sock, 1);



    cout << "listening.." << endl;

    int new_fd = accept(sock, NULL, 0); 

    close(sock);

    cout << "closed " << endl;





    //mount the file system
    FileSys fs;
    fs.mount(new_fd); //assume that sock is the new socket created 
                    //for a TCP connection between the client and the server.   
 
    cout << "Mounted..." << endl;
  
    //loop: get the command from the client and invoke the file
    //system operation which returns the results or error messages back to the clinet
    //until the client closes the TCP connection.

    string response;
    string cmd;
	string firstLevel;
	string secondLevel;
	string data; 
	string space, value, intermediate;
    int pos;

    while(true){
        if (!receive(response, new_fd))
            break;
        
        string fullMessage = response.substr(0, response.length() - 2);
        string command = fullMessage.substr(0, fullMessage.find(" "));
        
        if (command == "mkdir"){
            cmd = fullMessage.substr(5);
			cerr << "full msg: " << fullMessage << endl;
			cerr << "cmd: " << cmd << endl;
            fs.mkdir(cmd.c_str());
        }
        else if (command == "ls"){
            fs.ls();
        }
        else if (command == "cd"){
            cmd = fullMessage.substr(2);
            fs.cd(cmd.c_str());
        }
        else if (command == "home"){
            fs.home();
        }
        else if (command == "rmdir"){
            cmd = fullMessage.substr(5);
            fs.rmdir(cmd.c_str());
        }
        else if (command == "create"){
            cmd = fullMessage.substr(6);
            fs.create(cmd.c_str());
        }
        else if (command == "append"){
            cmd = fullMessage.substr(7);

			firstLevel = fullMessage.substr(7);
			secondLevel = firstLevel.substr(0, firstLevel.find(" "));
			data = firstLevel.substr(secondLevel.length() + 1);
			fs.append(secondLevel.c_str(), data.c_str());

        }
        else if (command == "stat"){
            cmd = fullMessage.substr(4);
            fs.stat(cmd.c_str());
        }
        else if (command == "cat"){
            cmd = fullMessage.substr(3);
            fs.cat(cmd.c_str());
        }
        else if (command == "head"){
            space = fullMessage.substr(0, fullMessage.find("\r\n"));
			firstLevel = space.substr(4);
			value = firstLevel.substr(1, firstLevel.find(" "));
			intermediate = firstLevel.substr(value.length()+1);
			secondLevel = intermediate.substr(0, intermediate.find(" "));
			data = intermediate.substr(secondLevel.length() + 1);		   
			fs.head(secondLevel.c_str(), stoi(data));
        }
        else if (command == "rm"){
            cmd = fullMessage.substr(2);
            fs.rm(cmd.c_str());
        }
    }
    //close the listening socket
    close(new_fd);

    //unmout the file system
    fs.unmount();

    return 0;
}

//helper function


bool receive(string &response, int sock)
{
  vector<char> msg;
  int temp = 0;
  int byteSent = 0;
  int count = 0;
  char buf;
  bool done = false;
  bool endP; false;

	while (!endP || !done)
	{
	   count = 0;

		while (count < sizeof(char))
		{
		    if ((byteSent = recv(sock, (void*)&buf, sizeof(char), 0)) == -1)
                perror("Error receiving message");

			count += byteSent;
		}

     	if (buf == '\r')
        	endP = true;

		if (buf == '\n')
			done = true;
		msg.push_back(buf);
  }
  

	response = string(msg.begin(), msg.end());

	return true;
}
