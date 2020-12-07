FROM centos
RUN yum update -y \
    && yum install sudo -y \
    && sudo yum install python36 wget gcc gcc-c++ make python3-devel llvm llvm-devel git-all tk-devel tcl-devel sqlite-devel gdbm-devel xz-devel readline-devel python3-tkinter net-tools firewalld -y \
    && wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz \
    && tar -xzf ta-lib-0.4.0-src.tar.gz \
    && cd ta-lib/ \
    && ./configure --prefix=/usr \
    && make \
    && sudo make install \
    && cd .. \
    && echo "empyrical==0.5.3" > req.txt \
    && echo "matplotlib==3.3.2" >> req.txt \
    && echo "pandas==1.0.5" >> req.txt \
    && echo "seaborn==0.9.0" >> req.txt \
    && echo "mplfinance==0.12.6a3" >> req.txt \
    && echo "abupy==0.4.0" >> req.txt \
    && echo "TA-Lib==0.4.17" >> req.txt \
    && echo "quantaxis==1.9.30" >> req.txt \
    && echo "peakutils==1.3.3" >> req.txt \
    && echo "ipywidgets==7.4.2" >> req.txt \
    && echo "bokeh==2.0.2" >> req.txt \
    && echo "toolz==0.10.0" >> req.txt \
    && echo "notebook" >> req.txt \
    && echo "jupyter_contrib_nbextensions" >> req.txt \
    && echo "yapf" >> req.txt \
    && pip3 install -r req.txt \
    && pip3 unstall pytdx -y \
    && pip3 install pytdx==1.72 \
    && pip3 install --upgrade git+https://github.com/GuQiangJS/gquant.git \
    && pip3 uninstall janus -y \
    && pip3 install janus==0.4.0 \
    && jupyter contrib nbextension install --user \
