# 说明

* 基于 [python3.7.3-slim](https://hub.docker.com/layers/python/library/python/3.7.3-slim/images/sha256-8baf9805da02f00e4e668ae96850107903c7201cad0350380bbbbbf38846f293) 构建的适用于 gquant 分析的python环境。其中`python`版本为`3.7.3`。启动后默认运行 `jupyter notebook`。

  > 此版本是基于 `debian`的`stretch`版本构建。构建时会自动将`/etc/apt/sources.list`修改为[清华大学的开源镜像](https://mirrors.tuna.tsinghua.edu.cn/help/debian/)。

# 构造时参数

* **mongodb_ip**: QUANTAXIS需要使用的MONGODB所在的IP。默认为127.0.0.1。
* **mongodb_port**：QUANTAXIS需要使用的MONGODB所在的Port。默认为27017。

```bash
$ docker build -t gquant -f . --build-arg mongodb_ip=1.2.3.4

$ docker run -it gquant /bin/bash
root@21612463eae6:/# cat /root/.quantaxis/setting/config.ini
[MONGODB]
uri = mongodb://1.2.3.4:27017
root@21612463eae6:/#
```
# 待处理

## 更新文件

每年需要更新交易日信息，该信息包含在`QUANTAXIS/QAUtil/QADate_trade.py`文件中。

如下示例表示

* -N 替换原有文件
* -P 指定下载目标目录，替换原本的`QADate_trade.py`
* -e 使用指定代理

`wget -N -P /usr/local/lib/python3.7/site-packages/QUANTAXIS/QAUtil/ https://raw.githubusercontent.com/QUANTAXIS/QUANTAXIS/master/QUANTAXIS/QAUtil/QADate_trade.py -e use_proxy=yes -e https_proxy=127.0.0.1:1080`
