#Extracting rpm files

mkdir test
cd test
wget $source/$Package.rpm
rpm2cpio $package.rpm | cpio -idmv

