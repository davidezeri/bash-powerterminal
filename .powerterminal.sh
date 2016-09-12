# Unicode symbols
readonly PS_SYMBOL_DARWIN=''
readonly PS_SYMBOL_LINUX='$'
readonly PS_SYMBOL_OTHER='%'
readonly GIT_BRANCH_SYMBOL='⑂ '
readonly GIT_BRANCH_CHANGED_SYMBOL='+'
readonly GIT_NEED_PUSH_SYMBOL='⇡'
readonly GIT_NEED_PULL_SYMBOL='⇣'

# Reset
Color_Off='\[\e[0m\]'       # Text Reset

# Regular Colors
Black='\[\e[0;30m\]'        # Nero
Red='\[\e[0;31m\]'          # Rosso
Green='\[\e[0;32m\]'        # Verde
Yellow='\[\e[0;33m\]'       # Giallo
Blue='\[\e[0;34m\]'         # Blu
Purple='\[\e[0;35m\]'       # Viola
Cyan='\[\e[0;36m\]'         # Ciano
White='\[\e[0;37m\]'        # Bianco

# Bold
BBlack='\[\e[1;30m\]'       # Nero
BRed='\[\e[1;31m\]'         # Rosso
BGreen='\[\e[1;32m\]'       # Verde
BYellow='\[\e[1;33m\]'      # Giallo
BBlue='\[\e[1;34m\]'        # Blu
BPurple='\[\e[1;35m\]'      # Viola
BCyan='\[\e[1;36m\]'        # Ciano
BWhite='\[\e[1;37m\]'       # Bianco

# Underline
UBlack='\[\e[4;30m\]'       # Nero
URed='\[\e[4;31m\]'         # Rosso
UGreen='\[\e[4;32m\]'       # Verde
UYellow='\[\e[4;33m\]'      # Giallo
UBlue='\[\e[4;34m\]'        # Blu
UPurple='\[\e[4;35m\]'      # Viola
UCyan='\[\e[4;36m\]'        # Ciano
UWhite='\[\e[4;37m\]'       # Bianco

# Background
On_Black='\[\e[40m\]'       # Nero
On_Red='\[\e[41m\]'         # Rosso
On_Green='\[\e[42m\]'       # Verde
On_Yellow='\[\e[43m\]'      # Giallo
On_Blue='\[\e[44m\]'        # Blu
On_Purple='\[\e[45m\]'      # Purple
On_Cyan='\[\e[46m\]'        # Ciano
On_White='\[\e[47m\]'       # Bianco

# High Intensty
IBlack='\[\e[0;90m\]'       # Nero
IRed='\[\e[0;91m\]'         # Rosso
IGreen='\[\e[0;92m\]'       # Verde
IYellow='\[\e[0;93m\]'      # Giallo
IBlue='\[\e[0;94m\]'        # Blu
IPurple='\[\e[0;95m\]'      # Viola
ICyan='\[\e[0;96m\]'        # Ciano
IWhite='\[\e[0;97m\]'       # Bianco

# Bold High Intensty
BIBlack='\[\e[1;90m\]'      # Nero
BIRed='\[\e[1;91m\]'        # Rosso
BIGreen='\[\e[1;92m\]'      # Verde
BIYellow='\[\e[1;93m\]'     # Giallo
BIBlue='\[\e[1;94m\]'       # Blu
BIPurple='\[\e[1;95m\]'     # Viola
BICyan='\[\e[1;96m\]'       # Ciano
BIWhite='\[\e[1;97m\]'      # Bianco

# High Intensty backgrounds
On_IBlack='\[\e[0;100m\]'   # Nero
On_IRed='\[\e[0;101m\]'     # Rosso
On_IGreen='\[\e[0;102m\]'   # Verde
On_IYellow='\[\e[0;103m\]'  # Giallo
On_IBlue='\[\e[0;104m\]'    # Blu
On_IPurple='\[\e[10;95m\]'  # Viola
On_ICyan='\[\e[0;106m\]'    # Ciano
On_IWhite='\[\e[0;107m\]'   # Bianco


# get docker version
function docker_version() {
	echo "`docker -v | cut -d " " -f 3 | cut -d "," -f 1`"
}

# get git user
function git_user(){
	echo "`git config user.name`"
}

# get file count current level !! NOT RECURSIVE
function file_count() {
	COMM="`find $pwd -maxdepth 1 | wc -l`"
	echo "$(expr $COMM - 1)"
}

function git_info() { 
	[ -x "$(which git)" ] || return    # git not found

	local git_eng="env LANG=C git"   # force git output in English to make our work easier
	# get current branch name or short SHA1 hash for detached head
	local branch="$($git_eng symbolic-ref --short HEAD 2>/dev/null || $git_eng describe --tags --always 2>/dev/null)"
	[ -n "$branch" ] || return  # git branch not found

	local marks

	# branch is modified?
	[ -n "$($git_eng status --porcelain)" ] && marks+=" $GIT_BRANCH_CHANGED_SYMBOL"

	# how many commits local branch is ahead/behind of remote?
	local stat="$($git_eng status --porcelain --branch | grep '^##' | grep -o '\[.\+\]$')"
	local aheadN="$(echo $stat | grep -o 'ahead [[:digit:]]\+' | grep -o '[[:digit:]]\+')"
	local behindN="$(echo $stat | grep -o 'behind [[:digit:]]\+' | grep -o '[[:digit:]]\+')"
	[ -n "$aheadN" ] && marks+=" $GIT_NEED_PUSH_SYMBOL$aheadN"
	[ -n "$behindN" ] && marks+=" $GIT_NEED_PULL_SYMBOL$behindN"

	# print the git branch segment without a trailing newline
	printf " $GIT_BRANCH_SYMBOL$branch$marks "
}


#export PS1="${IYellow}[\d \t]${Color_Off}" #date
export PS1="${IYellow}git:[\`git_user\`]${Color_Off}" #name
PS1+="${On_Green}\u${Color_Off}" #name
PS1+="${On_Red}\`docker_version\`${Color_Off}" #docker version
PS1+=":"
PS1+="${IPurple}[\w]${Color_Off}" #path
PS1+="${On_Cyan}\`file_count\`${Color_Off}" #file count
PS1+="${On_Blue}\`git_info\`${Color_Off}" #git branch
PS1+="$ "






