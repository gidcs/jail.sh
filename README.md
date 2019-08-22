# jailed.sh

## how to use it

```
_dir="test"
./jail.sh -d ${_dir} \
    /bin/{ls,cat,echo,rm,bash,mv,touch} \
    /usr/bin/{vim,scp,sftp} \
    /etc/hosts
sudo chroot ${_dir}
```
