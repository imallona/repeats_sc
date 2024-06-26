#!/bin/bash
##
## Software management till upgrading to conda
##
## 03 Feb 2020
## Izaskun Mallona
## GPLv3


mkdir -p ~/soft/python
cd $_
wget https://www.python.org/ftp/python/3.6.9/Python-3.6.9.tgz
tar xzvf Python-3.6.9.tgz
cd Python-3.6.9
./configure prefix=~/soft/python/Python-3.6.9
make prefix=~/soft/python/Python-3.6.9
make install prefix=~/soft/python/Python-3.6.9
## to ensure pip with that python
# ~/soft/python/Python-3.6.9/bin/python -m ensurepip --default-pip
~/soft/python/Python-3.6.9/bin/pip3 install virtualenv


mkdir -p ~/virtenvs
cd $_
~/soft/python/Python-3.6.9/bin/virtualenv snakemake
cd $_
source bin/activate
python --version
wget https://github.com/snakemake/snakemake/archive/v5.10.0.tar.gz
tar xzvf v5.10.0.tar.gz
cd snakemake-5.10.0
python setup.py install
deactivate


mkdir -p ~/soft/bowtie
cd $_
wget https://sourceforge.net/projects/bowtie-bio/files/bowtie/1.2.3/bowtie-src-x86_64.zip
unzip bowtie-src-x86_64.zip
cd bowtie-1.2.3
sudo apt-get install libtbb-dev
make ## --prefix='/home/imallona/soft/bowtie/bowtie-1.2.3'


mkdir -p ~/soft/star
cd $_
wget https://github.com/alexdobin/STAR/archive/2.7.3a.tar.gz
tar -xzf 2.7.3a.tar.gz
cd STAR-2.7.3a
cd source
make STAR


source ~/virtenvs/snakemake/bin/activate

sudo apt-get install libsqlite3-dev
pip3 install pysqlite3
pip3 install biopython.convert
biopython.convert -v
deactivate


mkdir -p ~/soft/subread
cd $_
wget https://sourceforge.net/projects/subread/files/subread-2.0.0/subread-2.0.0-source.tar.gz
tar xzvf subread-2.0.0-source.tar.gz
cd subread-2.0.0-source/src
make -f Makefile.Linux


# alevin (salmon): precompiled binaries
mkdir -p ~/soft/salmon
cd $_
wget https://github.com/COMBINE-lab/salmon/releases/download/v1.1.0/salmon-1.1.0_linux_x86_64.tar.gz
tar xzvf salmon-1.1.0_linux_x86_64.tar.gz
mv salmon-latest_linux_x86_64 salmon-1.1.0_linux_x86_64


# cellranger (precompiled) mind that registration/authentication is required
mkdir -p ~/soft/cellranger
cd $_
curl -o cellranger-3.1.0.tar.gz "http://cf.10xgenomics.com/releases/cell-exp/cellranger-3.1.0.tar.gz?Expires=[snip]=[snip]&Key-Pair-Id=[snip]"
tar xzvf cellranger-3.1.0.tar.gz


# bioawk for salmon
mkdir -p ~/soft
cd $_

git clone git://github.com/lh3/bioawk.git
cd bioawk

sudo apt-get install bison flex

make

## fastq-dump

mkdir ~/soft/sra-toools

cd $_
wget http://ftp-trace.ncbi.nlm.nih.gov/sra/sdk/2.10.4/sratoolkit.2.10.4-ubuntu64.tar.gz

tar xzvf sratoolkit.2.10.4-ubuntu64.tar.gz
cd sratoolkit.2.10.4-ubuntu64/bin

./vdb-config --interactive


## bedops
mkdir -p ~/soft/bedops

cd ~/soft/bedops
wget https://github.com/bedops/bedops/archive/v2.4.39.tar.gz

tar xzvf v2.4.39.tar.gz
cd bedops-2.4.39

make
make install


## salmon, including the chromium v1 binary

cd ~/soft/salmon

wget https://github.com/COMBINE-lab/salmon/archive/v1.2.1.tar.gz
tar xzvf v1.2.1.tar.gz
mv salmon-1.2.1  salmon-1.2.1_src
cd salmon-1.2.1_src

# mkdir build
# cd build
# cmake .. ## rather download the binaries later, and just do the chromium1 workaround here
#   workaround described at https://combine-lab.github.io/alevin-tutorial/2018/running-alevin/
#     (section 10x v1 Data)

cd scripts/v1_10x;
g++ -std=c++11 -O3 -I ../../include -o wrapper wrapper.cpp -lz

cd ~/soft/salmon
wget https://github.com/COMBINE-lab/salmon/releases/download/v1.2.1/salmon-1.2.1_linux_x86_64.tar.gz
tar xzvf salmon-1.2.1_linux_x86_64.tar.gz
mv salmon-latest_linux_x86_64 salmon-1.2.1

cd salmon-1.2.1/bin
ln -s ~/soft/salmon/salmon-1.2.1_src/scripts/v1_10x/run.sh run_v1_10x.sh
