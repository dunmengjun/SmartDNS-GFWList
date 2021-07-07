# GFW List
curl -sS https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt | \
    base64 -d | sort -u | sed '/^$\|@@/d'| sed 's#!.\+##; s#|##g; s#@##g; s#http:\/\/##; s#https:\/\/##;' | \
    sed '/apple\.com/d; /sina\.cn/d; /sina\.com\.cn/d; /baidu\.com/d; /qq\.com/d' | \
    sed '/^[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+$/d' | grep '^[0-9a-zA-Z\.-]\+$' | \
    grep '\.' | sed 's#^\.\+##' | sort -u > /tmp/temp_gfwlist1

curl -sS https://raw.githubusercontent.com/hq450/fancyss/master/rules/gfwlist.conf | \
    sed 's/ipset=\/\.//g; s/\/gfwlist//g; /^server/d' > /tmp/temp_gfwlist2

curl -sS https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/gfw.txt > /tmp/temp_gfwlist3

curl -sS https://raw.githubusercontent.com/privacy-protection-tools/anti-AD/master/anti-ad-smartdns.conf | \
    sed '/activity.windows.com/d' > smartdns_anti_ad.conf

cat /tmp/temp_gfwlist1 /tmp/temp_gfwlist2 /tmp/temp_gfwlist3 default/extra.conf | \
    sort -u | sed 's/^\.*//g' > /tmp/temp_gfwlist

cat /tmp/temp_gfwlist | sed 's/^/\./g' > /tmp/smartdns_gfw_domain.conf

cat /tmp/smartdns_gfw_domain.conf | sed 's/^/ipset \//g' | sed 's/$/\/ss_spec_dst_fw/g' > smartdns_gfw_ipset.conf

sed -i 's/^/nameserver \//' /tmp/smartdns_gfw_domain.conf
sed -i 's/$/\/GFW/' /tmp/smartdns_gfw_domain.conf
cat default/gfw_group.conf /tmp/smartdns_gfw_domain.conf > smartdns_gfw_domain.conf
