FROM python:3.7.3-slim

# 来源https://mirrors.tuna.tsinghua.edu.cn/help/debian/。版本是stretch。
# Debian 的软件源配置文件是 /etc/apt/sources.list。
# 将系统自带的该文件做个备份，将该文件替换为下面内容，即可使用 TUNA 的软件源镜像。
# 如果遇到无法拉取 https 源的情况，请先使用 http 源并安装：
COPY source_debian_stretch.list /etc/apt/sources.list

# ENV PIP_INSTALL_ARG="--default-timeout=100 --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple"
ENV PIP_INSTALL_ARG="--default-timeout=100 --no-cache-dir -i https://mirrors.aliyun.com/pypi/simple"
# ENV PIP_INSTALL_ARG="--no-cache-dir"

# 更新系统必须的包
RUN apt update \
    && apt install -y sudo ca-certificates wget gcc make zlib1g zlib1g-dev libffi-dev \
    git python3-tk lighttpd xz-utils \
    && rm -rf /var/lib/apt/lists/*

# 安装talib依赖项
RUN wget http://prdownloads.sourceforge.net/ta-lib/ta-lib-0.4.0-src.tar.gz \
    && tar -xzf ta-lib-0.4.0-src.tar.gz \
    && cd ta-lib/ \
    && ./configure --prefix=/usr \
    && make \
    && sudo make install \
    && cd .. \
    && pip --version \
    && pip3 install --upgrade pip $PIP_INSTALL_ARG \
    && pip3 install TA-Lib==0.4.17 $PIP_INSTALL_ARG \
    && rm -r ta-lib \
    && rm ta-lib-0.4.0-src.tar.gz \
    && pip --version

# 安装python需要的包
RUN pip install numpy==1.16.2 $PIP_INSTALL_ARG \
    && pip install empyrical==0.5.3 $PIP_INSTALL_ARG \
    && pip install matplotlib==3.3.2 $PIP_INSTALL_ARG \
    && pip install seaborn==0.9.0 $PIP_INSTALL_ARG \
    && pip install mplfinance==0.12.6a3 $PIP_INSTALL_ARG \
    && pip install abupy==0.4.0 $PIP_INSTALL_ARG \
    && pip install TA-Lib==0.4.17 $PIP_INSTALL_ARG \
    && pip install peakutils==1.3.3 $PIP_INSTALL_ARG \
    && pip install ipywidgets==7.4.2 $PIP_INSTALL_ARG \
    && pip install bokeh==2.0.2 $PIP_INSTALL_ARG \
    && pip install toolz==0.10.0 $PIP_INSTALL_ARG \
    # && pip install notebook $PIP_INSTALL_ARG \
    # && pip install jupyter_contrib_nbextensions $PIP_INSTALL_ARG \
    # 1.9.32 版本才修复了财务数据无法导入数据库的问题 https://github.com/QUANTAXIS/QUANTAXIS/commit/d10012099c42de7e60b1712e633c8de0fa5cc43a#diff-89c4c4778cd00cb19c03289adeb742a625990e0a670acdc506bf40309f041ee5
    # 2020-08-31修复了580错误。但是没有发版，最接近版本为1.10.1 https://github.com/QUANTAXIS/QUANTAXIS/pull/1580
    && pip install quantaxis==1.10.1 $PIP_INSTALL_ARG \
    && pip install pandas==1.0.5 $PIP_INSTALL_ARG \
    && pip uninstall -y pytdx janus \
    && pip install pytdx==1.72 janus==0.4.0
# && pip install tabulate==0.8.3 xlrd==1.2.0 yapf openpyxl xlsxwriter $PIP_INSTALL_ARG \
# 启用jupyter扩展
# && jupyter contrib nbextension install --user \

RUN pip install flask-cors $PIP_INSTALL_ARG

RUN pip3 install --upgrade git+https://github.com/GuQiangJS/gquant.git --no-cache-dir

RUN pip3 install --upgrade git+https://github.com/GuQiangJS/abu.git --no-cache-dir


# # 配置matplotlib
# ENV matplotlibrc /usr/local/lib/python3.7/site-packages/matplotlib/mpl-data/matplotlibrc
# ENV mpl_path /usr/local/lib/python3.7/site-packages/matplotlib/mpl-data/

# # 复制黑体字体
# COPY simhei.ttf "$mpl_path"fonts/ttf/SimHei.ttf

# # 设置matplotlib-支持中文显示
# RUN sed -i 's/#font.family/font.family/' "$matplotlibrc" \
#     && sed -i 's/#font.sans-serif\s*:/font.sans-serif : SimHei, /' "$matplotlibrc" \
#     && sed -i 's/#axes.unicode_minus\s*:\s*True/axes.unicode_minus  : False/' "$matplotlibrc" 

# 设置QUANTAXIS连接MONGODB的字符串
ARG mongodb_ip="127.0.0.1"
ARG mongodb_port="27017"

ARG git_username=""
ARG git_pwd=""

# 克隆gquant-report到本地
RUN git config --global http.proxy http://172.16.2.146:1080 \
    && git config --global https.proxy https://172.16.2.146:1080 \
    && git clone https://${git_username}:${git_pwd}@github.com/guqiangjs/holding_tracking.git/

RUN mkdir /root/.quantaxis/setting/ -p \
    && touch /root/.quantaxis/setting/config.ini \
    && echo "[MONGODB]" > /root/.quantaxis/setting/config.ini \
    && echo "uri = mongodb://${mongodb_ip}:${mongodb_port}" >> /root/.quantaxis/setting/config.ini

# 设置时区
RUN cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime \
    && echo "Asia/Shangshai" > /etc/timezone

# 复制需要的数据，数据来源 https://github.com/bbfamily/abu/tree/master/abupy/RomDataBu
COPY stock_code_CN.csv /usr/local/lib/python3.7/site-packages/abupy/RomDataBu/stock_code_CN.csv

# FLASK服务端口5000
EXPOSE 5000
# 网站端口80
EXPOSE 80

# WORKDIR /holding_tracking/server

# 安装NodeJs
RUN wget https://cdn.npm.taobao.org/dist/node/v14.15.1/node-v14.15.1-linux-x64.tar.xz \
    && tar -xJvf node-v14.15.1-linux-x64.tar.xz

ENV PATH="/node-v14.15.1-linux-x64/bin:$PATH"

RUN . ~/.profile \
    && node -v \
    && npm version \
    && npx -v

WORKDIR /holding_tracking/client

RUN npm install > /dev/null

# 安装 angularjs，并且不提示是否提交试用数据
# https://github.com/angular/angular-cli/blob/master/docs/design/analytics.md
# https://stackoverflow.com/questions/56355499/stop-angular-cli-asking-for-collecting-analytics-when-i-use-ng-build/56360325
RUN npm install -g @angular/cli > /dev/null

RUN npm install @angular-devkit/core > /dev/null

RUN npm install ng-zorro-antd

RUN ng build --prod

# RUN sed -i 's/localhost:5000/172.16.2.146:5000/' dist/client/main.*.js

WORKDIR /

COPY /lighttpd.conf /lighttpd.conf

ENV FLASK_APP=/holding_tracking/server/hello.py

ADD start.sh /holding_tracking/server/start.sh

CMD ["/holding_tracking/server/start.sh"]
