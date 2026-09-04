mkdir -p rawFVFiles 
ln -sf `realpath ./exampleApplication/*.fvec` rawFVFiles/
mkdir  -p trainingSets
diploSHIC makeTrainingSets rawFVFiles/neut.msOut.gz.diploid.fvec rawFVFiles/soft \
rawFVFiles/hard 5 0,1,2,3,4,6,7,8,9,10 trainingSets/
