                      RDNMF
==================================================

This is the auxiliary code of RDNMF. The code is implemented in Matlab and tested in version 2011b.
You need to do the following in order to run:

1. Download datasets and put it into Folder Data\
   For convenience, we have already put ORL_32x32.mat in Data\
   
2. Run ORLtest.m
   The file ORLtest.m is a configuration file that assign the datasets and parameters.
   Important parameters:
        Rd : the size of discriminative part of dictionary
		Rt : the size of the dictionary that tolerate outliers
		alpha : the weight of the discriminative part
		beta : the weight of the robust part
		KNNK = the number of nearest neighbours in KNN classifier.
		ct : Final recognition rate is averaged over ct times. (To weaken the impact brought by random initialization.)
		
====================================================

Other main functions:

1. Main.m
   Main.m contains five methods (KNN, NMF, RNMF, DNMF, RDNMF). The implementation of other methods compared in our paper can be found refer to Section IV. B.
   
2. Imodel.m
   Main.m call Imodel.m for dictionary and codes retrieval.
   
3. DNMF.m and RDNMF.m
   the algorithm of DNMF and RDNMF, respectively.
 
   