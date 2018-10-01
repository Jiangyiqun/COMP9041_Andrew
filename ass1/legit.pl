#!/usr/bin/perl
# author: Jack Jiang
# date: 29th Sep. 2018
# legit implementation, for COMP9041 assignment 1 at 2018 S2



############################ Use Packages ##############################
use strict;
use warnings;
use File::Path qw(make_path remove_tree);
use File::Copy::Recursive qw(dircopy);
use File::Copy;
use File::Compare;



########################## Global Variables ############################
our $HEAD = ".legit/HEAD";
our $INDEX = ".legit/index";
our $OBJECTS = ".legit/objects";
our $COMMIT = ".legit/objects/commit";
our $BRANCH = ".legit/objects/branch";
our $USAGE =<<EOF;
Usage: legit.pl <command> [<args>]

These are the legit commands:
   init       Create an empty legit repository
   add        Add file contents to the index
   commit     Record changes to the repository
   log        Show commit log
   show       Show file at particular state
   rm         Remove files from the current directory and from the index
   status     Show the status of files in the current directory, index, and repository
   branch     list, create or delete a branch
   checkout   Switch branches or restore current directory files
   merge      Join two development histories together

EOF



#################### Internal Data Storage Function ####################
sub read_head {
    # Usage: (my $c_branch, my $l_commit) = read_head()
    open(F, "<$HEAD") or die "Couldn't open file $HEAD, $!";
    my @head = <F>;
    $head[0] =~ s/current branch: //;
    chomp $head[0];
    $head[1] =~ s/last commit: //;
    chomp $head[1];
    close F;
    return $head[0], $head[1];
}



sub write_head {
    my $c_branch = shift @_;
    my $l_commit = shift @_;
    open(F, ">$HEAD") or die "Couldn't open file $HEAD, $!";
    print F "current branch: $c_branch\n";
    print F "last commit: $l_commit";
    close F;
}



sub write_msg {
    my $commit = shift @_;
    my $msg = shift @_;
    my $path = $COMMIT."/".$commit.".commit";
    open(F, ">$path") or die "Couldn't open file $path, $!";
    print F "$msg";
    close F;
}



sub read_msg {
    my $commit = shift @_;
    my $path = $COMMIT."/".$commit.".commit";
    open(F, "<$path") or die "Couldn't open file $path, $!";
    my @file = <F>;
    close F;
    return $file[0];
}



sub write_branch {
    my $branch = shift @_;
    my $commit = shift @_;
    my $path = $BRANCH."/"."$branch";
    open(F, ">>$path") or die "Couldn't open file $path, $!";
    print F "$commit ";
    close F;
}



sub read_branch {
    # Usage: my @commits = read_branch($branch)
    my $branch = shift @_;
    my @file;
    my $path = $BRANCH."/"."$branch";
    open(F, "<$path") or die "Couldn't open file $path, $!";
    @file = <F>;
    close F;
    my @commits = split /\s+/, $file[-1];
    return @commits;
}



############################# Helper Functions #########################
sub is_first_commit {
    (my $c_branch, my $l_commit) = read_head();
    if ($l_commit == -1) {
        return 1; # true
    } else {
        return 0; # false
    }
}



sub exit_if_no_commit {
    if (is_first_commit) {
        print "legit.pl: error: your repository does not have any"
                ." commits yet\n";
        exit 1;
    }
}



sub compare_dir {
    # Return 1: not identical; 0: identical
    my $left_dir = shift @_;
    my $right_dir = shift @_;
    my @left_glob = glob($left_dir."/*");
    my @right_glob = glob($right_dir."/*");
    my %left_hash;
    my %right_hash;
    foreach my $glob (@left_glob) {
        my $name = $glob;
        $name =~ s|^.*\/||;
        $left_hash{$name} = $glob;
    }
    foreach my $glob (@right_glob) {
        my $name = $glob;
        $name =~ s|^.*\/||;
        $right_hash{$name} = $glob;
    }
    # check number of files
    if (scalar @left_glob != scalar @right_glob) {
        # print "number is different\n";
        return 1;
    }
    # check file names
    foreach my $name (keys %left_hash) {
        if (not exists $right_hash{$name}) {
            return 1;
        }
        if (compare($left_hash{$name}, $right_hash{$name}) != 0) {
            return 1;
        }
    }
    return 0;
}



# acknowlegement:
#   this functions comes from an article
#   written by Jason McVeigh of Orillia, ON, CA
#   at https://coderwall.com/p/uawhga/perl-sets
#   modifeid by Jack Jiang for this assignment.
sub array_to_set {
    my @array = @_;
    my (%set,@set);
    foreach my $item (@array) {
        $set{$item} = 1;
    }
    @set = sort keys %set;
    return @set;
}



# acknowlegement:
#   this functions comes from an article
#   written by Jason McVeigh of Orillia, ON, CA
#   at https://coderwall.com/p/uawhga/perl-sets
#   modifeid by Jack Jiang for this assignment.
sub is_element_of {
    # usage: is_element_of($element,@set);
    # returns 1 if $element is a member of @set
    my $item = shift;
    return 1 if grep { $item eq $_ }@_;
}



sub get_status {
    # Status table:
    # index|./  |commit|status
    # -----|----|------|-------------------------------------------------
    #  no  |no  | _    |deleted
    #  no  |A   | _    |untracked
    #  A   |_   | no   |added to index
    #  A   |no  | A    |file deleted
    #  A   |A   | A    |same as repo
    #  A   |B   | A    |file changed, changes not staged for commit
    #  A   |no  | B    |added to index
    #  A   |A   | B    |file changed, changes staged for commit
    #  A   |~A  | B    |file changed, different changes staged for commit
    
    # get last commit of current branch
    (my $c_branch, my $l_commit) = read_head();
    my @commits = read_branch($c_branch);
    my $c_commit = $commits[-1];
    # get files in three tree structure
    my @working_files = glob("*");
    my @index_files;
    my @commit_files;
    my @index_glob = glob($INDEX."/*");
    foreach my $file (@index_glob) {
        $file =~ s|^$INDEX\/||;
        push @index_files, $file;
    }
    my @commit_glob = glob($COMMIT."/".$c_commit."/*");
    foreach my $file (@commit_glob) {
        $file =~ s|^$COMMIT\/$c_commit\/||;
        push @commit_files, $file;
    }
    # get union set
    my @union = array_to_set(@working_files,
             @index_files, @commit_files);
    # generate the status hash
    my %status;
    foreach my $file (@union) {
        my $index_file = $INDEX."/".$file;
        my $commit_file = $COMMIT."/".$c_commit."/".$file;
        # file is not in index
        if (not is_element_of($file, @index_files)) 
        {
            # file not in working directory
            if (not is_element_of($file, @working_files))
            {
                $status{$file} = "deleted";
            }
            # file in working directory
            else
            {
                $status{$file} = "untracked";
            }
        }
        # file is in index
        else 
        {
            # file is not in commit
            if (not is_element_of($file, @commit_files))
            {
                # print @commit_files;
                $status{$file} = "added to index";
            }
            # file in commit is the same as file in index
            elsif (compare($commit_file, $index_file) == 0)
            {
                # file is not in working directory
                if (not is_element_of($file, @working_files))
                {
                    $status{$file} = "file deleted";
                }
                # file in working directory is the same as file in index
                elsif (compare($file, $index_file) == 0)
                {
                    $status{$file} = "same as repo";
                }
                # file in working directory is different than file in index
                else
                {
                    $status{$file} = "file changed, changes not staged for commit";
                }
            }
            # file in commit is different than file in index
            else
            {
                # file is not in working directory
                if (not is_element_of($file, @working_files))
                {
                    $status{$file} = "added to index";
                }
                # file in working directory is the same as file in index
                elsif (compare($file, $index_file) == 0)
                {
                    $status{$file} = "file changed, changes staged for commit";
                }
                # file in working directory is different than file in index
                else
                {
                    $status{$file} = "file changed, different changes staged for commit";
                }
            }
        }
    }
    return %status;
}



sub commit {
    # do the real stuff on internal storage for commit
    my $message = shift @_;
    (my $c_branch, my $l_commit) = read_head();
    my $c_commit = $l_commit + 1;
    # copy index to commit
    my $commit_path = $COMMIT."/".$c_commit;
    # print "copy to", $INDEX, $commit_path, "\n";
    dircopy($INDEX, $commit_path)
            or die("Could not copy path: $!\n");
    # write commit message
    write_msg($c_commit, $message);
    # update HEAD to increase last commit
    write_head($c_branch, $c_commit);
    # update branch file
    write_branch($c_branch, $c_commit);
    # print commit information
    print "Committed as commit $c_commit\n";
    exit 0;
}



sub get_rm_permission {
    # permission level talbe:
    # - force mode (both cached and non-cached):
    # index|./  |commit|status
    # -----|----|------|-------------------------------------------------
    # no  | _  | _    |'x' is not in the legit repository

    # - cached mode (non-force)
    # index|./  |commit|status
    # -----|----|------|-------------------------------------------------
    # B   | A  | C    |'a' in index is different to both working file and repository

    # - non-cached mode (non-force):
    # index|./  |commit  |status
    # -----|----|--------|-------------------------------------------------
    # A   | A  | ~A     |'b' has changes staged in the index
    # ~A  | A  | A      |'c' in repository is different to working file

    # - free mode
    # index|./  |commit|status
    # -----|----|------|-------------------------------------------------
    # A   | A  | A    |free to remove
    # A   | no | A    |free to remove

    my $cached = shift @_; # 1: true 0: false
    my $force = shift @_; # 1: true 0: false
    my @files = @_;
    # get last commit of current branch
    (my $c_branch, my $l_commit) = read_head();
    my @commits = read_branch($c_branch);
    my $c_commit = $commits[-1];
    # check permission of each file
    foreach my $file (@files) {
        my $working_file = $file;
        my $index_file = $INDEX."/".$file;
        my $commit_file = $COMMIT."/".$c_commit."/".$file;
        # - force mode (both cached and non-cached):
        if (not -f $index_file) {
            print "legit.pl: error: \'$file\' is not in the legit"
                    ." repository\n";
            exit 1;
        }
        # - cached mode (non-force), index exist
        if (not $force) {
            if ((-f $working_file)
                and (compare($index_file, $working_file) != 0)
                and (compare($working_file, $commit_file) != 0)
                and (compare($commit_file, $index_file) != 0)
            ) 
            {
                print "legit.pl: error: \'$file\' in index is different"
                        ." to both working file and repository\n";
                exit 1;
            }
            # - non-cached mode (non-force):
            if (not $cached) {
                if ((-f $working_file)
                    and (compare($index_file, $working_file) == 0)
                    and (compare($index_file, $commit_file) != 0)
                ) 
                {
                    print "legit.pl: error: \'$file\' has changes staged in"
                            ." the index\n";
                    exit 1;
                }
                if ((-f $working_file)
                    and (compare($index_file, $working_file) != 0)
                    and ((compare($index_file, $commit_file) == 0)
                        or (compare($working_file, $commit_file) == 0)
                        )
                ) 
                {
                    print "legit.pl: error: \'$file\' in repository is"
                            ." different to working file\n";
                    exit 1;
                }
            }
        }
    }
}



sub merge {
    my $c_commit = shift @_;
    my $m_commit = shift @_;
    my $message = shift @_;
    my @c_commit_glob = glob($COMMIT."/".$c_commit."/*");
    my @m_commit_glob = glob($COMMIT."/".$m_commit."/*");
    my @c_commit_files;
    my @m_commit_files;
    my @can_not_merge;
    foreach my $item (@c_commit_glob) {
        $item =~ s|^$COMMIT\/$c_commit\/||;
        push @c_commit_files, $item;
    }
    foreach my $item (@m_commit_glob) {
        $item =~ s|^$COMMIT\/$m_commit\/||;
        push @m_commit_files, $item;
    }
    # print @c_commit_files, "\n";
    # print @m_commit_files, "\n";
    my @common_files;
    foreach my $item (@c_commit_files) {
        push @common_files, $item if grep {  $item eq $_ } @m_commit_files;
    }
    for my $file (@common_files) {
        my $c_commit_file = $COMMIT."/".$c_commit."/".$file;
        my $m_commit_file = $COMMIT."/".$m_commit."/".$file;
        # print $c_commit_file, "\n", $m_commit_file, "\n";
        # different files can not be merged
        if (compare($c_commit_file, $m_commit_file) == 1) {
            print $file;
            push @can_not_merge, $file;
        }
    }
    if (scalar @can_not_merge != 0) {
        print "legit.pl: error: These files can not be merged:\n";
        foreach my $file (@can_not_merge) {
            print $file, "\n";
        }
        exit 1;
    } else {    # merge and commit
        foreach my $path (@c_commit_glob) {
            copy($path, $INDEX) or die "Could not copy: $!\n";
        }
        foreach my $path (@m_commit_glob) {
            copy($path, $INDEX) or die "Could not copy: $!\n";
        }
        commit($message);
        exit 0;
    }
}



sub merge_commit {
    # get m_commit
    my $m_commit = shift @_;
    my $message = shift @_;
    # get c_commits
    (my $c_branch, my $l_commit) = read_head();
    my @c_commits = read_branch($c_branch);
    if (is_element_of($m_commit,@c_commits)) {
        print "Already up to date\n";
        exit 0;
    } 
    merge($c_commits[-1], $m_commit, $message);
    # add m_commit to branch
    my @m_commits;
    @c_commits = read_branch($c_branch);
    foreach my $item (@c_commits) {
        ;
    }
    # my $path = $BRANCH."/"."$branch";
    # open(F, ">>$path") or die "Couldn't open file $path, $!";
    # print F " $commit";
    # close F;
}



sub merge_branch {
    my $m_branch = shift @_;
    (my $c_branch, my $l_commit) = read_head();
    my @m_commits = read_branch($m_branch);
    my @c_commits = read_branch($c_branch);
    # calculate the difference between two set
    my @m_c;
    foreach my $item (@m_commits) {
        push @m_c, $item unless grep { $item eq $_ } @c_commits;
    }
    my @c_m;
    foreach my $item (@c_commits) {
        push @c_m, $item unless grep { $item eq $_ } @m_commits;
    }
    # merge branch is subset of current branch (or equal)
    if (scalar @m_c == 0) {
        print "Already up to date\n";
        exit 0;
    } 
    # current branch is subset of merge branch
    elsif (scalar @c_m == 0) {
        my $m_branch_path = $BRANCH."/".$m_branch;
        my $c_branch_path = $BRANCH."/".$c_branch;
        copy($m_branch_path, $c_branch_path)
                or die "Could not copy: $!\n";
        print "Fast-forward: no commit created\n";
        exit 0;
    } else {
        # normal merge
        ;
    }
}



############################# Command Functions ########################
sub init {
    if (-e ".legit") {
        print "legit.pl: error: .legit already exists\n";
        exit 1;
    } else {
        # init folders
        my @create = make_path(
                ".legit",
                $INDEX,
                $OBJECTS,
                $COMMIT,
                $BRANCH
                );
        # init HEAD
        open(F, ">$HEAD") or die "Couldn't open file $HEAD, $!";
        print F "current branch: master\n";
        print F "last commit: -1\n";
        close F;
        # init branch
        open(F, ">$BRANCH/master")
                or die "Couldn't open file $BRANCH/master, $!";
        print F "";
        close F;
        # print succuss information
        print "Initialized empty legit repository in .legit\n";
    }
}



sub add {
    # no args
    my @args = @_;
    if (not @args) {
        print "legit.pl: error: internal error Nothing specified, nothing added.\n";
        exit 1;
    } 
    # add file to index
    foreach my $file (@args) {
        # file exist in working directory
        if (-f $file) {
            copy("$file","$INDEX")
                    or die "Cound not copy $file: $!\n";
        } 
        # file not exist in working directory, but exist in index
        elsif (-f $INDEX."/".$file) {
            unlink $INDEX."/".$file 
                    or die "could not remove index: $!\n";
        } 
        # file does not exist in working directory nor index
        else {    
            print "legit.pl: error: can not open \'$file\'\n";
            exit 1;
        }
    }
}



sub legit_commit {
    my @args = @_;
    my $message;
    my $nothing_to_commit = 1; # 1: true  0: false
    if (is_first_commit) {
        if (glob($INDEX."/*")) {
            $nothing_to_commit = 0;
        }
    }
    # legit.pl commit -m message
    if (scalar @args == 2 and $args[0] eq "-m") 
    {
        $message = $args[1];
        if (not is_first_commit) {
            # get last commit of current branch
            (my $c_branch, my $l_commit) = read_head();
            my @commits = read_branch($c_branch);
            my $c_commit = $commits[-1];
            if (compare_dir($INDEX, $COMMIT."/".$c_commit) != 0) {
                $nothing_to_commit = 0;
            }
        }
    } 
    # legit.pl commit -a -m message
    elsif (scalar @args == 3 and $args[0] eq "-a" and $args[1] eq "-m") 
    {
        $message = $args[2];
        if (not is_first_commit) {
            my %status = get_status();
            foreach my $file (sort keys %status) {
                if ($status{$file} eq "added to index") {
                    $nothing_to_commit = 0;
                } elsif ($status{$file} eq "deleted") {
                    $nothing_to_commit = 0;
                } elsif ($status{$file} eq "file deleted") {
                    $nothing_to_commit = 0;
                    unlink $INDEX."/".$file 
                            or die "could not remove index: $!\n";
                } elsif ($status{$file} eq
                        "file changed, changes not staged for commit") {
                    $nothing_to_commit = 0;
                    push(my @array, $file);
                    add(@array);
                } elsif ($status{$file} eq
                        "file changed, changes staged for commit") {
                    $nothing_to_commit = 0;
                } elsif ($status{$file} eq
                        "file changed, different changes staged for commit")
                {
                    $nothing_to_commit = 0;
                    push(my @array, $file);
                    add(@array);
                } else {
                    ;
                }
            }
        }
    } 
    # error handler
    else 
    {
        print "usage: legit.pl commit [-a] -m commit-message\n";
        exit 1;
    }

    if ($nothing_to_commit == 1) {
        # do not commit
        print "nothing to commit\n";
    } else {
        # do the real commit 
        commit($message);
    }
}



sub legit_log {
    # get current branch
    (my $c_branch, my $l_commit) = read_head();
    # get commits in current branch
    my @commits = read_branch($c_branch);
    foreach my $commit (reverse @commits) {
        # get commit message for each commit
        my $msg = read_msg($commit);
        print "$commit $msg\n";
    }
}



sub show {
    my @args = @_;
    my $file_path;
    if (scalar @args == 1) {
        if ( $args[0] =~ /^([^:]):(.+)$/ ) {
            # get commit path
            my $commit = $1;
            my $commit_path = "$COMMIT"."/"."$commit";
            # get file and file_path
            if (not -d $commit_path) {
                print "legit.pl: error: unknown commit \'$commit\'\n";
                exit 1;
            }
            my $file = $2;
            $file_path = $commit_path."/"."$file";
            # file not exist in commit
            if (not -f $file_path) {
                print "legit.pl: error: \'$file\' not found in commit $commit\n";
                exit 1;
            }
        } elsif ( $args[0] =~ /^:(.+)$/ ) {
            # get file and file_path
            my $file = $1;
            $file_path = $INDEX."/".$file;
            # file not exist in index
            if (not -f $file_path) {
                print "legit.pl: error: \'$file\' not found in index\n";
                exit 1;
            }
        } else {
            print "legit.pl: error: invalid object $args[0]\n";
            exit 1;
        }
        # show file
        open(F, "<$file_path")
                or die "Couldn't open file $file_path, $!";
        print while (<F>);
        close F;
        exit 0;
    } 
    # wrong number of args
    print "usage: legit.pl show <commit>:<filename>\n";
    exit 1;
}



sub legit_status {
    my %status = get_status();
    foreach my $file (sort keys %status) {
        print "$file - $status{$file}\n";
    }
}



sub legit_rm {
    my @args = @_;
    my @files;  # file path in working directory
    my @index_files; # file path in index region
    my $cached = 0; # 1: cached 0: not cached
    my $force = 0; # 1: force 0: not force
    # parse the arguments
    foreach my $arg (@args) {
        if ($arg eq "--cached") {
            $cached = 1;
        } elsif ($arg eq "--force") {
            $force = 1;
        } else {
            push @files, $arg;
        }
    }
    # error handler
    if (not @files) {
        print "usage: legit.pl rm [--force] [--cached] <filenames>\n";
        exit 1;
    }
    # if not exit, mean we can safetly remove all files
    get_rm_permission($cached, $force, @files);
    # get index files list
    foreach my $file(@files) {
        push @index_files, $INDEX."/".$file;
    } 
    # actually remove file
    unlink @index_files;
    unlink @files if ($cached == 0);
}



sub legit_branch {
    my @args = @_;
    my $branch_name;
    (my $c_branch, my $l_commit) = read_head();
    my $c_branch_path = $BRANCH."/".$c_branch;
     # show branch
    if (scalar @args == 0)
    {
        my @branches;
        my @branches_glob = glob($BRANCH."/*");
        foreach my $branch (@branches_glob) {
            $branch =~ s|^$BRANCH\/||;
            push @branches, $branch;
        }
        foreach my $branch (sort @branches_glob) {
            print $branch, "\n";
        }
        exit 0;
    } 
    # create branch
    elsif (scalar @args == 1)
    {
        $branch_name = shift @args;
        if (not $branch_name =~ /^[a-zA-Z0-9]\S*/) {
            print "usage: legit.pl branch [-d] <branch>\n";
            exit 1;
        } else {
            # print "create $branch_name\n";
            my $new_branch_path = $BRANCH."/".$branch_name;
            if (-f $new_branch_path) {
                print "legit.pl: error: branch \'$branch_name\'"
                        ." already exists\n";
                exit 1;
            } else {
                copy($c_branch_path, $new_branch_path)
                        or die "Could not copy $new_branch_path: $!\n";
                exit 0;
            }
        }
    } 
    # remove branch
    elsif (scalar @args == 2)
    {
        # get branch_name
        if ($args[0] eq "-d") {
            $branch_name = $args[1];
        } elsif ($args[1] eq "-d") {
            $branch_name = $args[0];
        } else {
           print "usage: legit.pl branch [-d] <branch>\n";
           exit 1;
        }
        if (not $branch_name =~ /^[a-zA-Z0-9]\S*/) {
            print "usage: legit.pl branch [-d] <branch>\n";
            exit 1;
        } else {
            # print "remove $branch_name\n";
            my $branch_path = $BRANCH."/".$branch_name;
            # could not remove master branch
            if ($branch_name eq "master") {
                print "legit.pl: error: can not delete branch"
                        ." \'master\'\n";
                exit 1;
            }
            # could not remove current branch
            if ($branch_name eq $c_branch) {
                print "legit.pl: error: can not delete current branch"
                        ."\'$branch_name\'\n";
                exit 1;
            }
            if (not -f $branch_path) {
                print "legit.pl: error: branch \'$branch_name\'"
                        ." does not exist\n";
                exit 1;
            }
            unlink $branch_path
                    or die "Could not remove $branch_name: $!\n";
            exit 0;
        }
    } 
    # bad args
    else
    {
        print "usage: legit.pl branch [-d] <branch>\n";
        exit 1;
    }
}



sub checkout {
    my @args = @_;
    # bad args
    if (scalar @args != 1) {
        print "usage: legit.pl checkout <branch>\n";
        exit 1;
    } 
    # get branch information
    my $n_branch = shift @args;
    my $n_branch_path = $BRANCH."/".$n_branch;
    (my $c_branch, my $l_commit) = read_head();
    # branch does not exit
    if (not -f $n_branch_path) {
        print "legit.pl: error: branch \'$n_branch\' does not exist\n";
        exit 1;
    }
    # already on branch
    if ($n_branch eq $c_branch) {
        print "Already on \'$n_branch\'\n";
        exit 1;
    }
    # checkout new branch
    write_head($n_branch, $l_commit);
    print "Switched to branch \'$n_branch\'\n";
}



sub legit_merge {
    my @args = @_;
    my $m_commit; # commit number which merged from
    # empty commit message
    if (scalar @args == 1)
    {
        if ($args[0] eq "-m") {
            print "usage: legit.pl merge <branch|commit> -m message\n";
        } else {
            print "legit.pl: error: empty commit message\n";
        }
        exit 1;
    } 
    elsif (scalar @args == 3) 
    {
        if ($args[1] ne "-m") {
            print "usage: legit.pl merge <branch|commit> -m message\n";
            exit 1;
        }
        # merge from commit number
        if ($args[0] =~ /\d+/) {
            my $commit_path = $COMMIT."/".$args[0];
            if (-d $commit_path) {
                merge_commit($args[0], $args[2]);
            } else {
                print "legit.pl: error: unknown commit \'$args[0]\'\n";
                exit 1;
            }
        } else { # merge from branch
            my $branch_path = $BRANCH."/".$args[0];
            if (-f $branch_path) {
                merge_branch($args[0], $args[2]);
            } else {
                print "legit.pl: error: unknown branch \'$args[0]\'\n";
                exit 1;
            }
        }
    }
    else 
    {
        print "usage: legit.pl merge <branch|commit> -m message\n";
        exit 1;
    }
}



############################ Main Fucntion #############################
if (not @ARGV) 
{
    print $USAGE;
    exit 1;
}

# parse the arguments
my $command = shift @ARGV;
if ($command eq "init") {
    init();
    exit 0;
} else {
    if (not -e ".legit") {
        print "legit.pl: error: no .legit directory containing legit"
                ." repository exists\n";
        exit 1;
    }
}

if ($command eq "add") {
    add(@ARGV);
    exit 0;
} 

if ($command eq "commit") {
    legit_commit(@ARGV);
    exit 0;
} 


if ($command eq "log") {
    exit_if_no_commit();
    legit_log();
    exit 0;
} 

if ($command eq "show") {
    exit_if_no_commit();
    show(@ARGV);
    exit 0;
} 

if ($command eq "rm") {
    exit_if_no_commit();
    legit_rm(@ARGV);
    exit 0;
} 

if ($command eq "status") {
    exit_if_no_commit();
    legit_status();
    exit 0;
} 

if ($command eq "branch") {
    exit_if_no_commit();
    legit_branch(@ARGV);
    exit 0;
} 

if ($command eq "checkout") {
    exit_if_no_commit();
    checkout(@ARGV);
    exit 0;
} 

if ($command eq "merge") {
    exit_if_no_commit();
    legit_merge(@ARGV);
    exit 0;
}

# otherwise
print "legit.pl: error: unknown command $command\n";
print $USAGE;
exit 1;