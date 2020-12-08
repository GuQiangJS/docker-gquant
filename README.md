基于centos配置GQuant可用的Python环境。

运行方式：
```bash
# 默认启动jupyter notebook，并且可以通过localhost:8888访问。（不设置token）
docker run -it -p 8888:8888 镜像名称 jupyter notebook --ip 0.0.0.0 --allow-root --no-browser --NotebookApp.token=''
```