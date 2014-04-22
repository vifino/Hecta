]-[ : The other bot. 
===

]-[ is a bot all about control, letting users do what they want, just like a shell.

It is expandable, very simply, just by adding a file to the modules directory.
Lets call this file "mymodule.lua", note the extension.
This file doesn't have to contain anything, but better have.
The basic content of that file is a function with certain arguments. Here is a very basic module:

local function myfunc(text,nick, channel)

  -- Text is the input, aka "$myfunc My very input text".
  
  -- Nick is the username the person has, who issued the command.
  
  -- Channel is the channel the command came from, if the commands are issued from a PM, the channel is going to be the nickname of the user.

end
commands["myfunc"] = myfunc -- Makes the command available.

Made by vifino
