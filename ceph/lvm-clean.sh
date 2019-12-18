LV=$(lvs | tail -1 | awk '{print $1}')
VG=$(lvs | tail -1 | awk '{print $2}')
PV=$(pvs | tail -1 | awk '{print $1}')
lvremove -f ${VG} ${LV}
vgremove -f ${VG}
pvremove -f ${PV}
