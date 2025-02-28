====================================================================================
G I T   W O R K F L O W   H O M R E A / I N S F L A
------------------------------------------------------------------------------------
Author:		Marc-Sebastian Benzinger
Revision:	22.05.2015
====================================================================================

The current document assumes that the public folder is mounted/linked into the 
users' home directories and the repositories are located at
~/public/Programme

Then HOMREA bare repository must be in: ~/public/Programme/homrea.git
Then INSFLA bare repository must be in: ~/public/Programme/insfla.git
And Libraries bare repository in:	~/public/Programme/library.git

The git templates are located at
~/public/Programme/.git-templates

"$> " - Means terminal command

In Windows you can connect public as a network drive:

$> net use X: //itt-nas/public

Then you can change "~/public" to "X:\"

For more detailing information about git, please refer to:
http://git-scm.com/doc
$> git --help

------------------------------------------------------------------------------------
1.  C L O N E   R E P O S I T O R Y
------------------------------------------------------------------------------------

1.1. Set up global config file
The first time you use git set up a global config file (~/.gitconfig) with your 
name and email:

$> git config --global user.name "Max Mustermann"
$> git config --global user.email max.mustermann@kit.edu

Also configure the template directory

$> git config --global init.templatedir ~/public/Programme/.git-templates/


------------------------------------------------------------------------------------
1.2. Clone repository
To create a new local copy of HOMREA in ~/<MyPath>:

$> git clone ~/public/Programme/homrea.git ~/<MyPath>/homrea


------------------------------------------------------------------------------------
1.3. Make own local branch
The master branch should not be used to test and debug new features. So each user 
should create at least one own local branch.

$> git branch <MyBranch>


------------------------------------------------------------------------------------
1.4. Switch between branches
You can switch between branches.

$> git checkout <MyBranch>



------------------------------------------------------------------------------------
2.  B A S I C S
------------------------------------------------------------------------------------

2.1. Status and Log

$> git status
$> git log


------------------------------------------------------------------------------------
2.2. Add, move or delete files
If you create new files you can add them to the repository.

$> git add <MyFile>

You can also move or delete files from the repository.

$> git mv <MyFile> <MyNewFile>
$> git rm <MyFile>


------------------------------------------------------------------------------------
2.3. Commit changes
Changes can be committed into a new stage. For better readability include a 
comment or description.

$> git commit -a -m <MyComment>

Or add the changes to the last stage.

$> git commit -a --amend


------------------------------------------------------------------------------------
2.4. Diff

$> git diff



------------------------------------------------------------------------------------
3.  U P D A T I N G
------------------------------------------------------------------------------------

3.1. Getting new version of master and apply it on own local branch <MyBranch>:

$> git fetch origin
$> git checkout <MyBranch>
$> git rebase origin/master
$> git checkout <MyBranch>   (This is needed to update the version file)

If a conflict occurs manually open the listed file(s) and solve the conflicts
marked with the blocks:

<<<<<<<
   <code 1>
=======
   <code 2>
>>>>>>>

then continue with:

$> git rebase --continue


------------------------------------------------------------------------------------
3.2. Change remote URL

$> git remote set-url origin <URL>
