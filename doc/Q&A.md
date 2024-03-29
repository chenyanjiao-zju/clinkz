
### Q: What if those Q&A cannot help me solve my problem?
A: If you can NOT solve the problem yourself, write to the mailing list
__server-maintain@googlegroups.com__. Please read [How To Ask Questions The Smart Way
](http://www.catb.org/~esr/faqs/smart-questions.html) first. Please do not
bother admin in private chat.

## On server

### Q: How can I access the server?
A: There are some ways:

1. Teamviewer, [NOT recommend]. Teamviewer is based on monitor, and we'd not
spend time on virtual monitor or something else, though Teamviewer is convient
and fast in file transfer. Another point is that we want to enable more
functionalies such like limit process resource, job notification, etc. It would
be better to integate using CLI. Last, monitor would consume the GPU resource,
	 we want GPU to better serve our machine learning job.
2. Sunclient, [Not recommend]. Same as above.
3. ssh. Direct connect via ssh if you resides in the same LAN with server, e.g,
		you work at room B508 or B704, and start to work! However, some fellow group
		members cannot access server in this way. Thus the admin provides an intranet
		penetration via a relay node with public IP address. But the bandwidth is
		restrict to 1M. So using `scp` to send a large file is not recommended.

### Q: Why Teamviewer is not recommended? Then how to use IDEs to code my project?
A: See above. Some IDEs provides remote ssh. It might help you if you
prefer to code in IDE. Why hesitate to use Vim? Hope Emacs finds you well.Lol.
Moreover, better to provide an executable shellscript to help you run your job.

### Q: I used to code with Pycharm/VS Code, and there are some configs stored in IDE, how can I run them when I am only allowd to use ssh connection?
A: Write a shell script! Always to persist your config to disk.

### Q: I got Permissioned Denied when using ssh nor scp, why?
A: Check your command first, make sure you have specified the -oPort option. And
If you changed your profile just now that made you enable to login, for example,
   you specifed a wrong path for your default shell, contact the admin to help
   you.

### Q: I logged into server, but there's nothing in current work directory, why?
A: The admin creates a new $HOME for you.

### Q: Why I can not use arrows to track my commands history, neither tab auto-complete?
A: Check your default shell. Change to `bash` or `zsh` according to your
preference. Remember if you are using conda, it would be better to use bash.

### Q: Why I can not open/enter/write/execute some files/directories?
A: Check your permisson on this file/dir. Contact the admin to modify your
permission.

### Q: Why I cannot use `conda` or `activate`?
A: Use `which conda` to check if shell can find the executable. Add the path to
your .bashrc/.zshrc. It is a legacy that former user didn't install `conda` to
the system wide. Now `conda` has been installed to `/usr/bin/conda`, and the
installation dir is at `/opt/anaconda3` or 'opt/anaconda' (check it in your
machine), you shall have been added to the
`condagp` group to have permission on conda. You should run your task in your
own virtual environment. 

The admin have chosen to not have conda modify your shell scripts at all.
To activate conda's base environment in your current shell session:

eval "$(/opt/anaconda/bin/conda shell.YOUR\_SHELL\_NAME hook)"

Replace YOUR\_SHELL\_NAME with bash or zsh.

To install conda's shell functions for easier access, first activate, then:

conda init

If you'd prefer that conda's base environment not be activated on startup,
   set the auto\_activate\_base parameter to false:

conda config --set auto\_activate\_base false

Thank you for installing Anaconda3!

One last thing to remember that you'd better keep your env under your own home,
try to configure your `.condarc', keep your envs and pkgs to home dir prior to
the global dir in /opt/anaconda. You can use 'conda info' to check your
configuration.

If you have any problem with conda, try to refer its manual first and then try
to seek help from mailing list.

### Q: How can I know if there is anyone else running jobs on CPU/GPU?
A: At present, we have 2 __NVIDIA GeForce GTX 1080 Ti__ GPUs on each server. You
can use `nvidia-smi` to check the process id which is using GPU. Moreover, you
can use `ps` to check who is using (usually, the admin choose our fellow group
member's name as his/her user id). Start your job early, since there might be
more people running jobs the day before group meeting.

### Q: Why I got permission denied using `sudo`?
A: The admin would not add you to the `sudo` user group. If you want to install
some packages, contact the admin. Usually, most packages are already installed.

### Q: How can I open the browser to visit a localhost web service?
A: You can expose a local web service to public via `ngrok`.

### Q: How can I view some pictures via ssh?
A: There are several ways indeed, like `eog` with ssh X forwarding. However, it
does not work right now. (if you solved this, please update). Thus, you can
download your pictures via `scp` as a work arround.

### Q: How can I send/retrive files to/from server?
A: Now the ssh is bandwidth-restrict. There would be a solution soon.

### Q: Where can I backup my directories?
A: The admin will backup your $HOME periodically, in every Wed & Sat morning at 6
am.

### Q: Is there any notification I can receive about the status of server?
A: We are considering this. Currently, we release messages in our group chat.

### Q: Can I participate in server maintaining?
A: Yes. Your PR is really appreciated.

## On code hosting

### Q: Which version control tool do we use?
A: GitHub.

### Q: How can I contribute code to our lab?
A: We have our own organization at GitHub. Contact the admin to send you an
invitation to join our org!

### Q: What should I do when I import/create a repo under our organization?
A: First, keep the repo in private, and think twice before you make public of
the repository. Second, you should provide detailed documentation on how to
reproduce your results of experients as well as how to make use of your work.
You should prepare a shell script for others to have a quick start! Always
document your code! One reason is for later fellow group members to catch up
existing work and maybe he/she is the one who helps you revise your
paper/experiment. Use sphinx/doxygen and obey the [google coding
style](https://google.github.io/styleguide/). Third, code review is important
and dont forget to respond to issues. Last, YOU SHOULD ALWAYS REMEMBER NOT TO
LEAK ANY PASSWORD OR PRIVATE INFOMATION IN YOUR REPOSITORY especailly you are
about to make public the repo.

### Q: I am total new to git/GitHub, where should I start?
A: [git](https://git-scm.com/) and [GitHub](https://github.com/).

