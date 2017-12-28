FROM postgres:10.1
MAINTAINER Hiroyuki YAMASAKI <yamasakih@pharm.kitasato-u.ac.jp> 


RUN apt-get update && apt-get install -y \
 build-essential\
 python-numpy\
 cmake\
 python-dev\
 sqlite3\
 libsqlite3-dev\
 libboost-dev\
 libboost-system-dev\
 libboost-thread-dev\
 libboost-serialization-dev\
 libboost-python-dev\
 libboost-regex-dev\
 postgresql-client-10\
 postgresql-server-dev-10\
 postgresql-plpython-10\
 postgresql-plpython3-10\
 git

ENV RDKIT_BRANCH=master
RUN git clone -b $RDKIT_BRANCH --single-branch https://github.com/rdkit/rdkit.git

ENV RDBASE=/rdkit
ENV LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$RDBASE/lib:/usr/lib/x86_64-linux-gnu
ENV PYTHONPATH=$PYTHONPATH:$RDBASE

RUN mkdir $RDBASE/build
WORKDIR $RDBASE/build
RUN cmake -DRDK_BUILD_INCHI_SUPPORT=ON -DRDK_BUILD_PGSQL=ON -DPostgreSQL_ROOT=/usr/lib/postgresql/10 -DPostgreSQL_TYPE_INCLUDE_DIR=/usr/include/postgresql/10/server ..
RUN make
RUN make install
RUN sh Code/PgSQL/rdkit/pgsql_install.sh

WORKDIR $RDBASE
USER postgres

