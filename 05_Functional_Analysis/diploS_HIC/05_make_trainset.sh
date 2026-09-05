# Create directory for raw feature vectors
mkdir -p rawFVFiles 

# Link all feature vector files to the raw folder
ln -sf $(realpath ./exampleApplication/*.fvec) rawFVFiles/

# Create directory for training sets
mkdir -p trainingSets

# Generate training datasets using diploSHIC
# Input neutral soft and hard sweep feature vectors
# 5 replicates for training 
# Specified indices for positions
# Output to training sets directory
diploSHIC makeTrainingSets rawFVFiles/neut.msOut.gz.diploid.fvec rawFVFiles/soft \
rawFVFiles/hard 5 0,1,2,3,4,6,7,8,9,10 trainingSets/