
# Resize Disk
```
lsblk

growpart /dev/nvme0n1 4


lvextend -l +50%FREE /dev/RootVG/rootVol 


lvextend -l +50%FREE /dev/RootVG/varVol

xfs_growfs /


xfs_growfs /var

```
