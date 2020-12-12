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

### Q: Why Teamviewer is not recommended? Then how to use IDEs to code my
project?
A: See above. Some IDEs provides remote ssh. It might help you if you
prefer to code in IDE. Why hesitate to use Vim? Hope Emacs finds you well.Lol.
Moreover, better to provide an executable shellscript to help you run your job.

### Q: I used to code with Pycharm/VS Code, and there are some configs stored in IDE, how can I run them when I am only allowd to use ssh connection?
A: Write a shell script! Always to persist your config to disk.

### Q: I logged into server, but there's nothing in current work directory, why?
A: The admin creates a new $HOME for you.

### Q: Why I can not use arrows to track my commands history?
A: Check your default shell. Change to `bash` or `zsh` according to your
preference.

### Q: Why I can not open/enter/write/execute some files/directories?
A: Check your permisson on this file/dir. Contact the admin to modify your
permission.

### Q: Why I cannot use `conda` or `activate`?
A: Use `which conda` to check if shell can find the executable. Add the path to
your .bashrc/.zshrc.

### Q: Why I got permission denied using `sudo`?
A: The admin would not add you to the `sudo` user group. If you want to install
some packages, contact the admin. Usually, most packages are already installed.

### Q: How can I open the browser to visit a localhost web service?
A: You can expose a local web service to public via `ngrok`.

### Q: How can I view some pictures via ssh?
A: Go search on Google.

### Q: How can I send/retrive files to/from server?
A: Now the ssh is bandwidth-restrict. There would be a solution soon.

### Q: Where can I backup my directories?
A: The admin will backup your $HOME periodically.

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
style](https://google.github.io/styleguide/). Third, code review is important.
Last, dont forget to respond to issues.

### Q: I am total new to git/GitHub, where should I start?
A: [git](https://git-scm.com/) and [GitHub](https://github.com/).

