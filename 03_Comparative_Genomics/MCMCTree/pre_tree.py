sIn="/data/projects/zwang/macropodus_compare/phylodates_morespp/raxml/raxmlfull/MCMCTree/rerooted.tre"
sOut="/data/projects/zwang/macropodus_compare/phylodates_morespp/raxml/raxmlfull/MCMCTree/withoutconstraints.tre"
n=0
with open(sIn,"r") as f1, open(sOut, "a+") as f2:
    list1 = f1.readlines()
    Otree = list1[0]
    Ntree = "".join([i for i in Otree if not i.isdigit()])
    Ntree = Ntree.replace(":", "")
    Ntree = Ntree.replace(" ", "")
    Ntree = Ntree.replace(".", "") #cleaned tree from phylodate
#    print(Ntree)
    for i in Ntree:
        if i == ",":
            n+=1
        else:
            pass
    n=n+1 #number of spp.
    n=str(n)
#    print(n)
#    print(n,"1\n"+Ntree.strip())
    f2.write(n+" 1\n"+Ntree.strip())
