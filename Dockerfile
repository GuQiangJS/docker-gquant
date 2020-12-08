FROM centos:centos8.2.2004
RUN yum update -y \
    && yum install sudo -y
RUN sudo yum install wget gcc gcc-c++ make python3-devel llvm llvm-devel git-all tk-devel tcl-devel sqlite-devel gdbm-devel xz-devel readline-devel python3-tkinter net-tools firewalld -y
# && wget -O /etc/yum.repos.d/CentOS-Base.reop http://mirrors.aliyun.com/repo/Centos-8.repo \
# && yum makecache \
RUN sudo yum install python36 -y
RUN sudo wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz \
    && tar -xzf ta-lib-0.4.0-src.tar.gz \
    && cd ta-lib/ \
    && ./configure --prefix=/usr \
    && make \
    && sudo make install \
    && cd .. \
    && pip3 install TA-Lib==0.4.17 -i https://mirrors.aliyun.com/pypi/simple/
RUN echo "empyrical==0.5.3 " > req.txt \
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
    && pip3 install -r req.txt -i https://mirrors.aliyun.com/pypi/simple/ \
    # && rm -f req.txt \
    && pip3 uninstall pytdx -y \
    && pip3 install pytdx==1.72 -i https://mirrors.aliyun.com/pypi/simple/ \
    && pip3 install --upgrade git+https://github.com/GuQiangJS/gquant.git \
    && pip3 uninstall janus -y \
    && pip3 install janus==0.4.0 -i https://mirrors.aliyun.com/pypi/simple/

# 启用jupyter扩展
RUN jupyter contrib nbextension install --user

# #默认端口号
# ARG PORT="8888"
# #默认IP地址
# ARG IP="0.0.0.0"

# ARG AUTO-RUN-JUPYTER=false

# EXPOSE ${PORT} 

EXPOSE 8888

# RUN echo "echo \"首次运行import QUANTAXIS后，会生成config.ini文件（其中包含mongodb所在位置，默认为localhost:27017）。 \"" >start_notebook.sh \
#     && echo "可以通过`find / -name config.ini`命令查找。" >> start_notebook.sh \

# RUN echo "首次运行import QUANTAXIS后，会生成config.ini文件（其中包含mongodb所在位置，默认为localhost:27017）。 " > start_notebook.sh
# && echo "可以通过`find / -name config.ini`命令查找。" >> start_notebook.sh \
# && echo "找到以后使用`vi /root/.quantaxis/setting/config.ini`命令进行修改。" >> start_notebook.sh \

# RUN if $AUTO-RUN-JUPYTER; \
#     # && then echo "jupyter notebook --ip ${IP} --port ${PORT} --allow-root --no-browser" > /usr/local/bin/start_notebook.sh ; \
#     && then echo "abc">/usr/local/bin/start_notebook.sh ;\
#     # && else \
#     # && echo "" > start_notebook.sh ; \
#     && fi

# RUN if ${AUTO-RUN-JUPYTER}; then echo "then echo "jupyter notebook --ip ${IP} --port ${PORT} --allow-root --no-browser"">/usr/local/bin/start_notebook.sh;else echo "">/usr/local/bin/start_notebook.sh;fi

# RUN if $AUTO-RUN-JUPYTER; then echo "a" > abc ; else echo "b" > abc ; fi

# RUN chmod 777 /usr/local/bin/start_notebook.sh

# CMD /usr/local/bin/start_notebook.sh

# CMD ["jupyter", "notebook", "--port=${PORT}", "--no-browser", "--ip=${IP}"]