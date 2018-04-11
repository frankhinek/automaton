## gIt's Magical -  A Guide to Git

---

# Git Architecture *(todo)*

![Git Transport](http://assets.osteele.com/images/2008/git-transport.png)


#### Operations *(todo)*

--->
* add: workspace to index
* commit: index to local
* push: local to remote

<---
* pull: remote to local to index to workspace
* rebase: remote to local to index to workspace

* fetch: remote to local
* checkout: index to workspace
* diff: index to workspace compare

* stash: *todo*
* merge: *todo*

#### Terminology

* repository: *(todo)*
* headers: *(todo)*
* local: *(todo)*
* remote: *(todo)*
* clone: *(todo)*
* branch: *(todo)*
* origin: *(todo)*
* master: *(todo)*

## Basics

#### Cloning a Remote Repository
Cloning a repository is essentially copying the contents of a remote repository to your local computer. The `git clone` command with no options specified will create a folder using the name of the remote repository. For example if you `git clone https://somegitserver.com/userofgitness/all-your-gits-r-us.git` a folder named `all-your-gits-r-us` will be created and the content s of the repository will be downloaded to that folder.

If you specify a repository that is secured or private, you will be prompted for credentials. However, you can (not recommend) pass the credentials as part of the url passed to the `git clone` command. Both examples below:

###### Public or Private (no credentials):
```sh
git clone https://mygitserver/user/myproject.git
```

###### Private (username and password inline):
```sh
git clone https://user:password@mygitserver/user/myproject.git
```

#### Updating a Local Cloned Repository to the Latest Version on Server
Often the repository you have cloned will have updated made to it. You will want to grab those updates occasionally depending on how you are using the project. There are 3 main states that determine how this process works.

###### 1: No changes have been made to the original files of your local copy (added files do not apply)
```sh
# from inside the folder of the cloned repository
git pull
```

###### 2: You have modified some of the original files your local copy, but do not wish to preserve them
```sh
# from inside the folder of the cloned repository
git reset --hard
git pull
```

###### 3: You have modified some of the original files your local copy, but need to preserve them
This will revert you repository to the state it was when you cloned it in order for you to do a `git pull` but stashes any changes you have made.
```sh
# from inside the folder of the cloned repository
git stash
git pull
git apply
```

*Note: This assumes your changes do not conflict with the updated repo. If they do, see the advanced section on `git stash` and `git merge`.*

#### Local Machine Setup (globals)
If you plan to do more than simply clone repositories, you will want to setup you global identity. *Note: These commands can be ran without the `--global` inside a git folder to apply them to the single project only.*
```sh
# identity
git config --global user.name "Firstname Lastname"
git config --global user.email "user@domain.com"

# set if you are wanting to allow connections to https servers with self signed or invalid certs
git config --global http.sslVerify false

# push settings (default on new installs)
git config --global push.default simple

# preferences
git config --global core.editor vim
git config --global color.ui true

# if on osx, save git credentials into osx keychain
git config --global credential.helper osxkeychain
```

#### Creating a Local Repository
You can use git locally without access to a git server. This allows tracking of file changes and the other features of git purely local to your machine.
```sh
# create a new directory for your project
mkdir myrepo

# change to the new directory
cd myrepo

# add and modify a .gitignore file (see Appendix on .gitignore template)
touch .gitignore
vi .gitignore

# initialize the directory to be tracked via git
git init

# add all current files to be tracked for changes
git add -A

# commit the current files for their initial state
git commit -a -m "Initial commit"
```

#### Creating a Remote Repository
If you plan to store you project on a remote repository such as [github](https://github.com), the easiest way is to simply create the project there first. Github and others will walk you through setting up the repository locally in one of a few different ways:

###### 1: New Remote Repo created to be attached to a local project directory with existing content
```sh
# change to the root of your project directory
cd myrepo

# add a '.gitignore' file
touch .gitignore

# modify '.gitignore' (see Appendix on .gitignore template)
vi .gitignore

# add a project readme (if one does not already exist)
echo "# My Project" >> README.md

# initialize the directory to be tracked via git
git init

# add files to be tracked by git
git add .gitignore
git add README.md

# perform initial commit of .gitignore and readme
git commit -a -m "Initial commit"

# add the remote server where this repository will be pushed
#   ('origin' is the name of the default remote server)
git remote add origin https://mygitserver/user/myproject.git

# push the content of the current local branch and
#  link that branch to a branch on the remote
#  ('master' is the default name of the initial branch of a repository)
git push -u origin master
```

###### 2: New Remote Repo created to be attached to a new (empty) local project directory
This is by far the easiest. Simply clone your repository. The links to the remote are ready to go and you can start adding content, commits, and pushing those changes as described in more detail in following sections.
```sh
git clone https://mygitserver/user/myproject.git

# change to the new directory
cd myrepo
```

***Note**: At this point, you can begin using `git pull`, `git commit`, and `git push` without specifying the remote as the local repository is now linked to the remote.*


#### Sending Local Changes to the Remote Server
At this point, you should have a local repository linked with your local repository. This is the process to apply local changes and send them to the remote server. This assumes you are the repository owner and/or have permission to push changes to the repository directly. Otherwise, refer to the advanced section of a "Pull Request" and submitting that into a repository owned/managed by someone else.

###### 1. Verify (optional)
Before committing your changes, you may want to verify what you are about to do.
```sh
# optionally, show files that have been changed, added, or removed
git status

# optionally, show the differences to a file that is listed as changed
git diff path/to/myfile.js
```

###### 2. Commit Changes
Committing the changes, marks the changes with a comment to your LOCAL repository. This does not apply the change to the REMOTE repository. You can do several commits before updating the remote repository if desired.

```sh
# commit your changes to a single file with a inline comment (preferred)
git commit path/to/myfile.js -m "fixed function foo() to return string 'bar' instead of 'barf'"
```

```sh
# commit your changes to all modified or deleted files with a inline comment
git commit -a -m "My awesome update to everything. I hope this single line of text describes everything I did!"
```

***Note**: If you leave off the `-m "my special comment"` from the `git commit` command, you will be presented with a text editor to write the changes you are making in document form. This  is useful for large changes that may require a huge comment.*

###### 3. Update Remote Repository with your changed (commits)
"Pushing" means sending your updates to the remote repository.
```sh
git push
```

***Note**: if you are co-managing a repository with someone else, you may find that your `git push` gets rejected. This means that a change to the remote repository has been made since your last `git clone` or `git pull`. See the advanced section on merges and stashing.*



## (Semi)Advanced Git

#### Git Stash and Merge

*(todo)*

#### Managing a Single Repository Across Multiple Git Servers

Suppose you want to manage a single project but store it remote servers? For example, you may have an internal git server and also have an account on github. This goes through the process of setting that up and managing commits, merges, and/or pull requests that may be happening asynchronously on the two remote servers.

For the starting point, lets assume the following:

* Primary (internal corporate / alias 'origin') remote server is `https://git/john.dev/myproject.git`
* Secondary (alias 'github') remote server is `https://github.com/jdev/myproject.git`
* The project has two branches, `master` and `dev`
* Both remote servers are currently in sync
* The user's git configuration already has credentials stored as needed for both remote servers.

##### Local User's Setup

```sh
# init local repository
cd ~/git
mkdir myproject
cd myproject
git init

# add remote server to local repository
git remote add --tags origin https://git/john.dev/myproject.git
git remote add --tags github https://github.com/jdev/myproject.git

# verify remote servers
git remote -v

# fetch both branches from both remote servers specifying the server alias and branch name
git fetch origin
git fetch github

# verify both branches are seen for both remote servers along with local master
git branch -a
  > remotes/origin/master
  > remotes/origin/dev
  > remotes/github/master
  > remotes/github/dev

# user should still be in master branch of an empty local repository that is not linked to a remote server, verify...
git status
  >On branch master
  >nothing to commit, working directory clean

# current directory should still be empty
ls -alF
  > total 0
  > drwxr-xr-x   3 jdev  staff  102 Aug  3 14:12 ./
  > drwxr-xr-x   3 jdev  staff  102 Aug  3 14:06 ../
  > drwxr-xr-x  12 jdev  staff  408 Aug  3 14:17 .git/

# pull primary remote server's master branch into local master branch
git pull origin master

# link the current local branch(master) to a default upstream primary server master branch
git branch -u origin/master

# verify that local repository is now linked to origin
git status
  > On branch master
  > Your branch is up-to-date with 'origin/master'.

# create a new local branch that matches the 2nd branch on the remote server repo (dev)
git checkout -b dev

# user should be in new dev branch in local repository
git status
  >On branch dev
  >nothing to commit, working directory clean

# pull primary remote server's dev branch into the new local dev branch
git pull origin dev

# link the current local branch(dev) to a default upstream primary server dev branch
git branch -u origin/dev

# verify that local repository is now linked to origin
git status
  > On branch dev
  > Your branch is up-to-date with 'origin/dev'.

# switch back to local master branch
git checkout master

# verify branches (4 remote and 2 local that we linked to origin)
git branch -a
  > master
  > dev
  > remotes/origin/master
  > remotes/origin/dev
  > remotes/github/master
  > remotes/github/dev
```

Things to understand at this point:

* The local machine that performed the above work has access to 6 branches.
* Pulls, merges, joins, etc are done in the local repository. This is where you resolve conflicts, and is the authoritative source of the project as long as the git remotes do not change after a `fetch`. When pushing the changes back to the remote servers, you have the same limitations as you do with any push that is attempted when the local repos are out of sync with the remotes.
* While you *can* checkout a remote branch directly, it is checked out in a "detached state"
* Any changes made to a detached branch are essentially lost unless you create a new local branch from that detached one. This needs to be done BEFORE checking out another branch else changes are lost.
* It is not necessary to set a default upstream server, and in certain cases you may find it better not to as it forces you to be explicit with your `git push`, `git fetch` and `git pull` commands.

##### Compare Branches Across Two Remote Servers

To compare updates on remote servers, you can do the following:

```sh
# fetch updates to remote servers
git fetch origin
git fetch github

# compare remote branches
git diff origin/master github/master
git diff origin/dev github/dev
```

##### Update a Singe Branch Between Two Remote Servers (fast forward)

If a remote server gets ahead of another remote server, a case where a merge is not needed, you can do the following to fast forward one remote server to the more recent remote server.

```sh
# fetch updates to remote servers
git fetch origin
git fetch github

# compare remote branches
git diff origin/master github/master
git diff origin/dev github/dev

# select local 'dev' branch
git checkout dev

# pull in changes from github/dev to local (server that is ahead)
git pull github dev

# push changes to origin/dev (server that is behind)
git push origin dev
```

##### Merge a Single Branch Between Two Servers with Independent Commits (need to verify and double check use of --tags in push)

```sh
# fetch updates to remote servers
git fetch origin
git fetch github

# compare remote branches
git diff origin/master github/master
git diff origin/dev github/dev

# select local 'dev' branch
git checkout dev

# pull in changes from origin/dev to local (either remote should work)
git pull origin dev

# merge changes from github/dev to local (commit fast forwards)
git merge github/dev --noff --edit

# resolve conflicts...

# compare what has changed after local merge
git diff dev origin/dev
git diff dev github/dev

# push merges to both remotes
git push origin dev
git push origin dev --tags
git push github dev
git push github dev --tags
```

##### Programmatically Mirror a Repo to Another

[This](https://gitlab.presidio.com/nmarus/git-scripts-bash/blob/master/mirror.sh) is an attempt at a script that mirrors one repo with another. It does not (yet) resolve conflicts if there is a chance that the servers are getting asynchronous updates.

## Appendix

#### .gitignore Template *(todo)*
A git ignore file is named `.gitignore` and is stored in the root of your project. This file tells git what files to never track or upload to a git remote. This can be things like compiled code, log files, local database files, or downloaded dependencies that are part of the buid process.

An example .gitignore which covers some basics. However depending on you project you will want to modify this as needed.

```sh
# Folder view configuration files
.DS_Store
Desktop.ini

# Thumbnail cache files
._*
Thumbs.db

# Files that might appear on external disks
.Spotlight-V100
.Trashes

# Compiled Python files
*.pyc

# Compiled C++ files
*.out

# Platform specific files
venv
node_modules
```
