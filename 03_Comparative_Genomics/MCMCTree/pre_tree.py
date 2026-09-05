# define input and output tree files
sIn = "/data/projects/zwang/macropodus_compare/phylodates_morespp/raxml/raxmlfull/MCMCTree/rerooted.tre"
sOut = "/data/projects/zwang/macropodus_compare/phylodates_morespp/raxml/raxmlfull/MCMCTree/withoutconstraints.tre"
n = 0

# read tree and clean formatting for mcmctree
with open(sIn, "r") as f1, open(sOut, "a+") as f2:
    list1 = f1.readlines()
    Otree = list1[0]
    
    # remove branch lengths and punctuation
    Ntree = "".join([i for i in Otree if not i.isdigit()])
    Ntree = Ntree.replace(":", "")
    Ntree = Ntree.replace(" ", "")
    Ntree = Ntree.replace(".", "")
    
    # count number of species
    for i in Ntree:
        if i == ",":
            n += 1
    n = n + 1 
    
    # write formatted tree to output
    f2.write(str(n) + " 1\n" + Ntree.strip())